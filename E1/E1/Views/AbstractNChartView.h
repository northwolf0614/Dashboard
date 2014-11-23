//
//  AbstractNChartView.h
//  E1
//
//  Created by Jack Lin on 1/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <NChart3D/NChart3D.h>

@interface AbstractNChartView : NChartView
@property(nonatomic,strong) UILabel* middleLabel;
//-(void)enableRightTopLabel;
-(void)enableMiddleLabel;

//-(void)disableRightTopLabel;
-(void)disableMiddleLabel;

-(void)setTextForMiddleLabel:(NSNumber*) number animation:(BOOL)isAnimated animationTime:(float)duration;
//-(void)setTextForTopRightLabel:(NSString*) text;


@end
