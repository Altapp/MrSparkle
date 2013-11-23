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


- (void)viewDidLoad
{
	DLog(@"RMViewController viewDidLoad");
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.statusLabel setText:@"Not Connected."];
    
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
    
    [self.statusLabel setText:@"Connected."];
}

-(void)roombaControllerCantStart
{
	DLog(@"RMViewController roombaControllerCantStart");
    
    [self.statusLabel setText:@"Can't Connect."];
}

-(void)roombaControllerDidStop
{
	DLog(@"RMViewController roombaControllerDidStop");
    
    [self.statusLabel setText:@"Not Connected."];
}

-(IBAction)connectButtonAction:(UIButton *)button
{
	DLog(@"RMViewController vacuumButtonAction");
    
    if([roombaController RoombaIsConnected])
    {
        [self.statusLabel setText:@"Not Connected."];
        [button setTitle:@"Connect" forState:UIControlStateNormal];
        [roombaController stopRoombaController];
    }
    else
    {
        [self.statusLabel setText:@"Connecting..."];
        [button setTitle:@"Disconnect" forState:UIControlStateNormal];
        [roombaController startRoombaController];
    }
}

-(IBAction)vacuumButtonAction:(UIButton *)button
{
	DLog(@"RMViewController vacuumButtonAction");
    
    if([roombaController RoombaIsConnected])
    {
        if([roombaController VacuumIsOn])
        {
            [button setTitle:@"Start Vacuum" forState:UIControlStateNormal];
            [roombaController sendVacuumOffCommand];
        }
        else
        {
            [button setTitle:@"Stop Vacuum" forState:UIControlStateNormal];
            [roombaController sendVacuumOnCommand];
        }
    }
}

-(IBAction)driveControlTouchDownAction:(UILongPressGestureRecognizer *)recognizer
{
	//DLog(@"RMViewController touchPadAction");

    CGPoint location = [recognizer locationInView:self.driveControl];
    [self sendDriveCommandWithTouchLocation:CGPointMake(-location.x+125, -location.y+125)];
}

-(IBAction)driveControlTouchUpAction:(id)sender
{
	DLog(@"RMViewController driveControlTouchUpAction");
    
    [self sendDriveCommandWithTouchLocation:CGPointMake(0, 0)];
}

-(void)sendDriveCommandWithTouchLocation:(CGPoint)touchLocation
{
	DLog(@"RMViewController sendDriveCommandWithTouchLocation");
    
    CGFloat velocity = 0;
    CGFloat radius = 0;
    
    if(touchLocation.x > -20 && touchLocation.x < 20)
        radius = [roombaController driveRadiusStraight];
    else if(touchLocation.x < -120)
        radius = -[roombaController driveRadiusRotate];
    else if(touchLocation.x > 120)
        radius = [roombaController driveRadiusRotate];
    else if(touchLocation.x > 0)
        radius = roundf([roombaController driveRadiusMax] * (1 - ((touchLocation.x - 20)/100)));
    else if(touchLocation.x < 0)
        radius = roundf([roombaController driveRadiusMax] * (-1 - ((touchLocation.x + 20)/100)));
    
    if(touchLocation.y > -20 && touchLocation.y < 20)
        velocity = [roombaController driveVelocityStopped];
    else if(touchLocation.y < -120)
        velocity = -[roombaController driveVelocityMax];
    else if(touchLocation.y > 120)
        velocity = [roombaController driveVelocityMax];
    else if(touchLocation.y > 0)
        velocity = roundf([roombaController driveVelocityMax] * ((touchLocation.y - 20)/100));
    else if(touchLocation.y < 0)
        velocity = roundf([roombaController driveVelocityMax] * ((touchLocation.y + 20)/100));
    
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
    
    if([roombaController RoombaIsConnected])
    {
        [roombaController sendDriveCommandwithVelocity:velocity radius:radius];
    }
}

-(void)setDPadImageFromVelocity:(CGFloat)velocity radius:(CGFloat)radius
{
	DLog(@"RMViewController setDPadImageFromVelocity");
    
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
