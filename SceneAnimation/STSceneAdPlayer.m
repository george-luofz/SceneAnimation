//
//  STSceneAdPlayer.m
//  STAdSDK
//
//  Created by 程思源 on 16/4/25.
//  Copyright © 2016年 socialtouch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STSceneAdPlayer.h"
#import "STUtils.h"
@implementation STSceneAdPlayer {
}
- (void)start {
}
- (void)destroy {
}
- (void)pause {
}
- (void)resume {
}
- (UIView *)getView {
    return nil;
}
- (void)prepareInSubthread {
    NSLog(@"prepare in sub thread");
}
- (void)animationDidStart:(CAAnimation *)anim {
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
}

- (CGFloat)atan2f:(CGFloat)x y:(CGFloat)y {
    CGFloat d = atan2f(x, y);
    return d;
}
- (CGAffineTransform)CGAffineTransformMakeRotation:(CGFloat)x {
    return CGAffineTransformMakeRotation(x);
}
- (CGAffineTransform)CGAffineTransformMakeScale:(CGFloat)x y:(CGFloat)y {
    return CGAffineTransformMakeScale(x, y);
}
- (NSString *)kCAFillModeForwards {
    return kCAFillModeForwards;
}
- (CGFloat)PI {
    return M_PI;
}
- (NSString *)NSRunLoopCommonModes {
    return NSRunLoopCommonModes;
}
@end