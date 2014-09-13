//
//  KNMSegueRoutingTests.m
//  segue-routing
//
//  Created by Markus Gasser on 13.09.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "UIViewController+KNMSegueRouting.h"

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

- (void)testEnabledViewControllerRoutesPrepareCalls
{
    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"Sample"
                                                                      source:[UIViewController new]
                                                                 destination:[UIViewController new]];
    id sender = @"Foo";
    
    [enabledViewController prepareForSegue:segue sender:sender];
    
    XCTAssert([enabledViewController hasRegisteredCallWithSelector:@selector(prepareForSampleSegue:sender:)
                                                             segue:segue sender:sender],
              @"Should have routed the segue");
}

- (void)testEnabledViewControllerStillCallsOriginalImplementation
{
    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"Sample"
                                                                      source:[UIViewController new]
                                                                 destination:[UIViewController new]];
    id sender = @"Foo";
    
    [enabledViewController prepareForSegue:segue sender:sender];
    
    XCTAssert([enabledViewController hasRegisteredCallWithSelector:@selector(prepareForSegue:sender:)
                                                             segue:segue sender:sender],
              @"Should have routed the segue");
}

@end
