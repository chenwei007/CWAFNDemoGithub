//
//  DQRequestCenter.m
//  MiMi
//
//  Created by chenwei on 17/5/17.
//  Copyright © 2017年 chenwei. All rights reserved.
//

#import "DQRequestCenter.h"
#import "DQRequestItem.h"
#import "DQRequestEngine.h"
#import "DQRequestUrl.h"

NSString *const DQ_HTTP_DOMAIN = @"douqu.httpServer.host";

@interface DQRequestCenter ()
{
    dispatch_semaphore_t _selfLock;
}
@property (nonatomic, strong) DQRequestConfig *requestConfig;

@property (nonatomic, strong) NSMutableDictionary *requestTimestampPool;

@property (nonatomic, strong) dispatch_source_t clearnTimer;

@end

@implementation DQRequestCenter

+ (nullable NSString *)sendRequest:(DQConfigItemBlock)configBlock onSuccess:(DQSuccessBlock)successBlock onFailure:(DQFailureBlock)failureBlock
{
    return [[DQRequestCenter defaultCenter] sendRequest:configBlock onSuccess:successBlock onFailure:failureBlock onFinished:NULL];
}


/**
 给config设置参数（属于公共部分的参数）
 */
+ (void)setupConfig:(void(^)(DQRequestConfig *config))configBlock
{
    [[DQRequestCenter defaultCenter] setupConfig:configBlock];
}
/**
 根据标示取消正在请求的参数
 */
+ (void)cancelRequest:(NSString *)identifier
{
    [[DQRequestCenter defaultCenter] cancelRequest:identifier onCancel:nil];
}

+ (void)cancelRequest:(NSString *)identifier onCancel:(nullable DQCancelBlock)cancelBlock
{
    [[DQRequestCenter defaultCenter] cancelRequest:identifier onCancel:cancelBlock];
}

+ (NSString *)networkModeString
{
    return [[DQRequestEngine defaultEngine] networkModeString];
}

#pragma mark - 私有方法

+ (instancetype)defaultCenter {
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
        _selfLock = dispatch_semaphore_create(1);
        [self creatCleanTimer];
    }
    return self;
}

- (void)dealloc
{
    [_requestTimestampPool removeAllObjects];
    [self stopClearnTimer];
}

- (void)setupConfig:(void(^)(DQRequestConfig *config))configBlock
{
    DQ_SAFE_BLOCK(configBlock,self.requestConfig);
    NSAssert(!kStringIsEmpty(self.requestConfig.generalServer), @"generalServer is nil ...");
}

- (void)cancelRequest:(NSString *)identifier onCancel:(nullable DQCancelBlock)cancelBlock
{
    [[DQRequestEngine defaultEngine] cancelRequestByIdentifier:identifier];
    DQ_SAFE_BLOCK(cancelBlock);
}

- (NSString *)sendRequest:(DQConfigItemBlock)configBlock onSuccess:(nullable DQSuccessBlock)successBlock onFailure:(nullable DQFailureBlock)failureBlock onFinished:(DQFinishedBlock)finishedBlock
{
    self.requestConfig.generalServer = API_Public_Link;
    self.requestConfig.generalParameters = @{
                                         @"ua":kUa,
//                                         @"version":kCurrentAppVersion,
//                                         @"imei":IDFA_String,
                                         };
    self.requestConfig.callbackQueue = dispatch_get_main_queue();
    DQRequestItem *requestItem = [DQRequestItem requestItem];
    DQ_SAFE_BLOCK(configBlock,requestItem);
    __block NSString *identifier;
    //一，同步进行任务，要等请求发出后，afn分配identifier后，在返回identifier
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //二， 给DQRequestItem设置参数
        [self processRequestItem:requestItem onSuccess:successBlock onFailure:failureBlock onFinished:finishedBlock];
        // 三，检查网络状态
        if ([self checkNetworkWithRequestItem:requestItem]) {
            //发送请求
            [self sendRequestItem:requestItem];
            identifier = requestItem.identifier;
        }
    });
    return identifier;
}
/**
 对requestInterval设置的间隔时间，做频繁请求的处理
 */

