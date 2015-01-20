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


#pragma mark - Segue Routing

- (void)testEnabledViewControllerRoutesPrepareCalls
{
    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"Sample" source:[UIViewController new] destination:[UIViewController new]];
    id sender = @"Foo";
    
    [enabledViewController prepareForSegue:segue sender:sender];
    
    XCTAssert([enabledViewController hasRegisteredCallWithSelector:@selector(prepareForSampleSegue:sender:) segue:segue sender:sender],
              @"Should have routed the segue");
}

- (void)testEnabledViewControllerStillCallsOriginalImplementation
{
    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"Sample" source:[UIViewController new] destination:[UIViewController new]];
    id sender = @"Foo";
    
    [enabledViewController prepareForSegue:segue sender:sender];
    
    XCTAssert([enabledViewController hasRegisteredCallWithSelector:@selector(prepareForSegue:sender:) segue:segue sender:sender],
              @"Should have routed the segue");
}

- (void)testRoutingOfSeguesWithSparseCamelCaseNames
{
    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"Camel Case Sample" source:[UIViewController new] destination:[UIViewController new]];
    id sender = @"Foo";
    
    [enabledViewController prepareForSegue:segue sender:sender];
    
    XCTAssert([enabledViewController hasRegisteredCallWithSelector:@selector(prepareForCamelCaseSampleSegue:sender:) segue:segue sender:sender],
              @"Should have routed the segue");
}

- (void)testRoutingOfSeguesWithCompactCamelCaseNames
{
    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"CamelCaseSample" source:[UIViewController new] destination:[UIViewController new]];
    id sender = @"Foo";
    
    [enabledViewController prepareForSegue:segue sender:sender];
    
    XCTAssert([enabledViewController hasRegisteredCallWithSelector:@selector(prepareForCamelCaseSampleSegue:sender:) segue:segue sender:sender],
              @"Should have routed the segue");
}

- (void)testRoutingOfSeguesWithSeparatedNames
{
    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"camel-case-sample" source:[UIViewController new] destination:[UIViewController new]];
    id sender = @"Foo";
    
    [enabledViewController prepareForSegue:segue sender:sender];
    
    XCTAssert([enabledViewController hasRegisteredCallWithSelector:@selector(prepareForCamelCaseSampleSegue:sender:) segue:segue sender:sender],
              @"Should have routed the segue");
}


#pragma mark - Block Configuration

- (void)testThatConfigurationBlockIsCalledForSegue
{
    __block UIStoryboardSegue *configuredSegue = nil;
    [enabledViewController knm_performSegueWithIdentifier:@"Sample" sender:self configureUsingBlock:^(UIStoryboardSegue *segue) {
        configuredSegue = segue;
    }];
    
    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"Sample" source:[UIViewController new] destination:[UIViewController new]];
    [enabledViewController prepareForSegue:segue sender:self]; // simulate performing the segue
    
    XCTAssertEqualObjects(configuredSegue.identifier, @"Sample");
}


#pragma mark - Connecting Source and Destination View Controllers

- (void)testThatTheDestinationIsPassedToTheCallerForConnectSegues
{
    NSString *identifier = @"@connect(destinationController)"; // special segue name to notify we want to connect
    UIViewController *destinationController = [[UIViewController alloc] init];
    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:identifier source:[UIViewController new] destination:destinationController];
    id sender = @"Foo";
    
    [enabledViewController prepareForSegue:segue sender:sender];
    
    XCTAssert(enabledViewController.destinationController == destinationController, @"Should have set the controller property");
}

- (void)testThatConnectSeguePerformsPreparationCall
{
    NSString *identifier = @"@connect(destinationController)"; // special segue name to notify we want to connect
    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:identifier source:[UIViewController new] destination:[UIViewController new]];
    id sender = @"Foo";
    
    [enabledViewController prepareForSegue:segue sender:sender];
    
    // naming of prepare segue is as for other segues
    XCTAssert([enabledViewController hasRegisteredCallWithSelector:@selector(prepareForConnectDestinationControllerSegue:sender:) segue:segue sender:sender],
              @"Should have routed the segue");
}

@end
