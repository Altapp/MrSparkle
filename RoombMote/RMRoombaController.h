//
//  RMRoombaController.h
//  RoombMote
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WiFiDongleController.h"

@protocol RMRoombaControllerDelegate <NSObject>
@optional
-(void)roombaControllerDidStart;
-(void)roombaControllerCantStart;
@end

@interface RMRoombaController : NSObject <WiFiDongleControllerDelegate>
{
	id <RMRoombaControllerDelegate> delegate;
    WiFiDongleController *wifiDongle;
}

@property (retain) id delegate;
@property (nonatomic, retain) WiFiDongleController *wifiDongle;

-(void)startRoombaController;
-(void)stopRoombaController;


@end
