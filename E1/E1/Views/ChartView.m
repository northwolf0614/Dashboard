//
//  AbstractNChartView.m
//  E1
//
//  Created by Jack Lin on 1/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "ChartView.h"
#import "Definations.h"
@interface ChartView()
@property(nonatomic,strong) UILabel* middleLabel;
@property(nonatomic,strong) NSNumber* FloatingNumber;
@property(nonatomic,strong) NSNumber* valuePerStep;
@property(nonatomic,strong) NSTimer* timer;
@property(nonatomic,strong) NSNumber* changingValue;
@property(nonatomic,assign) float animationTime;
@end

@implementation ChartView

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
        if ([self.delegate respondsToSelector:@selector(mainChartFloatingNumber:)])
            
        {
            self.FloatingNumber=[self.delegate mainChartFloatingNumber:self];
        }
        if ([self.delegate respondsToSelector:@selector(mainChartFloatingNumberAnimationtime:)])
        {
            self.animationTime=[self.delegate mainChartFloatingNumberAnimationtime:self];
        }
    }
    [self.chart updateData];
    
    
    
}

-(void)showSeries:(BOOL)isAnimated
{
    
//    [self.chart removeAllSeries];
//    
//    [self updateData];
//    if (isAnimated)
//    {
//        if ([[self.chart series] count]>0&&![self.chart isTransitionPlaying])
//            
//        {
//
//            [self.chart stopTransition];
//            [self.chart playTransition:kcTRANSITION_TIME reverse:NO];
//            [self.chart flushChanges];
//            
//        }
//    }
    [super showSeries:isAnimated];
    [self showMiddleFloatingNumber:isAnimated];
    
    


}
-(void)setupDelegate:(id)delegate
{
    [super setupDelegate:delegate];
}

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        
        NSLog(@"this is initWithFrame in AbstractNChartView");
        self.middleLabel=[[UILabel alloc] init];
        self.middleLabel.backgroundColor=[UIColor clearColor];
        self.middleLabel.textColor=kcLikeRed;
        self.middleLabel.font=[UIFont fontWithName:@"Arial" size:60];
        self.middleLabel.adjustsFontSizeToFitWidth = YES;
        self.middleLabel.userInteractionEnabled = NO;
        self.middleLabel.numberOfLines = 1;
        self.middleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.middleLabel.textAlignment=NSTextAlignmentCenter;
        self.middleLabel.hidden=YES;
        [self addSubview:self.middleLabel];
        self.chart.legend.textColor=kcCharColor;
        self.chart.cartesianSystem.xAxis.textColor=kcCharColor;
        self.userInteractionEnabled=NO;
    }
    return self;
}



-(void)layoutSubviews
{
    CGFloat width=self.frame.size.width;
    CGFloat height=self.frame.size.height;
    CGFloat labelWidth= self.middleLabel.frame.size.width;
    CGFloat labelHeight=self.middleLabel.frame.size.height;
    CGFloat value= width>height? height:width;
    self.middleLabel.frame=CGRectMake(0.5*(width-labelWidth), 0.5*(height-labelHeight), 0.5*value, 0.5*value);
    //self.middleLabel.center=self.center;
    [super layoutSubviews];
    
}


-(void)setTextForMiddleLabel:(NSNumber*) number animation:(BOOL)isAnimated animationTime:(float)duration
{
    self.middleLabel.hidden=NO;
    self.FloatingNumber=number;
    float timeInterval=0.05f;
    float stepNum=duration/timeInterval;
    self.valuePerStep=[NSNumber numberWithFloat:([number floatValue]/stepNum)];
    
    if (!isAnimated)
    {
        if ([number floatValue]>=1)
            self.middleLabel.text=[NSString stringWithFormat:@"%d",(int)[number floatValue]] ;
        if ([number floatValue]>0&&[number floatValue]<1)
        {
            NSString* str=[NSString stringWithFormat:@"%d",(int)([number floatValue]*100)];
            self.middleLabel.text=[str stringByAppendingString:@"%"];
        }
        
        
    }
    else
    {
        self.timer =  [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.changingValue=[NSNumber numberWithFloat:0.0f];
    }
}
-(void)showMiddleFloatingNumber:(BOOL)isAnimated
{
    if (self.FloatingNumber!=nil)
    {
        self.middleLabel.hidden=NO;
        [self setTextForMiddleLabel:self.FloatingNumber animation:isAnimated animationTime:self.animationTime];
    }
    
}
-(void)onTimer:(NSTimer *)timer
{
    float val=[self.changingValue floatValue];
    val+=[self.valuePerStep floatValue];
    self.changingValue= [NSNumber numberWithFloat:val];
    if ([self.changingValue floatValue]<=[self.FloatingNumber floatValue])
    {
        if ([self.changingValue floatValue]>=1)
            self.middleLabel.text=[NSString stringWithFormat:@"%d",(int)[self.changingValue floatValue]] ;
        if ([self.changingValue floatValue]>0&&[self.changingValue floatValue]<1)
        {
            NSString* str=[NSString stringWithFormat:@"%d",(int)([self.changingValue floatValue]*100)];
            self.middleLabel.text=[str stringByAppendingString:@"%"];
        }
    }
    else
    {
        
        [self.timer invalidate];
        self.timer=nil;
        
    }
    
    
}
-(void)clean
{
    [super clean];
    
}

@end
