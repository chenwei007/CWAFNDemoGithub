//
//  QLChartsBarNegativeTool.m
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/3/16.
//
//

#import "QLChartsBarNegativeTool.h"
#import <Charts/Charts.h>
#import "DateValueFormatter.h"
#import "QLChartsDataCategoryView.h"
#import "QLChartsInitializationCategory.h"
@interface QLChartsBarNegativeTool()
@property (nonatomic ,strong) NSMutableArray *barArray;
@property (nonatomic ,strong) CombinedChartView  *myBarChartView;
@property (nonatomic ,strong)ChartYAxis *leftYAxis;
@property (nonatomic ,assign) QLChartsDataCategoryViewButtonType BtnType;
@end

@implementation QLChartsBarNegativeTool
- (void)setupBarNegativeChartsModel:(NSMutableArray *)barArray withview:(CombinedChartView *)myBarChartView withParam:(NSMutableDictionary *)param{
    if (barArray.count == 0) return;
    self.barArray = barArray;
    self.myBarChartView = myBarChartView;
    self.BtnType = [QLChartsDataCategoryView getQLChartsDataCategoryViewButtonTypeWithStr:[param objectForKey:@"linetype"]];
    
    NSNumberFormatter *rightformatter = [[NSNumberFormatter alloc]init];
    [rightformatter setPositiveFormat:@"###,##0.00"];
    rightformatter.numberStyle = kCFNumberFormatterPercentStyle;
    self.myBarChartView.leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:rightformatter];

    [self setupBarNegativeChartsDataset];
}
- (void)setupBarNegativeChartsDataset{
    NSString *labelStr1 = @"";
    NSString *labelStr2 = @"";
    NSString *labelStr3 = @"";
    if (self.BtnType == QLChartsDataCategoryViewMACDButton) {
        labelStr1 = @"DIFF";
        labelStr2 = @"DEA";
        labelStr3 = @"MACD";
    }else if (self.BtnType == QLChartsDataCategoryViewKDJButton){
        labelStr1 = @"K";
        labelStr2 = @"D";
        labelStr3 = @"J";
    }else if (self.BtnType == QLChartsDataCategoryViewRSIButton){
        labelStr1 = @"RSI1";
        labelStr2 = @"RSI2";
        labelStr3 = @"RSI3";
    }


    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    NSMutableArray *oneYVals = [NSMutableArray array];
    NSMutableArray *twoYVals = [NSMutableArray array];
    NSMutableArray *threeYVals = [NSMutableArray array];

    NSMutableArray<BarChartDataEntry *> *values = [[NSMutableArray alloc] init];
    NSMutableArray<UIColor *> *colors = [[NSMutableArray alloc] init];
    
    UIColor *green = ChartsCombineColorTwo;
    UIColor *red = ChartsCombineColorRed;
    
    for (int i = 0; i < self.barArray.count; i++)
    {
        NSArray *d = self.barArray[i];
        double onedataY = [[d objectAtIndex:0] doubleValue];
        ChartDataEntry *oneLineEntry = [[ChartDataEntry alloc] initWithX:i y:onedataY];
        [oneYVals addObject:oneLineEntry];
        
        double twodataY = [[d objectAtIndex:1] doubleValue];
        ChartDataEntry *twoLineEntry = [[ChartDataEntry alloc] initWithX:i y:twodataY];
        [twoYVals addObject:twoLineEntry];
        
        double threedataY = [[d objectAtIndex:2] doubleValue];
        ChartDataEntry *threeLineEntry = [[ChartDataEntry alloc] initWithX:i y:threedataY];
        [threeYVals addObject:threeLineEntry];


        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:[@(i) doubleValue] y:[d[2] doubleValue]];
        [values addObject:entry];
        
        // specific colors
        if ([d[2] doubleValue] >= 0.f)
        {
            [colors addObject:red];
        }
        else
        {
            [colors addObject:green];
        }
    }
    //第一条折线
    LineChartDataSet *oneSet = nil;
    oneSet = [QLChartsInitializationCategory getMyLineChartDataSetWith:oneYVals withLabelText:labelStr1];
    [oneSet setColor:ChartsCombineColorOne];
    oneSet.lineWidth = 1.0;
    oneSet.highlightEnabled = NO;
    LineChartData *lineOneData = [[LineChartData alloc]initWithDataSet:oneSet];
    [lineOneData setValueFont:[UIFont systemFontOfSize:0.f]];
    [dataSets addObject:oneSet];
    
    //第二条折线
    LineChartDataSet *twoSet = nil;
    twoSet = [QLChartsInitializationCategory getMyLineChartDataSetWith:twoYVals withLabelText:labelStr2];
    twoSet.highlightEnabled = NO;
    [twoSet setColor:ChartsCombineColorTwo];
    twoSet.lineWidth = 1.0;
    LineChartData *lineTwoData = [[LineChartData alloc]initWithDataSet:twoSet];
    [lineTwoData setValueFont:[UIFont systemFontOfSize:0.f]];
    [dataSets addObject:twoSet];
    
    if (self.BtnType != QLChartsDataCategoryViewMACDButton) {
        //第三条折线
        LineChartDataSet *threeSet = nil;
        threeSet = [QLChartsInitializationCategory getMyLineChartDataSetWith:threeYVals withLabelText:labelStr3];
        threeSet.highlightEnabled = NO;
        [threeSet setColor:ChartsCombineColorThree];
        threeSet.lineWidth = 1.0;
        LineChartData *lineThreeData = [[LineChartData alloc]initWithDataSet:threeSet];
        [lineThreeData setValueFont:[UIFont systemFontOfSize:0.f]];
        [dataSets addObject:threeSet];
    }
    //三条折线合并一起
    LineChartData *lineAllData = [[LineChartData alloc]initWithDataSets:dataSets];

    BarChartDataSet *set = [QLChartsInitializationCategory getMyBarChartDataSetWith:values withLabelText:labelStr3];
    set.colors = colors;
    set.valueColors = colors;

    BarChartData *barData = [[BarChartData alloc] initWithDataSet:set];
    [barData setValueFont:[UIFont systemFontOfSize:0.f]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.maximumFractionDigits = 1;
    [barData setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:formatter]];
    barData.barWidth = 0.8;

    CombinedChartData *combineData = [[CombinedChartData alloc] init];
    self.myBarChartView.data = nil;
    combineData.lineData = lineAllData;
    if (self.BtnType == QLChartsDataCategoryViewMACDButton) {
         combineData.barData = barData;   
    }
//    self.myBarChartView.leftAxis.axisMaximum = 0.78;
//    self.myBarChartView.leftAxis.axisMinimum = -0.96;
    self.myBarChartView.data = combineData;
    [self.myBarChartView setVisibleXRangeMaximum:50];
    [self.myBarChartView setVisibleXRangeMinimum:50];
    [self.myBarChartView setVisibleXRangeMinimum:20];
    [self.myBarChartView moveViewToX:self.barArray.count];
    [self.myBarChartView autoScale];
}

- (ChartYAxis *)leftYAxis{
    if (_leftYAxis == nil) {
        ChartYAxis *leftAxis = self.myBarChartView.leftAxis;
        leftAxis.drawLabelsEnabled = NO;
        leftAxis.spaceTop = 0.25;
        leftAxis.spaceBottom = 0.25;
        leftAxis.drawAxisLineEnabled = NO;
        leftAxis.drawGridLinesEnabled = NO;
        leftAxis.drawZeroLineEnabled = YES;
        leftAxis.zeroLineColor = UIColor.grayColor;
        leftAxis.zeroLineWidth = 0.7f;
        _leftYAxis = leftAxis;
        
    }
    return _leftYAxis;
}
@end
