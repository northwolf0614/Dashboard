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
@synthesize chartDataForDrawing;
#pragma <NSCopying>
-(NSDictionary*)serializeToDicForJSON
{
    NSInteger count=self.accessibilityElementCount;
    NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithCapacity:count];
    NSString* json_objectID=[self.objectID.URIRepresentation absoluteString];
    [dic setObject:json_objectID forKey:@"objectID"];
    NSString* json_chartCaption=self.chartCaption;
    [dic setObject:json_chartCaption forKey:@"chartCaption"];
    NSString* json_chartAxisYCaption=self.chartAxisYCaption;
    [dic setObject:json_chartAxisYCaption forKey:@"chartAxisYCaption"];
    NSString* json_chartAxisXCaption=self.chartAxisXCaption;
    [dic setObject:json_chartAxisXCaption forKey:@"chartAxisXCaption"];
    NSString* json_chartAxisZCaption=self.chartAxisZCaption;
    [dic setObject:json_chartAxisZCaption forKey:@"chartAxisZCaption"];
    NSArray* json_chartAxisXTicksValues=self.chartAxisXTicksValues;
    [dic setObject:json_chartAxisXTicksValues forKey:@"chartAxisXTicksValues"];
    NSArray* json_chartAxisYTicksValues=self.chartAxisYTicksValues;
    [dic setObject:json_chartAxisYTicksValues forKey:@"chartAxisYTicksValues"];
    NSArray* json_chartAxisZTicksValues=self.chartAxisZTicksValues;
    [dic setObject:json_chartAxisZTicksValues forKey:@"chartAxisZTicksValues"];
    NSeriesType json_chartType=self.chartType;
    [dic setObject:[NSNumber numberWithInteger:json_chartType] forKey:@"chartType"];
    AxisType json_axisType=self.axisType;
    [dic setObject:[NSNumber numberWithInteger:json_axisType] forKey:@"axisType"];
    NSString* json_pageName=self.pageName;
    [dic setObject:json_pageName forKey:@"pageName"];
    NSString* json_labelText=self.labelText;
    [dic setObject:json_labelText forKey:@"labelText"];
    NSNumber* json_percentage=self.percentage;
    [dic setObject:json_percentage forKey:@"percentage"];
    NSNumber* json_floatingNumber=self.floatingNumber;
    [dic setObject:json_floatingNumber forKey:@"floatingNumber"];
    
    NSMutableDictionary* json_chartDataForDrawing=self.chartDataForDrawing;
    [dic setObject:json_chartDataForDrawing forKey:chartDataForDrawing];
    
    AddedMap* json_dataForNextView=self.dataForNextView;
    [dic setObject:[json_dataForNextView serializeToDicForJSON] forKey:@"dataForNextView"];
    
    
    __block NSMutableArray* json_prediction=[NSMutableArray arrayWithCapacity:self.prediction.count];
    
    [self.prediction enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if ([obj isKindOfClass:[ChartPrediction class]]) {
            [json_prediction addObject:[obj serializeToDicForJSON]];
        }
    }];
    [dic setObject:json_prediction forKey:@"json_prediction"];
   
    
    
    
    return dic;
    
    
    
    
    
}
//-(NChartDataModel*)deserializeFromJSON:(id)jsonData
//{
//    
//}

-(id)copyWithZone:(NSZone *)zone
{
    NChartDataModel* data= [[NChartDataModel allocWithZone:zone] init];
    data.chartCaption=[self.chartCaption copy];
    data.chartAxisXCaption= [self.chartAxisXCaption copy];
    data.chartAxisYCaption= [self.chartAxisYCaption copy];
    data.chartAxisZCaption= [self.chartAxisZCaption copy];
    data.chartAxisXTicksValues= [self.chartAxisXTicksValues copy];
    data.chartAxisYTicksValues=[self.chartAxisYTicksValues copy];
    data.chartAxisZTicksValues=[self.chartAxisZTicksValues copy];
    data.chartType=self.chartType;
    data.axisType=self.axisType;
    data.isToolTips=self.isToolTips;
    data.sliceNumber=[self.sliceNumber copy];
    data.isBorder=self.isBorder;
    data.chartDataForDrawing=[self.chartDataForDrawing copy];
    data.dataForNextView=[self.dataForNextView copy];
    data.labelText=[self.labelText copy];
    data.percentage=[self.percentage copy];
    data.floatingNumber=[self.floatingNumber copy];
    data.isAnimated=self.isAnimated;
    data.empty=self.empty;
    
    return data;
}


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
    [aCoder encodeObject:self.dataForNextView forKey:@"dataForNextView"];//dataForNextView
    [aCoder encodeObject:self.labelText forKey:@"labelText"];//dataForNextView
    [aCoder encodeObject:self.floatingNumber forKey:@"floatingNumber"];//dataForNextView
    [aCoder encodeObject:self.percentage forKey:@"percentage"];//percentage
    
    

    
    
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
        self.dataForNextView=[aDecoder decodeObjectForKey:@"dataForNextView"];
        self.labelText=[aDecoder decodeObjectForKey:@"labelText"];
        self.floatingNumber=[aDecoder decodeObjectForKey:@"floatingNumber"];//floatingNumber
        self.percentage=[aDecoder decodeObjectForKey:@"percentage"];//percentage
        

        
        
    }
    //[self adaptedForFloatingNumber];
    return self;
}


