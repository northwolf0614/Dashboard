//
//  AxisValue.h
//  E1
//
//  Created by Jack Lin on 4/03/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Serie;

@interface AxisValue : NSManagedObject

@property (nonatomic, retain) NSNumber * axisValueType;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) Serie *serie;

@end
