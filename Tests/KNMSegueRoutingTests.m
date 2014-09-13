//
//  KNMSegueRoutingTests.m
//  segue-routing
//
//  Created by Markus Gasser on 13.09.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "KNMEnabledTestViewController.h"


@interface KNMSegueRoutingTests : XCTestCase @end
@implementation KNMSegueRoutingTests {
    KNMEnabledTestViewController *enabledViewController;
}

#pragma mark - Setup

- (void)setUp
{
    [super setUp];
    
    enabledViewController = [[KNMEnabledTestViewController alloc] init];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

@end
