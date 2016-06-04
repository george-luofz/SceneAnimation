//
//  STSceneAdPlayer2.m
//  AnimationDemo
//
//  Created by 罗富中 on 16/4/27.
//  Copyright © 2016年 罗富中. All rights reserved.

#import "STCarSceneAdPlayer.h"
#import "STUtils.h"
#import "STSceneAdCallback.h"
@implementation STCarSceneAdPlayer {
    UIImageView *_bgView;
    UIImageView *_carView;
    UIImageView *_logoView;
    UIImageView *_wheelViewLeft;
    UIImageView *_wheelViewRight;
    UILabel *_desLabel;
    UIButton *_closeBtn;
    
    UIView *_containerView;
    UIView *_view;
    
    CGFloat _bgImgLength;
    CGFloat _logoImgLength;
    CGFloat _curLeftMove;
    
    BOOL _allowStop;
    UITapGestureRecognizer *_logoTap;
    UITapGestureRecognizer *_containerTap;
    NSTimer *_autoClosetimer;
    
    NSDictionary *_dataDict;
    NSTimeInterval _delayCloseTimeInterval;
    NSDictionary *_configDict;
    BOOL _canGetView;
    
    UIImage *_closeImg;
    UIView *_logoBufferView;
}
- (CGFloat)getResizeValue:(CGFloat)origineValue {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return origineValue * screenWidth / 414.0;
}
- (void)start {
    if (_allowStop) {
        [self addTapGestureForView:_logoBufferView action:@selector(logoTap)];
        _curLeftMove = _logoImgLength;
        [self startLogoAnimation:_curLeftMove];
    } else {
        [self addTapGestureForView:_containerView action:@selector(tap)];
        _curLeftMove = _bgImgLength;
        [self startBgAnimation:_bgImgLength];
        [self.callback onShow];
    }
}
- (void)destroy {
//    [self stopTimer];
    if (_autoClosetimer) {
        [_autoClosetimer invalidate];
        _autoClosetimer = nil;
    }
}
- (void)pause {
    [self.timer pause];
}
- (void)resume {
    [self.timer start];
}
- (void)prepareInSubthread {
    NSDictionary *dataDict = [self.callback getSceneAdData];
    NSInteger styleId = [dataDict[@"style_id"] integerValue];
    if (styleId != 2001) return;
    _canGetView = YES;
    NSDictionary *contentDict = dataDict[@"content"];
    NSDictionary *carImgDict = contentDict[@"carImg"];
    NSDictionary *wheelImgDict = contentDict[@"wheelImg"];
    NSDictionary *logoImgDict = contentDict[@"logoImg"];
    NSDictionary *bgImgDict = contentDict[@"backImg"];
    
    NSString *carImgUrl = carImgDict[@"url"];
    NSString *wheelImgUrl = wheelImgDict[@"url"];
    NSString *logoImgUrl = logoImgDict[@"url"];
    NSString *bgImgUrl = bgImgDict[@"url"];
    
    NSData *bgImgData = [self.callback getDataFromUrl:bgImgUrl enableCache:YES];
    NSData *carImgData = [self.callback getDataFromUrl:carImgUrl enableCache:YES];
    NSData *logoImgData =
    [self.callback getDataFromUrl:logoImgUrl enableCache:YES];
    NSData *wheelImgData =
    [self.callback getDataFromUrl:wheelImgUrl enableCache:YES];
    
    UIImage *bgImg = [UIImage imageWithData:bgImgData];
    UIImage *carImg = [UIImage imageWithData:carImgData];
    UIImage *logoImg = [UIImage imageWithData:logoImgData];
    UIImage *wheelImg1 = [UIImage imageWithData:wheelImgData];
    
    NSString *closeImgUrl = @"http://img.ma.social-touch.com/sdk-res/img/close.png";
    NSData *closeImgData = [self.callback getDataFromUrl:closeImgUrl enableCache:YES];
    UIImage *closeImg = [UIImage imageWithData:closeImgData];
    _closeImg = closeImg;
    if(!(bgImg && carImg && logoImg && wheelImg1 && closeImg)) {
        _canGetView = NO;
        return;
    }
    NSMutableDictionary *tempDataDict =
    [NSMutableDictionary dictionaryWithDictionary:dataDict];
    NSMutableDictionary *tempContentDict =
    [NSMutableDictionary dictionaryWithDictionary:contentDict];
    NSMutableDictionary *tempWheelImgDict =
    [NSMutableDictionary dictionaryWithDictionary:wheelImgDict];
    [tempWheelImgDict setValue:wheelImg1 forKey:@"url"];
    NSMutableDictionary *tempCarDict =
    [NSMutableDictionary dictionaryWithDictionary:carImgDict];
    [tempCarDict setValue:carImg forKey:@"url"];
    NSMutableDictionary *tempLogoImgDict =
    [NSMutableDictionary dictionaryWithDictionary:logoImgDict];
    [tempLogoImgDict setValue:logoImg forKey:@"url"];
    NSMutableDictionary *tempBgImgDict =
    [NSMutableDictionary dictionaryWithDictionary:bgImgDict];
    [tempBgImgDict setValue:bgImg forKey:@"url"];
    
    [tempContentDict setValue:tempCarDict forKey:@"carImg"];
    [tempContentDict setValue:tempWheelImgDict forKey:@"wheelImg"];
    [tempContentDict setValue:tempLogoImgDict forKey:@"logoImg"];
    [tempContentDict setValue:tempBgImgDict forKey:@"backImg"];
    [tempDataDict setValue:tempContentDict forKey:@"content"];
    _dataDict = [NSDictionary dictionaryWithDictionary:tempDataDict];
    NSMutableDictionary *dict = [self.callback getExtra];
    NSNumber *timeOut = [dict valueForKey:@"sceneDelayCloseTimeout"];
    if (timeOut) _delayCloseTimeInterval = [timeOut integerValue];
    
    _configDict = [self.callback getSceneConfig];
    _allowStop = ![_configDict[@"clickPopup"] boolValue];
}
- (UIView *)getView {
    if (!_canGetView) return nil;
    UIView *view = [[UIView alloc] init];
    _view = view;
    NSDictionary *dataDict = _dataDict;
    NSDictionary *contentDict = dataDict[@"content"];
    NSDictionary *carImgDict = contentDict[@"carImg"];
    NSDictionary *wheelImgDict = contentDict[@"wheelImg"];
    NSDictionary *logoImgDict = contentDict[@"logoImg"];
    NSDictionary *bgImgDict = contentDict[@"backImg"];
    
    CGSize carImgSize =
    CGSizeMake([self getResizeValue:[carImgDict[@"width"] floatValue] / 3],
               [self getResizeValue:[carImgDict[@"height"] floatValue] / 3]);
    CGSize wheelImgSize = CGSizeMake(
                                     [self getResizeValue:[wheelImgDict[@"width"] floatValue] / 3],
                                     [self getResizeValue:[wheelImgDict[@"height"] floatValue] / 3]);
    CGSize logoImgSize =
    CGSizeMake([self getResizeValue:[logoImgDict[@"width"] floatValue] / 3],
               [self getResizeValue:[logoImgDict[@"height"] floatValue] / 3]);
    CGSize bgImgSize =
    CGSizeMake([self getResizeValue:[bgImgDict[@"width"] floatValue] / 3],
               [self getResizeValue:[bgImgDict[@"height"] floatValue] / 3]);
    
    NSString *text = contentDict[@"textWriter"];
    NSString *textColor = contentDict[@"textColor"];
    CGFloat xAxis1 =
    [self getResizeValue:[contentDict[@"xAxis1"] floatValue] / 3];
    CGFloat yAxis1 =
    [self getResizeValue:[contentDict[@"yAxis1"] floatValue] / 3];
    CGFloat xAxis2 =
    [self getResizeValue:[contentDict[@"xAxis2"] floatValue] / 3];
    
    UIImage *bgImg = bgImgDict[@"url"];
    UIImage *carImg = carImgDict[@"url"];
    UIImage *logoImg = logoImgDict[@"url"];
    UIImage *wheelImg1 = wheelImgDict[@"url"];
    
    _bgView = [[UIImageView alloc] initWithImage:bgImg];
    _carView = [[UIImageView alloc] initWithImage:carImg];
    _logoView = [[UIImageView alloc] initWithImage:logoImg];
    _wheelViewLeft = [[UIImageView alloc] initWithImage:wheelImg1];
    _wheelViewRight = [[UIImageView alloc] initWithImage:wheelImg1];
    _desLabel = [[UILabel alloc] init];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setBackgroundImage:_closeImg forState:UIControlStateNormal];
    [_closeBtn addTarget:self
                  action:@selector(closeBtnClicked)
        forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:_bgView];
    [_view addSubview:_carView];
    [_view addSubview:_logoView];
    [_view addSubview:_wheelViewLeft];
    [_view addSubview:_wheelViewRight];
    [_view addSubview:_desLabel];
    
    CGFloat fontSize = 14;
    if([UIScreen mainScreen].bounds.size.width == 375) fontSize = 13;
    if ([UIScreen mainScreen].bounds.size.width == 320) fontSize = 11.0;
    _desLabel.font = [UIFont systemFontOfSize:fontSize];
    _desLabel.text = text;
    _desLabel.textColor = [STUtils colorWithHexString:textColor];
    
    CGFloat wheelByCarY = yAxis1 + wheelImgSize.height - carImgSize.height;
    CGFloat wheelByCarLeftX = xAxis1;
    CGFloat wheelByCarRightX = xAxis2;
    CGFloat yOffSet = [_configDict[@"yOffset"] integerValue] / 100.0;
    CGFloat containerViewY = [UIScreen mainScreen].bounds.size.height * yOffSet;
    
    CGFloat viewHeight = bgImgSize.height + carImgSize.height + wheelByCarY +
    [self getResizeValue:26];
    CGFloat viewWidth = bgImgSize.width + carImgSize.width;
    view.bounds = CGRectMake(0, 0, viewWidth, viewHeight);
    _bgView.frame = CGRectMake(0, viewHeight - bgImgSize.height, bgImgSize.width,
                               bgImgSize.height);
    _logoView.bounds = CGRectMake(0, 0, logoImgSize.width, logoImgSize.height);
    _logoView.center = CGPointMake(
                                   [self getResizeValue:logoImgSize.width / 2 + 6], _bgView.center.y);
    _desLabel.frame =
    CGRectMake(CGRectGetMaxX(_logoView.frame) + [self getResizeValue:3],
               _logoView.frame.origin.y,
               bgImgSize.width - logoImgSize.width - [self getResizeValue:3],
               logoImgSize.height);
    _carView.frame =
    CGRectMake(CGRectGetMaxX(_bgView.frame),
               CGRectGetMinY(_bgView.frame) - wheelByCarY - carImgSize.height,
               carImgSize.width, carImgSize.height);
    _wheelViewLeft.frame =
    CGRectMake(CGRectGetMinX(_carView.frame) + wheelByCarLeftX,
               CGRectGetMinY(_bgView.frame) - wheelImgSize.height,
               wheelImgSize.width, wheelImgSize.height);
    _wheelViewRight.frame = CGRectMake(
                                       CGRectGetMinX(_carView.frame) + wheelByCarRightX,
                                       _wheelViewLeft.frame.origin.y, wheelImgSize.width, wheelImgSize.height);
    
    _closeBtn.hidden = YES;
    _bgImgLength = bgImgSize.width;
    _logoImgLength = CGRectGetMinX(_desLabel.frame);
    
    _bgView.userInteractionEnabled = YES;
    _carView.userInteractionEnabled = YES;
    _logoView.userInteractionEnabled = YES;
    _wheelViewLeft.userInteractionEnabled = YES;
    _wheelViewRight.userInteractionEnabled = YES;
    
    UIView *containerView = [[UIView alloc] init];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    containerView.frame = CGRectMake(
                                     screenWidth - bgImgSize.width, containerViewY,
                                     view.frame.size.width + bgImgSize.width, view.frame.size.height);
    [containerView addSubview:view];
    view.frame = CGRectMake(bgImgSize.width, 0, view.bounds.size.width,
                            view.bounds.size.height);
    
    [containerView addSubview:_closeBtn];
    _closeBtn.frame = CGRectMake(
                                 bgImgSize.width - [self getResizeValue:26] - [self getResizeValue:5], 0,
                                 [self getResizeValue:26], [self getResizeValue:26]);
    _containerView = containerView;
    
    _logoBufferView = [[UIView alloc]
                       initWithFrame:CGRectMake(
                                                _logoView.frame.origin.x,
                                                _logoView.frame.origin.y - _logoView.frame.size.height,
                                                _logoView.frame.size.width,
                                                _logoView.frame.size.height * 2)];
    [view addSubview:_logoBufferView];
    return containerView;
}
- (void)autoClose {
    [self.timer start];
    _autoClosetimer = [NSTimer timerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(timerFunc)
                                            userInfo:nil
                                             repeats:YES];
    [_autoClosetimer fire];
    [[NSRunLoop currentRunLoop] addTimer:_autoClosetimer
                                 forMode:NSRunLoopCommonModes];
}
- (void)timerFunc {
    if ([self.timer getTotal] >= _delayCloseTimeInterval) {
        [self closeBtnAction:1];
        [self stopTimer];
        [self.timer stop];
    } else {
        if ([self.timer getTotal] / 1000 % 5 == 0) {
            [self startLogoShakeAnimation];
        }
    }
}
- (void)addTapGestureForView:(UIView *)view action:(SEL)action {
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
    if ([view isEqual:_logoBufferView]) {
        _logoTap = tap;
    }
    if ([view isEqual:_containerView]) {
        _containerTap = tap;
    }
}
- (void)logoTap {
    [self stopTimer];
    [_logoView.layer removeAnimationForKey:@"logoShake"];
    [_bgView.layer removeAnimationForKey:@"bgShake"];
    [_logoBufferView removeGestureRecognizer:_logoTap];
    [self addTapGestureForView:_containerView action:@selector(tap)];
    [self startBgAnimation:_bgImgLength - _logoImgLength];
    
    [self.callback onShow];
}
- (void)stopTimer {
    if (_autoClosetimer) {
        [_autoClosetimer invalidate];
        _autoClosetimer = nil;
    }
}
- (void)tap {
    [self.callback onClick];
}
- (void)closeBtnClicked {
    [self closeBtnAction:2];
}
- (void)closeBtnAction:(int)closeType {
    [self.callback onClose];
    [self.callback postCloseLogWithType:closeType];
    
    [self stopTimer];
}
#pragma mark - get animation
- (CABasicAnimation *)getBasicAnimationWithkeyPath:(NSString *)keyPath
                                          duration:(CGFloat)duration
                                       repeatCount:(CGFloat)count
                                               key:(NSString *)key
                                       autoreverse:(BOOL)reverse
                               removedOnCompletion:(BOOL)removed
                                         fromValue:(id)fromValue
                                           toValue:(id)toValue
                                           byValue:(id)byValue
                                          delegate:(id)delegate {
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = keyPath;
    animation.duration = duration;
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.byValue = byValue;
    animation.autoreverses = reverse;
    animation.repeatCount = count;
    animation.delegate = delegate;
    if (!removed) {
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
    }
    [animation setValue:key forKey:key];
    return animation;
}
- (CABasicAnimation *)getBasicAnimationWithkeyPath:(NSString *)keyPath
                                          duration:(CGFloat)duration
                                               key:(NSString *)key
                                           toValue:(id)toValue
                                       autoreverse:(BOOL)reverse
                               removedOnCompletion:(BOOL)removed
                                          delegate:(id)delegate {
    return [self getBasicAnimationWithkeyPath:keyPath
                                     duration:duration
                                  repeatCount:0
                                          key:key
                                  autoreverse:reverse
                          removedOnCompletion:removed
                                    fromValue:nil
                                      toValue:toValue
                                      byValue:nil
                                     delegate:delegate];
}
- (CAAnimationGroup *)getGroupAnimation:(NSArray *)animations
                               duration:(CGFloat)duration
                                    key:(NSString *)key
                    removedOnCompletion:(BOOL)removed
                               delegate:(id)delegate {
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = animations;
    group.duration = duration;
    if (!removed) {
        group.removedOnCompletion = NO;
        group.fillMode = kCAFillModeForwards;
    }
    group.delegate = delegate;
    [group setValue:key forKey:key];
    return group;
}
#pragma mark - animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([anim.delegate hash] != self.hash) return;
    if ([anim valueForKey:@"bgView"]) {
        if (_curLeftMove == _logoImgLength) {
            [self changeMoveFrame:_view length:_bgImgLength - _logoImgLength];
        } else {
            [self changeMoveFrame:_view length:_bgImgLength];
        }
        _curLeftMove = _bgImgLength;
        [self startCarAnimation:_bgImgLength + [self getResizeValue:12]];
    } else if ([anim valueForKey:@"car"]) {
        [self changeMoveFrame:_carView
                       length:_bgImgLength + [self getResizeValue:12]];
        [self startCarStopAnimation];
    } else if ([anim valueForKey:@"wheelLeft"]) {
        [self changeMoveFrame:_wheelViewLeft
                       length:_bgImgLength + [self getResizeValue:12]];
    } else if ([anim valueForKey:@"wheelRight"]) {
        [self changeMoveFrame:_wheelViewRight
                       length:_bgImgLength + [self getResizeValue:12]];
    } else if ([anim valueForKey:@"logoView"]) {
        [self changeMoveFrame:_view length:_logoImgLength];
        [self autoClose];
    } else if ([anim valueForKey:@"carRotation"]) {
    }
}
- (void)changeMoveFrame:(UIView *)view length:(CGFloat)moveLength {
    view.frame = CGRectMake(view.frame.origin.x - moveLength, view.frame.origin.y,
                            view.frame.size.width, view.frame.size.height);
}
- (void)applyMoveAnimation:(UIView *)view
                moveLength:(CGFloat)length
                  duration:(CGFloat)duration
                       key:(NSString *)key {
    NSValue *fromValue =
    [NSValue valueWithCGPoint:CGPointMake([view center].x, [view center].y)];
    NSValue *toValue = [NSValue
                        valueWithCGPoint:CGPointMake([view center].x - length, [view center].y)];
    
    CABasicAnimation *animation = [self getBasicAnimationWithkeyPath:@"position"
                                                            duration:duration
                                                         repeatCount:0
                                                                 key:key
                                                         autoreverse:NO
                                                 removedOnCompletion:NO
                                                           fromValue:fromValue
                                                             toValue:toValue
                                                             byValue:nil
                                                            delegate:self];
    [view.layer addAnimation:animation forKey:key];
}
- (void)applyMoveAndRotateAnimation:(UIView *)view
                         moveLength:(CGFloat)length
                          durations:(CGFloat)duration
                                key:(NSString *)key {
    CGFloat originX = view.layer.position.x;
    CGFloat originY = view.layer.position.y;
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(originX, originY)];
    NSValue *value2 =
    [NSValue valueWithCGPoint:CGPointMake(originX - length * 0.3, originY)];
    NSValue *value3 =
    [NSValue valueWithCGPoint:CGPointMake(originX - length, originY)];
    NSArray *values = @[ value1, value2, value3 ];
    
    CAKeyframeAnimation *animation =
    [self getKeyFrameAnimationWithKeyPath:@"position"
                                      key:nil
                                   values:values
                                 keyTimes:@[ @(0), @(0.5), @(1.0) ]
                                 duration:0
                              repeatCount:0
                              autoreverse:NO
                      removedOnCompletion:NO
                                 delegate:nil];
    
    CABasicAnimation *rotationAnimation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.byValue = [NSNumber numberWithFloat:M_PI * 2.0];  // byValue
    CAAnimationGroup *group =
    [self getGroupAnimation:@[ animation, rotationAnimation ]
                   duration:duration
                        key:key
        removedOnCompletion:NO
                   delegate:self];
    [view.layer addAnimation:group forKey:key];
}
- (void)startCarStopAnimation {
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat:-M_PI * 0.01];
    
    CABasicAnimation *animation2 =
    [CABasicAnimation animationWithKeyPath:@"position"];
    animation2.toValue =
    [NSValue valueWithCGPoint:CGPointMake(_carView.layer.position.x - 2,
                                          _carView.layer.position.y)];
    CAAnimationGroup *group = [self getGroupAnimation:@[ animation, animation2 ]
                                             duration:0.2
                                                  key:@"carRotation"
                                  removedOnCompletion:YES
                                             delegate:self];
    [_carView.layer addAnimation:group forKey:@"carRotation"];
}
- (void)applyCarAnimation:(CGFloat)leftLength {
    CAKeyframeAnimation *animation =
    [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGFloat originX = _carView.layer.position.x;
    CGFloat originY = _carView.layer.position.y;
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(originX, originY)];
    NSValue *value2 = [NSValue
                       valueWithCGPoint:CGPointMake(originX - leftLength * 0.3, originY)];
    NSValue *value3 =
    [NSValue valueWithCGPoint:CGPointMake(originX - leftLength, originY)];
    NSArray *values = @[ value1, value2, value3 ];
    animation.values = values;
    animation.keyTimes = @[ @(0), @(0.5), @(1.0) ];
    animation.autoreverses = NO;
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 1.5;
    [animation setValue:@"car" forKey:@"car"];
    [_carView.layer addAnimation:animation forKey:@"car"];
}
- (void)startBgAnimation:(CGFloat)leftLength {
    _closeBtn.hidden = NO;
    [self applyMoveAnimation:_view
                  moveLength:leftLength
                    duration:1.0
                         key:@"bgView"];
}
- (void)startCarAnimation:(CGFloat)leftLength {
    [self applyCarAnimation:leftLength];
    [self applyMoveAndRotateAnimation:_wheelViewLeft
                           moveLength:leftLength
                            durations:1.5
                                  key:@"wheelLeft"];
    [self applyMoveAndRotateAnimation:_wheelViewRight
                           moveLength:leftLength
                            durations:1.5
                                  key:@"wheelRight"];
}
- (void)startLogoAnimation:(CGFloat)leftLength {
    [self applyMoveAnimation:_view
                  moveLength:leftLength
                    duration:0.5
                         key:@"logoView"];
}
- (NSArray *)getValusForLogoShake:(CGPoint)point {
    CGFloat originX = point.x;
    CGFloat originY = point.y;
    NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(originX, originY)];
    NSValue *value2 = [NSValue
                       valueWithCGPoint:CGPointMake(originX,
                                                    originY + [self getResizeValue:2.5])];
    NSValue *value3 = [NSValue
                       valueWithCGPoint:CGPointMake(originX,
                                                    originY - [self getResizeValue:2.5])];
    NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(originX, originY)];
    NSArray *values = @[ value1, value2, value3, value4 ];
    return values;
}
- (void)startLogoShakeAnimation {
    NSArray *logoShakeValues =
    [self getValusForLogoShake:_logoView.layer.position];
    CAKeyframeAnimation *logoShakeAnimation =
    [self getKeyFrameAnimationWithKeyPath:@"position"
                                      key:@"logoShake"
                                   values:logoShakeValues
                                 keyTimes:@[ @(0), @(0.33), @(0.66), @(1.0) ]
                                 duration:0.2
                              repeatCount:1
                              autoreverse:YES
                      removedOnCompletion:YES
                                 delegate:self];
    NSArray *bgShakeValues = [self getValusForLogoShake:_bgView.layer.position];
    CAKeyframeAnimation *bgShakeAnimation =
    [self getKeyFrameAnimationWithKeyPath:@"position"
                                      key:@"bgShake"
                                   values:bgShakeValues
                                 keyTimes:@[ @(0), @(0.33), @(0.66), @(1.0) ]
                                 duration:0.2
                              repeatCount:1
                              autoreverse:YES
                      removedOnCompletion:YES
                                 delegate:self];
    
    [_bgView.layer addAnimation:bgShakeAnimation forKey:@"bgShake"];
    [_logoView.layer addAnimation:logoShakeAnimation forKey:@"logoShake"];
}
- (CAKeyframeAnimation *)getKeyFrameAnimationWithKeyPath:(NSString *)keypath
                                                     key:(NSString *)key
                                                  values:(NSArray *)values
                                                keyTimes:(NSArray *)keyTimes
                                                duration:(CGFloat)duration
                                             repeatCount:(CGFloat)count
                                             autoreverse:(BOOL)reverse
                                     removedOnCompletion:(BOOL)removed
                                                delegate:(id)delegate {
    CAKeyframeAnimation *animation =
    [CAKeyframeAnimation animationWithKeyPath:keypath];
    animation.values = values;
    animation.keyTimes = keyTimes;
    animation.duration = duration;
    animation.repeatCount = count;
    animation.autoreverses = reverse;
    if (!removed) {
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
    }
    animation.delegate = delegate;
    [animation setValue:key forKey:key];
    return animation;
}
@end
