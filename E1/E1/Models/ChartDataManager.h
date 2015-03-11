//
//  ChartDataManager.h
//  E1
//
//  Created by Jack Lin on 17/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NChartDataModel.h"
#import <CoreData/CoreData.h>

@interface ChartDataManager : NSObject

-(void)storeChartDataToFile:(NSArray*) chartData fileName:(NSString*)file;//file is a whole file with directory
-(NSArray*)parseFromFile:(NSString*)file;//file is a whole file with directory
-(NSManagedObjectID*)insertChartData:(NChartDataModel*)chartData pageName:(NSString*)pageName;
-(NChartDataModel*)dataFetchRequestByObjectID:(NSManagedObjectID*)objectID;

+(NChartDataModel*)templateBarChartData;
+(NChartDataModel*)templateColumnChartData;
+(NChartDataModel*)templateRadarChartData;
+(NChartDataModel*)templateAreaChartData;
+(BOOL)deleteChartFile:(NSString*)pageName;
+(NSString*)getStoredFilePath:(NSString*)pageName;
+(id)defaultChartDataManager;
-(void)saveContext;
-(NSURL *)applicationDocumentsDirectory;
-(NSArray*)dataFetchRequest:(NSString*)pageName;
-(BOOL)updateChartData:(NChartDataModel*)chartData page:(NSString*)pageName;
-(NChartDataModel*)convertJSONToChartData:(NSData*)receivedData error:(NSError**)error;
@end
