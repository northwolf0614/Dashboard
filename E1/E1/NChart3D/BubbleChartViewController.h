//
//  BubbleChartViewController.h
//  E1
//
//  Created by Jack Lin on 30/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AbstractNChartViewController.h"

@interface BubbleChartViewController : AbstractNChartViewController<NChartSeriesDataSource, NChartTimeAxisDataSource, NChartSizeAxisDataSource>
@property(nonatomic, retain) NSMutableArray *brushes;

@end
