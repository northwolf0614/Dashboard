//
//  StatisticsPostWorker.m
//  E1
//
//  Created by Jack Lin on 18/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//
#import "StatisticsPostWorker.h"
#import "HTTPService.h"
#import "Notifications.h"
#import "Definations.h"
@interface StatisticsPostWorker ()
@property (nonatomic, strong) HTTPService* httpService;

@end

@implementation StatisticsPostWorker
- (id)init
{
    if (self = [super init]) {
        self.httpService = [[HTTPService alloc] initWithDelegate:self];
    }

    return self;
}
- (void)startRequestStatistics
{
    [self.httpService postRequestWithURL:kcURL postBody:kcHTTPBody userName:kcUserName password:kcPassword];
}

- (void)cancelRequestStatistics
{
    [self.httpService cancelService];
}
#pragma HTTPServiceDelegate
- (void)requestSucceed:(NSData*)receivedData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kStatisticsRetrieveSuccessfullyNotificatioin object:receivedData userInfo:nil]; //object is the parameter coupled with the sent message
}
- (void)requestFail:(NSError*)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kStatisticsRetrieveFailureNotification" object:error userInfo:nil]; //object is the parameter coupled with the sent message
}

@end
