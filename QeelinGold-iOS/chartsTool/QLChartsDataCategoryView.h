//
//  QLChartsDataCategoryView.h
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/3/22.
//
//

#import <UIKit/UIKit.h>
@class QLChartsDataCategoryView;
typedef NS_ENUM(NSInteger, QLChartsDataCategoryViewButtonType) {
    
    QLChartsDataCategoryViewMACDButton,
    QLChartsDataCategoryViewKDJButton,
    QLChartsDataCategoryViewRSIButton,
    QLChartsDataCategoryViewBOLLButton
    
};
@protocol QLChartsDataCategoryViewDelegate <NSObject>
- (void)QLChartsDataCategoryViewButtonClick:(QLChartsDataCategoryView *)chartsDataView withButtonType:(QLChartsDataCategoryViewButtonType )buttonType;

@end

@interface QLChartsDataCategoryView : UIView
@property (nonatomic, weak) id <QLChartsDataCategoryViewDelegate> delegate;
- (NSMutableDictionary *)getQLChartsDataCategoryViewButtonTypeString;
+ (QLChartsDataCategoryViewButtonType)getQLChartsDataCategoryViewButtonTypeWithStr:(NSString *)str;

+ (NSMutableAttributedString *)getChartsViewLendStr:(QLChartsDataCategoryViewButtonType)btnType with:(NSMutableArray *)baseLineArr withBar:(NSMutableArray *)lineExtArr isLastObject:(BOOL )isLas;

@end
