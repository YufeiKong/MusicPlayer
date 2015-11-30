//
//  FlyLrcCell.m
//  音乐播放器
//
//  Created by mac on 15/11/29.
//  Copyright © 2015年 flymanshow. All rights reserved.
//

#import "FlyLrcCell.h"
#import "FlyLrcLine.h"

@implementation FlyLrcCell

+(instancetype)lrcCellWithTableView:(UITableView *)tableView{

static NSString *ID = @"LrcCell";
    FlyLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[FlyLrcCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID
        ];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //选中cell模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return  cell;
 }

-(void)setLrcLine:(FlyLrcLine *)lrcLine{

    _lrcLine = lrcLine;
    
    self.textLabel.text = lrcLine.text;

}

@end
