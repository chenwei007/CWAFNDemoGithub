//
//  DQRequestConst.h
//  MiMi
//
//  Created by chenwei on 17/5/17.
//  Copyright © 2017年 chenwei. All rights reserved.
//

#ifndef DQRequestConst_h
#define DQRequestConst_h

NS_ASSUME_NONNULL_BEGIN

#define DQ_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })
#define DQSelfLock() dispatch_semaphore_wait(self->_selfLock, DISPATCH_TIME_FOREVER)
#define DQSelfUnlock() dispatch_semaphore_signal(self->_selfLock)
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys.count == 0 || dic.allKeys == nil)

@class DQRequestItem;

typedef NS_ENUM(NSInteger, DQHTTPMethodType) {
    kDQHTTPMethodGET    = 0,    // GET
    kDQHTTPMethodPOST   = 1,    // POST
};

typedef NS_ENUM(NSInteger, DQRequestSerializerType) {
    kDQRequestSerializerHTTP     = 0, // 默认POST的请求数据方式
    kDQRequestSerializerJSON    = 1, // 默认GET的请求数据方式
};

typedef NS_ENUM(NSInteger, DQResponseSerializerType) {
    kDQResponseSerializerHTTP    = 0,
    kDQResponseSerializerJSON   = 1,  //默认响应的数据形式
};

NS_ENUM(NSInteger)
{
    KDQNetWorkResponseObjectError  =                     -1,   //返回数据错误
    kDQNetworkStatusAvailableError =                     2004, //当前网络状态不可用
    kDQNetWorkFrequentRequestError =                     2005, //网络频繁请求
};
    
typedef void (^DQConfigItemBlock)(DQRequestItem *item);
typedef void (^DQSuccessBlock)(id _Nullable responseObject);
typedef void (^DQFailureBlock)(NSError * _Nullable error);
typedef void (^DQFinishedBlock)(id _Nullable responseObject, NSError * _Nullable error);
typedef void (^DQCancelBlock)();



NS_ASSUME_NONNULL_END

#endif /* DQRequestConst_h */
