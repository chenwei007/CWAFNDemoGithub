//
//  QLChartsBarNegativeTool.h
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/3/16.
//
//

#import <Foundation/Foundation.h>
@class CombinedChartView;
@interface QLChartsBarNegativeTool : NSObject
- (void)setupBarNegativeChartsModel:(NSMutableArray *)barArray withview:(CombinedChartView *)myBarChartView withParam:(NSMutableDictionary *)param;
@end
