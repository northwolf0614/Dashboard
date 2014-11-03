//
//  NChartDataModel.m
//  E1
//
//  Created by Jack Lin on 1/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "NChartDataModel.h"
#import "Definations.h"

@implementation NChartDataModel
/*
@property(nonatomic,assign) AxisType axisType;//new added



*/
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.chartCaption forKey:@"chartCaption"];
    [aCoder encodeObject:self.chartAxisXCaption forKey:@"chartAxisXCaption"];
    [aCoder encodeObject:self.chartAxisYCaption forKey:@"chartAxisYCaption"];
    [aCoder encodeObject:self.chartAxisZCaption forKey:@"chartAxisZCaption"];
    [aCoder encodeInt:self.chartType forKey:@"chartType"];
    [aCoder encodeObject:self.chartDataForDrawing  forKey:@"chartDataForDrawing"];
    [aCoder encodeObject:self.chartAxisXTicksValues forKey:@"chartAxisXTicksValues"];
    [aCoder encodeObject:self.chartAxisZTicksValues forKey:@"chartAxisZTicksValues"];
    [aCoder encodeObject:self.chartAxisYTicksValues forKey:@"chartAxisYTicksValues"];
    [aCoder encodeObject:self.sliceNumber forKey:@"sliceNumber"];
    [aCoder encodeBool:self.isToolTips forKey:@"isToolTips"];
    [aCoder encodeBool:self.isBorder forKey:@"isBorder"];
    [aCoder encodeInt:self.axisType forKey:@"axisType"];
    
    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        self.chartCaption=[aDecoder decodeObjectForKey:@"chartCaption"];
        self.chartAxisXCaption=[aDecoder decodeObjectForKey:@"chartAxisXCaption"];
        self.chartAxisYCaption=[aDecoder decodeObjectForKey:@"chartAxisYCaption"];
        self.chartAxisZCaption=[aDecoder decodeObjectForKey:@"chartAxisZCaption"];
        self.chartType=[aDecoder decodeIntForKey:@"chartType"];
        self.chartDataForDrawing=[aDecoder decodeObjectForKey:@"chartDataForDrawing"];
        self.chartAxisXTicksValues=[aDecoder decodeObjectForKey:@"chartAxisXTicksValues"];
        self.chartAxisYTicksValues=[aDecoder decodeObjectForKey:@"chartAxisYTicksValues"];
        self.chartAxisZTicksValues=[aDecoder decodeObjectForKey:@"chartAxisZTicksValues"];
        self.sliceNumber= [aDecoder decodeObjectForKey:@"sliceNumber"];
        self.isToolTips=[aDecoder decodeBoolForKey:@"isToolTips"];
        self.isBorder=[aDecoder decodeBoolForKey:@"isBorder"];
        self.axisType=[aDecoder decodeIntForKey:@"axisType"];

        
        
    }
    return self;
}


-(void)saveDataForKey:(NSString*)key

{
#ifdef UsingFileStoreData
    NSMutableData   * data = [[NSMutableData alloc] init];
    // 这个NSKeyedArchiver则是进行编码用的
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:key];
    [archiver finishEncoding];
    // 编码完成后的NSData，使用其写文件接口写入文件存起来
    [data writeToFile:[NChartDataModel getStoredDefaultFilePath] atomically:YES];
#else
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [userd setObject:data forKey:key];
    [userd synchronize];
    
    
#endif
}
+(NChartDataModel*)loadDataWithKey:(NSString*)key
{
#ifdef UsingFileStoreData
    NSData * codedData = [[NSData alloc] initWithContentsOfFile:[NChartDataModel getStoredDefaultFilePath]];
    if (codedData == nil)
        return nil;
    
    // NSKeyedUnarchiver用来解码
    NSKeyedUnarchiver * unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    // 解码后的数据被存在一个WSNSCodingData数据对象里面
    NChartDataModel* aData = (NChartDataModel*)[unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    return aData;
#else
    NSUserDefaults *userd = [NSUserDefaults standardUserDefaults];
    NChartDataModel* bData = (NChartDataModel *)[NSKeyedUnarchiver unarchiveObjectWithData:[userd objectForKey:key]];
    return bData;
    
    
#endif
}
+(NSString*)getStoredDefaultFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    return [docPath stringByAppendingPathComponent:kcDefaultDataFielName];
}

