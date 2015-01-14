//
//  LoginViewController.m
//  E1
//
//  Created by Jack Lin on 2/12/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginPresentationController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
-(id)init
{
    if (self=[super init]) {
        self.transitioningDelegate=self;
        
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadView
{
    [super loadView];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LoginViewController class]) owner:self options:nil];
    self.view = [nibs objectAtIndex:0];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.userName becomeFirstResponder];
}
- (IBAction)loginPressed:(id)sender {
    {
        DashBoardViewController* dashVC=[[DashBoardViewController alloc] init];
        
        [self presentViewController:dashVC animated:YES completion:^{
            
        }];
        
    }
}
#pragma mark <UIViewControllerTransitioningDelegate>


- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source
{
    return [[LoginPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kcControllerTransitionTime;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //    //Get references to the view hierarchy
    //    UIView *containerView = [transitionContext containerView];
    //    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //
    //    //if ([fromViewController isKindOfClass:[DashboardTableViewController class]] && [toViewController isKindOfClass:[DetailChartViewController class]])
    //    if ([fromViewController isKindOfClass:[DashBoardViewController class]] && [toViewController isKindOfClass:[DetailChartViewController class]])
    //    {
    //        //Presenting DetailChartViewController from DashboardTableViewController
    //        DetailChartViewController* dvc = (DetailChartViewController*)toViewController;
    //        DashboardTableViewController* dashvc=(DashboardTableViewController*) fromViewController;
    //        //DashboardTableViewController* dashvc = [naviVC.viewControllers objectAtIndex:0 ];
    //
    //
    //        CGRect transitioningFrame = [dashvc.transitioningView convertRect:dashvc.transitioningView.bounds toView:dashvc.view];//get the dashvc.transitoningview positon referencing to the dashvc.view
    //
    //        //Destination view controller
    //        dvc.view.transform = CGAffineTransformMakeScale(
    //                                                        CGRectGetWidth(transitioningFrame) / CGRectGetWidth(containerView.bounds),
    //                                                        CGRectGetHeight(transitioningFrame) / CGRectGetHeight(containerView.bounds));
    //        dvc.view.frame = transitioningFrame;
    //        dvc.view.alpha = 0.0f;
    //
    //        //source view controller
    //        dashvc.transitioningView.alpha = 1.0f;
    //
    //        [containerView insertSubview:dvc.view aboveSubview:dashvc.view];
    //
    //        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
    //            //Destination view controller
    //            dvc.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    //            dvc.view.frame = containerView.bounds;
    //            dvc.view.alpha = 1.0f;
    //
    //            //source view controller
    //            dashvc.transitioningView.alpha = 0.0f;
    //        } completion:^(BOOL finished) {
    //            [transitionContext completeTransition:YES];
    //        }];
    //    }
    
}

@end
