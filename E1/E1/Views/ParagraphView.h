//
//  ParagraphView.h
//  E1
//
//  Created by Jack Lin on 23/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "AbstractChartView.h"



@interface ParagraphView : AbstractChartView
@property(nonatomic,strong)CPTScatterPlot* boundLinePlot;
-(void)updateCorePlotViews;
@end
