//
//  FlyLrcView.m
//  音乐播放器
//
//  Created by mac on 15/11/29.
//  Copyright © 2015年 flymanshow. All rights reserved.
//

#import "FlyLrcView.h"
#import "FlyLrcCell.h"
#import "UIView+AdjustFrame.h"

@interface FlyLrcView( )<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)UITableView *tableView;

@end

@implementation FlyLrcView

//-(id)initWithCoder:(NSCoder *)aDecoder{
//   if ([super initWithCoder:aDecoder]) {
//        [self setupTableView];
//        
//   }
//    
//    return self;
//    
//}


- (void)awakeFromNib {
    //    [super awakeFromNib];
    [self setupTableView];
    //    NSLog(@"%@", NSStringFromCGRect(self.bounds));
    //    NSLog(@"awakeFromNib");
}
-(void)setupTableView{

    UITableView *tableView = [[UITableView alloc]init];
    
    tableView.frame = self.bounds;
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    
    
    [self addSubview:tableView];
    self.tableView = tableView;


}
//设置frame
-(void)layoutSubviews{

    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.height * 0.5, 0, self.tableView.height * 0.5, 0);
    

}

#pragma mark  - tableview的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 20;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

   FlyLrcCell *cell = [FlyLrcCell lrcCellWithTableView:tableView];
    
    cell.textLabel.text = @"歌词";
 
    
    return  cell;



}

@end
