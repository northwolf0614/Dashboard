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

-(void)adaptedForFloatingNumber
{
    
    NSArray* keysArray=self.chartDataForDrawing.allKeys;
    int seriesNumber=[keysArray count];
    BOOL seriesTypeIndicator=YES;
    BOOL dataNumberIndicator=YES;

    for (int count=0; count<[keysArray count]; count++)//for every series
    {
        NSString* key=[keysArray objectAtIndex:count];
        NSeriesType seriesType=[[self.chartDataForDrawing objectForKey:key] seriesType];
        int dataNumber=[[[self.chartDataForDrawing objectForKey:key] chartAxisXValues] count];

        if (dataNumber>1)
        {
            dataNumberIndicator=NO;
            break;
        }
        if (seriesType!=BAR&&seriesType!=DOUGHNUT)
        {
            seriesTypeIndicator=NO;
            break;
        }
    }
    if (seriesNumber==2&&seriesTypeIndicator&&dataNumberIndicator)//is bar or doughnut and there is only one piece of data and in this chart only 2 series.
    {
        
        double total=0.0f;
        NSArray* keysArray=self.chartDataForDrawing.allKeys;
        for (int count=0; count<[keysArray count]; count++)//for every series
        {
            NSString* key=[keysArray objectAtIndex:count];
            if ([[self.chartDataForDrawing objectForKey:key] seriesType]==BAR)
            {

                if ([[[self.chartDataForDrawing objectForKey:key] chartAxisXValues] count]>1) {
                    return;
                }
                total+=[[[[self.chartDataForDrawing objectForKey:key] chartAxisXValues] objectAtIndex:0] doubleValue];
            }
             if ([[self.chartDataForDrawing objectForKey:key] seriesType]==DOUGHNUT)
            {

                if ([[[self.chartDataForDrawing objectForKey:key] chartAxisYValues] count]>1)
                {
                    return;
                }
                total+=[[[[self.chartDataForDrawing objectForKey:key] chartAxisYValues] objectAtIndex:0] doubleValue];
            }



        }
//        if (total>=1)
//            self.floatingNumber=[NSString stringWithFormat:@"%d",(int)total];
//        if (total>0&&total<1)
//            self.floatingNumber=[NSString stringWithFormat:@"0.%d",(int)(total*10)];
        self.floatingNumber=[NSNumber numberWithFloat:total];
        
        
        
        
    }

    

    
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
        self.floatingNumber=[aDecoder decodeObjectForKey:@"floatingNumber"];

        
        
    }
    [self adaptedForFloatingNumber];
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
    rawData5.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:21],nil];
    rawData5.seriesType=DOUGHNUT;
    rawData5.brushColor=kcLikeBlue;
    //setup data4
    PrototypeDataModel* rawData6=[[PrototypeDataModel alloc] init];
    rawData6.seriesName=@"percentage6";
    rawData6.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],nil];//in this case, this data seems useless
    rawData6.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:121],nil];
    rawData6.seriesType=DOUGHNUT;
    rawData6.brushColor=kcLikeRed;
    
    //additive
    [chartData3.chartDataForDrawing setObject:rawData5 forKey:rawData5.seriesName];
    [chartData3.chartDataForDrawing setObject:rawData6 forKey:rawData6.seriesName];
    chartData3.axisType=ABSOLUTE;
    [chartData3 adaptedForFloatingNumber];
    


    NChartDataModel* chartData1=[[NChartDataModel alloc] init];
    chartData1.chartCaption=@"Claim Closed/Opened";
    chartData1.chartAxisXCaption=@"Years";
    chartData1.chartAxisYCaption=@"Products percentage";
    //chartData1.chartType=Dimention2;
    chartData1.chartAxisXTicksValues=[NSArray arrayWithObjects:@"June",@"July",@"August",@"September",nil];
    
    chartData1.chartDataForDrawing= [NSMutableDictionary dictionary];
 
    
    
    
    //setup rawData
    PrototypeDataModel* rawData=[[PrototypeDataModel alloc] init];
    rawData.seriesName=@"Opened";
    rawData.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],nil];
    rawData.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.5],nil];
    rawData.seriesType=COLUMN;
    //rawData.brushColor=[UIColor orangeColor];
    rawData.brushColor=kcLikeBlue;
    //chartData.chartDataForDrawing= [NSMutableDictionary dictionary];
        //setup rawData1
    PrototypeDataModel* rawData1=[[PrototypeDataModel alloc] init];
    rawData1.seriesName=@"Active";
    rawData1.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],nil];
    rawData1.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],nil];
    rawData1.seriesType=COLUMN;
    rawData1.brushColor=kcLikeOrange;
    //setup rawData2
    PrototypeDataModel* rawData2=[[PrototypeDataModel alloc] init];
    rawData2.seriesName=@"Closed";
    rawData2.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],nil];
    rawData2.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.1],nil];
    rawData2.seriesType=LINE;
    //rawData2.brushColor=[UIColor blueColor];
    rawData2.brushColor=kcLikeRed;
    
   


    
    
    //additive data
    [chartData1.chartDataForDrawing setObject:rawData forKey:rawData.seriesName];
    [chartData1.chartDataForDrawing setObject:rawData1 forKey:rawData1.seriesName];
    [chartData1.chartDataForDrawing setObject:rawData2 forKey:rawData2.seriesName];
    chartData1.axisType=ABSOLUTE;
    chartData1.dataForNextView=chartData3;
    chartData1.labelText=@"2014";
    [chartData1 adaptedForFloatingNumber];
    
    
    

    ///////////////////////////////////////////////////////////////////////////////////////////////////
  
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
    [chartData2 adaptedForFloatingNumber];
   
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
    rawData7.seriesType=RADAR;
    //rawData7.brushColor=[UIColor orangeColor];
    rawData7.brushColor=kcLikeRed;
    //setup data4
    PrototypeDataModel* rawData8=[[PrototypeDataModel alloc] init];
    rawData8.seriesName=@"Quoted";
    rawData8.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2001],[NSNumber numberWithInt:2002],[NSNumber numberWithInt:2003],[NSNumber numberWithInt:2004],[NSNumber numberWithInt:2005],nil];//in this case, this data seems useless
    rawData8.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.8],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.7],nil];
    rawData8.seriesType=RADAR;
    //rawData8.brushColor=[UIColor grayColor];
    rawData8.brushColor=kcLikeBlue;
    //additive
    [chartData4.chartDataForDrawing setObject:rawData7 forKey:rawData7.seriesName];
    [chartData4.chartDataForDrawing setObject:rawData8 forKey:rawData8.seriesName];
    
    
    chartData4.axisType=ABSOLUTE;
    [chartData4 adaptedForFloatingNumber];
    
    [chartsArray addObject:chartData1];
    [chartsArray addObject:chartData2];
    //[chartsArray addObject:chartData3];
    [chartsArray addObject:chartData4];
    

    
    
    
    
    return chartsArray ;
}
-(void)updateSeries:(NSDictionary*) seriesData
{
    
    if ([[seriesData allKeys] count]!=[[self.chartDataForDrawing allKeys] count]) {
        return;
    }
    //[self willChangeValueForKey:@"seriesUpdate"];
    for (NSString* key in self.chartDataForDrawing)//for every serie
    {
        [self.chartDataForDrawing setObject:[seriesData objectForKey:key] forKey:key];
    }
    //[self didChangeValueForKey:@"seriesUpdate"];
    
}
//+ (BOOL) automaticallyNotifiesObserversForKey:(NSString *)key {
//    if ([key isEqualToString:@"seriesUpdate"]) {
//        return NO;
//    }
//    
//    return [super automaticallyNotifiesObserversForKey:key];
//}

 +(NSMutableDictionary*)radarSeriesData
 {
     
     NSMutableDictionary* chartSeries= [NSMutableDictionary dictionary];
     
     //setup rawData3
     PrototypeDataModel* rawData7=[[PrototypeDataModel alloc] init];
     rawData7.seriesName=@"Converted";
     rawData7.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2001],[NSNumber numberWithInt:2002],[NSNumber numberWithInt:2003],nil];//in this case, this data seems useless
     rawData7.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.7],[NSNumber numberWithFloat:0.4],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.9],nil];
     rawData7.seriesType=RADAR;
     //rawData7.brushColor=[UIColor orangeColor];
     rawData7.brushColor=kcLikeRed;
     //setup data4
     PrototypeDataModel* rawData8=[[PrototypeDataModel alloc] init];
     rawData8.seriesName=@"Quoted";
     rawData8.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2001],[NSNumber numberWithInt:2002],[NSNumber numberWithInt:2003],nil];//in this case, this data seems useless
     rawData8.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.1],[NSNumber numberWithFloat:0.1],nil];
     rawData8.seriesType=RADAR;
     //rawData8.brushColor=[UIColor grayColor];
     rawData8.brushColor=kcLikeBlue;
     //additive
     [chartSeries setObject:rawData7 forKey:rawData7.seriesName];
     [chartSeries setObject:rawData8 forKey:rawData8.seriesName];
    return chartSeries ;
 }
