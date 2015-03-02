//
//  ChildDetailChartViewController.m
//  E1
//
//  Created by Jack Lin on 18/02/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import "ChildDetailChartViewController.h"
#import "Definations.h"

@interface ChildDetailChartViewController ()

@property(nonatomic,strong) NSArray* chartViews;
@property(nonatomic,strong) NChartDataModel* dataForNChart;
@property(nonatomic,assign) BOOL isAdded;

@property(nonatomic,strong) SingleChartView* chartView;
@property(nonatomic,strong) Progress* percentageView;

@property(nonatomic,strong) NSNumber* percent;
@property(nonatomic,strong) UILabel* yearLabel;

@end

@implementation ChildDetailChartViewController
-(void)dealloc
{
    NSLog(@"This is dealloc in GerneralChartViewController");
}
-(id)initWithDrawingData:(NChartDataModel*)drawingData views:(NSArray*)chartViews isAddedChart:(BOOL)isAdded
{
    NSLog(@"This is initWithDrawingData in GerneralChartViewController");
    if (self=[super init])
    {
        self.dataForNChart=drawingData;
        self.chartViews=chartViews;
        self.isAdded=isAdded;
        
        if ([chartViews count]==1) {
            self.chartView=[chartViews objectAtIndex:0];
            //self.controllerView=[chartViews objectAtIndex:1];
        }
        if ([chartViews count]==2) {
            
            self.chartView=[chartViews objectAtIndex:0];
            self.percentageView=[chartViews objectAtIndex:1];
            //self.controllerView=[chartViews objectAtIndex:2];
        }

        
        
    }
    return self;
}

-(void)showCharts:(BOOL)isAnimated
{

    //special for RADAR
    //NSMutableDictionary* radarSeriesData=nil;
//    if (self.dataForNChart.chartType==RADAR)
//    {
//        radarSeriesData=self.dataForNChart.chartDataForDrawing;
//        self.dataForNChart.chartDataForDrawing=[NChartDataModel radarSeriesData];
//        [self.chartView.chart removeAllSeries];
//        [self.chartView updateData];
//        self.dataForNChart.chartDataForDrawing=radarSeriesData;
//        
//    }
    //nomal procedure
    [self.percentageView showSeries:isAnimated];
    [self.chartView showSeries:isAnimated];

    
    
    
    
    
    
    

    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.hidden=YES;
//    BOOL isAnimated=!self.dataForNChart.isAnimated;
//    if (isAnimated)
//    {
//        [self showCharts:YES];
//        self.dataForNChart.isAnimated=YES;
//    }
//    else
//        [self showCharts:NO];
    
    [self showCharts:YES];
    
    
    
    
    
}




#pragma <ProgressBarDataSource>
-(NSNumber*)plusChartFloatingNumber:(Progress*) chartView
{
    if (!self.isAdded)
    {
        if ([self.percentageView isEqual:chartView])
            return self.dataForNChart.dataForNextView.floatingNumber;
        return nil;
    }
    else
    {
        if ([self.percentageView isEqual:chartView])
        {
            if (self.dataForNChart.chartType==COLUMN)
            {
                int x = arc4random() % 100;
                NSNumber* num=[NSNumber numberWithFloat:x];
                self.dataForNChart.dataForNextView.floatingNumber=num;
                return num;
            }
            if (self.dataForNChart.chartType==AREA) {
                self.dataForNChart.dataForNextView.floatingNumber=self.percent;
                return self.percent;
            }
        }
        else
            return nil;
    }
    return nil;
}

-(CGFloat)animationTime:(Progress*) chartView
{
    if ([self.percentageView isEqual:chartView]) {
        return kcTRANSITION_TIME;
    }
    return 0.0f;
    
    
}

