//
//  UIColor+Simple.h
//  Design
//
//  Created by fanghailong on 15-4-17.
//  Copyright (c) 2015年 superd3d. All rights reserved.
//  颜色类别扩展

#import <UIKit/UIKit.h>
@class colorModel;

@interface UIColor (Simple)

+(UIColor *)colorWithHexString:(NSString *)stringToConvert;

+(UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *) colorWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;

+ (colorModel *) RGBWithHexString: (NSString *)color withAlpha:(CGFloat)alpha;



@end
