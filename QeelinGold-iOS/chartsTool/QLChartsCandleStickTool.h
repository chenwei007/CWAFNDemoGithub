//
//  QLChartsCandleStickTool.h
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/2/23.
//
//

#import <Foundation/Foundation.h>
@class CandleStickChartView;
@interface QLChartsCandleStickTool : NSObject
- (void)setupCandleStickChartsModel:(NSMutableArray *)candleArray withview:(CandleStickChartView *)candleStickChartView withBool:(BOOL)isMinu;
@end
