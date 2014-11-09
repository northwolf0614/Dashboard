//
//  DoubleNChartWithLabelViewController.m
//  E1
//
//  Created by Jack Lin on 8/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DoubleNChartWithLabelViewController.h"
#import "Definations.h"

@interface DoubleNChartWithLabelViewController ()

@end

@implementation DoubleNChartWithLabelViewController
-(id)initWithDrawingData:(NChartDataModel*)drawingData delegateHolder:(id<ChartSubviewControllerResponse>) delegateImplementer
{
    if (self=[super initWithDrawingData:drawingData delegateHolder:delegateImplementer])
    {
        if (drawingData.dataForNextView!=nil&&[drawingData.dataForNextView isKindOfClass:[NChartDataModel class]]) {
            self.dataForNChartPlus=drawingData.dataForNextView;
        }
        //self.dataForNChartPlus=drawingData.dataForNextView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.dataForNChartPlus!=nil&&[self.dataForNChartPlus isKindOfClass:[NChartDataModel class]]&&self.label!=nil&&[self.label isKindOfClass:[UILabel class]])
    {
        self.chartViewPlus = [[AbstractNChartView alloc] initWithFrame:CGRectZero];
        self.chartViewPlus.chart.licenseKey = kcNchartViewlicense;
        self.chartViewPlus.chart.cartesianSystem.margin = NChartMarginMake(0, 0, 0, 0);
        self.chartViewPlus.chart.shouldAntialias = YES;
        //self.chartView.chart.drawIn3D = YES;
        self.chartViewPlus.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.chartViewPlus];
        self.chartViewPlus.chart.cartesianSystem.xAxis.dataSource = (id)self;
        self.chartViewPlus.chart.cartesianSystem.yAxis.dataSource = (id)self;
        self.chartViewPlus.chart.cartesianSystem.zAxis.dataSource = (id)self;
        
        self.chartViewPlus.chart.cartesianSystem.yAlongX.visible=NO;
        self.chartViewPlus.chart.cartesianSystem.xAlongY.visible=NO;
        self.chartViewPlus.chart.cartesianSystem.borderVisible=NO;
        self.chartViewPlus.chart.cartesianSystem.yAxis.caption.visible=NO;
        self.chartViewPlus.chart.cartesianSystem.yAxis.visible=NO;
        self.chartViewPlus.chart.cartesianSystem.yAxis.labelsVisible=NO;
        
        self.chartViewPlus.chart.cartesianSystem.xAxis.caption.visible=NO;
        self.chartViewPlus.chart.cartesianSystem.xAxis.visible=NO;
        self.chartViewPlus.chart.cartesianSystem.xAxis.labelsVisible=NO;
        self.chartViewPlus.chart.legend.visible=NO;
        
        self.chartViewPlus.chart.background = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor darkGrayColor]];

        NSArray* constraints=[self.contentView constraints];
        if ([constraints count]>0)
        {
            [self.contentView removeConstraints:constraints];
        }


        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartViewPlus]-0-[label(80)]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label,@"chartViewPlus":self.chartViewPlus}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label,@"chartViewPlus":self.chartViewPlus}]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chartViewPlus(==chartView)]-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label,@"chartViewPlus":self.chartViewPlus}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[label(50)]->=0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label,@"chartViewPlus":self.chartViewPlus}]];
        
        [self.titleItem setTitle:self.dataForNChartPlus.chartCaption];
        [self setupSeriesForChartView];
        [self setupAxesType];
        [self.chartViewPlus.chart updateData];
    }


}

-(void) setupSeriesForChartView
{
    [super setupSeriesForChartView];
    if (self.dataForNChartPlus!=nil&&[self.dataForNChartPlus isKindOfClass:[NChartDataModel class]])
    {
    NSArray* keysArray=self.dataForNChartPlus.chartDataForDrawing.allKeys;
    NSUInteger base= [self.dataForNChart.chartDataForDrawing count];
    for (int count=0; count<[keysArray count]; count++)//for every series
    {
            NSString* key=[keysArray objectAtIndex:count];
            NSeriesType seriesType=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:key] seriesType];
            UIColor* brushColor=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:key] brushColor];
            switch (seriesType) {
                case COLUMN:
                {
                    NChartColumnSeries* series = [NChartColumnSeries new];
                    series.tag=count+base;
                    series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                    series.dataSource = (id)self;
                    [self.chartViewPlus.chart addSeries:series];
                }
                    break;
                case LINE:
                {
                    NChartLineSeries* series = [NChartLineSeries new];
                    series.tag=count+base;
                    series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                    series.dataSource = (id)self;
                    [self.chartViewPlus.chart addSeries:series];
                }
                    break;
                case BAR:
                {
                    NChartBarSeries* series = [NChartBarSeries new];
                    series.tag=count+base;
                    series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                    series.dataSource = (id)self;
                    [self.chartViewPlus.chart addSeries:series];
                }
                    break;
                case DOUGHNUT:
                {
                    NChartPieSeries* series = [NChartPieSeries new];
                    series.tag=count+base;
                    series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                    series.dataSource = (id)self;
                    [self.chartViewPlus.chart addSeries:series];
                    NChartPieSeriesSettings *settings = [NChartPieSeriesSettings seriesSettings];
                    settings.holeRatio = 0.8f;
                    [self.chartViewPlus.chart addSeriesSettings:settings];
                    self.chartViewPlus.chart.streamingMode = NO;
                    self.chartViewPlus.chart.timeAxis.visible = NO;
                }
                    break;
                    
                case RADAR:
                {
                    NChartRadarSeries* series = [NChartRadarSeries new];
                    series.tag=count+base;
                    series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                    series.dataSource = (id)self;
                    [self.chartViewPlus.chart addSeries:series];
                    self.chartViewPlus.chart.streamingMode = YES;
                    self.chartViewPlus.chart.timeAxis.visible = NO;
                }
                    break;
                    
                    
                default:
                    break;
            }
            
        }
    }
    
    
    
    
}