+(NChartDataModel*) radarChart
{
    NChartDataModel* chartData4=[[NChartDataModel alloc] init];
    chartData4.chartCaption=@"Personal Quote Conversion";
    chartData4.chartAxisXCaption=@"product percentage";
    chartData4.chartAxisYCaption=@"Years";
    chartData4.chartType=RADAR;
    chartData4.chartAxisXTicksValues=[NSArray arrayWithObjects:@"Green Slip",@"Life",@"Home",@"Boat",nil];
    chartData4.labelText=@"2014";
    chartData4.chartDataForDrawing= [NSMutableDictionary dictionary];
    
    //setup rawData3
    PrototypeDataModel* rawData7=[[PrototypeDataModel alloc] init];
    rawData7.seriesName=@"Converted";
    rawData7.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2001],[NSNumber numberWithInt:2002],[NSNumber numberWithInt:2003],nil];//in this case, this data seems useless
    rawData7.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.10],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.6],[NSNumber numberWithFloat:0.7],nil];
    rawData7.seriesType=RADAR;
    //rawData7.brushColor=[UIColor orangeColor];
    rawData7.brushColor=kcLikeRed;
    //setup data4
    PrototypeDataModel* rawData8=[[PrototypeDataModel alloc] init];
    rawData8.seriesName=@"Quoted";
    rawData8.chartAxisXValues=[NSArray arrayWithObjects:[NSNumber numberWithInt:2000],[NSNumber numberWithInt:2001],[NSNumber numberWithInt:2002],[NSNumber numberWithInt:2003],nil];//in this case, this data seems useless
    rawData8.chartAxisYValues=[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.9],[NSNumber numberWithFloat:0.3],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:0.9],nil];
    rawData8.seriesType=RADAR;
    //rawData8.brushColor=[UIColor grayColor];
    rawData8.brushColor=kcLikeBlue;
    //additive
    [chartData4.chartDataForDrawing setObject:rawData7 forKey:rawData7.seriesName];
    [chartData4.chartDataForDrawing setObject:rawData8 forKey:rawData8.seriesName];
    
    
    chartData4.axisType=ABSOLUTE;
    [chartData4 adaptedForFloatingNumber];
    
    return chartData4;
    
    
    
    
    
    
    
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

