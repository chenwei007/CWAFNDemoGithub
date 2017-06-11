//
//  QLChartsDataCategoryView.m
//  QeelinMetal-iOS
//
//  Created by MacBook on 2017/3/22.
//
//

#import "QLChartsDataCategoryView.h"

@interface QLChartsDataCategoryView()
@property (nonatomic ,strong)UIButton *btn1;
@property (nonatomic ,strong)UIButton *btn2;
@property (nonatomic ,strong)UIButton *btn3;
@property (nonatomic ,strong)UIButton *btn4;
@property (nonatomic ,assign) QLChartsDataCategoryViewButtonType btnTypeBaselinetype;
@property (nonatomic ,assign) QLChartsDataCategoryViewButtonType btnTypeLinetype;
@end

@implementation QLChartsDataCategoryView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpButtons];
    }
    return self;
}
- (void)setUpButtons{
    self.btnTypeBaselinetype = QLChartsDataCategoryViewMACDButton;
    self.btnTypeLinetype = QLChartsDataCategoryViewMACDButton;
    UIButton *btn1 = [self getButton:@"MACD"];
    self.btn1 = btn1;
    [btn1 addTarget:self action:@selector(MACDClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn1];
    
    UIButton *btn2 = [self getButton:@"KDJ"];
    self.btn2 = btn2;
    [btn2 addTarget:self action:@selector(KDJClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn2];
    
    UIButton *btn3 = [self getButton:@"RSI"];
    self.btn3 = btn3;
    [btn3 addTarget:self action:@selector(RSIClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn3];
    
    UIButton *btn4 = [self getButton:@"BOLL"];
    self.btn4 = btn4;
    [btn4 addTarget:self action:@selector(BOLLClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn4];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(btn2.mas_height);
        make.top.equalTo(self).offset(10);
    }];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(btn3.mas_height);
        make.top.equalTo(btn1.mas_bottom).offset(10);
    }];

    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(btn4.mas_height);
        make.top.equalTo(btn2.mas_bottom).offset(10);
    }];

    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(btn1.mas_height);
        make.top.equalTo(btn3.mas_bottom).offset(10);
        make.bottom.equalTo(self).offset(-10);
    }];


}
- (void)MACDClickBtn{
    self.btnTypeLinetype = QLChartsDataCategoryViewMACDButton;
    [self.btn1 setTitleColor:color_red_ff5353 forState:UIControlStateNormal];
    [self.btn2 setTitleColor:color_font_757980 forState:UIControlStateNormal];
    [self.btn3 setTitleColor:color_font_757980 forState:UIControlStateNormal];

    if ([self.delegate respondsToSelector:@selector(QLChartsDataCategoryViewButtonClick:withButtonType:)]) {
        [self.delegate QLChartsDataCategoryViewButtonClick:self withButtonType:QLChartsDataCategoryViewMACDButton];
    }
}
- (void)KDJClickBtn{
    self.btnTypeLinetype = QLChartsDataCategoryViewKDJButton;
    [self.btn2 setTitleColor:color_red_ff5353 forState:UIControlStateNormal];
    [self.btn1 setTitleColor:color_font_757980 forState:UIControlStateNormal];
    [self.btn3 setTitleColor:color_font_757980 forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(QLChartsDataCategoryViewButtonClick:withButtonType:)]) {
        [self.delegate QLChartsDataCategoryViewButtonClick:self withButtonType:QLChartsDataCategoryViewKDJButton];
    }
   
}
- (void)RSIClickBtn{
    self.btnTypeLinetype = QLChartsDataCategoryViewRSIButton;
    [self.btn3 setTitleColor:color_red_ff5353 forState:UIControlStateNormal];
    [self.btn1 setTitleColor:color_font_757980 forState:UIControlStateNormal];
    [self.btn2 setTitleColor:color_font_757980 forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(QLChartsDataCategoryViewButtonClick:withButtonType:)]) {
        [self.delegate QLChartsDataCategoryViewButtonClick:self withButtonType:QLChartsDataCategoryViewRSIButton];
    }
 
}
- (void)BOLLClickBtn{
    if (self.btnTypeBaselinetype == QLChartsDataCategoryViewMACDButton) {
        self.btnTypeBaselinetype = QLChartsDataCategoryViewBOLLButton;
        [self.btn4 setTitleColor:color_red_ff5353 forState:UIControlStateNormal];
    }else if (self.btnTypeBaselinetype == QLChartsDataCategoryViewBOLLButton){
        self.btnTypeBaselinetype = QLChartsDataCategoryViewMACDButton;
        [self.btn4 setTitleColor:color_font_757980 forState:UIControlStateNormal];
    }

    if ([self.delegate respondsToSelector:@selector(QLChartsDataCategoryViewButtonClick:withButtonType:)]) {
        [self.delegate QLChartsDataCategoryViewButtonClick:self withButtonType:QLChartsDataCategoryViewBOLLButton];
    }
 
}

