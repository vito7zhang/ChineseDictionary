//
//  MoreChooseViewController.m
//  dictionary1
//
//  Created by Macx on 16/7/19.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "MoreChooseViewController.h"
#import "myColletViewController.h"
#import "ShareViewController.h"
#import "SuggestionFeedBackViewController.h"

#import "APPScoringViewController.h"
#import "AboutUsViewController.h"
@interface MoreChooseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *datasource;
}
@end

@implementation MoreChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backGroundImageview = [[UIImageView alloc]initWithFrame:self.view.frame];
    backGroundImageview.image = [UIImage imageNamed:@"beijing"];
    [self.view addSubview:backGroundImageview];
    [self navigationControllerSetting];
    
    datasource = @[@"我的收藏",@"分享",@"意见反馈",@"精品应用",@"应用打分",@"关于我们"];
    UITableView *myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    myTableView.layer.contents = (id)[UIImage imageNamed:@"beijing"].CGImage;
    myTableView.rowHeight = 80;
}


-(void)navigationControllerSetting{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    titleLabel.text = @"汉语字典";
    titleLabel.font = [UIFont systemFontOfSize:40];
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return datasource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = datasource[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [self.navigationController pushViewController:[myColletViewController new] animated:NO];
        } break;
        case 1:
        {
            [self.navigationController pushViewController:[ShareViewController new] animated:NO];
        } break;
        case 2:
        {
            [self.navigationController pushViewController:[SuggestionFeedBackViewController new] animated:NO];
        } break;
        case 3:
        {
            NSString *string = @"https://www.baidu.com";
            [self openURL:string];
        } break;
        case 4:
        {
            [self.navigationController pushViewController:[APPScoringViewController new] animated:NO];
        } break;
        case 5:
        {
            [self.navigationController pushViewController:[AboutUsViewController new] animated:NO];
        } break;
            
        default:
            break;
    }
}

-(void)openURL:(NSString *)string{
    //url：统一资源定位符
    NSURL *url = [NSURL URLWithString:string];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
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
