//
//  ASIDataService.m
//  NCPAxib
//
//  Created by chengjiangbin on 14-11-11.
//
//

#import "ASIDataService.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
@implementation ASIDataService


+(void)ASIPostRequest:(NSString *)urlstring
               params:(NSMutableDictionary *)params
         successBlock:(CompletionLoadHandle)successBlock
            failBlock:(FailBlock)failBlock
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlstring]];
    
    [request setTimeOutSeconds:30];
    
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        //有文件数据
        if ([value isKindOfClass:[NSData class]]) {
            [request setPostFormat:ASIMultipartFormDataPostFormat];
            [request addData:value withFileName:@"myFile" andContentType:@"multipart/form-data" forKey:@"0"];
        }
        else{
            [request addPostValue:value forKey:key];
        }
    }

    [request setStringEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:@"POST"];
    [request setDelegate : self];
    
    __unsafe_unretained ASIFormDataRequest *_request = request;
    [_request setCompletionBlock:^{
        NSData *responseData=[request responseData];
        NSDictionary *_DicJson=[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        successBlock(_DicJson);
    }];
    
    [_request setFailedBlock:^{
        failBlock();
        NSError *error = [_request error];
        NSLog(@"%@",error);
    }];
    
    //启动请求
    [request startAsynchronous];
}

@end
