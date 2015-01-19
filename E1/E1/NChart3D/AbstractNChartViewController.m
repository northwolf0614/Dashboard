//
//  AbstractNChartViewController.m
//  E1
//
//  Created by Lei Zhao on 30/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AbstractNChartViewController.h"
#import "Definations.h"
#import "NChartDataModel.h"



@interface AbstractNChartViewController ()
@property(nonatomic,assign) BOOL isShowMiddleLabel;
//@property(nonatomic,strong) UITapGestureRecognizer* tapGestureRecognizer;
@end

@implementation AbstractNChartViewController
//-(void)dealloc
//{
////    [_dataForNChart removeObserver:self forKeyPath:@"chartDataForDrawing"];//chartDataForDrawing
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.titleItem setTitle:self.dataForNChart.chartCaption];
    self.chartView = [[AbstractNChartView alloc] initWithFrame:CGRectZero];
    self.chartView.chart.licenseKey = kcNchartViewlicense;
    self.chartView.chart.cartesianSystem.margin = NChartMarginMake(0, 0, 0, 0);
    self.chartView.chart.shouldAntialias = YES;
    //self.chartView.chart.drawIn3D = YES;
    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.chartView];
    self.chartView.chart.cartesianSystem.xAxis.dataSource = (id)self;
    self.chartView.chart.cartesianSystem.yAxis.dataSource = (id)self;
    self.chartView.chart.cartesianSystem.zAxis.dataSource = (id)self;
    
    
    self.chartView.chart.cartesianSystem.syAxis.dataSource=(id)self;
    self.chartView.chart.cartesianSystem.sxAxis.dataSource=(id)self;
    
    self.chartView.chart.polarSystem.azimuthAxis.dataSource = (id)self;
    self.chartView.chart.polarSystem.radiusAxis.dataSource = (id)self;
    self.chartView.chart.sizeAxis.dataSource = (id)self;
    self.chartView.chart.cartesianSystem.syAxis.dataSource=(id)self;
    self.chartView.chart.background = [NChartSolidColorBrush solidColorBrushWithColor:kcWidgetBackColor];
    self.chartView.chart.cartesianSystem.xAxis.minTickSpacing = 2.0f;
    self.chartView.chart.cartesianSystem.xAxis.font=[UIFont systemFontOfSize:12];
    [self setupAxesType];
    
//    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                        action:@selector(handleTaps:)];
//    // 手指数
//    self.tapGestureRecognizer.numberOfTouchesRequired = 1;
//    // 连续点击次数
//    self.tapGestureRecognizer.numberOfTapsRequired = 1;
//    // 添加手势识别
//    [self.chartView addGestureRecognizer:self.tapGestureRecognizer];
    
    //[_dataForNChart addObserver:self forKeyPath:@"chartAxisYCaption" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) context:nil];
    

}


//- (void) handleTaps:(UITapGestureRecognizer*)paramSender
//{
//    
//    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(searchButtonClickedWithData: inView:)])
//        
//    {
//        [self.delegate searchButtonClickedWithData:self.dataForNChart inView:self.view];
//        
//    }
//}


-(void)setDataForNChart:(NChartDataModel *)aDataChart
{
    if (aDataChart!=_dataForNChart)
    {
        _dataForNChart=nil;
        _dataForNChart=aDataChart;
//        [_dataForNChart addObserver:self forKeyPath:@"chartDataForDrawing" options:(NSKeyValueObservingOptionNew) context:nil];
        
    }
    
}
-(NChartDataModel*)getDataForNChart
{
    return _dataForNChart;
}
//-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if (([keyPath isEqualToString:@"chartDataForDrawing"])&&[object isKindOfClass: [NChartDataModel class]])
//    {
//        
//        //self.isNeedsUpdate=YES;
//        //[self showSeries];
//    }
//}

-(void) setupAxesType
{}

