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
    if (!_model) {
        [self initData];
    }else{
        isCollection = YES;
        m = self.model;
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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-80, SCREEN_HEIGHT/2-30, 160, 60)];
    label.text = @"复制成功";
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:label];
    [UIView animateWithDuration:1.25 animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}
- (IBAction)collectionButtonAction:(UIBarButtonItem *)sender {
    isCollection = !isCollection;
    if (isCollection) {
        BOOL flag = [SqliteManager insertDataWithModel:m];
        NSLog(@"flag = %d",flag);
        sender.tintColor = RGBColor(254, 238, 153);
    }else{
        BOOL flag = [SqliteManager deleteDataWithModel:m];
        NSLog(@"flag = %d",flag);
        sender.tintColor = RGBColor(239, 236, 226);
    }
}
- (IBAction)shareButtonAction:(UIBarButtonItem *)sender {
    
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
//合成开始
- (void) onSpeakBegin{}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg{}
//合成播放进度
- (void) onSpeakProgress:(int) progress{}


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
