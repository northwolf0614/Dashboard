//
//  AppDelegate.m
//  E1
//
//  Created by Jack Lin on 18/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DashboardTableViewController.h"
#import "PageTableViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) UINavigationController* navigationController;
//@property(nonatomic,strong) ViewController* rootViewController;
@property (nonatomic, strong) DashboardTableViewController* rootViewController;
@property(nonatomic,strong) UISplitViewController* splitViewController;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    //self.rootViewController= [[ViewController alloc] init ];
//    self.rootViewController = [[DashboardTableViewController alloc] init];
//    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
//    self.window.rootViewController = self.navigationController;
//    [self.window makeKeyAndVisible];
//    return YES;
    
    
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
     // Override point for customization after application launch.
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
     {
         DashboardTableViewController* masterViewController = [[DashboardTableViewController alloc] init] ;
         self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController] ;
         self.window.rootViewController = self.navigationController;
     }
     else
     {
         PageTableViewController* masterViewController = [[PageTableViewController alloc] init] ;
         UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController] ;
         
         DashboardTableViewController *detailViewController = [[DashboardTableViewController alloc] init] ;
         UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController] ;
            
            masterViewController.detailViewController = detailViewController;
         
         self.splitViewController = [[UISplitViewController alloc] init] ;
         self.splitViewController.delegate = detailViewController;
         self.splitViewController.viewControllers = @[masterNavigationController, detailNavigationController];
         
         self.window.rootViewController = self.splitViewController;
     }
     [self.window makeKeyAndVisible];
     return YES;

    
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

@end