-(id)initWithDrawingData:(NChartDataModel*)drawingData delegateHolder:(id<ChartSubviewControllerResponse>) delegateImplementer;
{
    if (self=[super init])
    {
        self.dataForNChart=drawingData;
        
        self.delegate=delegateImplementer;
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showSeries];
}
-(void)showSeries
{}

-(void)updateChartData:(AbstractNChartView*)view animated:(BOOL) isAnimated dataModel:(NChartDataModel*)chartData
{
////    //selection 1
//    NChartLineSeries* lineSeries=nil;
//    NSArray* otherSeries=nil;
//    for (NChartSeries* s in view.chart.series)
//    {
//        if ([s isKindOfClass:[NChartLineSeries class]])
//        {
//            lineSeries=(NChartLineSeries*)s;
//            break;
//        }
//        
//        
//    }
//    [view.chart removeSeries:lineSeries];
////
////    /////////////////chart show
////    
////    //option 1
////    [view.chart updateData];
////    if ([[view.chart series] count]>0&&![view.chart isTransitionPlaying])
////        //if ([[view.chart series] count]>0)
////    {
////        //[view.chart resetTransition];
////        [view.chart stopTransition];
////        [view.chart playTransition:kcTRANSITION_TIME reverse:NO];
////        //[self.chartView.chart resetTransformations:kcTRANSITION_TIME];
////        [view.chart flushChanges];
////        
////    }
//    //option 1
//    //option 2
//    NSArray* array= [view.chart.series copy];
//    [view.chart removeAllSeries];
//    for (NChartSeries* s in array)
//    {
//        while ([view.chart isTransitionPlaying]) ;
//        [view.chart addSeries:s];
//        [view.chart updateData];
//        if ([[view.chart series] count]>0&&![view.chart isTransitionPlaying])
//
//        {
//            //[view.chart resetTransition];
//            [view.chart stopTransition];
//            [view.chart playTransition:kcTRANSITION_TIME reverse:NO];
//            //[self.chartView.chart resetTransformations:kcTRANSITION_TIME];
//            [view.chart flushChanges];
//            
//        }
//
//    }
//    //option 2
//    /////////////////chart show
//    if(chartData.floatingNumber!=nil&&[chartData.floatingNumber isKindOfClass:[NSNumber class]])
//        //[self.chartView setTextForMiddleLabel:self.dataForNChart.floatingNumber];
//        [view setTextForMiddleLabel:chartData.floatingNumber animation:isAnimated animationTime:kcTRANSITION_TIME];
//    
//    if (lineSeries!=nil)
//    {
//        while ([view.chart isTransitionPlaying]) ;
//        [view.chart addSeries:lineSeries];
//        [view.chart updateData];
//        if ([[view.chart series] count]>0&&![view.chart isTransitionPlaying])
//            //if ([[view.chart series] count]>0)
//        {
//            //[view.chart resetTransition];
//            [view.chart stopTransition];
//            [view.chart playTransition:kcTRANSITION_TIME reverse:NO];
//            //[self.chartView.chart resetTransformations:kcTRANSITION_TIME];
//            [view.chart flushChanges];
//            
//        }
//        
//    }
//    //selection 1
    
    //selection 2
    
    [view.chart updateData];
    if (isAnimated)
    {
        if ([[view.chart series] count]>0&&![view.chart isTransitionPlaying])
            //if ([[view.chart series] count]>0)
        {
            //[view.chart resetTransition];
            [view.chart stopTransition];
            [view.chart playTransition:kcTRANSITION_TIME reverse:NO];
            //[self.chartView.chart resetTransformations:kcTRANSITION_TIME];
            [view.chart flushChanges];
            
        }
    }
    if(chartData.floatingNumber!=nil&&[chartData.floatingNumber isKindOfClass:[NSNumber class]])

        [view setTextForMiddleLabel:chartData.floatingNumber animation:isAnimated animationTime:kcTRANSITION_TIME];

    
        //selcetion 2


    
    
}




@end
