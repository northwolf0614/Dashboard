//
//  GerneralChartViewController.m
//  E1
//
//  Created by Jack Lin on 16/01/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import "GerneralChartViewController.h"
#import "Definations.h"
#import "ChartView.h"
#import "NChartDataModel.h"

@interface GerneralChartViewController ()
@property(nonatomic,strong) NChartDataModel* dataForNChart;
@property(nonatomic,strong) Progress* percentageView;
@property(nonatomic,strong) NSArray* chartViews;
@property(nonatomic,strong) UIView* controllerView;
@property(nonatomic,weak) UICollectionView* cv;
@property(nonatomic,strong) NSIndexPath* index;

@end

@implementation GerneralChartViewController
-(void)dealloc
{
    NSLog(@"This is dealloc in GerneralChartViewController");
}
-(id)initWithDrawingData:(NChartDataModel*)drawingData views:(NSArray*)chartViews
{
    NSLog(@"This is initWithDrawingData in GerneralChartViewController");
    if (self=[super init])
    {
        self.dataForNChart=drawingData;
        self.chartViews=chartViews;
        if ([chartViews count]==2) {
            self.chartView=[chartViews objectAtIndex:0];
            self.controllerView=[chartViews objectAtIndex:1];
        }
        if ([chartViews count]==3) {
            
            self.chartView=[chartViews objectAtIndex:0];
            self.percentageView=[chartViews objectAtIndex:1];
            self.controllerView=[chartViews objectAtIndex:2];
        }
        

    }
    return self;
}
-(id)initWithDrawingData:(NChartDataModel*)drawingData views:(NSArray*)chartViews index:(NSIndexPath*)indexPath mainView:(UICollectionView*)view;
{
    if ([self initWithDrawingData:drawingData views:chartViews]!=nil)
    {
        self.index=indexPath;
        self.cv=view;
    }
    return self;
}
-(void)loadView
{
    [super loadView];
    //self.view=self.controllerView;
}
-(void)showCharts:(BOOL)isAnimated
{
    //special for RADAR
    NSMutableDictionary* radarSeriesData=nil;
    if (self.dataForNChart.chartType==RADAR)
    {
        radarSeriesData=self.dataForNChart.chartDataForDrawing;
        self.dataForNChart.chartDataForDrawing=[NChartDataModel radarSeriesData];
        [self.chartView.chart removeAllSeries];
        [self.chartView updateData];
        self.dataForNChart.chartDataForDrawing=radarSeriesData;
        
    }
    //nomal procedure
    [self.percentageView showSeries:isAnimated];
    [self.chartView showSeries:isAnimated];
    if (isAnimated)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (self.chartView.chart.isTransitionPlaying) ;
            if (self.percentageView!=nil)
            {
                while (self.percentageView.isAnimating) ;
            }
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(allAnimationsFinished)])
                {
                    [self.delegate allAnimationsFinished];
                }
                
                
                
                
            });
        });

    }
   
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.view.hidden=YES;
    BOOL isAnimated=!self.dataForNChart.isAnimated;
    if (isAnimated) {
        [self.cv  scrollToItemAtIndexPath:self.index atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        [self showCharts:YES];
        self.dataForNChart.isAnimated=YES;
    }
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"This is viewWillAppear in GerneralChartViewController");
    [super viewWillAppear:animated];
   


    BOOL isAnimated=!self.dataForNChart.isAnimated;
    if (!isAnimated) {
        [self showCharts:NO];
        //self.dataForNChart.isAnimated=YES;
    }
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma <ProgressBarDataSource>
-(NSNumber*)plusChartFloatingNumber:(Progress*) chartView
{
//    if (self.dataForNChart.dataForNextView!=nil)
//    {
//        return self.dataForNChart.dataForNextView.floatingNumber;
//    }
//    else
//        
//        return self.dataForNChart.floatingNumber;
    if ([self.percentageView isEqual:chartView]) {
        return self.dataForNChart.dataForNextView.floatingNumber;
    }
    return nil;
}

-(CGFloat)animationTime:(Progress*) chartView
{
    if ([self.percentageView isEqual:chartView]) {
        return 1;
    }
    return 0.0f;
    
}

