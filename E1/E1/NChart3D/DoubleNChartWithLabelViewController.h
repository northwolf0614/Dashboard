//
//  DoubleNChartWithLabelViewController.h
//  E1
//
//  Created by Jack Lin on 8/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "GeneralNChartWithLabelViewController.h"
#import "AbstractChartView.h"

@interface DoubleNChartWithLabelViewController : GeneralNChartWithLabelViewController<NChartSeriesDataSource,NChartValueAxisDataSource>
@property(nonatomic,strong) AbstractNChartView* chartViewPlus;
@property(nonatomic,strong) NChartDataModel* dataForNChartPlus;
-(id)initWithDrawingData:(NChartDataModel*)drawingData delegateHolder:(id<ChartSubviewControllerResponse>) delegateImplementer;

@end
