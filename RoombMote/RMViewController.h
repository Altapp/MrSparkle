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
}

@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIButton *vacuumButton;

-(IBAction)buttonPressVacuum:(id)sender;

@end
