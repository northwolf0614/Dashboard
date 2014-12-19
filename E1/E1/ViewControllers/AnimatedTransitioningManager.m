//
//  AnimatedTransitioningManager.m
//  E1
//
//  Created by Jack Lin on 14/12/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AnimatedTransitioningManager.h"
#import "PageTableViewController.h"
#import "DashBoardViewController.h"
#import "CATransform3DPerspect.h"
#import "OutlinePresentationViewController.h"
@interface AnimatedTransitioningManager()
- (void)animateTransitionFrom:(CGFloat)fromPercent to:(CGFloat)toPercent animatedController:(UIViewController*)controller duration:(CGFloat)duration;
@end

@implementation AnimatedTransitioningManager
{
    CATransform3D _currentTransform;
}

- (void)animateTransitionFrom:(CGFloat)fromPercent to:(CGFloat)toPercent animatedController:(UIViewController*)controller duration:(CGFloat)duration
{
    CATransform3D move = CATransform3DMakeTranslation(0, 0, 128);
    CATransform3D back = CATransform3DMakeTranslation(0, 0, -128);
    
    CATransform3D rotateInitial = CATransform3DMakeRotation(0.4*M_PI, 0, 1, 0);
    CATransform3D mat0Initial = CATransform3DConcat(CATransform3DConcat(move, rotateInitial), back);
    CATransform3D initialTransform=CATransform3DPerspect(mat0Initial, CGPointZero, 500);
    controller.view.layer.transform=initialTransform;

    
    CATransform3D rotate0 = CATransform3DMakeRotation(0.4*M_PI*fromPercent, 0, 1, 0);
    CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
    CATransform3D semiFinal=CATransform3DPerspect(mat0, CGPointZero, 500);
    
    CATransform3D rotate1 = CATransform3DMakeRotation(toPercent*0.4*M_PI, 0, 1, 0);
    CATransform3D mat1 = CATransform3DConcat(CATransform3DConcat(move, rotate1), back);
    CATransform3D final=CATransform3DPerspect(mat1, CGPointZero, 500);
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    CABasicAnimation* anim=[CABasicAnimation animationWithKeyPath:@"transform"];
    [anim setFromValue:[NSValue valueWithCATransform3D:semiFinal]];
    [anim setToValue:[NSValue valueWithCATransform3D:final]];
    anim.delegate=self;
    [anim setValue:@"pagingAnimationTransition" forKey:@"pagingTransition"];
    [controller.view.layer addAnimation:anim forKey:nil];
    controller.view.layer.transform=final;
    controller.view.alpha = 1.0f;
    [CATransaction commit];

    
    
    
    
    
}
//- (void)endAtPercent:(CGFloat)toPercent animatedController:(UIViewController*)controller duration:(CGFloat)duration;
//{
//    CATransform3D move = CATransform3DMakeTranslation(0, 0, 128);
//    CATransform3D back = CATransform3DMakeTranslation(0, 0, -128);
//    CATransform3D rotate0 = CATransform3DMakeRotation(0.5*M_PI*toPercent, 0, 1, 0);
//    CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
//    CATransform3D finalTransform=CATransform3DPerspect(mat0, CGPointZero, 500);
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:duration];
//    CABasicAnimation* anim=[CABasicAnimation animationWithKeyPath:@"transform"];
//    [anim setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
//    [anim setToValue:[NSValue valueWithCATransform3D:finalTransform]];
//    anim.delegate=self;
//    [anim setValue:@"pagingAnimationTransitionPercent" forKey:@"pagingTransitionPercent"];
//    [controller.view.layer addAnimation:anim forKey:nil];
//    controller.view.layer.transform=finalTransform;
//    [CATransaction commit];
//}


#pragma mark <UIViewControllerTransitioningDelegate>


- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source
{
    if ([presented isKindOfClass:[PageTableViewController class]]&&[source isKindOfClass:[DashBoardViewController class]]) {
        return [[OutlinePresentationViewController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    }
    else
        return  nil;
    
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return self;
    
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
    
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return  self.interactive?self:nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return  self.interactive?self:nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
//- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    NSLog(@"this is animateTransition in AnimatedTransitionManager");
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* viewContainer= [transitionContext containerView];
    self.transitionContext=transitionContext;
    
//    if ([fromViewController isKindOfClass:[UINavigationController class]])
//    {
//        fromViewController=((UINavigationController*)fromViewController).topViewController;
//        
//    }
//    if ([toViewController isKindOfClass:[UINavigationController class]])
//    {
//        toViewController=((UINavigationController*)toViewController).topViewController;
//        
//    }
    if ([toViewController isKindOfClass:[PageTableViewController class]]&&[fromViewController isKindOfClass:[DashBoardViewController class]])
    {
        [viewContainer insertSubview:toViewController.view aboveSubview:fromViewController.view];
        CATransform3D move = CATransform3DMakeTranslation(0, 0, 128);
        CATransform3D back = CATransform3DMakeTranslation(0, 0, -128);
        
        CATransform3D rotateInitial = CATransform3DMakeRotation(0.4*M_PI, 0, 1, 0);
        CATransform3D mat0Initial = CATransform3DConcat(CATransform3DConcat(move, rotateInitial), back);
        CATransform3D initialTransform=CATransform3DPerspect(mat0Initial, CGPointZero, 500);
        toViewController.view.layer.transform=initialTransform;
        
        
        CATransform3D rotate0 = CATransform3DMakeRotation(0.4*M_PI, 0, 1, 0);
        CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
        CATransform3D semiFinal=CATransform3DPerspect(mat0, CGPointZero, 500);
        
        CATransform3D rotate1 = CATransform3DMakeRotation(0*M_PI, 0, 1, 0);
        CATransform3D mat1 = CATransform3DConcat(CATransform3DConcat(move, rotate1), back);
        CATransform3D final=CATransform3DPerspect(mat1, CGPointZero, 500);
        toViewController.view.alpha=0.0f;
        toViewController.view.layer.transform=semiFinal;
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:0.45];
//        CABasicAnimation* anim=[CABasicAnimation animationWithKeyPath:@"transform"];
//        [anim setFromValue:[NSValue valueWithCATransform3D:semiFinal]];
//        [anim setToValue:[NSValue valueWithCATransform3D:final]];
//        anim.delegate=self;
//        [anim setValue:@"pagingAnimationNonTransitionOpen" forKey:@"pagingAnimationNonTransitionOpen"];
//        [toViewController.view.layer addAnimation:anim forKey:nil];
//        toViewController.view.layer.transform=final;
//        toViewController.view.alpha = 1.0f;
//        [CATransaction commit];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^
         {
             toViewController.view.layer.transform=final;
             toViewController.view.alpha=1.0f;
         } completion:^(BOOL finished)
         {
             if (finished)
                 [transitionContext completeTransition:YES];
             
             
         }];
        
    }
    
    if ([fromViewController isKindOfClass:[PageTableViewController class]]&&[toViewController isKindOfClass:[DashBoardViewController class]] )
    {
        //[viewContainer insertSubview:toViewController.view aboveSubview:fromViewController.view];
        CATransform3D move = CATransform3DMakeTranslation(0, 0, 128);
        CATransform3D back = CATransform3DMakeTranslation(0, 0, -128);
        
        
        
        
        CATransform3D rotate0 = CATransform3DMakeRotation(0*M_PI, 0, 1, 0);
        CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
        CATransform3D semiFinal=CATransform3DPerspect(mat0, CGPointZero, 500);
        
        CATransform3D rotate1 = CATransform3DMakeRotation(0.4*M_PI, 0, 1, 0);
        CATransform3D mat1 = CATransform3DConcat(CATransform3DConcat(move, rotate1), back);
        CATransform3D final=CATransform3DPerspect(mat1, CGPointZero, 500);
        fromViewController.view.alpha = 1.0f;
        fromViewController.view.layer.transform=semiFinal;
        
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:1];
//        CABasicAnimation* anim=[CABasicAnimation animationWithKeyPath:@"transform"];
//        [anim setFromValue:[NSValue valueWithCATransform3D:semiFinal]];
//        [anim setToValue:[NSValue valueWithCATransform3D:final]];
//        anim.delegate=self;
//        [anim setValue:@"pagingAnimationNonTransitionClose" forKey:@"pagingAnimationNonTransitionClose"];
//        [fromViewController.view.layer addAnimation:anim forKey:nil];
//        fromViewController.view.layer.transform=final;
//        
//        fromViewController.view.alpha = 0.0f;
//        [CATransaction commit];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^
         {
             fromViewController.view.layer.transform=final;
             fromViewController.view.alpha=0.0f;
         } completion:^(BOOL finished)
         {
             if (finished)
                 [transitionContext completeTransition:YES];
             
             
         }];
        
        
    }
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    NSLog(@"this is animationEnded");
    
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.45;
}

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    self.transitionContext=transitionContext;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* viewContainer= [transitionContext containerView];
    if ([fromViewController isKindOfClass:[UINavigationController class]])
    {
        fromViewController=((UINavigationController*)fromViewController).topViewController;
        
    }
    if ([toViewController isKindOfClass:[UINavigationController class]])
    {
        toViewController=((UINavigationController*)toViewController).topViewController;
        
    }
    if ([toViewController isKindOfClass:[PageTableViewController class]]&&[fromViewController isKindOfClass:[DashBoardViewController class]])
    {
        [viewContainer insertSubview:toViewController.view aboveSubview:fromViewController.view];
        CATransform3D move = CATransform3DMakeTranslation(0, 0, 128);
        CATransform3D back = CATransform3DMakeTranslation(0, 0, -128);
        CATransform3D rotate0 = CATransform3DMakeRotation(0.4*M_PI, 0, 1, 0);
        CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
        CATransform3D semiFinal=CATransform3DPerspect(mat0, CGPointZero, 500);
        toViewController.view.layer.transform=semiFinal;
        toViewController.view.alpha=0.0f;
    }
}
#pragma mark - overwrtie UIPercentDrivenInteractiveTransition
- (void)updateInteractiveTransition:(CGFloat)percentComplete{
    
    if (percentComplete<0) {
        percentComplete=0;
    }else if (percentComplete>1){
        percentComplete=1;
    }
    if (self.transitionContext!=nil)
    {
        UIViewController* toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIViewController* fromViewController = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        CATransform3D move = CATransform3DMakeTranslation(0, 0, 128);
        CATransform3D back = CATransform3DMakeTranslation(0, 0, -128);
        
        
        if ([toViewController isKindOfClass:[PageTableViewController class]]&&[fromViewController isKindOfClass:[DashBoardViewController class]])//present
        {
            CATransform3D rotate0 = CATransform3DMakeRotation(0.4*M_PI*(1-percentComplete), 0, 1, 0);
            CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
            CATransform3D changingTransform=CATransform3DPerspect(mat0, CGPointZero, 500);
            _currentTransform=changingTransform;

            //NSLog(@"percent is %f",(1-percentComplete));
            toViewController.view.layer.transform=changingTransform;
            toViewController.view.alpha=percentComplete;
            
            
        }
        
        if ([fromViewController isKindOfClass:[PageTableViewController class]]&&[toViewController isKindOfClass:[DashBoardViewController class]] )//dismiss
        {
            CATransform3D rotate0 = CATransform3DMakeRotation(0.4*M_PI*percentComplete, 0, 1, 0);
            CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
            CATransform3D changingTransform=CATransform3DPerspect(mat0, CGPointZero, 500);
            _currentTransform=changingTransform;

            NSLog(@"percent is %f",percentComplete);
            fromViewController.view.layer.transform=changingTransform;
            fromViewController.view.alpha=1-percentComplete;
            //[self.transitionContext updateInteractiveTransition:percentComplete];
            //NSLog(@"changingTransform is %@",NSstringFrom)
            
            
        }
        [self.transitionContext updateInteractiveTransition:percentComplete];
    }
    
    
}

