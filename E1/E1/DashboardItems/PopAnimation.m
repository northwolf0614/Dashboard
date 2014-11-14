//
//  PopAnimation.m
//  E1
//
//  Created by Jack Lin on 14/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "PopAnimation.h"
#import "DetailChartViewController.h"
#import "DashboardTableViewController.h"
#import "Definations.h"
@implementation PopAnimation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kcControllerTransitionTime;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([fromViewController isKindOfClass:[DetailChartViewController class]] && [toViewController isKindOfClass:[DashboardTableViewController class]])
    {
            //Dismissing MapViewControll from ChatViewController
            DetailChartViewController* dvc = (DetailChartViewController*)fromViewController;
            DashboardTableViewController* dashvc = (DashboardTableViewController*)toViewController;
            //DashboardTableViewController* dashvc = (DashboardTableViewController*)fromViewController;
            
            CGRect transitioningFrame = [dashvc.transitioningView convertRect:dashvc.transitioningView.bounds toView:dashvc.view];//get the dashvc.transitoningview positon referencing to the dashvc.view
            
            //desination view controller
            dashvc.transitioningView.alpha = 0.0f;
            [containerView addSubview:dashvc.view];
            
            //source view controller
            dvc.view.alpha = 1.0f;
            [containerView insertSubview:dvc.view aboveSubview:dashvc.view];
            
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                //source view controller
                dvc.view.transform = CGAffineTransformMakeScale(CGRectGetWidth(transitioningFrame) / CGRectGetWidth(containerView.bounds),
                                                                CGRectGetHeight(transitioningFrame) / CGRectGetHeight(containerView.bounds));
                dvc.view.frame = transitioningFrame;
                dvc.view.alpha = 0.0f;
                
                //desination view controller
                dashvc.transitioningView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
            
        }
}

@end
