//
//  GeneralCollectionViewCell.m
//  E1
//
//  Created by Jack Lin on 27/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "GeneralCollectionViewCell.h"

@implementation GeneralCollectionViewCell

-(void)prepareForReuse
{
//    NSLog(@"This is prepareForReuse");
//    for (UIView* view in self.contentView.subviews)
//    {
//        [view removeFromSuperview];
//    }
//    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [super prepareForReuse];
}

@end
