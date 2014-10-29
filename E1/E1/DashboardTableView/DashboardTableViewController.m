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
#import "DashboardMapViewController.h"

@interface DashboardTableViewController ()
@property(nonatomic, strong)NSMutableArray* dashboardItemViewControllers;
@end

@implementation DashboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dashboardItemViewControllers = [NSMutableArray arrayWithCapacity:5];
    [self.dashboardItemViewControllers addObject:[[DashboardMapViewController alloc] init]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return (int)(self.dashboardItemViewControllers.count+1) / 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellClassName = NSStringFromClass([DashboardTwinCell class]);
    DashboardTwinCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forCellReuseIdentifier:cellClassName];
        cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    }
    
    [[cell.leftView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[cell.rightView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    long itemIndex = indexPath.row * 2;
    for (long i=itemIndex; i<=itemIndex+1; i++) {
        if (i < self.dashboardItemViewControllers.count) {
            DashboardItemViewController *itemViewController = [self.dashboardItemViewControllers objectAtIndex:itemIndex];
            BOOL addChildViewContollerFlag = [self.childViewControllers containsObject:itemViewController];
            if (!addChildViewContollerFlag){
                [self addChildViewController:itemViewController];
            }
            
            UIView* cellView = i==itemIndex ? cell.leftView : cell.rightView;
            cellView.autoresizesSubviews = YES;
            itemViewController.view.frame = cellView.bounds;
            [cellView addSubview:itemViewController.view];
            
            if (!addChildViewContollerFlag){
                [itemViewController didMoveToParentViewController:self];
            }            
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
