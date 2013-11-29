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
    
    CGFloat currentRoombaAngle;
}

@property (nonatomic, retain) RoombaController *roombaController;

@end

@implementation RMViewController

@synthesize roombaController;
@synthesize statusLabel;
@synthesize vacuumButton;
@synthesize connectButton;
@synthesize driveControl;
@synthesize roombaImage;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	DLog(@"RMViewController viewDidLoad");
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(appEnteredBackground) name: @"didEnterBackground" object: nil];
    
    [self.statusLabel setText:@"Not Connected."];
    
    roombaController = [[RoombaController alloc] init];
    [roombaController setDelegate:self];
    
    currentRoombaAngle = 0;
}

- (void)appEnteredBackground
{
	DLog(@"RMViewController appEnteredBackground");
    
    [roombaController stopRoombaController];
    [self.statusLabel setText:@"Not Connected."];
    [self.connectButton setTitle:@"Connect"];
}

- (void)didReceiveMemoryWarning
{
	DLog(@"RMViewController didReceiveMemoryWarning");
    
    [super didReceiveMemoryWarning];
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
    
    if([button.title isEqualToString:@"Disconnect"])
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
    
    if([roombaController.ControllerIsRunning boolValue])
    {
        if([roombaController.VacuumIsRunning boolValue])
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
    
    NSInteger radius = [self getDriveRadiusFromTouchLocation:touchLocation];
    NSInteger velocity = [self getDriveVelocityFromTouchLocation:touchLocation];
    
    [self setDPadImageFromTouchLocation:touchLocation];
    
    if([roombaController.ControllerIsRunning boolValue])
        [roombaController sendDriveCommandwithVelocity:velocity radius:radius];
}

-(NSInteger)getDriveRadiusFromTouchLocation:(CGPoint)touchLocation;
{
    NSInteger radius = 0;
    CGFloat factor = 0;
    CGFloat sign = 1;
    
    if(IS_NEGATIVE(touchLocation.x))
        sign = -1;
    
    if([self isInStopZone:touchLocation.x])
        radius = ROOMB_RADIUS_STRAIGT;
    else if([self isInRotateZone:touchLocation.x])
        radius = (NSInteger)(sign * ROOMB_RADIUS_SPIN);
    else
    {
        factor = (sign * 1) - ((touchLocation.x - (sign * STOP_ZONE_RADIUS))/(ROTATE_ZONE_STARTPOINT-STOP_ZONE_RADIUS));
        radius = (NSInteger)roundf(ROOMB_RADIUS_MAX * factor);
    }

    //if pressing left or right, but not up or down, turn slowly in place
    if([self isInStopZone:touchLocation.y] && ![self isInStopZone:touchLocation.x])
        radius = (NSInteger)(sign * ROOMB_RADIUS_SPIN);
    
    return radius;
}

-(NSInteger)getDriveVelocityFromTouchLocation:(CGPoint)touchLocation;
{
    NSInteger velocity = 0;
    CGFloat factor = 0;
    CGFloat sign = 1;
    
    if(IS_NEGATIVE(touchLocation.y))
        sign = -1;
    
    if([self isInStopZone:touchLocation.y])
        velocity = ROOMB_VELOCITY_STOPPED;
    else if([self isInMaxVelocityZone:touchLocation.y])
        velocity = (NSInteger)(sign * ROOMB_VELOCITY_MAX);
    else
    {
        factor = (touchLocation.y - (sign * STOP_ZONE_RADIUS))/(MAX_VELOCITY_ZONE_STARTPOINT-STOP_ZONE_RADIUS);
        velocity = (NSInteger)roundf(ROOMB_VELOCITY_MAX * factor);
    }
    
    //if pressing left or right, but not up or down, turn slowly in place
    if([self isInStopZone:touchLocation.y] && ![self isInStopZone:touchLocation.x])
        velocity = STATIONARY_SPIN_SPEEN;
    
    return velocity;
}

-(void)setDPadImageFromTouchLocation:(CGPoint)touchLocation
{
	//DLog(@"RMViewController setDPadImageFromTouchLocation");
    
    NSString *horizontalImageCode = @"";
    NSString *verticalImageCode = @"";
    
    if([self isInStopZone:touchLocation.x])
        horizontalImageCode = @"";
    else if(IS_NEGATIVE(touchLocation.x))
        horizontalImageCode = @"right";
    else
        horizontalImageCode = @"left";
    
    if([self isInStopZone:touchLocation.y])
        verticalImageCode = @"";
    else if(IS_NEGATIVE(touchLocation.y))
        verticalImageCode = @"down";
    else
        verticalImageCode = @"up";
    
    //no code set, so set "off" code
    if([horizontalImageCode isEqualToString:verticalImageCode])
    {
        verticalImageCode = @"off";
        horizontalImageCode = @"";
    }
    
    NSString *imageName = [NSString stringWithFormat:@"dpad-%@%@.png",verticalImageCode,horizontalImageCode];
    [self.driveControl setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
}

-(BOOL)isInStopZone:(CGFloat)axisPoint
{
    return (axisPoint > -STOP_ZONE_RADIUS && axisPoint < STOP_ZONE_RADIUS);
}

-(BOOL)isInMaxVelocityZone:(CGFloat)axisPoint
{
    return (axisPoint < -MAX_VELOCITY_ZONE_STARTPOINT || axisPoint > MAX_VELOCITY_ZONE_STARTPOINT);
}

-(BOOL)isInRotateZone:(CGFloat)axisPoint
{
    return (axisPoint < -ROTATE_ZONE_STARTPOINT || axisPoint > ROTATE_ZONE_STARTPOINT);
}

-(void)handleRoombaBumbEvent
{
	DLog(@"RMViewController handleRoombaBumbEvent");
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

-(void)handleRoombaMovementDistance:(NSNumber *)distanceMM angle:(NSNumber *)angleRadians
{
	DLog(@"RMViewController handleRoombaMovementDistance %f",[angleRadians floatValue]);
    
    currentRoombaAngle = currentRoombaAngle-[angleRadians floatValue];
    
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(currentRoombaAngle);
    self.roombaImage.transform = rotateTransform;
}

@end
