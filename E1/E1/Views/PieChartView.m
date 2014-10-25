//
//  PieChartView.m
//  E1
//
//  Created by Jack Lin on 25/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "PieChartView.h"
#import "ViewController.h"
#import "Definations.h"
@interface PieChartView()<CPTPieChartDelegate>
@property (strong , nonatomic ) CPTXYGraph *graph;
@property (strong , nonatomic ) CPTPieChart *piePlot;
-(void)setupCoreplotViews;
-(id) viewController;

@end

@implementation PieChartView

-(id)init
{
    self=[super init];
    if (self!=nil)
    {
        // initialize the graph
        self.graph = [[ CPTXYGraph alloc ] init];
        //initilize the pie plot
        self.piePlot = [[ CPTPieChart alloc ] init];
        [self setupCoreplotViews];
    }
    return self;
}
-(void)layoutSubviews
{
    self.graph.frame=self.bounds;
    self.piePlot.frame=self.bounds;
    [super layoutSubviews];
    
}
-(id) viewController
{
    UIWindow* appWindow= [[UIApplication sharedApplication] keyWindow];
    UIViewController* navController=appWindow.rootViewController;
    if ([navController isKindOfClass:[UINavigationController class]])
    {
        for (UIViewController* vc in [(UINavigationController*)navController viewControllers])
        {
            if ([vc isKindOfClass:[ViewController class]])
            {
                return vc;
            }
        }
        return nil;
    }
    return nil;
}

-(void)setupCoreplotViews
{

    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme ];
    [self.graph applyTheme:theme];
    self.graph.paddingBottom = kcCorePlotGraphPadding ;
    self.graph.paddingLeft  =kcCorePlotGraphPadding;
    self.graph.paddingRight  =kcCorePlotGraphPadding ;
    self.graph.paddingTop = kcCorePlotGraphPadding ;
    // set the axis of the graph as nil
    self.graph.axisSet = nil ;
    // configue the graph for view
    self.hostedGraph = self.graph ;
    // configue the style of graph
    CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle ];
    whiteText.color = [CPTColor blackColor];
    whiteText.fontSize = kcPieChartTitleFontSize ;
    whiteText.fontName = @"Helvetica-Bold";
    self.graph.titleTextStyle = whiteText;
    self.graph.title = @"QBE Composition";
    // 创建图例
    CPTLegend *aLegend = [CPTLegend legendWithGraph:self.graph];
    aLegend.numberOfColumns = 1 ;
    aLegend.fill = [CPTFill fillWithColor:[ CPTColor whiteColor ]];
    aLegend.borderLineStyle = [CPTLineStyle lineStyle];
    aLegend.cornerRadius = 5.0 ;
    aLegend.delegate = [self viewController];
    self.graph.legend = aLegend;
    self.graph.legendAnchor = CPTRectAnchorRight ;
    self.graph.legendDisplacement = CGPointMake (-10,100);
}


-(void)updateCorePlotViews
{
    self.piePlot.dataSource = [self viewController];
    self.piePlot.pieRadius = kcPieChartRadius ;
    self.piePlot.identifier = @"pie chart" ;
    self.piePlot.startAngle = M_PI_4;
    self.piePlot.sliceDirection = CPTPieDirectionCounterClockwise ;
    // set up the center anchor
    self.piePlot.centerAnchor = CGPointMake (0.5,0.5);
    // set up the border line style of pie plot
    self.piePlot.borderLineStyle = [CPTLineStyle lineStyle];
    // setup the delegate
    self.piePlot.delegate=self;
    // add the pie chart to the graph
    [self.graph addPlot:self.piePlot ];
}
#pragma CPTPieChartDelegate
// method will be call when any part of the pie chart is being selected
-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)idx
{
    //do something when selecting any part of the pie chart
}



@end
