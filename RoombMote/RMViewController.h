//
//  RMViewController.h
//  RoombMote
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "RoombaController.h"


#define TOUCHPAD_HALFSIZE 125
#define STOP_ZONE_RADIUS 20
#define ROTATE_ZONE_STARTPOINT 130
#define MAX_VELOCITY_ZONE_STARTPOINT 150
#define STATIONARY_SPIN_SPEEN 200

#define IS_NEGATIVE(x) (x<0)
#define IS_POSITIVE(x) (x>=0)


@interface RMViewController : UIViewController <RoombaControllerDelegate>
{
    IBOutlet UILabel *statusLabel;
    IBOutlet UIBarButtonItem *vacuumButton;
    IBOutlet UIBarButtonItem *connectButton;
    IBOutlet UIButton *driveControl;
    IBOutlet UIImageView *roombaImage;
}

@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *vacuumButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *connectButton;
@property (nonatomic, retain) IBOutlet UIButton *driveControl;
@property (nonatomic, retain) IBOutlet UIImageView *roombaImage;

-(void)appEnteredBackground;

//Roomba Delegate Methods
-(void)roombaControllerDidStart;
-(void)roombaControllerCantStart;
-(void)roombaControllerDidStop;

//Buttons
-(IBAction)connectButtonAction:(UIBarButtonItem *)button;
-(IBAction)vacuumButtonAction:(UIBarButtonItem *)button;

//Drive Control
-(IBAction)driveControlTouchDownAction:(UILongPressGestureRecognizer *)recognizer;
-(IBAction)driveControlTouchUpAction:(id)sender;
-(void)sendDriveCommandWithTouchLocation:(CGPoint)touchLocation;
-(NSInteger)getDriveRadiusFromTouchLocation:(CGPoint)touchLocation;
-(NSInteger)getDriveVelocityFromTouchLocation:(CGPoint)touchLocation;
-(void)setDPadImageFromTouchLocation:(CGPoint)touchLocation;
-(BOOL)isInStopZone:(CGFloat)axisPoint;
-(BOOL)isInMaxVelocityZone:(CGFloat)axisPoint;
-(BOOL)isInRotateZone:(CGFloat)axisPoint;

//Event Handling
-(void)handleRoombaBumbEvent;
-(void)handleRoombaMovementDistance:(NSNumber *)distanceMM angle:(NSNumber *)angleRadians;

@end
