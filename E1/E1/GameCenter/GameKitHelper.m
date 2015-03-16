//
//  GameKitHelper.m
//  CatRaceStarter
//
//  Created by Kauserali on 12/01/14.
//  Copyright (c) 2014 Raywenderlich. All rights reserved.
//

#import "GameKitHelper.h"
#import <AVFoundation/AVFoundation.h>

NSString *const PresentAuthenticationViewController = @"present_authentication_view_controller";
NSString *const LocalPlayerIsAuthenticated = @"local_player_authenticated";
NSString *const GameCenterVoiceChannelForMeeting=@"GameCenterVoiceChannelNameOfChartDemo";
@interface GameKitHelper()
@property (strong,nonatomic) GKVoiceChat* chat;
@end
@implementation GameKitHelper {
    BOOL _enableGameCenter;
    BOOL _matchStarted;
    
}

+ (instancetype)sharedGameKitHelper
{
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper = [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

- (id)init
{
    self = [super init];
    if (self) {
        _enableGameCenter = YES;
    }
    return self;
}

- (void)authenticateLocalPlayer
{
    //1
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    if (localPlayer.isAuthenticated) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LocalPlayerIsAuthenticated object:nil];
        return;
    }
    //2
    localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error) {
        //3
        [self setLastError:error];
        
        if(viewController != nil)
        {
            //4
            [self setAuthenticationViewController:viewController];
        }
        else if([GKLocalPlayer localPlayer].isAuthenticated)
        {
            //5
            _enableGameCenter = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:LocalPlayerIsAuthenticated object:nil];
        }
        else
        {
            //6
            _enableGameCenter = NO;
        }
    };
}

- (void)setAuthenticationViewController:(UIViewController *)authenticationViewController
{
    if (authenticationViewController != nil) {
        _authenticationViewController = authenticationViewController;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:PresentAuthenticationViewController
         object:self];
    }
}

- (void)setLastError:(NSError *)error
{
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@",
              [[_lastError userInfo] description]);
    }

}

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController
                       delegate:(id<GameKitHelperDelegate>)delegate {
    
    if (!_enableGameCenter) return;
    
    _matchStarted = NO;
    self.match = nil;
    _delegate = delegate;
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    
    GKMatchmakerViewController *mmvc =
    [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    
    [viewController presentViewController:mmvc animated:YES completion:nil];
}
- (void)lookupPlayers
{
    
    NSLog(@"Looking up %lu players...", (unsigned long)_match.playerIDs.count);
    
    [GKPlayer loadPlayersForIdentifiers:_match.playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
        
        if (error != nil)
        {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
            _matchStarted = NO;
            [_delegate matchEnded];
        }
        else
        {
            
            // Populate players dict
            _playersDict = [NSMutableDictionary dictionaryWithCapacity:players.count];
            for (GKPlayer *player in players)
            {
                NSLog(@"Found player: %@", player.alias);
                [_playersDict setObject:player forKey:player.playerID];
            }
//            [_playersDict setObject:[GKLocalPlayer localPlayer] forKey:[GKLocalPlayer localPlayer].playerID];
            
            // Notify delegate match can begin
            _matchStarted = YES;
            [_delegate matchStarted];
        }
    }];
}

- (void)establishVoiceChatForAllPlayers
{
    if (![GKVoiceChat isVoIPAllowed])
        return;
    
    if (![self establishPlayAndRecordAudioSession])
        return;
    
    NSLog(@"Did stablish voice chat");
    
    _chat = [_match voiceChatWithName:GameCenterVoiceChannelForMeeting];
    [_chat start]; // stop with [chat end];
    
    
    _chat.playerStateUpdateHandler = ^(NSString *playerID, GKVoiceChatPlayerState state) {
        switch (state)
        {
            case GKVoiceChatPlayerSpeaking:
                // Highlight player's picture
                NSLog(@"Speaking");
                break;
            case GKVoiceChatPlayerSilent:
                // Dim player's picture
                NSLog(@"Silent");
                break;
            case GKVoiceChatPlayerConnected:
                // Show player name/picture
                NSLog(@"Voice connected");
                break;
            case GKVoiceChatPlayerDisconnected:
                // Hide player name/picture
                NSLog(@"Voice disconnected");
                break;
            default:
                break;
        } };
    
    _chat.active = YES; // disable mic by setting to NO
    _chat.volume = 1.0f; // adjust as needed.
    
}
- (BOOL) establishPlayAndRecordAudioSession
{
    NSLog(@"Establishing Audio Session");
    NSError *error;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (!success)
    {
        NSLog(@"Error setting session category: %@", error.localizedFailureReason);
        return NO;
    }
    else
    {
        success = [audioSession setActive: YES error: &error];
        if (success)
        {
            NSLog(@"Audio session is active (play and record)");
            return YES;
        }
        else
        {
            NSLog(@"Error activating audio session: %@", error.localizedFailureReason);
            return NO;
        }
    }
    
    return NO;
}
#pragma <GKMatchmakerViewControllerDelegate>

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    if(self.delegate!=nil)
       [((UIViewController*)self.delegate) dismissViewControllerAnimated:YES completion:nil];
}


- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error finding match: %@", error.localizedDescription);
    if(self.delegate!=nil)
        [((UIViewController*)self.delegate) dismissViewControllerAnimated:YES completion:nil];
}


- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
    self.match = match;
    match.delegate = self;
    if (!_matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"Ready to start match!");
        [self lookupPlayers];
    }
}


#pragma mark <GKMatchDelegate>


- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    if (_match != match) return;
    
    [_delegate match:match didReceiveData:data fromPlayer:playerID];
}


- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    if (_match != match) return;
    
    switch (state) {
        case GKPlayerStateConnected:
        {
            // handle a new player connection.
            NSLog(@"Player connected!");
            
            if (!_matchStarted && match.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
                [self lookupPlayers];
            }
        }
            
            break;
        case GKPlayerStateDisconnected:
        {
            // a player just disconnected.
            NSLog(@"Player disconnected!");
            _matchStarted = NO;
            [_delegate matchEnded];
        }
            break;
        case GKPlayerStateUnknown:
            break;
    }
}


- (void)match:(GKMatch *)match connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
    
    if (_match != match) return;
    
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    _matchStarted = NO;
    
    [_delegate matchEnded];
}


- (void)match:(GKMatch *)match didFailWithError:(NSError *)error {
    
    if (_match != match) return;
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    _matchStarted = NO;
    [_delegate matchEnded];
    
    
}
@end
