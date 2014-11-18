//
//  AbstractNChartView.m
//  E1
//
//  Created by Jack Lin on 1/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AbstractNChartView.h"
#import "Definations.h"
@interface AbstractNChartView()
//@property(nonatomic,assign) BOOL didUpdateStraints;
//@property(nonatomic,strong) UILabel* label;
@property(nonatomic,strong) UILabel* middleLabel;
@property(nonatomic,strong) NSNumber* FloatingNumber;
@property(nonatomic,strong) NSNumber* valuePerStep;
@property(nonatomic,strong) NSTimer* timer;
@property(nonatomic,strong) NSNumber* changingValue;


@end

@implementation AbstractNChartView

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.middleLabel=[[UILabel alloc] init];
        self.middleLabel.backgroundColor=[UIColor clearColor];
        self.middleLabel.hidden=YES;
        self.middleLabel.textColor=kcLikeRed;
        
        self.middleLabel.font=[UIFont fontWithName:@"Arial" size:80];
        
        self.middleLabel.adjustsFontSizeToFitWidth = YES;
        self.middleLabel.userInteractionEnabled = NO;
        self.middleLabel.numberOfLines = 1;
        self.middleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.middleLabel.hidden=YES;
        [self addSubview:self.middleLabel];
        //self.didUpdateStraints=NO;
        
        self.chart.legend.textColor=kcCharColor;
        self.chart.cartesianSystem.xAxis.textColor=kcCharColor;
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

-(void)enableMiddleLabel
{
    self.middleLabel.hidden=NO;
}
-(void)disableMiddleLabel
{
    self.middleLabel.hidden=YES;
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
            self.middleLabel.text=[NSString stringWithFormat:@"0.%d",(int)([number floatValue]*100)];

    }
    else
    {
        self.timer =  [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        self.changingValue=[NSNumber numberWithFloat:0.0f];
        
        
        
        
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
            self.middleLabel.text=[NSString stringWithFormat:@"0.%d",(int)([self.changingValue floatValue]*100)];
    }
    else
         [self.timer setFireDate:[NSDate distantFuture]];
    
    
}

@end
