//
//  GFIleDownLoadManager.h
//
//  Created by Bruce Xu on 14-5-12.
//  Copyright (c) 2014年 Pansoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "GFileModel.h"

@protocol GDownloadDelegate <NSObject>
@optional
-(void)startDownload:(ASIHTTPRequest *)request;
-(void)updateCellProgress:(ASIHTTPRequest *)request;
-(void)finishedDownload:(ASIHTTPRequest *)request;
-(void)failedDownload:(ASIHTTPRequest *)request;
@end





@interface GFIleDownLoadManager : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>{
    NSInteger type;
    NSInteger  maxcount;
    int count;
}
//实例化方法
+(GFIleDownLoadManager *) sharedFilesDownManage;

+(GFIleDownLoadManager *) sharedFilesDownManageWithBasepath:(NSString *)basepath
                                             TargetPathArr:(NSArray *)targetpaths;

//下载文件执行方法
-(void)downFileUrl:(NSString*) urlStr filename:(NSString*)name filetarget:(NSString*)path ComposerName:(NSString *)composername EnglishName:(NSString *)englishname FilePid:(NSString *)origialVideoId FileID:(NSString *)fileId CollectionState:(NSString *)collectionState FileDuration:(NSString *)duration FileBrif:(NSString *)filebrif;

@property(nonatomic,retain)NSMutableArray *finishedlist;//已下载完成的文件列表（文件对象）
@property(nonatomic,retain)NSMutableArray *downinglist;//正在下载的文件列表(ASIHttpRequest对象)
@property (nonatomic, strong) ASINetworkQueue *queue;//下载队列
@property(nonatomic,retain)id<GDownloadDelegate> downloadDelegate;//下载列表delegate
//用userinfo存fileModel，不知道为啥 有时候文件大小会丢失，这里新加一个字典，保存文件大小
@property(nonatomic,retain) NSMutableDictionary *fileNameDic;
-(void)saveFinishedFile;
//-(void)startLoad;

-(void)stopRequest:(ASIHTTPRequest *)request;

-(NSMutableArray *)getTempFiles;

//删除下载文件
-(void)deleteFinishFile:(GFileModel *)selectFile;

//删除正在下载的请求
-(NSMutableArray *)deleteRequest:(ASIHTTPRequest *)request;

//初始化并继续下载
- (void)loadTempFileASINetworkQueueWithGuid:(GFileModel*)fileInfo IndexPath:(NSInteger)index;

//继续下载
- (void)downloadAgainRequestWithGuid:(GFileModel*)fileInfo IndexPath:(NSInteger)index;

- (void)newASINetworkQueueWithUrl:(GFileModel *)fileInfo;

@end
