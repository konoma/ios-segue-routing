//
//  KNMTestViewController.m
//  segue-routing
//
//  Created by Markus Gasser on 13.09.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "KNMTestViewController.h"
#import "KNMSegueCall.h"


@interface KNMTestViewController ()

@property (nonatomic, readonly) NSMutableArray *registeredCalls;

@end

@implementation KNMTestViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _registeredCalls = [NSMutableArray array];
    }
    return self;
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    // no-op, because we don't have storyboards in tests anyway
}

- (void)registerCallWithSelector:(SEL)selector segue:(UIStoryboardSegue *)segue sender:(id)sender
{
    KNMSegueCall *call = [[KNMSegueCall alloc] initWithSelector:selector segue:segue sender:sender];
    [self.registeredCalls addObject:call];
}

- (BOOL)hasRegisteredCallWithSelector:(SEL)selector segue:(UIStoryboardSegue *)segue sender:(id)sender
{
    KNMSegueCall *call = [[KNMSegueCall alloc] initWithSelector:selector segue:segue sender:sender];
    return [self.registeredCalls containsObject:call];
}

@end
