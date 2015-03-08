//
//  GFIleDownLoadManager.m
//
//  Created by Bruce Xu on 14-5-12.
//  Copyright (c) 2014年 Pansoft. All rights reserved.
//

#import "GFIleDownLoadManager.h"
#import "ASIFormDataRequest.h"
#import "GFileModel.h"
#import "GCommonHelper.h"
#import "CommonCrypto/CommonDigest.h"

#define TEMPPATH [GCommonHelper getTempFolderPathWithBasepath:_basepath]
@interface GFIleDownLoadManager()
{}
@property(nonatomic,strong) GFileModel *fileInfo;


@property(nonatomic,retain)NSString *basepath;
@property(nonatomic,retain)NSString *TargetSubPath;

@property(nonatomic,retain)NSMutableArray *filelist;
@property(nonatomic,retain)NSMutableArray *targetPathArray;


@end
@implementation GFIleDownLoadManager
@synthesize queue,fileInfo=_fileInfo,basepath=_basepath,finishedlist=_finishedlist,downinglist=_downinglist;
@synthesize fileNameDic=_fileNameDic;
static  GFIleDownLoadManager *sharedFilesDownManage = nil;

-(void)downFileUrl:(NSString*) urlStr filename:(NSString*)name filetarget:(NSString*)path ComposerName:(NSString *)composername EnglishName:(NSString *)englishname FilePid:(NSString *)origialVideoId FileID:(NSString *)fileId CollectionState:(NSString *)collectionState FileDuration:(NSString *)duration FileBrif:(NSString *)filebrif
{
     self.TargetSubPath = path;
    
    //组装下载文件
    _fileInfo = [[GFileModel alloc]init];
    _fileInfo.fileName = name;
    _fileInfo.fileURL = urlStr;
    _fileInfo.fileComposerName = composername;
    _fileInfo.fileEnglishName = englishname;
    _fileInfo.pid = origialVideoId;
    _fileInfo.fileID = fileId;
    _fileInfo.isCollection = collectionState;
    _fileInfo.duration = duration;
    _fileInfo.brief = filebrif;
    
    path= [GCommonHelper getTargetPathWithBasepath:_basepath subpath:path];
    NSString *FileLoadName = [self md5:fileId];
    FileLoadName = [NSString stringWithFormat:@"%@_320",FileLoadName];
    path = [path stringByAppendingPathComponent:FileLoadName];
    
    _fileInfo.targetPath = path ; //下载路径
    _fileInfo.isDownloading=YES;
    _fileInfo.willDownloading = YES;
    _fileInfo.error = NO;
    _fileInfo.isFirstReceived = YES;
    
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    
    //临时路径
    NSString *tempfilePath= [[TEMPPATH stringByAppendingPathComponent:userIdStr] stringByAppendingPathComponent:FileLoadName];
    _fileInfo.tempPath = tempfilePath;
   
    NSLog(@"path =%@",path);
    //判断是否已经下载过此音乐
    if([GCommonHelper isExistFile: _fileInfo.targetPath])//已经下载过一次该音乐
    {
    
//        NSString *messageStr = [NSString stringWithFormat:@"%@该文件已下载！",_fileInfo.fileName];
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
//        [alert show];
        
//        return;
    }
    
  NSMutableArray * tempAllArr=[self getTempFiles];
    
    BOOL IsExite=NO;
    for(int i=0;i<tempAllArr.count;i++) //这里简化逻辑，正在下载的就不用在重新下载了
    {
        GFileModel *fModel=[tempAllArr objectAtIndex:i];
        if([fModel.fileName isEqualToString:_fileInfo.fileName])
        {
            IsExite=YES;
            break;
        }
        
    }
    if(!IsExite)
    {
         [_filelist addObject:_fileInfo];
         [self saveDownloadFile:_fileInfo];
    }
    else
    {
        NSString *fName=_fileInfo.fileName;
        NSString *ftext=[NSString stringWithFormat:@"%@已经进入下载队列",fName] ;
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:ftext delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alert show];
        return;
    }
 
    //只有从入口进去的才启动下载，只是打开页面不执行
    
   //  [queue go];

    
    if (queue==nil){
        queue = [[ASINetworkQueue alloc]init];
        queue.maxConcurrentOperationCount = 1;
        
        [queue setShowAccurateProgress:YES];
        [queue setShouldCancelAllRequestsOnFailure:NO];
        [queue go];
        [self addNewRequestWithGuid:_fileInfo];
//        [self newASINetworkQueueWithUrl:_fileInfo];

    }else{
        [self addNewRequestWithGuid:_fileInfo];
    }
   
}
//密码md5加密
-(NSString *)md5:(NSString *)inPutText
{
    
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    
}
//初始化，读取Temp文件下载
- (void)loadTempFileASINetworkQueueWithGuid:(GFileModel*)fileInfo IndexPath:(NSInteger)index
{
    if(queue==nil)
        queue = [[ASINetworkQueue alloc]init];
    
    queue.maxConcurrentOperationCount = 1;
    
    [queue setShowAccurateProgress:YES];
    
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fileInfo.fileURL]];
    request.delegate=self;
    [request setDownloadDestinationPath:[fileInfo targetPath]];
    [request setTemporaryFileDownloadPath:fileInfo.tempPath];
    [request setDownloadProgressDelegate:self];
    [request setNumberOfTimesToRetryOnTimeout:2];
    [request setAllowResumeForFileDownloads:NO];//不支持断点续传
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信

    [request cancel];
    
