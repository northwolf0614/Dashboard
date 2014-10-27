//
//  ViewController.m
//  E1
//
//  Created by Jack Lin on 18/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "ViewController.h"
#import "Notifications.h"
#import "StatisticsPostWorker.h"
#import "StatisticsModel.h"
#import "Definations.h"
#import "DashBoardView.h"
#import "StatisticsAnalyzerView.h"
#import "CorePlot-CocoaTouch.h"
#import "PieChartView.h"

@interface ViewController ()
//view related
@property(nonatomic,strong) DashBoardView* dashBoardView;
@property(nonatomic,strong) PieChartView* pieChartView;
@property(nonatomic,strong) UIScrollView* scrollView;
@property(nonatomic,strong) UIView* contentView;
//data for paragraphView
@property(nonatomic,strong) NSMutableArray * dataForPlot;
@property(nonatomic,strong) NSMutableArray * dataForPieChart;
//statistics retrieve worker
@property(nonatomic,strong) StatisticsPostWorker* statisticsRetrieveWorker;//HTTP service worker
//model related
@property(nonatomic,strong) StatisticsModel* statisticModelInstance;

-(void)setupStatisticsRetrieveWorker;
//-(void)setupDashBoardView;
//setup data for Views
-(void)setupDataForViews;
// applicatioin related
-(void)setupStateChanges;
@end

@implementation ViewController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
-(void)setupDashBoardView
{
    self.dashBoardView=[[DashBoardView alloc] initWithFrame:self.view.frame];
    self.dashBoardView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.dashBoardView];
    [self.dashBoardView setNeedsDisplay];
}
 */
-(void)setupAutoLayout
{
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollView];
    
    UIView* contentView = [[UIView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.backgroundColor = [UIColor greenColor];
    [scrollView addSubview:contentView];
    
    UILabel *randomLabel = [[UILabel alloc] init];
    randomLabel.text = @"this is a test";
    randomLabel.translatesAutoresizingMaskIntoConstraints = NO;
    randomLabel.backgroundColor = [UIColor clearColor];
    [contentView addSubview:randomLabel];
    
     DashBoardView* dashBoardView=[[DashBoardView alloc] init];
    self.dashBoardView=dashBoardView;
    dashBoardView.translatesAutoresizingMaskIntoConstraints=NO;
    dashBoardView.backgroundColor=[UIColor yellowColor];
    [contentView addSubview:dashBoardView];
    
    PieChartView* pieChartView1=[[PieChartView alloc] init];
    pieChartView1.translatesAutoresizingMaskIntoConstraints=NO;
    pieChartView1.backgroundColor=[UIColor yellowColor];
    [contentView addSubview:pieChartView1];
    
    PieChartView* pieChartView2=[[PieChartView alloc] init];
    pieChartView2.translatesAutoresizingMaskIntoConstraints=NO;
    pieChartView2.backgroundColor=[UIColor yellowColor];
    [contentView addSubview:pieChartView2];
    
    NSDictionary* viewDict = NSDictionaryOfVariableBindings(scrollView, contentView, randomLabel,dashBoardView,pieChartView1,pieChartView2);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:0 views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:0 views:viewDict]];
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:0 views:viewDict]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:0 views:viewDict]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=10-[randomLabel(==dashBoardView)]-20-[dashBoardView(300)]->=10-|" options:0 metrics:0 views:viewDict]];
    
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=10-[pieChartView1(==pieChartView2)]-20-[pieChartView2(300)]->=10-|" options:0 metrics:0 views:viewDict]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[randomLabel(==pieChartView1)]-20-[pieChartView1(300)]->=10-|" options:0 metrics:0 views:viewDict]];
    [contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[dashBoardView(==pieChartView2)]-20-[pieChartView2(300)]->=10-|" options:0 metrics:0 views:viewDict]];
    
    [self.dashBoardView setNeedsDisplay];
    

 
}
-(void)setupDataForViews
{
    self.dataForPlot = [NSMutableArray arrayWithCapacity:100];
    NSUInteger i;
    for ( i = 0; i < 100; i++ ) {
        id x = [NSNumber numberWithFloat:0 + i * 0.05];
        id y = [NSNumber numberWithFloat:1.2 * rand() / (float)RAND_MAX + 1.2];
        [self.dataForPlot addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
    self.dataForPieChart = [[ NSMutableArray alloc ] initWithObjects : @"0.2" , @"0.3" , @"0.1" , @"0.2" , @"0.2" , nil ];
}
-(void)setupStatisticsRetrieveWorker
{
    self.statisticsRetrieveWorker= [[StatisticsPostWorker alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processSuccessData:) name:kStatisticsRetrieveSuccessfullyNotificatioin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processFailureResponse:) name:kStatisticsRetrieveFailureNotification object:nil];
    [self.statisticsRetrieveWorker startRequestStatistics];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupStatisticsRetrieveWorker];
    [self setupStateChanges];
    [self setupDataForViews];
    [self setupAutoLayout];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)processSuccessData: (NSNotification*)notificatioin
{
    NSError* error=nil;
    self.statisticModelInstance= [StatisticsModel convertJSONToStatisticModelInstance:notificatioin.object error:error];
    
    if (error!=nil)
    {
        //show some error notifications to users
        
    }
    
    
}


