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
@interface PrototypeDataModel : NSObject<NSCoding,NSCopying>
@property(nonatomic,copy)   NSString* seriesName;
@property(nonatomic,strong) NSArray* chartAxisXValues;
@property(nonatomic,strong) NSArray* chartAxisYValues;
@property(nonatomic,strong) NSArray* chartAxisZValues;
@property(nonatomic,assign) NSeriesType seriesType;
@property(nonatomic,strong) UIColor* brushColor;
@end


@interface NChartDataModel : NSObject<NSCoding,NSCopying>
@property(nonatomic,copy)   NSString* chartCaption;
@property(nonatomic,copy) NSString* chartAxisYCaption;
@property(nonatomic,copy) NSString* chartAxisXCaption;
@property(nonatomic,copy) NSString* chartAxisZCaption;
@property(nonatomic,strong) NSArray* chartAxisXTicksValues;
@property(nonatomic,strong) NSArray* chartAxisYTicksValues;
@property(nonatomic,strong) NSArray* chartAxisZTicksValues;
//@property(nonatomic,assign) NChartType chartType;
@property(nonatomic,assign) NSeriesType chartType;
@property(nonatomic,assign) AxisType axisType;
@property(nonatomic,assign) BOOL isToolTips;
@property(nonatomic,strong) NSNumber* sliceNumber;
@property(nonatomic,assign) BOOL isBorder;
@property(nonatomic,strong) NSMutableDictionary* chartDataForDrawing;//key-value: prototypeDataModel.seriesname-prototypeDataModel instance
@property(nonatomic,strong) NChartDataModel* dataForNextView;
@property(nonatomic,strong) NSString* labelText;
@property(nonatomic,strong) NSNumber* percentage;
@property(nonatomic,strong) NSNumber* floatingNumber;
@property(nonatomic,assign) BOOL isAnimated;
+(NSString*)getStoredDefaultFilePath;
+(NSArray*)chartDataDefault;
+(NSMutableDictionary*)radarSeriesData;
//+(NChartDataModel*) radarChart;
-(void)adaptedForFloatingNumber;
-(void)updateSeries:(NSDictionary*) seriesData;





@end