-(void)setupAxesType

{
    [super setupAxesType];
    if (self.dataForNChartPlus!=nil&&[self.dataForNChartPlus isKindOfClass:[NChartDataModel class]])
        
        switch (self.dataForNChartPlus.axisType)
        {
            case ABSOLUTE:
                self.chartViewPlus.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
                break;
            case ADDITIVE:
                self.chartViewPlus.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAdditive;
                break;
            case PERCENT:
                self.chartViewPlus.chart.cartesianSystem.valueAxesType = NChartValueAxesTypePercent;
                break;
                
                
            default:
                break;
        }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NChart Data Source
- (NSArray*)seriesDataSourcePointsForSeries:(NChartSeries*)series
{

    NSMutableArray* result = [NSMutableArray array];
    NSUInteger base=[self.dataForNChart.chartDataForDrawing count];
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
    else

    {
        keysArray=self.dataForNChartPlus.chartDataForDrawing.allKeys;
        xValues=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:[keysArray objectAtIndex:(series.tag-base)]] chartAxisXValues];
        yValues=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:[keysArray objectAtIndex:(series.tag-base)]] chartAxisYValues];
        seriesType=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:[keysArray objectAtIndex:(series.tag-base)]] seriesType];
    }
        
//    NSArray* keysArray=self.dataForNChartPlus.chartDataForDrawing.allKeys;
//    NSArray* xValues=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] chartAxisXValues];
//    NSArray* yValues=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] chartAxisYValues];
//    NSeriesType seriesType=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] seriesType];
    //NSArray* zValues=[[self.dataForNChart.chartDataForDrawing objectForKey:key] chartAxisZValues];
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
            state.marker.brush=[NChartSolidColorBrush solidColorBrushWithColor:[UIColor blackColor]];
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
            NSNumber* yValueObject=[yValues objectAtIndex:count];
            double yValueDouble=[yValueObject doubleValue];
            //NSNumber* xValueObject=[xValues objectAtIndex:count];
            //int xValueInt=[xValueObject intValue];
            NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState
                                                             pointStateAlignedToXZWithX:count
                                                             Y:yValueDouble
                                                             Z:self.chartViewPlus.chart.drawIn3D &&
                                                             (self.chartViewPlus.chart.cartesianSystem.valueAxesType ==
                                                              NChartValueAxesTypeAbsolute) ? series.tag : 0]
                                                  forSeries:series];
            
            [result addObject:aPoint];
            
        }
        return result;
        
        
    }
    
    
    return nil;
}

- (NSString*)seriesDataSourceNameForSeries:(NChartSeries*)series
{
    NSArray* keysArray=nil;
    NSUInteger base=[self.dataForNChart.chartDataForDrawing count];
    if (series.tag< [self.dataForNChart.chartDataForDrawing count])
    {
       keysArray=self.dataForNChart.chartDataForDrawing.allKeys;
        return [keysArray objectAtIndex:series.tag];
        
       
    }
    else
    {
        keysArray=self.dataForNChartPlus.chartDataForDrawing.allKeys;
        return [keysArray objectAtIndex:series.tag-base];
        
    }
    
   
    
    
}

- (NSArray *)valueAxisDataSourceTicksForValueAxis:(NChartValueAxis *)axis
{
    // Choose ticks by the kind of axis.
    
    switch (axis.kind)
    {
        case NChartValueAxisX:
        {
            return self.dataForNChartPlus.chartAxisXTicksValues;
        }
            break;
            
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
            return self.dataForNChartPlus.chartAxisXCaption;
        case NChartValueAxisY:
            return self.dataForNChartPlus.chartAxisYCaption;
        case NChartValueAxisZ:
            return self.dataForNChartPlus.chartAxisZCaption;
            
        default:
            return nil;
    }
}

- (float)sizeAxisDataSourceMinSizeForSizeAxis:(NChartSizeAxis *)sizeAxis
{
    // Min size for markers in pixels.
    return 20.0f;
}

- (float)sizeAxisDataSourceMaxSizeForSizeAxis:(NChartSizeAxis *)sizeAxis
{
    // Max size for markers in pixels.
    return 10.0f;
}


@end
