//
//  NChartDataModel.h
//  E1
//
//  Created by Jack Lin on 1/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
typedef enum : NSUInteger {
Dimention2,
Dimention3,
} NChartType;
typedef enum : NSUInteger {
    COLUMN,
    BAR,
    AREA,
    LINE,
    STEPLINE,
    BIBBON,
    PIE,
    DOUGHNUT,
    BUBBLE,
    SCATTER,
    SURFACE,
    CANDLESTICK,
    OHLC,
    BAND,
    SEQUENCE,
    RADAR,
    FUNNEL,
    HEATMAP,
    
} NSeriesType;
typedef enum : NSUInteger {
    ABSOLUTE,
    ADDITIVE,
    PERCENT,
} AxisType;
typedef enum : NSUInteger {
    XAXISVALUE,
    YAXISVALUE,
    ZAXISVALUE,
} AxisValueType;
@interface PrototypeDataModel : NSObject<NSCoding,NSCopying>
@property(nonatomic,copy)   NSString* seriesName;
@property(nonatomic,strong) NSArray* chartAxisXValues;
@property(nonatomic,strong) NSArray* chartAxisYValues;
@property(nonatomic,strong) NSArray* chartAxisZValues;
@property(nonatomic,assign) NSeriesType seriesType;
@property(nonatomic,strong) UIColor* brushColor;
-(NSDictionary*)serializeToDicForJSON;
+(PrototypeDataModel*)deserializeFromJSON:(id)jsonData;
@end


@interface AddedMap : NSObject<NSCoding,NSCopying>

@property (nonatomic, retain) UIColor * color1;
@property (nonatomic, retain) UIColor * color2;
@property (nonatomic, retain) NSNumber * percentage;
@property (nonatomic, retain) NSNumber * floatingNumber;
-(NSDictionary*)serializeToDicForJSON;
+(AddedMap*)deserializeFromJSON:(id)jsonData;
@end


@interface ChartPrediction : NSObject<NSCoding,NSCopying>
@property (nonatomic,strong) NSNumber* base;
@property (nonatomic,strong) NSNumber* mult1;
@property (nonatomic,strong) NSNumber* mult2;
@property (nonatomic,strong) NSNumber* key;
-(NSDictionary*)serializeToDicForJSON;
+(ChartPrediction*)deserializeFromJSON:(id)jsonData;
@end

@interface NChartDataModel : NSObject<NSCoding,NSCopying>

@property(nonatomic,strong) NSManagedObjectID* objectID;
@property(nonatomic,copy)   NSString* chartCaption;
@property(nonatomic,copy)   NSString* chartAxisYCaption;
@property(nonatomic,copy)   NSString* chartAxisXCaption;
@property(nonatomic,copy)   NSString* chartAxisZCaption;
@property(nonatomic,strong) NSArray* chartAxisXTicksValues;
@property(nonatomic,strong) NSArray* chartAxisYTicksValues;
@property(nonatomic,strong) NSArray* chartAxisZTicksValues;
@property(nonatomic,assign) NSeriesType chartType;
@property(nonatomic,assign) AxisType axisType;
@property(nonatomic,strong) NSString* pageName;
@property(nonatomic,strong) NSMutableDictionary* chartDataForDrawing;
@property(nonatomic,strong) AddedMap* dataForNextView;
@property(nonatomic,strong) NSString* labelText;
@property(nonatomic,strong) NSNumber* percentage;
@property(nonatomic,strong) NSNumber* floatingNumber;
@property(nonatomic,strong) NSMutableSet* prediction;

//not stored permanantly only for programming
@property(nonatomic,assign) BOOL isAnimated;
@property(nonatomic,assign) BOOL empty;
//not stored permanantly only for programming

//not used
@property(nonatomic,assign) BOOL isToolTips;
@property(nonatomic,strong) NSNumber* sliceNumber;
@property(nonatomic,assign) BOOL isBorder;
//not used



//+(NSString*)getStoredDefaultFilePath;
+(NSArray*)chartDataDefault;
+(NSMutableDictionary*)radarSeriesData;
-(NSDictionary*)serializeToDicForJSON;
+(NChartDataModel*)deserializeFromJSON:(id)jsonData;






@end
