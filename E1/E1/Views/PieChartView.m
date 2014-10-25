//
//  PieChartView.m
//  E1
//
//  Created by Jack Lin on 25/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "PieChartView.h"
#import "ViewController.h"
@interface PieChartView()<CPTPieChartDelegate>
@property ( retain , nonatomic ) CPTXYGraph *graph;
@property ( retain , nonatomic ) CPTPieChart *piePlot;
-(void)setupCoreplotViews;
-(id) viewController;

@end

@implementation PieChartView

-(id)init
{
    self=[super init];
    if (self!=nil)
    {
        // 创建画布
        self.graph = [[ CPTXYGraph alloc ] init];
        //创建饼图
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
    // 设置画布主题
    CPTTheme *theme = [ CPTTheme themeNamed : kCPTPlainWhiteTheme ];
    [self.graph applyTheme:theme];
    // 画布与周围的距离
    self.graph.paddingBottom = 10 ;
    self.graph.paddingLeft = 5 ;
    self.graph.paddingRight = 5 ;
    self.graph.paddingTop = 10 ;
    // 将画布的坐标轴设为空
    self.graph.axisSet = nil ;
    // 创建画板
    CPTGraphHostingView *hostView=self;
    // 设置画板的画布
    hostView.hostedGraph = self.graph ;
    // 设置画布标题的风格
    CPTMutableTextStyle *whiteText = [ CPTMutableTextStyle textStyle ];
    whiteText.color = [ CPTColor blackColor ];
    whiteText.fontSize = 18 ;
    whiteText.fontName = @"Helvetica-Bold" ;
    self.graph.titleTextStyle = whiteText;
    self.graph.title = @" 饼状图 " ;
    // 创建图例
    CPTLegend *theLegeng = [ CPTLegend legendWithGraph : self.graph ];
    theLegeng.numberOfColumns = 1 ;
    theLegeng.fill = [ CPTFill fillWithColor :[ CPTColor whiteColor ]];
    theLegeng.borderLineStyle = [ CPTLineStyle lineStyle ];
    theLegeng.cornerRadius = 5.0 ;
    theLegeng.delegate = self ;
    self.graph.legend = theLegeng;
    self.graph.legendAnchor = CPTRectAnchorRight ;
    self.graph.legendDisplacement = CGPointMake (- 10 , 100 );
}


-(void)updateCorePlotViews
{
    // 设置数据源
    self.piePlot.dataSource = [self viewController];
    // 设置饼图半径
    self.piePlot.pieRadius = 50 ;
    // 设置饼图表示符
    self.piePlot.identifier = @"pie chart" ;
    // 饼图开始绘制的位置
    self.piePlot.startAngle = M_PI_4 ;
    // 饼图绘制的方向（顺时针 / 逆时针）
    self.piePlot.sliceDirection = CPTPieDirectionCounterClockwise ;
    // 饼图的重心
    self.piePlot.centerAnchor = CGPointMake (0.5,0.38);
    // 饼图的线条风格
    self.piePlot.borderLineStyle = [CPTLineStyle lineStyle];
    // 设置代理
    self.piePlot.delegate = self ;
    // 将饼图加到画布上
    [ self.graph addPlot:self.piePlot ];
    
    
    
}
#pragma CPTPieChartDelegate


// 选中某个扇形时的操作

- ( void )pieChart:( CPTPieChart *)plot sliceWasSelectedAtRecordIndex:( NSUInteger )idx

{
    
    //self.graph.title = [NSString stringWithFormat : @"比例 :%@" ,[ self.arr objectAtIndex :idx]];
    
}




@end
