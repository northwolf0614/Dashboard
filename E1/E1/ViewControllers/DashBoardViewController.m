//
//  DashBoardViewController.m
//  E1
//
//  Created by Jack Lin on 26/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//
//#import "DashboardTableViewController.h"
//#import "DashboardTwinCell.h"
#import "DashboardItemViewController.h"
#import "Definations.h"
#import "GeneralNChartViewController.h"
#import "NChartDataModel.h"
#import "GeneralNChartWithLabelViewController.h"
#import "DoubleNChartWithLabelViewController.h"
//#import "DetailChartViewController.h"
#import "ChartDataManager.h"
#import "DashBoardViewController.h"
#import "GeneralCollectionViewCell.h"
#import "EmptyCollectionViewCell.h"
#import "SplitViewController.h"
#import "OutlinePresentationViewController.h"
#import "PageTableViewController.h"
#import "DoubleNChartWithLabelViewController.h"
#import "AnimatedTransitioningManager.h"
#import "OneViewCell.h"
#import "TwoViewCell.h"
#import "GerneralChartViewController.h"
#import "NChartViewCell.h"
#import "NChartDataModel.h"
#import "AbstractCollectionViewCell.h"
#import "DetailViewController.h"
#import "MeetingCoordinator.h"
@interface DashBoardViewController()
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout* flowLayout;
@property (retain, nonatomic) UIPopoverController *masterPopoverController;
@property(nonatomic,assign) BOOL isInitial;
@property(nonatomic,strong) EmptyCollectionViewCell* emptyCell;
@property(nonatomic,strong) NSMutableArray* controllerArray;
@property(nonatomic,strong) NSIndexPath* currentSelectPath;
@property(nonatomic,assign) BOOL isMeetingMode;
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
        self.controllerArray=[NSMutableArray array];
    }
    return self;
    
}
-(void)changeMeetingModelTo:(BOOL)meetingModelValue
{
    self.isMeetingMode=meetingModelValue;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.flowLayout=[[TLSpringFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.collectionView.pagingEnabled=NO;
    self.collectionView.delegate=self;
    [self.collectionView registerClass:[GeneralCollectionViewCell class] forCellWithReuseIdentifier:[GeneralCollectionViewCell reuseIdentifier]];
    [self.collectionView registerClass:[OneViewCell class] forCellWithReuseIdentifier:[OneViewCell reuseIdentifier]];
    [self.collectionView registerClass:[NChartViewCell class] forCellWithReuseIdentifier:[NChartViewCell reuseIdentifier]];
    [self.collectionView registerClass:[TwoViewCell class] forCellWithReuseIdentifier:[TwoViewCell reuseIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:[EmptyCollectionViewCell reuseIdentifier] bundle:nil] forCellWithReuseIdentifier:[EmptyCollectionViewCell reuseIdentifier]];
    [self.collectionView setBackgroundColor:kcWholeBackColor];
    [self.collectionView setUserInteractionEnabled:YES];
    [self.collectionView setDelegate:(id)self];
    [self.collectionView setDataSource:(id)self];
    [self.view addSubview:self.collectionView];
    self.chartNames=[NSMutableArray array];
    [self.chartNames addObject:kcDefaultPageName];
    self.detailItem=kcDefaultPageName;//default page name
    _leftEdgeGesture=[[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestures:)];
    _leftEdgeGesture.edges=UIRectEdgeRight;
    _leftEdgeGesture.delegate=self;
    [self.collectionView addGestureRecognizer:_leftEdgeGesture];
    self.isInitial=YES;
    
    
    
    
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskLandscape;
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
        if (![userd.allKeys containsObject:kcPagesArrayName]&&[self.detailItem isEqualToString:kcDefaultPageName])
        {
            
            
            NSArray* chartsData=[NChartDataModel chartDataDefault];
//            self.chartDataAssembly=[NSMutableArray arrayWithArray:chartsData];
//            self.chartsForDisplay=[NSMutableArray arrayWithObject:[self.chartDataAssembly objectAtIndex:0]];
            [manager storeChartDataToFile:chartsData fileName:[ChartDataManager getStoredFilePath:self.detailItem]];
            chartsData=[manager parseFromFile:[ChartDataManager getStoredFilePath:self.detailItem]];
            self.chartDataAssembly=[NSMutableArray arrayWithArray:chartsData];
            self.chartsForDisplay=[NSMutableArray arrayWithObject:[self.chartDataAssembly objectAtIndex:0]];
            
//             test
//             NSArray* chartForTest=[manager parseFromFile:[ChartDataManager getStoredFilePath:self.detailItem]];
            
            
            
            
            
            
            
            
        }
        else
        {
            
            {
                NSArray* chartDataArray=[manager parseFromFile:[ChartDataManager getStoredFilePath:self.detailItem]];
                
                {
                    if (chartDataArray==nil)
                    {

                        [self.chartDataAssembly removeAllObjects];
                        [self.chartsForDisplay removeAllObjects];
                        
                        for (GerneralChartViewController* dvc in self.childViewControllers)
                        {
                            [dvc.view removeFromSuperview];
                            [dvc removeFromParentViewController];
                        }
                        NChartDataModel* emptyData=[[NChartDataModel alloc] init];
                        emptyData.empty=YES;
                        [self.chartsForDisplay addObject:emptyData];
                    }
                    
                    else
                    {
                        [self.chartDataAssembly removeAllObjects];
                        [self.chartsForDisplay removeAllObjects];
                        for (GerneralChartViewController* dvc in self.childViewControllers)
                        {
                            [dvc.view removeFromSuperview];
                            [dvc removeFromParentViewController];
                        }
                        self.chartDataAssembly=[NSMutableArray arrayWithArray:chartDataArray];
                        if (self.chartDataAssembly.count==0)
                        {
                            NChartDataModel* emptyData=[[NChartDataModel alloc] init];
                            emptyData.empty=YES;
                            [self.chartsForDisplay addObject:emptyData];
                        }
                        else
                        {
                            NChartDataModel* o=[self.chartDataAssembly objectAtIndex:0];
                            self.chartsForDisplay=[NSMutableArray arrayWithObject:o];
                        }
                    }

                    
                    
                    
                    
                }
                //);
            }
           // );
            
            

        }
    }
    [self.collectionView reloadData];
    


    
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
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setupCellSize];
    [self setupConstraints];
        

}
-(void)setupCellSize
{
    NSUInteger gap=10;
    NSUInteger width=self.view.frame.size.width;
    NSUInteger height=self.view.frame.size.height;
    NSUInteger cellWidth=(NSUInteger)((width-4*gap)/3);
    NSUInteger cellHeight=(NSUInteger)((height-3*gap)/2);
    self.flowLayout.itemSize=CGSizeMake(cellWidth,cellHeight);
    self.flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(gap , gap, gap, gap);
    
}
-(void)viewDidAppear:(BOOL)animated
{

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


        v = kcCollectionViewCellPVSpace;
        h = kcCollectionViewCellLHSpace;
        
        
        
    }
    else
    {
        v = kcCollectionViewCellPVSpace;
        h = kcCollectionViewCellPHSpace;
        
    }

    
    [UIView animateWithDuration:1 animations:^{
        layout.sectionInset = UIEdgeInsetsMake(v, h, v, h);
        layout.minimumLineSpacing = v;
        
    }];
    
    
    

    
}
-(void)changeColorScheme:(BOOL)isWhiteSheme
{

    self.collectionView.backgroundColor=kcWholeBackColor;
    NSArray* visibleCells=[self.collectionView visibleCells];
    for (AbstractCollectionViewCell* cell in visibleCells) {
        //if ([cell respondsToSelector:@selector(updateColorScheme)])
        {
            [cell updateColorScheme];
        }
    }
    
    
    
    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation

{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat v = 0;
    CGFloat h = 0;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {

        v = kcCollectionViewCellPVSpace;
        h = kcCollectionViewCellLHSpace;

        

    }
    else
    {
        v = kcCollectionViewCellPVSpace;
        h = kcCollectionViewCellPHSpace;

    }
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
    
    return ([self.chartsForDisplay count]);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell=nil;
    NChartDataModel* data=[self.chartsForDisplay objectAtIndex:indexPath.row];
    if (data.empty)
    {
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([EmptyCollectionViewCell class])  forIndexPath:indexPath];
        cell.backgroundColor=kcWidgetBackColor;
        self.emptyCell=(EmptyCollectionViewCell*)cell;
        return cell;
    }
    else
    {
        NChartDataModel* chartData=[self.chartsForDisplay objectAtIndex:indexPath.row];
        if (chartData.dataForNextView!=nil)
        {
            
            cell=(TwoViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TwoViewCell class]) forIndexPath:indexPath];
            ((TwoViewCell*)cell).yearLabel.text=chartData.labelText;
             GerneralChartViewController* itemViewController=[[GerneralChartViewController alloc] initWithDrawingData:[self.chartsForDisplay objectAtIndex:indexPath.row] views:[NSArray arrayWithObjects:((TwoViewCell*)cell).chartView,((TwoViewCell*)cell).percentageView,((TwoViewCell*)cell).controllerView,nil] index:indexPath mainView:collectionView];
            
            itemViewController.delegate=self;
            [((TwoViewCell*)cell).chartView setupDelegate:itemViewController];
            ((TwoViewCell*)cell).percentageView.delegate=itemViewController;
            if (chartData.isAnimated)
            {
                [((TwoViewCell*)cell).chartView updateData];
                [((TwoViewCell*)cell).percentageView updateData];

            }
            ((TwoViewCell*)cell).title.text=chartData.chartCaption;
            [self addChildViewController:itemViewController];
            [((TwoViewCell*)cell).contentView addSubview:itemViewController.view];
            [itemViewController didMoveToParentViewController:self];

        }
        else
        {
            if (chartData.floatingNumber!=nil)
            {
                cell=(OneViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([OneViewCell class]) forIndexPath:indexPath];
                ((OneViewCell*)cell).yearLabel.text=chartData.labelText;
                GerneralChartViewController* itemViewController=[[GerneralChartViewController alloc] initWithDrawingData:[self.chartsForDisplay objectAtIndex:indexPath.row] views:[NSArray arrayWithObjects:((OneViewCell*)cell).chartView,((OneViewCell*)cell).controllerView,nil] index:indexPath mainView:collectionView];
                
                itemViewController.delegate=self;
                [((OneViewCell*)cell).chartView setupDelegate:itemViewController];
                if (chartData.isAnimated)
                    [((OneViewCell*)cell).chartView updateData];
                ((OneViewCell*)cell).title.text=chartData.chartCaption;
                
                [self addChildViewController:itemViewController];
                [((OneViewCell*)cell).contentView addSubview:itemViewController.view];
                [itemViewController didMoveToParentViewController:self];
            }
            else
            {
                cell=(NChartViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NChartViewCell class]) forIndexPath:indexPath];
                ((NChartViewCell*)cell).yearLabel.text=chartData.labelText;
                GerneralChartViewController* itemViewController=[[GerneralChartViewController alloc] initWithDrawingData:[self.chartsForDisplay objectAtIndex:indexPath.row] views:[NSArray arrayWithObjects:((NChartViewCell*)cell).chartView,((NChartViewCell*)cell).controllerView,nil] index:indexPath mainView:collectionView];
                
                itemViewController.delegate=self;
                [((NChartViewCell*)cell).chartView setupDelegate:itemViewController];
                if (chartData.isAnimated)
                    [((NChartViewCell*)cell).chartView updateData];
                ((NChartViewCell*)cell).title.text=chartData.chartCaption;
                
                
                [self addChildViewController:itemViewController];
                [((NChartViewCell*)cell).contentView addSubview:itemViewController.view];
                [itemViewController didMoveToParentViewController:self];
                
            }

        }

        
        
        return cell;
    }
    
    
}
#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    //NSLog(@"did selected on %ld", indexPath.item);
    //DetailChartViewController* detailViewController=nil;
    self.currentSelectPath=indexPath;
    DetailViewController* detailViewController=nil;
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    UICollectionViewCell* cell=[collectionView cellForItemAtIndexPath:indexPath];
    NSUInteger count=self.chartDataAssembly.count;
    NSString* file=[ChartDataManager getStoredFilePath:self.detailItem];
    if (count==indexPath.row)
    {
        
        if (!_isMeetingMode) {
            detailViewController=[[DetailViewController alloc] initWithDrawingData:nil isAddedChart:YES page:[file lastPathComponent]];
        }
        else
            detailViewController=[[MeetingCoordinator alloc] initWithDrawingData:nil isAddedChart:YES page:[file lastPathComponent]];
    
        
        
    }
    
    else
    {
//        if (!_isMeetingMode)
//        {
            NChartDataModel* data=[self.chartDataAssembly objectAtIndex:indexPath.row];
            detailViewController=[[DetailViewController alloc] initWithDrawingData:data isAddedChart:NO page:[file lastPathComponent]];
//        }
//        else
//            detailViewController=[[MeetingCoordinator alloc] initWithDrawingData:[self.chartDataAssembly objectAtIndex:indexPath.row] isAddedChart:NO page:[file lastPathComponent]];
        
        
        
    }
    
    detailViewController.transitioningDelegate=(id)self;
    detailViewController.modalTransitionStyle = UIModalPresentationCustom;
    self.transitioningView = cell;
    [self presentViewController:detailViewController animated:YES completion:nil];
    
    
    
}
- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"This is didEndDisplayingCell ");
    if ([cell isKindOfClass:[CollectionViewCell class]]) {
        for (GerneralChartViewController* dvc in self.childViewControllers)
        {
            if ([((CollectionViewCell*)cell).viewContainer.subviews containsObject:dvc.chartView]) {
                [dvc.view removeFromSuperview];
                [dvc removeFromParentViewController];
            }
        }
    }
    
  
}

