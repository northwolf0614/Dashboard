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
        self.middleLabel.textColor=[UIColor redColor];
        self.middleLabel.font=[UIFont fontWithName:@"Arial" size:120];
        self.middleLabel.adjustsFontSizeToFitWidth = YES;
        self.middleLabel.userInteractionEnabled = NO;
        self.middleLabel.numberOfLines = 1;
        self.middleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.middleLabel.hidden=YES;
        [self addSubview:self.middleLabel];
        //self.didUpdateStraints=NO;
    }
    return self;
}


-(void)layoutSubviews
{
    CGFloat xAdjustment= kcMiddleLabelSize/2;
    CGFloat yAdjustment= kcMiddleLabelSize/2;
    self.middleLabel.frame=CGRectMake(self.center.x-xAdjustment, self.center.y-yAdjustment, kcMiddleLabelSize, kcMiddleLabelSize);
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
