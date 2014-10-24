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
@interface ViewController () <CPTPlotDataSource>
//view related
@property(nonatomic,strong) DashBoardView* dashBoardView;
//data for paragraphView
@property(nonatomic,strong) NSMutableArray * dataForPlot;
//statistics retrieve worker
@property(nonatomic,strong) StatisticsPostWorker* statisticsRetrieveWorker;//HTTP service worker
//model related
@property(nonatomic,strong) StatisticsModel* statisticModelInstance;

-(void)setupStatisticsRetrieveWorker;
-(void)setupDashBoardView;
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
-(void)setupDashBoardView
{
    self.dashBoardView=[[DashBoardView alloc] initWithFrame:self.view.frame];
    self.dashBoardView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.dashBoardView];
    [self.dashBoardView setNeedsDisplay];
    [self.dashBoardView startAnalyzeStatistics];
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
    [self setupDashBoardView];
    [self setupDataForViews];
    //[self setupStatisticsView];
    
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


#pragma mark -
#pragma mark Plot Data Source Methods

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






@end
