//
//  HMAudioTool.h
//  02-播放音效
//
//  Created by Hannibal Wang on 20/6/9.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface HMAudioTool : NSObject

/**
 *  播放音乐
 *
 *  @param musicName 音乐名称
 */
+ (AVAudioPlayer *)playMusicWithName:(NSString *)musicName;

/**
 *  暂停音乐
 *
 *  @param musicName 音乐名称
 */
+ (void)pauseMusicWithName:(NSString *)musicName;

/**
 *  停止音乐
 *
 *  @param musicName 音乐名称
 */
+ (void)stopMusicWithName:(NSString *)musicName;

/**
 *  播放音效
 *
 *  @param soundName 音效名称
 */
+ (void)playSoundWithName:(NSString *)soundName;

/**
 *  销毁音效
 *
 *  @param soundName 音效名称
 */
+ (void)disposeSoundWihtName:(NSString *)soundName;

@end
