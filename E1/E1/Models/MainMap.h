//
//  MainMap.h
//  E1
//
//  Created by Jack Lin on 4/03/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AxisTickValue, PlusMap, Prediction, Serie;

@interface MainMap : NSManagedObject

@property (nonatomic, retain) NSNumber * axisType;
@property (nonatomic, retain) NSString * chartAxisXCaption;
@property (nonatomic, retain) NSString * chartAxisYCaption;
@property (nonatomic, retain) NSString * chartAxisZCaption;
@property (nonatomic, retain) NSString * chartCaption;
@property (nonatomic, retain) NSNumber * chartType;
@property (nonatomic, retain) NSNumber * floatingNumber;
@property (nonatomic, retain) NSString * labelText;
@property (nonatomic, retain) NSString * pageName;
@property (nonatomic, retain) NSNumber * percentage;
@property (nonatomic, retain) NSSet *chartAxisTickValues;
@property (nonatomic, retain) PlusMap *plusMapData;
@property (nonatomic, retain) NSSet *prediction;
@property (nonatomic, retain) NSSet *series;
@end

@interface MainMap (CoreDataGeneratedAccessors)

- (void)addChartAxisTickValuesObject:(AxisTickValue *)value;
- (void)removeChartAxisTickValuesObject:(AxisTickValue *)value;
- (void)addChartAxisTickValues:(NSSet *)values;
- (void)removeChartAxisTickValues:(NSSet *)values;

- (void)addPredictionObject:(Prediction *)value;
- (void)removePredictionObject:(Prediction *)value;
- (void)addPrediction:(NSSet *)values;
- (void)removePrediction:(NSSet *)values;

- (void)addSeriesObject:(Serie *)value;
- (void)removeSeriesObject:(Serie *)value;
- (void)addSeries:(NSSet *)values;
- (void)removeSeries:(NSSet *)values;

@end