-(UIColor*)colorForfirstBar:(Progress*)progressView;
{
    if ([progressView isEqual:self.percentageView]) {
        if (self.dataForNChart.dataForNextView.chartDataForDrawing==nil) {
            return nil;
        }
        NSArray* keysArray=[self.dataForNChart.dataForNextView.chartDataForDrawing allKeys];
        if ([keysArray count]<1) {
            return nil;
        }
        PrototypeDataModel* drawingData=[self.dataForNChart.dataForNextView.chartDataForDrawing objectForKey:[keysArray objectAtIndex:0]];
        return drawingData.brushColor;
    }
    return nil;
    
    
}
-(UIColor*)colorForSecondBar:(Progress*) progressView
{
    if ([progressView isEqual:self.percentageView])
    {
        if (self.dataForNChart.dataForNextView.chartDataForDrawing==nil) {
            return nil;
        }
        NSArray* keysArray=[self.dataForNChart.dataForNextView.chartDataForDrawing allKeys];
        if ([keysArray count]<2) {
            return nil;
        }
        PrototypeDataModel* drawingData=[self.dataForNChart.dataForNextView.chartDataForDrawing objectForKey:[keysArray objectAtIndex:1]];
        return drawingData.brushColor;
    }
    return nil;
    
}
-(NSNumber*)finalPercentage:(Progress*) progressView
{
    if ([progressView isEqual:self.percentageView])
    {
        if (self.dataForNChart.dataForNextView==nil) {
            return nil;
        }
        return self.dataForNChart.dataForNextView.percentage;
    }
    return nil;
    
    
}
-(ProgressType)progressType:(Progress*)progressView
{
    return Circle;
}




