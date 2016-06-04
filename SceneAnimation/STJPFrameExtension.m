//
//  STJPFrameExtension.m
//  STAdSDK
//
//  Created by 罗富中 on 16/4/28.
//  Copyright © 2016年 socialtouch. All rights reserved.
//

#import "STJPFrameExtension.h"
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import "JPEngine.h"
#import <UIKit/UIKit.h>
@implementation STJPFrameExtension

+(void)main:(JSContext *)context
{
    context[@"CGRectMake"] = ^id(JSValue *x,JSValue *y,JSValue *width,JSValue *height){
        return @{@"x": @([x toDouble]), @"y": @([y toDouble]), @"width": @([width toDouble]),@"height": @([height toDouble])};
    };
    context[@"CGSizeMake"] = ^id(JSValue *width,JSValue *height){
        return @{ @"width": @([width toDouble]),@"height": @([height toDouble])};
    };
    context[@"CGPointMake"] = ^id(JSValue *x,JSValue *y){
        return @{@"x":@([x toDouble]),@"y":@([y toDouble])};
    };
    context[@"CGRectGetMaxX"] = ^id(JSValue *rect){
        CGFloat x = CGRectGetMaxX([rect toRect]);
        return @(x);
    };
    context[@"CGRectGetMaxY"] = ^id(JSValue *rect){
        CGFloat y = CGRectGetMaxY([rect toRect]);
        return @(y);
    };
    context[@"CGRectGetMinY"] = ^id(JSValue *rect){
        CGFloat y = CGRectGetMinY([rect toRect]);
        return @(y);
    };
    context[@"CGRectGetMinX"] = ^id(JSValue *rect){
        CGFloat x = CGRectGetMinX([rect toRect]);
        return @(x);
    };
    context[@"CGRectGetMidX"] = ^id(JSValue *rect){
        CGFloat x = CGRectGetMidX([rect toRect]);
        return @(x);
    };
    context[@"CGRectGetMidY"] = ^id(JSValue *rect){
        CGFloat y = CGRectGetMidY([rect toRect]);
        return @(y);
    };
    [JPEngine defineStruct:@{
        @"name": @"CGAffineTransform",
        @"types": @"FFFFFF",
        @"keys": @[@"a", @"b", @"c", @"d", @"tx", @"ty"]
    }];
}

@end
