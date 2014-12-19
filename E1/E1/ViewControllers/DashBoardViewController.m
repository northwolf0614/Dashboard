//
//  DashBoardViewController.m
//  E1
//
//  Created by Jack Lin on 26/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//
//#import "DashboardTableViewController.h"
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
#import "SplitViewController.h"
#import "OutlinePresentationViewController.h"
#import "PageTableViewController.h"
#import "DoubleNChartWithLabelViewController.h"
#import "AnimatedTransitioningManager.h"
@interface DashBoardViewController()
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout* flowLayout;
@property (retain, nonatomic) UIPopoverController *masterPopoverController;
@property(nonatomic,assign) BOOL isInitial;
@property(nonatomic,strong) EmptyCollectionViewCell* emptyCell;


@end



@implementation DashBoardViewController
{
    float _beginTouchValue;
    UIScreenEdgePanGestureRecognizer* _leftEdgeGesture;
    UIPanGestureRecognizer* _panGestureRecognizer;

}
//-(void)presentViewControllerInteractive:(UIViewController *)viewControllerToPresent isInteractive:(BOOL)interactive completion:(void (^)(void))completion
//{
//    self.interactionController.interactive=interactive;
//    [self presentViewController:viewControllerToPresent animated:YES completion:completion];
//}
-(id)init
{
    if (self=[super init]) {
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScreenTouch:) name:@"mainWindowTouch" object:nil];
    }
    return self;
    
}
//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"mainWindowTouch" object:nil];
//    //[super dealloc];
//}
//
//-(void) onScreenTouch:(NSNotification *)notification
//{
//    UIEvent *event=[notification.userInfo objectForKey:@"data"];
//    UITouch *touch=[event.allTouches anyObject];
//    if(touch.tapCount==1)
//        NSLog(@"This is the entry of tap of collection view");
//    
//    
//    
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setItemSize:CGSizeMake(328,350)]; //设置每个cell显示数据的宽和高必须
    //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //水平滑动
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
    

    self.flowLayout.sectionInset = UIEdgeInsetsMake(kcCollectionViewCellPHSpace , kcCollectionViewCellPVSpace, kcCollectionViewCellPHSpace, kcCollectionViewCellPVSpace);
    
    
    //创建一屏的视图大小
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    
    //self.collectionView.collectionViewLayout=self.flowLayout;
    //对Cell注册(必须否则程序会挂掉)
    [self.collectionView registerClass:[GeneralCollectionViewCell class] forCellWithReuseIdentifier:[GeneralCollectionViewCell reuseIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:[EmptyCollectionViewCell reuseIdentifier] bundle:nil] forCellWithReuseIdentifier:[EmptyCollectionViewCell reuseIdentifier]];

    [self.collectionView setBackgroundColor:kcWholeBackColor];
    
    [self.collectionView setUserInteractionEnabled:YES];
    [self.collectionView setDelegate:(id)self];
    [self.collectionView setDataSource:(id)self];

    [self setupConstraints];
    
    //////////////////
    self.dashboardItemViewControllers = [NSMutableArray array];
    //self.view.backgroundColor=kcWholeBackColor;
    
    self.chartNames=[NSMutableArray array];
    [self.chartNames addObject:kcDefaultChartName];
    self.detailItem=kcDefaultChartName;//default page name
    //[self setupDefaultDataForDrawing];
    //[self loadChartData];
    //self.navigationController.delegate=self;
    //self.pushAnimation= [[PushAnimation alloc] init];
    //self.popAnimation= [[PopAnimation alloc] init];
    
    _leftEdgeGesture=[[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestures:)];
    _leftEdgeGesture.edges=UIRectEdgeRight;
    _leftEdgeGesture.delegate=self;
    [self.collectionView addGestureRecognizer:_leftEdgeGesture];
    self.isInitial=YES;
    
    
    
    
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskLandscapeLeft;
}


