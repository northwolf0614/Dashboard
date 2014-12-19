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
#pragma mark <UIViewControllerTransitioningDelegate>


- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source
{
    return [[LoginPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

- (IBAction)loginPressed:(id)sender {
    {
        DashBoardViewController* dashVC=[[DashBoardViewController alloc] init];
        
        [self presentViewController:dashVC animated:YES completion:^{
            
        }];
        
    }
}
@end
