//
//  GeneralCollectionViewCell.m
//  E1
//
//  Created by Jack Lin on 27/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "CollectionViewCell.h"
#import "Definations.h"
@interface CollectionViewCell()

@property(nonatomic,assign) BOOL didSetupConstraintsGeneral;


@end

@implementation CollectionViewCell


-(void)prepareForReuse
{
    
    [super prepareForReuse];
    
}
-(void)layoutSubviews
{
    
    
    
    [super layoutSubviews];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        [self setup];
        
        
        
        
    }
    return self;
}
-(void)setup
{
    
    self.title=[[UILabel alloc] init];
    self.title.textColor=kcCharColor;
    self.title.font=[UIFont boldSystemFontOfSize:20.0f];
    self.title.backgroundColor=kcNavigationBarColor;
    self.title.numberOfLines = 1;
    self.title.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.title.textAlignment=NSTextAlignmentCenter;
    self.title.translatesAutoresizingMaskIntoConstraints=NO;
    self.viewContainer=[[UIView alloc] init];
    self.viewContainer.translatesAutoresizingMaskIntoConstraints=NO;
    [self.contentView addSubview:self.viewContainer];
    [self.contentView addSubview:self.title];
    
}
-(void)updateConstraints
{
    [super updateConstraints];
    
    if (self.didSetupConstraintsGeneral) {
        return;
    }
    if ([self isKindOfClass:[CollectionViewCell class]])
    {
        NSArray* constraints=[self.contentView constraints];
        if ([constraints count]>0)
        {
            [self.contentView removeConstraints:constraints];
        }
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[bar]-0-|" options:0 metrics:0 views:@{ @"bar" : self.title,@"container":self.viewContainer }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[container]-0-|" options:0 metrics:0 views:@{ @"bar" : self.title,@"container":self.viewContainer }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bar(44)]-0-[container]-0-|" options:0 metrics:0 views:@{ @"bar" : self.title,@"container":self.viewContainer }]];
        
        self.didSetupConstraintsGeneral=YES;
    }
    
    
    
    
}
-(void)loadView
{
        self.backgroundColor=[UIColor redColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowOffset = CGSizeMake(0, 3);
    
}







@end
