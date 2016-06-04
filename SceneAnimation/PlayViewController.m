//
//  PlayViewController.m
//  AdSDKSampleApp
//
//  Created by 罗富中 on 16/5/25.
//  Copyright © 2016年 wumeizhen. All rights reserved.
//

#import "PlayViewController.h"


@interface PlayViewController ()
{
    NSString *_adSpaceId;
}
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setViewBgColor:(UIColor *)bgColor
{
    if (bgColor) {
        self.view.backgroundColor = bgColor;
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
}

@end
