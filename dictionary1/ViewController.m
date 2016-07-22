//
//  ViewController.m
//  dictionary1
//
//  Created by Macx on 16/7/18.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "ViewController.h"
#import "MoreChooseViewController.h"
#import "BushouSearchViewController.h"
#import "PinyinSearchingViewController.h"

@interface ViewController ()
{
    UIView *pinyinView;
    UIView *bushouView;
}
@property (nonatomic,strong)UIButton *pinyinButton;
@property (nonatomic,strong)UIButton *bushouButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titlieLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    titlieLabel.backgroundColor = [UIColor clearColor];
    titlieLabel.textColor = [UIColor whiteColor];
    titlieLabel.text =@"汉语字典";
    titlieLabel.font = [UIFont systemFontOfSize:40];
    titlieLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titlieLabel;
    //背景图片
    UIImageView *backGroundImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backGroundImageView.image = [UIImage imageNamed:@"beijing"];
    [self.view addSubview:backGroundImageView];
//    导航栏背景颜色
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.navigationController.navigationBar.barTintColor = RGBColor(150, 28, 31);
        self.navigationController.navigationBar.
        tintColor = [UIColor whiteColor];
    }else{
        self.navigationController.navigationBar.tintColor = RGBColor(150, 28, 31);
    }
    
    //设置更多键图片
    UIBarButtonItem *rightMoreButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStylePlain target:self action:@selector(moreButtonAction:)];
    self.navigationItem.rightBarButtonItems = @[rightMoreButton];
    
    _pinyinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pinyinButton.frame = CGRectMake(100, 100, 100, 50);
    [_pinyinButton setTitle:@"拼音检索" forState:UIControlStateNormal];
    _pinyinButton.backgroundColor = [UIColor whiteColor];
    _pinyinButton.layer.borderWidth = 1;
    _pinyinButton.layer.cornerRadius = 10;
    [_pinyinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pinyinButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _pinyinButton.selected = YES;
    _pinyinButton.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_pinyinButton];
    
    _bushouButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _bushouButton.frame = CGRectMake(199, 100, 100, 50);
    [_bushouButton setTitle:@"部首检索" forState:UIControlStateNormal];
    _bushouButton.backgroundColor = [UIColor whiteColor];
    _bushouButton.layer.borderWidth = 1;
    _bushouButton.layer.cornerRadius = 10;
    [_bushouButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bushouButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bushouButton];
    
    //检索框
    UITextField *searchTextField = [[UITextField alloc]initWithFrame:CGRectMake(30, 170, SCREEN_WIDTH-60, 50)];
    searchTextField.backgroundColor = [UIColor whiteColor];
    searchTextField.placeholder = @"请输入...";
    searchTextField.layer.cornerRadius = 15;
    searchTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 0)];
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:searchTextField];
    
    UILabel *recentlyLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 230, 150, 50)];
    recentlyLabel.text = @"最近搜索：";
    recentlyLabel.font = [UIFont systemFontOfSize:25.0];
    [self.view addSubview:recentlyLabel];
    
    UIImageView *linerImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(30, 280, SCREEN_WIDTH-60, 3)];
    linerImageView1.image = [UIImage imageNamed:@"dividing-line"];
    [self.view addSubview:linerImageView1];
    
    UIImageView *recentlyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 290, SCREEN_WIDTH-60, 44)];
    recentlyImageView.image = [UIImage imageNamed:@"jintian"];
    [self.view addSubview:recentlyImageView];
    
    UILabel *zimuLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 350, SCREEN_WIDTH-60, 44)];
    zimuLabel.text = @"按照拼音字母检索：";
    zimuLabel.font = [UIFont systemFontOfSize:25.0];
    [self.view addSubview:zimuLabel];
 
    UIImageView *linerImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(30, 390, SCREEN_WIDTH-60, 3)];
    linerImageView2.image = [UIImage imageNamed:@"dividing-line"];
    [self.view addSubview:linerImageView2];
    
    pinyinView = [[UIView alloc]initWithFrame:CGRectMake(30, 395, SCREEN_WIDTH-60, SCREEN_HEIGHT-400)];
    pinyinView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    [self.view addSubview:pinyinView];
    
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 4; j++) {
            UIButton *zimuButton = [UIButton buttonWithType:UIButtonTypeSystem];
            zimuButton.frame = CGRectMake((SCREEN_WIDTH-60)/10+i*(SCREEN_WIDTH-60)/10, (SCREEN_HEIGHT-400)/5+(SCREEN_HEIGHT-400)*j/5, 50, 50);
            unichar h=65+i+j*8;
            if (h <= 90 ) {
                [zimuButton setTitle:[NSString stringWithUTF8String:(char *)&h] forState:UIControlStateNormal];
            }
            zimuButton.tag = h;
            zimuButton.titleLabel.font = [UIFont systemFontOfSize:40];
            zimuButton.tintColor = [UIColor orangeColor];
            [zimuButton addTarget:self action:@selector(pyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [pinyinView addSubview:zimuButton];
        }
    }
    
    bushouView = [[UIView alloc]initWithFrame:CGRectMake(30, 395, SCREEN_WIDTH-60, SCREEN_HEIGHT-400)];
    
    bushouView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    [self.view addSubview:bushouView];
    for (int i = 0; i < 7; i++) {
        for (int j = 0; j < 4; j++) {
            UIButton *bsButtom = [UIButton buttonWithType:UIButtonTypeSystem];
            bsButtom.frame = CGRectMake((SCREEN_WIDTH-60)/9+i*(SCREEN_WIDTH-60)/9, (SCREEN_HEIGHT-400)/4+(SCREEN_HEIGHT-400)*j/4, 50, 30);
            int h=i+j*7+1;
            if (h <=17 ) {
                [bsButtom setTitle:[NSString stringWithFormat:@"%d",h] forState:UIControlStateNormal];
            }
            bsButtom.titleLabel.font = [UIFont systemFontOfSize:30];
            bsButtom.tintColor = [UIColor orangeColor];
            [bsButtom addTarget:self action:@selector(bsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [bushouView addSubview:bsButtom];
        }
    }

    pinyinView.hidden = NO;
    bushouView.hidden = YES;
}
//更多按钮方法
-(void)moreButtonAction:(UIBarButtonItem *)sender{
    MoreChooseViewController *moreCh = [MoreChooseViewController new];
    [self.navigationController pushViewController:moreCh animated:YES];
}

//按钮选中状态的背景颜色变化
-(void)selectedButtonAction:(UIButton *)button{
    if (button == _pinyinButton) {
        _bushouButton.selected = NO;
        _pinyinButton.selected = YES;
        pinyinView.hidden = NO;
        bushouView.hidden = YES;
    }else{
        _pinyinButton.selected = NO;
        _bushouButton.selected = YES;
        pinyinView.hidden = YES;
        bushouView.hidden = NO;
    }
    _pinyinButton.backgroundColor = _pinyinButton.selected?[UIColor orangeColor]:0;
    _bushouButton.backgroundColor = _bushouButton.selected?[UIColor orangeColor]:0;
    
   

}

-(void)pyButtonAction:(UIButton *)sender{
    PinyinSearchingViewController *pyVC = [PinyinSearchingViewController new];
    pyVC.index = (int)sender.tag;
    [self.navigationController pushViewController:pyVC animated:YES];
}
-(void)bsButtonAction:(UIButton *)sender{
    BushouSearchViewController *bsVC = [BushouSearchViewController new];
    bsVC.index = [sender.titleLabel.text intValue];
    [self.navigationController pushViewController:bsVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end











