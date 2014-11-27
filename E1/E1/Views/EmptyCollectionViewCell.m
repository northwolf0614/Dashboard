//
//  EmptyCollectionViewCell.m
//  E1
//
//  Created by Jack Lin on 27/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "EmptyCollectionViewCell.h"
#import "Definations.h"

@implementation EmptyCollectionViewCell


- (void)awakeFromNib{
    [super awakeFromNib];
    self.emptyImageView.backgroundColor=kcWidgetBackColor;


}
@end
