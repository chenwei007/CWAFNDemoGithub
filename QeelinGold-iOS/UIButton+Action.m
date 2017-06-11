//
//  UIButton+Action.m
//  QeelinGold-iOS
//
//  Created by MacBook on 2017/5/5.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "UIButton+Action.h"
#import <objc/runtime.h>
static NSString *keyOfMethod;
static NSString *keyOfBlock;
static NSString *keyOfMyCode;


@implementation UIButton (Action)

+ (UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title actionBlock:(ActionBlock)actionBlock{
    UIButton *button = [[UIButton alloc]init];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:button action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    objc_setAssociatedObject (button , &keyOfMethod, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return button;
}
- (void)buttonClick:(UIButton *)button{
    PTTLog(@"%@点击了",button.currentTitle);
    //通过key获取被关联对象
    //objc_getAssociatedObject(id object, const void *key)
    ActionBlock block1 = (ActionBlock)objc_getAssociatedObject(button, &keyOfMethod);
    if(block1){
        button.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.userInteractionEnabled = YES;
        });
        block1(button);
    }
    
    ActionBlock block2 = (ActionBlock)objc_getAssociatedObject(button, &keyOfBlock);
    if(block2){
        block2(button);
    }
}
- (void)setActionBlock:(ActionBlock)actionBlock{
    objc_setAssociatedObject (self, &keyOfBlock, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC );
}

- (ActionBlock)actionBlock{
    return objc_getAssociatedObject (self ,&keyOfBlock);
}
- (void)setMyCode:(NSString *)myCode{
    objc_setAssociatedObject(self, &keyOfMyCode, myCode, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)myCode{
    return objc_getAssociatedObject(self, &keyOfMyCode);
}
- (NSString *)chenweidada{
    return @"chenweidada";
}
- (void)sendMyMethod{
    NSLog(@"运行时调用方法");
}
@end