- (BOOL)checkLimitTimeWithRequestItem:(DQRequestItem *)requestItem
{
    BOOL isAllow = NO;
    NSInteger currentTime = [self getCurrentTimestamp];
    DQSelfLock();
    NSNumber *lastTime = [self.requestTimestampPool objectForKey:requestItem.api];
    DQSelfUnlock();
    if (lastTime && currentTime < lastTime.integerValue) {
        if (!requestItem.isFrequentContinue){
            NSError *error = [self generateErrorWithErrorReason:@"频繁的发送同一个请求" errorCode:kDQNetWorkFrequentRequestError];
            [self failureWithError:error forRequestItem:requestItem];
            return isAllow;
        }
        NSInteger nextRequestTime = lastTime.integerValue - currentTime;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(nextRequestTime * NSEC_PER_SEC)),dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self sendRequestItem:requestItem];
        });
        return isAllow;
    }
    NSNumber *limitTime = @(currentTime + requestItem.requestInterval * 1000);
    DQSelfLock();
    [self.requestTimestampPool setObject:limitTime forKey:requestItem.api];
    DQSelfUnlock();
    return isAllow = YES;
}

/**
 给DQRequestItem类设置参数
 */
- (void)processRequestItem:(DQRequestItem *)requestItem onSuccess:(DQSuccessBlock)successBlock onFailure:(DQFailureBlock)failureBlock onFinished:(DQFinishedBlock)finishedBlock
{
    NSAssert(!kStringIsEmpty(requestItem.api), @"The request api can't be null.");
    if (successBlock) {
        [requestItem setValue:successBlock forKey:@"_successBlock"];
    }
    if (failureBlock) {
        [requestItem setValue:failureBlock forKey:@"_failureBlock"];
    }
    if (finishedBlock) {
//        [requestItem setValue:finishedBlock forKey:@"_finishedBlock"];
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (!kDictIsEmpty(self.requestConfig.generalParameters)) {
        [parameters addEntriesFromDictionary:self.requestConfig.generalParameters];
    }
    NSDictionary *realTimeParameters = DQ_SAFE_BLOCK(self.requestConfig.DQRealTimeParametersBlock);
    if (!kDictIsEmpty(realTimeParameters)) {
        [parameters addEntriesFromDictionary:realTimeParameters];
    }
    if (!kDictIsEmpty(requestItem.parameters)) {
        [parameters addEntriesFromDictionary:requestItem.parameters];
    }
    requestItem.parameters = parameters;
    if (kStringIsEmpty(requestItem.separateServer)) {
        requestItem.separateServer = self.requestConfig.generalServer;
    }
    NSString *url;
    if ([requestItem.api isEqualToString:@"ctrade/system/getFinanceCalenders.do?sysver=10.30&appsver=1.5.8&ua=ios&idfa=6C386E65-1C9F-42EB-ABBD-36009391ABF7"]) {
        url = [NSString stringWithFormat:@"%@%@",@"http://www.qilin99.com/",requestItem.api];
    }else{
        url = [NSString stringWithFormat:@"%@%@",requestItem.separateServer,requestItem.api];
    }
    [requestItem setValue:url forKey:@"_url"];
}

/**
 判断网络状态
 */
- (BOOL)checkNetworkWithRequestItem:(DQRequestItem *)requestItem
{
    if (![[DQRequestEngine defaultEngine] isReachable]) {
        NSError *error = [self generateErrorWithErrorReason:@"当前网络不可用" errorCode:kDQNetworkStatusAvailableError];
        [self failureWithError:error forRequestItem:requestItem];
        return NO;
    }
    return YES;
}

- (void)sendRequestItem:(DQRequestItem *)requestItem
{
    // 四，做频繁请求的处理
    if ([self checkLimitTimeWithRequestItem:requestItem]) {
        //五，进入DQRequestEngine，调用afn，进行网络请求
        [[DQRequestEngine defaultEngine] sendRequest:requestItem completionHandler:^(id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                [self failureWithError:error forRequestItem:requestItem];
            }
            else{
                [self successWithResponse:responseObject forRequestItem:requestItem];
            }
        }];
    }
}

- (void)successWithResponse:(id)responseObject forRequestItem:(DQRequestItem *)requestItem
{
    NSError *error;
    if ([self checkOutResult:responseObject forRequestItem:requestItem error:&error])
    {
        if (self.requestConfig.callbackQueue) {
            dispatch_async(self.requestConfig.callbackQueue, ^{
                [self execureSuccessBlockWithResponse:responseObject forRequest:requestItem];
            });
        }
        else{
            [self execureSuccessBlockWithResponse:responseObject forRequest:requestItem];
        }
    }
    else
    {
        [self failureWithError:error forRequestItem:requestItem];
    }
}

