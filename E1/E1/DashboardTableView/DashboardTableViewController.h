//
//  DashboardTableViewController.h
//  E1
//
//  Created by Lei Zhao on 28/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definations.h"
#import "AbstractNChartViewController.h"
#import "PopAnimation.h"
#import "PushAnimation.h"

 @class PushAnimation;
 @class PopAnimation;

@interface DashboardTableViewController : UITableViewController<ChartSubviewControllerResponse,UINavigationControllerDelegate,UISplitViewControllerDelegate>
@property(nonatomic,strong) NSMutableArray* chartNames;
@property(nonatomic,strong) UIView* transitioningView;
@property (copy, nonatomic) NSString* detailItem;

@property (strong, nonatomic) PushAnimation *pushAnimation;
@property (strong, nonatomic) PopAnimation *popAnimation;
//@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;
-(void)setupDefaultDataForDrawing;



@end