//+(NSString*)getStoredDefaultFilePath
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docPath = [paths objectAtIndex:0];
//    return [docPath stringByAppendingPathComponent:kcDefaultDataFielName];
//}


+(NSArray*)chartDataDefault
{
    NSMutableArray* chartsArray= [NSMutableArray array];
    AddedMap* chartData3=[[AddedMap alloc] init];
    chartData3.color1=kcLikeBlue;
    chartData3.color2=kcLikeRed;
    int x;
    float percent;
    percent = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
    x = arc4random() % 100;
    chartData3.floatingNumber=[NSNumber numberWithFloat:x];
    chartData3.percentage=[NSNumber numberWithFloat:percent];
    


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
    rawData.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.2],nil];
    rawData.seriesType=COLUMN;
    //rawData.brushColor=[UIColor orangeColor];
    rawData.brushColor=kcLikeBlue;
    //chartData.chartDataForDrawing= [NSMutableDictionary dictionary];
        //setup rawData1
    PrototypeDataModel* rawData1=[[PrototypeDataModel alloc] init];
    rawData1.seriesName=@"Active";
    rawData1.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8],[NSNumber numberWithInt:9],[NSNumber numberWithInt:10],[NSNumber numberWithInt:11],nil];
    rawData1.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],nil];
    rawData1.seriesType=COLUMN;
    rawData1.brushColor=kcLikeOrange;
    //setup rawData2
    PrototypeDataModel* rawData2=[[PrototypeDataModel alloc] init];
    rawData2.seriesName=@"Closed";
    rawData2.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8],[NSNumber numberWithInt:9],[NSNumber numberWithInt:10],[NSNumber numberWithInt:11],nil];
    rawData2.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.05],nil];
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
    
    
    

    ///////////////////////////////////////////////////////////////////////////////////////////////////
  
    NChartDataModel* chartData2=[[NChartDataModel alloc] init];
    chartData2.chartCaption=@"Calls Waiting in Line";
    chartData2.chartAxisXCaption=@"percentage";
    chartData2.chartAxisYCaption=@"Years";
    chartData2.chartType=BAR;
    chartData2.labelText=@"2014";
    //chartData2.chartAxisYTicksValues=[NSArray arrayWithObjects:@"one",@"Two",nil];
    chartData2.chartAxisYTicksValues=[NSArray arrayWithObjects:@"one",@"",@"",@"",nil];
    
    chartData2.chartDataForDrawing= [NSMutableDictionary dictionary];
    
    //setup rawData3
    PrototypeDataModel* rawData3=[[PrototypeDataModel alloc] init];
    rawData3.seriesName=@"In call";
    rawData3.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],nil];
    rawData3.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.2],nil];
    rawData3.seriesType=BAR;
    rawData3.brushColor=kcLikeOrange;
    //rawData3.brushColor=[UIColor colorWithRed:236 green:250 blue:48 alpha:1];
    //setup data4
    PrototypeDataModel* rawData4=[[PrototypeDataModel alloc] init];
    rawData4.seriesName=@"Inactive";
    rawData4.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],nil];
    rawData4.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.4],nil];
    rawData4.seriesType=BAR;
    rawData4.brushColor=kcLikeGray;
    //rawData4.brushColor=[UIColor colorWithRed:47 green:45 blue:55 alpha:1];

    //additive
    [chartData2.chartDataForDrawing setObject:rawData3 forKey:rawData3.seriesName];
    [chartData2.chartDataForDrawing setObject:rawData4 forKey:rawData4.seriesName];
    chartData2.axisType=ADDITIVE;
    //[chartData2 adaptedForFloatingNumber];
    x = arc4random() % 100;
    chartData2.floatingNumber=[NSNumber numberWithFloat:x];
    
    
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////

        ///////////////////////////////////////////////////////////////////////////////////////////////////
    
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
    rawData7.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.90],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.90],[NSNumber numberWithFloat:0.5],nil];
