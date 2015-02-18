//
//  AxisTickValue.h
//  E1
//
//  Created by Jack Lin on 16/02/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MainMap;

@interface AxisTickValue : NSManagedObject

@property (nonatomic, retain) NSNumber * axisValueType;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) MainMap *mainMapData;

@end
