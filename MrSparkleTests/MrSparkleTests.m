//
//  RoombMoteTests.m
//  MrSparkleTests
//
//  Copyright (c) 2013 Jess Latimer, Bruce Giovando
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  Except as contained in this notice, the name(s) of the above copyright holders
//  shall not be used in advertising or otherwise to promote the sale, use or
//  other dealings in this Software without prior written authorization.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import "RoombaController.h"

@interface MrSparkleTests : XCTestCase
{
    AppDelegate *app_delegate;
    ViewController *app_view_controller;
    UIView *app_view;
}

@end

@implementation MrSparkleTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    app_delegate = [[UIApplication sharedApplication] delegate];
    app_view_controller = (ViewController *)app_delegate.window.rootViewController;
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
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(0, 0)] == kStopVelocity, @"Falied Velocity Test 1");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(19, -19)] == kStopVelocity, @"Falied Velocity Test 2");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(0, 155)] == kMaxVelocity, @"Falied Velocity Test 3");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(0, -155)] == -kMaxVelocity, @"Falied Velocity Test 4");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(21, 15)] == kSpinVelocity, @"Falied Velocity Test 5");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(-21, -15)] == kSpinVelocity, @"Falied Velocity Test 6");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(0, 100)] == 308, @"Falied Velocity Test 7");
    XCTAssertTrue([app_view_controller getDriveVelocityFromTouchLocation:CGPointMake(0, -100)] == -308, @"Falied Velocity Test 8");
    
}

- (void)testRadius
{
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(0, 0)] == kStraightRadius, @"Falied Radius Test 1");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(19, -19)] == kStraightRadius, @"Falied Radius Test 2");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(135, 100)] == kSpinRadius, @"Falied Radius Test 3");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(-135, -100)] == -kSpinRadius, @"Falied Radius Test 4");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(21, 15)] == kSpinRadius, @"Falied Radius Test 5");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(-21, -15)] == -kSpinRadius, @"Falied Radius Test 6");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(50, 30)] == 1455, @"Falied Radius Test 7");
    XCTAssertTrue([app_view_controller getDriveRadiusFromTouchLocation:CGPointMake(-50, 30)] == -1455, @"Falied Radius Test 8");
}

@end
