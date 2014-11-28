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
#import "Definations.h"
#import "GeneralNChartViewController.h"
#import "NChartDataModel.h"
#import "GeneralNChartWithLabelViewController.h"
#import "DoubleNChartWithLabelViewController.h"
#import "DetailChartViewController.h"
#import "ChartDataManager.h"
#import "DashBoardViewController.h"
#import "GeneralCollectionViewCell.h"
#import "EmptyCollectionViewCell.h"
#import "SettingsViewController.h"
#import "SplitViewController.h"
@interface DashBoardViewController()
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout* flowLayout;

@property (nonatomic, strong) NSMutableArray* dashboardItemViewControllers;
@property (retain, nonatomic) UIPopoverController *masterPopoverController;
@property (nonatomic, strong) NSMutableArray* chartDataAssembly;
- (void)loadChartData;
@end



@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setItemSize:CGSizeMake(345,350)]; //设置每个cell显示数据的宽和高必须
    //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //水平滑动
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
    self.flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    
    //创建一屏的视图大小
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    //self.collectionView.collectionViewLayout=self.flowLayout;
    //对Cell注册(必须否则程序会挂掉)
    [self.collectionView registerClass:[GeneralCollectionViewCell class] forCellWithReuseIdentifier:[GeneralCollectionViewCell reuseIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:[EmptyCollectionViewCell reuseIdentifier] bundle:nil] forCellWithReuseIdentifier:[EmptyCollectionViewCell reuseIdentifier]];

    [self.collectionView setBackgroundColor:kcWholeBackColor];
    [self.collectionView setUserInteractionEnabled:YES];
    //self.collectionView.allowsSelection=YES;
    
    [self.collectionView setDelegate:(id)self];
    [self.collectionView setDataSource:(id)self];
//    [self.view addSubview:self.collectionView];
    [self setupConstraints];
    
    //////////////////
    self.dashboardItemViewControllers = [NSMutableArray array];
    //self.view.backgroundColor=kcWholeBackColor;
    
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
            self.chartDataAssembly=[NSMutableArray arrayWithArray:chartsData];
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
            self.chartDataAssembly=[NSMutableArray arrayWithArray:chartDataArray];
            
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
//- (void)handleRightButtonItem:(id)sender
//{
//    //want to add new chart
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupConstraints
{
    [self.view addSubview:self.collectionView];
    self.collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:0 views:@{ @"collectionView" : self.collectionView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:0 metrics:0 views:@{ @"collectionView" : self.collectionView}]];
    [self.view setNeedsLayout];
    //[self.visualEfView setNeedsLayout];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(UISplitViewController*)configSplitDetailsController:(DetailChartViewController*)detailViewController
{
    SettingsViewController* masterViewController = [[SettingsViewController alloc] init] ;
    UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController] ;
    
    //DetailChartViewController *detailViewController = [[DetailChartViewController alloc] init] ;
    //UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController] ;
    UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController] ;
    
    
    masterViewController.detailViewController = detailViewController;
    
    SplitViewController* splitViewController = [[SplitViewController alloc] init] ;
    splitViewController.delegate = (id)detailViewController;
    splitViewController.viewControllers = @[masterNavigationController, detailNavigationController];
    //splitViewController.transitioningDelegate=self;
    
    return splitViewController;
    
    
}

#pragma mark <UICollectionViewDataSource>
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
#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{

    //NSLog(@"did selected on %ld", indexPath.item);
    DetailChartViewController* detailViewController=nil;
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    UICollectionViewCell* cell=[collectionView cellForItemAtIndexPath:indexPath];
    
    if (indexPath.row>([self.dashboardItemViewControllers count]-1)||[self.dashboardItemViewControllers count]==0)
        detailViewController= [[DetailChartViewController alloc] initWithDrawingData:nil delegateHolder:nil];
    
    else
    detailViewController= [[DetailChartViewController alloc] initWithDrawingData:[self.chartDataAssembly objectAtIndex:indexPath.row] delegateHolder:nil];
    
    self.transitioningView = cell;
#ifdef DetailViewController
    
    detailViewController.transitioningDelegate=(id)self;
    detailViewController.modalTransitionStyle = UIModalPresentationCustom;
    
    [self presentViewController:detailViewController animated:YES completion:nil];
    
    
