//
//  QLChartsCandleStickCombineTool.m
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/3/22.
//
//

#import "QLChartsCandleStickCombineTool.h"
#import <Charts/Charts.h>
#import "DateValueFormatter.h"
#import "QLChartsDataCategoryView.h"
#import "QLChartsInitializationCategory.h"

@interface QLChartsCandleStickCombineTool()
@property (nonatomic ,strong)NSMutableArray *candleArray;
@property (nonatomic ,strong)NSMutableArray *combineArray;
@property (nonatomic ,strong) CombinedChartView  *myBarChartView;
@property (nonatomic ,assign) BOOL isMinu;
@property (nonatomic ,assign) QLChartsDataCategoryViewButtonType BtnType;
@end

@implementation QLChartsCandleStickCombineTool

- (void)setupCandleStickChartsModel:(NSMutableArray *)candleArray withCombinedData:(NSMutableArray *)combineArray withview:(CombinedChartView *)combineChartsView wihtParam:(NSMutableDictionary *)param withBool:(BOOL)isMinu{
    if (candleArray.count == 0) return;
    self.candleArray = candleArray;
    self.combineArray = combineArray;
    self.myBarChartView = combineChartsView;
    self.isMinu = isMinu;
    self.BtnType = [QLChartsDataCategoryView getQLChartsDataCategoryViewButtonTypeWithStr:[param objectForKey:@"baselinetype"]];

    [self setupBarNegativeChartsDataset];
    
}
- (void)setupBarNegativeChartsDataset{
    NSString *labelStr1 = @"";
    NSString *labelStr2 = @"";
    NSString *labelStr3 = @"";
    if (self.BtnType == QLChartsDataCategoryViewMACDButton) {
        labelStr1 = @"MA5";
        labelStr2 = @"MA10";
        labelStr3 = @"MA20";
    }else if (self.BtnType == QLChartsDataCategoryViewBOLLButton){
        labelStr1 = @"MB";
        labelStr2 = @"UP";
        labelStr3 = @"DN";
    }
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    NSMutableArray *oneYVals = [NSMutableArray array];
    NSMutableArray *twoYVals = [NSMutableArray array];
    NSMutableArray *threeYVals = [NSMutableArray array];
    
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
        //PTTLog(@"时间戳转成日期%@",turnStr) ;
        
        [xVals addObject:turnStr];
        
        double high = ((NSNumber *)newArr[2]).doubleValue;
        double low = ((NSNumber *)newArr[3]).doubleValue;
        double open = ((NSNumber *)newArr[1]).doubleValue;
        double close = ((NSNumber *)newArr[4]).doubleValue;
        NSString *dataStr = [NSString stringWithFormat:@"时间: %@\n开盘: %0.2f\n收盘: %0.2f\n最高: %0.2f\n最低: %0.2f",turnStr,open,close,high,low];
        NSDictionary *dic = @{
                              @"time":turnStr,
                              @"open":[NSString stringWithFormat:@"%0.2f",open],
                              @"close":[NSString stringWithFormat:@"%0.2f",close],
                              @"high":[NSString stringWithFormat:@"%0.2f",high],
                              @"low":[NSString stringWithFormat:@"%0.2f",low]
                              };
        NSArray *dataArr = @[@(i),@(open),@(high),@(low),@(close),turnStr];
        CandleChartDataEntry *entry =[[CandleChartDataEntry alloc]initWithX:i shadowH:high shadowL:low open:open close:close data:dic];
        [yVals1 addObject:entry];
    }
    self.myBarChartView.xAxis.valueFormatter = [[DateValueFormatter alloc]initWithArr:xVals];
    
    for (int i = 0; i < self.combineArray.count; i++)
    {
        NSArray *d = self.combineArray[i];
        double onedataY = [[d objectAtIndex:0] doubleValue];
        ChartDataEntry *oneLineEntry = [[ChartDataEntry alloc] initWithX:i y:onedataY];
        [oneYVals addObject:oneLineEntry];
        
        double twodataY = [[d objectAtIndex:1] doubleValue];
        ChartDataEntry *twoLineEntry = [[ChartDataEntry alloc] initWithX:i y:twodataY];
        [twoYVals addObject:twoLineEntry];
        
        double threedataY = [[d objectAtIndex:2] doubleValue];
        ChartDataEntry *threeLineEntry = [[ChartDataEntry alloc] initWithX:i y:threedataY];
        [threeYVals addObject:threeLineEntry];
    }
    LineChartDataSet *oneSet = nil;
    LineChartDataSet *twoSet = nil;
    LineChartDataSet *threeSet = nil;
    CandleChartDataSet *CandleDataset = nil;
