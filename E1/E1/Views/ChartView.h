//
//  AbstractNChartView.h
//  E1
//
//  Created by Jack Lin on 1/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <NChart3D/NChart3D.h>
@class ChartView;
@protocol AbstractNChartViewDelegate <NSObject>
-(void) setupAxesTypeForView:(ChartView*) chartView;
-(void) setupSeriesForChartView:(ChartView*) chartView;

@end



@interface ChartView : NChartView
@property(nonatomic,weak)   id<AbstractNChartViewDelegate>delegate;

-(void)showSeries:(BOOL)isAnimated;
-(void)setupDelegate:(id)delegate;

@end
