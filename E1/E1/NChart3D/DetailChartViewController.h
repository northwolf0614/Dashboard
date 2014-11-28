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
//@interface DetailChartViewController : UIViewController
@interface DetailChartViewController:DoubleNChartWithLabelViewController<UISplitViewControllerDelegate>
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UIView *chartViewContainer;
@property (weak, nonatomic) IBOutlet UIView *configurationViewContainer;

@end
