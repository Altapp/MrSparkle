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

#define IS_NEGATIVE(x) (x<0)
#define IS_POSITIVE(x) (x>=0)


@interface RMViewController : UIViewController <RoombaControllerDelegate>
{
    IBOutlet UIView *joystickView;
    IBOutlet UIView *bumpView;
    IBOutlet UIView *searchingView;
    IBOutlet UIButton *searchingButton;
    IBOutlet UIButton *vacuumButton;
    IBOutlet UIImageView *batteryIcon;
    IBOutlet UIImageView *outerCircle;
    IBOutlet UIButton *innerCircle;
    IBOutlet UIButton *dockButton;
    IBOutlet UIButton *spotButton;
    IBOutlet UIButton *cleanButton;
    IBOutlet UIButton *maxButton;
    IBOutlet UIButton *stopButton;
}

@property (nonatomic, retain) IBOutlet UIView *joystickView;
@property (nonatomic, retain) IBOutlet UIView *bumpView;
@property (nonatomic, retain) IBOutlet UIView *searchingView;
@property (nonatomic, retain) IBOutlet UIButton *searchingButton;
@property (nonatomic, retain) IBOutlet UIButton *vacuumButton;
@property (nonatomic, retain) IBOutlet UIImageView *batteryIcon;
@property (nonatomic, retain) IBOutlet UIImageView *outerCircle;
@property (nonatomic, retain) IBOutlet UIButton *innerCircle;
@property (nonatomic, retain) IBOutlet UIButton *dockButton;
@property (nonatomic, retain) IBOutlet UIButton *spotButton;
@property (nonatomic, retain) IBOutlet UIButton *cleanButton;
@property (nonatomic, retain) IBOutlet UIButton *maxButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;

//Roomba Delegate Methods
-(void)roombaControllerDidStart;
-(void)roombaControllerCantStart;
-(void)roombaControllerDidStop;

//Buttons
-(IBAction)vacuumButtonAction:(UIButton *)button;
-(IBAction)searchButtonAction:(UIButton *)button;
-(IBAction)dockButtonAction:(UIButton *)button;
-(IBAction)spotButtonAction:(UIButton *)button;
-(IBAction)cleanButtonAction:(UIButton *)button;
-(IBAction)maxButtonAction:(UIButton *)button;
-(IBAction)stopButtonAction:(UIButton *)button;

//Drive Control
-(IBAction)joystickTouchDownAction:(UILongPressGestureRecognizer *)recognizer;
-(IBAction)joystickTouchUpAction:(id)sender;
-(void)moveJoystick:(CGPoint)newLocation;
-(void)sendDriveCommandWithTouchLocation:(CGPoint)touchLocation;
-(NSInteger)getDriveRadiusFromTouchLocation:(CGPoint)touchLocation;
-(NSInteger)getDriveVelocityFromTouchLocation:(CGPoint)touchLocation;
-(BOOL)isInStopZone:(CGFloat)axisPoint;
-(BOOL)isInMaxVelocityZone:(CGFloat)axisPoint;
-(BOOL)isInRotateZone:(CGFloat)axisPoint;

//Event Handling
-(void)handleRoombaBumbEvent;
-(void)handleRoombaBatteryPercent:(NSNotification *)note;


//Public Constants
typedef enum
{
    kTouchpadHalfSize = 125,
    kStopZoneHalfSize = 20,
    kSpinZoneStart = 130,
    kMaxVelocityZoneStart = 150
} TouchZones;

@end
