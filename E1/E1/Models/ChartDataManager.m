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
    //NSString* filePath=[ChartDataManager getStoredFilePath:file ];
    //BOOL result=NO;
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
    int i=0;//
    for (NChartDataModel* dataChart in chartData)
    {
        
        if ([dataChart isKindOfClass:[NChartDataModel class]])
        {
            //[archiver encodeObject:dataChart forKey:dataChart.chartCaption];
            [archiver encodeObject:dataChart forKey:[NSString stringWithFormat:@"%d",i]];
            [chartNames addObject:[NSString stringWithFormat:@"%d",i]];
        }
        ++i;//
    }
    //[userDefault setObject:chartNames forKey:kcDefaultChartName];
    [userDefault setObject:chartNames forKey:[[file stringByDeletingPathExtension] lastPathComponent]];
    
    [userDefault synchronize];
    [archiver finishEncoding];
    
    if (![manager fileExistsAtPath:file])
    {
        [manager createFileAtPath:file contents:nil attributes:nil];
        
    }
    [data writeToFile:file atomically:YES];

    
}

+(BOOL)deleteChartFile:(NSString*)file
{
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSMutableArray* chartNames=[NSMutableArray array];
//    NSMutableData   * data = [[NSMutableData alloc] init];
    NSFileManager* manager=[NSFileManager defaultManager];
    NSString* filePath=[ChartDataManager getStoredFilePath:file ];
    
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

-(NSArray*)parseFromFile:(NSString*)file
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userd = [userDefault dictionaryRepresentation];
    NSMutableArray* array=[NSMutableArray array];
    if ([userd.allKeys containsObject:kcPagesArrayName])
    {
        NSArray* pageNameArray=[userd objectForKey: kcPagesArrayName];
        if ([pageNameArray containsObject:[[file stringByDeletingPathExtension] lastPathComponent]])
        {
            NSFileManager* manager=[NSFileManager defaultManager];
            if(![manager fileExistsAtPath:file])
                return nil;
            NSData *data = [NSData dataWithContentsOfFile:file];
            if ([data length]==0)
            {
                return nil;
            }
            // 根据数据，解析成一个NSKeyedUnarchiver对象
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            for (NSString* chartName in [userd objectForKey:[[file stringByDeletingPathExtension] lastPathComponent]])
            {
                [array addObject:[unarchiver decodeObjectForKey:chartName]];
            }
            
            [unarchiver finishDecoding];
            return array;
        }
        
        
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
    
    
    //doughnut
    NChartDataModel* chartData3=[[NChartDataModel alloc] init];
    chartData3.chartCaption=@"doughnut";
    chartData3.chartAxisXCaption=@"product percentage";
    chartData3.chartAxisYCaption=@"Years";
    //chartData3.chartType=Dimention2;
    chartData3.chartAxisYTicksValues=[NSArray arrayWithObjects:@"2000",@"2001",@"2002",@"2003",nil];
    
    chartData3.chartDataForDrawing= [NSMutableDictionary dictionary];
    
    //setup rawData3
    PrototypeDataModel* rawData5=[[PrototypeDataModel alloc] init];
    rawData5.seriesName=@"percentage5";
    rawData5.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],nil];//in this case, this data seems useless
//    rawData5.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.21],nil];
    rawData5.seriesType=DOUGHNUT;
    rawData5.brushColor=kcLikeBlue;
    //setup data4
    PrototypeDataModel* rawData6=[[PrototypeDataModel alloc] init];
    rawData6.seriesName=@"percentage6";
    rawData6.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],nil];//in this case, this data seems useless
//    rawData6.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.35],nil];
    rawData6.seriesType=DOUGHNUT;
    rawData6.brushColor=kcLikeRed;
    
    //additive
    [chartData3.chartDataForDrawing setObject:rawData5 forKey:rawData5.seriesName];
    [chartData3.chartDataForDrawing setObject:rawData6 forKey:rawData6.seriesName];
    chartData3.axisType=ABSOLUTE;
    //[chartData3 adaptedForFloatingNumber];
    chartData3.floatingNumber=[NSNumber numberWithFloat:10.0f];
    chartData3.percentage=[NSNumber numberWithFloat:0.1f];
    
    
    
    
    NChartDataModel* chartData1=[[NChartDataModel alloc] init];
    chartData1.chartCaption=@"Claim Closed/Opened";
    chartData1.chartAxisXCaption=@"Years";
    chartData1.chartAxisYCaption=@"Products percentage";
    chartData1.chartType=COLUMN;
    chartData1.chartAxisXTicksValues=[NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    
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
    int x;
    NChartDataModel* chartData5=[[NChartDataModel alloc] init];
    chartData5.chartCaption=@"doughnut";
    chartData5.chartAxisXCaption=@"product percentage";
    chartData5.chartAxisYCaption=@"Years";
    //chartData3.chartType=Dimention2;
    chartData5.chartAxisYTicksValues=[NSArray arrayWithObjects:@"2000",@"2001",@"2002",@"2003",nil];
    
    chartData5.chartDataForDrawing= [NSMutableDictionary dictionary];
    
    //setup rawData3
    PrototypeDataModel* rawData9=[[PrototypeDataModel alloc] init];
    rawData9.seriesName=@"percentage5";
    rawData9.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],nil];//in this case, this data seems useless
    rawData9.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.21],nil];
    rawData9.seriesType=DOUGHNUT;
    rawData9.brushColor=kcLikeBlue;
    //setup data4
    PrototypeDataModel* rawData10=[[PrototypeDataModel alloc] init];
    rawData10.seriesName=@"percentage6";
    rawData10.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],nil];//in this case, this data seems useless
    rawData10.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.35],nil];
    rawData10.seriesType=DOUGHNUT;
    rawData10.brushColor=kcLikeRed;
    
    //additive
    [chartData5.chartDataForDrawing setObject:rawData9 forKey:rawData9.seriesName];
    [chartData5.chartDataForDrawing setObject:rawData10 forKey:rawData10.seriesName];
    chartData5.axisType=ABSOLUTE;
    //[chartData3 adaptedForFloatingNumber];
    percent = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
    //x = arc4random() % 100;
    chartData5.floatingNumber=[NSNumber numberWithFloat:percent];
    chartData5.percentage=[NSNumber numberWithFloat:percent];
    
    
    
    NChartDataModel* chartData6=[[NChartDataModel alloc] init];
    chartData6.chartCaption=@"Conversion Rate";
    chartData6.chartAxisXCaption=@"Years";
    chartData6.chartAxisYCaption=@"Products percentage";
    chartData6.chartType=AREA;
    chartData6.chartAxisXTicksValues=[NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec",nil];
    
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

@end