//    [queue addOperation:request];
    
//    if ([self.downinglist containsObject:request]) {
//        
//    }else{
//        [self.downinglist insertObject:request atIndex:index];
// 
//    }
    
    
    BOOL oldexit = NO;
    
    for (int i=0; i<self.downinglist.count; ++i) {
        ASIHTTPRequest *theRequest=[self.downinglist objectAtIndex:i];
        GFileModel *oldfileInfo=[theRequest.userInfo objectForKey:@"File"];
        if ([oldfileInfo.fileName isEqualToString:fileInfo.fileName]) {
            oldexit = YES;
        }
    }
    
    if (oldexit==YES) {
        
    }else{
        [self.downinglist insertObject:request atIndex:index];
        [queue addOperation:request];

    }
    
    [queue go];
}
//暂停，重新开始下载
- (void)downloadAgainRequestWithGuid:(GFileModel*)fileInfo IndexPath:(NSInteger)index
{
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fileInfo.fileURL]];
    request.delegate=self;
    [request setDownloadDestinationPath:[fileInfo targetPath]];
    [request setTemporaryFileDownloadPath:fileInfo.tempPath];
    [request setDownloadProgressDelegate:self];
    [request setNumberOfTimesToRetryOnTimeout:2];
    [request setAllowResumeForFileDownloads:NO];//不支持断点续传
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信
    
//    [queue addOperation:request];
//    [self.downinglist insertObject:request atIndex:index];
    
//    if ([self.downinglist containsObject:request]) {
//        
//    }else{
//        [self.downinglist insertObject:request atIndex:index];
//        
//    }
    
    BOOL oldexit = NO;
    
    for (int i=0; i<self.downinglist.count; ++i) {
        ASIHTTPRequest *theRequest=[self.downinglist objectAtIndex:i];
        GFileModel *oldfileInfo=[theRequest.userInfo objectForKey:@"File"];
        if ([oldfileInfo.fileName isEqualToString:fileInfo.fileName]) {
            oldexit = YES;
        }
    }
    
    if (oldexit==YES) {
        [queue addOperation:request];
        [self.downinglist replaceObjectAtIndex:index withObject:request];
        
        
    }else{
//        [self.downinglist insertObject:request atIndex:index];
//        [queue addOperation:request];

    }
    [queue go];
}

//初始化队列，并向队列加入任务

- (void)newASINetworkQueueWithUrl:(GFileModel *)fileInfo
{
   
    
    if(queue ==nil){
        queue = [[ASINetworkQueue alloc]init];

    }else{

    }

//    if (!queue){
//        queue = [[ASINetworkQueue alloc]init];
//        queue.maxConcurrentOperationCount = 1;
//        
//        [queue setShowAccurateProgress:YES];
//        [queue setShouldCancelAllRequestsOnFailure:NO];
//        [queue go];
//        [self addNewRequestWithGuid:_fileInfo];
//    }else{
//        [self addNewRequestWithGuid:_fileInfo];
//    }
    
    
    queue.maxConcurrentOperationCount = 1;
    
    [queue setShowAccurateProgress:YES];
    
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fileInfo.fileURL]];
    request.delegate=self;
    [request setDownloadDestinationPath:[fileInfo targetPath]];
    [request setTemporaryFileDownloadPath:fileInfo.tempPath];
    [request setDownloadProgressDelegate:self];
    [request setNumberOfTimesToRetryOnTimeout:2];
    [request setAllowResumeForFileDownloads:NO];//不支持断点续传
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
    