- (void)cancelInteractiveTransitionWithDuration:(CGFloat)duration
{
    
    UIViewController* toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CATransform3D move = CATransform3DMakeTranslation(0, 0, 128);
    CATransform3D back = CATransform3DMakeTranslation(0, 0, -128);
    CATransform3D rotate0 = CATransform3DMakeRotation(0.4*M_PI, 0, 1, 0);
    CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
    CATransform3D finalTransform=CATransform3DPerspect(mat0, CGPointZero, 500);
    
    CATransform3D rotate1 = CATransform3DMakeRotation(0, 0, 1, 0);
    CATransform3D mat1 = CATransform3DConcat(CATransform3DConcat(move, rotate1), back);
    CATransform3D initialTransform=CATransform3DPerspect(mat1, CGPointZero, 500);
    
    
    
    if ([toViewController isKindOfClass:[PageTableViewController class]]&&[fromViewController isKindOfClass:[DashBoardViewController class]])
    {
        [CATransaction begin];
        [CATransaction setAnimationDuration:duration];
        CABasicAnimation* anim=[CABasicAnimation animationWithKeyPath:@"transform"];
        //[anim setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [anim setFromValue:[NSValue valueWithCATransform3D:_currentTransform]];
        [anim setToValue:[NSValue valueWithCATransform3D:finalTransform]];
        anim.delegate=self;
        [anim setValue:@"pagingTransitionCancel0" forKey:@"pagingTransitionCancel0"];
        [toViewController.view.layer addAnimation:anim forKey:nil];
        toViewController.view.layer.transform=finalTransform;
        //toViewController.view.alpha = 0.0f;
        [CATransaction commit];
        
    }
    
    if ([fromViewController isKindOfClass:[PageTableViewController class]]&&[toViewController isKindOfClass:[DashBoardViewController class]] )
    {
        [CATransaction begin];
        [CATransaction setAnimationDuration:duration];
        CABasicAnimation* anim=[CABasicAnimation animationWithKeyPath:@"transform"];
        //
        [anim setFromValue:[NSValue valueWithCATransform3D:_currentTransform]];
        [anim setToValue:[NSValue valueWithCATransform3D:initialTransform]];
        anim.delegate=self;
        [anim setValue:@"pagingTransitionCancel1" forKey:@"pagingTransitionCancel1"];
        [fromViewController.view.layer addAnimation:anim forKey:nil];
        fromViewController.view.layer.transform=initialTransform;
        //fromViewController.view.alpha = 1.0f;
        [CATransaction commit];
        
        
    }
    
    
    [self cancelInteractiveTransition];
}