//    rawData7.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.02],[NSNumber numberWithFloat:0.01],[NSNumber numberWithFloat:0.03],[NSNumber numberWithFloat:0.04],[NSNumber numberWithFloat:0.01],nil];
    rawData7.seriesType=RADAR;
    //rawData7.brushColor=[UIColor orangeColor];
    rawData7.brushColor=kcLikeRed;
    //setup data4
    PrototypeDataModel* rawData8=[[PrototypeDataModel alloc] init];
    rawData8.seriesName=@"Quoted";
    rawData8.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2001],[NSNumber numberWithInt:2002],[NSNumber numberWithInt:2003],[NSNumber numberWithInt:2004],[NSNumber numberWithInt:2005],nil];//in this case, this data seems useless
    rawData8.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],nil];
//    rawData8.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.05],[NSNumber numberWithFloat:0.03],[NSNumber numberWithFloat:0.02],[NSNumber numberWithFloat:0.01],[NSNumber numberWithFloat:0.03],[NSNumber numberWithFloat:0.01],nil];
    rawData8.seriesType=RADAR;
    //rawData8.brushColor=[UIColor grayColor];
    rawData8.brushColor=kcLikeBlue;
    //additive
    [chartData4.chartDataForDrawing setObject:rawData7 forKey:rawData7.seriesName];
    [chartData4.chartDataForDrawing setObject:rawData8 forKey:rawData8.seriesName];
    chartData4.axisType=ABSOLUTE;
     AddedMap* chartData5=[[AddedMap alloc] init];
     chartData5.color2=kcLikeRed;
     chartData5.color1=kcLikeBlue;
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
     rawData11.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.2],nil];
     rawData11.seriesType=AREA;
     //rawData.brushColor=[UIColor orangeColor];
     rawData11.brushColor=kcLikeRed;
     //chartData.chartDataForDrawing= [NSMutableDictionary dictionary];
     //setup rawData1
     PrototypeDataModel* rawData12=[[PrototypeDataModel alloc] init];
     rawData12.seriesName=@"Quoted";
     rawData12.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8],[NSNumber numberWithInt:9],[NSNumber numberWithInt:10],[NSNumber numberWithInt:11],nil];
     rawData12.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.1],nil];
     rawData12.seriesType=AREA;
     rawData12.brushColor=kcLikeBlue;
     //setup rawData2
     PrototypeDataModel* rawData13=[[PrototypeDataModel alloc] init];
     rawData13.seriesName=@"Estimate";
     rawData13.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],[NSNumber numberWithInt:6],[NSNumber numberWithInt:7],[NSNumber numberWithInt:8],[NSNumber numberWithInt:9],[NSNumber numberWithInt:10],[NSNumber numberWithInt:11],nil];
     rawData13.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],nil];
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
    


    [chartsArray addObject:chartData1];
    [chartsArray addObject:chartData2];
    [chartsArray addObject:chartData4];
    [chartsArray addObject:chartData6];
    

    
    
    
    
    return chartsArray ;
}


+(NSMutableDictionary*)radarSeriesData
{
     
     NSMutableDictionary* chartSeries= [NSMutableDictionary dictionary];
     
     //setup rawData3
     PrototypeDataModel* rawData7=[[PrototypeDataModel alloc] init];
     rawData7.seriesName=@"Converted";
     rawData7.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2001],[NSNumber numberWithInt:2002],[NSNumber numberWithInt:2003],[NSNumber numberWithInt:2004],[NSNumber numberWithInt:2005],nil];//in this case, this data seems useless
     rawData7.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.9],nil];
     rawData7.seriesType=RADAR;
     //rawData7.brushColor=[UIColor orangeColor];
     rawData7.brushColor=kcLikeRed;
     //setup data4
     PrototypeDataModel* rawData8=[[PrototypeDataModel alloc] init];
     rawData8.seriesName=@"Quoted";
     rawData8.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2001],[NSNumber numberWithInt:2002],[NSNumber numberWithInt:2003],[NSNumber numberWithInt:2004],[NSNumber numberWithInt:2005],nil];//in this case, this data seems useless
     rawData8.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.9],nil];
     rawData8.seriesType=RADAR;
     //rawData8.brushColor=[UIColor grayColor];
     rawData8.brushColor=kcLikeBlue;
     //additive
     [chartSeries setObject:rawData7 forKey:rawData7.seriesName];
     [chartSeries setObject:rawData8 forKey:rawData8.seriesName];
    
     return chartSeries ;
 }


 


