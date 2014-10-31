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
#import "DashboardGradientPercentViewController.h"
#import "DashboardStatisticsAnalyzerViewController.h"
#import "DashBoardPieChartViewController.h"
#import "ParagraphViewController.h"
#import "ColumnNChartViewController.h"
#import "BubbleChartViewController.h"

@interface DashboardTableViewController ()
@property (nonatomic, strong) NSMutableArray* dashboardItemViewControllers;
@end

@implementation DashboardTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DashboardTwinCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([DashboardTwinCell class])];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.dashboardItemViewControllers = [NSMutableArray arrayWithCapacity:5];
    [self.dashboardItemViewControllers addObject:[[DashboardMapViewController alloc] init]];
    [self.dashboardItemViewControllers addObject:[[DashboardGradientPercentViewController alloc] init]];
    //[self.dashboardItemViewControllers addObject:[[DashboardStatisticsAnalyzerViewController alloc] init]];
    [self.dashboardItemViewControllers addObject:[[DashBoardPieChartViewController alloc] init]];
    [self.dashboardItemViewControllers addObject:[[ParagraphViewController alloc] init]];
    [self.dashboardItemViewControllers addObject:[[ColumnNChartViewController alloc] init]];
    [self.dashboardItemViewControllers addObject:[[BubbleChartViewController alloc] init]];
    //config the add button
    UIBarButtonItem* rightBarButtonItem=[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    //
    self.view.backgroundColor=[UIColor lightGrayColor];
}
- (void)handleRightButtonItem:(id)sender
{
    //[self loadJsonData];
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

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 400;
}
@end
