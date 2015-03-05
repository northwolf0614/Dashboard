//
//  PlusMap.h
//  E1
//
//  Created by Jack Lin on 4/03/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MainMap;

@interface PlusMap : NSManagedObject

@property (nonatomic, retain) id color1;
@property (nonatomic, retain) id color2;
@property (nonatomic, retain) NSNumber * finalPercentage;
@property (nonatomic, retain) NSNumber * floatingNumber;
@property (nonatomic, retain) MainMap *mainMapData;

@end