//    [queue addOperation:request];
//    [self.downinglist addObject:request];
//    if ([self.downinglist containsObject:request]) {
//        
//    }else{
//        [self.downinglist addObject:request];
//        
//    }
    BOOL oldexit = NO;
    
    for (int i=0; i<self.downinglist.count; ++i) {
        ASIHTTPRequest *theRequest=[self.downinglist objectAtIndex:i];
        GFileModel *oldfileInfo=[theRequest.userInfo objectForKey:@"File"];
        if ([oldfileInfo.fileName isEqualToString:fileInfo.fileName]) {
            oldexit = YES;
        }
    }
    
    if (oldexit==YES) {
        
    }else{
        [self.downinglist addObject:request];
        [queue addOperation:request];
//        [queue go];

    }
    
    [queue setShouldCancelAllRequestsOnFailure:NO];
    
    //只有从入口进去的才启动下载，只是打开页面不执行
    [queue go];
}

//向队列中加入任务
- (void)addNewRequestWithGuid:(GFileModel *)fileInfo
{
    if(queue==nil){
        queue = [[ASINetworkQueue alloc]init];

    }
    
    [queue setShowAccurateProgress:YES];
    
    queue.maxConcurrentOperationCount = 1;
    
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fileInfo.fileURL]];
    request.delegate=self;
    [request setDownloadDestinationPath:[fileInfo targetPath]];
    [request setTemporaryFileDownloadPath:fileInfo.tempPath];
    [request setDownloadProgressDelegate:self];
    [request setNumberOfTimesToRetryOnTimeout:2];
    [request setAllowResumeForFileDownloads:NO];//不支持断点续传
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信
    
//    [queue addOperation:request];
//    [self.downinglist addObject:request];
    
    BOOL oldexit = NO;
    
    for (int i=0; i<self.downinglist.count; ++i) {
        ASIHTTPRequest *theRequest=[self.downinglist objectAtIndex:i];
        GFileModel *oldfileInfo=[theRequest.userInfo objectForKey:@"File"];
        if ([oldfileInfo.fileName isEqualToString:fileInfo.fileName]) {
            oldexit = YES;
        }
    }
    
    if (oldexit==YES) {
        
    }else{
        [self.downinglist addObject:request];
        [queue addOperation:request];

    }
    
    [queue go];
}

//
-(void)saveDownloadFile:(GFileModel*)fileinfo{
    
    NSMutableDictionary *filedic = [NSMutableDictionary dictionary];

    NSLog(@"saveFinishedFile-----------file.filename = %@, fileComposerName = %@",fileinfo.fileName,fileinfo.fileComposerName);
    
    if (fileinfo.pid) {
        [filedic setValue:fileinfo.pid forKey:@"pid"];
    }
    if (fileinfo.fileName) {
        [filedic setValue:fileinfo.fileName forKey:@"filename"];
    }
    if (fileinfo.fileID) {
        [filedic setValue:fileinfo.fileID forKey:@"fileID"];
    }
    if (fileinfo.isCollection) {
        [filedic setValue:fileinfo.isCollection forKey:@"isCollection"];
    }
    if (fileinfo.duration) {
        [filedic setValue:fileinfo.duration forKey:@"duration"];
    }
    if (fileinfo.fileComposerName) {
        [filedic setValue:fileinfo.fileComposerName forKey:@"composerName"];
    }
    if (fileinfo.fileSize) {
        [filedic setValue:fileinfo.fileSize forKey:@"filesize"];
    }
    if (fileinfo.targetPath) {
        [filedic setValue:fileinfo.targetPath forKey:@"filepath"];
    }
    if (fileinfo.brief) {
        [filedic setValue:fileinfo.brief forKey:@"brief"];
    }
    if (fileinfo.fileEnglishName) {
        [filedic setValue:fileinfo.fileEnglishName forKey:@"englishName"];
    }
    if (fileinfo.fileURL) {
        [filedic setValue:fileinfo.fileURL forKey:@"fileURL"];
    }
    //        if (imagedata) {
    //            [tempDic setValue:imagedata forKey:@"fileimage"];
    //        }
    //        if (fileinfo.smallImaUrl) {
    //            [tempDic setValue:fileinfo.smallImaUrl forKey:@"smallImag"];
    //        }
    
    NSString *FileLoadName = [self md5:fileinfo.fileID];
    FileLoadName = [NSString stringWithFormat:@"%@_320",FileLoadName];
    
    NSRange range = [fileinfo.tempPath rangeOfString:FileLoadName];
    
    int location = range.location;
    
    NSString *listPath = [fileinfo.tempPath substringToIndex:location - 1];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:listPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:listPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *plistPath = [fileinfo.tempPath stringByAppendingPathExtension:@"plist"];
    if (![filedic writeToFile:plistPath atomically:YES]) {
        NSLog(@"write plist fail");
    }
    else{
        NSLog(@"保存临时文件信息成功");
    }
}


