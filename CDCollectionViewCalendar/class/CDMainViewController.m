//
//  CDMainViewController.m
//  CDCollectionViewCalendar
//
//  Created by Cindy on 16/6/27.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#import "CDMainViewController.h"
#import "CDCustomDayViewController.h"

@interface CDMainViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_functionList;
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
        CDCustomDayViewController *day = [[CDCustomDayViewController alloc] init];
        [self.navigationController pushViewController:day animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_functionList count];
}




@end
