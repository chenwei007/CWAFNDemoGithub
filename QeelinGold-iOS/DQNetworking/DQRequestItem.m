//
//  DQRequestItem.m
//  MiMi
//
//  Created by chenwei on 17/5/17.
//  Copyright © 2017年 chenwei. All rights reserved.
//

#import "DQRequestItem.h"

@implementation DQRequestItem

+ (instancetype)requestItem
{
    return [[[self class] alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _httpMethod = kDQHTTPMethodGET;
        _requestSerializerType = kDQRequestSerializerJSON;
        _responseSerializerType = kDQResponseSerializerJSON;
        _requestInterval = 2.f;
        _timeoutInterval = 15.0f;
        _retryCount = 0;
        _isFrequentContinue = NO;
        _separateServer = nil;
    }
    return self;
}

- (void)cleanCallbackBlocks {
    _successBlock = nil;
    _failureBlock = nil;
}

- (void)dealloc
{
    NSLog(@" %@ dealloc ",NSStringFromClass([self class]));
}

@end
