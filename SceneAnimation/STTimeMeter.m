//
//  STTimeMeter.m
//  STAdSDK
//
//  Created by 罗富中 on 16/5/13.
//  Copyright © 2016年 socialtouch. All rights reserved.
//

#import "STTimeMeter.h"
#import "STUtils.h"
@implementation STTimeMeter {
    long long _historyTime;
    long long _pauseTime;
    long long _startTime;
    BOOL _isPaused;
}

- (void)start {
    @synchronized(self) {
        _isPaused = NO;
        _startTime = [STUtils _getJavaTimestamp];
        _historyTime = 0;
        _pauseTime = 0;
    }
}
- (void)stop {
    @synchronized(self) {
        _startTime = 0;
        _pauseTime = 0;
        _historyTime = 0;
        _isPaused = NO;
    }
}
- (void)pause {
    @synchronized(self) {
        _pauseTime = [STUtils _getJavaTimestamp];
        _isPaused = YES;
        _historyTime += (_pauseTime - _startTime);
    }
}
- (NSInteger)getTotal {
    @synchronized(self) {
        long long total = _historyTime;
        if (!_isPaused) {
            total += ([STUtils _getJavaTimestamp] - _startTime);
        }
        return (NSInteger)total;
    }
}
@end
