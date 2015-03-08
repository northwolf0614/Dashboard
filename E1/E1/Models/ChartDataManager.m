//
//  ChartDataManager.m
//  E1
//
//  Created by Jack Lin on 17/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "ChartDataManager.h"
#import "Definations.h"
#import "NChartDataModel.h"
#import "MainMap.h"
#import "PlusMap.h"
#import "AxisTickValue.h"
#import "AxisValue.h"
#import "Serie.h"
#import "Prediction.h"

@interface ChartDataManager()
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//+(NSString*)getStoredDefaultFilePath;


@end


@implementation ChartDataManager



-(void)storeChartDataToFile:(NSArray*) chartData fileName:(NSString*)file
{
    if (chartData==nil) {
        return ;
    }
    

    {

        for (NChartDataModel* chart in chartData) {
            [self insertChartData:chart pageName:[file lastPathComponent]];
        }
    }
    
    
    
    

    
}

+(BOOL)deleteChartFile:(NSString*)pageName
{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSMutableArray* chartNames=[NSMutableArray array];
//    NSMutableData   * data = [[NSMutableData alloc] init];
    NSFileManager* manager=[NSFileManager defaultManager];
    NSString* filePath=[ChartDataManager getStoredFilePath:pageName ];
    
    if ([manager fileExistsAtPath:filePath])
    {
        if ([manager removeItemAtPath:filePath error:nil])
        {
            return YES;
        }
        else
            return NO;
        
    }
    return NO;
    
    
    
}


-(NSArray*)parseFromFile:(NSString*)file
{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSDictionary *userd = [userDefault dictionaryRepresentation];
//    NSMutableArray* array=[NSMutableArray array];
//    if ([userd.allKeys containsObject:kcPagesArrayName])
//    {
//        NSArray* pageNameArray=[userd objectForKey: kcPagesArrayName];
//        if ([pageNameArray containsObject:[[file stringByDeletingPathExtension] lastPathComponent]])
//        {
//            NSFileManager* manager=[NSFileManager defaultManager];
//            if(![manager fileExistsAtPath:file])
//                return nil;
//            NSData *data = [NSData dataWithContentsOfFile:file];
//            if ([data length]==0)
//            {
//                return nil;
//            }
//            // 根据数据，解析成一个NSKeyedUnarchiver对象
//            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//            for (NSString* chartName in [userd objectForKey:[[file stringByDeletingPathExtension] lastPathComponent]])
//            {
//                [array addObject:[unarchiver decodeObjectForKey:chartName]];
//            }
//            
//            [unarchiver finishDecoding];
//            return array;
//        }
//        
//        
//    }
//    
//    
//    
//    
//    return nil;
    return [self dataFetchRequest:[file lastPathComponent]];
    
}

//+(NSString*)getStoredDefaultFilePath
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docPath = [paths objectAtIndex:0];
//    return [docPath stringByAppendingPathComponent:kcDefaultDataFielName];
//}

+(NSString*)getStoredFilePath:(NSString*)pageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    return [docPath stringByAppendingPathComponent:[pageName stringByAppendingString:@".plist"]];
}
+(id)defaultChartDataManager
{
    static dispatch_once_t pred;
    static ChartDataManager* manager=nil;
    dispatch_once(&pred, ^{
                    manager = [[ChartDataManager alloc] init];
    });
    
    return manager;
    
    
}


