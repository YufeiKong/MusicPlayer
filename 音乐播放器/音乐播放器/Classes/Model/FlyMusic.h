//
//  FlyMusic.h
//  音乐播放器
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 flymanshow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyMusic : NSObject

/*
 <key>name</key>
 <string>月半小夜曲</string>
 <key>filename</key>
 <string>1201111234.mp3</string>
 <key>lrcname</key>
 <string>月半小夜曲.lrc</string>
 <key>singer</key>
 <string>李克勤</string>
 <key>singerIcon</key>
 <string>lkq_icon.jpg</string>
 <key>icon</key>
 <string>lkq.jpg</string>
 
 */

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *filename;
@property(nonatomic,copy)NSString *lrcname;
@property(nonatomic,copy)NSString *singer;
@property(nonatomic,copy)NSString *singerIcon;
@property(nonatomic,copy)NSString *icon;

@end
