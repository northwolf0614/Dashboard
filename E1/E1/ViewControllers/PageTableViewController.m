//
//  PageTableViewController.m
//  E1
//
//  Created by Jack Lin on 20/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "PageTableViewController.h"
#import "Definations.h"
#import "SplitViewController.h"
#import "AlertController.h"
#import "OutlinePresentationViewController.h"
#import "ChartDataManager.h"
#import "SwitchCell.h"
#import "CATransform3DPerspect.h"
#import "AnimatedTransitioningManager.h"

@interface PageTableViewController ()<UINavigationBarDelegate>
@property(nonatomic,strong) NSMutableArray* pagesNameArray;
@property(nonatomic,strong) UIAlertController* alertViewController;
@property(nonatomic,strong) UIVisualEffectView* visualEfView;
@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) NSIndexPath* currentPath;
@property(nonatomic,strong) UIImageView* imageView;
@property(nonatomic,strong) UISwitch* colorSwitch;
@property(nonatomic,strong) UISwitch* meetingSwitch;
@property(nonatomic,assign) BOOL isMeetingModel;
@property(nonatomic,assign) BOOL colorScheme;





//@property(nonatomic,strong)(id<UIViewControllerContextTransitioning>)transitionContext
@end

@implementation PageTableViewController
{
    id<UIViewControllerContextTransitioning> _context;
    UIPanGestureRecognizer* _panGestureRecognizer;
    float  _beginTouchValue;
    
}


//-(id)init
//{
//    if (self=[super init]) {
//        self.interactionController = [[AnimatedTransitioningManager alloc] init];
//        self.transitioningDelegate=self.interactionController;
//        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScreenTouch:) name:@"mainWindowTouch" object:nil];
//    }
//    return self;
//    
//}
-(id)initWithDetailController:(UIViewController*)detailController
{
    if (self=[super init]) {
        self.interactionController = [[AnimatedTransitioningManager alloc] init];
        self.transitioningDelegate=self.interactionController;
        self.detailViewController=(DashBoardViewController*)detailController;
        self.detailViewController.interactionController=self.interactionController;
        self.isMeetingModel=NO;
        self.colorScheme=YES;
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onScreenTouch:) name:@"mainWindowTouch" object:nil];
    }
    return self;
    
}

//-(void)dealloc
//{
//    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"mainWindowTouch" object:nil];
//    //[super dealloc];
//}

//-(void) onScreenTouch:(NSNotification *)notification
//{
//    UIEvent *event=[notification.userInfo objectForKey:@"data"];
//    UITouch *touch=[event.allTouches anyObject];
//    
//    if (touch.view!=self.tableView) {
//        [self dismissViewControllerAnimated:YES
//                                 completion:^{
//                                     
//                                 }];
//    }
//    
//}

- (void)loadView
{
    [super loadView];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PageTableViewController class]) owner:self options:nil];
    self.view = [nibs objectAtIndex:0];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.delegate = self;
    
    //self.view set
    self.visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    self.tableView=[[UITableView alloc] init];
    self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
    self.visualEfView.translatesAutoresizingMaskIntoConstraints=NO;
    self.visualEfView.alpha = 1.0;
    [self.visualEfView addSubview:self.tableView];
    
