//
//  AbstractNChartViewController.h
//  E1
//
//  Created by Lei Zhao on 30/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DashboardItemViewController.h"
#import <NChart3D/NChart3D.h>
#import "AbstractNChartView.h"
#import "NChartDataModel.h"
@interface AbstractNChartViewController : DashboardItemViewController
@property (nonatomic, strong) AbstractNChartView* chartView;
@property(nonatomic,strong) NChartDataModel* dataForNChart;
-(id)initWithDrawingData:(NChartDataModel*)drawingData;
@end
