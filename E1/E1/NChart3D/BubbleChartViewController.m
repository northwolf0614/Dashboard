//
//  BubbleChartViewController.m
//  E1
//
//  Created by Jack Lin on 30/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "BubbleChartViewController.h"

@interface BubbleChartViewController ()

@end

@implementation BubbleChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleItem setTitle:@"Bubble"];
    
    // Create a chart view that will display the chart.
    NChartView* m_view = self.chartView;
    
    // Paste your license key here.
    //m_view.chart.licenseKey = @"";
    
    // Margin to ensure some free space for iOS status bar.
    m_view.chart.cartesianSystem.margin = NChartMarginMake(10.0f, 10.0f, 10.0f, 20.0f);
    
    // Create brushes.
    self.brushes = [NSMutableArray array];
    [self.brushes addObject:[NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0.38f green:0.8f blue:0.91f alpha:1.0f]]];
    [self.brushes addObject:[NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0.8f green:0.86f blue:0.22f alpha:1.0f]]];
    [self.brushes addObject:[NChartSolidColorBrush solidColorBrushWithColor:[UIColor colorWithRed:0.9f green:0.29f blue:0.51f alpha:1.0f]]];
    
    // Set up the time axis.
    m_view.chart.timeAxis.tickShape = NChartTimeAxisTickShapeLine;
    m_view.chart.timeAxis.tickTitlesFont = [UIFont boldSystemFontOfSize:11.0f];
    m_view.chart.timeAxis.tickTitlesLayout = NChartTimeAxisShowFirstLastLabelsOnly;
    m_view.chart.timeAxis.tickTitlesPosition = NChartTimeAxisLabelsBeneath;
    m_view.chart.timeAxis.tickTitlesColor = [UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.0f];
    m_view.chart.timeAxis.tickColor = [UIColor colorWithRed:0.43f green:0.43f blue:0.43f alpha:1.0f];
    m_view.chart.timeAxis.margin = NChartMarginMake(20.0f, 20.0f, 10.0f, 0.0f);
    m_view.chart.timeAxis.autohideTooltip = NO;
    
    // Create the time axis tooltip.
    m_view.chart.timeAxis.tooltip = [NChartTimeAxisTooltip new];
    m_view.chart.timeAxis.tooltip.textColor = [UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.0f];
    m_view.chart.timeAxis.tooltip.font = [UIFont systemFontOfSize:11.0f];
    
    [m_view.chart.timeAxis setImagesForBeginNormal:nil
                                       beginPushed:nil
                                         endNormal:nil
                                         endPushed:nil
                                        playNormal:[UIImage imageNamed:@"play-light.png"]
                                        playPushed:[UIImage imageNamed:@"play-pushed-light.png"]
                                       pauseNormal:[UIImage imageNamed:@"pause-light.png"]
                                       pausePushed:[UIImage imageNamed:@"pause-pushed-light.png"]
                                            slider:[UIImage imageNamed:@"slider-light.png"]
                                           handler:[UIImage imageNamed:@"handler-light.png"]];
    
    
    // Visible time axis.
    m_view.chart.timeAxis.visible = YES;
    
    // Set animation time in seconds.
    m_view.chart.timeAxis.animationTime = 3.0f;
    
    // Switch 3D on.
    m_view.chart.drawIn3D = YES;
    
    // Switch on antialiasing.
    m_view.chart.shouldAntialias = YES;
    
    // Create series.
    for (int i = 0; i < 3; ++i)
    {
        NChartBubbleSeries *series = [NChartBubbleSeries series];
        series.dataSource = self;
        series.tag = i;
        // Add series to the chart.
        [m_view.chart addSeries:series];
    }
    m_view.chart.cartesianSystem.xAxis.hasOffset = NO;
    m_view.chart.cartesianSystem.yAxis.hasOffset = NO;
    m_view.chart.cartesianSystem.zAxis.hasOffset = NO;
    
    // Set data source for the size axis to provide ticks.
    m_view.chart.timeAxis.dataSource = self;
    
    // Set data source for the size axis to provide sizes for bubbles.
    m_view.chart.sizeAxis.dataSource = self;
    
    // Reset animation.
    [m_view.chart.timeAxis stop];
    [m_view.chart.timeAxis goToFirstTick];
    
    // Update data in the chart.
    [m_view.chart updateData];
    
    // Set chart view to the controller.
    self.chartView = m_view;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NChartSeriesDataSource

- (NSArray *)seriesDataSourcePointsForSeries:(NChartSeries *)series
{
    // Create points with some data for the series.
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < 3; ++i)
    {
        NSMutableArray *states = [NSMutableArray array];
        for (int j = 0; j < 3; ++j)
        {
            NChartPointState *state = [NChartPointState pointStateWithX:(rand() % 10) + 1
                                                                      Y:(rand() % 10) + 1
                                                                      Z:(rand() % 10) + 1];
            state.marker = [NChartMarker new] ;
            state.marker.size = (float)(rand() % 1000) / 1000.0f;
            state.marker.brush = (NChartSolidColorBrush *)self.brushes[series.tag];
            state.marker.shape = NChartMarkerShapeSphere;
            state.marker.brush.shadingModel = NChartShadingModelPhong;
            [states addObject:state];
        }
        [result addObject:[NChartPoint pointWithArrayOfStates:states forSeries:series]];
    }
    return result;
}

- (NSString *)seriesDataSourceNameForSeries:(NChartSeries *)series
{
    // Get name of the series.
    return @"My series";
}

#pragma mark - NChartTimeAxisDataSource

- (NSArray *)timeAxisDataSourceTimestampsForAxis:(NChartTimeAxis *)timeAxis
{
    return @[@"1", @"2", @"3"];
}

#pragma mark - NChartSizeAxisDataSource

- (float)sizeAxisDataSourceMinSizeForSizeAxis:(NChartSizeAxis *)sizeAxis
{
    // Minimal size of bubbles in pixels. The size provided in the chart point is mapped to pixels through this value.
    return 30.0f;
}

- (float)sizeAxisDataSourceMaxSizeForSizeAxis:(NChartSizeAxis *)sizeAxis
{
    // Maximal size of bubbles in pixels. The size provided in the chart point is mapped to pixels through this value.
    return 100.0f;
}


@end