- (void)collectionView:(UICollectionView *)collectionView
  willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"This is willDisplayCell ");
}




- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}


#pragma ChartSubviewControllerResponse
-(void)searchButtonClickedWithData:(NChartDataModel*)dataSubviewControllerHolding inView:(UIView *)contentView
{
//    DetailViewController* detailViewController= [[DetailViewController alloc] initWithDrawingData:dataSubviewControllerHolding delegateHolder:nil];
//    detailViewController.transitioningDelegate=(id)self;
//    detailViewController.modalTransitionStyle = UIModalPresentationCustom;
//    self.transitioningView=contentView;
//    [self presentViewController:detailViewController animated:YES completion:nil];
    
    
    
    
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
    NSLog(@"this is animateTransition in DashBoardViewController");
    //Get references to the view hierarchy
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([fromViewController isKindOfClass:[DashBoardViewController class]] && [toViewController isKindOfClass:[DetailViewController class]])
    {
        //Presenting DetailChartViewController from DashboardTableViewController
        DetailViewController* dvc = (DetailViewController*)toViewController;
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
    
    if ([fromViewController isKindOfClass:[DetailViewController class]] && [toViewController isKindOfClass:[DashBoardViewController class]])
        
    {
        DetailViewController* dvc = (DetailViewController*)fromViewController;
        DashBoardViewController* dashvc=(DashBoardViewController*)toViewController;
        CGRect transitioningFrame = [dashvc.transitioningView convertRect:dashvc.transitioningView.bounds toView:dashvc.view];//get the dashvc.transitoningview positon referencing to the dashvc.view
        dashvc.transitioningView.alpha = 0.0f;
        
        [containerView addSubview:dashvc.view];
        dvc.view.alpha = 1.0f;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            //source view controller
            dvc.view.transform = CGAffineTransformMakeScale(CGRectGetWidth(transitioningFrame) / CGRectGetWidth(containerView.bounds),
                                                            CGRectGetHeight(transitioningFrame) / CGRectGetHeight(containerView.bounds));
            
            dvc.view.frame = transitioningFrame;
            dvc.view.alpha = 0.0f;
            dashvc.transitioningView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [dvc.view removeFromSuperview];
            RESULT r=[dvc shouldBeAddToPreviousPage];
            ChartDataManager* manager=[ChartDataManager defaultChartDataManager];
            switch (r)
            {
                case SHOULD_INSERT:
                {
                    NSInteger index=dashvc.chartDataAssembly.count;
                    NSString* file=[ChartDataManager getStoredFilePath:dashvc.detailItem];
                    NSManagedObjectID* oID=[manager insertChartData:dvc.dataForNChart pageName:file.lastPathComponent];
                    NChartDataModel* newInsertedObject=[manager dataFetchRequestByObjectID:oID];
                    [dashvc.chartDataAssembly addObject:newInsertedObject];
                    [dashvc.chartsForDisplay insertObject:newInsertedObject atIndex:index];
                    [dashvc.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:index inSection:0]]];
                }
                    break;
                    
                case SHOULD_UPDATE:
                {
                    NSInteger index=self.currentSelectPath.row;
                    [dashvc.chartDataAssembly setObject:dvc.dataForNChart atIndexedSubscript:index];
                    [dashvc.chartsForDisplay setObject:dvc.dataForNChart atIndexedSubscript:index];
                    [dashvc.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]]];
                    [manager updateChartData:dvc.dataForNChart page:[ChartDataManager getStoredFilePath:dashvc.detailItem].lastPathComponent];
                }
                    break;
                case SHOULD_NONE:
                    break;
                    
                default:
                    break;
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


