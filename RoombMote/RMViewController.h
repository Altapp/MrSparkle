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
}

@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIButton *vacuumButton;
@property (nonatomic, retain) IBOutlet UIButton *connectButton;
@property (nonatomic, retain) IBOutlet UIButton *driveControl;

-(IBAction)connectButtonAction:(UIButton *)button;
-(IBAction)vacuumButtonAction:(UIButton *)button;
-(IBAction)driveControlTouchDownAction:(UILongPressGestureRecognizer *)recognizer;
-(IBAction)driveControlTouchUpAction:(id)sender;
-(void)sendDriveCommandWithTouchLocation:(CGPoint)touchLocation;
-(void)setDPadImageFromVelocity:(CGFloat)velocity radius:(CGFloat)radius;

@end
