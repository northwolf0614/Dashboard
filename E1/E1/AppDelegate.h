//
//  AppDelegate.h
//  E1
//
//  Created by Jack Lin on 18/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewController.h"
#import "MainWindow.h"
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) MainWindow* window;
@property(nonatomic,strong) SplitViewController* splitViewController;
@end
