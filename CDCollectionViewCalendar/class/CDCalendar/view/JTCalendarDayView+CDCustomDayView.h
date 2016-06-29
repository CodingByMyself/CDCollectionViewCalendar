//
//  JTCalendarDayView+CDCustomDayView.h
//  CDCollectionViewCalendar
//
//  Created by Cindy on 16/6/28.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#import "JTCalendarDayView.h"

@interface JTCalendarDayView (CDCustomDayView)


- (void)initCustomView; //

- (void)setDescriptionText:(NSString *)description;
- (void)setDescriptionTextColor:(UIColor *)color;
- (void)setDescriptionFont:(UIFont *)font;
- (void)updateDayViewConstraintWithDescription:(NSString *)descr;

@end

