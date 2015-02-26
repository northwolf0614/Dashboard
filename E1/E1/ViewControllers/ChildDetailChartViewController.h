//
//  ChildDetailChartViewController.h
//  E1
//
//  Created by Jack Lin on 18/02/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NChartDataModel.h"
#import <NChart3D/NChart3D.h>
#import "ChartView.h"
#import "Progress.h"
#import "SingleChartView.h"
@interface ChildDetailChartViewController : UIViewController<NChartSeriesDataSource,NChartValueAxisDataSource,AbstractNChartViewDelegate,ProgressBarDataSource>
-(id)initWithDrawingData:(NChartDataModel*)drawingData views:(NSArray*)chartViews isAddedChart:(BOOL)isAdded;
@property(nonatomic,strong) UIView* contentView;//used when added to the collectionView


@end