//出错了，如果是等待超时，则继续下载
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error=[request error];
    NSLog(@"ASIHttpRequest出错了!%@",error);
    if (error.code==4) {
        return;
    }
    if ([request isExecuting]) {
        [request cancel];
    }
    [self.downloadDelegate failedDownload:request];
}

-(void)requestStarted:(ASIHTTPRequest *)request
{
     GFileModel *fileInfo=(GFileModel *)[request.userInfo objectForKey:@"File"];
     NSLog(@"%@ ============> 开始了!",fileInfo.fileName);
    [self.downloadDelegate startDownload:request];
    
}

-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    GFileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    NSLog(@"%@ ============> 收到回复了！",fileInfo.fileName);
    
   
    
    NSString *len = [responseHeaders objectForKey:@"Content-Length"];//
    
    NSLog(@"============================================>%@的大小为:%@",fileInfo.fileName,len );
    
    //这个信息头，首次收到的为总大小，那么后来续传时收到的大小为肯定小于或等于首次的值，则忽略
    if ([fileInfo.fileSize longLongValue]> [len longLongValue])
    {
        return;
    }
    
    fileInfo.fileSize = [NSString stringWithFormat:@"%lld",  [len longLongValue]];
    [_fileNameDic setObject:len forKey:fileInfo.fileName];
    [self saveDownloadFile:fileInfo];
    
}

-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    GFileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    NSLog(@"%@,%lld",fileInfo.fileReceivedSize,bytes);
    if (fileInfo.isFirstReceived) {
        fileInfo.isFirstReceived=NO;
        fileInfo.fileReceivedSize =[NSString stringWithFormat:@"%lld",bytes];
    }
    else if(!fileInfo.isFirstReceived)
    {
        
        fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%lld",[fileInfo.fileReceivedSize longLongValue]+bytes];
    }
    if([self.downloadDelegate respondsToSelector:@selector(updateCellProgress:)])
    {
        [self.downloadDelegate updateCellProgress:request];
    }
}

