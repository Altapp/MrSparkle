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
    RMRoombaController *roombaController;
}

@property (nonatomic, retain) RMRoombaController *roombaController;

-(void)roombaControllerDidStart;
-(void)roombaControllerCantStart;

@end