- (void)finishInteractiveTransitionWithDuration:(CGFloat)duration{
    
    UIViewController* toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CATransform3D move = CATransform3DMakeTranslation(0, 0, 128);
    CATransform3D back = CATransform3DMakeTranslation(0, 0, -128);
    
    CATransform3D rotate0 = CATransform3DMakeRotation(0.4*M_PI, 0, 1, 0);
    CATransform3D mat0 = CATransform3DConcat(CATransform3DConcat(move, rotate0), back);
    CATransform3D finalTransform=CATransform3DPerspect(mat0, CGPointZero, 500);
    
    CATransform3D rotate1 = CATransform3DMakeRotation(0, 0, 1, 0);
    CATransform3D mat1 = CATransform3DConcat(CATransform3DConcat(move, rotate1), back);
    CATransform3D initialTransform=CATransform3DPerspect(mat1, CGPointZero, 500);
    
    
    
    if ([toViewController isKindOfClass:[PageTableViewController class]]&&[fromViewController isKindOfClass:[DashBoardViewController class]])
    {
        [CATransaction begin];
        [CATransaction setAnimationDuration:duration];
        CABasicAnimation* anim=[CABasicAnimation animationWithKeyPath:@"transform"];
        //[anim setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [anim setFromValue:[NSValue valueWithCATransform3D:_currentTransform]];
        [anim setToValue:[NSValue valueWithCATransform3D:initialTransform]];
        anim.delegate=self;
        [anim setValue:@"pagingTransitionFinish0" forKey:@"pagingTransitionFinish0"];
        [toViewController.view.layer addAnimation:anim forKey:nil];
        toViewController.view.layer.transform=initialTransform;
        //toViewController.view.alpha = 1.0f;
        [CATransaction commit];
        
    }
    
    if ([fromViewController isKindOfClass:[PageTableViewController class]]&&[toViewController isKindOfClass:[DashBoardViewController class]] )
    {
        [CATransaction begin];
        [CATransaction setAnimationDuration:duration];
        CABasicAnimation* anim=[CABasicAnimation animationWithKeyPath:@"transform"];
        //[anim setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [anim setFromValue:[NSValue valueWithCATransform3D:_currentTransform]];
        [anim setToValue:[NSValue valueWithCATransform3D:finalTransform]];
        anim.delegate=self;
        [anim setValue:@"pagingTransitionFinish1" forKey:@"pagingTransitionFinish1"];
        [fromViewController.view.layer addAnimation:anim forKey:nil];
        fromViewController.view.layer.transform=finalTransform;
        //fromViewController.view.alpha = 0.0f;
        [CATransaction commit];
        
        
    }
    
    [self finishInteractiveTransition];
}


