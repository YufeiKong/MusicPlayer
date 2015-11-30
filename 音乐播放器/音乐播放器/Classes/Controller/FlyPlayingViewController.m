//
//  FlyPlayingViewController.m
//  音乐播放器
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 flymanshow. All rights reserved.
//

#import "FlyPlayingViewController.h"
#import "UIView+AdjustFrame.h"
#import "FlyMusic.h"
#import "FlyMusicTool.h"
#import "HMAudioTool.h"
#import "FlyLrcView.h"

@interface FlyPlayingViewController ()<AVAudioPlayerDelegate>
//记录当前播放的音乐
@property(nonatomic,strong)FlyMusic *playingMusic;

//添加歌曲进度计时器
@property(nonatomic,strong)NSTimer *progressTimer;

//添加歌词进度计时器
@property(nonatomic,strong)CADisplayLink *lrcTimer;


//调节播放器
@property(nonatomic,strong)AVAudioPlayer *player;

@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singer;

@property (weak, nonatomic) IBOutlet UIImageView *singerIcon;

//歌曲总时长
@property (weak, nonatomic) IBOutlet UILabel *totalTIme;

//推动按钮与左边的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *silderLeftConstraint;
//拖动按钮
@property (weak, nonatomic) IBOutlet UIButton *silderButton;

//点击进度条背景
- (IBAction)tapProgressBackground:(UITapGestureRecognizer *)sender;

//拖拽按钮改变进度
- (IBAction)panSilderbutton:(UIPanGestureRecognizer *)sender;
//拖拽显示时间label
@property (weak, nonatomic) IBOutlet UILabel *showTimeLabel;



- (IBAction)playMusic;
//点击播放或暂停音乐
@property (weak, nonatomic) IBOutlet UIButton *playMusicClick;
//点击歌词按钮
- (IBAction)lrcButtonClick:(UIButton *)sender;


//显示歌词view
@property (weak, nonatomic) IBOutlet FlyLrcView *lrcView;

@end

@implementation FlyPlayingViewController
//退出控制器
- (IBAction)exit {
    
    //1.拿到window
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    
    
    window.userInteractionEnabled = NO;
    
    //2.执行动画退出
    [UIView animateWithDuration:1.0 animations:^{
        
        self.view.y = self.view.height;
        
        
    } completion:^(BOOL finished) {
        
        window.userInteractionEnabled = YES;
        
        //移除定时器
        [self removeProgressTimer];
        [self removeLrcProgresstimer];
        
    }];
    
    
}

-(void)show{
    
    
    //判断音乐是否发生改变
    if (self.playingMusic && self.playingMusic != [FlyMusicTool playingMusic]) {
        
        [self stopPlayingMusic];
        
    }
    
    //1.拿到window
    UIWindow *window =[UIApplication sharedApplication].keyWindow;
    
    
    window.userInteractionEnabled = NO;
    
    //2.设置view的frame
    self.view.frame = window.bounds;
    
    //3.将自身的view添加到window上
    [window addSubview:self.view];
    
    //4.给self.view设置y值
    self.view.y = self.view.height;
    
    
    //5.动画效果
    [UIView animateWithDuration:1.0 animations:^{
        
        self.view.y = 0;
        
    }completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
        
        //开始播放音乐
        [self startPlaying];
        
    }];


    
}

-(void)startPlaying{

//拿到正在播放的音乐
    FlyMusic *playingMusic = [FlyMusicTool playingMusic];
    
    if(self.playingMusic==playingMusic){
        
        [self addProgressTimer];
        [self addLrcProgresstimer];
        
        return;
        
        
    }
    
    
    
    self.playingMusic = playingMusic;
    
        self.songName.text = playingMusic.name;
        self.singer.text = playingMusic.singer;
        self.singerIcon.image = [UIImage imageNamed:playingMusic.icon];
        //歌词
    self.lrcView.lrcname = playingMusic.lrcname;
    
        
        
        //播放音乐
       self.player = [HMAudioTool playMusicWithName:playingMusic.filename];
    
        //设置代理
    self.player.delegate = self;
        
        self.totalTIme.text = [self stringWithTime:self.player.duration];
    
       //添加计时器
       [self addProgressTimer];
       [self updateInfo];
       [self addLrcProgresstimer];
       [self updateLRCInfo];
    
    //改变按钮选中的状态
    self.playMusicClick.selected = NO;
  

}

-(void)stopPlayingMusic{

    self.songName.text = nil;
    self.singer.text = nil;
    self.singerIcon.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.totalTIme.text = nil;
    
    //停止播放音乐
    [HMAudioTool stopMusicWithName:self.playingMusic.filename];
    
    //移除计时器
    [self removeProgressTimer];
    [self removeLrcProgresstimer];

}


#pragma mark添加歌曲进度计时器
-(void)addProgressTimer{

    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateInfo) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop]addTimer:self.progressTimer forMode:NSRunLoopCommonModes];



}


#pragma mark 移除歌曲进度计时器
-(void)removeProgressTimer{

    [self.progressTimer invalidate];
    self.progressTimer = nil;


}


