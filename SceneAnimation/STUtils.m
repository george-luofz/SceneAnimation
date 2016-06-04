//
//  STUtils.m
//  STAdSDK
//
//  Created by 程思源 on 16/2/12.
//  Copyright © 2016年 socialtouch. All rights reserved.
//
#import "STUtils.h"

@implementation STUtils

+ (BOOL)openWithURL:(NSURL *)URL {
    UIApplication *application = [UIApplication sharedApplication];
    return [application openURL:URL];
}

+ (void)runOnMainThread:(dispatch_block_t)block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    }
}

+ (void)runOnSubthread:(dispatch_block_t)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       block();
                   });
}

+ (NSData *)getDataWithUrl:(NSURL *)url {
    NSURLRequest *request =
    [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:60];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil
                                                     error:nil];
    return data;
}
+ (UIColor *)colorWithHexString:(NSString *)hex {
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [hex substringWithRange:range];
    range.location = 2;
    NSString *gString = [hex substringWithRange:range];
    range.location = 4;
    NSString *bString = [hex substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0];
}
+ (long long)_getJavaTimestamp {
    return [[NSDate date] timeIntervalSince1970] * 1000;
}
@end