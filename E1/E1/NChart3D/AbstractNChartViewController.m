//
//  AbstractNChartViewController.m
//  E1
//
//  Created by Lei Zhao on 30/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AbstractNChartViewController.h"
#import "Definations.h"



@interface AbstractNChartViewController ()

@end

@implementation AbstractNChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.chartView = [[AbstractNChartView alloc] initWithFrame:CGRectZero];
    self.chartView.chart.licenseKey = kcNchartViewlicense;
    self.chartView.chart.cartesianSystem.margin = NChartMarginMake(0, 0, 0, 0);
    self.chartView.chart.shouldAntialias = YES;
    //self.chartView.chart.drawIn3D = YES;
    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
    self.label=[[UILabel alloc] init];
    self.label.backgroundColor=[UIColor redColor];
    
    
    [self.contentView addSubview:self.chartView];
    //[self.contentView addSubview: self.label];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView }]];
    
    //[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label(20)]-3-|" options:0 metrics:0 views:@{ @"label" : self.label }]];
    
    //[self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[label(10)]|" options:0 metrics:0 views:@{ @"label" : self.label }]];
    
    self.chartView.chart.cartesianSystem.xAxis.dataSource = (id)self;
    self.chartView.chart.cartesianSystem.yAxis.dataSource = (id)self;
    self.chartView.chart.cartesianSystem.zAxis.dataSource = (id)self;

    self.chartView.chart.cartesianSystem.yAlongX.visible=NO;
    self.chartView.chart.cartesianSystem.xAlongY.visible=NO;
    self.chartView.chart.cartesianSystem.borderVisible=NO;
    self.chartView.chart.cartesianSystem.yAxis.caption.visible=NO;
    self.chartView.chart.cartesianSystem.yAxis.visible=NO;
    self.chartView.chart.cartesianSystem.xAxis.majorTicks.visible=NO;
    self.chartView.chart.cartesianSystem.xAxis.minorTicks.visible=NO;
     self.chartView.chart.background = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor darkGrayColor]];
    
    
    
    
    
    
}
-(id)initWithDrawingData:(NChartDataModel*)drawingData delegateHolder:(id<ChartSubviewControllerResponse>) delegateImplementer;
{
    if (self=[super init]) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
