//
//  FlyPlayingViewController.m
//  音乐播放器
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 flymanshow. All rights reserved.
//

#import "FlyPlayingViewController.h"
#import "UIView+AdjustFrame.h"

@interface FlyPlayingViewController ()

@end

@implementation FlyPlayingViewController


-(void)show{
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
        
    }];


    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}


@end
