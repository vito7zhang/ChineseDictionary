//
//  WordViewController.m
//  dictionary1
//
//  Created by vito7zhang on 16/7/25.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "WordViewController.h"
#import "WordModel.h"
#import <iflyMSC/IFlySpeechConstant.h>
#import <iflyMSC/IFlySpeechSynthesizer.h>
#import <iflyMSC/IFlySpeechSynthesizerDelegate.h>
#import "SqliteManager.h"
#import "UIViewController+BackNavigationBarButtonItem.h"
#import "UIViewController+ShowRemind.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

#import "UIView+Printscreen.h"

@interface WordViewController ()<IFlySpeechSynthesizerDelegate>
{
    BOOL isCollection;
    WordModel *m;
}
@property (nonatomic,strong)IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@property (weak, nonatomic) IBOutlet UILabel *simpLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinyinLabel;
@property (weak, nonatomic) IBOutlet UILabel *traLabel;
@property (weak, nonatomic) IBOutlet UILabel *bushouLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhuyinLabel;
@property (weak, nonatomic) IBOutlet UILabel *frameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bsnumLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *seqLabel;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *starBarButtonItem;

@end

@implementation WordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    [self setHomeButton];
    
    self.title = self.word;
    if (!_model) {
        [self initData];
    }else{
        isCollection = YES;
        m = self.model;
        self.title = m.simp;
        self.starBarButtonItem.tintColor = RGBColor(254, 238, 153);
        [self setUI];
    }
}

-(void)setCollectionBarButtonItemColor{
    isCollection = [SqliteManager isExistWithModel:m];
    self.starBarButtonItem.tintColor = isCollection ? RGBColor(254, 238, 153) : RGBColor(239, 236, 226);
}

-(void)initData{
    isCollection = NO;
    NSString *string = [NSString stringWithFormat:@"http://www.chazidian.com/service/word/%@",self.word];
    string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *con = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:con];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dataDic = dic[@"data"];
        m = [WordModel new];
        m.simp = dataDic[@"baseinfo"][@"simp"];
        m.pinyin = dataDic[@"baseinfo"][@"yin"][@"pinyin"];
        m.zhuyin = dataDic[@"baseinfo"][@"yin"][@"zhuyin"];
        m.tra = dataDic[@"baseinfo"][@"tra"];
        m.frame = dataDic[@"baseinfo"][@"frame"];
        m.bushou = dataDic[@"baseinfo"][@"bushou"];
        m.bsnum = dataDic[@"baseinfo"][@"bsnum"];
        m.num = dataDic[@"baseinfo"][@"num"];
        m.seq = dataDic[@"baseinfo"][@"seq"];
        m.hanyu = dataDic[@"hanyu"];
        m.base = dataDic[@"base"];
        m.english = dataDic[@"english"];
        m.idiom = dataDic[@"idiom"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setUI];
            [self setCollectionBarButtonItemColor];
        });
    }];
    [dataTask resume];
}
-(void)setUI{
    self.simpLabel.text = m.simp;
    self.pinyinLabel.text = [NSString stringWithFormat:@"拼音：%@",m.pinyin];
    self.zhuyinLabel.text = [NSString stringWithFormat:@"注音：%@",m.zhuyin];
    self.traLabel.text = [NSString stringWithFormat:@"笔顺：%@",m.tra];
    self.frameLabel.text = [NSString stringWithFormat:@"结构：%@",m.frame];
    self.bsnumLabel.text = [NSString stringWithFormat:@"部首笔画：%@",m.bsnum];
    self.numLabel.text = [NSString stringWithFormat:@"笔画：%@",m.num];
    self.seqLabel.text = [NSString stringWithFormat:@"笔顺：%@",m.seq];
    self.infoTextView.text = m.base;
}

#pragma mark 按钮方法
- (IBAction)pinyinButtonAction:(UIButton *)sender {
    [self.iFlySpeechSynthesizer startSpeaking:m.pinyin];
}
- (IBAction)zhuyinButtonAction:(UIButton *)sender {
    [self.iFlySpeechSynthesizer startSpeaking:m.zhuyin];
}
- (IBAction)segmentedControlAction:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.infoTextView.text = m.base;
        }
            break;
        case 1:{
            self.infoTextView.text = m.hanyu;
        }
            break;
        case 2:{
            self.infoTextView.text = m.idiom;
        }
            break;
        case 3:{
            self.infoTextView.text = m.english;
        }
            break;
            
        default:
            break;
    }
}
- (IBAction)copyButtonAction:(UIBarButtonItem *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.infoTextView.text;
    [self showRemindWithText:@"复制成功"];
}
- (IBAction)collectionButtonAction:(UIBarButtonItem *)sender {
    isCollection = !isCollection;
  
    if (isCollection) {
        BOOL flag = [SqliteManager insertDataWithModel:m];
        NSLog(@"flag = %d",flag);
        sender.tintColor = RGBColor(254, 238, 153);
        [self showRemindWithText:@"收藏成功"];
    }else{
        BOOL flag = [SqliteManager deleteDataWithModel:m];
        NSLog(@"flag = %d",flag);
        [self showRemindWithText:@"取消收藏"];
        sender.tintColor = RGBColor(239, 236, 226);
    }
}
- (IBAction)shareButtonAction:(UIBarButtonItem *)sender {
    //1、创建分享参数
    NSArray* imageArray = @[[self.view printsScreen]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"汉语字典好好玩啊"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"https:www.google.com"]
                                          title:@"汉语字典"
                                           type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess:{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分享成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
                break;
            case SSDKResponseStateFail:{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
                break;
            default:
                break;
        }}];
    }
}

#pragma mark 发音
-(IFlySpeechSynthesizer *)iFlySpeechSynthesizer{
    if (!_iFlySpeechSynthesizer) {
        // 创建合成对象，为单例模式
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
        _iFlySpeechSynthesizer.delegate = self;
        //设置语音合成的参数
        //语速,取值范围 0~100
        [_iFlySpeechSynthesizer setParameter:@"20" forKey:[IFlySpeechConstant SPEED]];
        //音量;取值范围 0~100
        [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
        //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
        [_iFlySpeechSynthesizer setParameter:@"xioayan" forKey: [IFlySpeechConstant VOICE_NAME]];
        //音频采样率,目前支持的采样率有 16000 和 8000
        [_iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
        //asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
        [_iFlySpeechSynthesizer setParameter:nil forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    }
    return _iFlySpeechSynthesizer;
}

//合成结束，此代理必须要实现
- (void) onCompleted:(IFlySpeechError *) error{}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
