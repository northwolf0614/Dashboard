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

@interface PageTableViewController ()
@property(nonatomic,strong) NSMutableArray* pagesNameArray;
@property(nonatomic,strong) UIAlertController* alertViewController;
@property(nonatomic,strong) UIVisualEffectView* visualEfView;
@property(nonatomic,strong) UITableView* tableView;
//@property(nonatomic,strong) UIAlertController* alertViewController;
@end

@implementation PageTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

     self.visualEfView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
     self.tableView=[[UITableView alloc] init];
     self.tableView.translatesAutoresizingMaskIntoConstraints=NO;
     self.visualEfView.translatesAutoresizingMaskIntoConstraints=NO;
     self.visualEfView.alpha = 1.0;
     [self.visualEfView addSubview:self.tableView];
     [self.view addSubview: self.visualEfView];
     self.tableView.backgroundColor=[UIColor clearColor];
     self.tableView.delegate=(id)self;
     self.tableView.dataSource=(id)self;
    [self setupConstraints];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    


     
    //self.tableView.backgroundColor=[UIColor clearColor];
    self.navigationItem.title=kcMasterTitle;
    UIBarButtonItem* rightBarButtonItem=[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    UIBarButtonItem* leftBarButtonItem =[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(handleLeftButtonItem:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QBEPagesNames"];
    [self setupPages];
    [self initAddDialog];
}
-(void)setupConstraints
{
    [self.visualEfView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:0 views:@{ @"tableView" : self.tableView,@"effectView" : self.visualEfView }]];
    
    [self.visualEfView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:0 views:@{ @"tableView" : self.tableView,@"effectView" : self.visualEfView }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[effectView]-0-|" options:0 metrics:0 views:@{ @"tableView" : self.tableView,@"effectView" : self.visualEfView }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[effectView]-0-|" options:0 metrics:0 views:@{ @"tableView" : self.tableView,@"effectView" : self.visualEfView }]];
    [self.view setNeedsLayout];
    [self.visualEfView setNeedsLayout];
    
}

-(void)configViews:(UITableView*)view
{
//    if ([view isKindOfClass:[UITableView class]])
//    {
//        view.separatorStyle=UITableViewCellSeparatorStyleNone;
//        view.backgroundColor=[UIColor darkGrayColor];
//        
//        NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
//        [view selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
//        [self tableView:view didSelectRowAtIndexPath:ip];
//
//    }
}

-(void)initAddDialog
{

    //NSString* inputPageName=nil;
    self.alertViewController=[UIAlertController alertControllerWithTitle:@"Page Name" message:@"Please input the name for pages you want to create" preferredStyle:UIAlertControllerStyleAlert];
    //_weak id weakself=self;
    [self.alertViewController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder=@"Name";
    }];
    //self.alertViewController.transitionCoordinator
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
    {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];

        
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Apply" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
        UITextField* name = self.alertViewController.textFields.firstObject;
        //self.pageName=name.text;
        if (![self.pagesNameArray containsObject:name.text])
        {
            [self.pagesNameArray addObject:name.text];
            [self.tableView reloadData];
            
        }
        
        
    }];
    [self.alertViewController addAction:cancelAction];
    [self.alertViewController addAction:okAction];
    //self.alertViewController.transitionCoordinator=self;
    
    
    
}
-(void)handleRightButtonItem:(id)sender
{

    [self presentViewController:self.alertViewController animated:YES completion:^{
        
    }];

    

}
-(void)handleLeftButtonItem:(id)sender
{}



-(void)setupPages
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userd = [userDefault dictionaryRepresentation];
    //ChartDataManager* manager=[ChartDataManager defaultChartDataManager];
    if ([userd.allKeys containsObject:kcPagesArrayName])
    {
        self.pagesNameArray= [[NSMutableArray alloc] initWithArray:[userd objectForKey:kcPagesArrayName]];
        
//        NSArray* chartsData=[NChartDataModel chartDataDefault];
//        [manager storeChartDataToFile:chartsData fileName:[NChartDataModel getStoredDefaultFilePath]];
//        for (NChartDataModel* oneChartData in chartsData)
//        {
//            
//            [self.dashboardItemViewControllers addObject:[[DoubleNChartWithLabelViewController alloc] initWithDrawingData:oneChartData delegateHolder:self]];
//            
//        }
        
    }
    else//there are default data in defualts for display
    {
        self.pagesNameArray=[NSMutableArray array];
        [self.pagesNameArray addObject:kcDefaultChartName];
        
        [userDefault setObject:self.pagesNameArray forKey:kcPagesArrayName];
        [userDefault synchronize];
         
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.pagesNameArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QBEPagesNames"] ;
                             
    
    cell.textLabel.text=[self.pagesNameArray objectAtIndex:indexPath.row];
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    return cell;
    
    
    
    
    
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* detailItem= [self.pagesNameArray objectAtIndex:indexPath.row];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.detailViewController = [[DashboardTableViewController alloc] init] ;
        self.detailViewController.detailItem = detailItem;
        UINavigationController* detailNavigationController=[[self.navigationController.splitViewController viewControllers] objectAtIndex:1];
        [detailNavigationController pushViewController:self.detailViewController animated:YES];
    }
    else
    {
        //if (self.detailViewController.detailItem!=detailItem)
        {
            self.detailViewController.detailItem = detailItem;

        }
        
    }
    
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
    NSLog(@"this");
    //Get references to the view hierarchy
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
//    if ([fromViewController isKindOfClass:[ChatViewController class]] && [toViewController isKindOfClass:[MapViewController class]])
    if ([toViewController isKindOfClass:[UIAlertController class]]&&[fromViewController isKindOfClass:[UINavigationController class]])
    {
        UIAlertController* alvc = (UIAlertController*)toViewController;
        [[transitionContext containerView] addSubview:alvc.view];
        alvc.view.transform = CGAffineTransformMakeScale(0.1,0.1);
        
        alvc.view.frame = CGRectMake(250, 0, 20,20);
        alvc.view.alpha = 0.0f;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            //MVC
            alvc.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            alvc.view.alpha = 1.0f;
            alvc.view.center=containerView.center;
            

        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            //CGRect rect=alvc.view.frame;
        }];
    }
//    else if ([fromViewController isKindOfClass:[MapViewController class]] && [toViewController isKindOfClass:[ChatViewController class]]){
//        //Dismissing MapViewControll from ChatViewController
//        MapViewController* mvc = (MapViewController*)fromViewController;
//        ChatViewController* cvc = (ChatViewController*)toViewController;
//        CGRect transitioningFrame = [cvc.transitioningView convertRect:cvc.transitioningView.bounds toView:cvc.view];
//        
//        //CVC
//        cvc.transitioningView.alpha = 0.0f;
//        [containerView addSubview:cvc.view];
//        
//        //MVC
//        mvc.view.alpha = 1.0f;
//        [containerView insertSubview:mvc.view aboveSubview:cvc.view];
//        
//        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//            //MVC
//            mvc.view.transform = CGAffineTransformMakeScale(CGRectGetWidth(transitioningFrame) / CGRectGetWidth(containerView.bounds),
//                                                            CGRectGetHeight(transitioningFrame) / CGRectGetHeight(containerView.bounds));
//            mvc.view.frame = transitioningFrame;
//            mvc.view.alpha = 0.0f;
//            
//            //CVC
//            cvc.transitioningView.alpha = 1.0f;
//        } completion:^(BOOL finished) {
//            [transitionContext completeTransition:YES];
//        }];
//        
//    }
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.45;
}



@end
