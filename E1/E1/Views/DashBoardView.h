//
//  DashBoardView.h
//  E1
//
//  Created by Jack Lin on 20/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParagraphView.h"
#import <MapKit/MapKit.h>
#import "Definations.h"
#import "GradientPercentView.h"
#import "StatisticsAnalyzerView.h"
#import "CorePlot-CocoaTouch.h"
#import "ParagraphView.h"
#import "PieChartView.h"

@interface DashBoardView : UIView
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) GradientPercentView* percentageView;
@property (nonatomic,strong) StatisticsAnalyzerView* statisticsAnalyzerView;
@property(nonatomic,strong)  ParagraphView* paragraphView;
@property(nonatomic,strong)  PieChartView* pieCharView;
-(void)setPercent:(CGFloat)percent animated:(BOOL)animated;
-(void)updateAnalysis;
-(void)updateCorePlotViews;
@end
