//
//  PageTableViewController.h
//  E1
//
//  Created by Jack Lin on 20/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardTableViewController.h"
#import "DashBoardViewController.h"

@interface PageTableViewController : UIViewController<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning,UITableViewDataSource,UITableViewDelegate>
//@property (nonatomic, retain) DashboardTableViewController*detailViewController;
@property (nonatomic, strong) DashBoardViewController* detailViewController;
@end
