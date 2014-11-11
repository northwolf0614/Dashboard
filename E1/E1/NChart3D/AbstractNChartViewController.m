//
//  AbstractNChartViewController.m
//  E1
//
//  Created by Lei Zhao on 30/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AbstractNChartViewController.h"
#import "Definations.h"
#import "NChartDataModel.h"



@interface AbstractNChartViewController ()
@property(nonatomic,assign) BOOL isShowMiddleLabel;
@end

@implementation AbstractNChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.titleItem setTitle:self.dataForNChart.chartCaption];
    self.chartView = [[AbstractNChartView alloc] initWithFrame:CGRectZero];
    self.chartView.chart.licenseKey = kcNchartViewlicense;
    self.chartView.chart.cartesianSystem.margin = NChartMarginMake(0, 0, 0, 0);
    self.chartView.chart.shouldAntialias = YES;
    //self.chartView.chart.drawIn3D = YES;
    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.chartView];
    self.chartView.chart.cartesianSystem.xAxis.dataSource = (id)self;
    self.chartView.chart.cartesianSystem.yAxis.dataSource = (id)self;
    self.chartView.chart.cartesianSystem.zAxis.dataSource = (id)self;
    
    self.chartView.chart.polarSystem.azimuthAxis.dataSource = (id)self;
    self.chartView.chart.polarSystem.radiusAxis.dataSource = (id)self;
    self.chartView.chart.sizeAxis.dataSource = (id)self;
    //self.chartView.chart.timeAxis.dataSource = (id)self;
    
    self.chartView.chart.cartesianSystem.yAlongX.visible=NO;
    self.chartView.chart.cartesianSystem.xAlongY.visible=NO;
    self.chartView.chart.cartesianSystem.borderVisible=NO;
    self.chartView.chart.cartesianSystem.yAxis.caption.visible=NO;
    self.chartView.chart.cartesianSystem.yAxis.visible=NO;
    self.chartView.chart.cartesianSystem.yAxis.labelsVisible=NO;
    self.chartView.chart.cartesianSystem.xAxis.caption.visible=NO;
    self.chartView.chart.cartesianSystem.xAxis.visible=NO;
    self.chartView.chart.cartesianSystem.xAxis.labelsVisible=NO;
    
    self.chartView.chart.polarSystem.radiusAxis.labelsVisible=NO;
    self.chartView.chart.polarSystem.radiusAxis.visible=NO;
    self.chartView.chart.polarSystem.radiusAxis.caption.visible=NO;

    self.chartView.chart.polarSystem.azimuthAxis.caption.visible=NO;
    self.chartView.chart.polarSystem.azimuthAxis.thickness=12;
    //self.chartView.chart.polarSystem.azimuthAxis.visible=NO;
    //self.chartView.chart.polarSystem.azimuthAxis.labelsVisible=NO;
    self.chartView.chart.polarSystem.azimuthAxis.textColor=kcCharColor;
    
    
    
    self.chartView.chart.background = [NChartSolidColorBrush solidColorBrushWithColor:kcWidgetBackColor];

}
-(id)initWithDrawingData:(NChartDataModel*)drawingData delegateHolder:(id<ChartSubviewControllerResponse>) delegateImplementer;
{
    if (self=[super init])
    {
        self.dataForNChart=drawingData;
        
        self.delegate=delegateImplementer;
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    if(self.dataForNChart.floatingNumber!=nil&&[self.dataForNChart.floatingNumber isKindOfClass:[NSString class]])
       [self.chartView setTextForMiddleLabel:self.dataForNChart.floatingNumber];
    
    
    
    
}

@end
