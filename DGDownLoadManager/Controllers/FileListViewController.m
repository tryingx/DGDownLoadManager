//
//  FileListViewController.m
//  DGDownLoadManager
//
//  Created by Gavin on 15/3/8.
//  Copyright (c) 2015年 Gavin. All rights reserved.
//

#import "FileListViewController.h"
#import "FileListTVC.h"

@interface FileListViewController ()

@end

@implementation FileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
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
