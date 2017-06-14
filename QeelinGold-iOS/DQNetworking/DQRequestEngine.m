//
//  DQRequestEngine.m
//  MiMi
//
//  Created by chenwei on 17/5/17.
//  Copyright © 2017年 chenwei. All rights reserved.
//

#import "DQRequestEngine.h"
#import "DQRequestItem.h"
#import "DQRequestConst.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import <objc/runtime.h>
#import "AFNetworkActivityIndicatorManager.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

static dispatch_queue_t request_Completion_Callback_Queue() {
    static dispatch_queue_t request_Completion_Callback_Queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request_Completion_Callback_Queue = dispatch_queue_create("com.requestCompletionCallbackQueue.douqu", DISPATCH_QUEUE_CONCURRENT);
    });
    return request_Completion_Callback_Queue;
}


@implementation NSObject (BindingDQRequestItem)

static NSString * const kDQRequestBindingKey = @"kDQRequestBindingKey";

- (void)bindingRequestItem:(DQRequestItem *)requestItem {
    objc_setAssociatedObject(self, (__bridge CFStringRef)kDQRequestBindingKey, requestItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DQRequestItem *)bindedRequestItem {
    DQRequestItem *item = objc_getAssociatedObject(self, (__bridge CFStringRef)kDQRequestBindingKey);
    return item;
}

@end


@interface DQRequestEngine ()
{
    dispatch_semaphore_t _selfLock;
}
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end


@implementation DQRequestEngine

+ (instancetype)defaultEngine
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        _selfLock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)sendRequest:(DQRequestItem *)item completionHandler:(nullable DQCompletionHandler)completionHandler
{
    [self dataTaskWithRequest:item completionHandler:completionHandler];
}

- (void)cancelRequestByIdentifier:(NSString *)identifier
{
    if (kStringIsEmpty(identifier)) return;
    DQSelfLock();
    NSArray *tasks = self.sessionManager.tasks;
    if (!kArrayIsEmpty(tasks)) {
        [tasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.bindedRequestItem.identifier isEqualToString:identifier]) {
                [task cancel];
                *stop = YES;
            }
        }];
    }
    DQSelfUnlock();
}

- (BOOL )isReachable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    return [reachability currentReachabilityStatus] != NotReachable;
}

/**
 获取具体网络状态
 */
