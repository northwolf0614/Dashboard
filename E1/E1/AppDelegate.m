//
//  AppDelegate.m
//  E1
//
//  Created by Jack Lin on 18/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
//#import "DashboardTableViewController.h"
#import "PageTableViewController.h"
#import "DashBoardViewController.h"
#import "StartupViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) UINavigationController* navigationController;
//@property(nonatomic,strong) ViewController* rootViewController;
//@property (nonatomic, strong) DashboardTableViewController* rootViewController;

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{

    
    
    
    self.window =(MainWindow*) [[MainWindow alloc] initWithFrame:[AppDelegate screenRectForLandscape]] ;
    //self.window =(MainWindow*) [MainWindow new];

    //self.window =(MainWindow*) [[MainWindow alloc] init] ;
#ifndef MASTERDETAIL
     //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
     {
         StartupViewController* startupVC=[[StartupViewController alloc] init];
         //DashBoardViewController *detailViewController = [[DashBoardViewController alloc] init] ;
         //UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController] ;
         //UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController] ;
         
         //self.window.rootViewController = detailNavigationController;
         //self.window.rootViewController = detailViewController;
         self.window.rootViewController = startupVC;
     }
     //else
#else
     {
         PageTableViewController* masterViewController = [[PageTableViewController alloc] init] ;
         UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController] ;
         
         DashBoardViewController *detailViewController = [[DashBoardViewController alloc] init] ;
         //UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController] ;
         UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController] ;
         
         
         masterViewController.detailViewController = detailViewController;
         
         self.splitViewController = [[SplitViewController alloc] init] ;
         self.splitViewController.delegate = detailViewController;
         self.splitViewController.viewControllers = @[masterNavigationController, detailNavigationController];
         
         self.window.rootViewController = self.splitViewController;
     }
#endif
    [self.window makeKeyAndVisible];
    self.window.frame = [AppDelegate screenRectForLandscape];
    
    
     return YES;
    //self.splitViewController present

    
}

- (void)applicationWillResignActive:(UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//-(void)sendEvent:(UIEvent *)event
//{
//    if (event.type==UIEventTypeTouches) {f
//        if ([[event.allTouches anyObject] phase]==UITouchPhaseBegan) {
//            //响应触摸事件（手指刚刚放上屏幕）
//            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:nScreenTouch object:nil userInfo:[NSDictionary dictionaryWithObject:event forKey:@"data"]]];
//            //发送一个名为‘nScreenTouch’（自定义）的事件
//        }
//    }
//    [super sendEvent:event];
//}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

+( CGRect )screenRectForLandscape
{
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return CGRectMake(0, 0, MAX(screenSize.width, screenSize.height), MIN(screenSize.width, screenSize.height));
}

@end
