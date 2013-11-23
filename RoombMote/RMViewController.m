//
//  RMViewController.m
//  RoombMote
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import "RMViewController.h"

@interface RMViewController ()
{
    RMRoombaController *roombaController;
}

@property (nonatomic, retain) RMRoombaController *roombaController;

-(void)roombaControllerDidStart;
-(void)roombaControllerCantStart;
-(void)roombaControllerDidStop;
@end

@implementation RMViewController

@synthesize roombaController;
@synthesize statusLabel;
@synthesize vacuumButton;
@synthesize connectButton;
@synthesize driveControl;
@synthesize speedSlider;
@synthesize turnSlider;


- (void)viewDidLoad
{
	DLog(@"RMViewController viewDidLoad");
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGAffineTransform transformToVertical = CGAffineTransformMakeRotation(M_PI * 1.5);
    self.speedSlider.transform = transformToVertical;
    
    self.statusLabel.text = @"Not Connected.";
    
    roombaController = [[RMRoombaController alloc] init];
    [roombaController setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
	DLog(@"RMViewController didReceiveMemoryWarning");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - RMRoombaController Delegate Methods

-(void)roombaControllerDidStart
{
	DLog(@"RMViewController roombaControllerDidStart");
    
    self.statusLabel.text = @"Connected.";
}

-(void)roombaControllerCantStart
{
	DLog(@"RMViewController roombaControllerCantStart");
    
    self.statusLabel.text = @"Can't Connect.";
}

-(void)roombaControllerDidStop
{
	DLog(@"RMViewController roombaControllerDidStop");
    
    self.statusLabel.text = @"Not Connected.";
}

-(IBAction)connectButtonAction:(UIButton *)button
{
	DLog(@"RMViewController vacuumButtonAction");
    
    if([roombaController RoombaIsConnected])
    {
        [roombaController stopRoombaController];
        [button setTitle:@"Connect" forState:UIControlStateNormal];
    }
    else
    {
        [roombaController startRoombaController];
        [button setTitle:@"Disconnect" forState:UIControlStateNormal];
    }
}

-(IBAction)vacuumButtonAction:(UIButton *)button
{
	DLog(@"RMViewController vacuumButtonAction");
    
    if([roombaController RoombaIsConnected])
    {
        if([roombaController VacuumIsOn])
        {
            [roombaController sendVacuumOffCommand];
            [button setTitle:@"Start Vacuum" forState:UIControlStateNormal];
        }
        else
        {
            [roombaController sendVacuumOnCommand];
            [button setTitle:@"Stop Vacuum" forState:UIControlStateNormal];
        }
    }
}

-(IBAction)driveControlTouchDownAction:(UILongPressGestureRecognizer *)recognizer
{
	//DLog(@"RMViewController touchPadAction");

    CGPoint location = [recognizer locationInView:self.driveControl];
    [self sendDriveCommandWithTouchLocation:CGPointMake(-location.x+100, -location.y+100)];
}

-(IBAction)driveControlTouchUpAction:(id)sender
{
	DLog(@"RMViewController driveControlTouchUpAction");
    
    [self sendDriveCommandWithTouchLocation:CGPointMake(0, 0)];
}

-(IBAction)speedSliderChangedAction:(id)sender
{
	DLog(@"RMViewController speedSliderChangedAction");
    
    [self sendDriveCommandWithSliderValues];
}

-(IBAction)turnSliderChangedAction:(id)sender
{
	DLog(@"RMViewController turnSliderChangedAction");
    
    [self sendDriveCommandWithSliderValues];
}

-(IBAction)speedSliderLetGoAction:(id)sender
{
	DLog(@"RMViewController speedSliderLetGoAction");
    
    [self.speedSlider setValue:0 animated:NO];
    [self sendDriveCommandWithSliderValues];
    
}

-(IBAction)turnSliderLetGoAction:(id)sender
{
	DLog(@"RMViewController turnSliderLetGoAction");
    
    [self.turnSlider setValue:0 animated:NO];
    [self sendDriveCommandWithSliderValues];
}

-(void)sendDriveCommandWithTouchLocation:(CGPoint)touchLocation
{
	DLog(@"RMViewController sendDriveCommandWithSliderValues");
    
    if([roombaController RoombaIsConnected])
    {
        CGFloat velocity = 0;
        CGFloat radius = 0;
        
        if(touchLocation.x > -40 && touchLocation.x < 40)
            radius = [roombaController driveRadiusStraight];
        else if(touchLocation.x < -120)
            radius = -[roombaController driveRadiusRotate];
        else if(touchLocation.x > 120)
            radius = [roombaController driveRadiusRotate];
        else if(touchLocation.x > 0)
            radius = roundf([roombaController driveRadiusMax] * (1 - ((touchLocation.x - 40)/80)));
        else if(touchLocation.x < 0)
            radius = roundf([roombaController driveRadiusMax] * (-1 - ((touchLocation.x + 40)/80)));
        
        if(touchLocation.y > -40 && touchLocation.y < 40)
            velocity = [roombaController driveVelocityStopped];
        else if(touchLocation.y < -120)
            velocity = -[roombaController driveVelocityMax];
        else if(touchLocation.y > 120)
            velocity = [roombaController driveVelocityMax];
        else if(touchLocation.y > 0)
            velocity = roundf([roombaController driveVelocityMax] * ((touchLocation.y - 40)/80));
        else if(touchLocation.y < 0)
            velocity = roundf([roombaController driveVelocityMax] * ((touchLocation.y + 40)/80));
        
        [self setDPadImageFromVelocity:velocity radius:radius];
        
        //if pressing left or right, but not up or down, turn slowly in place
        if(velocity == [roombaController driveVelocityStopped] && radius != [roombaController driveRadiusStraight])
        {
            velocity = 200;
            
            if(radius < 0)
                radius = -1;
            else if(radius >= 0)
                radius = 1;
        }
        
        [roombaController sendDriveCommandwithVelocity:velocity radius:radius];
    }
}

-(void)sendDriveCommandWithSliderValues
{
	DLog(@"RMViewController sendDriveCommandWithSliderValues");
    
    if([roombaController RoombaIsConnected])
    {
        [roombaController sendDriveCommandwithVelocity:[self getVelocityFromSliderValue] radius:[self getRadiusFromSliderValue]];
    }
}

-(CGFloat)getVelocityFromSliderValue
{
    return self.speedSlider.value * [roombaController driveVelocityMax];
}

-(CGFloat)getRadiusFromSliderValue
{
    CGFloat radius = 0;
    
    if(self.turnSlider.value == 0)
        radius = [roombaController driveRadiusStraight]; //straight
    else if(self.turnSlider.value == -1)
        radius = [roombaController driveRadiusRotate]; //clockwise in place
    else if(self.turnSlider.value == 1)
        radius = -[roombaController driveRadiusRotate]; //counter-clockwise in place
    else if(self.turnSlider.value < 0)
        radius = roundf([roombaController driveRadiusMax] * (1 + self.turnSlider.value));
    else if(self.turnSlider.value > 0)
        radius = roundf([roombaController driveRadiusMax] * (-1 + self.turnSlider.value));
    
    return radius;
}

-(void)setDPadImageFromVelocity:(CGFloat)velocity radius:(CGFloat)radius
{
	DLog(@"RMViewController sendDriveCommandWithSliderValues");
    
    if(velocity == [roombaController driveVelocityStopped] && radius == [roombaController driveRadiusStraight])
        [self.driveControl setImage:[UIImage imageNamed:@"dpad-off.png"] forState:UIControlStateHighlighted];
    else if(velocity == [roombaController driveVelocityStopped] && radius != [roombaController driveRadiusStraight])
    {
        if(radius < 0)
            [self.driveControl setImage:[UIImage imageNamed:@"dpad-right.png"] forState:UIControlStateHighlighted];
        else if(radius >= 0)
            [self.driveControl setImage:[UIImage imageNamed:@"dpad-left.png"] forState:UIControlStateHighlighted];
    }
    else if(velocity > [roombaController driveVelocityStopped] && radius == [roombaController driveRadiusStraight])
        [self.driveControl setImage:[UIImage imageNamed:@"dpad-up.png"] forState:UIControlStateHighlighted];
    else if(velocity > [roombaController driveVelocityStopped] && radius != [roombaController driveRadiusStraight])
    {
        if(radius < 0)
            [self.driveControl setImage:[UIImage imageNamed:@"dpad-upright.png"] forState:UIControlStateHighlighted];
        else if(radius >= 0)
            [self.driveControl setImage:[UIImage imageNamed:@"dpad-upleft.png"] forState:UIControlStateHighlighted];
    }
    else if(velocity < [roombaController driveVelocityStopped] && radius == [roombaController driveRadiusStraight])
        [self.driveControl setImage:[UIImage imageNamed:@"dpad-down.png"] forState:UIControlStateHighlighted];
    else if(velocity < [roombaController driveVelocityStopped] && radius != [roombaController driveRadiusStraight])
    {
        if(radius < 0)
            [self.driveControl setImage:[UIImage imageNamed:@"dpad-downright.png"] forState:UIControlStateHighlighted];
        else if(radius >= 0)
            [self.driveControl setImage:[UIImage imageNamed:@"dpad-downleft.png"] forState:UIControlStateHighlighted];
    }
}

@end
