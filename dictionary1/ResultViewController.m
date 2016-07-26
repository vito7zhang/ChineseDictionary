//
//  ResultViewController.m
//  dictionary1
//
//  Created by vito7zhang on 16/7/25.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "ResultViewController.h"
#import "ResultModel.h"
#import "ResultTableViewCell.h"
#import <iflyMSC/IFlySpeechConstant.h>
#import <iflyMSC/IFlySpeechSynthesizer.h>
#import <iflyMSC/IFlySpeechSynthesizerDelegate.h>
#import <MJRefresh.h>
#import "WordViewController.h"

@interface ResultViewController ()<UITableViewDelegate,UITableViewDataSource,IFlySpeechSynthesizerDelegate>
{
    NSMutableArray *dataSource;
    IFlySpeechSynthesizer *_iFlySpeechSynthesizer;
    int index;
}
@property (nonatomic,strong)UITableView *resultTableView;
@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.searchWord;
    [self initData];
    self.resultTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    [self.view addSubview:self.resultTableView];
    [self.resultTableView registerNib:[UINib nibWithNibName:@"ResultTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([ResultTableViewCell class])];
    self.resultTableView.rowHeight = 88;
    self.resultTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];
    
    self.resultTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.resultTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(moreData)];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResultTableViewCell class])];
    cell.backgroundColor = [UIColor clearColor];
    ResultModel *m = dataSource[indexPath.row];
    cell.wordLabel.text = m.simp;
    cell.zhuyinLabel.text = [NSString stringWithFormat:@"[%@]",m.pinyin];
    cell.bushouLabel.text = [NSString stringWithFormat:@"部首：%@",m.bushou];
    cell.bihuaLabel.text = [NSString stringWithFormat:@"笔画：%@",m.num];
    [cell.loudButton addTarget:self action:@selector(loudAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.loudButton.tag = indexPath.row;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WordViewController *wordVC = [[WordViewController alloc]initWithNibName:@"WordViewController" bundle:[NSBundle mainBundle]];
    wordVC.word = dataSource[indexPath.row];
    [self.navigationController pushViewController:wordVC animated:YES];
}


#pragma mark 加载数据
-(void)initData{
    index = 1;
    dataSource = [NSMutableArray array];
    NSString *urlString;
    if (self.isPinyin) {
        urlString = [NSString stringWithFormat:@"http://www.chazidian.com/service/pinyin/%@/0/10",self.searchWord];
    }else{
        urlString = [NSString stringWithFormat:@"http://www.chazidian.com/service/bushou/%d/0/10",self.bsID];
    }
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"data"][@"words"];
        for (NSDictionary *dictionary in array) {
            ResultModel *m = [ResultModel new];
            m.simp = dictionary[@"simp"];
            m.pinyin = dictionary[@"yin"][@"pinyin"];
            m.bushou = dictionary[@"bushou"];
            m.num = dictionary[@"num"];
            [dataSource addObject:m];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.resultTableView reloadData];
            [self.resultTableView.mj_header endRefreshing];
        });
    }];
    [dataTask resume];
}

-(void)moreData{
    NSString *urlString;
    if (self.isPinyin) {
        urlString = [NSString stringWithFormat:@"http://www.chazidian.com/service/pinyin/%@/%d/10",self.searchWord,index];
    }else{
        urlString = [NSString stringWithFormat:@"http://www.chazidian.com/service/bushou/%d/%d/10",self.bsID,index];
    }
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *array = dic[@"data"][@"words"];
        for (NSDictionary *dictionary in array) {
            BOOL hasWord = NO;
            for (ResultModel *m in dataSource) {
                if ([dictionary[@"simp"] isEqualToString:m.simp]) {
                    hasWord = YES;
                    break;
                }
            }
            if (!hasWord) {
                ResultModel *m = [ResultModel new];
                m.simp = dictionary[@"simp"];
                m.pinyin = dictionary[@"yin"][@"pinyin"];
                m.bushou = dictionary[@"bushou"];
                m.num = dictionary[@"num"];
                [dataSource addObject:m];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.resultTableView reloadData];
            [self.resultTableView.mj_footer endRefreshing];
            index++;
        });
    }];
    [dataTask resume];
}

#pragma mark 发音
-(void)loudAction:(UIButton *)sender{
    ResultModel *m = dataSource[sender.tag];
    
    // 创建合成对象，为单例模式
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate = self;
    //设置语音合成的参数
    //语速,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"0" forKey:[IFlySpeechConstant SPEED]];
    //音量;取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
    //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
    [_iFlySpeechSynthesizer setParameter:@"xiaomei" forKey: [IFlySpeechConstant VOICE_NAME]];
    //音频采样率,目前支持的采样率有 16000 和 8000
    [_iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
    //asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iFlySpeechSynthesizer setParameter:nil forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    
    //启动合成会话
    [_iFlySpeechSynthesizer startSpeaking:m.simp];
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
