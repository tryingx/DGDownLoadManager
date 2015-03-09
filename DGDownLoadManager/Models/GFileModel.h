//
//  FileModel.h
//  YunPan
//
//  Created by Bruce Xu on 14-5-12.
//  Copyright (c) 2014年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFileModel : NSObject
@property (nonatomic,retain)NSString *fileID;
@property (nonatomic,retain)NSString *fileName;
@property (nonatomic,retain)NSString *fileSize;
@property(nonatomic,retain)NSString *fileComposerName;
@property(nonatomic,retain)NSString *fileEnglishName;

@property (nonatomic)BOOL isFirstReceived;//是否是第一次接受数据，如果是则不累加第一次返回的数据长度，之后变累加
@property (nonatomic,retain)NSString *fileReceivedSize;
@property (nonatomic,retain)NSMutableData *fileReceivedData;//接受的数据
@property (nonatomic,retain)NSString *fileURL;
@property (nonatomic,retain)NSString *time;
@property (nonatomic,retain)NSString *targetPath;
@property (nonatomic,retain)NSString *tempPath;
@property (nonatomic)BOOL isDownloading;//是否正在下载
@property (nonatomic)BOOL  willDownloading;
@property (nonatomic)BOOL error;
@property BOOL post;
@property int PostPointer;
@property (nonatomic,retain)NSString *postUrl;
@property (nonatomic,retain)NSString *fileUploadSize;
@property (nonatomic,retain)NSString *usrname;

@property (nonatomic,retain) NSString *brief;                   //音频简介
@property (nonatomic,retain) NSString *smallImaUrl;             //小图片链接
@property (nonatomic,retain) NSString *pid;                     //文件pid
@property (nonatomic,retain) NSString *isCollection;            //收藏状态
@property (nonatomic,retain) NSString *duration;                //音频文件时长


@end