- (void)execureSuccessBlockWithResponse:(id)responseObject forRequest:(DQRequestItem *)requestItem
{
    PTTLog(@"请求成功");
    id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
    DQ_SAFE_BLOCK(requestItem.successBlock,result,YES);
    DQ_SAFE_BLOCK(requestItem.finishedBlcok,result,nil);
    [requestItem cleanCallbackBlocks];
    /***以下在实际接口下使用
    if ([result isKindOfClass:[NSDictionary class]] || [result isKindOfClass:[NSMutableDictionary class]]){
        if (code == 0) { //请求成功返回 DQ_SAFE_BLOCK(requestItem.successBlock,item,YES);
            
        }else if (code == 其它){ //这里也是请求成功，如token过期，登录失败等等 DQ_SAFE_BLOCK(requestItem.successBlock,item,NO);
            
        }else{
            
        }
    }else if ([result isKindOfClass:[NSArray class]] || [result isKindOfClass:[NSMutableArray class]]){
        
    }else{ //其它数据类型如html
        
    }
     ***/

}

- (void)failureWithError:(NSError *)error forRequestItem:(DQRequestItem *)requestItem
{
    if (requestItem.retryCount > 0) {
        requestItem.retryCount --;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self sendRequestItem:requestItem];
        });
        return;
    }
    if (self.requestConfig.callbackQueue) {
        dispatch_async(self.requestConfig.callbackQueue, ^{
            [self execureFailureBlockWithError:error forRequest:requestItem];
        });
    }else{
        [self execureFailureBlockWithError:error forRequest:requestItem];
    }
}

- (void)execureFailureBlockWithError:(NSError *)error forRequest:(DQRequestItem *)requestItem
{
    PTTLog(@"请求失败的error = %@",error);
    DQ_SAFE_BLOCK(requestItem.failureBlock,error);
    DQ_SAFE_BLOCK(requestItem.finishedBlcok,nil,error);
    [requestItem cleanCallbackBlocks];
}

- (void)creatCleanTimer
{
    if (_clearnTimer) return;
    self.clearnTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(self.clearnTimer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.clearnTimer, ^{
        [self cleanTimestampPool];
    });
    dispatch_resume(self.clearnTimer);
}

- (void)cleanTimestampPool
{
    if (kDictIsEmpty(self.requestTimestampPool)) return;
    DQSelfLock();
    NSDictionary *tempDict = [self.requestTimestampPool mutableCopy];
    DQSelfUnlock();
    NSInteger currentTime = [self getCurrentTimestamp];
    for (NSString *api in tempDict) {
        NSInteger limitTime = [[self.requestTimestampPool objectForKey:api] integerValue];
        if (currentTime >= limitTime) {
            DQSelfLock();
            [self.requestTimestampPool removeObjectForKey:api];
            DQSelfUnlock();
        }
    }
}

- (void)stopClearnTimer
{
    if (_clearnTimer) {
        dispatch_source_cancel(_clearnTimer);
        _clearnTimer = NULL;
    }
}

- (NSInteger)getCurrentTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval currentTime=[dat timeIntervalSince1970] * 1000;
    return currentTime;
}

- (BOOL)checkOutResult:(id)responseObject forRequestItem:(DQRequestItem *)requestItem error:(NSError **)error
{
    BOOL isSuccess = NO;
    if (!responseObject)
    {
        if (error != NULL) *error = [self generateErrorWithErrorReason:@"responseObject is nil - 返回数据为空" errorCode:KDQNetWorkResponseObjectError];
        return isSuccess;
    }
    if (![responseObject isKindOfClass:[NSData class]])
    {
        if (error != NULL) *error = [self generateErrorWithErrorReason:@"responseObject type is not right - 返回数据类型错误" errorCode:KDQNetWorkResponseObjectError];
        return isSuccess;
    }
    return isSuccess = YES;
}

- (NSError *)generateErrorWithErrorReason:(NSString *)errorReason errorCode:(NSInteger)errorCode
{
    NSDictionary *errorInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(errorReason, @""),NSLocalizedFailureReasonErrorKey:NSLocalizedString(errorReason, @"")};
    NSError *error = [[NSError alloc] initWithDomain:DQ_HTTP_DOMAIN code:errorCode userInfo:errorInfo];
    return error;
}

- (DQRequestConfig *)requestConfig
{
    if (!_requestConfig) {
        _requestConfig = [[DQRequestConfig alloc] init];
    }
    return _requestConfig;
}

- (NSMutableDictionary *)requestTimestampPool
{
    if (!_requestTimestampPool) {
        _requestTimestampPool = [NSMutableDictionary dictionary];
    }
    return _requestTimestampPool;
}

@end

@implementation DQRequestConfig

@end


