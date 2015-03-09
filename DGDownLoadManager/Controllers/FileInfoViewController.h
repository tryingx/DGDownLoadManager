//
//  FileInfoViewController.h
//  DGDownLoadManager
//
//  Created by Gavin on 15/3/9.
//  Copyright (c) 2015年 Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileInfoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)didClickBack:(UIButton *)sender;
@end
