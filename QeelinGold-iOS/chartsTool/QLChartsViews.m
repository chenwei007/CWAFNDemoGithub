//
//  QLChartsViews.m
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/2/23.
//
//

#import "QLChartsViews.h"
#import <Charts/Charts.h>
#import "QeelinGold_iOS-Swift.h"

#import "QLChartsInitializationCategory.h"

@implementation QLChartsViews
+ (LineChartView *)getMyLineChartView{
   LineChartView *chartView = [[LineChartView alloc]init];
    chartView.descriptionText = @"";
    chartView.descriptionFont = [UIFont systemFontOfSize:0];
    //   捏合手势 与 双击手势
    chartView.pinchZoomEnabled = YES;
    //chartView.doubleTapToZoomEnabled = YES;
    [chartView setAutoScaleMinMaxEnabled:YES];//匹配y轴数据自动适配
    [chartView setDragEnabled:YES];// 是否可以拖拽
    [chartView setScaleEnabled:YES];
    //  是否允许x、y轴进行缩放
    chartView.scaleYEnabled = NO;
    chartView.scaleXEnabled = YES;
    chartView.drawGridBackgroundEnabled = NO;
    chartView.drawBordersEnabled = YES;
    chartView.borderColor = color_gray_e2e6eb;

    //图例左侧的大小
    chartView.legend.enabled = NO;
    
    [QLChartsInitializationCategory setChartsMyXAxisWith:chartView.xAxis];
    chartView.xAxis.granularity = 4*60;
    
    [QLChartsInitializationCategory setChartsMyYAxisWith:chartView.leftAxis];
    [QLChartsInitializationCategory setChartsMyYAxisWith:chartView.rightAxis];
    chartView.leftAxis.isChangeColor = YES;
    [chartView.leftAxis setLabelCount:7 force:YES];
    chartView.rightAxis.isChangeColor = YES;
    [chartView.rightAxis setLabelCount:7 force:YES];
    
    NSNumberFormatter *rightformatter = [[NSNumberFormatter alloc]init];
    [rightformatter setPositiveFormat:@"####,##0.00%"];
    rightformatter.numberStyle = kCFNumberFormatterPercentStyle;
    chartView.rightAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:rightformatter];

    BalloonMarker *marker = [QLChartsViews getBalloonMarker];
    marker.chartView = chartView;
    chartView.marker = marker;

    return chartView;
}
+ (CandleStickChartView *)getMyCandleStickChartView{
   CandleStickChartView *kLineView = [[CandleStickChartView alloc]init];
    kLineView.descriptionText = @"";
    kLineView.pinchZoomEnabled = NO;
    kLineView.scaleYEnabled = NO;
    kLineView.drawGridBackgroundEnabled = NO;
    kLineView.drawBordersEnabled = YES;
    kLineView.borderColor = color_gray_e2e6eb;
    kLineView.legend.enabled = NO;
    BalloonMarker *marker = [[BalloonMarker alloc]
                             initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
                             font: [UIFont systemFontOfSize:12.0]
                             textColor: UIColor.whiteColor
                             insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.chartView = kLineView;
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    kLineView.marker = marker;
    return kLineView;
}
+ (CombinedChartView *)getMyCombinedChartsView:(QLChartsViewsType)viewType withPinchZoomEnabled:(BOOL)isZoom
{
    CombinedChartView *comChartView = [[CombinedChartView alloc] init];
    [QLChartsInitializationCategory setChartsMyXAxisWith:comChartView.xAxis];
    [QLChartsInitializationCategory setChartsMyYAxisWith:comChartView.leftAxis];
    [QLChartsInitializationCategory setChartsMyYAxisWith:comChartView.rightAxis];
    comChartView.leftAxis.isChangeColor = NO;
    comChartView.rightAxis.isChangeColor = NO;
    
    comChartView.noDataText = @"";
    comChartView.descriptionText = @"";
    comChartView.descriptionFont = [UIFont systemFontOfSize:0];
    //   捏合手势 与 双击手势
    comChartView.doubleTapToZoomEnabled = NO;
    [comChartView setDragEnabled:YES];// 是否可以拖拽
    comChartView.dragDecelerationEnabled = NO;//拖拽后是否有惯性效果
    comChartView.dragDecelerationFrictionCoef = 0.01;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    //  是否允许x、y轴进行缩放
    comChartView.scaleYEnabled = NO;
    [comChartView setScaleEnabled:NO];
    comChartView.drawGridBackgroundEnabled = NO;
    comChartView.drawBordersEnabled = YES;
    comChartView.borderColor = color_gray_e2e6eb;
    comChartView.legend.enabled = NO;
    if (isZoom) {
        comChartView.pinchZoomEnabled = YES;
        comChartView.scaleXEnabled = YES;
    }else{
        comChartView.pinchZoomEnabled = NO;
        comChartView.scaleXEnabled = NO;
    }
//    //    图标右下角 描述文字
//    comChartView.legend.form = ChartLegendFormLine;
//    //    legend  图例 大小
//    comChartView.legend.formSize = 5;
//    //comChartView.legend.drawInside = YES;
//    //    图例文字颜色
//    comChartView.legend.position = ChartLegendPositionLeftOfChartInside;
//    comChartView.legend.orientation = ChartLegendOrientationVertical;
//    comChartView.legend.formToTextSpace = 30;
//    comChartView.legend.textColor = color_font_757980;
//    NSArray *colorArray = @[[UIColor redColor],[UIColor blackColor],[UIColor greenColor]];
//    comChartView.legend.colorsObjc = colorArray;
    if (viewType == QLChartsViewsCandleStick) {
        [comChartView setAutoScaleMinMaxEnabled:YES];//匹配y轴数据自动适配
        comChartView.xAxis.granularity = 10;
        comChartView.leftAxis.granularity = 0.1;
        [comChartView.leftAxis setLabelCount:7 force:YES];
        [comChartView.rightAxis setLabelCount:7 force:YES];
        comChartView.rightAxis.labelFont = [UIFont systemFontOfSize:0.f];
        comChartView.rightAxis.drawGridLinesEnabled = NO;
        comChartView.drawOrder = @[ @(CombinedChartDrawOrderCandle), @(CombinedChartDrawOrderLine)];
        
        BalloonMarker *marker = [QLChartsViews getBalloonMarker];
        marker.chartView = comChartView;
        comChartView.marker = marker;
    }else if (viewType == QLChartsViewsBar){
        [comChartView setAutoScaleMinMaxEnabled:YES];//匹配y轴数据自动适配
        comChartView.drawOrder = @[ @(CombinedChartDrawOrderBar), @(CombinedChartDrawOrderLine)];
        comChartView.xAxis.labelPosition =XAxisLabelPositionBothSided;
        comChartView.xAxis.labelFont = [UIFont systemFontOfSize:0.f];
        comChartView.xAxis.drawGridLinesEnabled = NO;
        [comChartView.leftAxis setLabelCount:2 force:YES];
        comChartView.leftAxis.spaceTop = 0.3;
        comChartView.leftAxis.granularity = 1;
        comChartView.leftAxis.drawGridLinesEnabled = NO;
        comChartView.rightAxis.drawGridLinesEnabled = NO;
        comChartView.rightAxis.spaceTop = 0.3;
        comChartView.rightAxis.labelFont = [UIFont systemFontOfSize:0.f];
        comChartView.drawMarkers = NO;
    }
    return comChartView;
}
+ (BarChartView *)getMyBarChartView{
    BarChartView *myBarChartsView = [[BarChartView alloc]init];
//    myBarChartsView.backgroundColor = [UIColor blueColor];
    myBarChartsView.noDataText = @"暂无数据";
    myBarChartsView.drawValueAboveBarEnabled = NO;//数值显示在柱形的上面还是下面
    myBarChartsView.drawBarShadowEnabled = NO;//是否绘制柱形的阴影背景
    myBarChartsView.scaleYEnabled = NO;//取消Y轴缩放
    myBarChartsView.doubleTapToZoomEnabled = NO;//取消双击缩放
    myBarChartsView.dragEnabled = YES;//启用拖拽图表
    myBarChartsView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    myBarChartsView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    return myBarChartsView;
}
+ (BalloonMarker *)getBalloonMarker{
//    [UIColor colorWithWhite:180/255. alpha:1.0]
    BalloonMarker *marker = [[BalloonMarker alloc]
                             initWithColor:mark_BackgroundColor
                             font: [UIFont systemFontOfSize:12.0]
                             textColor: UIColor.whiteColor
                             insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    return  marker;
}
@end