//    if (self.myBarChartView.data.dataSetCount > 0) {
//        oneSet = (LineChartDataSet *)self.myBarChartView.data.dataSets[0];
//        oneSet.values = oneYVals;
//        
//        twoSet = (LineChartDataSet *)self.myBarChartView.data.dataSets[1];
//        twoSet.values = twoYVals;
//        
//        threeSet = (LineChartDataSet *)self.myBarChartView.data.dataSets[2];
//        threeSet.values = threeYVals;
//        
//        CandleDataset = (CandleChartDataSet *)self.myBarChartView.data.dataSets[3];
//        CandleDataset.values = yVals1;
//        
//        [self.myBarChartView resetZoom];
//        [self.myBarChartView.data notifyDataChanged];
//        [self.myBarChartView notifyDataSetChanged];
//
//        [self.myBarChartView setVisibleXRangeMaximum:40];
//        [self.myBarChartView setVisibleXRangeMinimum:40];
//        [self.myBarChartView moveViewToX:self.candleArray.count];
//    }else{
        CandleDataset = [QLChartsInitializationCategory getMyCandleChartDataSetWith:yVals1 withLabelText:@""];
        //第一条折线
        oneSet = [QLChartsInitializationCategory getMyLineChartDataSetWith:oneYVals withLabelText:labelStr1];
        oneSet.highlightEnabled = NO;
        [oneSet setColor:ChartsCombineColorOne];
        oneSet.lineWidth = 1.0;
        LineChartData *lineOneData = [[LineChartData alloc]initWithDataSet:oneSet];
        [lineOneData setValueFont:[UIFont systemFontOfSize:0.f]];
        [dataSets addObject:oneSet];
        
        //第二条折线
        twoSet = [QLChartsInitializationCategory getMyLineChartDataSetWith:twoYVals withLabelText:labelStr2];
        twoSet.highlightEnabled = NO;
        [twoSet setColor:ChartsCombineColorTwo];
        twoSet.lineWidth = 1.0;
        LineChartData *lineTwoData = [[LineChartData alloc]initWithDataSet:twoSet];
        [lineTwoData setValueFont:[UIFont systemFontOfSize:0.f]];
        [dataSets addObject:twoSet];
        
        //第三条折线
        threeSet = [QLChartsInitializationCategory getMyLineChartDataSetWith:threeYVals withLabelText:labelStr3];
        threeSet.highlightEnabled = NO;
        [threeSet setColor:ChartsCombineColorThree];
        threeSet.lineWidth = 1.0;
        LineChartData *lineThreeData = [[LineChartData alloc]initWithDataSet:threeSet];
        [lineThreeData setValueFont:[UIFont systemFontOfSize:0.f]];
        [dataSets addObject:threeSet];
        
        //三条折线合并一起
        LineChartData *lineAllData = [[LineChartData alloc]initWithDataSets:dataSets];
        CandleChartData *candleData = [[CandleChartData alloc]initWithDataSet:CandleDataset];
        CombinedChartData *combineData = [[CombinedChartData alloc] init];
        self.myBarChartView.data = nil;
        combineData.lineData = lineAllData;
        
        combineData.candleData = candleData;
        //    self.myBarChartView.leftAxis.axisMaximum =x 0.78;
        //    self.myBarChartView.leftAxis.axisMinimum = -0.96;
        self.myBarChartView.data = combineData;

        [self.myBarChartView setVisibleXRangeMaximum:50];
        [self.myBarChartView setVisibleXRangeMinimum:50];
        [self.myBarChartView setVisibleXRangeMinimum:20];
        [self.myBarChartView moveViewToX:self.candleArray.count];
        [self.myBarChartView autoScale];
//    }
}

@end
