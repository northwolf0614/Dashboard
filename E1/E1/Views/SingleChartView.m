//
//  AbstractNChartView.m
//  E1
//
//  Created by Jack Lin on 1/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "SingleChartView.h"
#import "Definations.h"
@interface SingleChartView()
@end

@implementation SingleChartView
-(void)dealloc
{
    NSLog(@"this is deallocview in AbstractNChartView");
    
}



-(void)updateData
{
    
    if (self.delegate!=nil)
    {
        if ([self.delegate respondsToSelector:@selector(setupAxesTypeForView:)])
        {
            [self.delegate setupAxesTypeForView:self];
        }
        if ([self.delegate respondsToSelector:@selector(setupSeriesForChartView:)])
        {
            [self.delegate setupSeriesForChartView:self];
        }
        
    }
    [self.chart updateData];
    
    
    
}

-(void)showSeries:(BOOL)isAnimated
{
    
    
    [self.chart removeAllSeries];
    [self updateData];
    if (isAnimated)
    {
        if ([[self.chart series] count]>0&&![self.chart isTransitionPlaying])
            
        {

            [self.chart stopTransition];
            [self.chart playTransition:kcTRANSITION_TIME reverse:NO];
            [self.chart flushChanges];
            
        }
    }
    

    
    


}
-(void)setupDelegate:(id)delegate
{
    self.chart.cartesianSystem.xAxis.dataSource = (id)delegate;
    self.chart.cartesianSystem.yAxis.dataSource = (id)delegate;
    self.chart.cartesianSystem.zAxis.dataSource = (id)delegate;
    self.chart.cartesianSystem.syAxis.dataSource=(id)delegate;
    self.chart.cartesianSystem.sxAxis.dataSource=(id)delegate;
    self.chart.polarSystem.azimuthAxis.dataSource = (id)delegate;
    self.chart.polarSystem.radiusAxis.dataSource = (id)delegate;
    self.chart.sizeAxis.dataSource = (id)delegate;
    self.chart.cartesianSystem.syAxis.dataSource=(id)delegate;
    self.delegate=(id)delegate;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        
        NSLog(@"this is initWithFrame in AbstractNChartView");
        self.chart.legend.textColor=kcCharColor;
        self.chart.cartesianSystem.xAxis.textColor=kcCharColor;
        self.userInteractionEnabled=NO;
    }
    return self;
}



-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
}


-(void)clean
{
    [self.chart removeAllSeries];
}


@end
