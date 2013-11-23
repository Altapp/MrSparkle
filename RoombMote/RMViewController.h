//
//  RMViewController.h
//  RoombMote
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoombaController.h"

@interface RMViewController : UIViewController <RoombaControllerDelegate>
{
    IBOutlet UILabel *statusLabel;
    IBOutlet UIBarButtonItem *vacuumButton;
    IBOutlet UIBarButtonItem *connectButton;
    IBOutlet UIButton *driveControl;
}

@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *vacuumButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *connectButton;
@property (nonatomic, retain) IBOutlet UIButton *driveControl;

-(IBAction)connectButtonAction:(UIBarButtonItem *)button;
-(IBAction)vacuumButtonAction:(UIBarButtonItem *)button;
-(IBAction)driveControlTouchDownAction:(UILongPressGestureRecognizer *)recognizer;
-(IBAction)driveControlTouchUpAction:(id)sender;
-(void)sendDriveCommandWithTouchLocation:(CGPoint)touchLocation;
-(void)setDPadImageFromVelocity:(CGFloat)velocity radius:(CGFloat)radius;

@end