#pragma <AbstractNChartViewDelegate>
-(void) setupSeriesForChartView:(SingleChartView*) chartView
{
    
    NSArray* keysArray=self.dataForNChart.chartDataForDrawing.allKeys;
    for (int count=0; count<[keysArray count]; count++)//for every series
    {
        NSString* key=[keysArray objectAtIndex:count];
        NSeriesType seriesType=[[self.dataForNChart.chartDataForDrawing objectForKey:key] seriesType];
        UIColor* brushColor=[[self.dataForNChart.chartDataForDrawing objectForKey:key] brushColor];
        switch (seriesType)
        {
            case COLUMN:
            {
                NChartColumnSeries* series = [NChartColumnSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.dataSource = (id)self;
                [chartView.chart addSeries:series];
                chartView.chart.cartesianSystem.yAlongX.visible=NO;
                chartView.chart.cartesianSystem.xAlongY.visible=NO;
                chartView.chart.cartesianSystem.borderVisible=NO;
                chartView.chart.cartesianSystem.yAxis.caption.visible=NO;
                chartView.chart.cartesianSystem.yAxis.visible=NO;
                chartView.chart.cartesianSystem.yAxis.labelsVisible=NO;
                chartView.chart.cartesianSystem.xAxis.caption.visible=NO;
                chartView.chart.cartesianSystem.xAxis.majorTicks.visible=NO;
                chartView.chart.cartesianSystem.xAxis.minorTicks.visible=NO;
            }
                break;
            case LINE:
            {
                
                NChartLineSeries* series = [NChartLineSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.dataSource = (id)self;
                series.hostsOnSY = YES;
                [chartView.chart addSeries:series];
                
                chartView.chart.cartesianSystem.yAlongX.visible=NO;
                chartView.chart.cartesianSystem.xAlongY.visible=NO;
                chartView.chart.cartesianSystem.borderVisible=NO;
                chartView.chart.cartesianSystem.yAxis.caption.visible=NO;
                chartView.chart.cartesianSystem.yAxis.visible=NO;
                chartView.chart.cartesianSystem.yAxis.labelsVisible=NO;
                chartView.chart.cartesianSystem.xAxis.caption.visible=NO;
                chartView.chart.cartesianSystem.xAxis.majorTicks.visible=NO;
                chartView.chart.cartesianSystem.xAxis.minorTicks.visible=NO;
                chartView.chart.cartesianSystem.syAxis.visible = NO;
                
                
            }
                break;
            case BAR:
            {
                NChartBarSeries* series = [NChartBarSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.dataSource = (id)self;
                [chartView.chart addSeries:series];
                
                chartView.chart.cartesianSystem.yAlongX.visible=NO;
                chartView.chart.cartesianSystem.xAlongY.visible=NO;
                chartView.chart.cartesianSystem.borderVisible=NO;
                chartView.chart.cartesianSystem.yAxis.caption.visible=NO;
                chartView.chart.cartesianSystem.yAxis.visible=NO;
                chartView.chart.cartesianSystem.yAxis.labelsVisible=NO;
                chartView.chart.cartesianSystem.xAxis.caption.visible=NO;
                chartView.chart.cartesianSystem.xAxis.visible=NO;
                chartView.chart.cartesianSystem.xAxis.labelsVisible=NO;
                
                
            }
                break;
            case DOUGHNUT:
            {
                NChartPieSeries* series = [NChartPieSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.dataSource = (id)self;
                [chartView.chart addSeries:series];
                NChartPieSeriesSettings *settings = [NChartPieSeriesSettings seriesSettings];
                //settings.centerCaption=@"center";
                
                settings.holeRatio = 0.8f;
                [chartView.chart addSeriesSettings:settings];
                chartView.chart.streamingMode = NO;
                chartView.chart.timeAxis.visible = NO;
                //[self updateChartData:chartView animated:YES];
            }
                break;
                
            case RADAR:
            {
                NChartRadarSeries* series = [NChartRadarSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.brush.opacity=0.8f;
                series.dataSource = (id)self;
                [chartView.chart addSeries:series];
                
                chartView.chart.timeAxis.visible = NO;
                chartView.chart.polarSystem.borderColor = nil;
                chartView.chart.polarSystem.radiusAxis.labelsVisible=NO;
                chartView.chart.polarSystem.radiusAxis.visible=NO;
                chartView.chart.polarSystem.radiusAxis.caption.visible=NO;
                chartView.chart.polarSystem.azimuthAxis.caption.visible=NO;
                //chartView.chart.polarSystem.azimuthAxis.visible=NO;
                //chartView.chart.polarSystem.azimuthAxis.labelsVisible=NO;
                chartView.chart.polarSystem.azimuthAxis.textColor=kcCharColor;
                //[self updateChartData:chartView animated:YES];
                chartView.chart.streamingMode = NO;
                NChartRadarSeriesSettings *settings = [NChartRadarSeriesSettings seriesSettings];
                settings.shouldSmoothAxesGrid = NO;
                [chartView.chart addSeriesSettings:settings];
                chartView.chart.polarSystem.grid.visible=NO;
                //chartView.chart.polarSystem.b=NO;
                
                
                
                
                
                
            }
                break;
            case AREA:
            {
                NChartAreaSeries* series = [NChartAreaSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.brush.opacity =  0.6f;
                series.dataSource = (id)self;
                series.dataSmoother=nil;
                
                //series.hostsOnSY = YES;
                [chartView.chart addSeries:series];
                
                chartView.chart.cartesianSystem.yAlongX.visible=NO;
                chartView.chart.cartesianSystem.xAlongY.visible=NO;
                chartView.chart.cartesianSystem.borderVisible=NO;
                chartView.chart.cartesianSystem.yAxis.caption.visible=NO;
                chartView.chart.cartesianSystem.yAxis.visible=NO;
                chartView.chart.cartesianSystem.yAxis.labelsVisible=NO;
                chartView.chart.cartesianSystem.xAxis.caption.visible=NO;
                chartView.chart.cartesianSystem.xAxis.majorTicks.visible=NO;
                chartView.chart.cartesianSystem.xAxis.minorTicks.visible=NO;
                chartView.chart.streamingMode=NO;
                
            }
                break;
                
            default:
                break;
        }
        
    }
}






-(void) setupAxesTypeForView:(SingleChartView*) chartView

{
    switch (self.dataForNChart.axisType)
    {
        case ABSOLUTE:
            chartView.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
            break;
        case ADDITIVE:
            chartView.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAdditive;
            break;
        case PERCENT:
            chartView.chart.cartesianSystem.valueAxesType = NChartValueAxesTypePercent;
            break;
            
            
        default:
            break;
    }
}

-(NSNumber*)mainChartFloatingNumber:(ChartView*) chartView
{
    if ([self.chartView isEqual:chartView]) {
        return self.dataForNChart.floatingNumber;
    }
    return nil;
    
}

-(float) mainChartFloatingNumberAnimationtime:(ChartView*) chartView
{
    if ([self.chartView isEqual:chartView])
        return 1.0f;
    return 0.0f;
    
}

#pragma mark - NChart Data Source
- (NSArray*)seriesDataSourcePointsForSeries:(NChartSeries*)series
{
    
    NSMutableArray* result = [NSMutableArray array];
    //NSUInteger base=[self.dataForNChart.chartDataForDrawing count];
    //NSLog(@"series data source  is %@",[series.dataSource class]);
    NSArray* keysArray=nil;
    NSArray* xValues=nil;
    NSArray* yValues=nil;
    NSeriesType seriesType;
    if (series.tag< [self.dataForNChart.chartDataForDrawing count])
        //if (![series.dataSource isKindOfClass:[DoubleNChartWithLabelViewController class]])
    {
        keysArray=self.dataForNChart.chartDataForDrawing.allKeys;
        xValues=[[self.dataForNChart.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] chartAxisXValues];
        yValues=[[self.dataForNChart.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] chartAxisYValues];
        seriesType=[[self.dataForNChart.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] seriesType];
    }
//    else
//        
//    {
//        keysArray=self.dataForNChartPlus.chartDataForDrawing.allKeys;
//        xValues=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:[keysArray objectAtIndex:(series.tag-base)]] chartAxisXValues];
//        yValues=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:[keysArray objectAtIndex:(series.tag-base)]] chartAxisYValues];
//        seriesType=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:[keysArray objectAtIndex:(series.tag-base)]] seriesType];
//    }
    if (seriesType==LINE)
    {
        for (int count=0;count<[xValues count];count++)
        {
            NSNumber* yValueObject=[yValues objectAtIndex:count];
            double yValueDouble=[yValueObject doubleValue];
            NSNumber* xValueObject=[xValues objectAtIndex:count];
            int xValueInt=[xValueObject intValue];
            NChartPointState *state = [NChartPointState pointStateAlignedToXWithX:xValueInt Y:yValueDouble];
            state.marker = [NChartMarker new] ;
            state.marker.shape = NChartMarkerShapeCircle;
            state.marker.brush=[NChartSolidColorBrush solidColorBrushWithColor:kcLikeRed];
            //state.marker.size=1.0f;//maybe not working
            [result addObject:[NChartPoint pointWithState:state forSeries:series]];
        }
        return result;
        
    }
    else if (seriesType==COLUMN)
    {
        for (int count=0;count<[xValues count];count++)
        {
            NSNumber* yValueObject=[yValues objectAtIndex:count];
            double yValueDouble=[yValueObject doubleValue];
            NSNumber* xValueObject=[xValues objectAtIndex:count];
            int xValueInt=[xValueObject intValue];
            NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState pointStateAlignedToXWithX:xValueInt Y:yValueDouble] forSeries:series];
            [result addObject:aPoint];
            
            
        }
        return result;
        
        
    }
    else if (seriesType==BAR)
    {
        for (int count=0;count<[xValues count];count++)
        {
            NSNumber* xValueObject=[xValues objectAtIndex:count];
            double xValueDouble=[xValueObject doubleValue];
            NSNumber* yValueObject=[yValues objectAtIndex:count];
            int yValueInt=[yValueObject intValue];
            NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState pointStateAlignedToYWithX:xValueDouble Y:yValueInt] forSeries:series];
            [result addObject:aPoint];
            
            
        }
        return result;
        
        
    }
    else if (seriesType==DOUGHNUT)
    {
        for (int count=0;count<[xValues count];count++)
        {
            NSNumber* yValueObject=[yValues objectAtIndex:count];
            double yValueDouble=[yValueObject doubleValue];
            //NSNumber* xValueObject=[xValues objectAtIndex:count];
            //int xValueInt=[xValueObject intValue];
            NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState pointStateWithCircle:count value:yValueDouble] forSeries:series ];
            [result addObject:aPoint];
            
        }
        return result;
        
        
    }
    
    else if (seriesType==RADAR)
    {
        for (int count=0;count<[xValues count];count++)
        {
            NSNumber* xValueObject=[xValues objectAtIndex:count];
            double xValueInt=[xValueObject intValue];
            
            NSNumber* yValueObject=[yValues objectAtIndex:count];
            double yValueDouble=[yValueObject doubleValue];
            //NSNumber* xValueObject=[xValues objectAtIndex:count];
            //int xValueInt=[xValueObject intValue];
            NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState
                                                             pointStateAlignedToXZWithX:xValueInt
                                                             Y:yValueDouble
//                                                             Z:chartViewPlus.chart.drawIn3D &&
//                                                             (chartViewPlus.chart.cartesianSystem.valueAxesType ==
//                                                              NChartValueAxesTypeAbsolute) ? series.tag : 0
                                                             Z:0
                                                             ]
                                                  forSeries:series];
            
            [result addObject:aPoint];
            
        }
        return result;
        
        
    }
    else if (seriesType==AREA)
    {
        for (int count=0;count<[xValues count];count++)
        {
            NSNumber* yValueObject=[yValues objectAtIndex:count];
            double yValueDouble=[yValueObject doubleValue];
            NSNumber* xValueObject=[xValues objectAtIndex:count];
            int xValueInt=[xValueObject intValue];
            NChartPointState *state = [NChartPointState pointStateAlignedToXWithX:xValueInt Y:yValueDouble];
            //state.marker = [NChartMarker new] ;
            //state.marker.shape = NChartMarkerShapeCircle;
            //state.marker.brush=[NChartSolidColorBrush solidColorBrushWithColor:kcLikeRed];
            //state.marker.size=1.0f;//maybe not working
            [result addObject:[NChartPoint pointWithState:state forSeries:series]];
        }
        return result;
        
    }
    
    
    return nil;
}

