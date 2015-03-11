//
//  MYManagedObject.h
//  Adrianna_demo
//
//  Created by Lei Zhao on 15/01/2015.
//  Copyright (c) 2015 ey. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MYManagedObject : NSManagedObject
+ (instancetype)deserializeFromJsonObject:(id)jsonObject withManagedObjectContext:(NSManagedObjectContext*)moc;
- (void)deserializeFromJsonObject:(id)jsonObject;
- (NSDictionary*)serializeToJsonObject;
@end
