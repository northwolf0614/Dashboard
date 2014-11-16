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
@protocol  ChartSubviewControllerResponse <NSObject>

-(void)searchButtonClickedWithData:(NChartDataModel*)dataSubviewControllerHolding inView:(UIView*)contentView;

@end

@interface AbstractNChartViewController : DashboardItemViewController
{
@private
    NChartDataModel* _dataForNChart;
}
@property (nonatomic, strong) AbstractNChartView* chartView;
@property(nonatomic,assign) BOOL isNeedsUpdate;
@property(nonatomic,strong) NChartDataModel* dataForNChart;
@property(nonatomic,weak)id<ChartSubviewControllerResponse> delegate;

-(id)initWithDrawingData:(NChartDataModel*)drawingData delegateHolder:(id<ChartSubviewControllerResponse>) delegateImplementer;
-(void)updateChartData:(AbstractNChartView*)view animated:(BOOL) isAnimated dataModel:(NChartDataModel*)chartData;
-(void)showSeries;
-(void)setupAxesType;

@end
