//
//  RMViewController.h
//  RoombMote
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMRoombaController.h"

@interface RMViewController : UIViewController <RMRoombaControllerDelegate>
{
    IBOutlet UILabel *statusLabel;
    IBOutlet UIButton *vacuumButton;
    IBOutlet UIButton *connectButton;
    IBOutlet UIButton *driveControl;
    IBOutlet UISlider *speedSlider;
    IBOutlet UISlider *turnSlider;
}

@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIButton *vacuumButton;
@property (nonatomic, retain) IBOutlet UIButton *connectButton;
@property (nonatomic, retain) IBOutlet UIButton *driveControl;
@property (nonatomic, retain) IBOutlet UISlider *speedSlider;
@property (nonatomic, retain) IBOutlet UISlider *turnSlider;

-(IBAction)connectButtonAction:(UIButton *)button;
-(IBAction)vacuumButtonAction:(UIButton *)button;
-(IBAction)driveControlTouchDownAction:(UILongPressGestureRecognizer *)recognizer;
-(IBAction)driveControlTouchUpAction:(id)sender;
-(IBAction)speedSliderChangedAction:(id)sender;
-(IBAction)turnSliderChangedAction:(id)sender;
-(IBAction)speedSliderLetGoAction:(id)sender;
-(IBAction)turnSliderLetGoAction:(id)sender;
-(CGFloat)getVelocityFromSliderValue;
-(CGFloat)getRadiusFromSliderValue;
-(void)sendDriveCommandWithTouchLocation:(CGPoint)touchLocation;
-(void)sendDriveCommandWithSliderValues;
-(void)setDPadImageFromVelocity:(CGFloat)velocity radius:(CGFloat)radius;

@end