-(void)handleGestures:(UIPanGestureRecognizer*)gesture
{

     if ([self.collectionView isEqual: gesture.view])
     {
         
        UIView* view=[self.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];
        switch (gesture.state)
        {
            case UIGestureRecognizerStateBegan:
            {
                // 获取手势的触摸点坐标
                CGPoint location = [gesture locationInView:view];
                _beginTouchValue=location.x;
                if ([gesture isEqual:_leftEdgeGesture])
                {
    
                    PageTableViewController* pageVC=[[PageTableViewController alloc] initWithDetailController:self];
                    //pageVC.interactionController.interactive=YES;
                    pageVC.interactionController.interactive=NO;
                    pageVC.modalPresentationStyle = UIModalPresentationCustom;
                    [self presentViewController:pageVC animated:YES completion:^{}];

    
                }
                
                
            }
                break;
            case UIGestureRecognizerStateChanged:
            {
//                CGFloat completionRation=0;
//                CGPoint location = [gesture locationInView:view];
//                if ([gesture isEqual:_leftEdgeGesture])
//                    completionRation= fabs(_beginTouchValue-location.x)/KcPopoverWidth;
//                [self.interactionController updateInteractiveTransition:completionRation];
            }
                break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {
//                CGPoint location = [gesture locationInView:view];
//                CGFloat completionRation=0;
//
//                if ([gesture isEqual:_leftEdgeGesture])
//                    completionRation= fabs(_beginTouchValue-location.x)/KcPopoverWidth;
//                if (completionRation >= 0.5) {
//                    [self.interactionController finishInteractiveTransitionWithDuration:0.1];
//                } else {
//                    [self.interactionController cancelInteractiveTransitionWithDuration:0.1];
//                }

            }
                break;
            case UIGestureRecognizerStatePossible:
                break;
            case UIGestureRecognizerStateFailed:
                break;
            default:
                break;
        }
    }
   
    

}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem=nil;
        _detailItem = [newDetailItem copy];
        //self.navigationItem.title=_detailItem;
        [self setupDefaultDataForDrawing];
        //[self.collectionView reloadData];
    }
    
    
    if (self.masterPopoverController != nil)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}


