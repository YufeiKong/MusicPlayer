//
//  FlyLrcCell.h
//  音乐播放器
//
//  Created by mac on 15/11/29.
//  Copyright © 2015年 flymanshow. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlyLrcLine;
@interface FlyLrcCell : UITableViewCell


@property(nonatomic,strong)FlyLrcLine *lrcLine;
+(instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
