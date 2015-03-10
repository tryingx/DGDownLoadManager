//
//  FileListViewController.m
//  DGDownLoadManager
//
//  Created by Gavin on 15/3/8.
//  Copyright (c) 2015年 Gavin. All rights reserved.
//

#import "FileListViewController.h"
#import "FileListTVC.h"

//文件数量为：10
#define FILE_NUM 10

@interface FileListViewController (){
    NSArray *fileUrlArray;
    NSArray *fileNameArray;
    NSArray *fileBirefArray;
    NSArray *filePicArray;
}

@end

@implementation FileListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //对象实例化
    [self initObjectOfMethod];
}
#pragma mark 布局UI
-(void)buildUIView{
   
}
#pragma mark 对象实例化方法
-(void)initObjectOfMethod{
    //文件数量为10
    fileUrlArray = [NSArray arrayWithObjects:
                    @"http://yinyueshiting.baidu.com/data2/music/134378751/1201250291425873661128.mp3?xcode=58b49358bb29c3da4563b475f855113ca6a03c85c06f4409",
                    @"http://yinyueshiting.baidu.com/data2/music/134378751/1201250291425873661128.mp3?xcode=58b49358bb29c3da4563b475f855113ca6a03c85c06f4409",
                    @"http://yinyueshiting.baidu.com/data2/music/134378751/1201250291425873661128.mp3?xcode=58b49358bb29c3da4563b475f855113ca6a03c85c06f4409",
                    @"http://yinyueshiting.baidu.com/data2/music/134378751/1201250291425873661128.mp3?xcode=58b49358bb29c3da4563b475f855113ca6a03c85c06f4409",
                    @"http://yinyueshiting.baidu.com/data2/music/134378751/1201250291425873661128.mp3?xcode=58b49358bb29c3da4563b475f855113ca6a03c85c06f4409",
                    @"http://yinyueshiting.baidu.com/data2/music/134378751/1201250291425873661128.mp3?xcode=58b49358bb29c3da4563b475f855113ca6a03c85c06f4409",
                    @"http://yinyueshiting.baidu.com/data2/music/134378751/1201250291425873661128.mp3?xcode=58b49358bb29c3da4563b475f855113ca6a03c85c06f4409",
                    @"http://yinyueshiting.baidu.com/data2/music/134378751/1201250291425873661128.mp3?xcode=58b49358bb29c3da4563b475f855113ca6a03c85c06f4409",
                    @"http://yinyueshiting.baidu.com/data2/music/134378751/1201250291425873661128.mp3?xcode=58b49358bb29c3da4563b475f855113ca6a03c85c06f4409",
                    @"http://yinyueshiting.baidu.com/data2/music/134378751/1201250291425873661128.mp3?xcode=58b49358bb29c3da4563b475f855113ca6a03c85c06f4409",nil];
    //文件数量为10
    fileNameArray = [NSArray arrayWithObjects:
                      @"小苹果-筷子兄弟",
                      @"小苹果-筷子兄弟",
                      @"小苹果-筷子兄弟",
                      @"小苹果-筷子兄弟",
                      @"小苹果-筷子兄弟",
                      @"小苹果-筷子兄弟",
                      @"小苹果-筷子兄弟",
                      @"小苹果-筷子兄弟",
                      @"小苹果-筷子兄弟",
                      @"小苹果-筷子兄弟",nil];
    //文件数量为10
    fileBirefArray = [NSArray arrayWithObjects:
                      @"歌曲《小苹果》作为“筷子兄弟”（肖央、王太利）、屈菁菁主演的电影《老男孩之猛龙过江》的宣传曲，由王太利作词作曲，2014年5月3日发布。",
                      @"歌曲《小苹果》作为“筷子兄弟”（肖央、王太利）、屈菁菁主演的电影《老男孩之猛龙过江》的宣传曲，由王太利作词作曲，2014年5月3日发布。",
                      @"歌曲《小苹果》作为“筷子兄弟”（肖央、王太利）、屈菁菁主演的电影《老男孩之猛龙过江》的宣传曲，由王太利作词作曲，2014年5月3日发布。",
                      @"歌曲《小苹果》作为“筷子兄弟”（肖央、王太利）、屈菁菁主演的电影《老男孩之猛龙过江》的宣传曲，由王太利作词作曲，2014年5月3日发布。",
                      @"歌曲《小苹果》作为“筷子兄弟”（肖央、王太利）、屈菁菁主演的电影《老男孩之猛龙过江》的宣传曲，由王太利作词作曲，2014年5月3日发布。",
                      @"歌曲《小苹果》作为“筷子兄弟”（肖央、王太利）、屈菁菁主演的电影《老男孩之猛龙过江》的宣传曲，由王太利作词作曲，2014年5月3日发布。",
                      @"歌曲《小苹果》作为“筷子兄弟”（肖央、王太利）、屈菁菁主演的电影《老男孩之猛龙过江》的宣传曲，由王太利作词作曲，2014年5月3日发布。",
                      @"歌曲《小苹果》作为“筷子兄弟”（肖央、王太利）、屈菁菁主演的电影《老男孩之猛龙过江》的宣传曲，由王太利作词作曲，2014年5月3日发布。",
                      @"歌曲《小苹果》作为“筷子兄弟”（肖央、王太利）、屈菁菁主演的电影《老男孩之猛龙过江》的宣传曲，由王太利作词作曲，2014年5月3日发布。",
                      @"歌曲《小苹果》作为“筷子兄弟”（肖央、王太利）、屈菁菁主演的电影《老男孩之猛龙过江》的宣传曲，由王太利作词作曲，2014年5月3日发布。", nil];
    //文件数量为10
    filePicArray = [NSMutableArray arrayWithObjects:
                    @"small_apple.jpg",
                    @"small_apple.jpg",
                    @"small_apple.jpg",
                    @"small_apple.jpg",
                    @"small_apple.jpg",
                    @"small_apple.jpg",
                    @"small_apple.jpg",
                    @"small_apple.jpg",
                    @"small_apple.jpg",
                    @"small_apple.jpg",nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return FILE_NUM;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"FileListTVC";
    FileListTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.fileImageBtn setBackgroundImage:[UIImage imageNamed:[filePicArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    cell.fileNameLab.text = [fileNameArray objectAtIndex:indexPath.row];
    cell.fileBrifLab.text = [fileBirefArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