#else
    UISplitViewController* splitDetailViewController=[self configSplitDetailsController:detailViewController];
    
    splitDetailViewController.transitioningDelegate=(id)self;
    splitDetailViewController.modalTransitionStyle = UIModalPresentationCustom;
    
    [self presentViewController:splitDetailViewController animated:YES completion:nil];
#endif
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}


//#pragma <ChartSubviewControllerResponse>
//-(void)searchButtonClickedWithData:(NChartDataModel*)dataSubviewControllerHolding inView:(UIView *)contentView
//{
//    //    SubDetailChartViewController* detailViewController= [[SubDetailChartViewController alloc] initWithChartData:dataSubviewControllerHolding];
//    //    [self.navigationController pushViewController:detailViewController animated:YES];
//    DetailChartViewController* detailViewController= [[DetailChartViewController alloc] initWithDrawingData:dataSubviewControllerHolding delegateHolder:nil];
//    detailViewController.transitioningDelegate=(id)self;
//    
//    //detailViewController.transitioningDelegate=self;
//    detailViewController.modalTransitionStyle = UIModalPresentationCustom;
//    self.transitioningView=contentView;
//    
//    //[self.navigationController pushViewController:detailViewController animated:YES];
//    //[self.navigationController.splitViewController presentViewController:detailViewController animated:YES completion:nil];
//    //[self presentViewController:detailViewController animated:YES completion:nil];
//    //[self presentDetailsController];
//    
//    
//}
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


#pragma mark <UIViewControllerTransitioningDelegate>
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

#pragma mark <UIViewControllerAnimatedTransitioning>

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"this is animateTransition");
    //Get references to the view hierarchy
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController_topParent = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController=nil;
    
    if ([fromViewController_topParent isKindOfClass:[UISplitViewController class]])
    {
        for (UIViewController* vc in ((UISplitViewController*)fromViewController_topParent).viewControllers)
        {
            if ([vc isKindOfClass:[UINavigationController class]])
                if ([((UINavigationController*)vc).topViewController isKindOfClass:[DashBoardViewController class]]||[((UINavigationController*)vc).topViewController isKindOfClass:[DetailChartViewController class]])
                {
                    fromViewController=((UINavigationController*)vc).topViewController;
                    break;
                }
        }
    }
