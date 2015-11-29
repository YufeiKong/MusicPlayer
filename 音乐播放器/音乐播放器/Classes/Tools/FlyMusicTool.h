//
//  FlyMusicTool.h
//  音乐播放器
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 flymanshow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlyMusic;

@interface FlyMusicTool : NSObject




//获取所有的音乐数据
+(NSArray *)musics;

//获取正在播放的音乐

+(FlyMusic *)playingMusic;

//设置正在播放的音乐
+(void)settingPlayingMusic:(FlyMusic *)playingMusic;

//获取上一首音乐
+(FlyMusic *)previousMusic;

//获取下一首音乐
+(FlyMusic *)nextMusic;

@end
