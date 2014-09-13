//
//  UIViewController+KNMSegueRouting.m
//  segue-routing
//
//  Created by Markus Gasser on 13.09.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "UIViewController+KNMSegueRouting.h"

#import <objc/runtime.h>
#import <objc/message.h>


#define DISABLE_SEGUE_ROUTING(CLASS)\
    @implementation CLASS (KNMSegueRouting) \
    + (BOOL)knm_supportsSegueRouting { return NO; } \
    @end


@implementation UIViewController (KNMSegueRouting)

#pragma mark - Initialization

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _knm_enableSegueRouting];
    });
}

+ (void)_knm_enableSegueRouting
{
    NSAssert(self == [UIViewController class], @"Must only be called for UIViewController itself");
    
#ifdef DEBUG
    NSLog(@"Enabling segue routing on UIViewController");
#endif
    
    SEL originalSelector = @selector(prepareForSegue:sender:);
    SEL swizzledSelector = @selector(_knm_prepareForSegue:sender:);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}


#pragma mark - Configuration

+ (BOOL)knm_supportsSegueRouting
{
    return YES;
}


#pragma mark - Segue Routing

- (void)_knm_prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![self _knm_routePreparationForSegue:segue sender:sender]) {
        [self _knm_prepareForSegue:segue sender:sender]; // call original implementation
    }
}

- (BOOL)_knm_routePreparationForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![self.class knm_supportsSegueRouting] || segue.identifier.length == 0) {
        return NO;
    }
    
    SEL preparationSelector = [self _knm_selectorForSegueIdentifier:segue.identifier];
    if (![self respondsToSelector:preparationSelector]) {
        return NO;
    }
    
    ((void (*)(id, SEL, id, id))objc_msgSend)(self, preparationSelector, segue, sender); // call the routed method
    return YES;
}

- (SEL)_knm_selectorForSegueIdentifier:(NSString *)identifier
{
    static NSCharacterSet *forbiddenChars;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *allowedChars = @"_1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        forbiddenChars = [[NSCharacterSet characterSetWithCharactersInString:allowedChars] invertedSet];
    });
    
    // sanitize the identifier
    identifier = [identifier capitalizedString];
    identifier = [[identifier componentsSeparatedByCharactersInSet:forbiddenChars] componentsJoinedByString:@""];
    
    // create the selector
    return NSSelectorFromString([NSString stringWithFormat:@"prepareFor%@Segue:sender:", identifier]);
}

@end

// disable segue routing for some common controllers
DISABLE_SEGUE_ROUTING(UINavigationController)
DISABLE_SEGUE_ROUTING(UITabBarController)


// declare a class to make libtool happy
@interface KNMSegueRouting : NSObject
@end
@implementation KNMSegueRouting
@end

