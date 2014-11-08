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
@property(nonatomic,assign) BOOL didUpdateStraints;
@property(nonatomic,strong) UILabel* label;
@property(nonatomic,strong) UILabel* middleLabel;
@end

@implementation AbstractNChartView

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.label=[[UILabel alloc] init];
        self.label.translatesAutoresizingMaskIntoConstraints=NO;
        self.label.backgroundColor=[UIColor clearColor];
        self.label.hidden=NO;
        self.label.textColor=[UIColor blackColor];
        self.label.font=[UIFont fontWithName:@"Arial" size:30];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.userInteractionEnabled = NO;
        //self.label.text=@"2014";
        
        
        
        
        //NSLog(@"this is center point.x %f",self.center.x);
        self.middleLabel=[[UILabel alloc] init];
        self.middleLabel.backgroundColor=[UIColor clearColor];
        self.middleLabel.hidden=NO;
        self.middleLabel.textColor=[UIColor redColor];
        self.middleLabel.font=[UIFont fontWithName:@"Arial" size:120];
        self.middleLabel.adjustsFontSizeToFitWidth = YES;
        self.middleLabel.userInteractionEnabled = NO;
         self.middleLabel.numberOfLines = 1;
        self.middleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        //self.middleLabel.text=@"49";

        [self addSubview:self.label];
        [self addSubview:self.middleLabel];
        self.didUpdateStraints=NO;
    }
    return self;
}


-(void)layoutSubviews
{
    CGFloat xAdjustment= kcMiddleLabelSize/2;
    CGFloat yAdjustment= kcMiddleLabelSize/2;
    self.middleLabel.frame=CGRectMake(self.center.x-xAdjustment, self.center.y-yAdjustment, kcMiddleLabelSize, kcMiddleLabelSize);
    [super layoutSubviews];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}



-(void)updateConstraints
{
    
    [super updateConstraints];
    
    if (self.didUpdateStraints)
    {
        return;
    }
    else
    {
        
        NSArray *tmpConstraints;
        NSDictionary* metrics    = @{@"smallPadding":@5,@"sizeWidth":@50,@"sizeHeight":@50};
        
        {
            
            tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=smallPadding-[textLabel(sizeWidth)]-smallPadding-|" options:0 metrics:metrics views:@{ @"textLabel":self.label}];
            [self addConstraints:tmpConstraints];
            tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-smallPadding-[textLabel(sizeHeight)]->=smallPadding-|" options:0 metrics:metrics views:@{ @"textLabel":self.label}];
            [self addConstraints:tmpConstraints];
            self.didUpdateStraints=YES;
            
            
            
        }
        
        
        
    }
    
 
}
-(void)enableRightTopLabel
{
    self.label.hidden=NO;
}
-(void)enableMiddleLabel
{
    self.middleLabel.hidden=NO;
}

-(void)disableRightTopLabel
{
    self.label.hidden=YES;
}
-(void)disableMiddleLabel
{
    self.middleLabel.hidden=YES;
}
-(void)setTextForMiddleLabel:(NSString*) text
{
    self.middleLabel.text=text;
}

-(void)setTextForTopRightLabel:(NSString*) text
{
    self.label.text=text;
}




@end
