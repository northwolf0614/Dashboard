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

@interface PageTableViewController ()
@property(nonatomic,strong) NSMutableArray* pagesNameArray;
@property(nonatomic,strong) UIAlertController* alertViewController;
@property(nonatomic,strong) UIVisualEffectView* visualEfView;
@property(nonatomic,strong) UITableView* tableView;
//@property(nonatomic,assign) BOOL isApplyPressed;
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
    self.view.backgroundColor=[UIColor clearColor];
    
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.delegate=(id)self;
    self.tableView.dataSource=(id)self;
    [self setupConstraints];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title=kcMasterTitle;
    UIBarButtonItem* rightBarButtonItem=[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    UIBarButtonItem* leftBarButtonItem =[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(handleLeftButtonItem:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QBEPagesNames"];
    [self setupPages];
    [self initAddDialog];
    [self selectAtRow:0 inView:self.tableView];
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
        //self.pageName=name.text;
        if (![self.pagesNameArray containsObject:name.text])
        {
            //self.isApplyPressed=YES;
            [self.pagesNameArray addObject:name.text];
            [self syncWithUserDefault:self.pagesNameArray];
            [self.tableView reloadData];
            
//            [self.alertViewController dismissViewControllerAnimated:YES completion:^{
//            
//            }];
            
            
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
        
        
    }];
    //[self.alertViewController addAction:cancelAction];
    [self.alertViewController addAction:okAction];
    self.alertViewController.transitioningDelegate=self;

        

    
    
    
}
-(void)handleRightButtonItem:(id)sender
{

    [self presentViewController:self.alertViewController animated:YES completion:^{NSLog(@"presenting view controller completed");
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kcPageTableCellHeight;

}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView]) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        if (indexPath.row<[self.pagesNameArray count])
        {
            [self.pagesNameArray removeObjectAtIndex:indexPath.row];
            [self syncWithUserDefault:self.pagesNameArray];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QBEPagesNames"] ;
                             
    
    cell.textLabel.text=[self.pagesNameArray objectAtIndex:indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
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
        self.detailViewController = [[DashBoardViewController alloc] init] ;
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
    NSLog(@"this is animateTransition");
    //Get references to the view hierarchy
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
//    if ([fromViewController isKindOfClass:[ChatViewController class]] && [toViewController isKindOfClass:[MapViewController class]])
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
    
    else if ([fromViewController isKindOfClass:[UIAlertController class]] )
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
                y+=kcPageTableCellHeight*3/2;
                alvc.view.frame = CGRectMake(x, y, 20, 20);
                alvc.view.alpha = 0.0f;
                        //CVC
            //cvc.transitioningView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
            [alvc.view removeFromSuperview];
            [transitionContext completeTransition:YES];
            
        }];
//        else
//            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//                
//                
//                alvc.view.transform = CGAffineTransformMakeScale(0.1,0.1);
//                alvc.view.center = containerView.center;
//                alvc.view.alpha = 0.0f;
//                //CVC
//                //cvc.transitioningView.alpha = 1.0f;
//            } completion:^(BOOL finished) {
//                
//                [alvc.view removeFromSuperview];
//                [transitionContext completeTransition:YES];
//                
//            }];

        
    }
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.45;
}



@end
