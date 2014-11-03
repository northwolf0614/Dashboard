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
@end

@implementation GeneralNChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.titleItem setTitle:@"Column"];
    //config column series
    /*
    NChartColumnSeries* series = [NChartColumnSeries new];
    series.brush = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.4 alpha:1.0]];
    series.dataSource = (id)self;
    [self.chartView.chart addSeries:series];
     */
    [self setupSeriesForChartView];
    //config column series setting
    //NChartColumnSeriesSettings* settings = [[NChartColumnSeriesSettings alloc] init];
    //settings.shouldSmoothCylinders = YES;
    //[self.chartView.chart addSeriesSettings:settings];
    
    //self.chartView.chart.cartesianSystem.xAxis.dataSource = self;
    //self.chartView.chart.cartesianSystem.yAxis.dataSource = self;
    //self.chartView.chart.cartesianSystem.zAxis.dataSource = self;
    
    
    [self.chartView.chart updateData];
}
-(void) setupSeriesForChartView
{
    NSArray* keysArray=self.dataForNChart.chartDataForDrawing.allKeys;
    for (NSString* key in keysArray)//for every series
    {
        NSeriesType seriesType=[[self.dataForNChart.chartDataForDrawing objectForKey:key] seriesType];
        switch (seriesType) {
            case COLUMN:
            {
                NChartColumnSeries* series = [NChartColumnSeries new];
                series.brush = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.4 alpha:1.0]];
                series.dataSource = (id)self;
                [self.chartView.chart addSeries:series];
            }
                break;
                
            default:
                break;
        }
        
    }

    
}

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
    for (NSString* key in keysArray)//for every series
    {
        NSArray* xValues=[[self.dataForNChart.chartDataForDrawing objectForKey:key] chartAxisXValues];
        NSArray* yValues=[[self.dataForNChart.chartDataForDrawing objectForKey:key] chartAxisYValues];
        //NSArray* zValues=[[self.dataForNChart.chartDataForDrawing objectForKey:key] chartAxisZValues];
        
        for (int count=0;count<[xValues count];count++)
        {
            NSNumber* yValueObject=[yValues objectAtIndex:count];
            double yValueDouble=[yValueObject doubleValue];
            NSNumber* xValueObject=[xValues objectAtIndex:count];
            int xValueInt=[xValueObject intValue];
            NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState pointStateAlignedToXWithX:xValueInt Y:yValueDouble] forSeries:series];
            [result addObject:aPoint];
        }
    }
    return result;
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
