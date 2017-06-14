//
//  ViewController.m
//  QeelinGold-iOS
//
//  Created by MacBook on 2017/4/5.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "ViewController.h"

#import "UIButton+Action.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "DQRequestCenter.h"

@interface ViewController ()
@property (nonatomic ,strong)UIButton *button1 ;
@end

@implementation ViewController
- (void)netWorkCeshi{
    //第一,设置服务器配置地址和公共参数（也可以在DQRequestCenter中设置）
    [DQRequestCenter setupConfig:^(DQRequestConfig * _Nonnull config) {
        // 服务器地址
        config.callbackQueue = dispatch_get_main_queue();
        config.generalServer = @"http://www.baidu/"; //此处大家自己弄一下服务器地址
                config.generalParameters = @{
                                             // 不会发生变化的公共参数
                                             @"channel":@"ios",
                                             @"osVersion":[[UIDevice currentDevice] systemVersion],
                                             @"version":[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"],
                                             @"imei":[[UIDevice currentDevice].identifierForVendor UUIDString],
                                             };
    }];
    //第二发送一个请求，并设置接口路径（在这里设置频繁请求的间隔，请求失败重新请求的次数）
    [DQRequestCenter sendRequest:^(DQRequestItem * _Nonnull item) {
        item.api = @"system/getNoticeList.do";
        item.requestInterval = 5; //间隔
        item.retryCount = 3; //重复请求的次数
    } onSuccess:^(id  _Nullable responseObject, BOOL isNormalData) {
        if (isNormalData) {//请求成功，有数据返回
            
        }else{//请求成功，如token过期等情况，可以在这里做单一处理，也可以在框架里做统一处理
            
        }
        PTTLog(@"success = %@",responseObject);
    } onFailure:^(NSError * _Nullable error) {
        PTTLog(@"error = %@",error);
    }];
    
    // 第三种，取消已经发送的网络请求
    NSString *identifier = [DQRequestCenter sendRequest:^(DQRequestItem * _Nonnull item) {
        item.api = @"system/getNoticeList.do";
    } onSuccess:^(id  _Nullable responseObject, BOOL isNormalData) {
        PTTLog(@"success = %@",responseObject);
    } onFailure:^(NSError * _Nullable error) {
        PTTLog(@"error = %@",error);
    }];
    [DQRequestCenter cancelRequest:identifier onCancel:^{
        //取消完成后
    }];

    //第四，由于请求都是进行异步操作的队列，当对返回的数据要进行页面刷新操作，请求设置 config.callbackQueue = dispatch_get_main_queue();
    // 或者直接在 
    dispatch_async(dispatch_get_main_queue(), ^{
        //执行ui界面更新
    });
    
    //第五，如果有需要对定时请求做取消操作，需要大家自己去用数组保存 identifier，在通过identifier取消发起请求前的所有请求
    //第六，对于DQSuccessBlock的block增加了一个 isNormalData，此参数是为了区分token过期，登录失败等特殊情况的。
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self netWorkCeshi];
}


@end
