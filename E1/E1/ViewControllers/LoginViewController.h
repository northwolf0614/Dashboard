//
//  LoginViewController.h
//  E1
//
//  Created by Jack Lin on 2/12/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashBoardViewController.h"

@interface LoginViewController : UIViewController<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
- (IBAction)loginPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
