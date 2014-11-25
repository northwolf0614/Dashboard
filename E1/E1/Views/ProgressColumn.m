//
//  ProgressColumn.m
//  E1
//
//  Created by Jack Lin on 24/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "ProgressColumn.h"
#import "Definations.h"

@interface ProgressColumn()
@end




@implementation ProgressColumn

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width=self.animationLayer.frame.size.width;
    CGFloat height=self.animationLayer.frame.size.height;
    CGFloat width1=width*self.finalPercentage;
    //CGFloat width2=width-width1;
    CGFloat progressHeight=height/8;
    //set up path1
    UIBezierPath *circlePath1 = [UIBezierPath bezierPath];
    [circlePath1 addLineToPoint:CGPointMake(self.animationLayer.frame.origin.x, self.animationLayer.frame.origin.y+height-0.5*progressHeight)];
    [circlePath1 addLineToPoint:CGPointMake(self.animationLayer.frame.origin.x+width1, (self.animationLayer.frame.origin.y+height-0.5*progressHeight))];
    
    circlePath1.lineWidth=progressHeight;
    //set up path2
    UIBezierPath *circlePath2 = [UIBezierPath bezierPath];
    [circlePath2 addLineToPoint:CGPointMake(self.animationLayer.frame.origin.x+width1, self.animationLayer.frame.origin.y+height-0.5*progressHeight)];
    [circlePath2 addLineToPoint:CGPointMake(self.animationLayer.frame.origin.x+width, (self.animationLayer.frame.origin.y+height-0.5*progressHeight))];
    
    circlePath1.lineWidth=progressHeight;
    

    self.progressLayer.path=circlePath1.CGPath;
    //
    self.progressLayerPlus.path=circlePath2.CGPath;
    
}
@end
