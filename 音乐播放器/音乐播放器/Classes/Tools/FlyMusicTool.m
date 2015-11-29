//
//  FlyMusicTool.m
//  音乐播放器
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 flymanshow. All rights reserved.
//

#import "FlyMusicTool.h"
#import "FlyMusic.h"
#import "MJExtension.h"

@implementation FlyMusicTool


static NSArray * _musics;
static FlyMusic * _playingMusic;


//第一次加载数据的时候调用
+(void)initialize{

    _musics = [FlyMusic objectArrayWithFilename:@"Musics.plist"];
    


}


//获取所有的音乐数据
+(NSArray *)musics{
    
    return  _musics;


}

//获取正在播放的音乐

+(FlyMusic *)playingMusic{
    
    return  _playingMusic;



}

//设置正在播放的音乐
+(void)settingPlayingMusic:(FlyMusic *)playingMusic{
    
     assert(playingMusic);
    _playingMusic = playingMusic;



}

//获取上一首音乐
+(FlyMusic *)previousMusic{
    
    //获取当前正在播放的音乐
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    //获取上一首音乐
    currentIndex--;
    
    //判断是否越界
    if (currentIndex<0) {
        currentIndex = _musics.count -1;
    }
    
    //取出上一首音乐
    FlyMusic *previousMusic = _musics[currentIndex];
    _playingMusic = previousMusic;
    
    
    return previousMusic;
    



}

//获取下一首音乐
+(FlyMusic *)nextMusic{

    //获取当前正在播放的音乐
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    
    //获取上一首音乐
    currentIndex++;
    
    //判断是否越界
    if (currentIndex>_musics.count - 1) {
        currentIndex = 0;
    }
    
    //取出上一首音乐
    FlyMusic *nextMusic = _musics[currentIndex];
    _playingMusic = nextMusic;
    
    
    return nextMusic;
    


}



@end
