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

+(NSArray*)chartDataDefault
{
    NSMutableArray* chartsArray= [NSMutableArray array];

    NChartDataModel* chartData1=[[NChartDataModel alloc] init];
    chartData1.chartCaption=@"column&line";
    chartData1.chartAxisXCaption=@"Years";
    chartData1.chartAxisYCaption=@"Products percentage";
    chartData1.chartType=Dimention2;
    chartData1.chartAxisXTicksValues=[NSArray arrayWithObjects:@"2000",@"2001",@"2002",@"2003",nil];
    
    chartData1.chartDataForDrawing= [NSMutableDictionary dictionary];
 
    
    
    
    //setup rawData
    PrototypeDataModel* rawData=[[PrototypeDataModel alloc] init];
    rawData.seriesName=@"percentage";
    rawData.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],nil];
    rawData.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.5],nil];
    rawData.seriesType=COLUMN;
    rawData.brushColor=[UIColor orangeColor];
    //chartData.chartDataForDrawing= [NSMutableDictionary dictionary];
        //setup rawData1
    PrototypeDataModel* rawData1=[[PrototypeDataModel alloc] init];
    rawData1.seriesName=@"percentage1";
    rawData1.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],nil];
    rawData1.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],nil];
    rawData1.seriesType=COLUMN;
    rawData1.brushColor=[UIColor colorWithRed:0.8 green:0.1 blue:0.1 alpha:0.9];
    //setup rawData2
    PrototypeDataModel* rawData2=[[PrototypeDataModel alloc] init];
    rawData2.seriesName=@"percentage2";
    rawData2.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],nil];
    rawData2.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],nil];
    rawData2.seriesType=LINE;
    rawData2.brushColor=[UIColor blueColor];
    
   


    
    
    //additive data
    [chartData1.chartDataForDrawing setObject:rawData forKey:rawData.seriesName];
    [chartData1.chartDataForDrawing setObject:rawData1 forKey:rawData1.seriesName];
    [chartData1.chartDataForDrawing setObject:rawData2 forKey:rawData2.seriesName];
    chartData1.axisType=ADDITIVE;
    
    
    

    ///////////////////////////////////////////////////////////////////////////////////////////////////
  
    NChartDataModel* chartData2=[[NChartDataModel alloc] init];
    chartData2.chartCaption=@"BAR";
    chartData2.chartAxisXCaption=@"product percentage";
    chartData2.chartAxisYCaption=@"Years";
    chartData2.chartType=Dimention2;
    chartData2.chartAxisYTicksValues=[NSArray arrayWithObjects:@"2000",@"2001",@"2002",@"2003",nil];
    
    chartData2.chartDataForDrawing= [NSMutableDictionary dictionary];
    
    //setup rawData3
    PrototypeDataModel* rawData3=[[PrototypeDataModel alloc] init];
    rawData3.seriesName=@"percentage3";
    rawData3.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2002],nil];
    rawData3.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.4],nil];
    rawData3.seriesType=BAR;
    rawData3.brushColor=[UIColor orangeColor];
    //setup data4
    PrototypeDataModel* rawData4=[[PrototypeDataModel alloc] init];
    rawData4.seriesName=@"percentage4";
    rawData4.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2002],nil];
    rawData4.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.1],nil];
    rawData4.seriesType=BAR;
    rawData4.brushColor=[UIColor lightGrayColor];

    //additive
    [chartData2.chartDataForDrawing setObject:rawData3 forKey:rawData3.seriesName];
    [chartData2.chartDataForDrawing setObject:rawData4 forKey:rawData4.seriesName];
    chartData2.axisType=ADDITIVE;
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////

    //doughnut
    NChartDataModel* chartData3=[[NChartDataModel alloc] init];
    chartData3.chartCaption=@"doughnut";
    chartData3.chartAxisXCaption=@"product percentage";
    chartData3.chartAxisYCaption=@"Years";
    chartData3.chartType=Dimention2;
    chartData3.chartAxisYTicksValues=[NSArray arrayWithObjects:@"2000",@"2001",@"2002",@"2003",nil];
    
    chartData3.chartDataForDrawing= [NSMutableDictionary dictionary];
    
    //setup rawData3
    PrototypeDataModel* rawData5=[[PrototypeDataModel alloc] init];
    rawData5.seriesName=@"percentage5";
    rawData5.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],nil];//in this case, this data seems useless
    rawData5.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.90],nil];
    rawData5.seriesType=DOUGHNUT;
    rawData5.brushColor=[UIColor orangeColor];
    //setup data4
    PrototypeDataModel* rawData6=[[PrototypeDataModel alloc] init];
    rawData6.seriesName=@"percentage6";
    rawData6.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],nil];//in this case, this data seems useless
    rawData6.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.9],nil];
    rawData6.seriesType=DOUGHNUT;
    rawData6.brushColor=[UIColor grayColor];
    
    //additive
    [chartData3.chartDataForDrawing setObject:rawData5 forKey:rawData5.seriesName];
    [chartData3.chartDataForDrawing setObject:rawData6 forKey:rawData6.seriesName];
    chartData3.axisType=ABSOLUTE;

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    
    NChartDataModel* chartData4=[[NChartDataModel alloc] init];
    chartData4.chartCaption=@"RADAR";
    chartData4.chartAxisXCaption=@"product percentage";
    chartData4.chartAxisYCaption=@"Years";
    chartData4.chartType=Dimention2;
    chartData4.chartAxisYTicksValues=[NSArray arrayWithObjects:@"2000",@"2001",@"2002",@"2003",nil];
    
    chartData4.chartDataForDrawing= [NSMutableDictionary dictionary];
    
    //setup rawData3
    PrototypeDataModel* rawData7=[[PrototypeDataModel alloc] init];
    rawData7.seriesName=@"percentage7";
    rawData7.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2001],[NSNumber numberWithInt:2002],[NSNumber numberWithInt:2003],nil];//in this case, this data seems useless
    rawData7.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.90],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],nil];
    rawData7.seriesType=RADAR;
    rawData7.brushColor=[UIColor orangeColor];
    //setup data4
    PrototypeDataModel* rawData8=[[PrototypeDataModel alloc] init];
    rawData8.seriesName=@"percentage8";
    rawData8.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2001],[NSNumber numberWithInt:2002],[NSNumber numberWithInt:2003],nil];//in this case, this data seems useless
    rawData8.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:0.1],nil];
    rawData8.seriesType=RADAR;
    rawData8.brushColor=[UIColor grayColor];
    
    //additive
    [chartData4.chartDataForDrawing setObject:rawData7 forKey:rawData7.seriesName];
    [chartData4.chartDataForDrawing setObject:rawData8 forKey:rawData8.seriesName];
    chartData4.axisType=ABSOLUTE;
    
    [chartsArray addObject:chartData1];
    [chartsArray addObject:chartData2];
    [chartsArray addObject:chartData3];
    [chartsArray addObject:chartData4];
    

    
    
    
    
    
    return chartsArray ;
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

