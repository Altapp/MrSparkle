//
//  RMRoombaController.m
//  RoombMote
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import "RMRoombaController.h"

@interface RMRoombaController ()
{
    NSMutableArray *SendBuffer;
    WiFiDongleController *wifiDongle;
}

@property (nonatomic, retain) NSMutableArray *SendBuffer;
@property (nonatomic, retain) WiFiDongleController *wifiDongle;

-(void)killRoombaController;
-(void)notConnectedToWiFiDongleNetwork;
-(void)lostConnectionToWiFiDongleNetwork;
-(void)cantInitializeWiFiDongleSocket;
-(void)didConnectToWiFiDongle;
-(void)RoombaControlScheduler;
-(void)RoombaDataReceiver:(WiFiDongleController *)connectedDongle;
-(void)processDataReceviedFromRoomba:(NSMutableData *)receivedData;
@end


@implementation RMRoombaController

@synthesize delegate;
@synthesize wifiDongle;
@synthesize SendBuffer;

BOOL RunController = NO;
BOOL VacuumIsRunning = NO;

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
    
    SendBuffer = [[NSMutableArray alloc] init];
    wifiDongle = [[WiFiDongleController alloc] init];
    
    [wifiDongle connectToWiFiDongle];
}

-(void)stopRoombaController
{
	DLog(@"RMRoombaController stopRoombaController");
    
    //start the process of stopping, but we can't actually kill
    //here because we could cause probslems in other threads
    RunController = NO;
}

-(void)killRoombaController
{
	DLog(@"RMRoombaController killRoombaController");
    
    [wifiDongle disconnectFromWiFiDongle];
    wifiDongle = nil;
    
    [SendBuffer removeAllObjects];
    SendBuffer = nil;
    
    [[self delegate] roombaControllerDidStop];
}

-(BOOL)RoombaIsConnected
{
    return RunController;
}


#pragma mark - WiFiDongleController Delegate Methods

-(void)notConnectedToWiFiDongleNetwork
{
	DLog(@"RMRoombaController notConnectedToWiFiDongleNetwork");
    
    [[self delegate] roombaControllerCantStart];
}

-(void)lostConnectionToWiFiDongleNetwork
{
	DLog(@"RMRoombaController lostConnectionToWiFiDongleNetwork");
    
    [self stopRoombaController];
}

-(void)cantInitializeWiFiDongleSocket
{
	DLog(@"RMRoombaController cantInitializeWiFiDongleSocket");
    
    [[self delegate] roombaControllerCantStart];
}

-(void)didConnectToWiFiDongle
{
	DLog(@"RMRoombaController didConnectToWiFiDongle");
    
    RunController = YES;
    
    //start new thread to schedule roomba control
    [NSThread detachNewThreadSelector:@selector(RoombaControlScheduler) toTarget:self withObject:nil];
    
    //start new thread to manage receiving bytes from roomba
    [NSThread detachNewThreadSelector:@selector(RoombaDataReceiver:) toTarget:self withObject:wifiDongle];
}


#pragma mark - Control

-(void)RoombaControlScheduler
{
	DLog(@"RMRoombaController RoombaControlScheduler");
    
    while (RunController)
    {
        [self class]; //keep running
    }
    
	DLog(@"RMRoombaController SCHEDULER KILLED");
}

-(void)RoombaDataReceiver:(WiFiDongleController *)connectedDongle
{
	DLog(@"RMRoombaController RoombaDataReceiver");
    
    void *buffer = malloc(1);
    unsigned char rxByte = 0;
    
    while (RunController)
    {
        rxByte = 0;
        
        //this is non-blocking
        buffer = [connectedDongle readByte];
        
        //there was nothing to read
        if(buffer == NULL)
        {
            //DLog(@"no byte");
        }
        else
        {
            memcpy(&rxByte, buffer, sizeof(rxByte));
            
            //TODO: do stuff with the received byte
        }
    }
    
    free(buffer);
    
    //need to do this at the end of this thread so that we don't try to read from a closed socket
    [self performSelectorOnMainThread:@selector(killRoombaController) withObject:nil waitUntilDone:false];
    
	DLog(@"RMRoombaController TRANSCEIVER KILLED");
}

-(void)processDataReceviedFromRoomba:(NSMutableData *)receivedData
{
	DLog(@"RMRoombaController processDataReceviedFromRoomba");
    
}


-(BOOL)VacuumIsOn
{
	DLog(@"RMRoombaController VacuumIsOn");
    
    return VacuumIsRunning;
}

-(void)toggleVacuumState
{
	DLog(@"RMRoombaController toggleVacuumState");
    
    if(VacuumIsRunning)
    {
        //stop vacuum
    }
    else
    {
        //start vacuum
    }
}

@end
