//
//  RootViewController.m
//  DGDownLoadManager
//
//  Created by Gavin on 15/3/8.
//  Copyright (c) 2015年 Gavin. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController
//-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSInteger index = tabBarController.selectedIndex;
    switch (index) {
        case 0:
            self.navigationItem.title = @"文件列表";
            break;
        case 1:
            self.navigationItem.title = @"正在下载";
            break;
        case 2:
            self.navigationItem.title = @"已下载";
            break;
        default:
            break;
    }
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