//    [self.view addSubview: self.visualEfView];
//    self.view.backgroundColor=[UIColor clearColor];
    self.view.backgroundColor=[UIColor clearColor];
    [self.containerView addSubview: self.visualEfView];
    self.containerView.backgroundColor=[UIColor clearColor];

    
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=(id)self;
    self.tableView.dataSource=(id)self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SwitchCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SwitchCell class])];
    [self setupConstraints];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.naviItem.title=kcMasterTitle;
    UIImageView* imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"QBELogoPart1"]];
    float width=2*self.navigationBar.frame.size.height/3;
    float height=width;
    CGPoint centerPoint=self.navigationBar.center;
    [imgView setFrame:CGRectMake(centerPoint.x, centerPoint.y, width, height)];
    imgView.contentMode=UIViewContentModeScaleAspectFit;
    self.naviItem.titleView =imgView;
    UIBarButtonItem* rightBarButtonItem=[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleRightButtonItem:)];
    //self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    self.naviItem.rightBarButtonItem = rightBarButtonItem;


    UIBarButtonItem* leftBarButtonItem =[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(handleLeftButtonItem:)];
    //self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.naviItem.leftBarButtonItem = leftBarButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QBEPagesNames"];
    [self setupPages];
    [self initAddDialog];
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(handlePans:)];
    _panGestureRecognizer.maximumNumberOfTouches = 1;
    _panGestureRecognizer.minimumNumberOfTouches = 1;
    _panGestureRecognizer.delegate=self;
    //[self.tableView addGestureRecognizer:swipeGestureRecognizer];
    //[self.tableView addGestureRecognizer:_panGestureRecognizer];
    
    UISwipeGestureRecognizer* swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(handleSwipes:)];
    // 定义滑动方向，即：向X滑动
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    // 几个手指
    swipeGestureRecognizer.numberOfTouchesRequired = 1;
    // 将手势添加到某个UI上
    [self.tableView addGestureRecognizer:swipeGestureRecognizer];
}
- (void) handlePans:(UIPanGestureRecognizer *)recognizer
{
    
    UIView* view = self.tableView;
    CGPoint location = [recognizer locationInView:view];
    CGPoint translation = [recognizer translationInView:view];
    NSLog(@"locatioin is %@",NSStringFromCGPoint(location));
    NSLog(@"translation is %@",NSStringFromCGPoint(translation));
    //if (location.x>0)
    {
        switch (recognizer.state)
        {
            case UIGestureRecognizerStateBegan:
            {
                
                
                if ([recognizer isEqual:_panGestureRecognizer])
                {
                   // if ((location.x-_beginTouchValue)>0)
                    {
                    
                        _beginTouchValue=location.x;
                        //self.interactionController.interactive=YES;
                        self.interactionController.interactive=NO;
                        [self dismissViewControllerAnimated:YES completion:^{
                            
                        }];
                    }

                    
                }
                
            }
            break;
            case UIGestureRecognizerStateChanged:
            {
                //if ((location.x-_beginTouchValue)>0)
//                {
//                    CGPoint translation = [recognizer translationInView:view];
//                    //
//                    CGFloat distanceRation = fabs(translation.x / CGRectGetWidth(view.bounds));
//                    [self.interactionController updateInteractiveTransition:distanceRation];
//                }
            }
            break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {
                //if ((location.x-_beginTouchValue)>0)
//                {
//                    CGPoint translation = [recognizer translationInView:view];
//                    CGFloat distance = fabs(translation.x / CGRectGetWidth(view.bounds));
//                    if (distance >= 0.5) {
//                        [self.interactionController finishInteractiveTransitionWithDuration:0.1];
//                    }
//                    else
//                    {
//                        [self.interactionController cancelInteractiveTransitionWithDuration:0.1];
//                    }
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
- (void) handleSwipes:(UISwipeGestureRecognizer *)paramSender
{
    if (paramSender.direction & UISwipeGestureRecognizerDirectionDown){
        NSLog(@"Swiped Down.");
    }
    if (paramSender.direction & UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"Swiped Left.");
    }
    if (paramSender.direction & UISwipeGestureRecognizerDirectionRight){
        NSLog(@"Swiped Right.");
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    if (paramSender.direction & UISwipeGestureRecognizerDirectionUp){
        NSLog(@"Swiped Up.");
    }
}



-(void)setupConstraints
{
    [self.visualEfView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:0 views:@{ @"tableView" : self.tableView,@"effectView" : self.visualEfView }]];
    
    [self.visualEfView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:0 views:@{ @"tableView" : self.tableView,@"effectView" : self.visualEfView }]];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[effectView]-0-|" options:0 metrics:0 views:@{ @"tableView" : self.tableView,@"effectView" : self.visualEfView }]];
    
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[effectView]-0-|" options:0 metrics:0 views:@{ @"tableView" : self.tableView,@"effectView" : self.visualEfView }]];
    [self.containerView setNeedsLayout];
    [self.visualEfView setNeedsLayout];
    
}

-(void)selectAtRow:(NSInteger)row inView:(UITableView*)view
{
    if ([view isKindOfClass:[UITableView class]])
    {
        NSIndexPath *ip=[NSIndexPath indexPathForRow:row inSection:0];
        [view selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self tableView:view didSelectRowAtIndexPath:ip];

    }
}
-(CGRect)forcastRect:(UITableView*)aTableView
{
    if ([aTableView numberOfSections]>1)
    {
        return CGRectZero;
        
    }
    NSInteger cellNumber=[aTableView numberOfRowsInSection:0];
    UITableViewCell* aCell=[aTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellNumber-1 inSection:0]];
    
    CGRect rect= [aCell convertRect:aCell.bounds toView:aTableView];
    rect.origin.x=self.presentingViewController.view.bounds.size.width-0.5*KcPopoverWidth;
    return rect;
    
    
}
-(void)initAddDialog
{

    //NSString* inputPageName=nil;
    self.alertViewController=[UIAlertController alertControllerWithTitle:@"Page Name" message:@"Duplicated name result radom number appended" preferredStyle:UIAlertControllerStyleAlert];
    //_weak id weakself=self;
    [self.alertViewController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder=@"Name";
    }];
//    //self.alertViewController.transitionCoordinator
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
//    {
//        self.isApplyPressed=NO;
////        [self.alertViewController dismissViewControllerAnimated:YES completion:^{
////            
////        }];
//
//        
//        
//    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Apply" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
        UITextField* name = self.alertViewController.textFields.firstObject;
        if (![self.pagesNameArray containsObject:name.text])
        {
            
            [self.pagesNameArray addObject:name.text];
            [self syncWithUserDefault:self.pagesNameArray];
            
//            NSString* filePath=[ChartDataManager  getStoredFilePath:name.text];
//            NChartDataModel* chartData=[[NChartDataModel alloc] init];
//            chartData.empty=YES;
//            [[ChartDataManager defaultChartDataManager] storeChartDataToFile:[NSArray arrayWithObject:chartData] fileName:filePath];//new a empty file for chart
            
            [self.tableView reloadData];
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.pagesNameArray count]-1 inSection:0]];
            
            
            
            
        }
        else
        {
            while ([self.pagesNameArray containsObject:name.text])
            {
                NSString* randString=[NSString stringWithFormat:@"%d",(rand() % 100) ];
                name.text=[name.text stringByAppendingString:randString];
                
                
            }
            [self.pagesNameArray addObject:name.text];
            [self.tableView reloadData];
        }
        [self.alertViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }];
    [self.alertViewController addAction:okAction];
    
    self.alertViewController.modalTransitionStyle = UIModalPresentationCustom;
    self.alertViewController.transitioningDelegate=self;
    

        

    
    
    
}
-(void)handleRightButtonItem:(id)sender
{
    if ([sender isKindOfClass:[UIBarButtonItem class]])
    {
        [self presentViewController:self.alertViewController animated:YES completion:nil];
    }

    
        
    

    

}
-(void)handleLeftButtonItem:(id)sender
{


}



