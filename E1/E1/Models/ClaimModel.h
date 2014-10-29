//
//  ClaimModel.h
//  E1
//
//  Created by Jack Lin on 23/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//
/*
 - total ( value of claims opened by a week by product by channel)
 - claims closed by week by product by channel  and $ value
 - total cliams by status by product
 - reopneed claims                           ok
 - reservs totals average
 - loss payments by week by product
 - claim location                            ok
 - claim where lawyer/doctor is involved     ok
 - claims under investigation or in dispute  ok
 [21/10/2014 5:15:07 pm] billy huang: 过几天看看怎么去给你所有这些数据
 */
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, ClaimProcess) {
    UnderDispute,
    UnderInvestigation,
};
typedef NS_ENUM(NSUInteger, ClaimStatus) {
    Reopened,
    Closed,
    Initial,
};
typedef NS_ENUM(NSUInteger, ProductForClaim) {
    CarInsurance,
    HomeInsurance,
    LifeInsurance,
};
typedef NS_ENUM(NSUInteger, ChannelForClaim) {
    ChannelSydney,
    ChannelMelbourne,
};
@interface ClaimModel : NSObject
@property (nonatomic, strong) NSString* claimDiscription;
@property (nonatomic, strong) NSString* claimTitle;
@property (nonatomic, strong) NSNumber* claimID;
@property (nonatomic, strong) NSString* location;
@property (nonatomic, strong) NSDate* claimSubmissionTime;
@property (nonatomic, assign) ProductForClaim* product;
@property (nonatomic, assign) ChannelForClaim* channel;
@property (nonatomic, assign) ClaimStatus* claimStatus;
@property (nonatomic, assign) BOOL isLayerInvolved;
@property (nonatomic, assign) ClaimProcess* process;
@end
