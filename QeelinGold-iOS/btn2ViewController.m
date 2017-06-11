//
//  btn2ViewController.m
//  QeelinGold-iOS
//
//  Created by MacBook on 2017/4/7.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "btn2ViewController.h"
#import "QLChartsCandleStickCombineTool.h"
#import "QLChartsBarNegativeTool.h"
#import <Charts/Charts.h>
#import "QLCandleStickAndBarNegativeView.h"
#import "QLChartsDataCategoryView.h"
@interface btn2ViewController ()<ChartViewDelegate,QLChartsDataCategoryViewDelegate>
@property (nonatomic ,strong) QLCandleStickAndBarNegativeView *myCandleStickAndBarNegativeChartsView;
@end

@implementation btn2ViewController
- (QLCandleStickAndBarNegativeView *)myCandleStickAndBarNegativeChartsView{
    if (_myCandleStickAndBarNegativeChartsView == nil) {
        _myCandleStickAndBarNegativeChartsView = [[QLCandleStickAndBarNegativeView alloc]initWithZoomEnabled:NO];
        _myCandleStickAndBarNegativeChartsView.myCandleStickChartsView.delegate = self;
        _myCandleStickAndBarNegativeChartsView.myBarNegativeView.delegate = self;
        _myCandleStickAndBarNegativeChartsView.myChartsDataCategoryView.delegate =self;
    }
    return _myCandleStickAndBarNegativeChartsView;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.myCandleStickAndBarNegativeChartsView removeFromSuperview];
    [self.myCandleStickAndBarNegativeChartsView.myBarNegativeView removeFromSuperview];
    self.myCandleStickAndBarNegativeChartsView.myBarNegativeView = nil;
    [self.myCandleStickAndBarNegativeChartsView.myCandleStickChartsView  removeFromSuperview];
    self.myCandleStickAndBarNegativeChartsView.myCandleStickChartsView = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = color_background_f1f5f8;
//    self.myCandleStickAndBarNegativeChartsView.frame = self.view.bounds;
    self.myCandleStickAndBarNegativeChartsView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 70);
    [self.view addSubview:self.myCandleStickAndBarNegativeChartsView];
    
    NSString *comePath = [[NSBundle mainBundle] pathForResource:@"Documentscome" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:comePath];
    NSArray *arr = [[dic objectForKey:@"item"]objectForKey:@"datas"];
    NSArray *lineExtArr = [[dic objectForKey:@"item"]objectForKey:@"lineExt"];
    NSArray *baseLineArr = [[dic objectForKey:@"item"]objectForKey:@"baseLine"];
    if ([arr count] > 0) {
        QLChartsCandleStickCombineTool *candleCombineTool = [[QLChartsCandleStickCombineTool alloc]init];
        QLChartsBarNegativeTool *barTool = [[QLChartsBarNegativeTool alloc]init];
        NSDictionary *dic = @{
                              @"period":@"6"
                              };
        NSString *period = @"6";
        BOOL isMinu = NO;
        if (period.integerValue>=1 && period.integerValue<=5) {
            isMinu = YES;
        }else{
            isMinu = NO;
        }
        //单纯的CandleStickChartView
        //[candleStickTool setupCandleStickChartsModel:(NSMutableArray *)arr withview:candleStickChartView withBool:isMinu];
        //混合的CandleStickChartView
        [candleCombineTool setupCandleStickChartsModel:(NSMutableArray *)arr withCombinedData:(NSMutableArray *)baseLineArr withview:self.myCandleStickAndBarNegativeChartsView.myCandleStickChartsView wihtParam:(NSMutableDictionary *)dic withBool:isMinu];
        [barTool setupBarNegativeChartsModel:(NSMutableArray *)lineExtArr withview:self.myCandleStickAndBarNegativeChartsView.myBarNegativeView withParam:(NSMutableDictionary *)dic];
        
        NSDictionary *mDic = @{
                               @"arr":arr,
                               @"lineExtArr" : lineExtArr?lineExtArr:@[],
                               @"baseLineArr":baseLineArr?baseLineArr:@[],
                               @"paramets":dic
                               };
        self.myCandleStickAndBarNegativeChartsView.candleAndBarNegativeDic = mDic;
        
    }
}
- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight{
    double x = entry.x;
    NSInteger index = (NSInteger )x;
    if (chartView == self.myCandleStickAndBarNegativeChartsView.myCandleStickChartsView) {
        [self.myCandleStickAndBarNegativeChartsView changeChartsLabelText:index];
    }else if (chartView == self.myCandleStickAndBarNegativeChartsView.myBarNegativeView){
        [self.myCandleStickAndBarNegativeChartsView changeChartsLabelText:index];
        [self.myCandleStickAndBarNegativeChartsView showMarkWith:index withHight:highlight];
    }
}
- (void)chartScaled:(ChartViewBase *)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY{
    PTTLog(@"chartScaled %@----%f----%f",chartView,scaleX,scaleY);
}
- (void)chartTranslated:(ChartViewBase *)chartView matrix:(CGAffineTransform)matrix{
    if (chartView == self.myCandleStickAndBarNegativeChartsView.myBarNegativeView) {
        [self.myCandleStickAndBarNegativeChartsView.myCandleStickChartsView.viewPortHandler refreshWithNewMatrix:matrix chart:self.myCandleStickAndBarNegativeChartsView.myCandleStickChartsView invalidate:YES];
    }
    if (chartView == self.myCandleStickAndBarNegativeChartsView.myCandleStickChartsView) {
        [self.myCandleStickAndBarNegativeChartsView.myBarNegativeView.viewPortHandler refreshWithNewMatrix:matrix chart:self.myCandleStickAndBarNegativeChartsView.myBarNegativeView invalidate:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
