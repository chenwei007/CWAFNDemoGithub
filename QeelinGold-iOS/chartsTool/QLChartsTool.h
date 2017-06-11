//
//  QLChatrsTool.h
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/2/22.
//
//

#import <Foundation/Foundation.h>
@class QLChartsModel,LineChartView;
@interface QLChartsTool : NSObject
+ (instancetype)shareManager;
- (void)setupChartsModel:(QLChartsModel *)chartsModel withview:(LineChartView *)chartsview;
@end