//将正在下载的文件请求ASIHttpRequest从队列里移除，并将其配置文件删除掉,然后向已下载列表里添加该文件对象
-(void)requestFinished:(ASIHTTPRequest *)request
{
    GFileModel *fileInfo=(GFileModel *)[request.userInfo objectForKey:@"File"];
    
    [self.finishedlist addObject:fileInfo];
  
    NSString *configPath=[fileInfo.tempPath stringByAppendingString:@".plist"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if([fileManager fileExistsAtPath:configPath])//如果存在临时文件的配置文件
    {
        [fileManager removeItemAtPath:configPath error:&error];
        if(!error)
        {
            NSLog(@"已经清除临时文件的配置文件");
            
        }
        else{
           NSLog(@"%@",[error description]);
        }
    }
    [_filelist removeObject:fileInfo];
    [_downinglist removeObject:request];
   
    [self saveFinishedFile];

    if([self.downloadDelegate respondsToSelector:@selector(finishedDownload:)])
    {
        [self.downloadDelegate finishedDownload:request];
    }
    
    NSLog(@"%@ ============> 下载结束了！",fileInfo.fileName);
    
    
   // NSLog(@"下载结束了");
   
}

-(void)saveFinishedFile{
   
    if (self.finishedlist==nil) {
        return;
    }
    NSMutableArray *finishedinfo = [[NSMutableArray alloc]init];
    for (GFileModel *fileinfo in self.finishedlist) {
//        NSData *imagedata =UIImagePNGRepresentation(fileinfo.fileimage);
        NSLog(@"saveFinishedFile-----------file.filename = %@, fileComposerName = %@",fileinfo.fileName,fileinfo.fileComposerName);
        
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        
        if (fileinfo.pid) {
            [tempDic setValue:fileinfo.pid forKey:@"pid"];
        }
        if (fileinfo.fileName) {
            [tempDic setValue:fileinfo.fileName forKey:@"filename"];
        }
        if (fileinfo.fileID) {
            [tempDic setValue:fileinfo.fileID forKey:@"fileID"];
        }
        if (fileinfo.isCollection) {
            [tempDic setValue:fileinfo.isCollection forKey:@"isCollection"];
        }
        if (fileinfo.duration) {
            [tempDic setValue:fileinfo.duration forKey:@"duration"];
        }
        if (fileinfo.fileComposerName) {
            [tempDic setValue:fileinfo.fileComposerName forKey:@"composerName"];
        }
        if (fileinfo.fileSize) {
            [tempDic setValue:fileinfo.fileSize forKey:@"filesize"];
        }
        if (fileinfo.targetPath) {
            [tempDic setValue:fileinfo.targetPath forKey:@"filepath"];
        }
        if (fileinfo.brief) {
            [tempDic setValue:fileinfo.brief forKey:@"brief"];
        }
        if (fileinfo.fileEnglishName) {
            [tempDic setValue:fileinfo.fileEnglishName forKey:@"englishName"];
        }
        if (fileinfo.fileURL) {
            [tempDic setValue:fileinfo.fileURL forKey:@"fileURL"];
        }
//        if (imagedata) {
//            [tempDic setValue:imagedata forKey:@"fileimage"];
//        }
//        if (fileinfo.smallImaUrl) {
//            [tempDic setValue:fileinfo.smallImaUrl forKey:@"smallImag"];
//        }
        [finishedinfo addObject:tempDic];
    }
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *plistPath = [[document stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",self.basepath,userIdStr]]stringByAppendingPathComponent:@"finishPlist.plist"];
    if (![finishedinfo writeToFile:plistPath atomically:YES]) {
        NSLog(@"write plist fail");
    }
    else{
        NSLog(@"下载下来的文件信息已经成功保存");
        NSLog(@"%@",NSHomeDirectory());
    }
}

+(GFIleDownLoadManager *) sharedFilesDownManageWithBasepath:(NSString *)basepath
                                         TargetPathArr:(NSArray *)targetpaths{
    @synchronized(self){
        if (sharedFilesDownManage == nil) {
            sharedFilesDownManage = [[self alloc] initWithBasepath: basepath  TargetPathArr:targetpaths];
        }
    }
    if (![sharedFilesDownManage.basepath isEqualToString:basepath]) {
       // [sharedFilesDownManage cleanLastInfo];
        sharedFilesDownManage.basepath = basepath;
        [sharedFilesDownManage loadTempfiles];
        [sharedFilesDownManage loadFinishedfiles];
    }
    sharedFilesDownManage.basepath = basepath;
    sharedFilesDownManage.targetPathArray =[NSMutableArray arrayWithArray:targetpaths];
    return  sharedFilesDownManage;
}

+(GFIleDownLoadManager *) sharedFilesDownManage{
    @synchronized(self){
        if (sharedFilesDownManage == nil) {
            sharedFilesDownManage = [[self alloc] init];
        }
    }
    return  sharedFilesDownManage;
}
+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (sharedFilesDownManage == nil) {
            sharedFilesDownManage = [super allocWithZone:zone];
            return  sharedFilesDownManage;
        }
    }
    return nil;
}

-(id)initWithBasepath:(NSString *)basepath
        TargetPathArr:(NSArray *)targetpaths{
    self.basepath = basepath;
    _targetPathArray = [[NSMutableArray alloc]initWithArray:targetpaths];
       _filelist = [[NSMutableArray alloc]init];
    _downinglist=[[NSMutableArray alloc] init];
    _finishedlist = [[NSMutableArray alloc] init];
    
    _fileNameDic=[[NSMutableDictionary alloc] init];
  
    return  [self init];
}

- (id)init
{
	self = [super init];
	if (self != nil) {
        
        if (self.basepath!=nil) {
           
            [self loadFinishedfiles];//加载下载完的文件
            [self loadTempfiles]; //加载临时文件
        }
        
    }
	return self;
}
-(GFileModel *)getTempfile:(NSString *)path{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    GFileModel *file = [[GFileModel alloc]init];
    file.fileName = [dic objectForKey:@"filename"];
    file.fileURL = [dic objectForKey:@"fileURL"];
    file.fileReceivedSize= [dic objectForKey:@"filerecievesize"];
    file.fileID = [dic objectForKey:@"fileID"];
    file.brief = [dic objectForKey:@"brief"];
    file.fileComposerName = [dic objectForKey:@"composerName"];
    file.duration = [dic objectForKey:@"duration"];
    file.fileEnglishName = [dic objectForKey:@"englishName"];
    file.isCollection = [dic objectForKey:@"isCollection"];
    file.pid = [dic objectForKey:@"pid"];
    
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    
    NSString*  path1= [GCommonHelper getTargetPathWithBasepath:self.basepath subpath:self.TargetSubPath];
    NSString *FileLoadName = [self md5:file.fileID];
    FileLoadName = [NSString stringWithFormat:@"%@_320",FileLoadName];
    path1 = [[[path1 stringByAppendingPathComponent:userIdStr] stringByAppendingPathComponent:@"tempdownload"] stringByAppendingPathComponent:FileLoadName];
    
    file.targetPath = path1;
    NSString *tempfilePath= [[TEMPPATH stringByAppendingPathComponent:userIdStr] stringByAppendingPathComponent:FileLoadName];
    file.tempPath = tempfilePath;
//    file.fileimage = [UIImage imageWithData:[dic objectForKey:@"fileimage"]];
    file.error = NO;
    
//    NSData *fileData=[[NSFileManager defaultManager ] contentsAtPath:file.tempPath];
//    NSInteger receivedDataLength=[fileData length];
//    file.fileReceivedSize=[NSString stringWithFormat:@"%d",receivedDataLength];
    return file;
}

-(void)loadTempfiles
{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *listPath = [TEMPPATH stringByAppendingPathComponent:userIdStr];
    
    //如果listPath路径下文件不存在，创建文件目录
    if (![[NSFileManager defaultManager]fileExistsAtPath:listPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:listPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:listPath error:&error];
    if(error)
    {
        NSLog(@"%@",[error description]);
    }
    NSMutableArray *filearr = [[NSMutableArray alloc]init];
    for(NSString *file in filelist)
    {
        NSString *filetype = [file  pathExtension];
        if([filetype isEqualToString:@"plist"])
            [filearr addObject:[self getTempfile:[listPath stringByAppendingPathComponent:file]]];
    }
    
   
    [_filelist addObjectsFromArray:filearr];
    
    for (id fileM in _filelist) {
//        [self keepOnAddNewRequestWithGuid:(GFileModel *)fileM];
        [self loadTempFileASINetworkQueueWithGuid:(GFileModel *)fileM IndexPath:0];
    }
   
}
-(NSMutableArray *)getTempFiles
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:TEMPPATH error:&error];
    if(error)
    {
        NSLog(@"%@",[error description]);
    }
    NSMutableArray *filearr = [[NSMutableArray alloc]init];
    for(NSString *file in filelist)
    {
        NSString *filetype = [file  pathExtension];
        if([filetype isEqualToString:@"plist"])
            [filearr addObject:[self getTempfile:[TEMPPATH stringByAppendingPathComponent:file]]];
    }
    return [filearr mutableCopy];
}





