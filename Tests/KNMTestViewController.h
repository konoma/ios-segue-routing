//
//  KNMTestViewController.h
//  segue-routing
//
//  Created by Markus Gasser on 13.09.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


#define REGISTER_CALL() [self registerCallWithSelector:_cmd segue:segue sender:sender]


@interface KNMTestViewController : UIViewController

- (void)registerCallWithSelector:(SEL)selector segue:(UIStoryboardSegue *)segue sender:(id)sender;
- (BOOL)hasRegisteredCallWithSelector:(SEL)selector segue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
