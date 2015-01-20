//
//  KNMEnabledTestViewController.h
//  segue-routing
//
//  Created by Markus Gasser on 13.09.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "KNMTestViewController.h"


@interface KNMEnabledTestViewController : KNMTestViewController

@property (nonatomic, strong) UIViewController *destinationController;

- (void)prepareForSampleSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void)prepareForCamelCaseSampleSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (void)prepareForConnectDestinationControllerSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
