//
//  DashboardTableViewController.m
//  E1
//
//  Created by Lei Zhao on 28/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DashboardTableViewController.h"
#import "DashboardTwinCell.h"
#import "DashboardItemViewController.h"
//#import "DashboardMapViewController.h"
//#import "DashboardGradientPercentViewController.h"
//#import "DashboardStatisticsAnalyzerViewController.h"
//#import "DashBoardPieChartViewController.h"
//#import "ParagraphViewController.h"
//#import "ColumnNChartViewController.h"
//#import "BubbleChartViewController.h"
#import "Definations.h"
#import "GeneralNChartViewController.h"
#import "NChartDataModel.h"
//#import "SubDetailChartViewController.h"
#import "GeneralNChartWithLabelViewController.h"
#import "DoubleNChartWithLabelViewController.h"
#import "DetailChartViewController.h"
#import "ChartDataManager.h"
@interface DashboardTableViewController ()
@property (nonatomic, strong) NSMutableArray* dashboardItemViewControllers;
- (void)loadChartData;
@end

@implementation DashboardTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DashboardTwinCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DashboardTwinCell class])];
    self.tableView.allowsSelection = NO;
    //self.tableView.backgroundColor=kcWholeBackColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.dashboardItemViewControllers = [NSMutableArray arrayWithCapacity:5];
    //[self.dashboardItemViewControllers addObject:[[DashboardMapViewController alloc] init]];
    //[self.dashboardItemViewControllers addObject:[[DashboardGradientPercentViewController alloc] init]];
    //[self.dashboardItemViewControllers addObject:[[DashboardStatisticsAnalyzerViewController alloc] init]];
    //[self.dashboardItemViewControllers addObject:[[DashBoardPieChartViewController alloc] init]];
    //[self.dashboardItemViewControllers addObject:[[ParagraphViewController alloc] init]];
    //[self.dashboardItemViewControllers addObject:[[ColumnNChartViewController alloc] init]];
    //[self.dashboardItemViewControllers addObject:[[BubbleChartViewController alloc] init]];
    //config the add button
    UIBarButtonItem* rightBarButtonItem=[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.view.backgroundColor=kcWholeBackColor;
    self.chartNames=[NSMutableArray array];
    [self.chartNames addObject:kcDefaultChartName];
    [self setupDefaultDataForDrawing];
    
    
    //[self loadChartData];
    
    
    self.navigationController.delegate=self;
    self.pushAnimation= [[PushAnimation alloc] init];
    self.popAnimation= [[PopAnimation alloc] init];
    
}

