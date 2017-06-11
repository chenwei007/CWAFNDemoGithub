//
//  QLChartsModel.h
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/2/22.
//
//

@interface QLChartsModel : NSObject
@property (nonatomic ,strong) NSArray *leftAxisArray;
@property (nonatomic ,strong) NSArray *rightAxisArray;
@property (nonatomic ,strong) NSArray *xBottonAxisArray;
@property (nonatomic ,strong) NSArray *LineChartDataSetOneArray;
@property (nonatomic ,strong) NSArray *LineChartDataSetTwoArray;
@property (nonatomic ,assign) double yesterdayPrice;
@end
