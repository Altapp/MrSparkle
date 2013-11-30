//
//  RMViewController.h
//  RoombMote
//
//  Copyright (c) 2013 Jess Latimer
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
    IBOutlet UIBarButtonItem *controlButton;
    IBOutlet UIButton *driveControl;
    IBOutlet UIImageView *roombaImage;
}

@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *vacuumButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *connectButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *controlButton;
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
-(IBAction)controlButtonAction:(UIBarButtonItem *)button;

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
