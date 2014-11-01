//
//  NChartDataModel.h
//  E1
//
//  Created by Jack Lin on 1/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
Dimention2,
Dimention3,
} NChartType;
typedef enum : NSUInteger {
    COLUMN,
    AREA,
    LINE,
    BUBBLE,
    SCATTER,
} NSeriesType;
@interface PrototypeDataModel : NSObject<NSCopying>
@property(nonatomic,copy)   NSString* seriesName;
@property(nonatomic,strong) NSArray* chartAxisXTicksValues;
@property(nonatomic,strong) NSArray* chartAxisYTicksValues;
@property(nonatomic,strong) NSArray* chartAxisZTicksValues;
@property(nonatomic,assign) NChartType seriesType;
@end


@interface NChartDataModel : NSObject<NSCoding>
@property(nonatomic,copy) NSString* chartCaption;
@property(nonatomic,copy) NSString* chartAxisYCaption;
@property(nonatomic,copy) NSString* chartAxisXCaption;
@property(nonatomic,copy) NSString* chartAxisZCaption;
@property(nonatomic,assign) NChartType chartType;
@property(nonatomic,strong) NSMutableDictionary* chartDataForDrawing;

-(void)saveDataForKey:(NSString*)key;
+(NChartDataModel*)loadDataWithKey:(NSString*)key;
+(NSString*)getStoredDefaultFilePath;
@end
