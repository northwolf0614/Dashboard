//
//  GeneralNChartWithLabelViewController.m
//  E1
//
//  Created by Jack Lin on 8/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "GeneralNChartWithLabelViewController.h"
#import "Definations.h"

@interface GeneralNChartWithLabelViewController ()

@end

@implementation GeneralNChartWithLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.dataForNChart.labelText!=nil&&[self.dataForNChart.labelText isKindOfClass:[NSString class]])
    {
        self.label=[[UILabel alloc] init];
        self.label.backgroundColor=[UIColor clearColor];
        self.label.text=self.dataForNChart.labelText;
        self.label.textColor=kcCharColor;
        self.label.translatesAutoresizingMaskIntoConstraints=NO;
        self.label.font=[UIFont fontWithName:@"Arial" size:120];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.userInteractionEnabled = NO;
        self.label.numberOfLines = 1;
        self.label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self.contentView addSubview:self.label];
        
        NSArray* constraints=[self.contentView constraints];
        if ([constraints count]>0) {
            [self.contentView removeConstraints:constraints];
        }
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[label(80)]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[label(50)]-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label }]];

    }
    
    // Do any additional setup after loading the view.
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
