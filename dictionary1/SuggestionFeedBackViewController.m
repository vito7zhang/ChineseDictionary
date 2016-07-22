//
//  SuggestionFeedBackViewController.m
//  dictionary1
//
//  Created by Macx on 16/7/19.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "SuggestionFeedBackViewController.h"
#define SCREEN_WIDTH self.view.bounds.size.width
#define SCREEN_HEIGHT self.view.bounds.size.height

@interface SuggestionFeedBackViewController ()<UITextViewDelegate>
{
    UITextView *insetTextView;
    UILabel *sexShowLabel;
    UIView *ageView;
    UILabel *ageLabel;
    UIButton *ageButton;
}
@end

@implementation SuggestionFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *backGroundImageview = [[UIImageView alloc]initWithFrame:self.view.frame];
    backGroundImageview.image = [UIImage imageNamed:@"beijing"];
    [self.view addSubview:backGroundImageview];
    [self setNavigation];
    [self setTextViewAction];
    [self setChooseSex];
    [self setAgeChoose];
    [self addAgeChoose];
    
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    chooseButton.frame = CGRectMake(60,SCREEN_HEIGHT-100, 40, 40);
    [chooseButton setImage:[[UIImage imageNamed:@"downward"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(addSexChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseButton];
    
    ageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    ageButton.frame = CGRectMake((SCREEN_WIDTH-100)/2+50, SCREEN_HEIGHT-100, 40, 40);
    [ageButton setImage:[[UIImage imageNamed:@"downward"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [ageButton addTarget:self action:@selector(ageMakeChoose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ageButton];
    
    UIButton *presentButton = [UIButton buttonWithType: UIButtonTypeSystem];
    presentButton.frame = CGRectMake(SCREEN_WIDTH-110, SCREEN_HEIGHT-100, 100, 60);
    [presentButton setTitle:@"提交" forState:UIControlStateNormal];
    presentButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:30];
    presentButton.tintColor = [UIColor whiteColor];
    [presentButton setBackgroundImage:[UIImage imageNamed:@"pressed1"] forState:UIControlStateNormal];
    [presentButton addTarget:self action:@selector(saveSuggestionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:presentButton];
    
}
-(void)setNavigation{
    UILabel *titlieLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    titlieLabel.text = @"意见反馈";
    titlieLabel.textColor = [UIColor whiteColor];
    titlieLabel.font = [UIFont systemFontOfSize:44];
    self.navigationItem.titleView = titlieLabel;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:nil action:nil];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}
-(void)setTextViewAction{
    insetTextView= [[UITextView alloc]initWithFrame:CGRectMake(10, 80,SCREEN_WIDTH-20, SCREEN_HEIGHT-200)];
    [insetTextView setBackgroundColor:[UIColor whiteColor]];
    insetTextView.delegate = self;
    insetTextView.font = [UIFont fontWithName:@"Arial" size:25.0];
    insetTextView.text = @"请输入您的反馈意见...";
    insetTextView.textColor = [UIColor grayColor];
    [self.view addSubview:insetTextView];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length ==0) {
        
        textView.textColor = [UIColor grayColor];
    }else{
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}
-(void)textViewDidEndEditing:(UITextView *)textView{
        textView.text = @"请输入您的反馈意见...";
}
-(void)setChooseSex{
    sexShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-100, 80, 40)];
    sexShowLabel.backgroundColor = [UIColor whiteColor];
    sexShowLabel.text = @"男";
    [self.view addSubview:sexShowLabel];
}
-(void)addSexChoose{
    UIAlertController *alerControll = [UIAlertController alertControllerWithTitle:@"请选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *menAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sexShowLabel.text = action.title;
    }];
    UIAlertAction *womenAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sexShowLabel.text = action.title;
    }];
    [alerControll addAction:menAction];
    [alerControll addAction:womenAction];
    [self presentViewController:alerControll animated:YES completion:nil];
}
-(void)setAgeChoose{
    ageLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/3+50, SCREEN_HEIGHT-100, 80, 40)];
    ageLabel.text = @"年龄";
    ageLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ageLabel];
}
-(void)addAgeChoose{
    ageView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/3+50, SCREEN_HEIGHT-430, 100, 300)];
    for (int i = 0; i <10; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 30*i, 100, 30);
        [button setTitle:[NSString stringWithFormat:@"%d~%d",i*10,(i+1)*10] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addAgeAction:) forControlEvents:UIControlEventTouchUpInside];
        [ageView addSubview:button];
    }
    ageView.hidden = YES;
    [self.view addSubview:ageView];
}
-(void)ageMakeChoose:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        ageView.hidden = NO;
        [self.view addSubview:ageView];
    }else if(!sender.selected){
        ageView.hidden = YES;
        [self.view addSubview:ageView];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self ageMakeChoose:ageButton];
    ageView.hidden = YES;
    [self.view addSubview:ageView];
}
-(void)addAgeAction:(UIButton *)button{
     ageLabel.text =button.titleLabel.text;
}
-(void)saveSuggestionAction{
    [self.navigationController popViewControllerAnimated:NO];
}


-(void)didReceiveMemoryWarning {
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
