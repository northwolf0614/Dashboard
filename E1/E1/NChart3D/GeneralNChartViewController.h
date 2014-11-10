//
//  GeneralNChartViewController.h
//  E1
//
//  Created by Jack Lin on 1/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AbstractNChartViewController.h"

@interface GeneralNChartViewController : AbstractNChartViewController//
//<NChartSeriesDataSource,NChartValueAxisDataSource>
@property(nonatomic,strong) UIColor* backGroundColor;
-(void) setupSeriesForChartView;
-(void) setupAxesType;

@end
