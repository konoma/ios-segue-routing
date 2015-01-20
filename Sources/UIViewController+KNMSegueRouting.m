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


static const NSUInteger _KNMSegueConfigurationBlockKey;

#define DISABLE_SEGUE_ROUTING(CLASS)\
    @implementation CLASS (KNMSegueRouting) \
    + (BOOL)knm_supportsSegueRouting { return NO; } \
    @end


static NSString* FirstLetterCapitalizedString(NSString *string)
{
    if (string.length == 0) {
        return string;
    }
    
    NSString *head = [string substringToIndex:1];
    NSString *tail = [string substringFromIndex:1];
    return [[head uppercaseString] stringByAppendingString:tail];
}


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


#pragma mark - Custom -prepareForSegue:sender:

- (void)_knm_prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self _knm_connectDestinationControllerForSegue:segue];
    [self _knm_executeConfigurationBlockForSegue:segue];
    [self _knm_routePreparationForSegue:segue sender:sender];
    
    [self _knm_prepareForSegue:segue sender:sender]; // call original implementation
}


#pragma mark - Segue Routing

- (void)_knm_routePreparationForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![self.class knm_supportsSegueRouting] || segue.identifier.length == 0) {
        return;
    }
    
    SEL preparationSelector = [self _knm_selectorForSegueIdentifier:segue.identifier];
    if (preparationSelector == NULL || ![self respondsToSelector:preparationSelector]) {
        return;
    }
    
    ((void (*)(id, SEL, id, id))objc_msgSend)(self, preparationSelector, segue, sender); // call the routed method
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
    NSMutableString *sanitizedIdentifier = [NSMutableString string];
    NSArray *identifierParts = [identifier componentsSeparatedByCharactersInSet:forbiddenChars];
    for (NSString *part in identifierParts) {
        [sanitizedIdentifier appendString:FirstLetterCapitalizedString(part)];
    }
    
    // create the selector
    return (sanitizedIdentifier.length > 0
            ? NSSelectorFromString([NSString stringWithFormat:@"prepareFor%@Segue:sender:", sanitizedIdentifier])
            : NULL);
}


#pragma mark - Block Configuration for Segues

- (void)knm_performSegueWithIdentifier:(NSString *)identifier sender:(id)sender configureUsingBlock:(void (^)(UIStoryboardSegue *))configBlock
{
    if (configBlock != nil) {
        [self _knm_pushConfigurationBlock:configBlock forSegueWithIdentifier:identifier];
    }
    [self performSegueWithIdentifier:identifier sender:sender];
}

- (void)_knm_executeConfigurationBlockForSegue:(UIStoryboardSegue *)segue
{
    // execute a configure block if there is one
    void (^configurationBlock)(UIStoryboardSegue *) = [self _knm_popConfigurationBlockForSegueWithIdentifier:segue.identifier];
    if (configurationBlock != nil) {
        configurationBlock(segue);
    }
}

- (void)_knm_pushConfigurationBlock:(void (^)(UIStoryboardSegue *))block forSegueWithIdentifier:(NSString *)identifier
{
    NSMutableDictionary *configurationBlocks = objc_getAssociatedObject(self, &_KNMSegueConfigurationBlockKey);
    if (configurationBlocks == nil) {
        configurationBlocks = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &_KNMSegueConfigurationBlockKey, configurationBlocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    configurationBlocks[identifier] = block;
}

- (void (^)(UIStoryboardSegue *))_knm_popConfigurationBlockForSegueWithIdentifier:(NSString *)identifier
{
    NSMutableDictionary *configurationBlocks = objc_getAssociatedObject(self, &_KNMSegueConfigurationBlockKey);
    id block = configurationBlocks[identifier];
    [configurationBlocks removeObjectForKey:identifier];
    return block;
}


#pragma mark - Connecting the Destination Controller

- (void)_knm_connectDestinationControllerForSegue:(UIStoryboardSegue *)segue
{
    if (![self.class knm_supportsSegueRouting]
        || ![segue.identifier hasPrefix:@"@connect("]
        || ![segue.identifier hasSuffix:@")"]
        || segue.identifier.length <= 10) {
        return;
    }
    
    NSString *propertyName = [segue.identifier substringWithRange:NSMakeRange(9, (segue.identifier.length - 10))];
    [self setValue:segue.destinationViewController forKey:propertyName];
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

