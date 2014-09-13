//
//  KNMSegueCall.h
//  segue-routing
//
//  Created by Markus Gasser on 13.09.14.
//  Copyright (c) 2014 konoma GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KNMSegueCall : NSObject

- (instancetype)initWithSelector:(SEL)selector segue:(UIStoryboardSegue *)segue sender:(id)sender;

@property (nonatomic, readonly) SEL selector;
@property (nonatomic, readonly) UIStoryboardSegue *segue;
@property (nonatomic, readonly) id sender;

@end
