//
//  GerneralChartViewController.h
//  E1
//
//  Created by Jack Lin on 16/01/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NChartDataModel.h"
#import <NChart3D/NChart3D.h>
#import "ChartView.h"
#import "Progress.h"
@protocol ControllerDelegate <NSObject>

-(void)allAnimationsFinished;

@end


//@interface GerneralChartViewController : NSObject
@interface GerneralChartViewController : UIViewController
<NChartSeriesDataSource,NChartValueAxisDataSource,AbstractNChartViewDelegate,ProgressBarDataSource>

@property(nonatomic,weak) id<ControllerDelegate> delegate;
-(id)initWithDrawingData:(NChartDataModel*)drawingData views:(NSArray*)chartViews;
-(void)showCharts:(BOOL)isAnimated;

@end
