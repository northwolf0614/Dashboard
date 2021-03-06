//
//  DashboardStatisticsAnalyzerViewController.m
//  E1
//
//  Created by Lei Zhao on 29/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DashboardStatisticsAnalyzerViewController.h"

@interface DashboardStatisticsAnalyzerViewController ()

@end

@implementation DashboardStatisticsAnalyzerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.titleItem setTitle:@"Statistic"];

    self.statisticsAnalyzerView = [[StatisticsAnalyzerView alloc] init];
    [self.contentView addSubview:self.statisticsAnalyzerView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[statisticsAnalyzerView]-0-|" options:0 metrics:0 views:@{ @"statisticsAnalyzerView" : self.statisticsAnalyzerView }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[statisticsAnalyzerView]-0-|" options:0 metrics:0 views:@{ @"statisticsAnalyzerView" : self.statisticsAnalyzerView }]];

    [self.statisticsAnalyzerView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.statisticsAnalyzerView startAnalyzeStatistics];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleRightButtonItem:(id) sender
{
    [super handleRightButtonItem:sender];
    NSLog(@"this is statisticsViw clicked!");
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
