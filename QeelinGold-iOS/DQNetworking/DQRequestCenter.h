//
//  DQRequestCenter.h
//  MiMi
//
//  Created by chenwei on 17/5/17.
//  Copyright © 2017年 chenwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DQRequestConst.h"
#import "DQRequestItem.h"
//#import "XSRequestApi.h"

NS_ASSUME_NONNULL_BEGIN

@class DQRequestConfig;

@interface DQRequestCenter : NSObject
/**
 请求配置信息
 */
+ (void)setupConfig:(void(^)(DQRequestConfig *config))configBlock;

+ (nullable NSString *)sendRequest:(DQConfigItemBlock)configBlock;
+ (nullable NSString *)sendRequest:(DQConfigItemBlock)configBlock onSuccess:(DQSuccessBlock)successBlock;
+ (nullable NSString *)sendRequest:(DQConfigItemBlock)configBlock onFailure:(DQFailureBlock)failureBlock;
+ (nullable NSString *)sendRequest:(DQConfigItemBlock)configBlock onFinished:(DQFinishedBlock)finishedBlock;
+ (nullable NSString *)sendRequest:(DQConfigItemBlock)configBlock onSuccess:(nullable DQSuccessBlock)successBlock onFailure:(nullable DQFailureBlock)failureBlock;
/**
 发送请求的方法

 @param configBlock 配置请求的item
 @param successBlock 成功回调
 @param failureBlock 失败回调
 @param finishedBlock 无论成功或失败,完成的回调
 @return 请求的task的表示符,可以用来取消
 */
+ (nullable NSString *)sendRequest:(DQConfigItemBlock)configBlock onSuccess:(nullable DQSuccessBlock)successBlock onFailure:(nullable DQFailureBlock)failureBlock onFinished:(DQFinishedBlock)finishedBlock;
/**
 取消一个请求
 @param identifier 发送请求时返回的标识符
 */
+ (void)cancelRequest:(NSString *)identifier;
+ (void)cancelRequest:(NSString *)identifier onCancel:(nullable DQCancelBlock)cancelBlock;
/**
 具体的网络信息
 
 @return @"unKnow" @"Wifi" @"notReachable" @"2G" @"3G" @"4G"
 */
+ (NSString *)networkModeString;

@end


@interface DQRequestConfig : NSObject
/**
 配置服务器地址
 */
@property (nonatomic, copy, nullable) NSString *generalServer;
/**
 固定公共参数
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString *, id> *generalParameters;
/**
 实时的公共参数
 */
@property (nonatomic, copy) NSDictionary* (^DQRealTimeParametersBlock)();
/**
 回调的线程
 */
@property (nonatomic, strong, nullable) dispatch_queue_t callbackQueue;

@end

NS_ASSUME_NONNULL_END
