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

@interface DashboardTableViewController : UITableViewController<ChartSubviewControllerResponse>
@property(nonatomic,strong) NSMutableArray* chartNames;
@end
