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
    RoombaController *roombaController;
}

@property (nonatomic, retain) RoombaController *roombaController;

-(void)roombaControllerDidStart;
-(void)roombaControllerCantStart;
-(void)roombaControllerDidStop;
-(CGFloat)getDriveRadiusFromTouchX:(CGFloat)touchX;
-(CGFloat)getDriveVelocityFromTouchY:(CGFloat)touchY;
-(void)setDPadTouchImage:(NSString *)imageName;
-(BOOL)isNegative:(CGFloat)number;
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
    
    roombaController = [[RoombaController alloc] init];
    [roombaController setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
	DLog(@"RMViewController didReceiveMemoryWarning");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - RoombaController Delegate Methods

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

-(IBAction)connectButtonAction:(UIBarButtonItem *)button
{
	DLog(@"RMViewController vacuumButtonAction");
    
    if([roombaController RoombaIsConnected])
    {
        [self.statusLabel setText:@"Not Connected."];
        [button setTitle:@"Connect"];
        [roombaController stopRoombaController];
    }
    else
    {
        [self.statusLabel setText:@"Connecting..."];
        [button setTitle:@"Disconnect"];
        [roombaController startRoombaController];
    }
}

-(IBAction)vacuumButtonAction:(UIBarButtonItem *)button
{
	DLog(@"RMViewController vacuumButtonAction");
    
    if([roombaController RoombaIsConnected])
    {
        if([roombaController VacuumIsOn])
        {
            [button setTitle:@"Start Vacuum"];
            [roombaController sendVacuumOffCommand];
        }
        else
        {
            [button setTitle:@"Stop Vacuum"];
            [roombaController sendVacuumOnCommand];
        }
    }
}

-(IBAction)driveControlTouchDownAction:(UILongPressGestureRecognizer *)recognizer
{
	//DLog(@"RMViewController touchPadAction");

    CGPoint location = [recognizer locationInView:self.driveControl];
    CGPoint locationTransposedToCenterOrigin = CGPointMake(-location.x+TOUCHPAD_HALFSIZE, -location.y+TOUCHPAD_HALFSIZE);
    
    [self sendDriveCommandWithTouchLocation:locationTransposedToCenterOrigin];
}

-(IBAction)driveControlTouchUpAction:(id)sender
{
	DLog(@"RMViewController driveControlTouchUpAction");
    
    CGPoint driveControlStoppedPosition = CGPointMake(0, 0);
    [self sendDriveCommandWithTouchLocation:driveControlStoppedPosition];
}

-(void)sendDriveCommandWithTouchLocation:(CGPoint)touchLocation
{
	DLog(@"RMViewController sendDriveCommandWithTouchLocation");
    
    CGFloat radius = [self getDriveRadiusFromTouchX:touchLocation.x];
    CGFloat velocity = [self getDriveVelocityFromTouchY:touchLocation.y];
    
    [self setDPadImageFromVelocity:velocity radius:radius];
    
    //if pressing left or right, but not up or down, turn slowly in place
    if(velocity == ROOMB_VELOCITY_STOPPED && radius != ROOMB_RADIUS_STRAIGT)
    {
        velocity = STATIONARY_SPIN_SPEEN;
        
        if([self isNegative:radius])
            radius = -ROOMB_RADIUS_SPIN;
        else
            radius = ROOMB_RADIUS_SPIN;
    }
    
    if([roombaController RoombaIsConnected])
    {
        [roombaController sendDriveCommandwithVelocity:velocity radius:radius];
    }
}

-(CGFloat)getDriveRadiusFromTouchX:(CGFloat)touchX
{
    CGFloat radius = 0;
    CGFloat factor = 0;
    
    if(touchX > -STOP_ZONE_RADIUS && touchX < STOP_ZONE_RADIUS)
        radius = ROOMB_RADIUS_STRAIGT;
    else if(touchX < -ROTATE_ZONE_STARTPOINT)
        radius = -ROOMB_RADIUS_SPIN;
    else if(touchX > ROTATE_ZONE_STARTPOINT)
        radius = ROOMB_RADIUS_SPIN;
    else if(touchX > TOUCHPAD_ORIGIN)
    {
        factor = 1 - ((touchX - STOP_ZONE_RADIUS)/(ROTATE_ZONE_STARTPOINT-STOP_ZONE_RADIUS));
        radius = roundf(ROOMB_RADIUS_MAX * factor);
    }
    else if(touchX < TOUCHPAD_ORIGIN)
    {
        factor = -1 - ((touchX + STOP_ZONE_RADIUS)/(ROTATE_ZONE_STARTPOINT-STOP_ZONE_RADIUS));
        radius = roundf(ROOMB_RADIUS_MAX * factor);
    }
    
    return radius;
}

-(CGFloat)getDriveVelocityFromTouchY:(CGFloat)touchY
{
    CGFloat velocity = 0;
    CGFloat factor = 0;
    
    if(touchY > -STOP_ZONE_RADIUS && touchY < STOP_ZONE_RADIUS)
        velocity = ROOMB_VELOCITY_STOPPED;
    else if(touchY < -ROTATE_ZONE_STARTPOINT)
        velocity = -ROOMB_VELOCITY_MAX;
    else if(touchY > ROTATE_ZONE_STARTPOINT)
        velocity = ROOMB_VELOCITY_MAX;
    else if(touchY > TOUCHPAD_ORIGIN)
    {
        factor = (touchY - STOP_ZONE_RADIUS)/(ROTATE_ZONE_STARTPOINT-STOP_ZONE_RADIUS);
        velocity = roundf(ROOMB_VELOCITY_MAX * factor);
    }
    else if(touchY < TOUCHPAD_ORIGIN)
    {
        factor = (touchY + STOP_ZONE_RADIUS)/(ROTATE_ZONE_STARTPOINT-STOP_ZONE_RADIUS);
        velocity = roundf(ROOMB_VELOCITY_MAX * factor);
    }
    
    return velocity;
}

-(void)setDPadImageFromVelocity:(CGFloat)velocity radius:(CGFloat)radius
{
	DLog(@"RMViewController setDPadImageFromVelocity");
    
    if(velocity == ROOMB_VELOCITY_STOPPED && radius == ROOMB_RADIUS_STRAIGT)
        [self setDPadTouchImage:@"dpad-off.png"];
    else if(velocity == ROOMB_VELOCITY_STOPPED && radius != ROOMB_RADIUS_STRAIGT)
    {
        if([self isNegative:radius])
            [self setDPadTouchImage:@"dpad-right.png"];
        else
            [self setDPadTouchImage:@"dpad-left.png"];
    }
    else if(velocity > ROOMB_VELOCITY_STOPPED && radius == ROOMB_RADIUS_STRAIGT)
        [self setDPadTouchImage:@"dpad-up.png"];
    else if(velocity > ROOMB_VELOCITY_STOPPED && radius != ROOMB_RADIUS_STRAIGT)
    {
        if([self isNegative:radius])
            [self setDPadTouchImage:@"dpad-upright.png"];
        else
            [self setDPadTouchImage:@"dpad-upleft.png"];
    }
    else if(velocity < ROOMB_VELOCITY_STOPPED && radius == ROOMB_RADIUS_STRAIGT)
        [self setDPadTouchImage:@"dpad-down.png"];
    else if(velocity < ROOMB_VELOCITY_STOPPED && radius != ROOMB_RADIUS_STRAIGT)
    {
        if([self isNegative:radius])
            [self setDPadTouchImage:@"dpad-downright.png"];
        else
            [self setDPadTouchImage:@"dpad-downleft.png"];
    }
}

-(void)setDPadTouchImage:(NSString *)imageName
{
    [self.driveControl setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
}

-(BOOL)isNegative:(CGFloat)number
{
    return number < 0;
}
@end
