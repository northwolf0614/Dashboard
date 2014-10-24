//
//  DashBoardView.h
//  E1
//
//  Created by Jack Lin on 20/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParagraphView.h"

@interface DashBoardView : UIView

-(void)setPercent:(CGFloat)percent animated:(BOOL)animated;
-(void)startAnalyzeStatistics;
@end
