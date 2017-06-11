//
//  QLChartsCandleStickTool.m
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/2/23.
//
//

#import "QLChartsCandleStickTool.h"
#import <Charts/Charts.h>
#import "DateValueFormatter.h"

@interface QLChartsCandleStickTool()
@property (nonatomic ,strong)NSMutableArray *candleArray;
@property (nonatomic ,strong)CandleStickChartView *candleStickChartView;
@property (nonatomic ,assign) BOOL isMinu;

@property (nonatomic ,strong)ChartYAxis *leftYAxis;
@property (nonatomic ,strong)ChartXAxis *xAxis;

@end

@implementation QLChartsCandleStickTool
- (void)setupCandleStickChartsModel:(NSMutableArray *)candleArray withview:(CandleStickChartView *)candleStickChartView withBool:(BOOL)isMinu{
    if (candleArray.count == 0) return;
    self.candleArray = candleArray;
    self.candleStickChartView = candleStickChartView;
    self.isMinu = isMinu;
    
    self.leftYAxis.isChangeColor = NO;
    ChartYAxis *rightAxis = self.candleStickChartView.rightAxis;
    rightAxis.enabled = NO;
    [self setupCandleStickChartsDataset];
}
- (void)setupCandleStickChartsDataset{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.candleArray.count; i++)
    {
        NSArray *newArr = self.candleArray[i];
        NSString *xStr = ((NSNumber *)(newArr.lastObject)).stringValue;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:xStr.floatValue / 1000];
        NSDateFormatter *df = [NSDateFormatter new];
        if (self.isMinu) {
            [df setDateFormat:@"HH:mm"];//时间戳转成日期
        }else{
            [df setDateFormat:@"MM-dd"];//时间戳转成日期
        }
        NSString *  turnStr = [df stringFromDate:date];
        PTTLog(@"时间戳转成日期%@",turnStr) ;
        
        [xVals addObject:turnStr];
        
        double high = ((NSNumber *)newArr[2]).doubleValue;
        double low = ((NSNumber *)newArr[3]).doubleValue;
        double open = ((NSNumber *)newArr[1]).doubleValue;
        double close = ((NSNumber *)newArr[4]).doubleValue;
        CandleChartDataEntry *entry =[[CandleChartDataEntry alloc]initWithX:i shadowH:high shadowL:low open:open close:close];
        [yVals1 addObject:entry];
    }
    self.xAxis.valueFormatter = [[DateValueFormatter alloc]initWithArr:xVals];
    
    CandleChartDataSet *set1 = [[CandleChartDataSet alloc]initWithValues:yVals1 label:@""];
    set1.axisDependency = AxisDependencyLeft;
    set1.valueFont = [UIFont systemFontOfSize:0.f];//表上边的提示文字
    
    set1.shadowColor =color_new_dark;
    set1.shadowWidth = 0.5;
    
    set1.decreasingColor =color_font_46b97c;
    [set1 setDecreasingFilled:YES];
    
    set1.increasingColor =
    color_red_ff5353;
    [set1 setIncreasingFilled:YES];
    [set1 setShadowColorSameAsCandle:YES];//细线的颜色和区域块的颜色一样
    
    CandleChartData *data = [[CandleChartData alloc]initWithDataSet:set1];
    self.candleStickChartView.data = data;

}
- (ChartXAxis *)xAxis{
    if (_xAxis == nil) {
        ChartXAxis *xAxis = self.candleStickChartView.xAxis;
        xAxis.labelPosition = XAxisLabelPositionBottom;
        xAxis.granularityEnabled = YES;
        xAxis.labelTextColor= color_new_dark;
        xAxis.drawGridLinesEnabled = NO;
//        [xAxis setLabelCount:7 force:YES];
        _xAxis = xAxis;
    }
    return _xAxis;
}
- (ChartYAxis *)leftYAxis{
    if (_leftYAxis == nil) {
        ChartYAxis *leftAxis = self.candleStickChartView.leftAxis;
        [leftAxis setLabelCount:7 force:YES];
        leftAxis.drawGridLinesEnabled = YES;
        leftAxis.drawAxisLineEnabled = YES;
        leftAxis.labelTextColor = color_new_dark;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0.00"];
        formatter.numberStyle = kCFNumberFormatterRoundUp;
        leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:formatter];
        _leftYAxis = leftAxis;
        
    }
    return _leftYAxis;
}
@end
