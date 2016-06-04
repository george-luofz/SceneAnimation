//
//  STSceneAdCallback.h
//  STAdSDK
//
//  Created by 程思源 on 16/4/28.
//  Copyright © 2016年 socialtouch. All rights reserved.
//

#ifndef STSceneAdCallback_h
#define STSceneAdCallback_h

extern const NSInteger kSTSceneAdApiLevel;

@protocol STSceneAdCallback
@optional
- (void)onClick;
- (void)onClose;
- (void)onShow;
- (NSData *)getDataFromUrl:(NSString *)url enableCache:(BOOL)enableCache;
- (void)logInfoWithMessage:(NSString *)message;
- (void)logErrorWithMessage:(NSString *)message error:(NSError *)error;
- (void)postCloseLogWithType:(int)type;
- (NSDictionary *)getSceneAdData;
- (NSDictionary *)getSceneConfig;
- (NSMutableDictionary *)getExtra;
@end

#endif /* STSceneAdCallback_h */
