//
//  MYManagedObject.m
//  Adrianna_demo
//
//  Created by Lei Zhao on 15/01/2015.
//  Copyright (c) 2015 ey. All rights reserved.
//

#import "MYManagedObject.h"
//#import "Utility.h"
//#import "NSEntityDescription+Utility.h"
//#import "NSPropertyDescription+Utility.h"
//#import "NSRelationshipDescription+Utility.h"
//#import "NSAttributeDescription+Utility.h"

@implementation MYManagedObject

+ (instancetype)deserializeFromJsonObject:(id)jsonObject withManagedObjectContext:(NSManagedObjectContext *)moc{
    if (jsonObject == nil) {
        return nil;
    }
    
    MYManagedObject* this = nil;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[NSStringFromClass([self class]) substringFromIndex:2] inManagedObjectContext:moc];
    //NSString* primaryKey = entityDescription.primaryKey;
    
    if (primaryKey && jsonObject[primaryKey])
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", primaryKey, jsonObject[primaryKey]]];
        NSArray *array = [moc executeFetchRequest:request error:nil];
        if (array && array.count > 0) {
            this = array[0];
        }
    }
    
    if (this == nil) {
        this = (MYManagedObject*)[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:moc];
    }
    
    [this deserializeFromJsonObject:jsonObject];
    
    return this;
}

- (void)deserializeFromJsonObject:(id)jsonObject
{
    //Attributes
    [self.entity.attributesByName enumerateKeysAndObjectsUsingBlock:^(NSString* name, NSAttributeDescription* attribute, BOOL* stop){
        NSString* jsonKey = name;
        int i = 0;
        while (jsonObject[jsonKey] == nil) {
            if (i >= attribute.alias.count) {
                return;
            }
            jsonKey = attribute.alias[i++];
        }
        
        switch (attribute.attributeType) {
            case NSDateAttributeType:
                [self setValue:[jsonObject[jsonKey] dateValueAsFormat:nil] forKey:name];
                break;
//            case NSBooleanAttributeType:
//                [self setValue:[NSNumber numberWithBool:[jsonObject[jsonKey] isEqualToString:@"true"]] forKey:name];
//                break;
            case NSInteger32AttributeType:
                [self setValue:[NSNumber numberWithInteger:[jsonObject[jsonKey] integerValue]] forKey:name];
                break;
            case NSDoubleAttributeType:
                [self setValue:[NSNumber numberWithDouble:[jsonObject[jsonKey] doubleValue]] forKey:name];
                break;
            case NSFloatAttributeType:
                [self setValue:[NSNumber numberWithFloat:[jsonObject[jsonKey] floatValue]] forKey:name];
                break;
            default:
                [self setValue:jsonObject[jsonKey] forKey:name];
                break;
        }
    }];
    
    //Relationships
    [self.entity.relationshipsByName enumerateKeysAndObjectsUsingBlock:^(NSString* name, NSRelationshipDescription* relationship, BOOL* stop){
        if (relationship.inverseRelationship) {
            return;
        }
        
        NSString* jsonKey = name;
        int i = 0;
        while (jsonObject[jsonKey] == nil) {
            if (i >= relationship.alias.count) {
                return;
            }
            jsonKey = relationship.alias[i++];
        }
        
        
        Class destinationManagedObjectClass = NSClassFromString(relationship.destinationEntity.managedObjectClassName);
        if (relationship.toMany) {
            NSMutableSet* set = [NSMutableSet setWithCapacity:[jsonObject[name] count]];
            [(NSArray*)jsonObject[jsonKey] enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL* stop){
                NSManagedObject* destinationManagedObject = [destinationManagedObjectClass deserializeFromJsonObject:object withManagedObjectContext:self.managedObjectContext];
                [set addObject:destinationManagedObject];
            }];
            [self setValue:set forKey:name];
        }
        else{
            NSManagedObject* destinationManagedObject = [destinationManagedObjectClass deserializeFromJsonObject:jsonObject[jsonKey] withManagedObjectContext:self.managedObjectContext];
            [self setValue:destinationManagedObject forKey:name];
        }
    }];
}
/*
 case UndefinedAttributeType
 case Integer16AttributeType
 case Integer32AttributeType
 case Integer64AttributeType
 case DecimalAttributeType
 case DoubleAttributeType
 case FloatAttributeType
 case StringAttributeType
 case BooleanAttributeType
 case DateAttributeType
 case BinaryDataAttributeType
 case TransformableAttributeType
 case ObjectIDAttributeType
 */
- (NSDictionary*)serializeToDicForJsonObject{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:self.entity.properties.count];
    
    //Attributes
    [self.entity.attributesByName enumerateKeysAndObjectsUsingBlock:^(NSString* name, NSAttributeDescription* attribute, BOOL* stop){
        if ([self valueForKey:name] == nil) {
            return;
        }
        
        switch (attribute.attributeType) {
            case NSDateAttributeType:
                dict[name] = [[self valueForKey:name] stringAsFormat:nil];
                break;
            case NSBooleanAttributeType:
                dict[name] = [[self valueForKey:name] boolValue] ? @"true" : @"false";
                break;
            case NSInteger32AttributeType:
                dict[name] = [NSString stringWithFormat:@"%ld", (long)[[self valueForKey:name] integerValue]];
                break;
            case NSDoubleAttributeType:
                dict[name] = [NSString stringWithFormat:@"%.2f", [[self valueForKey:name] doubleValue]];
                break;
            case NSFloatAttributeType:
                dict[name] = [NSString stringWithFormat:@"%.2f", [[self valueForKey:name] floatValue]];
                break;
            default:
                dict[name] = [self valueForKey:name];
                break;
        }
    }];
    
    //Relationships
    [self.entity.relationshipsByName enumerateKeysAndObjectsUsingBlock:^(NSString* name, NSRelationshipDescription* relationship, BOOL* stop){
        if (relationship.inverseRelationship) {
            return;
        }
        
        if (relationship.toMany) {
            NSSet* values = [self valueForKey:name];
            if (values.count > 0) {
                NSMutableArray* array = [NSMutableArray arrayWithCapacity:values.count];
                [values enumerateObjectsUsingBlock:^(MYManagedObject* object, BOOL* stop){
                    [array addObject:[object serializeToJsonObject]];
                }];
                dict[name] = array;
            }
        }
        else{
            if ([self valueForKey:name]) {
                dict[name] = [[self valueForKey:name] serializeToJsonObject];
            }
        }
    }];
    
    return dict;
}
@end
