//
//  SubDetailChartViewController.m
//  E1
//
//  Created by Jack Lin on 2/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "SubDetailChartViewController.h"

@interface SubDetailChartViewController ()

@end

@implementation SubDetailChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NChartColumnSeries* series = [NChartColumnSeries new];
    series.brush = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.4 alpha:1.0]];
    series.dataSource = (id)self;
    [self.chartView.chart addSeries:series];
    NChartColumnSeriesSettings* settings = [[NChartColumnSeriesSettings alloc] init];
    settings.shouldSmoothCylinders = YES;
    [self.chartView.chart addSeriesSettings:settings];
    self.chartView.chart.cartesianSystem.xAxis.dataSource = (id)self;
    self.chartView.chart.cartesianSystem.yAxis.dataSource = (id)self;
    self.chartView.chart.cartesianSystem.zAxis.dataSource = (id)self;
    [self.chartView.chart updateData];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - NChart Data Source
- (NSArray*)seriesDataSourcePointsForSeries:(NChartSeries*)series
{
    NSMutableArray* result = [NSMutableArray array];
    NSArray* keysArray=self.dataForChartView.chartDataForDrawing.allKeys;
    for (NSString* key in keysArray)//for every series
    {
        NSArray* xValues=[[self.dataForChartView.chartDataForDrawing objectForKey:key] chartAxisXValues];
        NSArray* yValues=[[self.dataForChartView.chartDataForDrawing objectForKey:key] chartAxisYValues];
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
    NSArray* keysArray=self.dataForChartView.chartDataForDrawing.allKeys;
    return [keysArray objectAtIndex:series.tag];
    
    
}

- (NSArray *)valueAxisDataSourceTicksForValueAxis:(NChartValueAxis *)axis
{
    // Choose ticks by the kind of axis.
    switch (axis.kind)
    {
        case NChartValueAxisX:
        {
            return self.dataForChartView.chartAxisXTicksValues;
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
            return self.dataForChartView.chartAxisXCaption;
        case NChartValueAxisY:
            return self.dataForChartView.chartAxisYCaption;
        case NChartValueAxisZ:
            return self.dataForChartView.chartAxisZCaption;
            
        default:
            return nil;
    }
}


@end
