//
//  ViewController.m
//  music
//
//  Created by mac on 16/3/29.
//  Copyright (c) 2016年 lzc. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Lrc.h"
@interface ViewController ()<AVAudioPlayerDelegate,UITableViewDataSource,UITableViewDelegate>
- (IBAction)voile:(UISlider *)sender;
- (IBAction)song:(UISlider *)sender;
- (IBAction)start:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UISlider *voile;
@property (weak, nonatomic) IBOutlet UISlider *song;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)AVAudioPlayer *audioPlayer;
- (IBAction)shang:(UIButton *)sender;

- (IBAction)next:(UIButton *)sender;
@property (nonatomic,strong)NSArray *mp3Arr;
@property (nonatomic,strong)NSArray *lrcArr;
@property (nonatomic)NSInteger mp3Index;
@property (nonatomic,strong)Lrc *lrcPath;
@property (nonatomic)NSInteger mp3Row;
@end

@implementation ViewController


- (void)initWithMp3:(NSString *)mp3Path pathLrc:(NSString *)mp3Lrc
{
    //    播放器对象
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:mp3Path] error:nil];
    //    准备开始播放
    [self.audioPlayer prepareToPlay];
    self.audioPlayer.delegate = self;
    //    音量大小
    self.audioPlayer.volume = 0.5;
    self.voile.value = 0.5f;
//    音乐的总时间
    self.song.maximumValue = self.audioPlayer.duration;
    [self.lrcPath parserLrcWithPath:mp3Lrc];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.lrcPath = [[Lrc alloc]init];
    self.mp3Arr = @[[[NSBundle mainBundle] pathForResource:@"情非得已" ofType:@"mp3"],[[NSBundle mainBundle] pathForResource:@"林俊杰-背对背拥抱" ofType:@"mp3"],[[NSBundle mainBundle] pathForResource:@"梁静茹-偶阵雨" ofType:@"mp3"]];
    self.lrcArr = @[[[NSBundle mainBundle] pathForResource:@"情非得已" ofType:@"lrc"],[[NSBundle mainBundle] pathForResource:@"林俊杰-背对背拥抱" ofType:@"lrc"],[[NSBundle mainBundle] pathForResource:@"梁静茹-偶阵雨" ofType:@"lrc"]];

    [self initWithMp3:self.mp3Arr[self.mp3Index] pathLrc:self.lrcArr[self.mp3Index]];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
}

- (void)timeChange
{
    self.song.value = self.audioPlayer.currentTime;
    for (NSInteger i = 0;i < self.lrcPath.timeArr.count;i++) {
        NSString *timeString = self.lrcPath.timeArr[i];
        
        NSArray *timeArray = [timeString componentsSeparatedByString:@":"];
        
        NSTimeInterval seconds = [timeArray[0] integerValue] * 60 + [timeArray[1] floatValue];
        
        if(seconds < self.audioPlayer.currentTime)
        {
            self.mp3Row = i;
        }
        else
        {
            break;
        }
    }
    
    //刷新tableView
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.mp3Row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)voile:(UISlider *)sender {
    self.audioPlayer.volume = sender.value;
}

- (IBAction)song:(UISlider *)sender {
//    音乐播放当前时间
    self.audioPlayer.currentTime = sender.value;
}

- (IBAction)start:(UIButton *)sender {
//    判断是否正在播放音乐
    if (!self.audioPlayer.playing) {
        [self.audioPlayer play];
    }else
    {
        [self.audioPlayer pause];
    }
}
- (IBAction)shang:(UIButton *)sender {
//    [self.audioPlayer stop];
    self.mp3Index--;
    if (self.mp3Index < 0) {
        self.mp3Index = self.mp3Arr.count - 1;
    }
    [self initWithMp3:self.mp3Arr[self.mp3Index] pathLrc:self.lrcArr[self.mp3Index]];
    [self.audioPlayer play];
}

- (IBAction)next:(UIButton *)sender {
    [self.audioPlayer stop];
    self.mp3Index++;
    if (self.mp3Index >= self.mp3Arr.count) {
        self.mp3Index = 0;
    }
    [self initWithMp3:self.mp3Arr[self.mp3Index] pathLrc:self.lrcArr[self.mp3Index]];
    [self.audioPlayer play];
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self next:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcPath.songArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = self.lrcPath.songArr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if(indexPath.row == self.mp3Row)
    {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else
    {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}
@end
