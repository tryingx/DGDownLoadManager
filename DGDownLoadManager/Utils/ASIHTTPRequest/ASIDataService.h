//
//  ASIDataService.h
//  NCPAxib
//
//  Created by chengjiangbin on 14-11-11.
//
//

#import <Foundation/Foundation.h>

typedef void(^CompletionLoadHandle)(id result);
typedef void(^FailBlock)(void);

@interface ASIDataService : NSObject

+(void)ASIPostRequest:(NSString *)urlstring
               params:(NSMutableDictionary *)params
         successBlock:(CompletionLoadHandle)successBlock
            failBlock:(FailBlock)failBlock;

@end
