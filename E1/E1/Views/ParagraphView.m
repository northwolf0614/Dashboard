//
//  ParagraphView.m
//  E1
//
//  Created by Jack Lin on 23/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "ParagraphView.h"
#import "CorePlot-CocoaTouch.h"
#import "Definations.h"
#import "VieWController.h"


@interface ParagraphView() <CPTAxisDelegate>
//plot related
@property(nonatomic,strong) CPTXYGraph * graph;
//Coreplot related
-(void)setupCoreplotViews;
-(CPTPlotRange *)CPTPlotRangeFromFloat:(float)location length:(float)length;
@end


@implementation ParagraphView
-(id)init
{
    self=[super init];
    if (self!=nil)
    {
        self.graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
        [self setupCoreplotViews];
    }
    return self;
}
-(void)setupCoreplotViews
{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    // Create graph from theme
    
    CPTTheme * theme = [CPTTheme themeNamed:kCPTSlateTheme];
    [self.graph applyTheme:theme];
    CPTGraphHostingView * hostingView = self;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph = self.graph;
    
    self.graph.paddingLeft = self.graph.paddingRight = 10.0;// config the distance frome edge of the view to contents of graph
    self.graph.paddingTop = self.graph.paddingBottom = 10.0;// config the distance frome edge of the view to contents of graph

    CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.0) length:CPTDecimalFromFloat(2.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.0) length:CPTDecimalFromFloat(3.0)];
    
    // Axes: 设置x:如原点，量度间隔，标签，刻度，颜色等
    //
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    
    lineStyle.miterLimit = 1.0f;
    lineStyle.lineWidth = 2.0;
    lineStyle.lineColor = [CPTColor whiteColor];
    
    CPTXYAxis * x = axisSet.xAxis;
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"2"); // 原点的 x 位置
    x.majorIntervalLength = CPTDecimalFromString(@"0.5");   // x轴主刻度：显示数字标签的量度间隔
    x.minorTicksPerInterval = 2;    // x轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    x.minorTickLineStyle = lineStyle;
    
    // 需要排除的不显示数字的主刻度
    NSArray * exclusionRanges = [
                                 NSArray arrayWithObjects:
                                 [self CPTPlotRangeFromFloat:0.99 length:0.02],
                                 [self CPTPlotRangeFromFloat:2.99 length:0.02],
                                 nil
                              ];
    x.labelExclusionRanges = exclusionRanges;
    
    // Axes: 设置Y:如原点，量度间隔，标签，刻度，颜色等
    CPTXYAxis * y = axisSet.yAxis;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"2"); // 原点的 y 位置
    y.majorIntervalLength = CPTDecimalFromString(@"0.5");   // y轴主刻度：显示数字标签的量度间隔
    y.minorTicksPerInterval = 4;    // y轴细分刻度：每一个主刻度范围内显示细分刻度的个数
    y.minorTickLineStyle = lineStyle;
    exclusionRanges = [
                       NSArray arrayWithObjects:
                       [self CPTPlotRangeFromFloat:1.99 length:0.02],
                       [self CPTPlotRangeFromFloat:2.99 length:0.02],
                       nil
                       ];
    y.labelExclusionRanges = exclusionRanges;
    y.delegate = self;
}


-(void)updateCorePlotViews
{
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 3.0f;
    lineStyle.lineColor         = [CPTColor blueColor];
    
    CPTScatterPlot * boundLinePlot  = [[CPTScatterPlot alloc] init];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = BLUE_PLOT_IDENTIFIER;
    boundLinePlot.dataSource    =[self viewController];
    // Do a red-blue gradient: 渐变色区域
    //
    CPTColor * blueColor        = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPTColor * redColor         = [CPTColor colorWithComponentRed:1.0 green:0.3 blue:0.3 alpha:0.8];
    CPTGradient * areaGradient1 = [CPTGradient gradientWithBeginningColor:blueColor
                                                              endingColor:redColor];
    areaGradient1.angle = -90.0f;
    CPTFill * areaGradientFill  = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber numberWithFloat:1.0] decimalValue]; // 渐变色的起点位置
    // Add plot symbols: 表示数值的符号的形状
    //
    CPTMutableLineStyle * symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    symbolLineStyle.lineWidth = 2.0;
    
    CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(10.0, 10.0);
    boundLinePlot.plotSymbol = plotSymbol;
    //draw the data from the delegate to the area
    [self.graph addPlot:boundLinePlot];

}

-(CPTPlotRange *)CPTPlotRangeFromFloat:(float)location length:(float)length
{
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(location) length:CPTDecimalFromFloat(length)];
    
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

#pragma mark -
#pragma mark Axis Delegate Methods

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    static CPTTextStyle * positiveStyle = nil;
    static CPTTextStyle * negativeStyle = nil;
    //Jack Lin remended
    //NSNumberFormatter * formatter   = axis.labelFormatter;
    NSFormatter * formatter     =  axis.labelFormatter;
    //Jack Lin remended
    CGFloat labelOffset         = axis.labelOffset;
    NSDecimalNumber * zero         = [NSDecimalNumber zero];
    NSMutableSet * newLabels      = [NSMutableSet set];
    
    for (NSDecimalNumber * tickLocation in locations)
    {
        CPTTextStyle *theLabelTextStyle;
        
        if ([tickLocation isGreaterThanOrEqualTo:zero])
        {
            if (!positiveStyle)
            {
                CPTMutableTextStyle * newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor greenColor];
                positiveStyle  = newStyle;
            }
            
            theLabelTextStyle = positiveStyle;
        }
        else
        {
            if (!negativeStyle)
            {
                CPTMutableTextStyle * newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor redColor];
                negativeStyle  = newStyle;
            }
            
            theLabelTextStyle = negativeStyle;
        }
        
        NSString * labelString      = [formatter stringForObjectValue:tickLocation];
        CPTTextLayer * newLabelLayer  = [[CPTTextLayer alloc] initWithText:labelString style:theLabelTextStyle];
        CPTAxisLabel * newLabel     = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
        newLabel.tickLocation       = tickLocation.decimalValue;
        newLabel.offset             = labelOffset;
        [newLabels addObject:newLabel];
    }
    axis.axisLabels = newLabels;
    return NO;
}
@end
