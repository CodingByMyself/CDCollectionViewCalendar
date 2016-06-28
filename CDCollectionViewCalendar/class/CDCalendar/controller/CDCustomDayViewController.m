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
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    
    NSDate *_dateSelected; //  单选模式
    NSMutableArray *_datesSelected;  //  多选模式
}

@end

@implementation CDCustomDayViewController

#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"显示自定义day view";
    self.view.backgroundColor = [UIColor whiteColor];
    _datesSelected = [[NSMutableArray alloc] init];
    
    _calendarManager = [[JTCalendarManager alloc] init];
    _calendarManager.delegate = self;
    [self createMinAndMaxDate];
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
    [_calendarManager setDate:_todayDate];
}

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:0];
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:1.5];
}

#pragma mark - CalendarManager delegate
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    [dayView setDescriptionText:@"¥240"];
    // Other month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;  //  设置非本月的日期不显示
    }
//   if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
//        // 设置非本月的日期显示为灰度
//        dayView.circleView.hidden = YES;
//        dayView.dotView.backgroundColor = [UIColor redColor];
//        dayView.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
//        [dayView setDescriptionTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15]];
//    }
    else if ([_calendarManager.dateHelper date:dayView.date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate] == NO) {
        // 不在设定的日期区间的显示为灰度
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
//    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){  //  单选模式
    else if([self isInDatesSelected:dayView.date]){  //  多选模式
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
//    [self singleSelectionModeOnCalendar:calendar didTouchDayView:dayView];  //  单选模式
    [self multiSelectionModeOnCalendar:calendar didTouchDayView:dayView];
    
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

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    BOOL result = [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
    NSLog(@"result = %zi",result);
    return result;
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
    view.circleRatio = 0.90; // 背景圆的比率
    
    [view setDescriptionFont:[UIFont fontWithName:@"Helvetica" size:10.0/568.0*(ScreenHeigth)]];
    [view initCustomView];  //  使用自定义的 day view
    
    return view;
    
}

#pragma mark - touch mode method
- (void)singleSelectionModeOnCalendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView duration:.3 options:0 animations:^{
        dayView.circleView.transform = CGAffineTransformIdentity;
        [calendar reload];
    } completion:nil];
    
}

- (void)multiSelectionModeOnCalendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    CGAffineTransform transform;
    if ([self isInDatesSelected:dayView.date]) {
        [_datesSelected removeObject:dayView.date];
        transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    } else {
        [_datesSelected addObject:dayView.date];
        dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        transform =  CGAffineTransformIdentity;
    }
    
    //  加入动画
    [UIView transitionWithView:dayView duration:.3 options:0 animations:^{
        [_calendarManager reload];
        dayView.circleView.transform = transform;
    } completion:nil];
}

- (BOOL)isInDatesSelected:(NSDate *)date
{
    for(NSDate *dateSelected in _datesSelected){
        if([_calendarManager.dateHelper date:dateSelected isTheSameDayThan:date]){
            return YES;
        }
    }
    return NO;
}




@end
