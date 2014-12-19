//
//  OutlinePresentationViewController.m
//  E1
//
//  Created by Jack Lin on 1/12/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "OutlinePresentationViewController.h"
#import "DashBoardViewController.h"
#import "PageTableViewController.h"
@interface OutlinePresentationViewController()
@end
@implementation OutlinePresentationViewController



-(id) initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    if(self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController])
    {
//        if ([presentedViewController isKindOfClass:[DashBoardViewController class]]&&[presentingViewController isKindOfClass:[PageTableViewController class]])
//        {
//            self.dashBoardPresenting=(DashBoardViewController*)presentingViewController;
//            self.pageTableViewPresented=(PageTableViewController*)presentedViewController;
//        }
        
        //self.presentationStyle=
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
    
    CGRect rectBounds=self.presentingViewController.view.bounds;
    float x=rectBounds.size.width-KcPopoverWidth;
    float y=rectBounds.origin.y;
    float width=KcPopoverWidth;
    float height=rectBounds.size.height;
    
    
    CGRect rect= CGRectMake(x, y, width, height);
    self.presentedViewController.view.frame=rect;
    return rect;
}



@end
