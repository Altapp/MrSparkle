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
@optional
-(void)notConnectedToWiFiDongleNetwork;
-(void)lostConnectionToWiFiDongleNetwork;
-(void)cantInitializeWiFiDongleSocket;
-(void)didConnectToWiFiDongle;
@end

@interface WiFiDongleController : NSObject
{
	id <WiFiDongleControllerDelegate> delegate;
    LXSocket *wiSocket;
    NSTimer *wifiSearchTimer;
    NSTimer *wifiTimeoutTimer;
    NSTimer *wifiPeriodicSearchTimer;
    NSTimer *socketSearchTimer;
    NSTimer *socketTimeoutTimer;
}

@property (retain) id delegate;
@property (nonatomic, retain) LXSocket *wiSocket;
@property (nonatomic, retain) NSTimer *wifiSearchTimer;
@property (nonatomic, retain) NSTimer *wifiTimeoutTimer;
@property (nonatomic, retain) NSTimer *wifiPeriodicSearchTimer;
@property (nonatomic, retain) NSTimer *socketSearchTimer;
@property (nonatomic, retain) NSTimer *socketTimeoutTimer;

-(void)connectToWiFiDongle;
-(void)disconnectFromWiFiDongle;

-(BOOL)sendData:(NSData *)data;
-(void*)readByte;

@end
