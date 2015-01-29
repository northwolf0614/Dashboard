//
//  AbstractCollectionViewCell.m
//  E1
//
//  Created by Jack Lin on 27/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AbstractCollectionViewCell.h"
#import "Definations.h"

@implementation AbstractCollectionViewCell

+ (NSString*)reuseIdentifier{
    return NSStringFromClass([self class]);
}
-(void)prepareForReuse
{
    [super prepareForReuse];
    [self updateColorScheme];
    [self clean];
}
-(void)clean
{}
-(void)updateColorScheme
{}
@end
