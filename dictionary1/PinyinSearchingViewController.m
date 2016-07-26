//
//  PinyinSearchingViewController.m
//  dictionary1
//
//  Created by Macx on 16/7/20.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "PinyinSearchingViewController.h"
#import "SqliteManager.h"
#import "PinyinModel.h"
#import "ResultViewController.h"

@interface PinyinSearchingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTableView;
    NSMutableArray *dataSource;
    NSArray *pyArr;
}
@end

@implementation PinyinSearchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    self.title = @"拼音检字";
    
    [self initData];
    if (self.index == 73 || self.index == 86) {
        self.index += 1;
    }
    if (self.index == 85) {
        self.index -= 1;
    }
    [myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.index-65] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];
}

-(void)initData{
    NSArray *array = [SqliteManager findAllPinyin];
    dataSource = [NSMutableArray array];
    int i = 0;
    pyArr = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    
    for (int a = 0; a < 26; a++) {
        i = 0;
        NSMutableArray *fenleiArr = [NSMutableArray array];
        for (PinyinModel *m in array) {
            i++;
            if (i<=26) {
                continue;
            }
            if ([m.pinyin hasPrefix:pyArr[a]]) {
                [fenleiArr addObject:m];
            }
        }
        [dataSource addObject:fenleiArr];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = dataSource[section];
    return array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    cell.backgroundColor = [UIColor clearColor];
    NSArray *array = dataSource[indexPath.section];
    PinyinModel *m = array[indexPath.row];
    cell.textLabel.text = m.pinyin;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [pyArr[section] uppercaseString];
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return pyArr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultViewController *resultVC = [ResultViewController new];
    resultVC.isPinyin = YES;
    PinyinModel *m = dataSource[indexPath.section][indexPath.row];
    resultVC.searchWord = m.pinyin;
    [self.navigationController pushViewController:resultVC animated:YES];
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
