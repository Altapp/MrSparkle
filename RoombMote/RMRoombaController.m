//
//  RMRoombaController.m
//  RoombMote
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import "RMRoombaController.h"

@interface RMRoombaController ()
-(void)notConnectedToWiFiDongleNetwork;
-(void)lostConnectionToWiFiDongleNetwork;
-(void)cantInitializeWiFiDongleSocket;
-(void)didConnectToWiFiDongle;
@end


@implementation RMRoombaController

@synthesize delegate;
@synthesize wifiDongle;


#pragma mark - Initialization

- init;
{
	DLog(@"RMRoombaController init");
    
	//[super init];
    
	return self;
}


#pragma mark - Start/Stop RMRoombaController

-(void)startRoombaController
{
	DLog(@"RMRoombaController startRoombaController");
    
    wifiDongle = [[WiFiDongleController alloc] init];
    [wifiDongle connectToWiFiDongle];
}

-(void)stopRoombaController
{
	DLog(@"RMRoombaController stopRoombaController");
    
    [wifiDongle disconnectFromWiFiDongle];
}


#pragma mark - WiFiDongleController Delegate Methods

-(void)notConnectedToWiFiDongleNetwork
{
	DLog(@"RMRoombaController notConnectedToWiFiDongleNetwork");
    
}

-(void)lostConnectionToWiFiDongleNetwork
{
	DLog(@"RMRoombaController lostConnectionToWiFiDongleNetwork");
    
}

-(void)cantInitializeWiFiDongleSocket
{
	DLog(@"RMRoombaController cantInitializeWiFiDongleSocket");
    
}

-(void)didConnectToWiFiDongle
{
	DLog(@"RMRoombaController didConnectToWiFiDongle");
    
}

@end