-(UIColor*)colorForfirstBar:(Progress*)progressView;
{
    if (!self.isAdded)
    {
        if ([progressView isEqual:self.percentageView])
        {
            return self.dataForNChart.dataForNextView.color1;
            
        }
        else
            
            return nil;
    }
    else
    {
        if ([progressView isEqual:self.percentageView])
        {
            self.dataForNChart.dataForNextView.color1=kcLikeBlue;
            return kcLikeBlue;
        }
        else
            return nil;
        
        
    }
   

    
    
}
-(UIColor*)colorForSecondBar:(Progress*) progressView
{
    if (!self.isAdded) {
        if ([progressView isEqual:self.percentageView])
        {
            return self.dataForNChart.dataForNextView.color2;
            
        }
        else
            
            return nil;
    }
   
    else
    {
        if ([progressView isEqual:self.percentageView])
        {
            self.dataForNChart.dataForNextView.color1=kcLikeRed;
            return kcLikeRed;
        }
        else
            return nil;
        
        
    }
    
    
}
-(NSNumber*)finalPercentage:(Progress*) progressView
{
    if (!self.isAdded)
    {
        if ([progressView isEqual:self.percentageView])
        {
            if (self.dataForNChart.dataForNextView==nil) {
                return nil;
            }
            else
                return self.dataForNChart.dataForNextView.percentage;
        }
        return nil;
    }
    else
    {
        if ([progressView isEqual:self.percentageView])
        {
            float percent = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
            NSNumber* per=[NSNumber numberWithFloat:percent];
            self.percent=per;
            self.dataForNChart.dataForNextView.percentage=per;
            return per;
        }
        else
            return nil;
        
    }
    
    
    
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
                //chartView.chart.cartesianSystem.yAxis.visible=NO;
                //chartView.chart.cartesianSystem.yAxis.labelsVisible=NO;
                chartView.chart.cartesianSystem.yAxis.majorTicks.visible=NO;
                chartView.chart.cartesianSystem.yAxis.minorTicks.visible=NO;
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
                //chartView.chart.cartesianSystem.yAxis.visible=NO;
                //chartView.chart.cartesianSystem.yAxis.labelsVisible=NO;
                chartView.chart.cartesianSystem.yAxis.majorTicks.visible=NO;
                chartView.chart.cartesianSystem.yAxis.minorTicks.visible=NO;
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
                //chartView.chart.cartesianSystem.yAxis.visible=NO;
                //chartView.chart.cartesianSystem.yAxis.labelsVisible=NO;
                chartView.chart.cartesianSystem.yAxis.majorTicks.visible=NO;
                chartView.chart.cartesianSystem.yAxis.minorTicks.visible=NO;
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

    if (!self.isAdded)
    {
        if ([self.chartView isEqual:chartView])
        {
            return self.dataForNChart.floatingNumber;
        }
        return nil;
    }
    else
    {
        if ([self.chartView isEqual:chartView])
        {
            int x = arc4random() % 100;
            NSNumber* num=[NSNumber numberWithFloat:x];
            self.dataForNChart.floatingNumber=num;
            return num;
        }
        else
            return  nil;
        
    }
    
    
}

-(float) mainChartFloatingNumberAnimationtime:(ChartView*) chartView
{
    if ([self.chartView isEqual:chartView])
        return kcTRANSITION_TIME;
    return 0.0f;
    
}

#pragma mark - NChart Data Source
- (NSString*)seriesDataSourceNameForSeries:(NChartSeries*)series
{
    NSArray* keysArray=nil;
    keysArray=self.dataForNChart.chartDataForDrawing.allKeys;
    return [keysArray objectAtIndex:series.tag];
}

