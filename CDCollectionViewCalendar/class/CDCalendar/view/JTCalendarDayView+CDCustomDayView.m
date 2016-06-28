//
//  JTCalendarDayView+CDCustomDayView.m
//  CDCollectionViewCalendar
//
//  Created by Cindy on 16/6/28.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#import "JTCalendarDayView+CDCustomDayView.h"
#import "Masonry.h"

@implementation JTCalendarDayView (CDCustomDayView)


- (void)initCustomView
{
    [self bringSubviewToFront:self.circleView];
    
    // 显示view
    UIView *showView = [[UIView alloc] init];
    showView.tag = 100;
    showView.backgroundColor = [UIColor clearColor];
    [self addSubview:showView];
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    // 日期标题
    [self.textLabel removeFromSuperview];
    [showView addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showView);
        make.right.equalTo(showView);
        make.height.equalTo(@(16.0));
        make.centerY.equalTo(@(-6.0));
    }];
    
    //  副标题
    UILabel *labelDescription = [[UILabel alloc] init];
    labelDescription.tag = 102;
    labelDescription.textColor = [UIColor orangeColor];
    labelDescription.textAlignment = NSTextAlignmentCenter;
    labelDescription.font = [UIFont fontWithName:@"Avenir-Medium" size:10];
    [showView addSubview:labelDescription];
    [labelDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(showView);
        make.right.equalTo(showView);
        make.height.equalTo(@(15.0));
        make.centerY.equalTo(@(7.0));
    }];
    
    [self layoutIfNeeded];
}

#pragma mark -
- (void)setDescriptionText:(NSString *)description
{
    UIView *showView = [self viewWithTag:100];
    UILabel *labelDescription = [showView viewWithTag:102];
    labelDescription.text = description;
}

- (void)setDescriptionTextColor:(UIColor *)color
{
    UIView *showView = [self viewWithTag:100];
    UILabel *labelDescription = [showView viewWithTag:102];
    labelDescription.textColor = color;
}

- (void)setDescriptionFont:(UIFont *)font
{
    UIView *showView = [self viewWithTag:100];
    UILabel *labelDescription = [showView viewWithTag:102];
    labelDescription.font = font;
}

@end
