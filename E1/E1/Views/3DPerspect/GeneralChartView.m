//
//  GeneralChartView.m
//  E1
//
//  Created by Jack Lin on 24/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "GeneralChartView.h"
#import "ProgressColumn.h"
@interface GeneralChartView()
@property(nonatomic,strong) ProgressColumn* progressColumnBar;
@end
@implementation GeneralChartView

- (id)initWithFinalPercentage:(CGFloat)percentage color1:(UIColor*)color1 color2:(UIColor*)color2
{
    if (self=[super initWithFrame:CGRectZero])
    {
        self.progressColumnBar=[[ProgressColumn alloc] initWithFinalPercentage:percentage color1:color1 color2:color2];
        
    }
    return self;
    
}
-(void)layoutSubviews
{
//    self.chart.legend.maxSize
    NSDictionary* metircs=@{@"legendHeight":@200};
    if (self.progressColumnBar!=nil)
    {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[progressColumn]-0-|" options:0 metrics:metircs views:@{ @"progressColumn" : self.progressColumnBar }]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[progressColumn]-legendHeight-|" options:0 metrics:metircs views:@{ @"progressColumn" : self.progressColumnBar }]];

    }
    
    [super layoutSubviews];
    
}
//-(void)updateData
//{
//    [super.chartView.chart updateData];
//    
//    
//    
//}
@end