- (NSArray *)valueAxisDataSourceTicksForValueAxis:(NChartValueAxis *)axis
{
    // Choose ticks by the kind of axis.
    
    switch (axis.kind)
    {
            
        case NChartValueAxisX:
        {
            if (self.dataForNChart.chartAxisXTicksValues.count==0) {
                return nil;
            }
            return self.dataForNChart.chartAxisXTicksValues;
        }
            break;
        case NChartValueAxisY:
        {
            if (self.dataForNChart.chartAxisYTicksValues.count==0)
            {
                return nil;
            }
            return self.dataForNChart.chartAxisYTicksValues;
        }
            break;
            
            
        case NChartValueAxisAzimuth:
            if (self.dataForNChart.chartType == RADAR)
            {
                if (self.dataForNChart.chartAxisXTicksValues.count==0) {
                    return nil;
                }
                
                return self.dataForNChart.chartAxisXTicksValues;
            }
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
    
    
    keysArray=self.dataForNChart.chartDataForDrawing.allKeys;
    xValues=[[self.dataForNChart.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] chartAxisXValues];
    yValues=[[self.dataForNChart.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] chartAxisYValues];
    seriesType=[[self.dataForNChart.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] seriesType];
    
    
    if (seriesType==LINE)
    {
        if (!self.isAdded)
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
        else
        {
            NSMutableArray* yVals=[NSMutableArray array];//
            for (int count=0;count<[xValues count];count++)
            {
                
                double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
                NChartPointState *state = [NChartPointState pointStateAlignedToXWithX:count Y:val];
                state.marker = [NChartMarker new] ;
                state.marker.shape = NChartMarkerShapeCircle;
                state.marker.brush=[NChartSolidColorBrush solidColorBrushWithColor:kcLikeRed];
                //state.marker.size=1.0f;//maybe not working
                
                [yVals addObject:[NSNumber numberWithDouble:val]];//
                [result addObject:[NChartPoint pointWithState:state forSeries:series]];
                
                
                
                
            }
            
            NSArray* keys=[self.dataForNChart.chartDataForDrawing allKeys];
            PrototypeDataModel* rawData=[self.dataForNChart.chartDataForDrawing objectForKey:[keys objectAtIndex:series.tag]];//
            rawData.chartAxisYValues=[yVals copy];//
            [self.dataForNChart.chartDataForDrawing setObject:rawData forKey:[keys objectAtIndex:series.tag]];
            
            return result;
            
        }
        
        
    }
    else if (seriesType==COLUMN)
    {
        if (!self.isAdded)
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
        
        else
        {
            NSMutableArray* yVals=[NSMutableArray array];//
            for (int count=0;count<[xValues count];count++)
            {
                double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
                NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState pointStateAlignedToXWithX:count Y:val] forSeries:series];
                [yVals addObject:[NSNumber numberWithDouble:val]];//
                [result addObject:aPoint];
                //NSLog(@"the double number is %f",val);
                
                
            }
            NSArray* keys=[self.dataForNChart.chartDataForDrawing allKeys];
            PrototypeDataModel* rawData=[self.dataForNChart.chartDataForDrawing objectForKey:[keys objectAtIndex:series.tag]];//
            rawData.chartAxisYValues=[yVals copy];//
            [self.dataForNChart.chartDataForDrawing setObject:rawData forKey:[keys objectAtIndex:series.tag]];
            
            return result;
        }
    }
    else if (seriesType==BAR)
    {
        if (!self.isAdded)
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
        else
        {   NSMutableArray* xVals=[NSMutableArray array];//
            for (int count=0;count<[yValues count];count++)
            {
                double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
                NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState pointStateAlignedToYWithX:val Y:count] forSeries:series];
                [xVals addObject:[NSNumber numberWithDouble:val]];//
                [result addObject:aPoint];
                
                
            }
            NSArray* keys=[self.dataForNChart.chartDataForDrawing allKeys];
            PrototypeDataModel* rawData=[self.dataForNChart.chartDataForDrawing objectForKey:[keys objectAtIndex:series.tag]];//
            rawData.chartAxisXValues=[xVals copy];//
            [self.dataForNChart.chartDataForDrawing setObject:rawData forKey:[keys objectAtIndex:series.tag]];
            return result;
            
        }
    }

    
    else if (seriesType==RADAR)
    {
        if (!self.isAdded)
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
                                                                     Z: 0]
                                                          forSeries:series];

                    [result addObject:aPoint];

                }
                return result;
            }
        
                    
        
        
        
        else
        {
            NSMutableArray* yVals=[NSMutableArray array];//
            for (int count=0;count<[xValues count];count++)
            {
                
                double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
                NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState
                                                                 pointStateAlignedToXZWithX:count
                                                                 Y:val
                                                                 Z: 0]
                                                      forSeries:series];
                
                [result addObject:aPoint];
                [yVals addObject:[NSNumber numberWithDouble:val]];//
                
            }
            NSArray* keys=[self.dataForNChart.chartDataForDrawing allKeys];
            PrototypeDataModel* rawData=[self.dataForNChart.chartDataForDrawing objectForKey:[keys objectAtIndex:series.tag]];//
            rawData.chartAxisYValues=[yVals copy];//
            [self.dataForNChart.chartDataForDrawing setObject:rawData forKey:[keys objectAtIndex:series.tag]];
            return result;
            
        }
    }
    if (seriesType==AREA)
    {
        if (!self.isAdded)
        {
            
        
            for (int count=0;count<[xValues count];count++)
            {
                NSNumber* yValueObject=[yValues objectAtIndex:count];
                double yValueDouble=[yValueObject doubleValue];
                NSNumber* xValueObject=[xValues objectAtIndex:count];
                int xValueInt=[xValueObject intValue];
                NChartPointState *state = [NChartPointState pointStateAlignedToXWithX:xValueInt Y:yValueDouble];
//                state.marker = [NChartMarker new] ;
//                state.marker.shape = NChartMarkerShapeCircle;
//                state.marker.brush=[NChartSolidColorBrush solidColorBrushWithColor:kcLikeRed];
//                state.marker.size=1.0f;//maybe not working
                [result addObject:[NChartPoint pointWithState:state forSeries:series]];



            }
            return result;
        }
        
                    
        
        else
        {
            NSMutableArray* yVals=[NSMutableArray array];//
            for (int count=0;count<[xValues count];count++)
            {
                
                double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
                NChartPointState *state = [NChartPointState pointStateAlignedToXWithX:count Y:val];
                //state.marker = [NChartMarker new] ;
                //state.marker.shape = NChartMarkerShapeCircle;
                //state.marker.brush=[NChartSolidColorBrush solidColorBrushWithColor:kcLikeRed];
                //state.marker.size=1.0f;//maybe not working
                
                [yVals addObject:[NSNumber numberWithDouble:val]];//
                [result addObject:[NChartPoint pointWithState:state forSeries:series]];
                
                
                
                
            }
            
            NSArray* keys=[self.dataForNChart.chartDataForDrawing allKeys];
            PrototypeDataModel* rawData=[self.dataForNChart.chartDataForDrawing objectForKey:[keys objectAtIndex:series.tag]];//
            rawData.chartAxisYValues=[yVals copy];//
            [self.dataForNChart.chartDataForDrawing setObject:rawData forKey:[keys objectAtIndex:series.tag]];
            
            return result;
            
        }
        
        
    }
    
    
    return nil;
    
    
}

@end
