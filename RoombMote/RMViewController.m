//
//  RMViewController.m
//  RoombMote
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import "RMViewController.h"

@interface RMViewController ()

-(void)roombaControllerDidStart;
-(void)roombaControllerCantStart;
-(void)roombaControllerDidStop;
@end

@implementation RMViewController

@synthesize roombaController;
@synthesize statusLabel;
@synthesize vacuumButton;

- (void)viewDidLoad
{
	DLog(@"RMViewController viewDidLoad");
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    roombaController = [[RMRoombaController alloc] init];
    [roombaController startRoombaController];
    
    self.statusLabel.text = @"Connecting...";
}

- (void)didReceiveMemoryWarning
{
	DLog(@"RMViewController didReceiveMemoryWarning");
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - RMRoombaController Delegate Methods

-(void)roombaControllerDidStart
{
	DLog(@"RMViewController roombaControllerDidStart");
    
    self.statusLabel.text = @"Connected.";
}

-(void)roombaControllerCantStart
{
	DLog(@"RMViewController roombaControllerCantStart");
    
    self.statusLabel.text = @"Can't Connect.";
}
-(void)roombaControllerDidStop
{
	DLog(@"RMViewController roombaControllerDidStop");
    
    self.statusLabel.text = @"Not Connected.";
}

-(IBAction)buttonPressVacuum:(id)sender
{
    if([roombaController RoombaIsConnected])
    {
        if([roombaController VacuumIsOn])
            self.vacuumButton.titleLabel.text = @"Stop Vacuum";
        else
            self.vacuumButton.titleLabel.text = @"Start Vacuum";
                
        [roombaController toggleVacuumState];
    }
}

@end
