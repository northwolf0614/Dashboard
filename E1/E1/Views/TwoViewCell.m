//
//  TwoViewCell.m
//  E1
//
//  Created by Jack Lin on 16/01/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import "TwoViewCell.h"
#import "ChartView.h"
#import "Definations.h"
#import "Progress.h"

@interface TwoViewCell()
@property(nonatomic,assign) BOOL didSetupConstraintsTwoViewCell;



@end
@implementation TwoViewCell

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self setupPercentageView];
        
        
        
        
    }
    return self;
}
-(void)setupPercentageView
{
    

    self.percentageView=[[Progress alloc] init];
    self.percentageView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.viewContainer addSubview:self.percentageView];
    self.percentageView.backgroundColor=kcWidgetBackColor;
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)updateConstraints
{
    [super updateConstraints];
//    if (self.didSetupConstraintsTwoViewCell) {
//        return;
//    }
    
    if ([self isKindOfClass:[TwoViewCell class]])
    {
        NSNumber* labelWidth=[NSNumber numberWithInteger:(NSUInteger)self.frame.size.height*0.2];
        NSNumber* labelHeight=[NSNumber numberWithInteger:(NSUInteger)self.frame.size.height*0.2];
        NSNumber* percentageHeight=[NSNumber numberWithInteger:(NSUInteger)self.frame.size.height*0.3];
        NSDictionary* metrics=@{@"labelWidth":labelWidth,@"labelHeight":labelHeight,@"percentageHeight":percentageHeight};
        NSArray* constraints=[self.viewContainer constraints];
        if ([constraints count]>0)
        {
            [self.viewContainer removeConstraints:constraints];
        }
        [self.viewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[percentageView]-0-[label(labelWidth)]-0-|" options:0 metrics:metrics views:@{ @"chartView" : self.chartView,@"label":self.yearLabel,@"percentageView":self.percentageView}]];
        [self.viewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-|" options:0 metrics:metrics views:@{ @"chartView" : self.chartView,@"label":self.yearLabel,@"percentageView":self.percentageView}]];
        [self.viewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[percentageView(percentageHeight)]-0-[chartView]-0-|" options:0 metrics:metrics views:@{ @"chartView" : self.chartView,@"label":self.yearLabel,@"percentageView":self.percentageView}]];
        [self.viewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[label(labelHeight)]->=0-[chartView]-0-|" options:0 metrics:metrics views:@{ @"chartView" : self.chartView,@"label":self.yearLabel,@"percentageView":self.percentageView}]];
        //self.didSetupConstraintsTwoViewCell=YES;
    }
    

    
}
-(void)updateColorScheme
{
    
    
    [super updateColorScheme];
    self.percentageView.backgroundColor=kcWidgetBackColor;
    
    
}
-(void)clean
{
    [super clean];
    [self.percentageView clean];

}



@end
