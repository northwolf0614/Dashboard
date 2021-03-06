//
//  GeneralNChartViewController.m
//  E1
//
//  Created by Jack Lin on 1/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "GeneralNChartViewController.h"
#import "Definations.h"
#import  <NChart3D/NChart3D.h>

@interface GeneralNChartViewController ()

@end

@implementation GeneralNChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView }]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView }]];
    [self.chartView.chart fitToScreen:0.1];
    //[self setupAxesType];
    self.backGroundColor=kcWidgetBackColor;
    self.contentView.backgroundColor=self.backGroundColor;
    self.isNeedsUpdate=YES;
    
//    if (self.dataForNChart.chartType==RADAR) {
//        [self removeAllSeries];
//        [self setupSeriesForChartView];
//        [self.chartView.chart updateData];
//    }
    
   
    
}

 



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];//2
    //[self createSeries];
}

-(void) setupSeriesForChartView
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
                [self.chartView.chart addSeries:series];
                
                self.chartView.chart.cartesianSystem.yAlongX.visible=NO;
                self.chartView.chart.cartesianSystem.xAlongY.visible=NO;
                self.chartView.chart.cartesianSystem.borderVisible=NO;
                self.chartView.chart.cartesianSystem.yAxis.caption.visible=NO;
                self.chartView.chart.cartesianSystem.yAxis.visible=NO;
                self.chartView.chart.cartesianSystem.yAxis.labelsVisible=NO;
                self.chartView.chart.cartesianSystem.xAxis.caption.visible=NO;
                self.chartView.chart.cartesianSystem.xAxis.majorTicks.visible=NO;
                self.chartView.chart.cartesianSystem.xAxis.minorTicks.visible=NO;
                //[self updateChartData:self.chartView animated:YES];
