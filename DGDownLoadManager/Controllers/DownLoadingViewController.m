//
//  DownLoadingViewController.m
//  DGDownLoadManager
//
//  Created by Gavin on 15/3/8.
//  Copyright (c) 2015年 Gavin. All rights reserved.
//

#import "DownLoadingViewController.h"
#import "FileListTVC.h"

#define VIEW_Width self.view.bounds.size.width
#define VIEW_Height self.view.bounds.size.height

@interface DownLoadingViewController (){
    UIButton *allOptionBtn;
}

@end

@implementation DownLoadingViewController
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"++++++++%f",self.downloadingTableView.frame.origin.y);
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark 全部删除按钮执行方法
-(void)didClickToDelegateAllFile:(UIButton *)sender{
    NSLog(@"全部删除按钮执行方法");
}
#pragma mark 全部暂停/全部开始执行方法
-(void)didClickToControlAll:(UIButton *)sender{
    NSLog(@"全部暂停全部开始执行方法");
}
#pragma mark UITableViewDelegate&UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *allOptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    allOptionView.backgroundColor = [UIColor orangeColor];
    
    UIButton *allDelegateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allDelegateBtn.frame = CGRectMake(0, 0, VIEW_Width / 2, 40);
    [allDelegateBtn setCenter:CGPointMake(VIEW_Width / 4, allOptionView.bounds.size.height / 2)];
    [allDelegateBtn setTitle:@"全部删除" forState:UIControlStateNormal];
    [allDelegateBtn setTintColor:[UIColor whiteColor]];
    [allDelegateBtn setBackgroundColor:[UIColor redColor]];
    [allDelegateBtn addTarget:self action:@selector(didClickToDelegateAllFile:) forControlEvents:UIControlEventTouchUpInside];
    
    allOptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allOptionBtn.frame = CGRectMake(0, 0, VIEW_Width / 2, 40);
    [allOptionBtn setCenter:CGPointMake(VIEW_Width / 4 * 3, allOptionView.bounds.size.height / 2)];
    [allOptionBtn setTitle:@"全部开始" forState:UIControlStateNormal];
    [allOptionBtn setTintColor:[UIColor whiteColor]];
    [allOptionBtn setBackgroundColor:[UIColor blueColor]];
    [allOptionBtn addTarget:self action:@selector(didClickToControlAll:) forControlEvents:UIControlEventTouchUpInside];
    
    [allOptionView addSubview:allDelegateBtn];
    [allOptionView addSubview:allOptionBtn];
    
    return allOptionView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"FileListTVC";
    FileListTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell.fileImageBtn setBackgroundImage:[UIImage imageNamed:@"DGFile_Logo"] forState:UIControlStateNormal];
    cell.fileNameLab.text = [NSString stringWithFormat:@"这是第%ld个文件",indexPath.row + 1];
    cell.fileBrifLab.text = [NSString stringWithFormat:@"这是DGDownLoadManager的一个文件的简介，这个文件可以在详情页面进行对本文件的下载以及查看文件的信息详情。"];
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