- (void)loadChartData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [NSThread sleepForTimeInterval:3.0f];//simulate the process of loading data from node
    dispatch_async(dispatch_get_main_queue(), ^{
            DoubleNChartWithLabelViewController* vc2=(DoubleNChartWithLabelViewController*)[self.dashboardItemViewControllers objectAtIndex:2];
            vc2.dataForNChart.chartDataForDrawing=[NChartDataModel radarSeriesData] ;//update chart's series data
            //vc2.dataForNChart=[NChartDataModel radarChart];
            
            
        });
    });
}
-(void)setupDefaultDataForDrawing
{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userd = [userDefault dictionaryRepresentation];
//    if (![userd.allKeys containsObject:kcDefaultChartName])
//    {
//        NSMutableArray* chartNameArray=[NSMutableArray array];
//        NSArray* chartsData=[NChartDataModel chartDataDefault];
//        for (NChartDataModel* oneChartData in chartsData)
//        {
//            [chartNameArray addObject:oneChartData.chartCaption];
//            [oneChartData saveDataForKey:oneChartData.chartCaption];//chartCaption
//            [self.dashboardItemViewControllers addObject:[[DoubleNChartWithLabelViewController alloc] initWithDrawingData:oneChartData delegateHolder:self]];
//            
//        }
//        [userDefault setObject:chartNameArray forKey:kcDefaultChartName];
//        [userDefault synchronize];
//    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userd = [userDefault dictionaryRepresentation];
    ChartDataManager* manager=[ChartDataManager defaultChartDataManager];
    if (![userd.allKeys containsObject:kcDefaultChartName])
    {
       
        
        NSArray* chartsData=[NChartDataModel chartDataDefault];
        [manager storeChartDataToFile:chartsData fileName:[NChartDataModel getStoredDefaultFilePath]];
        for (NChartDataModel* oneChartData in chartsData)
        {
            
            [self.dashboardItemViewControllers addObject:[[DoubleNChartWithLabelViewController alloc] initWithDrawingData:oneChartData delegateHolder:self]];
            
        }

    }    
//    else//there are default data in defualts for display
//    {
//        
//        for (NSString* chartName in [userd objectForKey:kcDefaultChartName])
//        {
//            NChartDataModel* dataForChart=[NChartDataModel loadDataWithKey:chartName];
//            
//            [self.dashboardItemViewControllers addObject:[[DoubleNChartWithLabelViewController alloc] initWithDrawingData:dataForChart delegateHolder:self]];
//        }
//
//                
//        
//    }
    
    else//there are default data in defualts for display
    {
        NSArray* chartDataArray=[manager parseFromDefaultFile:[NChartDataModel getStoredDefaultFilePath]];
        
        for (NChartDataModel* dataForChart in chartDataArray)
        {
            //NChartDataModel* dataForChart=[NChartDataModel loadDataWithKey:chartName];
            
            [self.dashboardItemViewControllers addObject:[[DoubleNChartWithLabelViewController alloc] initWithDrawingData:dataForChart delegateHolder:self]];
        }
        
        
        
    }
    
}
- (void)handleRightButtonItem:(id)sender
{
    //want to add new chart
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (int)(self.dashboardItemViewControllers.count + 1) / 2;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    DashboardTwinCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DashboardTwinCell class])];

    long itemIndex = indexPath.row * 2;
    for (long i = itemIndex; i <= itemIndex + 1 && i < self.dashboardItemViewControllers.count; i++) {
        //Find item view controller
        DashboardItemViewController* itemViewController = [self.dashboardItemViewControllers objectAtIndex:i];

        //Add item vc as child vc.
        BOOL addChildViewContollerFlag = [self.childViewControllers containsObject:itemViewController];
        if (!addChildViewContollerFlag) {
            [self addChildViewController:itemViewController];
        }

        //Add item view to cell
        UIView* cellView = i == itemIndex ? cell.leftView : cell.rightView;
        [[cellView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        itemViewController.view.frame = cellView.bounds;
        [cellView addSubview:itemViewController.view];

        //Add item vc as child vc.
        if (!addChildViewContollerFlag) {
            [itemViewController didMoveToParentViewController:self];
        }
    }
    //cell.backgroundColor=kcWidgetBackColor;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 400;
}

#pragma ChartSubviewControllerResponse
-(void)searchButtonClickedWithData:(NChartDataModel*)dataSubviewControllerHolding inView:(UIView *)contentView
{
//    SubDetailChartViewController* detailViewController= [[SubDetailChartViewController alloc] initWithChartData:dataSubviewControllerHolding];
//    [self.navigationController pushViewController:detailViewController animated:YES];
    DetailChartViewController* detailViewController= [[DetailChartViewController alloc] initWithDrawingData:dataSubviewControllerHolding delegateHolder:nil];
    
    //detailViewController.transitioningDelegate=self;
    detailViewController.modalTransitionStyle = UIModalPresentationCustom;
    self.transitioningView=contentView;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    //[self.navigationController presentViewController:detailViewController animated:YES completion:nil];

    
}
#pragma <UINavigationControllerDelegate>

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return self.pushAnimation;
    }
    else if (operation == UINavigationControllerOperationPop) {
        return self.popAnimation;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    //return self.interactionController;
    return nil;
}
@end
