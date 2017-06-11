//
//  DateValueFormatter.h
//  chenwei_charts
//
//  Created by MacBook on 2017/2/15.
//  Copyright © 2017年 xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Charts;
@interface DateValueFormatter : NSObject<IChartAxisValueFormatter>
-(id)initWithArr:(NSArray *)arr;

@end
