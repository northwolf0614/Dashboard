//
//  ColumnNChartViewController.m
//  E1
//
//  Created by Lei Zhao on 30/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "ColumnNChartViewController.h"

@interface ColumnNChartViewController () <NChartSeriesDataSource>

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
