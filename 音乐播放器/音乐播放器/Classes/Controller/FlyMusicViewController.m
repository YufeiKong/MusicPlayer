//
//  FlyMusicViewController.m
//  音乐播放器
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 flymanshow. All rights reserved.
//

#import "FlyMusicViewController.h"
#import "FlyMusic.h"
#import "MJExtension.h"
#import "UIImage+Circle.h"
#import "FlyPlayingViewController.h"

@interface FlyMusicViewController ()

@property(nonatomic,strong)NSArray *musics;

//播放的控制器
@property(nonatomic,strong)FlyPlayingViewController *playingVC;

@end

@implementation FlyMusicViewController

#pragma mark  懒加载

-(NSArray *)musics{
    if (_musics==nil) {
        
        self.musics = [FlyMusic objectArrayWithFilename:@"Musics.plist"];
        
        
    }

    return _musics;
}


-(FlyPlayingViewController *)playingVC{

    if (_playingVC == nil) {
        _playingVC = [[FlyPlayingViewController alloc]init];
    }
    
    return _playingVC;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置高度
    self.tableView.rowHeight = 80;
    
  
}

#pragma MARK  代理

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //让cell变为不选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    //弹出播放控制器
    [self.playingVC show];



}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return  self.musics.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    static NSString *ID = @"MUSICID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
   
    //设置单元格内容
    
    //取出模型
    
    FlyMusic *musics = self.musics[indexPath.row];
    
    cell.imageView.image = [UIImage circleImageWithName:musics.icon borderWidth:3.0 borderColor:[UIColor purpleColor]];
    cell.textLabel.text = musics.name;
    cell.detailTextLabel.text=musics.singer;
    
    return  cell;
    
    
}


@end
