//
//  UIButton+Action.h
//  QeelinGold-iOS
//
//  Created by MacBook on 2017/5/5.
//  Copyright © 2017年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)(UIButton *button);
@interface UIButton (Action)
@property (nonatomic,copy) ActionBlock actionBlock;
@property (nonatomic ,copy) NSString *myCode;
+ (UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title actionBlock:(ActionBlock)actionBlock;
- (NSString *)chenweidada;
- (void)sendMyMethod;
-(NSString *)onlyDeclareMethod:(NSString *)first andWithSec:(NSString*)second;
@end
