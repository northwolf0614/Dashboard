//
//  GeneralCollectionViewCell.h
//  E1
//
//  Created by Jack Lin on 27/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AbstractCollectionViewCell.h"

@interface CollectionViewCell : AbstractCollectionViewCell

-(void)showCharts:(BOOL)isAnimated;
@property(nonatomic,strong)UIView* viewContainer;
@property(nonatomic,strong)UINavigationBar* naviBar;
@end