+(NChartDataModel*)templateBarChartData
{
    NChartDataModel* chartData2=[[NChartDataModel alloc] init];
    chartData2.chartCaption=@"Calls Waiting in Line";
    chartData2.chartAxisXCaption=@"percentage";
    chartData2.chartAxisYCaption=@"Years";
    chartData2.chartType=BAR;
    //chartData2.chartAxisYTicksValues=[NSArray arrayWithObjects:@"one",@"Two",nil];
    chartData2.chartAxisYTicksValues=[NSArray arrayWithObjects:@"one",@"",@"",@"",nil];
    
    chartData2.chartDataForDrawing= [NSMutableDictionary dictionary];
    
    //setup rawData3
    PrototypeDataModel* rawData3=[[PrototypeDataModel alloc] init];
    rawData3.seriesName=@"In call";
    rawData3.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],nil];
    //rawData3.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.2],nil];
    rawData3.seriesType=BAR;
    rawData3.brushColor=kcLikeOrange;
    //rawData3.brushColor=[UIColor colorWithRed:236 green:250 blue:48 alpha:1];
    //setup data4
    PrototypeDataModel* rawData4=[[PrototypeDataModel alloc] init];
    rawData4.seriesName=@"Inactive";
    rawData4.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],nil];
    //rawData4.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.4],nil];
    rawData4.seriesType=BAR;
    rawData4.brushColor=kcLikeGray;
    //rawData4.brushColor=[UIColor colorWithRed:47 green:45 blue:55 alpha:1];
    
    //additive
    [chartData2.chartDataForDrawing setObject:rawData3 forKey:rawData3.seriesName];
    [chartData2.chartDataForDrawing setObject:rawData4 forKey:rawData4.seriesName];
    chartData2.axisType=ADDITIVE;
    //[chartData2 adaptedForFloatingNumber];
    chartData2.floatingNumber=[NSNumber numberWithDouble:10.0f];
    //chartData2.floatingNumber=0.1;
    
    chartData2.labelText=@"2014";
    return chartData2;
    
    
}
+(NChartDataModel*)templateColumnChartData
{
    
    
//    //doughnut
//    NChartDataModel* chartData3=[[NChartDataModel alloc] init];
//    chartData3.chartCaption=@"doughnut";
//    chartData3.chartAxisXCaption=@"product percentage";
//    chartData3.chartAxisYCaption=@"Years";
//    //chartData3.chartType=Dimention2;
//    chartData3.chartAxisYTicksValues=[NSArray arrayWithObjects:@"2000",@"2001",@"2002",@"2003",nil];
//    
//    chartData3.chartDataForDrawing= [NSMutableDictionary dictionary];
//    
//    //setup rawData3
//    PrototypeDataModel* rawData5=[[PrototypeDataModel alloc] init];
//    rawData5.seriesName=@"percentage5";
//    rawData5.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],nil];//in this case, this data seems useless
////    rawData5.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.21],nil];
//    rawData5.seriesType=DOUGHNUT;
//    rawData5.brushColor=kcLikeBlue;
//    //setup data4
//    PrototypeDataModel* rawData6=[[PrototypeDataModel alloc] init];
//    rawData6.seriesName=@"percentage6";
//    rawData6.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],nil];//in this case, this data seems useless
////    rawData6.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.35],nil];
//    rawData6.seriesType=DOUGHNUT;
//    rawData6.brushColor=kcLikeRed;
//    
//    //additive
//    [chartData3.chartDataForDrawing setObject:rawData5 forKey:rawData5.seriesName];
//    [chartData3.chartDataForDrawing setObject:rawData6 forKey:rawData6.seriesName];
//    chartData3.axisType=ABSOLUTE;
    
    AddedMap* chartData3=[[AddedMap alloc] init];
    chartData3.color1=kcLikeBlue;
    chartData3.color2=kcLikeRed;
    chartData3.floatingNumber=[NSNumber numberWithFloat:10.0f];
    chartData3.percentage=[NSNumber numberWithFloat:0.1f];
    
    
    
    
    NChartDataModel* chartData1=[[NChartDataModel alloc] init];
    chartData1.chartCaption=@"Claim Closed/Opened";
    chartData1.chartAxisXCaption=@"Years";
    chartData1.chartAxisYCaption=@"Products percentage";
    chartData1.chartType=COLUMN;
    chartData1.chartAxisXTicksValues=[NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    chartData1.chartAxisYTicksValues=[NSArray arrayWithObjects:@"0",@"5000",@"10000",nil];
    chartData1.chartDataForDrawing= [NSMutableDictionary dictionary];
    
    
    
    
    //setup rawData
    PrototypeDataModel* rawData=[[PrototypeDataModel alloc] init];
    rawData.seriesName=@"Opened";
    rawData.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8],[NSNumber numberWithInt:9],[NSNumber numberWithInt:10],[NSNumber numberWithInt:11],nil];
//    rawData.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.2],nil];
    rawData.seriesType=COLUMN;
    //rawData.brushColor=[UIColor orangeColor];
    rawData.brushColor=kcLikeBlue;
    //chartData.chartDataForDrawing= [NSMutableDictionary dictionary];
    //setup rawData1
    PrototypeDataModel* rawData1=[[PrototypeDataModel alloc] init];
    rawData1.seriesName=@"Active";
    rawData1.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8],[NSNumber numberWithInt:9],[NSNumber numberWithInt:10],[NSNumber numberWithInt:11],nil];
//    rawData1.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],nil];
    rawData1.seriesType=COLUMN;
    rawData1.brushColor=kcLikeOrange;
    //setup rawData2
    PrototypeDataModel* rawData2=[[PrototypeDataModel alloc] init];
    rawData2.seriesName=@"Closed";
    rawData2.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8],[NSNumber numberWithInt:9],[NSNumber numberWithInt:10],[NSNumber numberWithInt:11],nil];
