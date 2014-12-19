//
//  AnimatedTransitioningManager.h
//  E1
//
//  Created by Jack Lin on 14/12/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedTransitioningManager : UIPercentDrivenInteractiveTransition<UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
@property(nonatomic,assign) BOOL interactive;

- (void)cancelInteractiveTransitionWithDuration:(CGFloat)duration;
- (void)finishInteractiveTransitionWithDuration:(CGFloat)duration;
- (void)updateInteractiveTransition:(CGFloat)percentComplete;

@end
