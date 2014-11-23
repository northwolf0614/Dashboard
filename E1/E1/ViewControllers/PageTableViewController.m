//
//  PageTableViewController.m
//  E1
//
//  Created by Jack Lin on 20/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "PageTableViewController.h"
#import "Definations.h"

@interface PageTableViewController ()
@property(nonatomic,strong) NSMutableArray* pagesNameArray;
@end

@implementation PageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.backgroundColor=[UIColor clearColor];
    self.navigationItem.title=kcMasterTitle;
    UIBarButtonItem* rightBarButtonItem=[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIBarButtonItem* leftBarButtonItem =[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(handleLeftButtonItem:)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"QBEPagesNames"];
    [self setupPages];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=[UIColor darkGrayColor];
    
    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [self tableView:self.tableView didSelectRowAtIndexPath:ip];
}
-(void)handleRightButtonItem:(id)sender
{}
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [self.pagesNameArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QBEPagesNames"] ;
                             
    
    cell.textLabel.text=[self.pagesNameArray objectAtIndex:indexPath.row];
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

@end
