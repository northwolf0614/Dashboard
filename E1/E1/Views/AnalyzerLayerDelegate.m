//
//  AnalyzerLayerDelegate.m
//  E1
//
//  Created by Jack Lin on 22/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AnalyzerLayerDelegate.h"

@implementation AnalyzerLayerDelegate
- (void)drawLayer:(CALayer*)layer inContext:(CGContextRef)ctx
{
    //this function shall be override by your real content
    UIGraphicsPushContext(ctx);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(16.72, 7.22)];
    [path addLineToPoint:CGPointMake(3.29, 20.83)];
    [path addLineToPoint:CGPointMake(0.4, 18.05)];
    [path addLineToPoint:CGPointMake(18.8, -0.47)];
    [path addLineToPoint:CGPointMake(37.21, 18.05)];
    [path addLineToPoint:CGPointMake(34.31, 20.83)];
    [path addLineToPoint:CGPointMake(20.88, 7.22)];
    [path addLineToPoint:CGPointMake(20.88, 42.18)];
    [path addLineToPoint:CGPointMake(16.72, 42.18)];
    [path addLineToPoint:CGPointMake(16.72, 7.22)];
    [path closePath];
    path.lineWidth = 1;
    [[UIColor yellowColor] setStroke];
    [path stroke];
    UIGraphicsPopContext();
    
}
@end
