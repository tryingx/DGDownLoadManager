//
//  ASIShareRequestQueue.m
//  NCPAxib
//
//  Created by chengjiangbin on 15-1-5.
//
//

#import "ASIShareRequestQueue.h"

static ASIShareRequestQueue *requestQueue = nil;
@implementation ASIShareRequestQueue

+(id)shareRequestQueue
{
    if (requestQueue == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            requestQueue = [[ASIShareRequestQueue alloc] init];
            [requestQueue setMaxConcurrentOperationCount:1];
            requestQueue.shouldCancelAllRequestsOnFailure = NO;
            
        });
    }
    return requestQueue;
}
@end
