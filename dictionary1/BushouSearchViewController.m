//
//  BushouSearchViewController.m
//  dictionary1
//
//  Created by vito7zhang on 16/7/21.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "BushouSearchViewController.h"
#import "SqliteManager.h"
#import "BushouModel.h"
#import "ResultViewController.h"

@interface BushouSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSource;
    NSArray *bhArr;
}

@end

@implementation BushouSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    [self initData];
    
    self.title = @"部首检字";
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.index-1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];
}

-(void)initData{
    dataSource = [NSMutableArray array];
    bhArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17"];
    NSArray *bsArr = [SqliteManager findAllBushou];
    
    for ( int i = 0; i < 17; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (BushouModel *m in bsArr) {
            if (m.bihua == [bhArr[i] intValue]) {
                [array addObject:m];
            }
        }
        [dataSource addObject:array];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray *)dataSource[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bsReuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bsReuse"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [(BushouModel *)[(NSArray *)dataSource[indexPath.section] objectAtIndex:indexPath.row] bushou];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return bhArr[section];
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return bhArr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BushouModel *m = dataSource[indexPath.section][indexPath.row];
    ResultViewController *resultVC = [ResultViewController new];
    resultVC.isPinyin = NO;
    resultVC.bsID = m.bs_id;
    resultVC.searchWord = m.bushou;
    [self.navigationController pushViewController:resultVC animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
