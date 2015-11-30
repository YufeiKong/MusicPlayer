//
//  FlyLrcView.h
//  音乐播放器
//
//  Created by mac on 15/11/29.
//  Copyright © 2015年 flymanshow. All rights reserved.
//

#import "DRNRealTimeBlurView.h"

@interface FlyLrcView : DRNRealTimeBlurView

//歌词
@property(nonatomic,copy)NSString *lrcname;
//记录歌词当前显示时间
@property(nonatomic,assign)NSTimeInterval currentTime;

@end