//    rawData2.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.05],nil];
    rawData2.seriesType=LINE;
    //rawData2.brushColor=[UIColor blueColor];
    rawData2.brushColor=kcLikeRed;
    
    
    
    
    
    
    //additive data
    [chartData1.chartDataForDrawing setObject:rawData forKey:rawData.seriesName];
    [chartData1.chartDataForDrawing setObject:rawData1 forKey:rawData1.seriesName];
    [chartData1.chartDataForDrawing setObject:rawData2 forKey:rawData2.seriesName];
    chartData1.axisType=ADDITIVE;
    chartData1.dataForNextView=chartData3;
    chartData1.labelText=@"2014";
    //[chartData1 adaptedForFloatingNumber];
    return chartData1;
}
+(NChartDataModel*)templateAreaChartData
{
    float percent;
//    NChartDataModel* chartData5=[[NChartDataModel alloc] init];
//    chartData5.chartCaption=@"doughnut";
//    chartData5.chartAxisXCaption=@"product percentage";
//    chartData5.chartAxisYCaption=@"Years";
//    //chartData3.chartType=Dimention2;
//    chartData5.chartAxisYTicksValues=[NSArray arrayWithObjects:@"2000",@"2001",@"2002",@"2003",nil];
//    
//    chartData5.chartDataForDrawing= [NSMutableDictionary dictionary];
//    
//    //setup rawData3
//    PrototypeDataModel* rawData9=[[PrototypeDataModel alloc] init];
//    rawData9.seriesName=@"percentage5";
//    rawData9.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],nil];//in this case, this data seems useless
//    rawData9.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.21],nil];
//    rawData9.seriesType=DOUGHNUT;
//    rawData9.brushColor=kcLikeBlue;
//    //setup data4
//    PrototypeDataModel* rawData10=[[PrototypeDataModel alloc] init];
//    rawData10.seriesName=@"percentage6";
//    rawData10.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],nil];//in this case, this data seems useless
//    rawData10.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.35],nil];
//    rawData10.seriesType=DOUGHNUT;
//    rawData10.brushColor=kcLikeRed;
//    
//    //additive
//    [chartData5.chartDataForDrawing setObject:rawData9 forKey:rawData9.seriesName];
//    [chartData5.chartDataForDrawing setObject:rawData10 forKey:rawData10.seriesName];
//    chartData5.axisType=ABSOLUTE;
    
    AddedMap* chartData5=[[AddedMap alloc] init];
    chartData5.color1=kcLikeBlue;
    chartData5.color2=kcLikeRed;
    percent = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
    chartData5.floatingNumber=[NSNumber numberWithFloat:percent];
    chartData5.percentage=[NSNumber numberWithFloat:percent];
    
    
    
    NChartDataModel* chartData6=[[NChartDataModel alloc] init];
    chartData6.chartCaption=@"Conversion Rate";
    chartData6.chartAxisXCaption=@"Years";
    chartData6.chartAxisYCaption=@"Products percentage";
    chartData6.chartType=AREA;
    chartData6.chartAxisXTicksValues=[NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    chartData6.chartAxisYTicksValues=[NSArray arrayWithObjects:@"0",@"5000",@"10000",nil];
    chartData6.chartDataForDrawing= [NSMutableDictionary dictionary];
    
    
    
    
    //setup rawData
    PrototypeDataModel* rawData11=[[PrototypeDataModel alloc] init];
    rawData11.seriesName=@"Bind";
    rawData11.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8],[NSNumber numberWithInt:9],[NSNumber numberWithInt:10],[NSNumber numberWithInt:11],nil];
    //rawData11.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.2],nil];
    rawData11.seriesType=AREA;
    //rawData.brushColor=[UIColor orangeColor];
    rawData11.brushColor=kcLikeRed;
    //chartData.chartDataForDrawing= [NSMutableDictionary dictionary];
    //setup rawData1
    PrototypeDataModel* rawData12=[[PrototypeDataModel alloc] init];
    rawData12.seriesName=@"Quoted";
    rawData12.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8],[NSNumber numberWithInt:9],[NSNumber numberWithInt:10],[NSNumber numberWithInt:11],nil];
    //rawData12.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],nil];
    rawData12.seriesType=AREA;
    rawData12.brushColor=kcLikeBlue;
    //setup rawData2
    PrototypeDataModel* rawData13=[[PrototypeDataModel alloc] init];
    rawData13.seriesName=@"Estimate";
    rawData13.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8],[NSNumber numberWithInt:9],[NSNumber numberWithInt:10],[NSNumber numberWithInt:11],nil];
    //rawData13.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.05],nil];
    rawData13.seriesType=AREA;
    //rawData2.brushColor=[UIColor blueColor];
    rawData13.brushColor=kcLikeOrange;
    
    
    
    
    
    
    //additive data
    [chartData6.chartDataForDrawing setObject:rawData11 forKey:rawData11.seriesName];
    [chartData6.chartDataForDrawing setObject:rawData12 forKey:rawData12.seriesName];
    [chartData6.chartDataForDrawing setObject:rawData13 forKey:rawData13.seriesName];
    chartData6.axisType=ABSOLUTE;
    chartData6.dataForNextView=chartData5;
    chartData6.labelText=@"2014";
    return chartData6;
}
+(NChartDataModel*)templateRadarChartData
{
    NChartDataModel* chartData4=[[NChartDataModel alloc] init];
    chartData4.chartCaption=@"Personal Quote Conversion";
    chartData4.chartAxisXCaption=@"product percentage";
    chartData4.chartAxisYCaption=@"Years";
    chartData4.chartType=RADAR;
    chartData4.chartAxisXTicksValues=[NSArray arrayWithObjects:@"Green Slip",@"Life",@"Home",@"Boat",@"Auto",@"Worker",nil];
    chartData4.labelText=@"2014";
    chartData4.chartDataForDrawing= [NSMutableDictionary dictionary];
    
    //setup rawData3
    PrototypeDataModel* rawData7=[[PrototypeDataModel alloc] init];
    rawData7.seriesName=@"Converted";
    rawData7.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2001],[NSNumber numberWithInt:2002],[NSNumber numberWithInt:2003],[NSNumber numberWithInt:2004],[NSNumber numberWithInt:2005],nil];//in this case, this data seems useless
