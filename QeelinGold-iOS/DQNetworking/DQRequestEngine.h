//
//  DQRequestEngine.h
//  MiMi
//
//  Created by chenwei on 17/5/17.
//  Copyright © 2017年 chenwei. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@class DQRequestItem,AFNetworkReachabilityManager;

typedef void (^DQCompletionHandler) (id _Nullable responseObject, NSError * _Nullable error);

@interface DQRequestEngine : NSObject

+ (instancetype)defaultEngine;

- (void)sendRequest:(DQRequestItem *)item completionHandler:(nullable DQCompletionHandler)completionHandler;

- (void)cancelRequestByIdentifier:(NSString *)identifier;
/**
 判断是否连接网络

 @return YES:有网络
 */
- (BOOL )isReachable;
/**
 具体的网络信息

 @return @"unKnow" @"Wifi" @"notReachable" @"2G" @"3G" @"4G"
 */
- (NSString *)networkModeString;

@end
NS_ASSUME_NONNULL_END

