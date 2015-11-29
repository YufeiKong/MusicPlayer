//
//  HMAudioTool.m
//  02-播放音效
//
//  Created by Hannibal Wang on 20/6/9.
//  Copyright (c) 2020年 itheima. All rights reserved.
//

#import "HMAudioTool.h"

@implementation HMAudioTool

static NSMutableDictionary *_soundIDs;
static NSMutableDictionary *_musics;

+ (void)initialize {
    _soundIDs = [NSMutableDictionary dictionary];
    _musics = [NSMutableDictionary dictionary];
}

#pragma mark - 播放音乐

+ (AVAudioPlayer *)playMusicWithName:(NSString *)musicName {
    
    // 0.判断musicName是否为空
    assert(musicName);
    
    // 1.取出播放器
    AVAudioPlayer *player = _musics[musicName];
    
    // 2.判断播放器是否为nil
    if (player == nil) {
        // 2.0.获取资源的URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
    
        // 2.1.创建播放器对象
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
        // 2.2.准备播放
        [player prepareToPlay];
        
        // 2.3.存入字典中
        _musics[musicName] = player;
    }
    
    // 3.播放音乐
    [player play];
    
    // 4.返回播放器
    return player;
}

+ (void)pauseMusicWithName:(NSString *)musicName {
    // 0.判断musicName是否为空
    assert(musicName);
    
    // 1.取出播放器
    AVAudioPlayer *player = _musics[musicName];
    
    if (player) {
        [player pause];
    }
}

+ (void)stopMusicWithName:(NSString *)musicName {
    // 0.判断musicName是否为空
    assert(musicName);
    
    // 1.取出播放器
    AVAudioPlayer *player = _musics[musicName];
    
    if (player) {
        [player stop];
        player = nil;
        [_musics removeObjectForKey:musicName];
    }
}

#pragma mark - 播放音效
+ (void)playSoundWithName:(NSString *)soundName {
    // 1.从字典中取出音效的ID
    SystemSoundID soundID = [_soundIDs[soundName] unsignedIntValue];
    
    // 2.如果现在取出来的值是0
    if (soundID == 0) {
        // 2.1.获取资源的URL
        NSURL *buyaoUrl = [[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        
        // 2.2.给SoundID赋值
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(buyaoUrl), &soundID);
        
        // 2.3.放入字典中
        _soundIDs[soundName] = @(soundID);
    }
    
    // 3.播放音效
    AudioServicesPlaySystemSound(soundID);
}

+ (void)disposeSoundWihtName:(NSString *)soundName {
    
    // 1.从字典中取出音效的ID
    SystemSoundID soundID = [_soundIDs[soundName] unsignedIntValue];
    
    // 2.如果soundID有值，则销毁音效
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
    }
}

@end
