//
//  HeaderView.m
//  SceneAnimation
//
//  Created by 罗富中 on 16/5/25.
//  Copyright © 2016年 socialtouch. All rights reserved.
//

#import "HeaderView.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation HeaderView {
    NSArray *_dataArray;
    UIButton *_curBtn;
    UIView *_flagLine;
    NSMutableArray *_btnArray;
}
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    if(self = [super initWithFrame:frame]){
        _dataArray = [NSArray arrayWithArray:titles];
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    _btnArray = [NSMutableArray array];
    CGFloat leftMagin = 32;
    CGFloat btnWidth = 50;
    CGFloat btnMagin = (KScreenWidth - leftMagin * 2 - _dataArray.count*btnWidth) /
    (_dataArray.count - 1);
    
    for (int i = 0; i < _dataArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftMagin + (btnWidth + btnMagin) * i, 0, btnWidth,
                               self.frame.size.height);
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [btn setTitle:_dataArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [btn addTarget:self
                action:@selector(btnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 10000 + i;
        [self addSubview:btn];
        if (i == 0) {
            _curBtn = btn;
            _curBtn.selected = YES;
        }
        [_btnArray addObject:btn];
    }
    
    UIView *flagLine = [[UIView alloc]
                        initWithFrame:CGRectMake(_curBtn.frame.origin.x,
                                                 self.frame.size.height - 2, btnWidth, 1)];
    flagLine.backgroundColor = [UIColor blueColor];
    [self addSubview:flagLine];
    _flagLine = flagLine;
    
    UIView *seperatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    seperatorLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:seperatorLine];
}
- (void)btnClicked:(UIButton *)sender {
    [self setBtnIndex:sender.tag - 10000];
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(clickAtIndex:)]) {
        [self.delegate clickAtIndex:sender.tag - 10000];
    }
}

- (void)setBtnIndex:(NSInteger)index {
    if (_curBtn.tag - 10000 == index) return;
    UIButton *btn = _btnArray[index];
    UIButton *sender = btn;
    sender.selected = YES;
    _curBtn.selected = NO;
    _curBtn = sender;
    
    CGRect origionFrame = _flagLine.frame;
    CGRect btnFrame = sender.frame;
    
    CGFloat changX = btnFrame.origin.x;
    CGFloat width = btnFrame.size.width;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         CGRect curFrame =
                         CGRectMake(changX, origionFrame.origin.y, width,
                                    origionFrame.size.height);
                         _flagLine.frame = curFrame;
                     }];
}


@end
