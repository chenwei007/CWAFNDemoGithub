//
//  QLChartsInitializationCategory.h
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/3/23.
//
//

#import <Foundation/Foundation.h>
@class ChartXAxis,ChartYAxis,LineChartDataSet,CandleChartDataSet,BarChartDataSet;
@interface QLChartsInitializationCategory : NSObject
+ (void)setChartsMyXAxisWith:(ChartXAxis *)xAxis;
+ (void)setChartsMyYAxisWith:(ChartYAxis *)YAxis;
+ (LineChartDataSet *)getMyLineChartDataSetWith:(NSMutableArray *)oneYVals withLabelText:(NSString *)text;
+ (CandleChartDataSet*)getMyCandleChartDataSetWith:(NSMutableArray *)oneYVals withLabelText:(NSString *)text;
+ (BarChartDataSet*)getMyBarChartDataSetWith:(NSMutableArray *)oneYVals withLabelText:(NSString *)text;
@end
