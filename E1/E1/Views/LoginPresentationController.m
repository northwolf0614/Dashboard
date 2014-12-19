//
//  LoginPresentationController.m
//  E1
//
//  Created by Jack Lin on 2/12/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "LoginPresentationController.h"
#import "StartupViewController.h"
#import "Definations.h"
@interface LoginPresentationController()
//@property(nonatomic,strong) UIViewController* presentingController;


@end

@implementation LoginPresentationController
-(id) initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    if(self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController])
    {
        
            //self.presentingController=presentingViewController;
        
        
        
        
    }
    return self;
}

- (void)presentationTransitionWillBegin
{
    NSLog(@"presentationTransitionWillBegin");
}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    NSLog(@"presentationTransitionDidEnd");
}

- (void)dismissalTransitionWillBegin
{
    NSLog(@"dismissalTransitionWillBegin");
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    NSLog(@"dismissalTransitionDidEnd");
    
}

- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect rect=CGRectZero;
    if ([self.presentingViewController isKindOfClass:[StartupViewController class]])
    {
        StartupViewController* sVC=(StartupViewController*)self.presentingViewController;
        rect=sVC.imageView.frame;
        
    }
    
    float y=rect.origin.y+rect.size.height+kcConstantSpace;
    CGPoint p=self.presentingViewController.view.center;
    float x=p.x-0.5*kcQBELoginBoxWidth;
    return CGRectMake(x, y, kcQBELoginBoxWidth , kcQBELoginBoxWidth);

}



- (void)containerViewDidLayoutSubviews

{
    NSLog(@"this is - (void)containerViewDidLayoutSubviews");
    CGRect rect=CGRectZero;
    if ([self.presentingViewController isKindOfClass:[StartupViewController class]])
    {
        StartupViewController* sVC=(StartupViewController*)self.presentingViewController;
        rect=sVC.imageView.frame;
        
    }
    
    float y=rect.origin.y+rect.size.height;
    CGPoint p=self.presentingViewController.view.center;
    float x=p.x-0.5*kcQBELoginBoxWidth;
    [UIView animateWithDuration:0.45 animations:^{
        self.presentedViewController.view.frame=CGRectMake(x, y, kcQBELoginBoxWidth , kcQBELoginBoxWidth);
    }];
    
    [super containerViewDidLayoutSubviews];
}
@end