#pragma mark <childControllerDelegate>
-(void)allAnimatingFinished
{
    NSInteger index=[self.chartsForDisplay count];
    if (index<self.chartDataAssembly.count)
    {

        [self.chartsForDisplay addObject:[self.chartDataAssembly objectAtIndex:index]];
        [self.collectionView reloadData];
    }
    
}

-(void)allAnimationsFinished
{
    NSInteger index=[self.chartsForDisplay count];
    NSInteger indexOfAssembly=[self.chartDataAssembly count];
    if (index<indexOfAssembly)
        if (index<kcMaxCellsinOneScreen||(index>6&&index%3!=0))
        {

            if (index<self.chartDataAssembly.count)
            {
                
                [self.chartsForDisplay addObject:[self.chartDataAssembly objectAtIndex:index]];
                [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:index inSection:0]]];
                
            }
            
        }
    
    if (index==indexOfAssembly)
    {
        NChartDataModel* emptyData=[[NChartDataModel alloc] init];
        emptyData.empty=YES;
        
        [self.chartsForDisplay addObject:emptyData];
        [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:index inSection:0]]];
        
    }
}
-(void)setAnimationStatus:(GerneralChartViewController*)vc value:(BOOL)isAnimating
{
    if ([self.childViewControllers containsObject:vc])
    {
        self.isAnimating=isAnimating;
    }
}
#pragma <UIScrollViewDelegate>

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    if (scrollView.contentOffset.y + scrollView.frame.size.height >= (scrollView.contentSize.height+kcOffsetBuffer)&&!self.isAnimating)
    {
        NSInteger index=[self.chartsForDisplay count];
        if (index<self.chartDataAssembly.count)
        {
            
            [self.chartsForDisplay addObject:[self.chartDataAssembly objectAtIndex:index]];
            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:index inSection:0]]];
        }
        if (index==self.chartDataAssembly.count)
        {
            
            NChartDataModel* emptyData=[[NChartDataModel alloc] init];
            emptyData.empty=YES;
            [self.chartsForDisplay addObject:emptyData];
            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:index inSection:0]]];
        }
    }
}





@end

