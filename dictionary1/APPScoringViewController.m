//
//  APPScoringViewController.m
//  dictionary1
//
//  Created by Macx on 16/7/19.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "APPScoringViewController.h"

@interface APPScoringViewController ()<UITableViewDelegate,UITableViewDataSource>
#define SCREEN_WIDTH self.view.bounds.size.width
#define SCREEN_HEIGHT self.view.bounds.size.height
{
    NSArray *dataSorece;
}
@end

@implementation APPScoringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self ;
    [self.view addSubview:myTableView];
    myTableView.rowHeight = 80;
    dataSorece = @[@"1.本词典超级好用      8~10 分",@"2.本词典非常好用     6~8 分",@"3.本词典还可以   4~6 分",@"4.本词典一般     2~4 分",@"5.本词典不合用    0~2 分"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSorece.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    cell.textLabel.text = dataSorece[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
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
