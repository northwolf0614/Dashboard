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
    self.backgroundColor=kcWidgetBackColor;
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowOffset = CGSizeMake(0, 3);
}
-(void)updateColorScheme;
{
    self.backgroundColor=kcWidgetBackColor;
}
@end
