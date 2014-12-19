//
//  StartupViewController.m
//  E1
//
//  Created by Jack Lin on 2/12/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "StartupViewController.h"
#import "LoginViewController.h"

@interface StartupViewController ()

@end

@implementation StartupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadView
{
    [super loadView];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([StartupViewController class]) owner:self options:nil];
    self.view = [nibs objectAtIndex:0];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //CGPoint centerPoint=self.view.center;
    //self.imageView.center=centerPoint;
    [NSThread sleepForTimeInterval:3.0f];
    //centerPoint.y-=100;
    
    [UIView animateWithDuration:0.45 animations:^{
        
        self.imageView.transform=CGAffineTransformTranslate(self.imageView.transform, 0, kcQBELogoMovingDistance);
        //self.imageView.center=centerPoint;
    }];
    LoginViewController* logVC=[[LoginViewController alloc] init];
    logVC.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:logVC animated:YES completion:^{
        NSLog(@"this is presentation completion ");
        
    }];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskLandscapeLeft;
}

@end
