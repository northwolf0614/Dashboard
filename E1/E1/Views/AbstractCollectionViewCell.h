//
//  AbstractCollectionViewCell.h
//  E1
//
//  Created by Jack Lin on 27/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractCollectionViewCell : UICollectionViewCell
+ (NSString*)reuseIdentifier;
-(void)updateColorScheme;
-(void)clean;
@end
