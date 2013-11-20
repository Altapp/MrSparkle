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
@required
-(void)roombaControllerDidStart;
-(void)roombaControllerCantStart;
-(void)roombaControllerDidStop;
@end

@interface RMRoombaController : NSObject <WiFiDongleControllerDelegate>
{
	id <RMRoombaControllerDelegate> delegate;
}

@property (retain) id delegate;

-(void)startRoombaController;
-(void)stopRoombaController;
-(BOOL)RoombaIsConnected;

-(BOOL)VacuumIsOn;
-(BOOL)toggleVacuumState;

@end
