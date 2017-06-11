//
//  QLCandleStickAndBarNegativeView.m
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/3/28.
//
//

#import "QLCandleStickAndBarNegativeView.h"
#import <Charts/Charts.h>
//#import "QeelinGold-iOS-Swift.h"
#import "QLChartsDataCategoryView.h"
#import "QLChartsViews.h"
#import "Masonry.h"

@interface QLCandleStickAndBarNegativeView()
@property (nonatomic ,strong) UILabel *myBarNegativeViewLabel;
@property (nonatomic ,strong) UILabel *myCandleStickChartsViewLabel;
@property (nonatomic ,strong) NSMutableArray *arr;
@property (nonatomic ,strong) NSMutableArray *chartslineExtArr;
@property (nonatomic ,strong) NSMutableArray *chartsbaseLineArr;
@property (nonatomic ,strong) NSDictionary *parametsDic;
@end

@implementation QLCandleStickAndBarNegativeView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithZoomEnabled:(BOOL)isZoom{
    self = [super init];
    if (self) {
        self.isZoom = isZoom;
        [self commonInit];
    }
    return self;
 
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self commonInit];
    }
    return self;
}
- (void)setCandleAndBarNegativeDic:(NSDictionary *)candleAndBarNegativeDic{
    _candleAndBarNegativeDic = candleAndBarNegativeDic;
    self.arr = candleAndBarNegativeDic[@"arr"];
    self.chartslineExtArr = candleAndBarNegativeDic[@"lineExtArr"];
    self.chartsbaseLineArr = candleAndBarNegativeDic[@"baseLineArr"];
    self.parametsDic = candleAndBarNegativeDic[@"paramets"];
    QLChartsDataCategoryViewButtonType baseLineBtnType = [QLChartsDataCategoryView getQLChartsDataCategoryViewButtonTypeWithStr:[self.parametsDic objectForKey:@"baselinetype"]];
    QLChartsDataCategoryViewButtonType lineExtBtnType = [QLChartsDataCategoryView getQLChartsDataCategoryViewButtonTypeWithStr:[self.parametsDic objectForKey:@"linetype"]];
    NSMutableAttributedString *baseLineLabeltext = [QLChartsDataCategoryView getChartsViewLendStr:baseLineBtnType with:self.chartsbaseLineArr withBar:nil isLastObject:YES];
    NSMutableAttributedString *lineExtLabeltext = [QLChartsDataCategoryView getChartsViewLendStr:lineExtBtnType with:nil withBar:self.chartslineExtArr isLastObject:YES];
    self.myCandleStickChartsViewLabel.attributedText = baseLineLabeltext;
    self.myBarNegativeViewLabel.attributedText = lineExtLabeltext;
}
- (void)changeChartsLabelText:(NSInteger)index{
    NSArray *baseLineArr = self.chartsbaseLineArr[index];
    QLChartsDataCategoryViewButtonType btnType = [QLChartsDataCategoryView getQLChartsDataCategoryViewButtonTypeWithStr:[self.parametsDic objectForKey:@"baselinetype"]];
    NSMutableAttributedString *baseLineLabeltext = [QLChartsDataCategoryView getChartsViewLendStr:btnType with:(NSMutableArray *)baseLineArr withBar:nil isLastObject:NO];
    
    NSArray *lineExtArr = self.chartslineExtArr[index];
    QLChartsDataCategoryViewButtonType lineExtBtnType = [QLChartsDataCategoryView getQLChartsDataCategoryViewButtonTypeWithStr:[self.parametsDic objectForKey:@"linetype"]];
    NSMutableAttributedString *lineExtLabeltext = [QLChartsDataCategoryView getChartsViewLendStr:lineExtBtnType with:nil withBar:(NSMutableArray *)lineExtArr isLastObject:NO];
    self.myCandleStickChartsViewLabel.attributedText = baseLineLabeltext;
    self.myBarNegativeViewLabel.attributedText = lineExtLabeltext;

}
- (void)showMarkWith:(NSInteger)index withHight:(ChartHighlight*)highl{
//        NSArray *newArr = self.arr[index];
//        NSString *xStr = ((NSNumber *)(newArr.lastObject)).stringValue;
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:xStr.floatValue / 1000];
//        NSDateFormatter *df = [NSDateFormatter new];
//        NSString *period = [self.parametsDic objectForKey:@"period"];
//        BOOL isMinu = NO;
//        if (period.integerValue>=1 && period.integerValue<=5) {
//            isMinu = YES;
//        }else{
//            isMinu = NO;
//        }
//        if (isMinu) {
//            [df setDateFormat:@"HH:mm"];//时间戳转成日期
//        }else{
//            [df setDateFormat:@"MM-dd"];//时间戳转成日期
//        }
//        NSString *  turnStr = [df stringFromDate:date];
//    
//        double high = ((NSNumber *)newArr[2]).doubleValue;
//        double low = ((NSNumber *)newArr[3]).doubleValue;
//        double open = ((NSNumber *)newArr[1]).doubleValue;
//        double close = ((NSNumber *)newArr[4]).doubleValue;
//        NSDictionary *dic = @{
//                              @"time":turnStr,
//                              @"open":[NSString stringWithFormat:@"%0.2f",open],
//                              @"close":[NSString stringWithFormat:@"%0.2f",close],
//                              @"high":[NSString stringWithFormat:@"%0.2f",high],
//                              @"low":[NSString stringWithFormat:@"%0.2f",low]
//                              };
//        CandleChartDataEntry *entry =[[CandleChartDataEntry alloc]initWithX:index shadowH:high shadowL:low open:open close:close data:dic];
////    self.myCandleStickChartsView setHighlighter:<#(id<IChartHighlighter> _Nullable)#>
//   ChartHighlight *highlll = [self.myCandleStickChartsView.highlighter getHighlightWithX:entry.x y:entry.y];
//    [self.myCandleStickChartsView.marker refreshContentWithEntry:entry highlight:highlll ];
//    [self.myCandleStickChartsView setHighlighter:highlll];
    
    
}
- (void)commonInit{
    [self addSubview:self.myCandleStickChartsViewLabel];
    [self addSubview:self.myCandleStickChartsView];
    [self addSubview:self.myBarNegativeViewLabel];
//    [self.myCandleStickChartsView addSubview:self.myCandleStickChartsViewLabel];
    [self addSubview:self.myChartsDataCategoryView];
    [self addSubview:self.myBarNegativeView];
//    [self.myBarNegativeView addSubview:self.myBarNegativeViewLabel];
    
    [self.myCandleStickChartsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self.myChartsDataCategoryView.mas_left).offset(10);
        make.bottom.equalTo(self.myBarNegativeView.mas_top).offset(-10);
    }];
    [self.myCandleStickChartsViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(6);
        make.left.equalTo(self).offset(40);
        make.height.equalTo(@20);
    }];
