//
//  RMViewController.m
//  RoombMote
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import "RMViewController.h"

@interface RMViewController ()
{
    RMRoombaController *roombaController;
}

@property (nonatomic, retain) RMRoombaController *roombaController;

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
    
    self.statusLabel.text = @"Connecting...";
    
    roombaController = [[RMRoombaController alloc] init];
    [roombaController setDelegate:self];
    [roombaController startRoombaController];
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
        [roombaController toggleVacuumState];
        if([roombaController VacuumIsOn])
            [self.vacuumButton setTitle:@"Stop Vacuum" forState:UIControlStateNormal];
        else
            [self.vacuumButton setTitle:@"Start Vacuum" forState:UIControlStateNormal];
    }
}

@end
