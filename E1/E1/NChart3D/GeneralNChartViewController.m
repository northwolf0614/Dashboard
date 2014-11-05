//
//  GeneralNChartViewController.m
//  E1
//
//  Created by Jack Lin on 1/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "GeneralNChartViewController.h"
#import  <NChart3D/NChart3D.h>

@interface GeneralNChartViewController ()
-(void) setupSeriesForChartView;
-(void) setupAxesType;

@end

@implementation GeneralNChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.titleItem setTitle:self.dataForNChart.chartCaption];
    [self setupSeriesForChartView];
    [self setupAxesType];
    [self.chartView.chart updateData];
    
}
-(void) setupSeriesForChartView
{
    
    NSArray* keysArray=self.dataForNChart.chartDataForDrawing.allKeys;
    for (int count=0; count<[keysArray count]; count++)//for every series
    {
        NSString* key=[keysArray objectAtIndex:count];
        NSeriesType seriesType=[[self.dataForNChart.chartDataForDrawing objectForKey:key] seriesType];
        UIColor* brushColor=[[self.dataForNChart.chartDataForDrawing objectForKey:key] brushColor];
        switch (seriesType) {
            case COLUMN:
            {
                NChartColumnSeries* series = [NChartColumnSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.dataSource = (id)self;
                [self.chartView.chart addSeries:series];
            }
                break;
            case LINE:
            {
                NChartLineSeries* series = [NChartLineSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.dataSource = (id)self;
                
                //series.marker.shape=NChartMarkerShapeCircle;
                //series.marker.size=1.0f;
                [self.chartView.chart addSeries:series];
            }
                break;
            case BAR:
            {
                NChartBarSeries* series = [NChartBarSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.dataSource = (id)self;
                [self.chartView.chart addSeries:series];
            }
            case DOUGHNUT:
            {
                NChartPieSeries* series = [NChartPieSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.dataSource = (id)self;
                [self.chartView.chart addSeries:series];
                NChartPieSeriesSettings *settings = [NChartPieSeriesSettings seriesSettings];
                settings.holeRatio = 0.8f;
                [self.chartView.chart addSeriesSettings:settings];
                self.chartView.chart.streamingMode = NO;
                self.chartView.chart.timeAxis.visible = NO;
            }
                break;
            
            case RADAR:
            {
                NChartRadarSeries* series = [NChartRadarSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.dataSource = (id)self;
                [self.chartView.chart addSeries:series];
                //NChartPieSeriesSettings *settings = [NChartPieSeriesSettings seriesSettings];
                //settings.holeRatio = 0.5f;
                //[self.chartView.chart addSeriesSettings:settings];
                self.chartView.chart.streamingMode = YES;
                self.chartView.chart.timeAxis.visible = NO;
            }
                break;

                
            default:
                break;
        }
        
    }
    

    
    
}

-(void)setupAxesType

{
    switch (self.dataForNChart.axisType)
    {
        case ABSOLUTE:
            self.chartView.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAbsolute;
            break;
        case ADDITIVE:
            self.chartView.chart.cartesianSystem.valueAxesType = NChartValueAxesTypeAdditive;
            break;
        case PERCENT:
            self.chartView.chart.cartesianSystem.valueAxesType = NChartValueAxesTypePercent;
            break;
        
        
        default:
            break;
    }
}

//

-(void)handleRightButtonItem:(id) sender
{
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(searchButtonClickedWithData:)])
        
    {
        [self.delegate searchButtonClickedWithData:self.dataForNChart];
       
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NChart Data Source
- (NSArray*)seriesDataSourcePointsForSeries:(NChartSeries*)series
{
    NSMutableArray* result = [NSMutableArray array];
    NSArray* keysArray=self.dataForNChart.chartDataForDrawing.allKeys;
    //NSLog(@"this is the name for series: %d",series.tag);
    //else
    
        NSArray* xValues=[[self.dataForNChart.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] chartAxisXValues];
        NSArray* yValues=[[self.dataForNChart.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] chartAxisYValues];
        NSeriesType seriesType=[[self.dataForNChart.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] seriesType];
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
                state.marker.size=1.0f;//maybe not working
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
                                                                 Z:self.chartView.chart.drawIn3D &&
                                                                 (self.chartView.chart.cartesianSystem.valueAxesType ==
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
    NSArray* keysArray=self.dataForNChart.chartDataForDrawing.allKeys;
    return [keysArray objectAtIndex:series.tag];
    
    
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






@end
