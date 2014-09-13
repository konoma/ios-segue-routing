//
//  UIViewController+KNMSegueRouting.h
//  segue-routing
//
//  Created by Markus Gasser on 13.09.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 Routes the preparation for a segue to an appropriate identifier.
 
 This category swizzles `-prepareForSegue:sender:` to try and find a
 method that matches the segue identifier and invokes this method instead.
 
 For example the segue with identifier 'Show Settings' will be routed to
 `-prepareForShowSettingsSegue:sender:`.
 
 If a matching method is found, it is invoked and `-prepareForSegue:sender:` returns.
 Otherwise the original implementation is called.
 
 If you override `-prepareForSegue:sender:` in your `UIViewController` subclass, you need
 to call super at some point if you desire the routing behavior.
 
 If you want to opt out of the segue routing behavior, override `+knm_supportsSegueRouting`
 and return NO, or alternatively override `-prepareForSegue:sender:` and do not call super.
 */
@interface UIViewController (KNMSegueRouting)

+ (BOOL)knm_supportsSegueRouting;

@end


