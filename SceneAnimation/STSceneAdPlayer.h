//
//  STSceneAdPlayer.h
//  STAdSDK
//
//  Created by 程思源 on 16/4/25.
//  Copyright © 2016年 socialtouch. All rights reserved.
//


#ifndef SceneAdPlayer_h
#define SceneAdPlayer_h
#import <UIKit/UIKit.h>
#import "STTimeMeter.h"
#import "STSceneAdCallback.h"
@interface STSceneAdPlayer : NSObject
@property(nonatomic, retain, nonnull) id callback;
@property(nonnull,nonatomic,retain) STTimeMeter *timer;
- (void)start;
- (void)destroy;
- (void)pause;
- (void)resume;
- (void)prepareInSubthread;
- (nullable UIView*)getView;
@end

#endif /* STSceneAdPlayer_h */
