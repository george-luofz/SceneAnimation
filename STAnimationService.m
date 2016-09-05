//
//  STAnimationService.m
//  SceneAnimation
//
//  Created by 罗富中 on 16/6/4.
//  Copyright © 2016年 social-touch. All rights reserved.
//

#import "STAnimationService.h"
#import "STAnimation.h"
#import "JPEngine.h"
#import "STSceneAdPlayer.h"
#import "STCarSceneAdPlayer.h"
#import "STTimeMeter.h"
#import <objc/runtime.h>
#import "STJPEngine.h"
@implementation STAnimationService {
    NSMutableDictionary *_animationDict;
    STAnimation *_curAnimation;
}
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static STAnimationService *service;
    dispatch_once(&onceToken, ^{
        service = [[STAnimationService alloc] init];
    });
    return service;
}
-(void) clearAnimation
{
    NSArray *keyArr = [NSArray arrayWithArray:_animationDict.allKeys];
    for(NSString *key in keyArr){
        STAnimation *animation = [_animationDict valueForKey:key];
        if(animation.viewController == nil){
            [_animationDict removeObjectForKey:key];
        }
    }
}
- (void)createAnimation:(NSString *)animationId
         viewController:(UIViewController *)viewController {
    [self clearAnimation];
    if (!animationId) return;
    if (!_animationDict) {
        _animationDict = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    STAnimation *animation = [[STAnimation alloc] init];
    animation.animationId = animationId;
    animation.viewController = viewController;
    [_animationDict setValue:animation forKey:animationId];
}
void TestMetaClass(id self, SEL _cmd) {
    NSLog(@"This objcet is %p", self);
    
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]);
    
    
    
    Class currentClass = [self class];
    
    for (int i = 0; i < 4; i++) {
        
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        
        currentClass = objc_getClass((__bridge void *)currentClass);
        
    }
    NSLog(@"NSObject's class is %p", [NSObject class]);
    
    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class]));
    
}


- (void)enableAnimation:(NSString *)animationId {
    STAnimation *animation = [_animationDict valueForKey:animationId];
    if (animation) {
        if(_curAnimation){
            if ([_curAnimation isEqual:animation]) return;
            [_curAnimation hide];
        }
//        Class newClass = objc_allocateClassPair([NSError class], "STCarSceneAdPlayer", 0);
        
//        class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
        
//        objc_registerClassPair(newClass);
        
        
        
        
//        [player performSelector:@selector(testMetaClass)];

        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"carAnimaiton" ofType:@"js"];
        [STJPEngine evaluateScriptWithPath:filePath];
        
//        id player = [[NSClassFromString(@"STCarSceneAdPlayer") alloc] init];
//        [player performSelector:@selector(dddd) withObject:nil afterDelay:0];
        
//        STSceneAdPlayer *player = [[STCarSceneAdPlayer alloc] init];
//         此处换为STCarSceneAdPlayer初始化，动画播放正常
        
        STSceneAdPlayer *player = [[STSceneAdPlayer alloc] init];
        animation.player = player;
        [player setCallback:animation];
        STTimeMeter *timer = [[STTimeMeter alloc] init];
        player.timer = timer;
        [animation load];
        [animation show];
        _curAnimation = animation;
    } else {
        _curAnimation = nil;
    }
}
- (void)closeAnimation:(NSString *)animationId {
    STAnimation *anmation = [_animationDict valueForKey:animationId];
    if (!anmation) return;
    [anmation close];
    [_animationDict removeObjectForKey:animationId];
}
@end