- (UIButton *)getButton:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    if ([title isEqualToString:@"MACD"]) {
        [btn setTitleColor:color_red_ff5353 forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:color_font_757980 forState:UIControlStateNormal];
    }
    [btn setTitleColor:color_red_ff5353 forState:UIControlStateSelected];
    btn.titleLabel.font = font_new_littleTitle;
    return btn;
}
- (NSMutableDictionary *)getQLChartsDataCategoryViewButtonTypeString{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    if (self.btnTypeBaselinetype == QLChartsDataCategoryViewMACDButton) {
       [mDic setObject:@"MA" forKey:@"baselinetype"];
    }else if (self.btnTypeBaselinetype == QLChartsDataCategoryViewBOLLButton){
        [mDic setObject:@"BOLL" forKey:@"baselinetype"];
    }else{
       [mDic setObject:@"MA" forKey:@"baselinetype"];
    }
    if (self.btnTypeLinetype == QLChartsDataCategoryViewMACDButton) {
        [mDic setObject:@"MACD" forKey:@"linetype"];
    }else if (self.btnTypeLinetype == QLChartsDataCategoryViewKDJButton){
        [mDic setObject:@"KDJ" forKey:@"linetype"];
    }else if (self.btnTypeLinetype == QLChartsDataCategoryViewRSIButton){
        [mDic setObject:@"RSI" forKey:@"linetype"];
    }else{
        [mDic setObject:@"MACD" forKey:@"linetype"];
    }
    return mDic;
}
+ (QLChartsDataCategoryViewButtonType)getQLChartsDataCategoryViewButtonTypeWithStr:(NSString *)str{
    QLChartsDataCategoryViewButtonType btnType = QLChartsDataCategoryViewMACDButton;
    if ([str isEqualToString:@"MACD"]) {
        btnType = QLChartsDataCategoryViewMACDButton;
    }else if ([str isEqualToString:@"KDJ"]){
        btnType = QLChartsDataCategoryViewKDJButton;
    }else if ([str isEqualToString:@"RSI"]){
        btnType = QLChartsDataCategoryViewRSIButton;
    }else if ([str isEqualToString:@"MA"]){
        btnType = QLChartsDataCategoryViewMACDButton;
    }else if ([str isEqualToString:@"BOLL"]){
        btnType = QLChartsDataCategoryViewBOLLButton;
    }

    return btnType;
}

+ (NSMutableAttributedString *)getChartsViewLendStr:(QLChartsDataCategoryViewButtonType)btnType with:(NSMutableArray *)baseLineArr withBar:(NSMutableArray *)lineExtArr isLastObject:(BOOL )isLast{
    NSString *labelStr1 = @"";
    NSString *labelStr2 = @"";
    NSString *labelStr3 = @"";
    NSArray *d = [NSArray array];
    if (baseLineArr.count > 0) {
        if (btnType == QLChartsDataCategoryViewMACDButton) {
            labelStr1 = @"MA5";
            labelStr2 = @"MA10";
            labelStr3 = @"MA20";
        }else if (btnType == QLChartsDataCategoryViewBOLLButton){
            labelStr1 = @"MB";
            labelStr2 = @"UP";
            labelStr3 = @"DN";
        }
        if (isLast) {
            d = baseLineArr.lastObject;
        }else{
            d = baseLineArr;
        }
    }else if (lineExtArr.count > 0){
        if (btnType == QLChartsDataCategoryViewMACDButton) {
            labelStr1 = @"DIFF";
            labelStr2 = @"DEA";
            labelStr3 = @"MACD";
        }else if (btnType == QLChartsDataCategoryViewKDJButton){
            labelStr1 = @"K";
            labelStr2 = @"D";
            labelStr3 = @"J";
        }else if (btnType == QLChartsDataCategoryViewRSIButton){
            labelStr1 = @"RSI1";
            labelStr2 = @"RSI2";
            labelStr3 = @"RSI3";
        }
        if (isLast) {
            d = lineExtArr.lastObject;
        }else{
            d = lineExtArr;
        }
    }else{
        return nil;
    }
    double onedataY = [[d objectAtIndex:0] doubleValue];
    labelStr1 = [NSString stringWithFormat:@"%@:%0.2f  ",labelStr1,onedataY];
    double twodataY = [[d objectAtIndex:1] doubleValue];
    labelStr2 = [NSString stringWithFormat:@"%@:%0.2f  ",labelStr2,twodataY];
    double threedataY = [[d objectAtIndex:2] doubleValue];
    labelStr3 = [NSString stringWithFormat:@"%@:%0.2f",labelStr3,threedataY];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@",labelStr1,labelStr2,labelStr3]];
    [attStr addAttribute:NSForegroundColorAttributeName value:ChartsCombineColorOne range:NSMakeRange(0,labelStr1.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:ChartsCombineColorTwo range:NSMakeRange(labelStr1.length, labelStr2.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:ChartsCombineColorThree range:NSMakeRange(labelStr1.length + labelStr2.length, labelStr3.length)];
    return attStr;
}

@end
