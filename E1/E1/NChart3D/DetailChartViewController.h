//
//  DetailChartViewController.h
//  E1
//
//  Created by Jack Lin on 2/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractNChartViewController.h"
#import "AbstractNChartView.h"
//#import "AbstractDetailChartViewController.h"
#import "DoubleNChartWithLabelViewController.h"
#import "SliderCell.h"
@interface DetailChartViewController:DoubleNChartWithLabelViewController<UITableViewDataSource,UITableViewDelegate,SliderDelegate>
@property (weak, nonatomic) IBOutlet UIView *chartViewContainer;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property(assign,nonatomic) BOOL isAdded;
-(BOOL)shouldBeAddToPreviousPage;
@end
