//
//  CDMainViewController.m
//  CDCollectionViewCalendar
//
//  Created by Cindy on 16/6/27.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#import "CDMainViewController.h"
#import "CDMangocityCalendar.h"

@interface CDMainViewController () <UITableViewDelegate,UITableViewDataSource,CDMangocityCalendarViewDelegate>
{
    NSArray *_functionList;
    
    CDMangocityCalendar *_calendarView;
}
@end

@implementation CDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"功能列表";
    
    
    _functionList = @[@"自定义显示day的view"];
    _tableFunction.delegate = self;
    _tableFunction.dataSource = self;
    
    [self initCalendar];
}

- (void)initCalendar
{
    _calendarView = [[CDMangocityCalendar alloc] init];
    _calendarView.delegate = self;
    //  如果不设置minDate和maxDate则默认没有区间限制
    _calendarView.minDate = [_calendarView.calendarManager.dateHelper addToDate:_calendarView.todayDate months:0];
    _calendarView.maxDate = [_calendarView.calendarManager.dateHelper addToDate:_calendarView.todayDate months:3];
}

#pragma mark - UI Table View Data And Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellID"];
    }
    
    
    cell.textLabel.text = _functionList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"section = %zi , row = %zi",[indexPath section],[indexPath row]);
    if ([indexPath row] == 0) {
        [_calendarView showCalendarWithTargetView:self.view];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_functionList count];
}

#pragma mark  -  CDMangocityCalendarView  Delegate
- (NSString *)mangocityCalendar:(UIView *)calendar descriptionStringOnDay:(NSDate *)date
{
    if ([date timeIntervalSinceDate:[NSDate date]] < 0) {
        return nil;  //  返回nil表示不需要显示描述文本
    } else {
        return @"¥1240"; //  返回需要显示的描述文本
    }
}

- (void)mangocityCalendar:(UIView *)calendar didTouchDay:(NSDate *)dayDate
{
    NSLog(@"%@ 被点击啦",[_calendarView.calendarManager.dateHelper stringWithDate:dayDate byFormat:@"yyyy - MM - dd"]);
}


@end