//    [self.myCandleStickChartsViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.myCandleStickChartsView).offset(6);
//        make.left.equalTo(self.myCandleStickChartsView).offset(40);
//        make.height.equalTo(@20);
//    }];
    [self.myChartsDataCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.myCandleStickChartsView.mas_right).offset(-10);
        make.width.equalTo(@(70));
        make.right.equalTo(self);
        make.bottom.equalTo(self.myBarNegativeView.mas_top).offset(-10);
    }];
    [self.myBarNegativeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self.myChartsDataCategoryView.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@80);
    }];
    [self.myBarNegativeViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myCandleStickChartsViewLabel);
        make.top.equalTo(self.myBarNegativeView.mas_top).offset(6);
        make.height.equalTo(self.myCandleStickChartsViewLabel);
    }];
//    [self.myBarNegativeViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.myBarNegativeView).offset(6);
//        make.left.equalTo(self.myBarNegativeView).offset(40);
//        make.height.equalTo(@20);
//    }];

}

- (CombinedChartView *)myCandleStickChartsView{
    if (_myCandleStickChartsView == nil) {
        _myCandleStickChartsView  = [QLChartsViews getMyCombinedChartsView:QLChartsViewsCandleStick withPinchZoomEnabled:self.isZoom];
    }
    return _myCandleStickChartsView;
}
- (CombinedChartView *)myBarNegativeView{
    if (_myBarNegativeView == nil) {
        _myBarNegativeView = [QLChartsViews getMyCombinedChartsView:QLChartsViewsBar withPinchZoomEnabled:self.isZoom];
    }
    return _myBarNegativeView;
}
- (QLChartsDataCategoryView *)myChartsDataCategoryView{
    if (_myChartsDataCategoryView == nil) {
        _myChartsDataCategoryView = [[QLChartsDataCategoryView alloc]init];
    }
    return _myChartsDataCategoryView;
}
- (UILabel *)myBarNegativeViewLabel{
    if (_myBarNegativeViewLabel == nil) {
        _myBarNegativeViewLabel = [[UILabel alloc]init];
        _myBarNegativeViewLabel.font = font_new_tabbar;
    }
    return _myBarNegativeViewLabel;
}
- (UILabel *)myCandleStickChartsViewLabel{
    if (_myCandleStickChartsViewLabel == nil) {
        _myCandleStickChartsViewLabel = [[UILabel alloc]init];
        _myCandleStickChartsViewLabel.font = font_new_tabbar;
    }
    return _myCandleStickChartsViewLabel;
}

@end