-(void)processFailureResponse: (NSNotification*)notificatioin
{
    
    NSLog(@"receiving the statistics data fail!\n");
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [self.dashBoardView setPercent:0.9 animated:YES];
    [self.dashBoardView updateCorePlotViews];
    [self.dashBoardView updateAnalysis];

    
    
}


-(void)setupStateChanges
{

    UIApplication * app= [UIApplication sharedApplication];
    UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)])
        backgroundSupported = device.multitaskingSupported;
    

    if(backgroundSupported == NO)
    {
        [[NSNotificationCenter defaultCenter ] addObserver:self
                                                  selector:@selector(applicationWillTerminate:)
                                                      name:UIApplicationWillTerminateNotification
                                                    object:app];
    }

    else
    {
        
        [[NSNotificationCenter defaultCenter ] addObserver:self
                                                  selector:@selector(applicationDidEnterBackground:)
                                                      name:UIApplicationWillResignActiveNotification
                                                    object:app];
        
        
        [[NSNotificationCenter defaultCenter ] addObserver:self
                                                  selector:@selector(applicationDidBecomeActive:)
                                                      name:UIApplicationWillEnterForegroundNotification
                                                    object:app];
    }
    
}
-(void) applicationDidEnterBackground:(NSNotification*)notification
{
    NSLog(@"enter applicationDidEnterBackground ");
    //[self.percentageView deleteAnimatedProgress];
}

-(void)applicationDidBecomeActive:(NSNotification*)notification
{
    NSLog(@"enter applicationDidBecomeActive ");
}




#pragma mark -CPTPlotDataSource
#pragma mark Plot Data Source Methods for ParagraphView
/*
 -(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
 {
 return [ self.dataForPlot count];
 }
 
 -(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
 {
 NSString * key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
 NSNumber * num = [[_dataForPlot objectAtIndex:index] valueForKey:key];
 
 // Green plot gets shifted above the blue
 if ([(NSString *)plot.identifier isEqualToString:GREEN_PLOT_IDENTIFIER]) {
 if (fieldEnum == CPTScatterPlotFieldY) {
 num = [NSNumber numberWithDouble:[num doubleValue] + 1.0];
 }
 }
 
 return num;
 }
 */
// 返回扇形数目

-(NSUInteger)numberOfRecordsForPlot:( CPTPlot *)plot
{
    
    return self.dataForPieChart.count ;
    
}

// 返回每个扇形的比例

- (NSNumber *)numberForPlot:( CPTPlot *)plot field:( NSUInteger )fieldEnum recordIndex:( NSUInteger )idx
{
    return [ self.dataForPieChart objectAtIndex:idx];
}

// 凡返回每个扇形的标题

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)idx

{
    
    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"hello,%@" ,[ self. dataForPieChart objectAtIndex:idx]]];
    CPTMutableTextStyle* text = [ label.textStyle mutableCopy ];
    text.color = [CPTColor whiteColor];
    return label;
    
}

#pragma ===========CPTPieChart   Delegate========================

// 选中某个扇形时的操作

//- ( void )pieChart:( CPTPieChart *)plot sliceWasSelectedAtRecordIndex:( NSUInteger )idx

//{
    
//    self . graph . title = [ NSString stringWithFormat : @" 比例 :%@" ,[ self .arr objectAtIndex :idx]];
    
//}

// 返回图例

-(NSAttributedString*)attributedLegendTitleForPieChart:(CPTPieChart*)pieChart recordIndex:(NSUInteger)idx

{
    NSAttributedString* title = [[NSAttributedString alloc ] initWithString :[ NSString stringWithFormat:@"hi:%i",idx]];
    return  title;
    
}




@end
