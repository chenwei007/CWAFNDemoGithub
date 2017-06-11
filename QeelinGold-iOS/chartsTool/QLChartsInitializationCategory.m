//
//  QLChartsInitializationCategory.m
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/3/23.
//
//

#import "QLChartsInitializationCategory.h"
#import <Charts/Charts.h>
#import "QLChartsDataCategoryView.h"

@implementation QLChartsInitializationCategory
+ (void)setChartsMyXAxisWith:(ChartXAxis *)xAxis{
    //label设置
    xAxis.labelFont = [UIFont systemFontOfSize:8.f];
    xAxis.labelPosition= XAxisLabelPositionBottom;//设置x轴数据在底部
    xAxis.labelTextColor = [UIColor blackColor];//文字颜色
//    xAxis.labelCount = 6;//Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
//    xAxis.forceLabelsEnabled = YES;//不强制绘制指定数量的label
    //x轴线
    xAxis.axisLineWidth = 0.3f;
    xAxis.axisLineColor = [UIColor blackColor];
    //x轴网格线
    xAxis.drawGridLinesEnabled = YES;//是否画网格线
    xAxis.gridLineWidth = 0.3f;
    xAxis.gridColor = color_gray_e2e6eb;
    xAxis.gridLineDashLengths = @[@2.f, @2.f];//划竖向的虚线
    //label的间距
//    xAxis.granularity = 4*60;
    xAxis.granularityEnabled = YES;//设置重复的值不显示
    [xAxis setEnabled:YES];//是否显示X坐标轴 及 对应的刻度竖线，默认是true
    xAxis.spaceMin = 0;
}
+ (void)setChartsMyYAxisWith:(ChartYAxis *)YAxis{
    YAxis.isChangeColor = NO;//自定义ylabel的颜色
    YAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
    YAxis.labelTextColor = [UIColor blackColor];//文字颜色
    YAxis.labelFont = [UIFont systemFontOfSize:8.0f];//文字字体
    YAxis.axisLineWidth = 0.4f;
    YAxis.inverted = NO;//是否将Y轴进行上下翻转
    YAxis.axisLineColor = [UIColor blackColor];//Y轴颜色
    //YAxis轴网格线
    YAxis.drawGridLinesEnabled = YES;//是否画网格线
    YAxis.gridColor = color_gray_e2e6eb;//网格线颜色
    YAxis.gridAntialiasEnabled = NO;//开启抗锯齿

    YAxis.gridLineDashLengths = @[@2.f, @2.f];//划竖向的虚线
    [YAxis setEnabled:YES];
    YAxis.granularityEnabled = YES;//设置重复的值不显示
    //y轴数据类型
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [formatter setPositiveFormat:@"###,##0.00"];
    formatter.numberStyle = kCFNumberFormatterRoundUp;
    YAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:formatter];
}
+ (LineChartDataSet *)getMyLineChartDataSetWith:(NSMutableArray *)oneYVals withLabelText:(NSString *)text{
    LineChartDataSet *set1 = [[LineChartDataSet alloc]initWithValues:oneYVals label:text];
    set1.lineWidth = 0.3;//折线宽度
    set1.drawValuesEnabled = YES;//是否在拐点处显示数据
    //    set1.valueFormatter = [[SetValueFormatter alloc]initWithArr:yVals];
    set1.valueColors = @[[UIColor brownColor]];//折线拐点处显示数据的颜色
    [set1 setColor:[UIColor blueColor]];//折线颜色
    [set1 setCircleColor:[UIColor clearColor]];
    set1.highlightColor = [UIColor colorWithRed:230/255.f green:178/255.f blue:87/255.f alpha:1.f];
    set1.circleRadius = 0.0;//两个线段中间的圆点
    set1.drawCircleHoleEnabled = NO;
    set1.drawSteppedEnabled = NO;//是否开启绘制阶梯样式的折线图
    set1.fillColor = UIColor.blackColor;
    set1.valueFont = [UIFont systemFontOfSize:0.f];//线顶部的文字大小
    set1.drawCirclesEnabled = NO;//是否绘制拐点
    set1.drawFilledEnabled = NO;//是否填充颜色
    return set1;
}
+ (CandleChartDataSet*)getMyCandleChartDataSetWith:(NSMutableArray *)oneYVals withLabelText:(NSString *)text{
    CandleChartDataSet * CandleDataset = [[CandleChartDataSet alloc]initWithValues:oneYVals label:text];
    CandleDataset.axisDependency = AxisDependencyLeft;
    CandleDataset.valueFont = [UIFont systemFontOfSize:0.f];//表上边的提示文字
    
    CandleDataset.shadowColor =color_new_dark;
    CandleDataset.shadowWidth = 0.5;
    
    CandleDataset.decreasingColor =color_font_46b97c;
    [CandleDataset setDecreasingFilled:YES];
    
    CandleDataset.increasingColor =
    color_red_ff5353;
    [CandleDataset setIncreasingFilled:YES];
    [CandleDataset setShadowColorSameAsCandle:YES];//细线的颜色和区域块的颜色一样
    return CandleDataset;
}
+ (BarChartDataSet*)getMyBarChartDataSetWith:(NSMutableArray *)oneYVals withLabelText:(NSString *)text{
    BarChartDataSet *set = set = [[BarChartDataSet alloc] initWithValues:oneYVals label:text];
    return set;
}
@end
