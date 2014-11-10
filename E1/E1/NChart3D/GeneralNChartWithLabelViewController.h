//
//  GeneralNChartWithLabelViewController.h
//  E1
//
//  Created by Jack Lin on 8/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "GeneralNChartViewController.h"

@interface GeneralNChartWithLabelViewController : GeneralNChartViewController//<NChartSeriesDataSource,NChartValueAxisDataSource>

@property(nonatomic,strong) UILabel* label;
@end