-(void)setupPages
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userd = [userDefault dictionaryRepresentation];
    //ChartDataManager* manager=[ChartDataManager defaultChartDataManager];
    if ([userd.allKeys containsObject:kcPagesArrayName])
    {
        self.pagesNameArray= [[NSMutableArray alloc] initWithArray:[userd objectForKey:kcPagesArrayName]];
    }
    else//there are default data in defualts for display
    {
        self.pagesNameArray=[NSMutableArray array];
        [self.pagesNameArray addObject:kcDefaultPageName];
        
        [userDefault setObject:self.pagesNameArray forKey:kcPagesArrayName];
        [userDefault synchronize];
         
        
        
    }
    
}
-(void)syncWithUserDefault:(NSMutableArray*)data
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userd = [userDefault dictionaryRepresentation];
    if ([userd.allKeys containsObject:kcPagesArrayName])
    {
        [userDefault setObject:data forKey:kcPagesArrayName];
        [userDefault synchronize];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -<UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //return [self.pagesNameArray count];
    return ([self.pagesNameArray count]+1+1);//one for color scheme and the other for meeting model
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kcPageTableCellHeight;

}
#pragma mark -<UITableViewDelegate>
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        //if (indexPath.row==0)
        if (indexPath.row==0||indexPath.row==self.pagesNameArray.count)
        {
            return UITableViewCellEditingStyleNone;
        }
        else
            return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        if (indexPath.row<[self.pagesNameArray count]&&![self.currentPath isEqual:indexPath])
        {
            [ChartDataManager deleteChartFile:[self.pagesNameArray objectAtIndex:indexPath.row]];
            [self.pagesNameArray removeObjectAtIndex:indexPath.row];
            [self syncWithUserDefault:self.pagesNameArray];
            
            
            
            
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];

        }
        else
        {
            
        }
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=nil;
    if (indexPath.row<self.pagesNameArray.count)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"QBEPagesNames"] ;
        cell.textLabel.text=[self.pagesNameArray objectAtIndex:indexPath.row];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.backgroundColor=[UIColor clearColor];
    }
    else if(indexPath.row==self.pagesNameArray.count)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SwitchCell class])];
        ((SwitchCell*)cell).seriesName.text=@"Light-Dark";
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        ((SwitchCell*)cell).seriesSwitch.enabled=YES;
        ((SwitchCell*)cell).delegate=self;
        ((SwitchCell*)cell).seriesSwitch.on=_colorScheme;
        _colorSwitch=((SwitchCell*)cell).seriesSwitch;
        
        
        
    }
    else
    {
        cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SwitchCell class])];
        ((SwitchCell*)cell).seriesName.text=@"Meeting Mode";
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        ((SwitchCell*)cell).seriesSwitch.enabled=YES;
        ((SwitchCell*)cell).delegate=self;
        ((SwitchCell*)cell).seriesSwitch.on=_isMeetingModel;
        _meetingSwitch=((SwitchCell*)cell).seriesSwitch;
    }
    
        
                             
    
    
    return cell;
    
    
    
    
    
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<self.pagesNameArray.count)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.currentPath=indexPath;
        NSString* detailItem= [self.pagesNameArray objectAtIndex:indexPath.row];
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    //    {
    //        self.detailViewController = [[DashBoardViewController alloc] init] ;
    //        self.detailViewController.detailItem = detailItem;
    //        UINavigationController* detailNavigationController=[[self.navigationController.splitViewController viewControllers] objectAtIndex:1];
    //        [detailNavigationController pushViewController:self.detailViewController animated:YES];
    //    }
    //    else
        {
            if (![self.detailViewController.detailItem isEqualToString:detailItem])
            {
                self.detailViewController.detailItem = detailItem;

            }
            
        }
        self.interactionController.interactive=NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}




