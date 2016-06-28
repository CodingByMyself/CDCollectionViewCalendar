//
//  CDCustomDayViewController.m
//  CDCollectionViewCalendar
//
//  Created by Cindy on 16/6/27.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#import "CDCustomDayViewController.h"
#import "JTCalendar.h"
#import "Masonry.h"
#import "CDCalendarDay.h"


@interface CDCustomDayViewController () <JTCalendarDelegate>
{
    JTCalendarManager *_calendarManager;
    JTCalendarMenuView *_calendarMenuView;
    JTVerticalCalendarView *_calendarContentView;
    
    NSDate *_dateSelected;
}

@end

@implementation CDCustomDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"显示自定义day view";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _calendarManager = [[JTCalendarManager alloc] init];
    _calendarManager.delegate = self;
    _calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatSingle;
    //    [[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans"]
    //    [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]
    //    [NSLocale currentLocale]
    _calendarManager.dateHelper.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
    
    
    
    // Generate random events sort by date using a dateformatter for the demonstration
//    [self createRandomEvents];
    
    
    // 星期菜单
    _calendarMenuView =  [[JTCalendarMenuView alloc] init];
    _calendarMenuView.contentRatio = 1.0;
    [self.view addSubview:_calendarMenuView];
    [_calendarMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(50.0));
    }];
    [_calendarManager setMenuView:_calendarMenuView];
    
    //  日期内容
    _calendarContentView = [[JTVerticalCalendarView alloc] init];
    [self.view addSubview:_calendarContentView];
    [_calendarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_calendarMenuView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(300.0));
    }];
    [_calendarManager setContentView:_calendarContentView];
//    _calendarContentView.backgroundColor = [UIColor yellowColor];
    
    
    [_calendarManager setDate:[NSDate date]];
}


#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    CDCalendarDay *cdDayView = (CDCalendarDay *)dayView;
    dayView.hidden = NO;
    
    // Other month
//    if([dayView isFromAnotherMonth]){
//        dayView.hidden = YES;
//    }
    cdDayView.labelDescription.text = @"¥240";
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:cdDayView.date]){
        cdDayView.circleViewBg.hidden = YES;
        cdDayView.labelTitle.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        cdDayView.labelDescription.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:cdDayView.date]){
        cdDayView.circleViewBg.hidden = NO;
        cdDayView.circleViewBg.backgroundColor = [UIColor redColor];
        cdDayView.labelTitle.textColor = [UIColor whiteColor];
        cdDayView.labelDescription.textColor = [UIColor orangeColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:cdDayView.date]){
        cdDayView.circleView.hidden = NO;
        cdDayView.circleView.backgroundColor = [UIColor greenColor];
        cdDayView.textLabel.textColor = [UIColor whiteColor];
        cdDayView.labelDescription.textColor = [UIColor orangeColor];
    }
    // Another day of the current month
    else{
        cdDayView.circleViewBg.hidden = YES;
        cdDayView.labelTitle.textColor = [UIColor darkGrayColor];
        cdDayView.labelDescription.textColor = [UIColor orangeColor];
    }
    
    //  是显示下面的小圆点
//    if([self haveEventForDay:dayView.date]){
//        dayView.dotView.hidden = NO;
//    }
//    else{
//        dayView.dotView.hidden = YES;
//    }
    
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    CDCalendarDay *cdDayView = (CDCalendarDay *)dayView;
    _dateSelected = cdDayView.date;
    // Animation for the circleView
    cdDayView.circleViewBg.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:cdDayView duration:.3 options:0 animations:^{
        cdDayView.circleView.transform = CGAffineTransformIdentity;
        [_calendarManager reload];
    } completion:nil];
    
    // Load the previous or next page if touch a day from another month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:cdDayView.date]){
        if([_calendarContentView.date compare:cdDayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark  Views Customization
- (UIView<JTCalendarWeekDay> *)calendarBuildWeekDayView:(JTCalendarManager *)calendar
{
    JTCalendarWeekDayView *view = [JTCalendarWeekDayView new];
    
    for(UILabel *label in view.dayViews){
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"Avenir-Light" size:14];
    }
    
    return view;
}

- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
//    JTCalendarDayView *view = [JTCalendarDayView new];
//    view.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13];
//    view.circleRatio = .8;
//    view.dotRatio = 1. / .9;
//    return view;
    
    CDCalendarDay *dayView = [[CDCalendarDay alloc] init];
    [dayView commonInit];
    
    return dayView;
}

@end
