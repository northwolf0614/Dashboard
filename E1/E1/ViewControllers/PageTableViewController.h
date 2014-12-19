//
//  PageTableViewController.h
//  E1
//
//  Created by Jack Lin on 20/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "DashboardTableViewController.h"
#import "DashBoardViewController.h"
#import "SwitchCell.h"

@interface PageTableViewController : UIViewController<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning,UITableViewDataSource,UITableViewDelegate,SwitchDelegate,UIGestureRecognizerDelegate>
//@property (nonatomic, retain) DashboardTableViewController*detailViewController;
@property (weak, nonatomic) IBOutlet UINavigationItem *naviItem;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) DashBoardViewController* detailViewController;
@property(nonatomic,strong) AnimatedTransitioningManager* interactionController;
-(id)initWithDetailController:(UIViewController*)detailController;
@end