- (NSString*)seriesDataSourceNameForSeries:(NChartSeries*)series
{
    NSArray* keysArray=nil;
    //NSUInteger base=[self.dataForNChart.chartDataForDrawing count];
    //if (series.tag< [self.dataForNChart.chartDataForDrawing count])
    {
        keysArray=self.dataForNChart.chartDataForDrawing.allKeys;
        return [keysArray objectAtIndex:series.tag];
        
        
    }
//    else
//    {
//        keysArray=self.dataForNChartPlus.chartDataForDrawing.allKeys;
//        return [keysArray objectAtIndex:series.tag-base];
//        
//    }
    
    
    
    
}

- (NSArray *)valueAxisDataSourceTicksForValueAxis:(NChartValueAxis *)axis
{
    // Choose ticks by the kind of axis.
    
    switch (axis.kind)
    {
            
        case NChartValueAxisX:
        {
            return self.dataForNChart.chartAxisXTicksValues;
        }
            break;
        case NChartValueAxisY:
        {
            
            if (self.dataForNChart.chartType == BAR)
                //NSArray* value=self.dataForNChart.chartAxisYTicksValues;
                return self.dataForNChart.chartAxisYTicksValues;
            
            else
                return nil;
        }
        case NChartValueAxisAzimuth:
            if (self.dataForNChart.chartType == RADAR)
                return self.dataForNChart.chartAxisXTicksValues;
            else
                return nil;
        case NChartValueAxisRadius:
            return nil;
        default:
            // Other axes have no ticks.
            return nil;
    }
}



