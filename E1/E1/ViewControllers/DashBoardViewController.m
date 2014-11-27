//
//  DashBoardViewController.m
//  E1
//
//  Created by Jack Lin on 26/11/2014.
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

#import "DashBoardViewController.h"
//#import "ChartViewCell.h"
//#import "DefaultChartViewCell.h"
//#import "BlankViewCell.h"
#import "GeneralCollectionViewCell.h"
#import "EmptyCollectionViewCell.h"
@interface DashBoardViewController()
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout* flowLayout;

@property (nonatomic, strong) NSMutableArray* dashboardItemViewControllers;
@property (retain, nonatomic) UIPopoverController *masterPopoverController;
- (void)loadChartData;
@end



@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setItemSize:CGSizeMake(345,350)]; //设置每个cell显示数据的宽和高必须
    //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //水平滑动
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 2, 0, 0);
    
    //创建一屏的视图大小
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    //self.collectionView.collectionViewLayout=self.flowLayout;
    //对Cell注册(必须否则程序会挂掉)
    [self.collectionView registerClass:[GeneralCollectionViewCell class] forCellWithReuseIdentifier:[GeneralCollectionViewCell reuseIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:[EmptyCollectionViewCell reuseIdentifier] bundle:nil] forCellWithReuseIdentifier:[EmptyCollectionViewCell reuseIdentifier]];

    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setUserInteractionEnabled:YES];
    
    [self.collectionView setDelegate:(id)self]; //代理－视图
    [self.collectionView setDataSource:(id)self]; //代理－数据
    
    [self.view addSubview:self.collectionView];
    [self setupConstraints];
    
    //////////////////
    self.dashboardItemViewControllers = [NSMutableArray array];
    self.view.backgroundColor=kcWholeBackColor;
    
    self.chartNames=[NSMutableArray array];
    [self.chartNames addObject:kcDefaultChartName];
    [self setupDefaultDataForDrawing];
    
    
    //[self loadChartData];
    
    
    self.navigationController.delegate=self;
    self.pushAnimation= [[PushAnimation alloc] init];
    self.popAnimation= [[PopAnimation alloc] init];


}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem=nil;
        _detailItem = [newDetailItem copy];
        self.navigationItem.title=_detailItem;
        [self setupDefaultDataForDrawing];
        [self.collectionView reloadData];
    }
    
    
    if (self.masterPopoverController != nil)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
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
    if (self.detailItem!=nil&&[self.detailItem isKindOfClass:[NSString class]])
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *userd = [userDefault dictionaryRepresentation];
        ChartDataManager* manager=[ChartDataManager defaultChartDataManager];
        if (![userd.allKeys containsObject:self.detailItem]&&[self.detailItem isEqualToString:kcDefaultChartName])
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
        
        else if([userd.allKeys containsObject:self.detailItem]&&[self.detailItem isEqualToString:kcDefaultChartName])
        {
            NSArray* chartDataArray=[manager parseFromDefaultFile:[NChartDataModel getStoredDefaultFilePath]];
            
            for (NChartDataModel* dataForChart in chartDataArray)
            {
                //NChartDataModel* dataForChart=[NChartDataModel loadDataWithKey:chartName];
                
                [self.dashboardItemViewControllers addObject:[[DoubleNChartWithLabelViewController alloc] initWithDrawingData:dataForChart delegateHolder:self]];
            }
            
            
            
        }
        else
        {
            //NSLog(@"this is the entry I want");
            [manager storeChartDataToFile:nil fileName:[ChartDataManager getStoredFilePath:self.detailItem ]];
            [self.dashboardItemViewControllers removeAllObjects];
            
            
            
            
            
            
            
            
            
            
            
        }
    }
    //[self.view layoutSubviews];
    
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

-(void)setupConstraints
{
    self.collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:0 views:@{ @"collectionView" : self.collectionView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:0 metrics:0 views:@{ @"collectionView" : self.collectionView}]];
    [self.view setNeedsLayout];
    //[self.visualEfView setNeedsLayout];
    
}

#pragma mark <ChatViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ([self.dashboardItemViewControllers count]+1);
    //return ([self.dashboardItemViewControllers count]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell=nil;
    if (indexPath.row>([self.dashboardItemViewControllers count]-1)||[self.dashboardItemViewControllers count]==0)
    {
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EmptyCollectionViewCell class])  forIndexPath:indexPath];
        return cell;
    }
    else
    {
        cell=(GeneralCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GeneralCollectionViewCell class]) forIndexPath:indexPath];
    
//    long itemIndex = indexPath.row * 2;
//    for (long i = itemIndex; i <= itemIndex + 1 && i < self.dashboardItemViewControllers.count; i++)
//    {
        //Find item view controller
        DashboardItemViewController* itemViewController = [self.dashboardItemViewControllers objectAtIndex:indexPath.row];
        
        //Add item vc as child vc.
        BOOL addChildViewContollerFlag = [self.childViewControllers containsObject:itemViewController];
        if (!addChildViewContollerFlag) {
            [self addChildViewController:itemViewController];
        }
        
        //Add item view to cell
        UIView* cellView =(GeneralCollectionViewCell*)cell.contentView;
        [[cellView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        itemViewController.view.frame = cellView.bounds;
        [cellView addSubview:itemViewController.view];
        
        //Add item vc as child vc.
        if (!addChildViewContollerFlag) {
            [itemViewController didMoveToParentViewController:self];
        }
        return cell;
    }
    //cell.backgroundColor=kcWidgetBackColor;
   
    
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
    //[self.navigationController.splitViewController presentViewController:detailViewController animated:YES completion:nil];
    
    
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

#pragma mark - <UISplitViewControllerDelegate>

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Pages", @"Pages");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    //popoverController.contentViewController is qual to master navigation controller
    if ([popoverController.contentViewController isKindOfClass:[UINavigationController
                                                                class]])
    {
        self.masterPopoverController = popoverController;
    }
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}






@end