#ifdef DetailViewController
    //UIViewController *fromViewController = fromViewController_topParent.
    if ([fromViewController isKindOfClass:[DashBoardViewController class]] && [toViewController isKindOfClass:[DetailChartViewController class]])
    {
        //Presenting DetailChartViewController from DashboardTableViewController
        DetailChartViewController* dvc = (DetailChartViewController*)toViewController;
        DashboardTableViewController* dashvc=(DashboardTableViewController*) fromViewController;
        //DashboardTableViewController* dashvc = [naviVC.viewControllers objectAtIndex:0 ];
        
        
        CGRect transitioningFrame = [dashvc.transitioningView convertRect:dashvc.transitioningView.bounds toView:dashvc.view];//get the dashvc.transitoningview positon referencing to the dashvc.view
        
        //Destination view controller
        dvc.view.transform = CGAffineTransformMakeScale(
                                                        CGRectGetWidth(transitioningFrame) / CGRectGetWidth(containerView.bounds),
                                                        CGRectGetHeight(transitioningFrame) / CGRectGetHeight(containerView.bounds));
        dvc.view.frame = transitioningFrame;
        dvc.view.alpha = 0.0f;
        
        //source view controller
        dashvc.transitioningView.alpha = 1.0f;
        
        [containerView insertSubview:dvc.view aboveSubview:dashvc.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            //Destination view controller
            dvc.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            dvc.view.frame = containerView.bounds;
            dvc.view.alpha = 1.0f;
            
            //source view controller
            dashvc.transitioningView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
    
    if ([fromViewController isKindOfClass:[DetailChartViewController class]] && [toViewController isKindOfClass:[DashBoardViewController class]])
        
    {
        //Dismissing MapViewControll from ChatViewController
        DetailChartViewController* dvc = (DetailChartViewController*)fromViewController;
        DashboardTableViewController* dashvc = (DashboardTableViewController*)toViewController;
        //DashboardTableViewController* dashvc = (DashboardTableViewController*)fromViewController;
        
        CGRect transitioningFrame = [dashvc.transitioningView convertRect:dashvc.transitioningView.bounds toView:dashvc.view];//get the dashvc.transitoningview positon referencing to the dashvc.view
        
        //desination view controller
        dashvc.transitioningView.alpha = 0.0f;
        [containerView addSubview:dashvc.view];
        
        //source view controller
        dvc.view.alpha = 1.0f;
        [containerView insertSubview:dvc.view aboveSubview:dashvc.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            //source view controller
            dvc.view.transform = CGAffineTransformMakeScale(CGRectGetWidth(transitioningFrame) / CGRectGetWidth(containerView.bounds),
                                                            CGRectGetHeight(transitioningFrame) / CGRectGetHeight(containerView.bounds));
            dvc.view.frame = transitioningFrame;
            dvc.view.alpha = 0.0f;
            
            //desination view controller
            dashvc.transitioningView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
    }
    
#else
    if ([fromViewController isKindOfClass:[DashBoardViewController class]] && [toViewController isKindOfClass:[SplitViewController class]])
    {
        //Presenting DetailChartViewController from DashboardTableViewController
        SplitViewController* dvc = (SplitViewController*)toViewController;
        DashboardTableViewController* dashvc=(DashboardTableViewController*) fromViewController;
        //DashboardTableViewController* dashvc = [naviVC.viewControllers objectAtIndex:0 ];
        
        
        CGRect transitioningFrame = [dashvc.transitioningView convertRect:dashvc.transitioningView.bounds toView:dashvc.view];//get the dashvc.transitoningview positon referencing to the dashvc.view
        
        //Destination view controller
        dvc.view.transform = CGAffineTransformMakeScale(
                                                        CGRectGetWidth(transitioningFrame) / CGRectGetWidth(containerView.bounds),
                                                        CGRectGetHeight(transitioningFrame) / CGRectGetHeight(containerView.bounds));
        dvc.view.frame = transitioningFrame;
        dvc.view.alpha = 0.0f;
        
        //source view controller
        dashvc.transitioningView.alpha = 1.0f;
        
        [containerView insertSubview:dvc.view aboveSubview:dashvc.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            //Destination view controller
            dvc.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            dvc.view.frame = containerView.bounds;
            dvc.view.alpha = 1.0f;
            
            //source view controller
            dashvc.transitioningView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    
    
    if ([fromViewController isKindOfClass:[DetailChartViewController class]] && [toViewController isKindOfClass:[SplitViewController class]])
        
    {
        
        
        //Dismissing MapViewControll from ChatViewController
        DetailChartViewController* dvc = (DetailChartViewController*)fromViewController;
        SplitViewController* dashvc_parent = (SplitViewController*)toViewController;
        DashBoardViewController* dashvc=nil;
        if ([dashvc_parent isKindOfClass:[SplitViewController class]])
        {
            for (UIViewController* vc in dashvc_parent.viewControllers)
            {
                if ([vc isKindOfClass:[UINavigationController class]])
                    if ([((UINavigationController*)vc).topViewController isKindOfClass:[DashBoardViewController class]])
                    {
                        dashvc=(DashBoardViewController*)((UINavigationController*)vc).topViewController;
                        break;
                    }
            }
        }
        
        CGRect transitioningFrame = [dashvc.transitioningView convertRect:dashvc.transitioningView.bounds toView:dashvc.view];//get the dashvc.transitoningview positon referencing to the dashvc.view
        
        //desination view controller
        dashvc.transitioningView.alpha = 0.0f;
        //[containerView addSubview:dashvc.view];//?[containerView addSubview:dashvc_parent.view]
        [containerView addSubview:dashvc_parent.view];
        
        //source view controller
        dvc.view.alpha = 1.0f;
        //[containerView insertSubview:dvc.view aboveSubview:dashvc.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            //source view controller
            dvc.view.transform = CGAffineTransformMakeScale(CGRectGetWidth(transitioningFrame) / CGRectGetWidth(containerView.bounds),
                                                            CGRectGetHeight(transitioningFrame) / CGRectGetHeight(containerView.bounds));
            dvc.view.frame = transitioningFrame;
            dvc.view.alpha = 0.0f;
            
            //desination view controller
            dashvc.transitioningView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [fromViewController_topParent.view removeFromSuperview];
        }];
        
    }
#endif
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.45;
}







@end