- (NSString *)valueAxisDataSourceNameForAxis:(NChartValueAxis *)axis
{
    switch (axis.kind)
    {
        case NChartValueAxisX:
            return self.dataForNChart.chartAxisXCaption;
        case NChartValueAxisY:
            return self.dataForNChart.chartAxisYCaption;
        case NChartValueAxisZ:
            return self.dataForNChart.chartAxisZCaption;
            
        default:
            return nil;
    }
}

- (float)sizeAxisDataSourceMinSizeForSizeAxis:(NChartSizeAxis *)sizeAxis
{
    // Min size for markers in pixels.
    return kcMinmumMarkSize;
}

- (float)sizeAxisDataSourceMaxSizeForSizeAxis:(NChartSizeAxis *)sizeAxis
{
    // Max size for markers in pixels.
    return kcMaximumMarkSize;
}

- (NSNumber *)valueAxisDataSourceMinForValueAxis:(NChartValueAxis *)axis
{
    switch (axis.kind) {
        case NChartValueAxisRadius:
            return [NSNumber numberWithFloat:0.0f];
            break;
        case NChartValueAxisSY:
            return [NSNumber numberWithFloat:0.0f];
            break;
        case NChartValueAxisY:
            return [NSNumber numberWithFloat:0.0f];
            break;
            
        default:
            return nil;
            break;
    }
}
- (NSNumber *)valueAxisDataSourceMaxForValueAxis:(NChartValueAxis *)axis
{
    switch (axis.kind)
    {
        case NChartValueAxisRadius:
            return [NSNumber numberWithFloat:1.0f];
            break;
            
        case NChartValueAxisSY:
            return [NSNumber numberWithFloat:1.0f];
            break;
        case NChartValueAxisY:
            return [NSNumber numberWithFloat:1.0f];
            break;
            
        default:
            return nil;
            break;
    }
}











@end