//    rawData7.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.90],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.90],[NSNumber numberWithFloat:0.5],nil];
    //    rawData7.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.02],[NSNumber numberWithFloat:0.01],[NSNumber numberWithFloat:0.03],[NSNumber numberWithFloat:0.04],[NSNumber numberWithFloat:0.01],nil];
    rawData7.seriesType=RADAR;
    //rawData7.brushColor=[UIColor orangeColor];
    rawData7.brushColor=kcLikeRed;
    //setup data4
    PrototypeDataModel* rawData8=[[PrototypeDataModel alloc] init];
    rawData8.seriesName=@"Quoted";
    rawData8.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2001],[NSNumber numberWithInt:2002],[NSNumber numberWithInt:2003],[NSNumber numberWithInt:2004],[NSNumber numberWithInt:2005],nil];//in this case, this data seems useless
//    rawData8.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],nil];
    //    rawData8.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.03],[NSNumber numberWithFloat:0.02],[NSNumber numberWithFloat:0.01],[NSNumber numberWithFloat:0.03],[NSNumber numberWithFloat:0.01],nil];
    rawData8.seriesType=RADAR;
    //rawData8.brushColor=[UIColor grayColor];
    rawData8.brushColor=kcLikeBlue;
    //additive
    [chartData4.chartDataForDrawing setObject:rawData7 forKey:rawData7.seriesName];
    [chartData4.chartDataForDrawing setObject:rawData8 forKey:rawData8.seriesName];
    
    
    chartData4.axisType=ABSOLUTE;
    //[chartData4 adaptedForFloatingNumber];
    return chartData4;
}