@end

@implementation PrototypeDataModel


#pragma <NSCopying>
-(id)copyWithZone:(NSZone *)zone
{
    PrototypeDataModel* data=[[PrototypeDataModel allocWithZone:zone] init];
    data.seriesName= [self.seriesName copy];
    data.chartAxisXValues=[self.chartAxisXValues copy];
    data.chartAxisYValues= [self.chartAxisYValues copy];
    data.chartAxisZValues= [self.chartAxisZValues copy];
    data.seriesType=self.seriesType;
    data.brushColor=[self.brushColor copy];
    
    return data;
    
}
#pragma <NSCoding>
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

@implementation AddedMap

#pragma <NSCopying>
-(id)copyWithZone:(NSZone *)zone
{
    AddedMap* data=[[AddedMap allocWithZone:zone] init];
    data.color1= [self.color1 copy];
    data.color2=[self.color2 copy];
    data.percentage= [self.percentage copy];
    data.floatingNumber= [self.floatingNumber copy];
    
    
    return data;
    
}
#pragma <NSCoding>
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.color1 forKey:@"color1"];
    [aCoder encodeObject:self.color2 forKey:@"color2"];
    [aCoder encodeObject:self.percentage forKey:@"percentage"];
    [aCoder encodeObject:self.floatingNumber forKey:@"floatingNumber"];
    
    
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        self.color1=[aDecoder decodeObjectForKey:@"color1"];
        self.color2=[aDecoder decodeObjectForKey:@"color2"];
        self.percentage=[aDecoder decodeObjectForKey:@"percentage"];
        self.floatingNumber=[aDecoder decodeObjectForKey:@"floatingNumber"];
        
        
        
        
    }
    return self;
    
}
-(NSDictionary*)serializeToDicForJSON
{
    NSInteger count=self.accessibilityElementCount;
    NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithCapacity:count];
    
    NSNumber* json_percentage=self.percentage;
    [dic setObject:json_percentage forKey:@"percentage"];
    
    NSNumber* json_floatingNumber=self.floatingNumber;
    [dic setObject:json_floatingNumber forKey:@"floatingNumber"];
    
}

@end

@implementation ChartPrediction

#pragma <NSCopying>
-(id)copyWithZone:(NSZone *)zone
{
    ChartPrediction* data=[[ChartPrediction allocWithZone:zone] init];
    data.base= [self.base copy];
    data.mult1=[self.mult1 copy];
    data.mult2= [self.mult2 copy];
    data.key= [self.key copy];

    return data;
    
}
#pragma <NSCoding>
-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.base forKey:@"base"];
    [aCoder encodeObject:self.mult1 forKey:@"mult1"];
    [aCoder encodeObject:self.mult2 forKey:@"mult2"];
    [aCoder encodeObject:self.key forKey:@"key"];
    
    
    
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        self.mult2=[aDecoder decodeObjectForKey:@"mult2"];
        self.mult1=[aDecoder decodeObjectForKey:@"mult1"];
        self.base=[aDecoder decodeObjectForKey:@"base"];
        self.key=[aDecoder decodeObjectForKey:@"key"];
        
        
        
        
        
    }
    return self;
}
-(NSDictionary*)serializeToDicForJSON
{
    NSInteger count=self.accessibilityElementCount;
    NSMutableDictionary* dic=[NSMutableDictionary dictionaryWithCapacity:count];
    
    NSNumber* json_mult2=self.mult2;
    [dic setObject:json_mult2 forKey:@"mult2"];
    
    NSNumber* json_mult1=self.mult1;
    [dic setObject:json_mult1 forKey:@"mult1"];
    
    NSNumber* json_base=self.base;
    [dic setObject:json_base forKey:@"base"];
    
    NSNumber* json_key=self.key;
    [dic setObject:json_key forKey:@"key"];
    
    
    
    
    
    
    return dic;
    
    
}

@end

