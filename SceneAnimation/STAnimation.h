//
//  STAnimation.h
//  SceneAnimation
//
//  Created by 罗富中 on 16/6/4.
//  Copyright © 2016年 social-touch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STSceneAdPlayer.h"
#import "STTimeMeter.h"
@interface STAnimation : NSObject
@property(nonatomic,nullable,copy) NSString *animationId;
@property(nonatomic,nullable,weak) UIViewController *viewController;
@property(nonatomic,nullable,retain) STSceneAdPlayer *player;
@property(nonatomic,nullable,retain) STTimeMeter *timer;
-(void) load;
-(void) close;
-(void) hide;
-(void) show;
@end