//实现方法  随着播放进度更新进度条
-(void)updateInfo{
    
    
    // NSLog(@"更改数据");
    
    //计算播放比例
    CGFloat progressRatio = self.player.currentTime / self.player.duration;
    self.silderLeftConstraint.constant = progressRatio * (self.view.width - self.silderButton.width);
    
    NSString *currentTimer = [self stringWithTime:self.player.currentTime];
    
    [self.silderButton setTitle:currentTimer forState:UIControlStateNormal];
 
    
    
}

#pragma mark 添加歌词进度计时器
-(void)addLrcProgresstimer{

    if (self.lrcView.hidden) {
        return;
    }
    
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLRCInfo)];
    
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    

}


#pragma mark 移除歌词进度计时器
-(void)removeLrcProgresstimer{
    
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
    
    
}
//实现方法  随着播放进度更新歌词
-(void)updateLRCInfo{

    self.lrcView.currentTime = self.player.currentTime;
  

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置显示时间的label半径
    self.showTimeLabel.layer.cornerRadius = 5.0;
    //切割
    self.showTimeLabel.layer.masksToBounds = YES;
    
    
}

#pragma mark  私有方法
-(NSString *)stringWithTime:(NSTimeInterval)time{

    NSInteger minute = time / 60;
    NSInteger second = (NSInteger)time % 60;

    
    return  [NSString stringWithFormat:@"%02ld:%02ld",minute,second];

}
//点击进度条改变进度
- (IBAction)tapProgressBackground:(UITapGestureRecognizer *)sender {
    
    //获取点击位置
    CGPoint point = [sender locationInView:sender.view];
    
    //改变sliderbutton的约束
    if (point.x <= self.silderButton.width * 0.5) {
        self.silderLeftConstraint.constant = 0;
    }else if (point.x>=(self.view.width - self.silderButton.width * 0.5)){
    
        self.silderLeftConstraint.constant = self.view.width - self.silderButton.width - 1;
    
    }else{
    
        self.silderLeftConstraint.constant = point.x - self.silderButton.width * 0.5;
    
    }
    
    //改变当前播放的时间
    CGFloat progressRatio = self.silderLeftConstraint.constant / (self.view.width - self.silderButton.width);
    CGFloat currentTime = progressRatio * self.player.duration;
    
    self.player.currentTime  =currentTime;
    
    //更新时间
    [self updateInfo];
    
}
//拖拽按钮改变进度
- (IBAction)panSilderbutton:(UIPanGestureRecognizer *)sender {
    
    //获取用户拖拽位移
    CGPoint point = [sender locationInView:sender.view];
    
    [sender setTranslation:CGPointZero inView:sender.view];
    
    //改变button的约束
    if (self.silderLeftConstraint.constant + point.x <=0) {
        self.silderLeftConstraint.constant = 0;
    }else if (self.silderLeftConstraint.constant + point.x >= self.view.width - self.silderButton.width){
    
        self.silderLeftConstraint.constant = self.view.width - self.silderButton.width - 1;
    
    
    }else{
    
        self.silderLeftConstraint.constant += point.x;
    
    }
    
    
    //获取拖拽进度对应的时间
    CGFloat progressRatio = self.silderLeftConstraint.constant / (self.view.width - self.silderButton.width);
    CGFloat currentTime = progressRatio * self.player.duration;
    
    //更新文字
    
    NSString *currentTimeStr = [self stringWithTime:currentTime];
    
    [self.silderButton setTitle:currentTimeStr forState:UIControlStateNormal];
    self.showTimeLabel.text = currentTimeStr;
    
    
    //监听拖拽状态
    if (sender.state == UIGestureRecognizerStateBegan) {
        //移除定时器
        [self removeProgressTimer];
        
        self.showTimeLabel.hidden = false;
    }else if (sender.state == UIGestureRecognizerStateEnded){
        //更新播放时长
        self.player.currentTime = currentTime;
        
        //添加计时器
        [self addProgressTimer];
        
        //让显示时间的label隐藏
        self.showTimeLabel.hidden = YES;
    
    }
    
}

//暂停或播放音乐
- (IBAction)playMusic {
    
    
    self.playMusicClick.selected = !self.playMusicClick.selected;
    
    if (self.player.playing) {
        [self.player pause];
        [self removeLrcProgresstimer];
        [self removeProgressTimer];
    }else{
    
    
    [self.player play];
    [self addProgressTimer];
    [self addLrcProgresstimer];
    
    }
    
    
    
}

//上一首音乐
- (IBAction)preiousMusic {
    [self  stopPlayingMusic];
    [FlyMusicTool previousMusic];
    
    [self startPlaying];
    
}

//下一首音乐
- (IBAction)nextMusic {
    
    [self  stopPlayingMusic];
    [FlyMusicTool nextMusic];
    
    [self startPlaying];
    
}

#pragma mark  player代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{

    if (flag) {
        
        [self nextMusic];
        
    }
}

//被打断
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{

    [self playMusic];

}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player{

    [self playMusic];

}
//点击歌词按钮

- (IBAction)lrcButtonClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.lrcView.hidden = !self.lrcView.hidden;
    
    if (self.lrcView.hidden) {
        [self removeLrcProgresstimer];
    }else{
    
        [self addLrcProgresstimer];
    
    }
    
}
@end