+(NSString*)filePathFromeFileName:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    return [docPath stringByAppendingPathComponent:fileName];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "EY-E.ee" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
    
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kcDataBaseFileName];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)addTickValues:(NSArray*)xAxisTickValues yAxis:(NSArray*)yAxisTickValues zAxis:(NSArray*)zAxisTickValues mainMap:(MainMap*)map context:(NSManagedObjectContext*)context
{
    NSSet* tickValues=[map valueForKey:@"chartAxisTickValues"];
    if (tickValues!=nil) {
        [map removeChartAxisTickValues:tickValues];
    }

    
    if (xAxisTickValues!=nil&&xAxisTickValues.count>0)
    {
        NSUInteger arrayNum=xAxisTickValues.count;
        for (NSUInteger count=0;count<arrayNum;count++)
        {
            AxisTickValue* tickVal=[NSEntityDescription insertNewObjectForEntityForName:@"AxisTickValue" inManagedObjectContext:context];
            [tickVal setValue:[NSNumber numberWithInteger:count] forKey:@"index"];
            [tickVal setValue:[xAxisTickValues objectAtIndex:count] forKey:@"value"];
            [tickVal setValue:map forKey:@"mainMapData"];
            [tickVal setValue:[NSNumber numberWithInteger:XAXISVALUE] forKey:@"axisValueType"];
            [map addChartAxisTickValuesObject:tickVal];
        }
    }
    if (yAxisTickValues!=nil&&yAxisTickValues.count>0)
    {
        NSUInteger arrayNum=yAxisTickValues.count;
        for (NSUInteger count=0;count<arrayNum;count++)
        {
            AxisTickValue* tickVal=[NSEntityDescription insertNewObjectForEntityForName:@"AxisTickValue" inManagedObjectContext:context];
            [tickVal setValue:[NSNumber numberWithInteger:count] forKey:@"index"];
            [tickVal setValue:[yAxisTickValues objectAtIndex:count] forKey:@"value"];
            [tickVal setValue:map forKey:@"mainMapData"];
            [tickVal setValue:[NSNumber numberWithInteger:YAXISVALUE] forKey:@"axisValueType"];
            [map addChartAxisTickValuesObject:tickVal];
        }
    }
    if (zAxisTickValues!=nil&&zAxisTickValues.count>0)
    {
        NSUInteger arrayNum=zAxisTickValues.count;
        for (NSUInteger count=0;count<arrayNum;count++)
        {
            AxisTickValue* tickVal=[NSEntityDescription insertNewObjectForEntityForName:@"AxisTickValue" inManagedObjectContext:context];
            [tickVal setValue:[NSNumber numberWithInteger:count] forKey:@"index"];
            [tickVal setValue:[zAxisTickValues objectAtIndex:count] forKey:@"value"];
            [tickVal setValue:map forKey:@"mainMapData"];
            [tickVal setValue:[NSNumber numberWithInteger:ZAXISVALUE] forKey:@"axisValueType"];
            [map addChartAxisTickValuesObject:tickVal];
        }
    }
   
    
    
}
-(void)addAxisValues:(NSArray*)axisValues serie:(Serie*)serie valueType:(AxisValueType)valueType context:(NSManagedObjectContext*)context
{
    NSUInteger arrayNum=axisValues.count;
    for(NSUInteger count=0;count<arrayNum;count++)
    {
        AxisValue *axisVal = [NSEntityDescription insertNewObjectForEntityForName:@"AxisValue" inManagedObjectContext:context];
        [axisVal setValue:[NSNumber numberWithInteger:count] forKey:@"index"];
        [axisVal setValue:[axisValues objectAtIndex:count] forKey:@"value"];
        [axisVal setValue:[NSNumber numberWithInteger:valueType] forKey:@"axisValueType"];
        [axisVal setValue:serie forKey:@"serie"];
        [serie addAxisValuesObject:axisVal];
        
        
    }
    
}
-(void)addSerieAxisValues:(NSDictionary*)seriesDic map:(MainMap*)mainMap context:(NSManagedObjectContext*)context
{
    NSArray* seriesKeys= seriesDic.allKeys;
    NSSet* series=[mainMap valueForKey:@"series"];
    if (series!=nil) {
        [mainMap removeSeries:series];
    }
    for (NSString* strKey in seriesKeys)
    {
        PrototypeDataModel* serieData= [seriesDic objectForKey:strKey];
        Serie *serie = [NSEntityDescription insertNewObjectForEntityForName:@"Serie" inManagedObjectContext:context];
        [serie setValue:serieData.seriesName forKey:@"seriesName"];
        //NSData* brushData= [NSData dataWithBytes:CFBridgingRetain(serieData.brushColor) length:sizeof(serieData.brushColor)];
        [serie setValue:serieData.brushColor forKey:@"brushColor"];
        [serie setValue:[NSNumber numberWithInteger:serieData.seriesType] forKey:@"seriesType"];
        [serie setValue:mainMap forKey:@"mainMapData"];
        
        [self addAxisValues:serieData.chartAxisXValues serie:serie valueType:XAXISVALUE context:context];
        [self addAxisValues:serieData.chartAxisYValues serie:serie valueType:YAXISVALUE context:context];
        [self addAxisValues:serieData.chartAxisZValues serie:serie valueType:ZAXISVALUE context:context];
        [mainMap addSeriesObject:serie];
        
    }
}

