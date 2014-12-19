//
//  ChartDataManager.h
//  E1
//
//  Created by Jack Lin on 17/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NChartDataModel.h"

@interface ChartDataManager : NSObject
@property(nonatomic,strong)NSMutableArray* defaultChartDataQueue;
@property(nonatomic,strong)NSMutableArray* chartDataQueue;


-(void)storeChartDataToFile:(NSArray*) chartData fileName:(NSString*)file;
-(NSArray*)parseFromDefaultFile:(NSString*)file;
+(NSString*)getStoredDefaultFilePath;
+(NSString*)getStoredFilePath:(NSString*)pageName;
+(NChartDataModel*)templateBarChartData;
+(NChartDataModel*)templateColumnChartData;
+(NChartDataModel*)templateRadarChartData;
+(NChartDataModel*)templateAreaChartData;
-(NSArray*)parseFromFile:(NSString*)file;
+(BOOL)deleteChartFile:(NSString*)file;


+(id)defaultChartDataManager;
@end
