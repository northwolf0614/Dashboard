#import "StatisticsModel.h"
@interface StatisticsModel()

@end

@implementation StatisticsModel
/*
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"statisticID": @"id",
             @"jsonrpc": @"jsonrpc",
             @"publicID": @"result.publicID",
             @"openActivityCount": @"result.openActivityCount",
             @"openClaimCount": @"result.openClaimCount",
             @"openExposureCount": @"result.openExposureCount",
             @"openMatterCount": @"result.openMatterCount",
            };
}

+(StatisticsModel*)convertJSONToStatisticModelInstance:(NSData*)receivedData error:(NSError*)error
{
    //NSError* error=nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&error];
    
    if (error != nil)
    {
        NSLog(@"converting data from internet into JSON format data fail %@", [error localizedDescription]);
        return nil;
    }
    else
    {

        //binding the key value with property of TideInfo
        error=nil;
        StatisticsModel* statisticsModelInstance= [MTLJSONAdapter modelOfClass:[StatisticsModel class] fromJSONDictionary:jsonObject error:&error];
        if (error!=nil) {
            NSLog(@"JSON format data parsing fail %@", [error localizedDescription]);
            return nil;
        }
        return statisticsModelInstance;
    }
}


    
*/
/*
"result": {
"publicID": "default_data:1",
"openActivityCount": 0,
"openClaimCount": 0,
"openExposureCount": 0,
"openMatterCount": 0
},
"id": "2",
"jsonrpc": "2.0"

*/
+(StatisticsModel*)convertJSONToStatisticModelInstance:(NSData*)receivedData error:(NSError*)error
{
    id jsonObject = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&error];
 
    if (error != nil)
    {
        NSLog(@"converting data from internet into JSON format data fail %@", [error localizedDescription]);
        return nil;
    }
 
    StatisticsModel *statisticsModelInstance = [[StatisticsModel alloc] init];
    NSString* idName = [jsonObject objectForKey:@"id"];
    if (![idName isKindOfClass:[NSString class]])
        return nil;
    [statisticsModelInstance setStatisticID:idName];
    
    NSString* jsonrpc = [jsonObject objectForKey:@"jsonrpc"];
    if (![jsonrpc isKindOfClass:[NSString class]])
        return nil;
    [statisticsModelInstance setJsonrpc:jsonrpc];
    
    id resultContents= [jsonObject objectForKey:@"result"];
    if (![resultContents isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    //NSMutableArray *mutableContents = [NSMutableArray array];
    //for (NSDictionary *resultContent in resultContents)
    {
        
        
        NSString* publicID = [resultContents objectForKey:@"publicID"];
        if (![publicID isKindOfClass:[NSString class]])
        {
            return nil;
        }
        [statisticsModelInstance setPublicID:publicID];
        
        NSNumber* openActivityCount = [resultContents objectForKey:@"openActivityCount"];
        if (![openActivityCount isKindOfClass:[NSNumber class]])
        {
            return nil;
        }
        [statisticsModelInstance setOpenActivityCount:openActivityCount];
        
        NSNumber* openClaimCount = [resultContents objectForKey:@"openClaimCount"];
        if (![openClaimCount isKindOfClass:[NSNumber class]])
        {
            return nil;
        }
        [statisticsModelInstance setOpenClaimCount:openClaimCount];
        
        NSNumber* openExposureCount = [resultContents objectForKey:@"openExposureCount"];
        if (![openExposureCount isKindOfClass:[NSNumber class]])
        {
            return nil;
        }
        [statisticsModelInstance setOpenExposureCount:openExposureCount];
        
        NSNumber* openMatterCount = [resultContents objectForKey:@"openMatterCount"];
        if (![openMatterCount isKindOfClass:[NSNumber class]])
        {
            return nil;
        }
        [statisticsModelInstance setOpenMatterCount:openMatterCount];

    }
    return statisticsModelInstance;
}



@end