#pragma <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    UIViewController* toViewController = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if ([[animation valueForKey:@"pagingTransitionCancel0"] isEqualToString:@"pagingTransitionCancel0"])
        
    {
        
        
        if (flag)
        {
            NSLog(@"animation transition pagingTransitionCancel0 completed!");
            toViewController.view.alpha=1.0;
            //[self.transitionContext completeTransition:YES];
            //[self.transitionContext cancelInteractiveTransition];
            [self.transitionContext completeTransition:NO];
            self.transitionContext=nil;
            
        }
        
    }
        
        
        
        
    if ([[animation valueForKey:@"pagingTransitionCancel1"] isEqualToString:@"pagingTransitionCancel1"] )
    {
        if (flag)
        {
            NSLog(@"animation transition  pagingTransitionCancel1 completed!");
            fromViewController.view.alpha=1.0;
            //[self.transitionContext cancelInteractiveTransition];
            [self.transitionContext completeTransition:NO];
            self.transitionContext=nil;

                    }
    }

    if ([[animation valueForKey:@"pagingTransitionFinish0"] isEqualToString:@"pagingTransitionFinish0"] )
    {
        if (flag)
        {
            NSLog(@"animation transition pagingTransitionFinish0 completed!");
            toViewController.view.alpha=1.0;
            [self.transitionContext completeTransition:YES];
            self.transitionContext=nil;
            
        }
    }
    if ([[animation valueForKey:@"pagingTransitionFinish1"] isEqualToString:@"pagingTransitionFinish1"] )
    {
        if (flag)
        {
            NSLog(@"animation transition pagingTransitionFinish1 completed!");
            fromViewController.view.alpha=0.0;
            [self.transitionContext completeTransition:YES];
            self.transitionContext=nil;
            
            
        }
    }
    if ([[animation valueForKey:@"pagingAnimationNonTransitionClose"] isEqualToString:@"pagingAnimationNonTransitionClose"] )
    {
        if (flag)
        {
            NSLog(@"animation transition pagingAnimationNonTransitionClose completed!");
            fromViewController.view.alpha = 0.0f;
            [self.transitionContext completeTransition:YES];
            self.transitionContext=nil;
            
            
        }
    }
    if ([[animation valueForKey:@"pagingAnimationNonTransitionOpen"] isEqualToString:@"pagingAnimationNonTransitionOpen"] )
    {
        if (flag)
        {
            NSLog(@"animation transition pagingAnimationNonTransitionOpen completed!");
            toViewController.view.alpha=1.0f;
            [self.transitionContext completeTransition:YES];
            self.transitionContext=nil;
            
            
        }
    }

    
    
    
}
-(void)animationDidStart:(CAAnimation *)animation
{
    
    
}
@end
