//
//  UIColor+Simple.m
//  Camera3D
//
//  Created by fanghailong on 15-4-17.
//  Copyright (c) 2015年 superd3d. All rights reserved.
//

#import "UIColor+Simple.h"
#import "colorModel.h"


@implementation UIColor (Simple)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+(UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}

#pragma mark 16进制颜色转换
// color = #FFFFFF 或者 0xFFFFFF
+ (UIColor *) colorWithHexString: (NSString *)color withAlpha:(CGFloat)alpha
{
    unsigned int r, g, b;
    colorModel *rgb = [self RGBWithHexString:color withAlpha:alpha];
    r = rgb.R;
    g = rgb.G;
    b = rgb.B;
    alpha = rgb.alpha;
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

#pragma mark 16进制转换为RGB模式
+ (colorModel *) RGBWithHexString: (NSString *)color withAlpha:(CGFloat)alpha{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return Nil;
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return Nil;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    colorModel *rgb = [[colorModel alloc] init];
    rgb.R = r;
    rgb.B = b;
    rgb.G = g;
    rgb.alpha = alpha;
    return  rgb;
}


@end