- (NSString *)networkModeString
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus status = [r currentReachabilityStatus];
    if (status == NotReachable)
    {
        return @"unknown";
    }
    else if(status == ReachableViaWiFi)
    {
        return @"wifi";
    }
    CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc]init];  //创建一个CTTelephonyNetworkInfo对象
    NSString *currentStatus  = networkStatus.currentRadioAccessTechnology; //获取当前网络描述
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"] ||
        [currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"] ||
        [currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"] ||
        [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"] )
    {
        return @"2G";//2G
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]||
        [currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]||
        [currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]||
        [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]||
        [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]||
        [currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"])
    {
        return @"3G";//3G
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"])
    {
        return @"4G";//4G
    }
    return @"unknown";
}

#pragma mark - 私有方法

- (void)dataTaskWithRequest:(DQRequestItem *)item completionHandler:(DQCompletionHandler)completionHandler
{
    //这一块废弃了，这里的处理afn的3.0版本已经帮我们处理了
//    NSString *httpMethod = (item.httpMethod == kDQHTTPMethodPOST) ? @"POST" : @"GET";
//    AFHTTPRequestSerializer *requestSerializer = [self getRequestSerializer:item];
//    NSError *serializationError = nil;
//    // 拼接参数后，得到NSMutableURLRequest，用以网络请求
//    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:httpMethod URLString:item.url parameters:item.parameters error:&serializationError];
//    PTTLog(@"urlRequest = %@",urlRequest);
//    if (serializationError) {
//        if (completionHandler) {
//            dispatch_async(request_Completion_Callback_Queue(), ^{
//                completionHandler(nil, serializationError);
//            });
//        }
//        return;
//    }
//    urlRequest.timeoutInterval = item.timeoutInterval;
//    NSURLSessionDataTask *dataTask = nil;
//    __weak __typeof(self)weakSelf = self;
//    // 进行网络请求
//    dataTask = [self.sessionManager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        // 对返回的结果做处理
//        [strongSelf processResponse:response object:responseObject error:error requestItem:item completionHandler:completionHandler];
//    }];
//    //获取一个网络请求的管理者 dataTask，一次网络请求的信息都在这里
//    NSString *identifier = [NSString stringWithFormat:@"%lu",(unsigned long)dataTask.taskIdentifier];
//    [item setValue:identifier forKey:@"_identifier"];
//    [dataTask bindingRequestItem:item];
//    [dataTask resume];
    
    NSURLSessionDataTask *dataTask = nil;
     //进行网络请求
    PTTLog(@"发送了一次请求");
    if (item.httpMethod == kDQHTTPMethodGET) {
        dataTask = [self.sessionManager GET:item.url parameters:item.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(request_Completion_Callback_Queue(), ^{
                completionHandler(responseObject, nil);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(request_Completion_Callback_Queue(), ^{
                completionHandler(nil, error);
            });
        }];
    }else if (item.httpMethod == kDQHTTPMethodPOST){
        dataTask = [self.sessionManager POST:item.url parameters:item.parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(request_Completion_Callback_Queue(), ^{
                completionHandler(responseObject, nil);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(request_Completion_Callback_Queue(), ^{
                completionHandler(nil, error);
            });
        }];
    }else if (item.httpMethod == kDQHTTPMethodPUT){
        dataTask = [self.sessionManager PUT:item.url parameters:item.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(request_Completion_Callback_Queue(), ^{
                completionHandler(responseObject, nil);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            dispatch_async(request_Completion_Callback_Queue(), ^{
                completionHandler(nil, error);
            });
        }];
    }
    //获取一个网络请求的管理者 dataTask，一次网络请求的信息都在这里
    NSString *identifier = [NSString stringWithFormat:@"%lu",(unsigned long)dataTask.taskIdentifier];
    [item setValue:identifier forKey:@"_identifier"];
    [dataTask bindingRequestItem:item];
}

- (void)processResponse:(NSURLResponse *)response object:(id)responseObject error:(NSError *)error requestItem:(DQRequestItem *)item completionHandler:(DQCompletionHandler)completionHandler {
    AFHTTPResponseSerializer *responseSerializer = [self getResponseSerializer:item];
    NSError *serializationError = nil;
    responseObject = [responseSerializer responseObjectForResponse:response data:responseObject error:&serializationError];
    if (completionHandler) {
        dispatch_async(request_Completion_Callback_Queue(), ^{
            if (serializationError) {
                completionHandler(nil, serializationError);
            } else {
                completionHandler(responseObject, error);
            }
        });
    }
}

- (AFHTTPRequestSerializer *)getRequestSerializer:(DQRequestItem *)item
{
    switch (item.requestSerializerType) {
        case kDQRequestSerializerHTTP:
            return [AFHTTPRequestSerializer serializer];
            break;
        case kDQRequestSerializerJSON:
            return [AFJSONRequestSerializer serializer];
            break;
        default:
            return [AFJSONRequestSerializer serializer];
            break;
    }
}

- (AFHTTPResponseSerializer *)getResponseSerializer:(DQRequestItem *)item
{
    switch (item.responseSerializerType) {
        case kDQResponseSerializerHTTP:
            return [AFHTTPResponseSerializer serializer];
            break;
        case kDQResponseSerializerJSON:
            return self.sessionManager.responseSerializer;
            break;
        default:
            return self.sessionManager.responseSerializer;
            break;
    }
}

#pragma mark - 懒加载

- (AFHTTPSessionManager *)sessionManager
{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
//        _sessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
//        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
//        _sessionManager.securityPolicy.validatesDomainName = NO;
//        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.operationQueue.maxConcurrentOperationCount = 10;
        _sessionManager.completionQueue = request_Completion_Callback_Queue();
        
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"application/json",@"text/html",@"text/css",@"text/plain", nil];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    }
    return _sessionManager;
}

@end
