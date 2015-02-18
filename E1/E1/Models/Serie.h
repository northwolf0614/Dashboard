//
//  Serie.h
//  E1
//
//  Created by Jack Lin on 16/02/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AxisValue, MainMap;

@interface Serie : NSManagedObject

@property (nonatomic, retain) id brushColor;
@property (nonatomic, retain) NSString * seriesName;
@property (nonatomic, retain) NSNumber * seriesType;
@property (nonatomic, retain) NSSet *axisValues;
@property (nonatomic, retain) MainMap *mainMapData;
@end

@interface Serie (CoreDataGeneratedAccessors)

- (void)addAxisValuesObject:(AxisValue *)value;
- (void)removeAxisValuesObject:(AxisValue *)value;
- (void)addAxisValues:(NSSet *)values;
- (void)removeAxisValues:(NSSet *)values;

@end
