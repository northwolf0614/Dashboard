//
//  ColumnNChartViewController.m
//  E1
//
//  Created by Lei Zhao on 30/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "ColumnNChartViewController.h"

@interface ColumnNChartViewController () <NChartSeriesDataSource>
//@property(nonatomic,strong) NChartColumn* columnChartData;
@end

@implementation ColumnNChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.titleItem setTitle:@"Column"];
    
    NChartColumnSeries* series = [NChartColumnSeries new];
    series.brush = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.4 alpha:1.0]];
    series.dataSource = self;
    [self.chartView.chart addSeries:series];

    NChartColumnSeriesSettings* settings = [[NChartColumnSeriesSettings alloc] init];
    settings.shouldSmoothCylinders = YES;
    [self.chartView.chart addSeriesSettings:settings];
    
    [self.chartView.chart updateData];
}
-(void) setupData
{
    //self.columnChartData= [[NChartColumn alloc] init];
    
    
    
    
    
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
    for (int i = 0; i <= 10; ++i) {
        [result addObject:[NChartPoint pointWithState:[NChartPointState pointStateAlignedToXWithX:i Y:(rand() % 30) + 1]
                                            forSeries:series]];
    }
    return result;
}

- (NSString*)seriesDataSourceNameForSeries:(NChartSeries*)series
{
    return @"Just a Test";
}





@end
