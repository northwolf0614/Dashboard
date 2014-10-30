//
//  DashBoardPieChartViewController.m
//  E1
//
//  Created by Jack Lin on 29/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DashBoardPieChartViewController.h"
#import "Definations.h"
#import "PieChartView.h"

@interface DashBoardPieChartViewController ()
@property (nonatomic, strong) NSMutableArray* dataForPieChart;
@property (nonatomic, strong) PieChartView* pieChartView;

@end

@implementation DashBoardPieChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.titleItem setTitle:@"Pie"];
    
    self.pieChartView = [[PieChartView alloc] init];
    [self.contentView addSubview:self.pieChartView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pieChartView]-0-|" options:0 metrics:0 views:@{ @"pieChartView" : self.pieChartView }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pieChartView]-0-|" options:0 metrics:0 views:@{ @"pieChartView" : self.pieChartView }]];
    [self.pieChartView setTranslatesAutoresizingMaskIntoConstraints:NO];

    self.pieChartView.piePlot.delegate = self;
    self.pieChartView.piePlot.dataSource = (id)self;
    self.pieChartView.legend.delegate = self;

    [self setupDataForPieChartView];

    // Do any additional setup after loading the view.
}

- (void)setupDataForPieChartView
{
    self.dataForPieChart = [[NSMutableArray alloc] initWithObjects:@"0.2", @"0.3", @"0.1", @"0.2", @"0.2", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChartView updateCorePlotViews];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 返回扇形数目

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot*)plot
{
    if ([plot isKindOfClass:[CPTPieChart class]] && [plot.identifier isEqual:kcQBE_Products_PieChart]) {
        return self.dataForPieChart.count;
    }
    return 0;
}

// 返回每个扇形的比例

- (NSNumber*)numberForPlot:(CPTPlot*)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    if ([plot isKindOfClass:[CPTPieChart class]] && [plot.identifier isEqual:kcQBE_Products_PieChart])
        return [self.dataForPieChart objectAtIndex:idx];
    return nil;
}

// 凡返回每个扇形的标题

- (CPTLayer*)dataLabelForPlot:(CPTPlot*)plot recordIndex:(NSUInteger)idx

{
    if ([plot isKindOfClass:[CPTPieChart class]] && [plot.identifier isEqual:kcQBE_Products_PieChart]) {

        CPTTextLayer* label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"hello,%@", [self.dataForPieChart objectAtIndex:idx]]];
        CPTMutableTextStyle* text = [label.textStyle mutableCopy];
        text.color = [CPTColor whiteColor];
        return label;
    }
    return nil;
}

#pragma CPTPieChartDelegate

// 选中某个扇形时的操作

//- ( void )pieChart:( CPTPieChart *)plot sliceWasSelectedAtRecordIndex:( NSUInteger )idx

//{

//    self . graph . title = [ NSString stringWithFormat : @" 比例 :%@" ,[ self .arr objectAtIndex :idx]];

//}

// 返回图例

- (NSAttributedString*)attributedLegendTitleForPieChart:(CPTPieChart*)pieChart recordIndex:(NSUInteger)idx

{
    if ([pieChart isKindOfClass:[CPTPieChart class]] && [pieChart.identifier isEqual:kcQBE_Products_PieChart])

    {
        NSAttributedString* title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"hi:%i", idx]];
        return title;
    }
    return nil;
}

@end
