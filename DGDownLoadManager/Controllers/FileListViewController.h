//
//  FileListViewController.h
//  DGDownLoadManager
//
//  Created by Gavin on 15/3/8.
//  Copyright (c) 2015年 Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *fileListTableView;

@end
