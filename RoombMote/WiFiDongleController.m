//
//  WiFiDongleController.m
//  RoombMote
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import "WiFiDongleController.h"

@implementation WiFiDongleController


@synthesize delegate;
@synthesize wiSocket;
@synthesize wifiSearchTimer;
@synthesize wifiTimeoutTimer;
@synthesize socketSearchTimer;
@synthesize socketTimeoutTimer;


BOOL WiFiDongleConnected = NO;
BOOL WiFiSocketIsOpen = NO;




#pragma mark - Initialization
- init;
{
	DLog(@"WiFiDongleController init");
    
	//[super init];
    
	return self;
}


@end
