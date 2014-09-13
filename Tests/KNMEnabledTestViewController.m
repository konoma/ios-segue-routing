//
//  KNMEnabledTestViewController.m
//  segue-routing
//
//  Created by Markus Gasser on 13.09.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "KNMEnabledTestViewController.h"

@interface KNMEnabledTestViewController ()

@end

@implementation KNMEnabledTestViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    REGISTER_CALL();
}

- (void)prepareForSampleSegue:(UIStoryboardSegue *)segue sender:(id)sender { REGISTER_CALL(); }
- (void)prepareForAnotherExample2Segue:(UIStoryboardSegue *)segue sender:(id)sender { REGISTER_CALL(); }

@end
