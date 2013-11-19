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
-(void)didInitializeWiFiSocket;
-(void)cantInitializeWiFiSocket;
-(void)notConnectedToWiFiDongle;
-(void)lostConnectionToWiFiDongle;
@end

@interface WiFiDongleController : NSObject
{
	id <WiFiDongleControllerDelegate> delegate;
    
    LXSocket *wiSocket;
    NSTimer *wifiSearchTimer;
    NSTimer *wifiTimeoutTimer;
    NSTimer *socketSearchTimer;
    NSTimer *socketTimeoutTimer;
}

@property (retain) id delegate;

@property (nonatomic, retain) LXSocket *wiSocket;
@property (nonatomic, retain) NSTimer *wifiSearchTimer;
@property (nonatomic, retain) NSTimer *wifiTimeoutTimer;
@property (nonatomic, retain) NSTimer *socketSearchTimer;
@property (nonatomic, retain) NSTimer *socketTimeoutTimer;

-(void)connectToWiFiDongle;
-(void)connectToWiFiDongleSocket;
-(void)disconnectFromWiFiDongle;

-(void)searchForWiFiDongle;
-(BOOL)checkForWiFiDongleSSID;
-(void)stopSearchingForWiFiDongle;

-(void)tryToOpenSocket;
-(void)didOpenSocket;
-(void)cantOpenSocket;
-(void)stopTryingToOpenSocket;
-(void)closeSocket;

-(void)stopTimer:(NSTimer *)timer;

-(BOOL)sendData:(NSData *)data;
-(void*)readByte;


@end
