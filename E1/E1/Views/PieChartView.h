//
//  PieChartView.h
//  E1
//
//  Created by Jack Lin on 25/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface PieChartView : CPTGraphHostingView
-(void)updateCorePlotViews;
@end