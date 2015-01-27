//
//  TwoViewCell.h
//  E1
//
//  Created by Jack Lin on 16/01/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import "CollectionViewCell.h"
#import "OneViewCell.h"
#import "Progress.h"
#import "NChartViewCell.h"
@interface TwoViewCell : NChartViewCell
@property(nonatomic,strong) Progress* percentageView;
@end
