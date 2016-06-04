//
//  STAnimation.m
//  SceneAnimation
//
//  Created by 罗富中 on 16/6/4.
//  Copyright © 2016年 social-touch. All rights reserved.
//

#import "STAnimation.h"
#import "STSceneAdPlayer.h"
#import "STUtils.h"
#import "JPEngine.h"
@implementation STAnimation {
    UIView *_playerView;
    BOOL _isWorking;
}

- (void)load {
    @synchronized (self) {
        if(_isWorking) return;
        if(_playerView) return;
    }
    [STUtils runOnSubthread:^{
        [self.player prepareInSubthread];
        [STUtils runOnMainThread:^{
            UIView *playerView = [self.player getView];
            _playerView = playerView;
            if(!playerView) return ;
            [self.viewController.view addSubview:playerView];
            [self.player start];
            _isWorking = NO;
        }];
    }];
}
- (void)close {
    [_playerView.layer removeAllAnimations];
    [_playerView removeFromSuperview];
    _player = nil;
}
-(void)show
{
    _playerView.hidden = NO;
}
-(void)hide{
    _playerView.hidden = YES;
}
- (void)onClick{
    
}
- (void)onClose{
    
}
- (void)onShow{
    
}
- (NSData *)getDataFromUrl:(NSString *)url enableCache:(BOOL)enableCache{
    return [STUtils getDataWithUrl:[NSURL URLWithString:url]];
}
- (void)postCloseLogWithType:(int)type{
    
}
- (NSDictionary *)getSceneAdData{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return [dict valueForKey:@"sceneData"];
}
- (NSDictionary *)getSceneConfig{
    return  @{@"clickPopup":@(1),@"yOffset":@(50)};
}
- (NSMutableDictionary *)getExtra{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:@(10),@"sceneDelayCloseTimeout", nil];
}
@end
