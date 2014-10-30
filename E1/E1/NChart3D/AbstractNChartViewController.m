//
//  AbstractNChartViewController.m
//  E1
//
//  Created by Lei Zhao on 30/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AbstractNChartViewController.h"

@interface AbstractNChartViewController ()

@end

@implementation AbstractNChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    self.chartView = [[NChartView alloc] initWithFrame:CGRectZero];
    self.chartView.chart.licenseKey = @"iQRg8UB5hqZL29rD54FU0+WsjCwkhO7bPEhpWYhLYXmkuiiS1KB59qPd8U2H+bJU6mdBscwqZzIcXRYyo7w4wdd7yUhZUYEoXfuK/XdiA3aBb8QM3MsFyocP7VDtcYF4B1rEVVmsor4JYaVXSonyDoLyvRn670fPQZd0ItllYoRtjF5oJv/NML7cqP5W/Cpro6eLn1u4onfo6xzGG/4Fs/B/rZtbOoQ9MFO1Q74Uj/aeTcnri5llWx071zURtL1L0e3COZ+oQ96xlPVZk2Cun0Lol0nyglf6C4RKifMbnCEtGRIL30aLMvKeC1JT8kc36xyLgpRYF4Ggrx8EY+PwbYxBOmkt1i8JJNrFThUs1DMDGBw0sA51CTNu4SIGgUDVjMBZZFrECvjzrwhkdTjBEXXLxFAEhm5ApsTxiKvdFIiqISHMtQGtcMnh5oIBszO1ucGzPH3kweyTY8jAfqunDw2+vLXgsR+BxpCoBcHwd6Tb8HcVd0TB2J6jeMEmjLOwIYE64mPPcI9rcWdbQ0fBcmAiTAzsc2TcQDSVgH2pRhKf1QzBxnyls1GXsVoFqRoRsqalwFLzOqnU6ZByftHJdI6W8CRjb0Yl54TS3I0BlvURShYyCfzkQEC+QZ4+xmCpOFtBIcbITN8NK5h5NtA3C9EkiMH4p9gurIsIofAssOM=";
    self.chartView.chart.cartesianSystem.margin = NChartMarginMake(0, 0, 0, 0);
    self.chartView.chart.shouldAntialias = YES;
    self.view = self.chartView;
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
