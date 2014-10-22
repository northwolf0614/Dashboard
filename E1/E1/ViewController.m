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



@interface ViewController ()//animated view related
@property(nonatomic,strong) StatisticsPostWorker* statisticsRetrieveWorker;//HTTP service worker
@property(nonatomic,strong) StatisticsModel* statisticModelInstance;
@property(nonatomic,strong) DashBoardView* dashBoardView;
@property(nonatomic,strong) StatisticsAnalyzerView* statisticsView;//





-(void)setupStatisticsRetrieveWorker;
-(void)setupStateChanges;
-(void)setupDashBoardView;





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

-(void)setupStatisticsView
{
    self.statisticsView=[[StatisticsAnalyzerView alloc] initWithFrame:self.view.frame];
    self.statisticsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.statisticsView];
    
    [self.statisticsView setNeedsDisplay];
    [self.statisticsView startAnalyzeStatistics];
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






@end