-(void)setupDefaultDataForDrawing
{

    if (self.detailItem!=nil&&[self.detailItem isKindOfClass:[NSString class]])
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *userd = [userDefault dictionaryRepresentation];
        ChartDataManager* manager=[ChartDataManager defaultChartDataManager];
        if (![userd.allKeys containsObject:self.detailItem]&&[self.detailItem isEqualToString:kcDefaultChartName])//initially new page file
        {
            
            
            NSArray* chartsData=[NChartDataModel chartDataDefault];
            self.chartDataAssembly=[NSMutableArray arrayWithArray:chartsData];
            //[manager storeChartDataToFile:chartsData fileName:[NChartDataModel getStoredDefaultFilePath]];
            [manager storeChartDataToFile:chartsData fileName:[ChartDataManager getStoredFilePath:self.detailItem]];
            [self.dashboardItemViewControllers removeAllObjects];
            for (NChartDataModel* oneChartData in chartsData)
            {
                
                [self.dashboardItemViewControllers addObject:[[DoubleNChartWithLabelViewController alloc] initWithDrawingData:oneChartData delegateHolder:nil]];
                
            }
            [self.collectionView reloadData];
            
        }


        else
        {
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
            {
                NSArray* chartDataArray=[manager parseFromFile:[ChartDataManager getStoredFilePath:self.detailItem] ];
                

                //dispatch_async(dispatch_get_main_queue(), ^
                {
                    if (chartDataArray==nil)
                    {
//                        for (UIViewController* vc in self.childViewControllers)
//                        {
//                            
////                            for (UIView* view in ((DoubleNChartWithLabelViewController*)vc).contentView.subviews)
////                            {
////                                [view removeFromSuperview];
////                            }
////                            [vc.view removeFromSuperview];
//                            [vc removeFromParentViewController];
//                        }
                        [self.chartDataAssembly removeAllObjects];
                        [self.dashboardItemViewControllers removeAllObjects];
                        
                        
                    }
                    
                    else
                    {
//                        for (UIViewController* vc in self.childViewControllers) {
//                            
////                            for (UIView* view in ((DoubleNChartWithLabelViewController*)vc).contentView.subviews)
////                            {
////                                [view removeFromSuperview];
////                            }
////                            [vc.view removeFromSuperview];
//                            [vc removeFromParentViewController];
//                            
//                            
//                        }
                        [self.chartDataAssembly removeAllObjects];
                        self.chartDataAssembly=[NSMutableArray arrayWithArray:chartDataArray];
                        [self.dashboardItemViewControllers removeAllObjects];
                        for (NChartDataModel* dataForChart in chartDataArray)
                        {
                            
                            [self.dashboardItemViewControllers addObject:[[DoubleNChartWithLabelViewController alloc] initWithDrawingData:dataForChart delegateHolder:nil]];
                        }
                        
                        
                        
                    }
                    [self.collectionView reloadData];
                    
                    
                    
                    
                }
                //);
            }
           // );
            
            

        }
    }


    
}


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
    [self.collectionView reloadData];
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if (self.isInitial)
    {
        PageTableViewController* pageVC=[[PageTableViewController alloc] initWithDetailController:self];
        //UINavigationController* nav=[[UINavigationController alloc] initWithRootViewController:pageVC];
        pageVC.modalPresentationStyle = UIModalPresentationCustom;
        pageVC.interactionController.interactive=NO;
        //pageVC.detailViewController=self;
        //self.interactioinControllerDelegate=pageVC;
        [self presentViewController:pageVC animated:YES completion:nil];
        //[self presentViewControllerInteractive:pageVC isInteractive:NO completion:nil];
        self.isInitial=NO;
    }
    
    
    
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat v = 0;
    CGFloat h = 0;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        
        // 横屏的间距

        v = kcCollectionViewCellPVSpace;
        
        h = kcCollectionViewCellLHSpace;
        
        
        
    }
    else
    {
        v = kcCollectionViewCellPVSpace;
        h = kcCollectionViewCellPHSpace;
        
    }
    
    // 3.动画调整格子之间的距离
    
    [UIView animateWithDuration:1 animations:^{
        layout.sectionInset = UIEdgeInsetsMake(v, h, v, h);
        layout.minimumLineSpacing = v;
        
    }];
    
    
    

    
}
-(void)changeColorScheme:(BOOL)isWhiteSheme
{
    self.collectionView.backgroundColor=kcWholeBackColor;
    for (DoubleNChartWithLabelViewController* dVC in self.dashboardItemViewControllers)
    {
        dVC.chartView.chart.background = [NChartSolidColorBrush solidColorBrushWithColor:kcWidgetBackColor];
        dVC.label.backgroundColor=kcWidgetBackColor;
        dVC.contentView.backgroundColor=kcWidgetBackColor;
        if (dVC!=nil)
        {
            dVC.percentageView.chart.background = [NChartSolidColorBrush solidColorBrushWithColor:kcWidgetBackColor];
        }
        
        [dVC.naviBar setBarTintColor: kcNavigationBarColor];
        [dVC.naviBar setTranslucent: NO];
        [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance]  setShadowImage:[[UIImage alloc] init]];
        dVC.naviBar.titleTextAttributes=@{UITextAttributeTextColor:kcCharColor};
        
//        dVC.view.layer.borderWidth=isWhiteScheme? 0:1;
//        dVC.view.layer.borderColor=isWhiteScheme?nil:[[UIColor lightGrayColor] CGColor];

        
        
        
        
    }
    if (self.emptyCell!=nil)
    {
        self.emptyCell.backgroundColor=kcWidgetBackColor;
//        self.emptyCell.layer.borderWidth=isWhiteScheme? 0:1;
//        self.emptyCell.layer.borderColor=isWhiteScheme?nil:[[UIColor lightGrayColor] CGColor];
    }
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation

{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat v = 0;
    CGFloat h = 0;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {

        // 横屏的间距

        v = kcCollectionViewCellPVSpace;
        
        h = kcCollectionViewCellLHSpace;

        

    }
    else
    {
        v = kcCollectionViewCellPVSpace;
        h = kcCollectionViewCellPHSpace;

    }

    // 3.动画调整格子之间的距离

    [UIView animateWithDuration:1 animations:^{
        layout.sectionInset = UIEdgeInsetsMake(v, h, v, h);
        layout.minimumLineSpacing = v;

    }];
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

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
        cell.backgroundColor=kcWidgetBackColor;
        self.emptyCell=(EmptyCollectionViewCell*)cell;
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
    {
        detailViewController= [[DetailChartViewController alloc] initWithDrawingData:nil delegateHolder:nil];
        detailViewController.isAdded=YES;
        
    }
    
    else
    {
        detailViewController= [[DetailChartViewController alloc] initWithDrawingData:[self.chartDataAssembly objectAtIndex:indexPath.row] delegateHolder:nil];
        detailViewController.isAdded=NO;
    }
    
    detailViewController.transitioningDelegate=(id)self;
    detailViewController.modalTransitionStyle = UIModalPresentationCustom;
    self.transitioningView = cell;
    [self presentViewController:detailViewController animated:YES completion:nil];
    
    
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}


