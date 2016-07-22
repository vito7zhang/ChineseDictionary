//
//  AboutUsViewController.m
//  dictionary1
//
//  Created by Macx on 16/7/19.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
{
    UIImageView *backGroundImageView;
}
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    backGroundImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backGroundImageView.image = [UIImage imageNamed:@"beijing"];
    [self.view addSubview:backGroundImageView];
    [self setNavigation];
    [self setlogo];
    [self contactAction];
}
-(void)setNavigation{
    UILabel *titlieLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    titlieLabel.text = @"关于我们";
    titlieLabel.textColor = [UIColor whiteColor];
    titlieLabel.font = [UIFont systemFontOfSize:44];
    self.navigationItem.titleView = titlieLabel;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:nil action:nil];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
-(void)setlogo{
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 80, self.view.bounds.size.width, 60)];
    logoImageView.image = [UIImage imageNamed:@"z"];
    [self.view addSubview:logoImageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 80, self.view.bounds.size.width, 50)];
    titleLabel.text = @"指掌无线";
    titleLabel.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:titleLabel];
    
    UILabel *smallDetail = [[UILabel alloc]initWithFrame:CGRectMake(250, 130, 100, 40)];
    smallDetail.text = @"汉语字典";
    [self.view addSubview:smallDetail];
    
    UIImageView *logo = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/3, 170, self.view.bounds.size.width/3, self.view.bounds.size.width/3)];
    logo.image = [UIImage imageNamed:@"zidian"];
    [self.view addSubview:logo];
    
    UILabel *descriptionLable = [[UILabel alloc]initWithFrame:CGRectMake(30, 350, self.view.bounds.size.width-60, 100)];
    descriptionLable.text = @"        汉语是世界上最精密的语言之一，语义丰富，耐人寻味。本词典篇幅简短，内容丰富，既求融科学性、知识性、实用性、规范性于一体，又注意突出时代特色。";
    descriptionLable.numberOfLines= 0 ;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:descriptionLable.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:20];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [descriptionLable.text length])];
    descriptionLable.attributedText = attributedString;
    [descriptionLable sizeToFit];
    [self.view addSubview:descriptionLable];
}
-(void)contactAction{
    UIImageView *contactImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, self.view.bounds.size.height-150, self.view.bounds.size.width-60, 120)];
    contactImageView.image = [UIImage imageNamed:@"kuang"];
    [self.view addSubview:contactImageView];
    
    UILabel *webLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, self.view.bounds.size.width-20, 30)];
    webLabel.text = @"官方网站：www.zhizhang.com";
    [contactImageView addSubview:webLabel];
    
    UILabel *weiboLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, self.view.bounds.size.width-20, 30)];
    weiboLabel.text = @"官方微博：e.weibo.com/u/3385145102";
    [contactImageView addSubview:weiboLabel];
    
    UILabel *publieLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 80,self.view.bounds.size.width-20, 30)];
    publieLabel.text = @"微信公共账号：指掌无线";
    [contactImageView addSubview:publieLabel];
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
