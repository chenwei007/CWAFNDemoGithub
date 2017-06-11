//
//  QLCandleStickAndBarNegativeView.h
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/3/28.
//
//

#import <UIKit/UIKit.h>
@class CombinedChartView,QLChartsDataCategoryView,ChartHighlight;
@interface QLCandleStickAndBarNegativeView : UIView
@property (nonatomic ,strong) CombinedChartView *myCandleStickChartsView;
@property (nonatomic ,strong) CombinedChartView *myBarNegativeView;
@property (nonatomic ,strong)  QLChartsDataCategoryView *myChartsDataCategoryView;
@property (nonatomic ,strong)  NSDictionary *candleAndBarNegativeDic;
- (void)changeChartsLabelText:(NSInteger)index;
- (void)showMarkWith:(NSInteger)index withHight:(ChartHighlight*)highl;
- (instancetype)initWithZoomEnabled:(BOOL)isZoom;
@property (nonatomic ,assign) BOOL isZoom;
@end
