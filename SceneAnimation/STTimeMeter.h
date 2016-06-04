//
//  STTimeMeter.h
//  STAdSDK
//
//  Created by 罗富中 on 16/5/13.
//  Copyright © 2016年 socialtouch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STTimeMeter : NSObject

- (void)start;
- (void)stop;
- (void)pause;
- (NSInteger)getTotal;
@end
