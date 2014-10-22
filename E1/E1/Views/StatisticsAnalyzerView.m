//
//  StatisticsAnalyzerView.m
//  E1
//
//  Created by Jack Lin on 22/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "StatisticsAnalyzerView.h"
#import "AnalyzerLayerDelegate.h"
#import "CATransform3DPerspect.h"

@interface StatisticsAnalyzerView()
@property(nonatomic, strong) CALayer* statisticsLayer1;
@property(nonatomic, strong) CALayer* statisticsLayer2;
@property(nonatomic,strong)  AnalyzerLayerDelegate* layer1Delegate;
@property(nonatomic,strong)  AnalyzerLayerDelegate* layer2Delegate;
@end

@implementation StatisticsAnalyzerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self!=nil) {
        self.backgroundColor=[UIColor whiteColor];
        self.layer1Delegate= [[AnalyzerLayerDelegate alloc] init];
        self.layer2Delegate= [[AnalyzerLayerDelegate alloc] init];
        self.statisticsLayer1=[CALayer layer];
        self.statisticsLayer1.backgroundColor=[[UIColor lightGrayColor] CGColor];
        
        
        self.statisticsLayer1.shadowOffset = CGSizeMake(10, 10);
        self.statisticsLayer1.shadowRadius = 5;
        self.statisticsLayer1.shadowOpacity = 0.5;
        
        self.statisticsLayer2=[CALayer layer];
        self.statisticsLayer2.backgroundColor=[[UIColor redColor] CGColor];
        
        self.statisticsLayer2.shadowOffset = CGSizeMake(10, 10);
        self.statisticsLayer2.shadowRadius = 5;
        self.statisticsLayer2.shadowOpacity = 0.5;


        
        self.statisticsLayer1.frame=CGRectMake(0,240,frame.size.width/3,100);
        self.statisticsLayer2.frame=CGRectMake(160,240,frame.size.width/3,100);
        [self.layer addSublayer:self.statisticsLayer1];
        [self.layer addSublayer:self.statisticsLayer2];
        self.statisticsLayer1.delegate=self.layer1Delegate;
        self.statisticsLayer2.delegate=self.layer2Delegate;
        
    }
    return self;
    
}
-(void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [self.statisticsLayer2 setNeedsDisplay];
    [self.statisticsLayer1 setNeedsDisplay];
    
}


-(void) startAnalyzeStatistics
{
    CATransform3D rotate = CATransform3DMakeRotation(M_PI/3, 0, 1, 0);
    self.statisticsLayer1.transform=CATransform3DPerspect(rotate, CGPointMake(0, 0), 200);
    self.statisticsLayer2.transform=CATransform3DPerspect(rotate, CGPointMake(0, 0), 200);
}













@end


