//
//  AbstractNChartView.m
//  E1
//
//  Created by Jack Lin on 1/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AbstractNChartView.h"
@interface AbstractNChartView()
@property(nonatomic,assign) BOOL didUpdateStraints;
@end

@implementation AbstractNChartView

-(id)init
{
    if (self=[super init])
    {
        self.label=[[UILabel alloc] init];
        self.label.translatesAutoresizingMaskIntoConstraints=NO;
        self.label.backgroundColor=[UIColor clearColor];
        //self.label.text=@"28";
        [self addSubview:self.label];
        self.didUpdateStraints=NO;
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}



-(void)updateConstraints
{
    
    [super updateConstraints];
    if (self.didUpdateStraints) {
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






@end
