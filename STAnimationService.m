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
- (void)enableAnimation:(NSString *)animationId {
    STAnimation *animation = [_animationDict valueForKey:animationId];
    if (animation) {
        if(_curAnimation){
            if ([_curAnimation isEqual:animation]) return;
            [_curAnimation hide];
        }
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"carAnimaiton" ofType:@"js"];
        [JPEngine evaluateScriptWithPath:filePath];
        //STSceneAdPlayer *player = [[STCarSceneAdPlayer alloc] init];
        // 此处换为STCarSceneAdPlayer初始化，动画播放正常
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
