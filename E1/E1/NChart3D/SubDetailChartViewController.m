//
//  SubDetailChartViewController.m
//  E1
//
//  Created by Jack Lin on 2/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "SubDetailChartViewController.h"

@interface SubDetailChartViewController ()
-(void) setupSeriesForChartView;
-(void)setupAxesType;
@end

@implementation SubDetailChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSeriesForChartView];
    [self setupAxesType];
    [self.chartView.chart updateData];

}

-(void) setupSeriesForChartView
{
    
    NSArray* keysArray=self.dataForChartView.chartDataForDrawing.allKeys;
    for (int count=0; count<[keysArray count]; count++)
    {
        NSString* key=[keysArray objectAtIndex:count];
        NSeriesType seriesType=[[self.dataForChartView.chartDataForDrawing objectForKey:key] seriesType];
        UIColor* brushColor=[[self.dataForChartView.chartDataForDrawing objectForKey:key] brushColor];
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
                
            default:
                break;
        }
        
    }
    
    
    
    
}

-(void)setupAxesType

{
    switch (self.dataForChartView.axisType)
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - NChart Data Source
- (NSArray*)seriesDataSourcePointsForSeries:(NChartSeries*)series
{
    NSMutableArray* result = [NSMutableArray array];
    NSArray* keysArray=self.dataForChartView.chartDataForDrawing.allKeys;
    //for (NSString* key in keysArray)//for every series
    NSLog(@"this is the name for series: %d",series.tag);
    //else
    {
        NSArray* xValues=[[self.dataForChartView.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] chartAxisXValues];
        NSArray* yValues=[[self.dataForChartView.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] chartAxisYValues];
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
        return result;
    }
    //return result;

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
