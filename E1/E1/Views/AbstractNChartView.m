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
-(void)setTextForMiddleLabel:(NSString*) text
{
    self.middleLabel.hidden=NO;
    self.middleLabel.text=text;
}





@end
