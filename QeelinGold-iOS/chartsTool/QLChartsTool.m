//
//  QLChatrsTool.m
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/2/22.
//
//

#import "QLChartsTool.h"
#import "QLChartsModel.h"
#import <Charts/Charts.h>
#import "DateValueFormatter.h"
#import "SetValueFormatter.h"
#import "QLChartsInitializationCategory.h"
@interface QLChartsTool()
@property (nonatomic ,strong)QLChartsModel *chartsModel;
@property (nonatomic ,strong)LineChartView *chartsview;
@end

@implementation QLChartsTool
+(id)shareManager
{
    __strong static QLChartsTool* chartsTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chartsTool = [[QLChartsTool alloc] init];
    });
    return chartsTool;
}

- (void)setupChartsModel:(QLChartsModel *)chartsModel withview:(LineChartView *)chartsview{
    if (chartsModel.xBottonAxisArray.count == 0) return;
    if (self.chartsview != chartsview) {

    }
    self.chartsview = chartsview;
    self.chartsModel = chartsModel;
//    PTTLog(@"charts数据准备完成，传入数据");
    self.chartsview.leftAxis.axisMinValue = [self.chartsModel.leftAxisArray.lastObject floatValue];//设置Y轴的最小值
    self.chartsview.leftAxis.axisMaxValue = [self.chartsModel.leftAxisArray.firstObject floatValue];//设置Y轴的最大值
    self.chartsview.leftAxis.entries = self.chartsModel.leftAxisArray;
//    PTTLog(@"charts-leftYAxis数据准备完成");
    self.chartsview.rightAxis.axisMinValue = -[self.chartsModel.rightAxisArray.firstObject floatValue];//设置Y轴的最小值
    self.chartsview.rightAxis.axisMaxValue = [self.chartsModel.rightAxisArray.firstObject floatValue];;//设置Y轴的最大值
    self.chartsview.rightAxis.entries = self.chartsModel.rightAxisArray;
//    PTTLog(@"charts-rightYAxis数据准备完成");
//    [self setUpXAxis];
//    chartsview.xAxis.valueFormatter = nil;
    chartsview.xAxis.valueFormatter = [[DateValueFormatter alloc]initWithArr:self.chartsModel.xBottonAxisArray];
//    PTTLog(@"charts-XAxis数据准备完成");
    [self setUpChartsDataSet];
}
- (void)setUpChartsDataSet{
    // 第一条折线-设置分时图平均值相关数据
    NSMutableArray *oneYVals = [NSMutableArray array];

    for (int i = 0; i < self.chartsModel.LineChartDataSetOneArray.count; i++) {
        NSArray *yArray = self.chartsModel.LineChartDataSetOneArray[i];
        double datasY = [[yArray objectAtIndex:1] doubleValue];
        NSArray *arr = self.chartsModel.LineChartDataSetTwoArray[i];
        double datas2Y = [[arr objectAtIndex:1] doubleValue];
        double datas3 = 0.00;
        NSString *plusStr = @"";
        if (datasY > self.chartsModel.yesterdayPrice) {
            datas3 = (datasY - self.chartsModel.yesterdayPrice ) / self.chartsModel.yesterdayPrice;
            plusStr = @"+";
        }else if (datasY == self.chartsModel.yesterdayPrice){
            datas3 = 0.00;
        }else if (datasY < self.chartsModel.yesterdayPrice){
            datas3 = (self.chartsModel.yesterdayPrice - datasY) / self.chartsModel.yesterdayPrice;
            plusStr = @"-";
        }
        NSString *datas3Y = [NSString stringWithFormat:@"%@%0.2f%@",plusStr,datas3 * 100,@"%"];
        NSString *timestr = self.chartsModel.xBottonAxisArray[i];
        NSDictionary *dic = @{
                              @"datasY" : [NSString stringWithFormat:@"%0.2f",datasY],
                              @"datas2Y" : [NSString stringWithFormat:@"%0.2f",datas2Y],
                              @"datas3Y" :datas3Y,
                              @"timeStr" : timestr ? timestr : @""
                              };
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:datasY data:dic];
        [oneYVals addObject:entry];

    }
//    for (NSArray *yArray in self.chartsModel.LineChartDataSetOneArray) {
//        double dataY = [[yArray objectAtIndex:1] doubleValue];
//        NSArray *arr = self.chartsModel.LineChartDataSetTwoArray[]
//        NSDictionary *dic = @{
//                              
//                              };
//
//        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:dataY];
//        [oneYVals addObject:entry];
//        i++;
//    }
    // 第二条折线-设置分时图平均值相关数据
    NSMutableArray *twoYvals = [NSMutableArray array];
    int  j =0;
    for (NSArray *yArray in self.chartsModel.LineChartDataSetTwoArray) {
        double dataY = [[yArray objectAtIndex:1] doubleValue];
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:j y:dataY];
        [twoYvals addObject:entry];
        j++;
    }
    // 第三条折线-设置分时图平均值相关数据
    NSMutableArray *threeYVals = [NSMutableArray array];
    for (int i = 0; i < self.chartsModel.xBottonAxisArray.count; i++) {
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:0.00];
        [threeYVals addObject:entry];
    }
    LineChartDataSet *set1 = nil;
    LineChartDataSet *set2 = nil;
    LineChartDataSet *set3 = nil;
    if (self.chartsview.data.dataSetCount > 0) {
        set1 = (LineChartDataSet *)self.chartsview.data.dataSets[0];
        set1.values = oneYVals;
        [self.chartsview.data notifyDataChanged];
        [self.chartsview notifyDataSetChanged];
        
        set2 = (LineChartDataSet *)self.chartsview.data.dataSets[1];
        set2.values = twoYvals;
        [self.chartsview.data notifyDataChanged];
        [self.chartsview notifyDataSetChanged];

        set3 = (LineChartDataSet *)self.chartsview.data.dataSets[2];
        set3.values = threeYVals;
        [self.chartsview.data notifyDataChanged];
        [self.chartsview notifyDataSetChanged];

    }else{
        //创建第一个LineChartDataSet对象
        set1 = [QLChartsInitializationCategory getMyLineChartDataSetWith:oneYVals withLabelText:@""];
        set1.drawFilledEnabled = YES;//是否填充颜色
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#f1f5f8"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#73a5ff"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.fillAlpha = 0.8f;
        set1.drawFilledEnabled = YES;
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        //第二条折线
        set2 =  [QLChartsInitializationCategory getMyLineChartDataSetWith:twoYvals withLabelText:@""];
        set2.highlightEnabled = NO;
        [set2 setColor:[UIColor colorWithRed:230/255.f green:178/255.f blue:87/255.f alpha:1.f]];
        set2.lineWidth = 1.0;
        [dataSets addObject:set2];
        
        //第三条折线
        set3 = [QLChartsInitializationCategory getMyLineChartDataSetWith:threeYVals withLabelText:@""];
        set3.highlightEnabled = NO;
        set3.lineWidth = 0.0;
        [dataSets addObject:set3];
        
        // 绑定数据：分时图数据和均值数据
        LineChartData *data = [[LineChartData alloc]initWithDataSets:dataSets];
        
        //线顶端显示数据
        [data setValueTextColor:[UIColor clearColor]];
        [data setValueFont:[UIFont systemFontOfSize:0.f]];
//        PTTLog(@"charts数据准备完成，准备绘图");
        self.chartsview.data = nil;
        self.chartsview.data = data;
        [self.chartsview setVisibleXRangeMinimum:4*60];
//        PTTLog(@"charts数据准备完成，绘图完成");
    }
}

@end
