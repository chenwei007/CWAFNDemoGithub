//
//  QLChartsViews.h
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/2/23.
//
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, QLChartsViewsType) {
    
    QLChartsViewsCandleStick,
    QLChartsViewsBar
};

@class LineChartView,CandleStickChartView,BarChartView,CombinedChartView;
@interface QLChartsViews : NSObject
+ (LineChartView *)getMyLineChartView;
+ (CandleStickChartView *)getMyCandleStickChartView;
+ (BarChartView *)getMyBarChartView;
+ (CombinedChartView *)getMyCombinedChartsView:(QLChartsViewsType)viewType withPinchZoomEnabled:(BOOL)isZoom;
@end
