//
//  RoombMoteTests.m
//  RoombMoteTests
//
//  Created by Jess Latimer on 11/19/2013.
//  Copyright (c) 2013 Robot Friendship Society. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RMAppDelegate.h"
#import "RMViewController.h"
#import "RoombaController.h"

@interface RoombMoteTests : XCTestCase
{
    RMAppDelegate *app_delegate;
    RMViewController *app_view_controller;
    UIView *app_view;
}

@end

@implementation RoombMoteTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    app_delegate = [[UIApplication sharedApplication] delegate];
    app_view_controller = (RMViewController *)app_delegate.window.rootViewController;
    app_view = app_view_controller.view;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testZoneDetect
{
    XCTAssertTrue([app_view_controller isInStopZone:0], @"Failed Stop Zone Test 1");
    XCTAssertTrue(![app_view_controller isInStopZone:20], @"Failed Stop Zone Test 2");
    XCTAssertTrue(![app_view_controller isInStopZone:-20], @"Failed Stop Zone Test 3");
    XCTAssertTrue(![app_view_controller isInStopZone:100], @"Failed Stop Zone Test 4");
    XCTAssertTrue(![app_view_controller isInStopZone:-100], @"Failed Stop Zone Test 5");
    
    XCTAssertTrue(![app_view_controller isInRotateZone:0], @"Failed Rotate Zone Test 1");
    XCTAssertTrue(![app_view_controller isInRotateZone:20], @"Failed Rotate Zone Test 2");
    XCTAssertTrue(![app_view_controller isInRotateZone:-20], @"Failed Rotate Zone Test 3");
    XCTAssertTrue([app_view_controller isInRotateZone:145], @"Failed Rotate Zone Test 4");
    XCTAssertTrue([app_view_controller isInRotateZone:-145], @"Failed Rotate Zone Test 5");
    
    XCTAssertTrue(![app_view_controller isInMaxVelocityZone:0], @"Failed Max Velocity Zone Test 1");
    XCTAssertTrue(![app_view_controller isInMaxVelocityZone:20], @"Failed Max Velocity Zone Test 2");
    XCTAssertTrue(![app_view_controller isInMaxVelocityZone:-20], @"Failed Max Velocity Zone Test 3");
    XCTAssertTrue([app_view_controller isInMaxVelocityZone:155], @"Failed Max Velocity Zone Test 4");
    XCTAssertTrue([app_view_controller isInMaxVelocityZone:155], @"Failed Max Velocity Zone Test 5");
}

- (void)testVelocity
{
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(0, 0)] == ROOMB_VELOCITY_STOPPED, @"Falied Velocity Test 1");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(19, -19)] == ROOMB_VELOCITY_STOPPED, @"Falied Velocity Test 2");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(0, 155)] == ROOMB_VELOCITY_MAX, @"Falied Velocity Test 3");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(0, -155)] == -ROOMB_VELOCITY_MAX, @"Falied Velocity Test 4");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(21, 15)] == STATIONARY_SPIN_SPEEN, @"Falied Velocity Test 5");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(-21, -15)] == STATIONARY_SPIN_SPEEN, @"Falied Velocity Test 6");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(0, 100)] == 308, @"Falied Velocity Test 7");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(0, -100)] == -308, @"Falied Velocity Test 8");
    
}

- (void)testRadius
{
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(0, 0)] == ROOMB_RADIUS_STRAIGT, @"Falied Radius Test 1");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(19, -19)] == ROOMB_RADIUS_STRAIGT, @"Falied Radius Test 2");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(135, 100)] == ROOMB_RADIUS_SPIN, @"Falied Radius Test 3");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(-135, -100)] == -ROOMB_RADIUS_SPIN, @"Falied Radius Test 4");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(21, 15)] == ROOMB_RADIUS_SPIN, @"Falied Radius Test 5");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(-21, -15)] == -ROOMB_RADIUS_SPIN, @"Falied Radius Test 6");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(50, 30)] == 1455, @"Falied Radius Test 7");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(-50, 30)] == -1455, @"Falied Radius Test 8");
}

- (void)testDPadImage
{
    [app_view_controller setDPadImageFromTouchLocation:CGPointMake(0, 0)];
    XCTAssertTrue([[app_view_controller.driveControl imageForState:UIControlStateHighlighted] isEqual:(UIImage *)[UIImage imageNamed:@"dpad-off.png"]],@"Falied DPad Test 1" );
    [app_view_controller setDPadImageFromTouchLocation:CGPointMake(19, -19)];
    XCTAssertTrue([[app_view_controller.driveControl imageForState:UIControlStateHighlighted] isEqual:(UIImage *)[UIImage imageNamed:@"dpad-off.png"]],@"Falied DPad Test 2" );
    [app_view_controller setDPadImageFromTouchLocation:CGPointMake(100, -19)];
    XCTAssertTrue([[app_view_controller.driveControl imageForState:UIControlStateHighlighted] isEqual:(UIImage *)[UIImage imageNamed:@"dpad-left.png"]],@"Falied DPad Test 3" );
    [app_view_controller setDPadImageFromTouchLocation:CGPointMake(-100, -19)];
    XCTAssertTrue([[app_view_controller.driveControl imageForState:UIControlStateHighlighted] isEqual:(UIImage *)[UIImage imageNamed:@"dpad-right.png"]],@"Falied DPad Test 4" );
    [app_view_controller setDPadImageFromTouchLocation:CGPointMake(0, 100)];
    XCTAssertTrue([[app_view_controller.driveControl imageForState:UIControlStateHighlighted] isEqual:(UIImage *)[UIImage imageNamed:@"dpad-up.png"]],@"Falied DPad Test 5" );
    [app_view_controller setDPadImageFromTouchLocation:CGPointMake(0, -100)];
    XCTAssertTrue([[app_view_controller.driveControl imageForState:UIControlStateHighlighted] isEqual:(UIImage *)[UIImage imageNamed:@"dpad-down.png"]],@"Falied DPad Test 6" );
    [app_view_controller setDPadImageFromTouchLocation:CGPointMake(100, 100)];
    XCTAssertTrue([[app_view_controller.driveControl imageForState:UIControlStateHighlighted] isEqual:(UIImage *)[UIImage imageNamed:@"dpad-upleft.png"]],@"Falied DPad Test 7" );
    [app_view_controller setDPadImageFromTouchLocation:CGPointMake(-100, -100)];
    XCTAssertTrue([[app_view_controller.driveControl imageForState:UIControlStateHighlighted] isEqual:(UIImage *)[UIImage imageNamed:@"dpad-downright.png"]],@"Falied DPad Test 8" );
}

@end