//                NChartColumnSeriesSettings *setting = [NChartColumnSeriesSettings seriesSettings];
//                setting.animationType = NChartColumnAnimationTypeOneByOne;
//                [self.chartView.chart addSeriesSettings:setting];
            }
                break;
            case LINE:
            {
                NChartLineSeries* series = [NChartLineSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.dataSource = (id)self;
                series.hostsOnSY = YES;
                [self.chartView.chart addSeries:series];
                
                self.chartView.chart.cartesianSystem.yAlongX.visible=NO;
                self.chartView.chart.cartesianSystem.xAlongY.visible=NO;
                self.chartView.chart.cartesianSystem.borderVisible=NO;
                self.chartView.chart.cartesianSystem.yAxis.caption.visible=NO;
                self.chartView.chart.cartesianSystem.yAxis.visible=NO;
                self.chartView.chart.cartesianSystem.yAxis.labelsVisible=NO;
                self.chartView.chart.cartesianSystem.xAxis.caption.visible=NO;
                self.chartView.chart.cartesianSystem.xAxis.majorTicks.visible=NO;
                self.chartView.chart.cartesianSystem.xAxis.minorTicks.visible=NO;
                self.chartView.chart.cartesianSystem.syAxis.visible = NO;
//                NChartLineSeriesSettings *setting = [NChartLineSeriesSettings seriesSettings];
//                setting.animationType = NChartLineAnimationTypeGrowRight;
//                [self.chartView.chart addSeriesSettings:setting];

            }
                break;
            case BAR:
            {
                NChartBarSeries* series = [NChartBarSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.dataSource = (id)self;
                [self.chartView.chart addSeries:series];
                
                self.chartView.chart.cartesianSystem.yAlongX.visible=NO;
                self.chartView.chart.cartesianSystem.xAlongY.visible=NO;
                self.chartView.chart.cartesianSystem.borderVisible=NO;
                self.chartView.chart.cartesianSystem.yAxis.caption.visible=NO;
                self.chartView.chart.cartesianSystem.yAxis.visible=NO;
                self.chartView.chart.cartesianSystem.yAxis.labelsVisible=NO;
                self.chartView.chart.cartesianSystem.xAxis.caption.visible=NO;
                self.chartView.chart.cartesianSystem.xAxis.visible=NO;
                self.chartView.chart.cartesianSystem.xAxis.labelsVisible=NO;
                //[self updateChartData:self.chartView animated:YES];
                
            }
                break;
            case DOUGHNUT:
            {
                NChartPieSeries* series = [NChartPieSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.dataSource = (id)self;
                [self.chartView.chart addSeries:series];
                NChartPieSeriesSettings *settings = [NChartPieSeriesSettings seriesSettings];
                //settings.centerCaption=@"center";
                
                settings.holeRatio = 0.8f;
                [self.chartView.chart addSeriesSettings:settings];
                self.chartView.chart.streamingMode = NO;
                self.chartView.chart.timeAxis.visible = NO;
                //[self updateChartData:self.chartView animated:YES];
            }
                break;
            
            case RADAR:
            {
                NChartRadarSeries* series = [NChartRadarSeries new];
                series.tag=count;
                series.brush =[NChartSolidColorBrush solidColorBrushWithColor:brushColor];
                series.brush.opacity=0.8f;
                series.dataSource = (id)self;
                [self.chartView.chart addSeries:series];
                
                self.chartView.chart.timeAxis.visible = NO;
                self.chartView.chart.polarSystem.borderColor = nil;
                self.chartView.chart.polarSystem.radiusAxis.labelsVisible=NO;
                self.chartView.chart.polarSystem.radiusAxis.visible=NO;
                self.chartView.chart.polarSystem.radiusAxis.caption.visible=NO;
                
                self.chartView.chart.polarSystem.azimuthAxis.caption.visible=NO;
                //self.chartView.chart.polarSystem.azimuthAxis.visible=NO;
                //self.chartView.chart.polarSystem.azimuthAxis.labelsVisible=NO;
                self.chartView.chart.polarSystem.azimuthAxis.textColor=kcCharColor;
                //[self updateChartData:self.chartView animated:YES];
                self.chartView.chart.streamingMode = NO;
                NChartRadarSeriesSettings *settings = [NChartRadarSeriesSettings seriesSettings];
                settings.shouldSmoothAxesGrid = NO;
                [self.chartView.chart addSeriesSettings:settings];
                self.chartView.chart.polarSystem.grid.visible=NO;
                //self.chartView.chart.polarSystem.b=NO;

                
                
                
                

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
                [self.chartView.chart addSeries:series];
                
                self.chartView.chart.cartesianSystem.yAlongX.visible=NO;
                self.chartView.chart.cartesianSystem.xAlongY.visible=NO;
                self.chartView.chart.cartesianSystem.borderVisible=NO;
                self.chartView.chart.cartesianSystem.yAxis.caption.visible=NO;
                self.chartView.chart.cartesianSystem.yAxis.visible=NO;
                self.chartView.chart.cartesianSystem.yAxis.labelsVisible=NO;
                self.chartView.chart.cartesianSystem.xAxis.caption.visible=NO;
                self.chartView.chart.cartesianSystem.xAxis.majorTicks.visible=NO;
                self.chartView.chart.cartesianSystem.xAxis.minorTicks.visible=NO;
                self.chartView.chart.streamingMode=NO;
                
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
-(void)removeAllSeries
{
    [self.chartView.chart removeAllSeries];
}
-(void)showSeries

{
    if (self.isNeedsUpdate)
    {
        
        [self removeAllSeries];
        [self setupSeriesForChartView];
        self.isNeedsUpdate=NO;
        [self updateChartData:self.chartView animated:YES dataModel:self.dataForNChart];
    }
    
}
//-(void)handleRightButtonItem:(id) sender
//{
//    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(searchButtonClickedWithData: inView:)])
//        
//    {
//        [self.delegate searchButtonClickedWithData:self.dataForNChart inView:self.view];
//       
//    }
//    
////    if (![self.chartView.chart isTransitionPlaying])
////    {
////        //[m_delegate chartDelegatePointOfChart:nil selected:nil];
////        
////        [self.chartView.chart  stopTransition];
////        //[m_view.chart playTransition:TRANSITION_TIME reverse:YES];
////        [self.chartView.chart  playTransition:0.45 reverse:NO];
////    }
//
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
