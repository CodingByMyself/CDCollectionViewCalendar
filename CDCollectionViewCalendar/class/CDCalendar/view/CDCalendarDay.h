//
//  CDCalendarDay.h
//  CDCollectionViewCalendar
//
//  Created by Cindy on 16/6/27.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendarDayView.h"

@interface CDCalendarDay : JTCalendarDayView

@property (nonatomic, readonly) UIView *customView;

@property (nonatomic, readonly) UILabel *labelTitle;
@property (nonatomic, readonly) UILabel *labelDescription;

@property (nonatomic, readonly) UIView *circleViewBg;


- (void)commonInit;

@end
