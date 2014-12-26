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
//#import "PopAnimation.h"
//#import "PushAnimation.h"
#import "AnimatedTransitioningManager.h"
#import "TLSpringFlowLayout.h"

@class PushAnimation;
@class PopAnimation;

@interface DashBoardViewController : UIViewController <UIViewControllerAnimatedTransitioning,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray* dashboardItemViewControllers;
@property (nonatomic, strong) NSMutableArray* chartDataAssembly;

@property(nonatomic,strong) NSMutableArray* chartNames;//seem useless
@property(nonatomic,strong) UIView* transitioningView;
@property (copy, nonatomic) NSString* detailItem;//page name
@property (strong, nonatomic) PushAnimation *pushAnimation;
@property (strong, nonatomic) PopAnimation *popAnimation;
@property(nonatomic,weak) AnimatedTransitioningManager* interactionController;
-(void)setupDefaultDataForDrawing;
-(void)changeColorScheme:(BOOL)isWhiteSheme;


@end
