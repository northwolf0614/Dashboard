//
//  DetailChartViewController.m
//  E1
//
//  Created by Jack Lin on 2/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DetailChartViewController.h"
#import "Definations.h"

@interface DetailChartViewController ()

@end

@implementation DetailChartViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.chartView = [[AbstractNChartView alloc] init];
    self.chartView.chart.licenseKey = kcNchartViewlicense;
    self.chartView.chart.cartesianSystem.margin = NChartMarginMake(0, 0, 0, 0);
    self.chartView.chart.shouldAntialias = YES;
    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.chartViewContainer addSubview:self.chartView];
    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView }]];
    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView }]];
    
    self.configurationViewContainer.backgroundColor=[UIColor redColor];
    
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

-(id)initWithChartData:(NChartDataModel*) dataForChart;
{
    
    if (self=[super init]) {
        self.dataForChartView=dataForChart;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DetailChartViewController class]) owner:self options:nil];
    self.view = [nibs objectAtIndex:0];
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
