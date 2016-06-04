//
//  ContainerViewController.m
//  AdSDKSampleApp
//
//  Created by 罗富中 on 16/5/25.
//  Copyright © 2016年 wumeizhen. All rights reserved.
//

#import "ContainerViewController.h"
#import "PlayViewController.h"
#import "HeaderView.h"
#import "STAnimationService.h"
#import "AppDelegate.h"
#import "STCarSceneAdPlayer.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ContainerViewController () <HeaderViewDelegate,
UIScrollViewDelegate> {
    HeaderView *_header;
    UIScrollView *_containerView;
    NSArray *_adspaceIdArr;
    NSArray *_bgColorArr;
    
    PlayViewController *_curPlayVc;
    NSMutableArray *_vcArr;
    CGPoint _curOffSet;
    NSInteger _curIndex;
    STAnimationService *_service;
}
@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"tab 页面1";
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *titleArr = @[ @"汽车", @"娱乐", @"图片", @"视频" ];
    
    
    
    HeaderView *header =
    [[HeaderView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, 44)
                               titles:titleArr];
    [self.view addSubview:header];
    header.delegate = self;
    _header = header;
    UIScrollView *containerView = [[UIScrollView alloc]
                                   initWithFrame:CGRectMake(0, CGRectGetMaxY(header.frame), KScreenWidth,
                                                            KScreenHeight - CGRectGetMaxY(header.frame))];
    containerView.contentSize = CGSizeMake(4 * KScreenWidth, 0);
    containerView.showsHorizontalScrollIndicator = NO;
    containerView.pagingEnabled = YES;
    containerView.bounces = NO;
    containerView.delegate = self;
    [self.view addSubview:containerView];
    _containerView = containerView;
    
    _adspaceIdArr = @[ @"1000067", @"1000068", @"1000080", @"1000081" ];
    _bgColorArr = @[
                    [UIColor cyanColor],
                    [UIColor orangeColor],
                    [UIColor brownColor],
                    [UIColor purpleColor]
                    ];
    _vcArr = [NSMutableArray arrayWithCapacity:_adspaceIdArr.count];
    for (int i = 0; i < _adspaceIdArr.count; i++) {
        [self addSceneAdVc:i];
    }
    _curOffSet = CGPointMake(0, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_service enableAnimation:_adspaceIdArr[_curIndex]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)addSceneAdVc:(NSInteger)index {
    PlayViewController *playVc = [[PlayViewController alloc] init];
    [_vcArr addObject:playVc];
    [playVc setViewBgColor:_bgColorArr[index]];
    [self addChildViewController:playVc];
    if (index == 0) {
        _curPlayVc = playVc;
        _curIndex = index;
    }
    UIView *vc = playVc.view;
    vc.frame = CGRectMake(index * KScreenWidth, 0, KScreenWidth,
                          _containerView.frame.size.height);
    [_containerView addSubview:vc];
    
    if(!_service){
        STAnimationService *service = [STAnimationService shareInstance];
        _service = service;
    }
    [_service createAnimation:_adspaceIdArr[index] viewController:playVc];
}

- (void)clickAtIndex:(NSInteger)index {
    _curIndex = index;
    [_containerView setContentOffset:CGPointMake(KScreenWidth * index, 0)
                            animated:NO];
    _curOffSet = CGPointMake(index * KScreenWidth, 0);
    [self transitionViewConttoller:index];
}
- (void)transitionViewConttoller:(NSInteger)index {
    [_service enableAnimation:_adspaceIdArr[index]];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self endScoll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    
    if (!decelerate) {
        [self endScoll:scrollView];
    }
}
- (void)endScoll:(UIScrollView *)scrollView {
    CGPoint offSet = scrollView.contentOffset;
    _curOffSet = offSet;
    int index = offSet.x / KScreenWidth;
    _curIndex = index;
    [_header setBtnIndex:index];
    [self transitionViewConttoller:index];
}
@end
