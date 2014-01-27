//
//  RMViewController.m
//  Mr. Sparkle
//
//  Copyright (c) 2013 Jess Latimer, Bruce Giovando
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  Except as contained in this notice, the name(s) of the above copyright holders
//  shall not be used in advertising or otherwise to promote the sale, use or
//  other dealings in this Software without prior written authorization.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "ViewController.h"

@interface ViewController ()
{
    RoombaController *roombaController;
    NSUInteger batteryLevel;
    NSTimer *bumpTimer;
}

@property (nonatomic, retain) RoombaController *roombaController;
@property (nonatomic, retain) NSTimer *bumpTimer;

-(void)connectToRoomba;
-(void)disconnectFromRoomba;
-(void)hideBumpView;
-(void)showBumpView;
-(void)showStopButtonHideOthers;
-(void)hideStopButtonShowOthers;
-(void)enableControlButtons;
-(void)disableControlButtons;
@end

@implementation ViewController

@synthesize roombaController;
@synthesize joystickView;
@synthesize bumpView;
@synthesize bumpTimer;
@synthesize searchingView;
@synthesize searchingButton;
@synthesize vacuumButton;
@synthesize batteryIcon;
@synthesize outerCircle;
@synthesize innerCircle;
@synthesize dockButton;
@synthesize spotButton;
@synthesize cleanButton;
@synthesize maxButton;
@synthesize stopButton;
@synthesize instructionsView;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectToRoomba)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectFromRoomba)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRoombaBatteryPercent:)
                                                 name:@"RoombaDidReturnBatteryPercentage"
                                               object:nil];
    
    
    roombaController = [[RoombaController alloc] init];
    [roombaController setDelegate:self];
    
    batteryLevel = 10;
}

- (void)connectToRoomba
{
	DLog(@"RMViewController appEnteredForeground");
    
    [self hideStopButtonShowOthers];
    [self disableControlButtons];
    [self.searchingButton setEnabled:NO];
    [self.searchingView setHidden:NO];
    [self.instructionsView setHidden:NO];
    [roombaController startRoombaController];
}

- (void)disconnectFromRoomba
{
	DLog(@"RMViewController appEnteredBackground");
    
    [roombaController stopRoombaController];
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
    [self.searchingButton setEnabled:NO];
    [self.searchingView setHidden:YES];
    [self.instructionsView setHidden:YES];
    [self enableControlButtons];
}

-(void)roombaControllerCantStart
{
	DLog(@"RMViewController roombaControllerCantStart");
    [self.searchingView setHidden:NO];
    [self.searchingButton setEnabled:YES];
}

-(void)roombaControllerDidStop
{
	DLog(@"RMViewController roombaControllerDidStop");
}

-(IBAction)vacuumButtonAction:(UIButton *)button
{
	DLog(@"RMViewController vacuumButtonAction");
    
    if([roombaController.ControllerIsRunning boolValue])
    {
        if([roombaController.VacuumIsRunning boolValue])
        {
            [button setSelected:NO];
            [roombaController sendVacuumOffCommand];
        }
        else
        {
            [button setSelected:YES];
            [roombaController sendVacuumOnCommand];
        }
    }
}

-(IBAction)searchButtonAction:(UIButton *)button
{
    [self connectToRoomba];
}

-(IBAction)dockButtonAction:(UIButton *)button
{
    [roombaController forceDockSeeking];
    [self showStopButtonHideOthers];
}

-(IBAction)spotButtonAction:(UIButton *)button
{
    [roombaController sendSpotCommand];
    [self showStopButtonHideOthers];
}

-(IBAction)cleanButtonAction:(UIButton *)button
{
    [roombaController sendCleanCommand];
    [self showStopButtonHideOthers];
}

-(IBAction)maxButtonAction:(UIButton *)button
{
    [roombaController sendMaxCommand];
    [self showStopButtonHideOthers];
}

-(IBAction)stopButtonAction:(UIButton *)button
{
    [roombaController returnToFullControlMode];
    [self hideStopButtonShowOthers];
}

-(void)showStopButtonHideOthers
{
    [self.dockButton setHidden:YES];
    [self.spotButton setHidden:YES];
    [self.cleanButton setHidden:YES];
    [self.maxButton setHidden:YES];
    [self disableControlButtons];
    
    [self.stopButton setEnabled:YES];
    [self.stopButton setHidden:NO];
}

-(void)hideStopButtonShowOthers
{
    [self.dockButton setHidden:NO];
    [self.spotButton setHidden:NO];
    [self.cleanButton setHidden:NO];
    [self.maxButton setHidden:NO];
    [self enableControlButtons];
    
    [self.stopButton setEnabled:NO];
    [self.stopButton setHidden:YES];
}

-(void)enableControlButtons
{
    [self.dockButton setEnabled:YES];
    [self.spotButton setEnabled:YES];
    [self.cleanButton setEnabled:YES];
    [self.maxButton setEnabled:YES];
}

-(void)disableControlButtons
{
    [self.dockButton setEnabled:NO];
    [self.spotButton setEnabled:NO];
    [self.cleanButton setEnabled:NO];
    [self.maxButton setEnabled:NO];
}