#pragma mark <UIViewControllerAnimatedTransitioning>

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSLog(@"this is animateTransition in PageTableViewController");
    //Get references to the view hierarchy
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([fromViewController isKindOfClass:[UINavigationController class]])
    {
        fromViewController=((UINavigationController*)fromViewController).topViewController;
        
    }
    if ([toViewController isKindOfClass:[UINavigationController class]])
    {
        toViewController=((UINavigationController*)toViewController).topViewController;
        
    }

    
        if ([toViewController isKindOfClass:[UIAlertController class]])
        {
            UIAlertController* alvc = (UIAlertController*)toViewController;
            [[transitionContext containerView] addSubview:alvc.view];
            alvc.view.transform = CGAffineTransformMakeScale(0.1,0.1);
            alvc.view.center=containerView.center;
            alvc.view.alpha = 0.0f;
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                //MVC
                //if (self.isApplyPressed) {
                    alvc.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    alvc.view.alpha = 1.0f;
                    alvc.view.center=containerView.center;
                //}
                //else
    
    
    
    
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
                //CGRect rect=alvc.view.frame;
            }];
        }
    
        if ([fromViewController isKindOfClass:[UIAlertController class]] )
        {
            //Dismissing MapViewControll from ChatViewController
            UIAlertController* alvc = (UIAlertController*)fromViewController;
            alvc.view.alpha = 1.0f;
            //if (self.isApplyPressed)
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    
    
                    alvc.view.transform = CGAffineTransformMakeScale(0.1,0.1);
                    CGRect rect=[self forcastRect:self.tableView];
                    float x=CGRectGetMidX(rect);
                    float y=CGRectGetMidY(rect);
                    y+=kcPageTableCellHeight*1/2;
                    alvc.view.frame = CGRectMake(x, y, 20, 20);
                    alvc.view.alpha = 0.0f;
                            //CVC
                //cvc.transitioningView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                
                //[alvc.view removeFromSuperview];
                [transitionContext completeTransition:YES];
                
            }];
    
            
        }

}

