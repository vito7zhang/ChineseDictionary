//
//  myColletViewController.m
//  dictionary1
//
//  Created by Macx on 16/7/19.
//  Copyright © 2016年 Macx. All rights reserved.
//

#import "myColletViewController.h"
#import "ResultTableViewCell.h"
#import "SqliteManager.h"
#import <iflyMSC/IFlySpeechConstant.h>
#import <iflyMSC/IFlySpeechSynthesizer.h>
#import <iflyMSC/IFlySpeechSynthesizerDelegate.h>
#import "WordViewController.h"

@interface myColletViewController ()<UITableViewDelegate,UITableViewDataSource,IFlySpeechSynthesizerDelegate>
{
    UITableView *myTableView;
    NSMutableArray *dataSource;
    IFlySpeechSynthesizer *_iFlySpeechSynthesizer;
}
@end

@implementation myColletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
    myTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    [myTableView registerNib:[UINib nibWithNibName:@"ResultTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([ResultTableViewCell class])];
    myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beijing"]];

    myTableView.rowHeight = 88;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}

-(void)initData{
    dataSource = [NSMutableArray arrayWithArray:[SqliteManager findAllCollection]];
    [myTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResultTableViewCell class])];
    WordModel *m = dataSource[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.wordLabel.text = [NSString stringWithFormat:@"%@",m.simp];
    cell.zhuyinLabel.text = [NSString stringWithFormat:@"[%@]",m.pinyin];
    cell.bushouLabel.text = [NSString stringWithFormat:@"部首：%@",m.bushou];
    cell.bihuaLabel.text = [NSString stringWithFormat:@"笔画：%@",m.num];
    [cell.loudButton addTarget:self action:@selector(loudAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WordViewController *wordVC = [[WordViewController alloc]initWithNibName:@"WordViewController" bundle:[NSBundle mainBundle]];
    wordVC.model = dataSource[indexPath.row];
    [self.navigationController pushViewController:wordVC animated:YES];
}

#pragma mark 发音
#pragma mark 发音
-(void)loudAction:(UIButton *)sender{
    WordModel *m = dataSource[sender.tag];
    
    // 创建合成对象，为单例模式
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate = self;
    //设置语音合成的参数
    //语速,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"20" forKey:[IFlySpeechConstant SPEED]];
    //音量;取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
    //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
    [_iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey: [IFlySpeechConstant VOICE_NAME]];
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
