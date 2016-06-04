//
//  HeaderView.h
//  SceneAnimation
//
//  Created by 罗富中 on 16/5/25.
//  Copyright © 2016年 socialtouch. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HeaderViewDelegate <NSObject>

-(void) clickAtIndex:(NSInteger)index;

@end

@interface HeaderView : UIView
@property(nonatomic,nullable,assign) id<HeaderViewDelegate> delegate;
-(instancetype) initWithFrame:(CGRect) frame titles:(NSArray *)titles;
- (void)setBtnIndex:(NSInteger)index;
@end
