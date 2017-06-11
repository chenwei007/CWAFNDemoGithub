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
    } onSuccess:^(id  _Nullable responseObject) {
        PTTLog(@"success = %@",responseObject);
    } onFailure:^(NSError * _Nullable error) {
        PTTLog(@"success = %@",error);
    } onFinished:^(id  _Nullable responseObject, NSError * _Nullable error) {
        //不论成功或失败都会,如果成功error = nil 如果失败responseObject = nil
        PTTLog(@"success = %@---%@",responseObject,error);
    }];
    
    // 第三种，取消已经发送的网络请求
    NSString *identifier = [DQRequestCenter sendRequest:^(DQRequestItem * _Nonnull item) {
        item.api = @"system/getNoticeList.do";
    } onSuccess:^(id  _Nullable responseObject) {
        PTTLog(@"success = %@",responseObject);
    } onFailure:^(NSError * _Nullable error) {
        PTTLog(@"success = %@",error);
    } onFinished:^(id  _Nullable responseObject, NSError * _Nullable error) {
        //不论成功或失败都会,如果成功error = nil 如果失败responseObject = nil
        PTTLog(@"success = %@---%@",responseObject,error);
    }];
    [DQRequestCenter cancelRequest:identifier onCancel:^{
        //取消完成后
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self netWorkCeshi];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10, 200, 100, 40);
    btn1.backgroundColor = [UIColor  blackColor];
    [btn1 setTitle:@"图表1" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(10, 250, 100, 40);
    [btn2 setTitle:@"图表2" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor blackColor];
    [btn2 addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    //第一个按钮
    UIButton *button1 = [UIButton createBtnWithFrame:CGRectMake(10, 300, 100, 50) title:@"按钮" actionBlock:^(UIButton *button) {
        float r = random()%255/255.0;
        float g = random()%255/255.0;
        float b = random()%255/255.0;
        self.view.backgroundColor = [UIColor blueColor];
        PTTLog(@"hhhhhh");
    }];
    self.button1 = button1;
    button1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:button1];
    button1.myCode = @"chenweidada";
//    NSLog(@"myCode = %@",button1.myCode);
    NSString *str = [button1 chenweidada];
//    NSLog(@"str = %@",str);
    Method  oriMethod = class_getInstanceMethod([UIButton class], @selector(chenweidada));
    Method  newMethod = class_getInstanceMethod([self class], @selector(newchenweidada));
    method_exchangeImplementations(oriMethod, newMethod);
    NSString *newstr = [button1 chenweidada];
//    NSLog(@"newstr = %@",newstr);
    //第二个按钮
    UIButton *button2 = [UIButton createBtnWithFrame:CGRectMake(10, CGRectGetMaxY(button1.frame) + 50, 100, 50) title:@"按钮2" actionBlock:nil];
    button2.actionBlock = ^(UIButton *button){
//        NSLog(@"---%@---",button.currentTitle);
    };
    button2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:button2];
    
    ((void (*)(id,SEL)) objc_msgSend)(button1,@selector(sendMyMethod));
    
    class_addMethod([UIButton class], @selector(onlyDeclareMethod: andWithSec:), (IMP)implementOnlyDeclare, "@@:@@");
    
    [button1 onlyDeclareMethod:@"chenwei" andWithSec:@"hehe"];
}
NSString *implementOnlyDeclare(id class ,SEL sel,NSString * first,NSString * second)
{
//    NSLog(@"%@",[NSString stringWithFormat:@"在resolveInstanceMethod中通过addMethod方法实现方法:%@+%@",first,second]);
    return [NSString stringWithFormat:@"在resolveInstanceMethod中通过addMethod方法实现方法:%@+%@",first,second];
}

- (NSString *)newchenweidada{
    return @"newchenweidada";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