-(void)loadFinishedfiles
{
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *plistPath = [[document stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",self.basepath,userIdStr]]stringByAppendingPathComponent:@"finishPlist.plist"];
    if ([[NSFileManager defaultManager]fileExistsAtPath:plistPath]) {
        NSMutableArray *finishArr = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
        for (NSDictionary *dic in finishArr) {
            GFileModel *file = [[GFileModel alloc]init];
            file.fileName = [dic objectForKey:@"filename"];
            file.fileSize = [dic objectForKey:@"filesize"];
            file.targetPath = [dic objectForKey:@"filepath"];
            file.fileComposerName = [dic objectForKey:@"composerName"];
            file.duration = [dic objectForKey:@"duration"];
//            file.fileimage = [UIImage imageWithData:[dic objectForKey:@"fileimage"]];
            file.fileURL = [dic objectForKey:@"fileURL"];
            file.pid = [dic objectForKey:@"pid"];
            file.fileID = [dic objectForKey:@"fileID"];
            file.isCollection = [dic objectForKey:@"isCollection"];
            file.targetPath = [dic objectForKey:@"filepath"];
            file.brief = [dic objectForKey:@"brief"];
            file.fileEnglishName = [dic objectForKey:@"englishName"];
            
            [_finishedlist addObject:file];
           
        }
       
    }
}


-(void)stopRequest:(ASIHTTPRequest *)request{
   
    if([request isExecuting])
    {
        [request cancel];
    }
   /* FileModel *fileInfo =  [request.userInfo objectForKey:@"File"];
    for (FileModel *file in _filelist) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            file.isDownloading = NO;
            file.willDownloading = NO;
             break;
         }
    }
  */
    

}
-(NSMutableArray *)deleteRequest:(ASIHTTPRequest *)request{
    if ([request isExecuting]) {
        [request cancel];
    }else{
        [request cancel];
    }
    GFileModel *fileInfo=(GFileModel *)[request.userInfo objectForKey:@"File"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileInfo.tempPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:fileInfo.tempPath error:nil];
    }
    NSString *plistPath = [fileInfo.tempPath stringByAppendingPathExtension:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:plistPath error:nil];
    }
    [self.downinglist removeObject:request];
    return self.downinglist;
}
-(void)deleteFinishFile:(GFileModel *)selectFile{
    //    [_finishedList removeObject:selectFile];
    [self.finishedlist removeAllObjects];
    //by self
    NSLog(@"selectFile = %@",selectFile.fileName);
    NSString *document = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *userIdStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    NSString *plistPath = [[[document stringByAppendingPathComponent:self.basepath] stringByAppendingString:[NSString stringWithFormat:@"/%@",userIdStr]] stringByAppendingPathComponent:@"finishPlist.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSMutableArray *finishArr = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
        
        for (NSDictionary *dic in finishArr) {
            GFileModel *file = [[GFileModel alloc] init];
            file.fileName = [dic objectForKey:@"filename"];
            NSLog(@"file.fileName = %@",file.fileName);
            if ([file.fileName isEqualToString:selectFile.fileName]) {
                continue;
            }
            file.fileSize = [dic objectForKey:@"filesize"];
            file.targetPath = [dic objectForKey:@"filepath"];
            file.brief = [dic objectForKey:@"brief"];
//            file.smallImaUrl = [dic objectForKey:@"smallImag"];
            file.pid = [dic objectForKey:@"pid"];
            file.fileEnglishName = [dic objectForKey:@"englishName"];
            file.fileID  = [dic objectForKey:@"fileID"];
            file.isCollection  = [dic objectForKey:@"isCollection"];
            file.duration = [dic objectForKey:@"duration"];
            
            if (![file.fileEnglishName isEqualToString:@""]) {
                file.fileEnglishName = [dic objectForKey:@"fileEnglishName"];
                file.fileComposerName = [dic objectForKey:@"composerName"];
                file.pid = [dic objectForKey:@"origialVideoId"];
            }
            [self.finishedlist addObject:file];
        }
    }
    if ([GCommonHelper isExistFile:plistPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:plistPath error:nil];
        [[NSFileManager defaultManager] createFileAtPath:plistPath contents:nil attributes:nil];
    }
    
    NSString *path= [GCommonHelper getTargetPathWithBasepath:self.basepath subpath:self.TargetSubPath];
    NSString *FileLoadName = [self md5:selectFile.fileID];
    FileLoadName = [NSString stringWithFormat:@"%@_320",FileLoadName];
    path = [[[path stringByAppendingPathComponent:userIdStr] stringByAppendingPathComponent:@"tempdownload"] stringByAppendingPathComponent:FileLoadName];
    
    if ([GCommonHelper isExistFile:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    NSLog(@"finish.count = %d",self.finishedlist.count);
    [self saveFinishedFile];
    
    
}


@end
