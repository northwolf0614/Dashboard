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

@implementation ChartDataManager



-(void)storeChartDataToFile:(NSArray*) chartData fileName:(NSString*)file
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray* chartNames=[NSMutableArray array];
    NSMutableData   * data = [[NSMutableData alloc] init];
    NSFileManager* manager=[NSFileManager defaultManager];
    if (chartData==nil)
    {
        if (![manager fileExistsAtPath:file])
        {
            [manager createFileAtPath:file contents:nil attributes:nil];
            
        }
        
        return;
    }

    //NSString* fileString=[NChartDataModel getStoredDefaultFilePath];
    // 这个NSKeyedArchiver则是进行编码用的
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    for (NChartDataModel* dataChart in chartData)
    {
        if ([dataChart isKindOfClass:[NChartDataModel class]])
        {
            [archiver encodeObject:dataChart forKey:dataChart.chartCaption];
            [chartNames addObject:dataChart.chartCaption];
        }
    }
    [userDefault setObject:chartNames forKey:kcDefaultChartName];
    [userDefault synchronize];
    [archiver finishEncoding];
    
    if (![manager fileExistsAtPath:file])
    {
        [manager createFileAtPath:file contents:nil attributes:nil];
        
    }
    [data writeToFile:file atomically:YES];

    
}
-(NSArray*)parseFromDefaultFile:(NSString*)file
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userd = [userDefault dictionaryRepresentation];
    NSMutableArray* array=[NSMutableArray array];
    if ([userd.allKeys containsObject:kcDefaultChartName])
    {
        
        NSFileManager* manager=[NSFileManager defaultManager];
        if(![manager fileExistsAtPath:file])
            return nil;
        NSData *data = [NSData dataWithContentsOfFile:file];
        // 根据数据，解析成一个NSKeyedUnarchiver对象
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        for (NSString* chartName in [userd objectForKey:kcDefaultChartName]) {
            [array addObject:[unarchiver decodeObjectForKey:chartName]];
        }
        
        [unarchiver finishDecoding];
        return array;

    }
    
    
    
    
    return nil;
    
}

+(NSString*)getStoredDefaultFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    return [docPath stringByAppendingPathComponent:kcDefaultDataFielName];
}

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
    //manager.defaultChartDataQueue=[[NSMutableArray alloc] initWithArray:[NChartDataModel chartDataDefault]];
    manager.defaultChartDataQueue=[NSMutableArray array];
    manager.chartDataQueue=[NSMutableArray array];
    return manager;
    
    
}
@end
