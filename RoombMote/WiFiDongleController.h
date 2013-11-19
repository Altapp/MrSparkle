//
//  WiFiDongleController.h
//  RoombMote
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXSocket.h"


@protocol WiFiDongleControllerDelegate <NSObject>
@required
-(void)notConnectedToWiFiDongleNetwork;
-(void)lostConnectionToWiFiDongleNetwork;
-(void)cantInitializeWiFiDongleSocket;
-(void)didConnectToWiFiDongle;
@end

@interface WiFiDongleController : NSObject
{
	id <WiFiDongleControllerDelegate> delegate;
}

@property (retain) id delegate;

-(void)connectToWiFiDongle;
-(void)disconnectFromWiFiDongle;
-(BOOL)sendData:(NSData *)data;
-(void*)readByte;

@end
