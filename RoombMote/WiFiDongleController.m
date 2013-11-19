//
//  WiFiDongleController.m
//  RoombMote
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import "WiFiDongleController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

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


#pragma mark - Connection

-(void)connectToWiFiDongle
{
	DLog(@"WiFiDongleController connectToWiFiDongle");
    
    if(!WiFiDongleConnected)
    {
        WiFiSocketIsOpen = NO;
        //search for connection to correct SSID every 5 seconds for a max of 2 minutes
        wifiSearchTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(searchForWiFiDongle) userInfo:nil repeats:YES];
        wifiTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:122 target:self selector:@selector(stopSearchingForWiFiDongle) userInfo:nil repeats:NO];
        [self searchForWiFiDongle];//check once in case we're already good to go
    }
}

-(void)connectToWiFiDongleSocket
{
	DLog(@"WiFiDongleController connectToWiFiDongleSocket");
    
    if(!WiFiSocketIsOpen)
    {
        wiSocket = [[LXSocket alloc] init];
        
        //open socket
        socketSearchTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(tryToOpenSocket) userInfo:nil repeats:YES];
        socketTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:62 target:self selector:@selector(stopTryingToOpenSocket) userInfo:nil repeats:NO];
        [self tryToOpenSocket];//check once in case we're already good to go
    }
}

-(void)disconnectFromWiFiDongle
{
    DLog(@"WiFiDongleController disconnectFromWiFiDongle");
    
    //stop timers
    [self stopTimer:wifiSearchTimer];
    [self stopTimer:wifiTimeoutTimer];
    [self stopTimer:socketSearchTimer];
    [self stopTimer:socketTimeoutTimer];
    
    //reset flags
    WiFiDongleConnected = NO;
    
    //close socket
    [self closeSocket];
}

-(void)searchForWiFiDongle
{
    DLog(@"WiFiDongleController searchForWiFiDongle");
    
    if([self checkForWiFiDongleSSID])
    {
        WiFiDongleConnected = YES;
        
        //stop searching for SSID
        [self stopTimer:wifiTimeoutTimer];
        [self stopSearchingForWiFiDongle];
    }
    else
        WiFiDongleConnected = NO;
}

-(BOOL)checkForWiFiDongleSSID
{
    DLog(@"WiFiDongleController checkForWiFiDongleSSID");
    
    BOOL connected = NO;
    NSString *ssid = @"";
    NSString *search1 = @"WiSnap";
    NSString *search2 = @"Wifly";
    NSString *search3 = @"LTC";
    
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs)
    {
        info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        if (info && [info count])
        {
            ssid = [info objectForKey:@"SSID"];
            if([ssid hasPrefix:search1] || [ssid hasPrefix:search2] || [ssid hasPrefix:search3])
            {
                connected = YES;
                break;
            }
        }
    }
    
    return connected;
}

-(void)stopSearchingForWiFiDongle
{
    DLog(@"WiFiDongleController stopSearchingForWiFiDongle");
    
    [self stopTimer:wifiSearchTimer];
    
    if(!WiFiDongleConnected)
    {
        [self disconnectFromWiFiDongle];
        [[self delegate] notConnectedToWiFiDongle];
    }
    else
    {
        [self connectToWiFiDongleSocket];
    }
}

-(void)tryToOpenSocket
{
    DLog(@"WiFiDongleController tryToOpenSocket");
    
    //open socket to wisnap module for API comms
    if ([wiSocket connect: @"169.254.1.1" port: 2000] == YES)
    {
        DLog(@"created socket");
        WiFiSocketIsOpen = YES;
        
        //stop trying to open socket
        [self stopTimer:socketTimeoutTimer];
        [self stopTryingToOpenSocket];
    }
    else
        WiFiSocketIsOpen = NO;
}

-(void)stopTryingToOpenSocket
{
    DLog(@"WiFiDongleController stopTryingToOpenSocket");
    
    [self stopTimer:socketSearchTimer];
    
    if(WiFiSocketIsOpen)
    {
        [self didOpenSocket];
    }
    else
    {
        [self cantOpenSocket];
    }
}

-(void)didOpenSocket
{
    DLog(@"WiFiDongleController didOpenSocket");
    
    //notify delegate
    [[self delegate] didInitializeWiFiSocket];
}

-(void)cantOpenSocket
{
    DLog(@"WiFiDongleController cantOpenSocket");
    
    [self disconnectFromWiFiDongle];
    
    //notify delegate
    [[self delegate] cantInitializeWiFiSocket];
}

-(void)closeSocket
{
    DLog(@"WiFiDongleController closeSocket");
    
    if(WiFiSocketIsOpen)
    {
        if(wiSocket != nil)
            [wiSocket close];
        wiSocket = nil;
        WiFiSocketIsOpen = NO;
    }
}

-(void)stopTimer:(NSTimer *)timer
{
	DLog(@"WiFiDongleController stopTimer");

    if(timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
}


#pragma mark - Reading/Writing

-(BOOL)sendData:(NSData *)data
{
	DLog(@"WiFiDongleController sendData");
    
    if(WiFiSocketIsOpen)
        return [wiSocket sendData:data];
    else
        return FALSE;
}

-(void*)readByte
{
	DLog(@"WiFiDongleController readByte");
    
    if(WiFiSocketIsOpen)
        return [wiSocket readByte];
    else
        return FALSE;
}


@end