+(NChartDataModel*)chartDataDefault
{
    NChartDataModel* chartData=[[NChartDataModel alloc] init];
    chartData.chartCaption=kcDefaultChartName;
    chartData.chartAxisXCaption=@"Years";
    chartData.chartAxisYCaption=@"Products percentage";
    chartData.chartType=Dimention2;
    chartData.chartAxisXTicksValues=[NSArray arrayWithObjects:@"2000",@"2001",@"2002",@"2003",nil];
    chartData.axisType=ADDITIVE;
    chartData.chartDataForDrawing= [NSMutableDictionary dictionary];

    
    //setup rawData
    PrototypeDataModel* rawData=[[PrototypeDataModel alloc] init];
    rawData.seriesName=@"percentage";
    rawData.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],nil];
    rawData.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.5],nil];
    rawData.seriesType=COLUMN;
    rawData.brushColor=[UIColor redColor];
    //chartData.chartDataForDrawing= [NSMutableDictionary dictionary];
        //setup rawData1
    PrototypeDataModel* rawData1=[[PrototypeDataModel alloc] init];
    rawData1.seriesName=@"percentage1";
    rawData1.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],nil];
    rawData1.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],nil];
    rawData1.seriesType=COLUMN;
    rawData1.brushColor=[UIColor greenColor];
    //setup rawData2
    
    PrototypeDataModel* rawData2=[[PrototypeDataModel alloc] init];
    rawData2.seriesName=@"percentage2";
    rawData2.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],nil];
    rawData2.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],nil];
    rawData2.seriesType=LINE;
    rawData2.brushColor=[UIColor grayColor];


    
    
    
    [chartData.chartDataForDrawing setObject:rawData forKey:rawData.seriesName];
    [chartData.chartDataForDrawing setObject:rawData1 forKey:rawData1.seriesName];
    [chartData.chartDataForDrawing setObject:rawData2 forKey:rawData2.seriesName];
    
    
    
    
    return chartData ;
}


@end

@implementation PrototypeDataModel
/*
 @property(nonatomic,copy) NSString* seriesName;
 @property(nonatomic,strong) NSArray* chartAxisXTicksValues;
 @property(nonatomic,strong) NSArray* chartAxisYTicksValues;
 @property(nonatomic,strong) NSArray* chartAxisZTicksValues;
 @property(nonatomic,assign) NChartType seriesType;

 */
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.seriesName forKey:@"seriesName"];
    [aCoder encodeObject:self.chartAxisXValues forKey:@"chartAxisXValues"];
    [aCoder encodeObject:self.chartAxisZValues forKey:@"chartAxisZValues"];
    [aCoder encodeObject:self.chartAxisYValues forKey:@"chartAxisYValues"];
    [aCoder encodeInt:self.seriesType forKey:@"seriesType"];
    [aCoder encodeObject:self.brushColor forKey:@"brushColor"];

    
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        self.seriesName=[aDecoder decodeObjectForKey:@"seriesName"];
        self.chartAxisXValues=[aDecoder decodeObjectForKey:@"chartAxisXValues"];
        self.chartAxisYValues=[aDecoder decodeObjectForKey:@"chartAxisYValues"];
        self.chartAxisZValues=[aDecoder decodeObjectForKey:@"chartAxisZValues"];
        self.seriesType=[aDecoder decodeIntForKey:@"seriesType"];
        self.brushColor=[aDecoder decodeObjectForKey:@"brushColor"];

        
        
    }
    return self;
}


@end

