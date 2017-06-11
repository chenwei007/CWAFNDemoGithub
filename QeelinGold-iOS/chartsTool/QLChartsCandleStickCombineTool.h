//
//  QLChartsCandleStickCombineTool.h
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/3/22.
//
//

#import <Foundation/Foundation.h>
@class CombinedChartView;
@interface QLChartsCandleStickCombineTool : NSObject
- (void)setupCandleStickChartsModel:(NSMutableArray *)candleArray withCombinedData:(NSMutableArray *)combineArray withview:(CombinedChartView *)combineChartsView wihtParam:(NSMutableDictionary *)param withBool:(BOOL)isMinu;

@end