- (void)animationEnded:(BOOL)transitionCompleted
{
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.45;
}
#pragma <UINavigationBarDelegate>
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
    return UIBarPositionTopAttached;
}
#pragma <SwitchDelegate>
-(void)switchValueChaged:(BOOL)isOn sender:(id)sender
{
    NSLog(@"this is the call from switch");
    if ([_colorSwitch isEqual:sender]) {
        _colorScheme=isOn;
        [self.detailViewController changeColorScheme:isOn];
    }
    if ([_meetingSwitch isEqual:sender]) {
        _isMeetingModel=isOn;
        [self.detailViewController changeMeetingModelTo:isOn];
        
    }
    
    
        
    
    
    
    
    
}


#pragma <CAAnimationDelegate>
//- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
//{
//    if ([[animation valueForKey:@"pagingClose"] isEqualToString:@"pagingAnimationClose"])
//        
//    {
//        if (flag) {
//            NSLog(@"animation pagingClose completed!");
//            [_context completeTransition:YES];
//            self.view.alpha=0;
//        }
//        
//    }
//    if ([[animation valueForKey:@"pagingOpen"] isEqualToString:@"pagingAnimationOpen"])
//        
//    {
//        if (flag) {
//            NSLog(@"animation pagingOpen completed!");
//            [_context completeTransition:YES];
//        }
//        
//    }
//    
//    
//    
//}
//-(void)animationDidStart:(CAAnimation *)animation
//{
//    
//    
//}
#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    if (gestureRecognizer == _gestureRecognizerForMainView) {
//        return YES;
//    }
//    if (gestureRecognizer == _gestureRecognizerForSideMenu) {
//        return otherGestureRecognizer == self.sideMenuViewController.scrollView.panGestureRecognizer;
//    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    if (gestureRecognizer == _gestureRecognizerForMainView) {
//        return YES;
//    }
//    if (gestureRecognizer == _gestureRecognizerForSideMenu) {
//        return [self.sideMenuViewController didScrollToEnd] || [_gestureRecognizerForSideMenu locationInView:self.containerView].x > CGRectGetMinX(self.mainViewController.view.frame);
//    }
    return YES;
}
#pragma mark <UIViewControllerTransitioningDelegate>


- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source
{
    return nil;
}

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

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return  nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}

@end
