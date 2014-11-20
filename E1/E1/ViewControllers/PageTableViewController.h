//
//  PageTableViewController.h
//  E1
//
//  Created by Jack Lin on 20/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardTableViewController.h"

@interface PageTableViewController : UITableViewController
@property (nonatomic, retain) DashboardTableViewController*detailViewController;
@end