#pragma ChartSubviewControllerResponse
-(void)searchButtonClickedWithData:(NChartDataModel*)dataSubviewControllerHolding inView:(UIView *)contentView
{
    DetailChartViewController* detailViewController= [[DetailChartViewController alloc] initWithDrawingData:dataSubviewControllerHolding delegateHolder:nil];
    detailViewController.transitioningDelegate=(id)self;
    detailViewController.modalTransitionStyle = UIModalPresentationCustom;
    self.transitioningView=contentView;
    [self presentViewController:detailViewController animated:YES completion:nil];
    
    
    
    
}
//#pragma <UINavigationControllerDelegate>

//- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
//                                  animationControllerForOperation:(UINavigationControllerOperation)operation
//                                               fromViewController:(UIViewController *)fromVC
//                                                 toViewController:(UIViewController *)toVC
//{
//    if (operation == UINavigationControllerOperationPush) {
//        return self.pushAnimation;
//    }
//    else if (operation == UINavigationControllerOperationPop) {
//        return self.popAnimation;
//    }
//    
//    return nil;
//}
//
//- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
//    //return self.interactionController;
//    return nil;
//}

//#pragma mark - <UISplitViewControllerDelegate>

//- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
//{
//    barButtonItem.title = NSLocalizedString(@"Pages", @"Pages");
//    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
//    //popoverController.contentViewController is qual to master navigation controller
//    if ([popoverController.contentViewController isKindOfClass:[UINavigationController
//                                                                class]])
//    {
//        self.masterPopoverController = popoverController;
//    }
//}
//
//- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
//{
//    // Called when the view is shown again in the split view, invalidating the button and popover controller.
//    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
//    self.masterPopoverController = nil;
//}


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
    NSLog(@"this is animateTransition in DashBoardViewController");
    //Get references to the view hierarchy
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //UIViewController *fromViewController=fromViewController_topParent;
    
//    if ([fromViewController_topParent isKindOfClass:[UINavigationController class]])
//    {
//        fromViewController=((UINavigationController*)fromViewController_topParent).topViewController;
//
//    }
    //UIViewController *fromViewController = fromViewController_topParent.
    if ([fromViewController isKindOfClass:[DashBoardViewController class]] && [toViewController isKindOfClass:[DetailChartViewController class]])
    {
        //Presenting DetailChartViewController from DashboardTableViewController
        DetailChartViewController* dvc = (DetailChartViewController*)toViewController;
        DashBoardViewController* dashvc=(DashBoardViewController*) fromViewController;
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
        //UINavigationController* dashvc_parent = (DashBoardViewController*)toViewController;
        DashBoardViewController* dashvc=(DashBoardViewController*)toViewController;
//        if ([dashvc_parent isKindOfClass:[UINavigationController class]])
//        {
//            
//            dashvc=(DashBoardViewController*)((UINavigationController*)dashvc_parent).topViewController;
//            
//            
//        }
        
        CGRect transitioningFrame = [dashvc.transitioningView convertRect:dashvc.transitioningView.bounds toView:dashvc.view];//get the dashvc.transitoningview positon referencing to the dashvc.view
        
        //desination view controller
        dashvc.transitioningView.alpha = 0.0f;
        //[containerView addSubview:dashvc.view];//?[containerView addSubview:dashvc_parent.view]
        [containerView addSubview:dashvc.view];
        
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
            [dvc.view removeFromSuperview];
            if ([dvc shouldBeAddToPreviousPage])
            {
                [dashvc.dashboardItemViewControllers addObject:[[DoubleNChartWithLabelViewController alloc] initWithDrawingData:dvc.dataForNChart delegateHolder:nil]];
                [dashvc.chartDataAssembly addObject:dvc.dataForNChart];
                ChartDataManager* manager=[ChartDataManager defaultChartDataManager];
                //[manager syncwithPage:[NSString stringWithFormat:@"%lu",([dashvc.chartDataAssembly count])] withKey:dashvc.detailItem];
                [manager storeChartDataToFile:dashvc.chartDataAssembly fileName:[ChartDataManager getStoredFilePath:dashvc.detailItem]];
                
            }
            [transitionContext completeTransition:YES];

        }];
        
    }
    
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.45;
}







@end

