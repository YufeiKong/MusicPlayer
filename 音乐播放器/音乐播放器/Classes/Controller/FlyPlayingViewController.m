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

@interface FlyPlayingViewController ()
//记录当前播放的音乐
@property(nonatomic,strong)FlyMusic *playingMusic;

//添加计时器
@property(nonatomic,strong)NSTimer *progressTimer;

@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *singer;

@property (weak, nonatomic) IBOutlet UIImageView *singerIcon;

//歌曲总时长
@property (weak, nonatomic) IBOutlet UILabel *totalTIme;
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
        
        
        return;
        
        
    }
    
    
    
    self.playingMusic = playingMusic;
    
        self.songName.text = playingMusic.name;
        self.singer.text = playingMusic.singer;
        self.singerIcon.image = [UIImage imageNamed:playingMusic.icon];
        
        
        //播放音乐
        AVAudioPlayer *player = [HMAudioTool playMusicWithName:playingMusic.filename];
        
        self.totalTIme.text = [self stringWithTime:player.duration];
    
       //添加计时器
       [self addProgressTimer];
  

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

}


#pragma mark添加计时器
-(void)addProgressTimer{

    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateInfo) userInfo:nil repeats:nil];
    
    [[NSRunLoop mainRunLoop]addTimer:self.progressTimer forMode:NSRunLoopCommonModes];



}


#pragma mark 移除计时器
-(void)removeProgressTimer{

    [self.progressTimer invalidate];
    self.progressTimer = nil;


}

//实现方法
-(void)updateInfo{


    NSLog(@"更改数据");

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark  私有方法
-(NSString *)stringWithTime:(NSTimeInterval)time{

    NSInteger minute = time / 60;
    NSInteger second = (NSInteger)time % 60;

    
    return  [NSString stringWithFormat:@"%02ld:%02ld",minute,second];

}

@end
