//
//  OneViewCell.m
//  E1
//
//  Created by Jack Lin on 16/01/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import "OneViewCell.h"
#import "Definations.h"
#import "ChartView.h"
@interface OneViewCell()
@property(nonatomic,assign) BOOL didSetupConstraintsOneViewCell;
@end
@implementation OneViewCell
-(void)prepareForReuse
{
    [self.chartView.chart removeAllSeries];
    [self.chartView clean];
    [super prepareForReuse];
}
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self setupChartView];
        [self setupYearLabel];
        
        
        
    }
    return self;
}
-(void)setupChartView
{
    self.chartView = [[ChartView alloc] initWithFrame:CGRectZero];
    self.chartView.chart.licenseKey = kcNchartViewlicense;
    self.chartView.chart.cartesianSystem.margin = NChartMarginMake(0, 0, 0, 0);
    self.chartView.chart.shouldAntialias = YES;
    //self.chartView.chart.drawIn3D = YES;
    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
    self.chartView.chart.background = [NChartSolidColorBrush solidColorBrushWithColor:kcWidgetBackColor];
    //self.chartView.chart.background = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor yellowColor]];
    self.chartView.chart.cartesianSystem.xAxis.minTickSpacing = 2.0f;
    self.chartView.chart.cartesianSystem.xAxis.font=[UIFont systemFontOfSize:12];
    
    [self.viewContainer addSubview:self.chartView];
    
}
-(void)setupYearLabel
{
    self.yearLabel=[[UILabel alloc] init];
    self.yearLabel.backgroundColor=[UIColor clearColor];
    //self.yearLabel.backgroundColor=[UIColor redColor];
    self.yearLabel.textColor=kcCharColor;
    self.yearLabel.translatesAutoresizingMaskIntoConstraints=NO;
    self.yearLabel.font=[UIFont fontWithName:@"Arial" size:120];
    self.yearLabel.adjustsFontSizeToFitWidth = YES;
    self.yearLabel.userInteractionEnabled = NO;
    self.yearLabel.numberOfLines = 1;
    self.yearLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self.viewContainer addSubview:self.yearLabel];
    
}


-(void)updateConstraints
{
    [super updateConstraints];

    if (self.didSetupConstraintsOneViewCell) {
        return;
    }
    if ([self isKindOfClass:[OneViewCell class]])
    {
        NSArray* constraints=[self.viewContainer constraints];
        if ([constraints count]>0)
        {
            [self.viewContainer removeConstraints:constraints];
        }
        [self.viewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.yearLabel }]];
        [self.viewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[label(80)]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.yearLabel }]];
        [self.viewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[label(50)]->=0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.yearLabel }]];
        [self.viewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.yearLabel }]];
        self.didSetupConstraintsOneViewCell=YES;
    }
    
    
    
    
}

@end
