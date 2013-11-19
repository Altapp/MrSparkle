//
//  WiFiDongleController.m
//  RoombMote
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import "WiFiDongleController.h"
#import <SystemConfiguration/CaptiveNetwork.h>


@interface WiFiDongleController ()
{
    LXSocket *wiSocket;
    NSTimer *wifiSearchTimer;
    NSTimer *wifiTimeoutTimer;
    NSTimer *wifiPeriodicSearchTimer;
    NSTimer *socketSearchTimer;
    NSTimer *socketTimeoutTimer;
}

@property (nonatomic, retain) LXSocket *wiSocket;
@property (nonatomic, retain) NSTimer *wifiSearchTimer;
@property (nonatomic, retain) NSTimer *wifiTimeoutTimer;
@property (nonatomic, retain) NSTimer *wifiPeriodicSearchTimer;
@property (nonatomic, retain) NSTimer *socketSearchTimer;
@property (nonatomic, retain) NSTimer *socketTimeoutTimer;

-(void)connectToWiFiDongleSocket;
-(void)searchForWiFiDongleNetwork;
-(BOOL)checkForWiFiDongleSSID;
-(void)stopSearchingForWiFiDongleNetwork;
-(void)periodicWiFiDongleNetworkCheck;
-(void)tryToOpenSocket;
-(void)didOpenSocket;
-(void)cantOpenSocket;
-(void)stopTryingToOpenSocket;
-(void)closeSocket;
-(void)stopTimer:(NSTimer *)timer;
@end


@implementation WiFiDongleController


@synthesize delegate;
@synthesize wiSocket;
@synthesize wifiSearchTimer;
@synthesize wifiTimeoutTimer;
@synthesize wifiPeriodicSearchTimer;
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
        wifiSearchTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(searchForWiFiDongleNetwork) userInfo:nil repeats:YES];
        wifiTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:122 target:self selector:@selector(stopSearchingForWiFiDongleNetwork) userInfo:nil repeats:NO];
        [self stopSearchingForWiFiDongleNetwork];//check once in case we're already good to go
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
    [self stopTimer:wifiPeriodicSearchTimer];
    [self stopTimer:socketSearchTimer];
    [self stopTimer:socketTimeoutTimer];
    
    //reset flags
    WiFiDongleConnected = NO;
    
    //close socket
    [self closeSocket];
}

-(void)searchForWiFiDongleNetwork
{
    DLog(@"WiFiDongleController searchForWiFiDongleNetwork");
    
    if([self checkForWiFiDongleSSID])
    {
        WiFiDongleConnected = YES;
        
        //stop searching for SSID
        [self stopTimer:wifiTimeoutTimer];
        [self stopSearchingForWiFiDongleNetwork];
    }
    else
        WiFiDongleConnected = NO;
}

-(BOOL)checkForWiFiDongleSSID
{
    DLog(@"WiFiDongleController checkForWiFiDongleSSID");
    
    BOOL connected = NO;
    NSString *ssid = @"";
    
    //get current SSID from captive network info
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs)
    {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count])
        {
            ssid = [info objectForKey:@"SSID"];
            
            if([ssid hasPrefix:@"WiSnap"] || [ssid hasPrefix:@"Wifly"] || [ssid hasPrefix:@"LTC"])
            {
                connected = YES;
                break;
            }
        }
    }
    
    return connected;
}

-(void)stopSearchingForWiFiDongleNetwork
{
    DLog(@"WiFiDongleController stopSearchingForWiFiDongleNetwork");
    
    [self stopTimer:wifiSearchTimer];
    
    //not connected to WiFiDongle's Network
    if(WiFiDongleConnected)
    {
        //start trying to open socket
        [self connectToWiFiDongleSocket];
    }
    else //not connected to WiFiDongle's Network
    {
        //reset controller
        [self disconnectFromWiFiDongle];
        
        //notify delegate
        [[self delegate] notConnectedToWiFiDongleNetwork];
    }
}

-(void)periodicWiFiDongleNetworkCheck
{
    DLog(@"WiFiDongleController periodicWiFiDongleNetworkCheck");
    
    //no longer connected to correct network SSID
    if(![self checkForWiFiDongleSSID])
    {
        [self stopTimer:wifiPeriodicSearchTimer];
        
        //reset controller
        [self disconnectFromWiFiDongle];
        
        //notify delegate
        [[self delegate] lostConnectionToWiFiDongleNetwork];
    }
}

-(void)tryToOpenSocket
{
    DLog(@"WiFiDongleController tryToOpenSocket");
    
    //open socket to wisnap module for API comms
    if ([wiSocket connect: @"169.254.1.1" port: 2000] == YES)
    {
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
    
    //we are finished setting up dongle conneciton
    
    //notify delegate
    [[self delegate] didConnectToWiFiDongle];
    
    //start periodically confirming network connection
    wifiPeriodicSearchTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(periodicWiFiDongleNetworkCheck) userInfo:nil repeats:YES];
}

-(void)cantOpenSocket
{
    DLog(@"WiFiDongleController cantOpenSocket");
    
    //reset controller
    [self disconnectFromWiFiDongle];
    
    //notify delegate
    [[self delegate] cantInitializeWiFiDongleSocket];
}

-(void)closeSocket
{
    DLog(@"WiFiDongleController closeSocket");
    
    if(wiSocket != nil)
        [wiSocket close];
    wiSocket = nil;
    WiFiSocketIsOpen = NO;
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
