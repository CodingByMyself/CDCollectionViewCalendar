//
//  CDCalendarDay.m
//  CDCollectionViewCalendar
//
//  Created by Cindy on 16/6/27.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#import "CDCalendarDay.h"
#import "Masonry.h"

@interface CDCalendarDay ()

@property (nonatomic, assign) CGFloat circleBgRatio;

@end


@implementation CDCalendarDay

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}



- (void)setCustomView:(UIView *)customView
{
    if (_customView != customView) {
        _customView = customView;
        _customView.frame = self.bounds;
    }
}

#pragma mark - 重载
- (void)commonInit
{
//    [super commonInit];  // 调用一下父类的实现
    
    self.clipsToBounds = YES;
    _customView = [[UIView alloc] init];
//    _customView.backgroundColor = [UIColor yellowColor];
    [self addSubview:_customView];
    [_customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    
    {
        _circleBgRatio = 1.0;
        _circleViewBg = [[UIView alloc] init];
        [_customView addSubview:_circleViewBg];
        
        _circleViewBg.backgroundColor = [UIColor colorWithRed:0x33/256. green:0xB3/256. blue:0xEC/256. alpha:.5];
        _circleViewBg.hidden = YES;
        
        _circleViewBg.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _circleViewBg.layer.shouldRasterize = YES;
    }
    
    {
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.textColor = [UIColor blackColor];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.font = [UIFont fontWithName:@"Avenir-Medium" size:15];
        [_customView addSubview:_labelTitle];
        [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_customView);
            make.left.equalTo(_customView);
            make.right.equalTo(_customView);
            make.height.equalTo(@(_customView.bounds.size.height/2.0));
        }];
        
        _labelDescription = [[UILabel alloc] init];
        _labelDescription.textColor = [UIColor orangeColor];
        _labelDescription.textAlignment = NSTextAlignmentCenter;
        _labelDescription.font = [UIFont fontWithName:@"Avenir-Medium" size:10];
        [_customView addSubview:_labelDescription];
        [_labelDescription mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_labelTitle.mas_bottom);
            make.left.equalTo(_customView);
            make.right.equalTo(_customView);
            make.bottom.equalTo(_customView);
        }];
    }

    {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchItem)];
        
        _customView.userInteractionEnabled = YES;
        [_customView addGestureRecognizer:gesture];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    _customView.frame = self.bounds;
    [_labelTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(_customView.bounds.size.height/2.0));
    }];
    
    CGFloat sizeCircle = MIN(_customView.bounds.size.width, _customView.bounds.size.height);
    CGFloat sizeDot = sizeCircle;
    
    sizeCircle = sizeCircle * _circleBgRatio;
    
    sizeCircle = roundf(sizeCircle);
    sizeDot = roundf(sizeDot);
    
    _circleViewBg.frame = CGRectMake(0, 0, sizeCircle, sizeCircle);
    _circleViewBg.center = CGPointMake(_customView.frame.size.width / 2., _customView.frame.size.height / 2.);
    _circleViewBg.layer.cornerRadius = sizeCircle / 2.;
}

- (void)reload
{
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [self.manager.dateHelper createDateFormatter];
        [dateFormatter setDateFormat:@"dd"];
    }
    
    _labelTitle.text = [dateFormatter stringFromDate:self.date];
    
    [self.manager.delegateManager prepareDayView:self];
}

- (void)didTouchItem
{
    [self.manager.delegateManager didTouchDayView:self];
}

@end
