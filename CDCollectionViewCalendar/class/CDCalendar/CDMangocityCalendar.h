//
//  CDMangocityCalendar.h
//  CDCollectionViewCalendar
//
//  Created by Cindy on 16/6/28.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "JTCalendarDayView+CDCustomDayView.h"
#import "Masonry.h"

@protocol CDMangocityCalendarViewDelegate;
@interface CDMangocityCalendar : UIView

@property (nonatomic,weak) id <CDMangocityCalendarViewDelegate> delegate;

@property (nonatomic,strong) JTCalendarManager *calendarManager;

@property (nonatomic,strong) NSDate *minDate;
@property (nonatomic,strong) NSDate *maxDate;
@property (nonatomic,readonly) NSDate *todayDate;
@property (nonatomic,readonly) NSDate *dateSelected;   //  单选模式
@property (nonatomic,readonly) NSMutableArray *datesSelected;   //  多选模式



#pragma mark public method
- (void)showCalendarWithTargetView:(UIView *)targetView;
- (void)hiddenCalendar;
@end


@protocol CDMangocityCalendarViewDelegate <NSObject>

- (NSString *)mangocityCalendar:(UIView *)calendar descriptionStringOnDay:(NSDate *)date;
- (void)mangocityCalendar:(UIView *)calendar didTouchDay:(NSDate *)dayDate;

@end