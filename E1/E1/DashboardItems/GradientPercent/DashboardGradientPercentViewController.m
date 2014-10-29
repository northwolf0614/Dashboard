//
//  DashboardGradientPercentViewController.m
//  E1
//
//  Created by Lei Zhao on 29/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DashboardGradientPercentViewController.h"

@interface DashboardGradientPercentViewController ()

@end

@implementation DashboardGradientPercentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.percentageView= [[GradientPercentView alloc] init];
    [self.view addSubview:self.percentageView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[percentageView]-0-|" options:0 metrics:0 views:@{@"percentageView":self.percentageView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[percentageView]-0-|" options:0 metrics:0 views:@{@"percentageView":self.percentageView}]];
    
    [self.percentageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.percentageView setPercent:0.9 animated:YES];
}

- (void)didReceiveMemoryWarning {
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