-(IBAction)joystickTouchDownAction:(UILongPressGestureRecognizer *)recognizer
{
	//DLog(@"RMViewController joystickTouchDownAction");
    
    CGPoint jslocation = [recognizer locationInView:self.joystickView];
    CGPoint drivelocation = [recognizer locationInView:self.outerCircle];
    CGPoint drivelocationTransposedToCenterOrigin = CGPointMake(-drivelocation.x+kTouchpadHalfSize, -drivelocation.y+kTouchpadHalfSize);
    
    [self moveJoystick:jslocation];
    [self sendDriveCommandWithTouchLocation:drivelocationTransposedToCenterOrigin];
}

-(IBAction)joystickTouchUpAction:(id)sender
{
	DLog(@"RMViewController joystickTouchUpAction");
    
    CGPoint joystickStoppedPosition = CGPointMake(self.outerCircle.center.x, self.outerCircle.center.y);
    
    
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
           self.innerCircle.center = joystickStoppedPosition;
    } completion:NULL];
    
    
    [self sendDriveCommandWithTouchLocation:CGPointMake(0, 0)];
}

-(void)moveJoystick:(CGPoint)newLocation
{
    CGFloat differenceX;
    CGFloat differenceY;
    CGFloat outerCircleOriginX = self.outerCircle.center.x;
    CGFloat outerCircleOriginY = self.outerCircle.center.y;
    
    if(outerCircleOriginX >= newLocation.x)
        differenceX = outerCircleOriginX - newLocation.x;
    else
        differenceX = newLocation.x - outerCircleOriginX;
    
    if(outerCircleOriginY >= newLocation.y)
        differenceY = outerCircleOriginY - newLocation.y;
    else
        differenceY = newLocation.y - outerCircleOriginY;
    
    if(hypotf(differenceX, differenceY) > 110)
    {
        CGFloat angle = atanf(differenceY/differenceX);
        
        if(outerCircleOriginX >= newLocation.x)
            newLocation.x = outerCircleOriginX - 110 * cosf(angle);
        else
            newLocation.x = outerCircleOriginX + 110 * cosf(angle);
        
        if(outerCircleOriginY >= newLocation.y)
            newLocation.y = outerCircleOriginY - 110 * sinf(angle);
        else
            newLocation.y = outerCircleOriginY + 110 * sinf(angle);
    }
    
    self.innerCircle.center = newLocation;
}

-(void)sendDriveCommandWithTouchLocation:(CGPoint)touchLocation
{
	DLog(@"RMViewController sendDriveCommandWithTouchLocation");
    
    NSInteger radius = [self getDriveRadiusFromTouchLocation:touchLocation];
    NSInteger velocity = [self getDriveVelocityFromTouchLocation:touchLocation];
    
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
        radius = kStraightRadius;
    else if([self isInRotateZone:touchLocation.x])
        radius = (NSInteger)(sign * kSpinRadius);
    else
    {
        factor = (sign * 1) - ((touchLocation.x - (sign * kStopZoneHalfSize))/(kSpinZoneStart-kStopZoneHalfSize));
        radius = (NSInteger)roundf(kMaxRadius * factor);
    }

    //if pressing left or right, but not up or down, turn slowly in place
    if([self isInStopZone:touchLocation.y] && ![self isInStopZone:touchLocation.x])
        radius = (NSInteger)(sign * kSpinRadius);
    
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
        velocity = kStopVelocity;
    else if([self isInMaxVelocityZone:touchLocation.y])
        velocity = (NSInteger)(sign * kMaxVelocity);
    else
    {
        factor = (touchLocation.y - (sign * kStopZoneHalfSize))/(kMaxVelocityZoneStart-kStopZoneHalfSize);
        velocity = (NSInteger)roundf(kMaxVelocity * factor);
    }
    
    //if pressing left or right, but not up or down, turn slowly in place
    if([self isInStopZone:touchLocation.y] && ![self isInStopZone:touchLocation.x])
        velocity = kSpinVelocity;
    
    return velocity;
}

-(BOOL)isInStopZone:(CGFloat)axisPoint
{
    return (axisPoint > -kStopZoneHalfSize && axisPoint < kStopZoneHalfSize);
}

-(BOOL)isInMaxVelocityZone:(CGFloat)axisPoint
{
    return (axisPoint < -kMaxVelocityZoneStart || axisPoint > kMaxVelocityZoneStart);
}

-(BOOL)isInRotateZone:(CGFloat)axisPoint
{
    return (axisPoint < -kSpinZoneStart || axisPoint > kSpinZoneStart);
}

-(void)handleRoombaBumbEvent
{
	DLog(@"RMViewController handleRoombaBumbEvent");
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    [self showBumpView];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(hideBumpView) userInfo:nil repeats:NO];
}

-(void)hideBumpView
{
    if(![bumpTimer isValid])
        [self.bumpView setHidden:YES];
}

-(void)showBumpView
{
    [self.bumpView setHidden:NO];
}


-(void)handleRoombaBatteryPercent:(NSNotification *)note
{
	DLog(@"RMViewController handleRoombaBatteryPercent");

    NSUInteger level = [[[note userInfo] objectForKey:@"battPercent"] unsignedIntegerValue] / 10;
    
    if(batteryLevel != level)
    {
        batteryLevel = level;
        if(batteryLevel == 0)
            batteryLevel = 1;
        
        NSString *imageName = [NSString stringWithFormat:@"Battery_%u_.png",batteryLevel];
        [self.batteryIcon setImage:[UIImage imageNamed:imageName]];
    }
}

@end
