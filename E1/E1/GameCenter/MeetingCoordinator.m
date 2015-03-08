//
//  MeetingCoordinator.m
//  E1
//
//  Created by Jack Lin on 6/03/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import "MeetingCoordinator.h"
#import "GameKitHelper.h"
@interface MeetingCoordinator()<GameKitHelperDelegate>
@end

@implementation MeetingCoordinator

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerAuthenticated)
                                                 name:LocalPlayerIsAuthenticated object:nil];
}





- (void)playerAuthenticated {
    [[GameKitHelper sharedGameKitHelper] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:self];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



//-(void)sendChartDataToAllPalyers:(NSData *)data error:(NSError **)error
//{
//     [[GCHelper sharedInstance] sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:error];
//    
//}
//-(void)sendVoiceToAllPalyers:(NSData *)data error:(NSError **)error
//{
//    [[GCHelper sharedInstance] sendDataToAllPlayers:data withDataMode:GKMatchSendDataUnreliable error:error];
//}

#pragma <GCHelperDelegate>
- (void)matchStarted
{
    NSLog(@"matchStarted");
}
- (void)matchEnded
{
    NSLog(@"matchEnded");
    
}
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data
   fromPlayer:(NSString *)playerID
{
    NSLog(@"received data");
    
}
@end
