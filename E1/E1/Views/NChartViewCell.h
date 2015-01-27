//
//  OneViewCell.h
//  E1
//
//  Created by Jack Lin on 16/01/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import "SingleChartView.h"
#import "CollectionViewCell.h"
@interface NChartViewCell : CollectionViewCell
@property(nonatomic,strong) SingleChartView* chartView;
@property(nonatomic,strong) UIView* controllerView;
@property(nonatomic,strong) UILabel* yearLabel;

@end
