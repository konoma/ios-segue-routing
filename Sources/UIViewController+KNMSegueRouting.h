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
 
 If the segue identifier is a special identifier looking like this: `@connect(myProperty)`
 it will write the destination view controller to the `myProperty` property of the calling
 controller. `myProperty` must be KVC compliant for this to work.
 
 If you override `-prepareForSegue:sender:` in your `UIViewController` subclass, you need
 to call super at some point if you desire the routing behavior.
 */
@interface UIViewController (KNMSegueRouting)

/**
 Determines if segue routing is enabled for this class.
 
 By default this returns YES. If you want to opt out of the segue routing behavior, override this method
 and return NO.
 
 @return Wether segue routing should be supported or not.
 */
+ (BOOL)knm_supportsSegueRouting;

/**
 Perform a segue with the given identifier and sender and execute the `configBlock` when preparing for the segue.
 
 The config block is called in `-prepareForSegue:sender:`. If you override `-prepareForSegue:sender:` you need to
 call super so the config block is executed.
 
 The configuration block is executed before any `-perform<MyIdentifier>Segue:sender:` methods are called.
 
 @param configBlock The block to execute when preparing for the segue
 */
- (void)knm_performSegueWithIdentifier:(NSString *)identifier sender:(id)sender configureUsingBlock:(void(^)(UIStoryboardSegue *segue))configBlock;

@end
