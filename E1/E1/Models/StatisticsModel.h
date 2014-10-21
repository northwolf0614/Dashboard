

#import <Foundation/Foundation.h>


@interface StatisticsModel : NSObject//MTLModel<MTLJSONSerializing>
{
}
@property(nonatomic,strong) NSString* statisticID;
@property(nonatomic,strong) NSString* jsonrpc;
@property(nonatomic,strong) NSString* publicID;
@property(nonatomic,strong) NSNumber* openActivityCount;
@property(nonatomic,strong) NSNumber* openClaimCount;
@property(nonatomic,strong) NSNumber* openExposureCount;
@property(nonatomic,strong) NSNumber* openMatterCount;

//+ (NSDictionary *)JSONKeyPathsByPropertyKey;
+(StatisticsModel*)convertJSONToStatisticModelInstance:(NSData*)receivedData error:(NSError*)error;
@end