-(void)insertChartData:(NChartDataModel*)chartData pageName:(NSString*)pageName
{
    //if (!chartData.empty)
    //if (chartData!=nil)
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        MainMap *mainMap = [NSEntityDescription insertNewObjectForEntityForName:@"MainMap" inManagedObjectContext:context];
        [mainMap setValue:[NSNumber numberWithInteger:chartData.axisType] forKey:@"axisType"];
        [mainMap setValue:chartData.chartAxisXCaption forKey:@"chartAxisXCaption"];
        [mainMap setValue:chartData.chartAxisYCaption forKey:@"chartAxisYCaption"];
        [mainMap setValue:chartData.chartAxisZCaption forKey:@"chartAxisZCaption"];
        [mainMap setValue:chartData.chartCaption forKey:@"chartCaption"];
        [mainMap setValue:[NSNumber numberWithInteger:chartData.chartType] forKey:@"chartType"];
        //[mainMap setValue:[NSNumber numberWithBool:chartData.empty] forKey:@"empty"];
        [mainMap setValue:chartData.floatingNumber forKey:@"floatingNumber"];
        [mainMap setValue:chartData.labelText forKey:@"labelText"];
        [mainMap setValue:pageName forKey:@"pageName"];
        [mainMap setValue:chartData.percentage forKey:@"percentage"];
        if (chartData.dataForNextView!=nil)
        {
            AddedMap* plusChartData=chartData.dataForNextView;
            PlusMap *plusMap = [NSEntityDescription insertNewObjectForEntityForName:@"PlusMap" inManagedObjectContext:context];
            [mainMap setValue:plusMap forKey:@"plusMapData"];
//            NSData* color1Data=[NSData dataWithBytes:CFBridgingRetain(plusChartData.color1) length:sizeof(plusChartData.color1)];
//            NSData* color2Data=[NSData dataWithBytes:CFBridgingRetain(plusChartData.color2) length:sizeof(plusChartData.color2)];
            [plusMap setValue:plusChartData.color1 forKey:@"color1"];
            [plusMap setValue:plusChartData.color2 forKey:@"color2"];
            [plusMap setValue:plusChartData.percentage forKey:@"finalPercentage"];
            [plusMap setValue:plusChartData.floatingNumber forKey:@"floatingNumber"];
            [plusMap setValue:mainMap forKey:@"mainMapData"];
            
        }
        [self addTickValues:chartData.chartAxisXTicksValues yAxis:chartData.chartAxisYTicksValues zAxis:chartData.chartAxisZTicksValues mainMap:mainMap context:context];
        [self addSerieAxisValues:chartData.chartDataForDrawing map:mainMap context:context];
        if (chartData.prediction!=nil)
        {
            for (ChartPrediction* p in chartData.prediction) {
                Prediction *prediction = [NSEntityDescription insertNewObjectForEntityForName:@"Prediction" inManagedObjectContext:context];
                [prediction setValue:p.mult1 forKey:@"multiplier1"];
                [prediction setValue:p.mult2 forKey:@"multiplier2"];
                [prediction setValue:p.base forKey:@"base"];
                [prediction setValue:p.key forKey:@"key"];
                [prediction setValue:mainMap forKey:@"mainMapData"];
                
                [mainMap addPredictionObject:prediction];
                

            }
            
            
            
            
        }
        
        NSError* error;
        if(![context save:&error])
        {
            NSLog(@"can not save：%@",[error localizedDescription]);
        }
    }
    
    
    
    
    
    
    
    
    
}

