//
//  STUtils.h
//  STAdSDK
//
//  Created by 程思源 on 16/2/12.
//  Copyright © 2016年 socialtouch. All rights reserved.
//


#ifndef STUtils_h
#define STUtils_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface STUtils : NSObject

+ (long long)_getJavaTimestamp;

+ (void)runOnMainThread:(dispatch_block_t)block;

+ (void)runOnSubthread:(dispatch_block_t)block;

+ (NSData *)getDataWithUrl:(NSURL *)url;

+ (UIColor *)colorWithHexString:(NSString *)hex;

@end

#endif /* STUtils_h */
