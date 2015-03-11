//
//  MeetingCoordinator.m
//  E1
//
//  Created by Jack Lin on 6/03/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import "MeetingCoordinator.h"
#import "GameKitHelper.h"
#import "ChartDataManager.h"
@interface MeetingCoordinator()<GameKitHelperDelegate>
@end

@implementation MeetingCoordinator
-(void)submitSuccessfully:(UIViewController *)vc
{
    [super submitSuccessfully:vc];
    NSError* error;
    
    if([NSJSONSerialization isValidJSONObject:self.dataForNChart])
    {
        NSData* jsonData=[NSJSONSerialization dataWithJSONObject:self.dataForNChart options:0 error:&error];
        if (error!=nil)
            NSLog(@"Converting to JSON data fail:%@",[error localizedDescription]);
        else
            [self sendDataToAll:jsonData];
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //self.view.backgroundColor=[UIColor redColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerAuthenticated) name:LocalPlayerIsAuthenticated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthenticationViewController) name:PresentAuthenticationViewController
     object:nil];
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
}
- (void)showAuthenticationViewController
{
    GameKitHelper *gameKitHelper =
    [GameKitHelper sharedGameKitHelper];
    
    [self presentViewController:
     gameKitHelper.authenticationViewController
                                         animated:YES
                                       completion:nil];
}





- (void)playerAuthenticated {
    [[GameKitHelper sharedGameKitHelper] findMatchWithMinPlayers:2 maxPlayers:2 viewController:self delegate:self];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sendDataToAll:(NSData*)data
{
    NSError *error;
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    
    BOOL success = [gameKitHelper.match
                    sendDataToAllPlayers:data
                    withDataMode:GKMatchSendDataReliable
                    error:&error];
    
    if (!success) {
        NSLog(@"Error sending data:%@", error.localizedDescription);
        [self matchEnded];
    }
}
- (void)sendData:(NSData*)data toPlayers:(NSArray *)players
{
    NSError *error;
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    
    BOOL success = [gameKitHelper.match
                    sendData:data toPlayers:players withDataMode: GKMatchSendDataReliable
                    error:&error];
    
    if (!success) {
        NSLog(@"Error sending data:%@", error.localizedDescription);
        [self matchEnded];
    }
}
-(void)joinDefaultVoiceChannel
{
    
    [[GameKitHelper sharedGameKitHelper] establishVoiceChatForAllPlayers];
    
    
    
}



#pragma <GCHelperDelegate>
- (void)matchStarted
{
    NSLog(@"The exciting meeting begain->matchStarted");
    [self joinDefaultVoiceChannel];
    
//    NSString *aString = @"Hello Game Data";
//    NSData *aData = [aString dataUsingEncoding: NSUTF8StringEncoding];
//    [self sendDataToAll:aData];
}
- (void)matchEnded
{
    NSLog(@"matchEnded");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data
   fromPlayer:(NSString *)playerID
{
    
    NSError* error;
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"received data:%@",aString);
    self.dataForNChart=[[ChartDataManager defaultChartDataManager] convertJSONToChartData:data error:&error];
    if (self.dataForNChart!=nil)
            [self.collectionView reloadData];
    
    
    
    
    
    
    
    
    
}
@end
