//
//  DashBoardPieChartViewController.h
//  E1
//
//  Created by Jack Lin on 29/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DashboardItemViewController.h"
#import "CorePlot-CocoaTouch.h"

@interface DashBoardPieChartViewController : DashboardItemViewController<CPTPieChartDelegate,CPTPieChartDataSource,CPTLegendDelegate>

@end
