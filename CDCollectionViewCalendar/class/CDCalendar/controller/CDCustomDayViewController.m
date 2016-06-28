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
#import "JTCalendarDayView+CDCustomDayView.h"

#define ScreenHeigth  [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width

@interface CDCustomDayViewController () <JTCalendarDelegate>
{
    JTCalendarManager *_calendarManager;
    JTCalendarMenuView *_calendarMenuView;
    JTVerticalCalendarView *_calendarContentView;
    
    NSDate *_dateSelected;
}

@end

@implementation CDCustomDayViewController

#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"显示自定义day view";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _calendarManager = [[JTCalendarManager alloc] init];
    _calendarManager.delegate = self;
    _calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatSingle;
    //    [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]
    //    [NSLocale currentLocale]
    _calendarManager.dateHelper.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hans"];
    
    // 星期菜单
    _calendarMenuView =  [[JTCalendarMenuView alloc] init];
    _calendarMenuView.contentRatio = 1.0;
    _calendarMenuView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_calendarMenuView];
    [_calendarMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64.0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(25.0));
    }];
    [_calendarManager setMenuView:_calendarMenuView];
    
    //  日期内容
    _calendarContentView = [[JTVerticalCalendarView alloc] init];
    [self.view addSubview:_calendarContentView];
    //    _calendarContentView.backgroundColor = [UIColor yellowColor];
    [_calendarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_calendarMenuView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(280.0/568.0*(ScreenHeigth)));
    }];
    [_calendarManager setContentView:_calendarContentView];
    
    //  设置今天的日期
    [_calendarManager setDate:[NSDate date]];
}


#pragma mark - CalendarManager delegate
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    [dayView setDescriptionText:@"¥240"];
    // Other month
//    if([dayView isFromAnotherMonth]){
//        dayView.hidden = YES;  //  设置非本月的日期不显示
//    }
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        // 设置非本月的日期显示为灰度
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
        [dayView setDescriptionTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15]];
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:180/255.0 green:250/255.0 blue:175.0/255.0 alpha:1.0];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor darkGrayColor];
        [dayView setDescriptionTextColor:[UIColor orangeColor]];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor orangeColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
        [dayView setDescriptionTextColor:[UIColor whiteColor]];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor darkGrayColor];
        [dayView setDescriptionTextColor:[UIColor orangeColor]];
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView duration:.3 options:0 animations:^{
        dayView.circleView.transform = CGAffineTransformIdentity;
        [calendar reload];
    } completion:nil];
    
    // Load the previous or next page if touch a day from another month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
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
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont fontWithName:@"Helvetica-blod" size:10];
    }
    
    return view;
}

- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
    JTCalendarDayView *view = [JTCalendarDayView new];
    view.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0/568.0*(ScreenHeigth)];
    view.circleRatio = 1.0; // 背景圆的比率
    
    [view setDescriptionFont:[UIFont fontWithName:@"Helvetica" size:10.0/568.0*(ScreenHeigth)]];
    [view initCustomView];  //  使用自定义的 day view
    
    return view;
    
}

@end