- (NSArray*)dataFetchRequest:(NSString*)pageName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MainMap" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSString* attributeName=@"pageName";
    NSString* attributeValue=pageName;
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", attributeName, attributeValue]];
    //fetchRequest.resultType=NSManagedObjectIDResultType;
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray* chartDataArray=[NSMutableArray array];
    if (fetchedObjects.count>0)
    {
        
        for (MainMap *info in fetchedObjects)
        {
       
            NChartDataModel* chartData=[[NChartDataModel alloc] init];
            chartData.objectID=[(NSManagedObject*)info objectID];
            chartData.chartCaption= [info valueForKey:@"chartCaption"];
            chartData.chartAxisXCaption=[info valueForKey:@"chartAxisXCaption"];
            chartData.chartAxisYCaption=[info valueForKey:@"chartAxisYCaption"];
            chartData.chartAxisZCaption=[info valueForKey:@"chartAxisZCaption"];
            chartData.labelText=[info valueForKey:@"labelText"];
            chartData.percentage=[info valueForKey:@"percentage"];
            chartData.floatingNumber=[info valueForKey:@"floatingNumber"];
            chartData.axisType=(AxisType)[[info valueForKey:@"axisType"] integerValue];
            chartData.chartType=(NSeriesType)[[info valueForKey:@"chartType"] integerValue];
            //chartData.empty=[[info valueForKey:@"empty"] boolValue];
            PlusMap* plusMap=[info valueForKey:@"plusMapData"];
            if (plusMap!=nil&&[plusMap isKindOfClass:[plusMap class]]) {
                AddedMap* addedMapData=[[AddedMap alloc] init];
                addedMapData.color1=(UIColor*)[plusMap valueForKey:@"color1"];
                addedMapData.color2=(UIColor*)[plusMap valueForKey:@"color2"];
                addedMapData.percentage=[plusMap valueForKey:@"finalPercentage"];
                addedMapData.floatingNumber=[plusMap valueForKey:@"floatingNumber"];
                chartData.dataForNextView=addedMapData;
            }
            
            NSSet* predictionSet=[info valueForKey:@"prediction"];
            if (predictionSet!=nil)
            {
                chartData.prediction=[NSMutableSet set];
                for (NSObject* o in predictionSet )
                {
                    ChartPrediction* chartPredictionData=[[ChartPrediction alloc] init];
                    chartPredictionData.mult1=[o valueForKey:@"multiplier1"];
                    chartPredictionData.mult2=[o valueForKey:@"multiplier2"];
                    chartPredictionData.base=[o valueForKey:@"base"];
                    chartPredictionData.key=[o valueForKey:@"key"];
                    [chartData.prediction addObject:chartPredictionData];
                }
            }
            NSSet* axisTickValues=[info valueForKey:@"chartAxisTickValues"];
            chartData.chartAxisXTicksValues=[self analyseTickOrValue:axisTickValues axisValueType:XAXISVALUE];
            chartData.chartAxisYTicksValues=[self analyseTickOrValue:axisTickValues axisValueType:YAXISVALUE];
            chartData.chartAxisZTicksValues=[self analyseTickOrValue:axisTickValues axisValueType:ZAXISVALUE];
            NSSet* series=[info valueForKey:@"series"];
            chartData.chartDataForDrawing=[self analyseSeries:series];
            [chartDataArray addObject:chartData];
        }
        return chartDataArray;
        
    }
    else
        return nil;
    
}
-(NSArray*)analyseTickOrValue:(NSSet*)tickSet axisValueType:(AxisValueType)valueType
{
    NSArray* sortedGroup = [[[tickSet filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"axisValueType = %ld", (NSUInteger)valueType]] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]] valueForKey:@"value"];
    return sortedGroup;
}
-(NSMutableDictionary*)analyseSeries:(NSSet*)series
{
    NSMutableDictionary* seriesDic=[NSMutableDictionary dictionary];
    [series enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if ([obj isKindOfClass:[Serie class]])
        {
            PrototypeDataModel* serieData=[[PrototypeDataModel alloc] init];
            Serie* serieVal=(Serie*)obj;
            serieData.seriesName=[serieVal valueForKey:@"seriesName"];
            serieData.seriesType=[[serieVal valueForKey:@"seriesType"] integerValue];
            serieData.brushColor=(UIColor*) [serieVal valueForKey:@"brushColor"];
            NSSet* axisValues=[serieVal valueForKey:@"axisValues"];
            NSArray* xValues=[self analyseTickOrValue:axisValues axisValueType:XAXISVALUE];
            NSArray* yValues=[self analyseTickOrValue:axisValues axisValueType:YAXISVALUE];
            NSArray* zValues=[self analyseTickOrValue:axisValues axisValueType:ZAXISVALUE];
            serieData.chartAxisXValues=xValues;
            serieData.chartAxisYValues=yValues;
            serieData.chartAxisZValues=zValues;
            [seriesDic setObject:serieData forKey:serieData.seriesName];
            
        }
    }];
    return seriesDic;

    
}
-(BOOL)updateChartData:(NChartDataModel*)chartData page:(NSString*)pageName
{
    NSManagedObjectContext *context = [self managedObjectContext];
    //NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
    //NSEntityDescription *entity = [NSEntityDescription entityForName:@"MainMap" inManagedObjectContext:context];
    //[fetchRequest setEntity:entity];
    //fetchRequest.resultType=NSManagedObjectIDResultType;
    
    NSError *error=nil;
    //NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    
    MainMap* mainMap=(MainMap*)[context existingObjectWithID:chartData.objectID error:&error];
    if(error!=nil)
    {
        NSLog(@"can not update：%@",[error localizedDescription]);
        return NO;
    }
    if (mainMap!=nil)
    {

                [mainMap setValue:[NSNumber numberWithInteger:chartData.axisType] forKey:@"axisType"];
                [mainMap setValue:chartData.chartAxisXCaption forKey:@"chartAxisXCaption"];
                [mainMap setValue:chartData.chartAxisYCaption forKey:@"chartAxisYCaption"];
                [mainMap setValue:chartData.chartAxisZCaption forKey:@"chartAxisZCaption"];
                [mainMap setValue:chartData.chartCaption forKey:@"chartCaption"];
                [mainMap setValue:[NSNumber numberWithInteger:chartData.chartType] forKey:@"chartType"];
                [mainMap setValue:chartData.floatingNumber forKey:@"floatingNumber"];
                [mainMap setValue:chartData.labelText forKey:@"labelText"];
                [mainMap setValue:pageName forKey:@"pageName"];
                [mainMap setValue:chartData.percentage forKey:@"percentage"];
                if (chartData.dataForNextView!=nil)
                {
                    AddedMap* plusChartData=chartData.dataForNextView;
                    PlusMap *plusMap =nil;
                    if ([mainMap valueForKey:@"plusMapData"]==nil) {
                        plusMap=[NSEntityDescription insertNewObjectForEntityForName:@"PlusMap" inManagedObjectContext:context];
                        [plusMap setValue:plusChartData.color1 forKey:@"color1"];
                        [plusMap setValue:plusChartData.color2 forKey:@"color2"];
                        [plusMap setValue:plusChartData.percentage forKey:@"finalPercentage"];
                        [plusMap setValue:plusChartData.floatingNumber forKey:@"floatingNumber"];
                        [plusMap setValue:mainMap forKey:@"mainMapData"];
                        [mainMap setValue:plusMap forKey:@"plusMapData"];
                    }
                    else
                    {
                        plusMap=[mainMap valueForKey:@"plusMapData"];
                    
                        [plusMap setValue:plusChartData.color1 forKey:@"color1"];
                        [plusMap setValue:plusChartData.color2 forKey:@"color2"];
                        [plusMap setValue:plusChartData.percentage forKey:@"finalPercentage"];
                        [plusMap setValue:plusChartData.floatingNumber forKey:@"floatingNumber"];
                    }
                    //[plusMap setValue:mainMap forKey:@"mainMapData"];
                    
                }
                [self addTickValues:chartData.chartAxisXTicksValues yAxis:chartData.chartAxisYTicksValues zAxis:chartData.chartAxisZTicksValues mainMap:mainMap context:context];
                [self addSerieAxisValues:chartData.chartDataForDrawing map:mainMap context:context];
        
                if (chartData.prediction!=nil)
                {
                    for (ChartPrediction* p in chartData.prediction)
                    {
                        Prediction* prediction=nil;
//                        Prediction* prediction = [NSEntityDescription insertNewObjectForEntityForName:@"Prediction" inManagedObjectContext:context];
                        if ([mainMap valueForKey:@"prediction"]==nil) {
                            prediction = [NSEntityDescription insertNewObjectForEntityForName:@"Prediction" inManagedObjectContext:context];
                            [prediction setValue:p.mult1 forKey:@"multiplier1"];
                            [prediction setValue:p.mult2 forKey:@"multiplier2"];
                            [prediction setValue:p.base forKey:@"base"];
                            [prediction setValue:p.key forKey:@"key"];
                            [prediction setValue:mainMap forKey:@"mainMapData"];
                            
                            [mainMap addPredictionObject:prediction];
                            //[mainMap setValue:prediction forKey:@"prediction"];
                        }
                        else
                        {
                            prediction=[mainMap valueForKey:@"prediction"];
                        
                            [prediction setValue:p.mult1 forKey:@"multiplier1"];
                            [prediction setValue:p.mult2 forKey:@"multiplier2"];
                            [prediction setValue:p.base forKey:@"base"];
                            [prediction setValue:p.key forKey:@"key"];
                            [prediction setValue:mainMap forKey:@"mainMapData"];
                        }
                        
                        //[mainMap addPredictionObject:prediction];
                        //addPredictionObject
                        
                    }
                    
                    
                    
                    
                }
                
                NSError* error;
                if(![context save:&error])
                {
                    NSLog(@"can not update：%@",[error localizedDescription]);
                    return NO;
                }
                else
                    return YES;
    }
            //}
        //}
    //}
    return NO;
}

@end
