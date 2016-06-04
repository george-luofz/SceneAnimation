//
//  STAnimationService.h
//  SceneAnimation
//
//  Created by 罗富中 on 16/6/4.
//  Copyright © 2016年 social-touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface STAnimationService : NSObject
+(instancetype) shareInstance;
- (void)createAnimation:(NSString *)animationId viewController:(UIViewController *)viewController;;
- (void)enableAnimation:(NSString *)animationId;
- (void)closeAnimation:(NSString *)animationId;
@end
