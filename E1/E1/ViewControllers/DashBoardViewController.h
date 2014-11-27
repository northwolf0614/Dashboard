//
//  DashBoardViewController.h
//  E1
//
//  Created by Jack Lin on 26/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definations.h"
#import "AbstractNChartViewController.h"
#import "PopAnimation.h"
#import "PushAnimation.h"

@class PushAnimation;
@class PopAnimation;

@interface DashBoardViewController : UIViewController <ChartSubviewControllerResponse,UINavigationControllerDelegate,UISplitViewControllerDelegate,UIViewControllerAnimatedTransitioning,UIViewControllerAnimatedTransitioning,UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong) NSMutableArray* chartNames;
@property(nonatomic,strong) UIView* transitioningView;
@property (copy, nonatomic) NSString* detailItem;

@property (strong, nonatomic) PushAnimation *pushAnimation;
@property (strong, nonatomic) PopAnimation *popAnimation;
//@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;
-(void)setupDefaultDataForDrawing;

@end
