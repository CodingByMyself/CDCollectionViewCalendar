//
//  CDCustomDayViewController.m
//  CDCollectionViewCalendar
//
//  Created by Cindy on 16/6/27.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#import "CDCustomDayViewController.h"
#import "CDMangocityCalendar.h"

@interface CDCustomDayViewController () <JTCalendarDelegate,CDMangocityCalendarViewDelegate>
{
    CDMangocityCalendar *_calendarView;
}

@end

@implementation CDCustomDayViewController

#pragma mark - view
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"显示自定义day view";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _calendarView = [[CDMangocityCalendar alloc] init];
    _calendarView.delegate = self;
    [self.view addSubview:_calendarView];
    [_calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(65.0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(280.0));
    }];
    
    //  如果不设置minDate和maxDate则默认没有区间限制
     _calendarView.minDate = [_calendarView.calendarManager.dateHelper addToDate:_calendarView.todayDate months:0];
    _calendarView.maxDate = [_calendarView.calendarManager.dateHelper addToDate:_calendarView.todayDate months:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_calendarView.calendarManager reload];
}

#pragma mark  -  CDMangocityCalendarView  Delegate
- (NSString *)mangocityCalendar:(UIView *)calendar descriptionStringOnDay:(NSDate *)date
{
    if ([date timeIntervalSinceDate:[NSDate date]] < 0) {
        return nil;
    } else {
         return @"¥1240";
    }
}

- (void)mangocityCalendar:(UIView *)calendar didTouchDay:(NSDate *)dayDate
{
    NSLog(@"%@ 被点击啦",[_calendarView.calendarManager.dateHelper stringWithDate:dayDate byFormat:@"yyyy - MM - dd"]);
}

@end
