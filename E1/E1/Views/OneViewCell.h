//
//  OneViewCell.h
//  E1
//
//  Created by Jack Lin on 16/01/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import "CollectionViewCell.h"
#import "ChartView.h"

@interface OneViewCell : CollectionViewCell
@property(nonatomic,strong) UILabel* yearLabel;
@property(nonatomic,strong) ChartView* chartView;
@property(nonatomic,strong) UIView* controllerView;

@end
