//
//  KNMSegueCall.m
//  segue-routing
//
//  Created by Markus Gasser on 13.09.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import "KNMSegueCall.h"


@implementation KNMSegueCall

- (instancetype)initWithSelector:(SEL)selector segue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ((self = [super init])) {
        _selector = selector;
        _segue = segue;
        _sender = sender;
    }
    return self;
}

- (NSUInteger)hash
{
    return ((NSUInteger)self.selector ^ self.segue.hash ^ [self.sender hash]);
}

- (BOOL)isEqual:(id)object
{
    if (object == self) { return YES; }
    else if (object == nil || [object class] != [self class]) { return NO; }
    typeof(self) other = object;
    
    return (self.selector == other.selector && self.segue == other.segue && self.sender == other.sender);
}

@end
