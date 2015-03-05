//
//  Prediction.h
//  E1
//
//  Created by Jack Lin on 4/03/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MainMap;

@interface Prediction : NSManagedObject

@property (nonatomic, retain) NSNumber * base;
@property (nonatomic, retain) NSNumber * key;
@property (nonatomic, retain) NSNumber * multiplier1;
@property (nonatomic, retain) NSNumber * multiplier2;
@property (nonatomic, retain) MainMap *mainMapData;

@end
