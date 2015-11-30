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
#import "FlyLrcLine.h"

@interface FlyLrcView( )<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSArray *lrcLines;
@property(nonatomic,assign) NSInteger  currentIndex;
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
    
    self.currentIndex = -1;
    
    
    
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

    return self.lrcLines.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

   FlyLrcCell *cell = [FlyLrcCell lrcCellWithTableView:tableView];
    
    cell.lrcLine = self.lrcLines[indexPath.row];
 
    if (indexPath.row == self.currentIndex) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    }else{
    
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return  cell;



}
//重写歌词
-(void)setLrcname:(NSString *)lrcname{

    _lrcname= lrcname;
    
    
    //加载对应歌词
    NSString *path = [[NSBundle mainBundle]pathForResource:lrcname ofType:nil];
    NSString *lrcSring = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"%@",lrcSring);
    /*
     [ti:最佳損友]
     [ar:陳奕迅]
     [al:《Life Continues...》]
     
     [00:00.10]最佳損友
     [00:00.20]演唱：陳奕迅
     [00:00.30]專輯：《Life Continues...》
     [00:00.40]作詞：黃偉文
     [00:00.50]作曲：Eric Kwok
     [00:00.60]
     [00:00.64]朋友 我當你一秒朋友
     [00:06.47]朋友 我當你一世朋友
     [00:13.13]奇怪 過去再不堪回首
     [00:19.86]懷緬 時時其實還有
     [00:25.30]
     [00:26.51]朋友 你試過將我營救
     [00:33.11]朋友 你試過把我批鬥
     [00:39.77]無法 再與你交心聯手
     [00:46.08]畢竟難得 有過最佳損友
     
     */
    
    
    //解析歌词
    //分割字符串
    NSArray *lrcLineStrs = [lrcSring componentsSeparatedByString:@"\n"];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSString *lrcLineStr in lrcLineStrs) {
        //移除不要的行
        if ([lrcLineStr hasPrefix:@"[ti"]||[lrcLineStr hasPrefix:@"[ar"]||[lrcLineStr hasPrefix:@"[al"]|| ![lrcLineStr hasPrefix:@"["]) {
            
            continue;
            
        }
      //截取每一行字符串
        NSArray *lrcLineStrParts = [lrcLineStr componentsSeparatedByString:@"]"];
        FlyLrcLine *lrcLine = [[FlyLrcLine alloc]init];
        
        lrcLine.text = [lrcLineStrParts lastObject];
        lrcLine.time = [[lrcLineStrParts firstObject]substringFromIndex:1];
       //将模型添加到数据
        
        [tempArray addObject:lrcLine];
        
    }
    
    self.lrcLines = tempArray;
    //刷新数据
    [self.tableView reloadData];

}


//重写当前时间
-(void)setCurrentTime:(NSTimeInterval)currentTime{
    if (_currentTime > currentTime) {
        self.currentIndex = -1;
    }
    

    _currentTime = currentTime;
    
    //将传入的时间转换成字符串
    NSInteger minute = currentTime /60;
    NSInteger second = (NSInteger)currentTime % 60;
    NSInteger milesecond = (currentTime - (NSInteger)currentTime)* 1000;
    
    NSString *currentStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",minute,second,milesecond];
    
    
    //对比时间
    NSInteger count = self.lrcLines.count;
    
    for (NSInteger i =self.currentIndex + 1; i<count; i++) {
        
        //取出当前歌词模型
        FlyLrcLine *lrcline = self.lrcLines[i];
        
        //取出下一个歌词模型
        NSInteger nextIndex = i + 1;
        if (nextIndex < count) {
            FlyLrcLine *nextLrcLine = self.lrcLines[nextIndex];
            
            //比较时间
            if ([currentStr compare:lrcline.time]!=NSOrderedAscending && [currentStr compare:nextLrcLine.time] != NSOrderedDescending && self.currentIndex != i) {
                self.currentIndex = i;
                NSIndexPath *currentIndex = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
                NSIndexPath *nextIndex = [NSIndexPath indexPathForRow:i inSection:0];
                
                [self.tableView reloadRowsAtIndexPaths:@[currentIndex,nextIndex] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView scrollToRowAtIndexPath:nextIndex atScrollPosition: UITableViewScrollPositionTop animated:YES];
                
                NSLog(@"%@----%@----%@",currentStr,lrcline.time,nextLrcLine.time);
                
                
            }
            
            
        }
        
    }
    


}
@end
