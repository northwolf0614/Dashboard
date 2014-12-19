//
//  DashboardItemViewController.m
//  E1
//
//  Created by Lei Zhao on 29/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DashboardItemViewController.h"
#import "Definations.h"


@interface DashboardItemViewController ()

@end

@implementation DashboardItemViewController
-(id)init
{
    if (self=[super init]) {
        NSLog(@"This is init in DashboardItemViewController");
        
    }
    return self;
    
}
-(void)dealloc
{
    NSLog(@"This is dealloc in DashboardItemViewController");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.naviBar setBarTintColor: kcNavigationBarColor];
    [self.naviBar setTranslucent: NO];
    [[UINavigationBar appearance]  setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]  setShadowImage:[[UIImage alloc] init]];
    
    self.naviBar.titleTextAttributes=@{UITextAttributeTextColor:kcCharColor};
    
        
    
}
-(void)handleRightButtonItem:(id) sender
{
    NSLog(@"this is super clicked!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DashboardItemViewController class]) owner:self options:nil];
    self.view = [nibs objectAtIndex:0];
    
    //self.view.layer.borderWidth=isWhiteScheme? 0:1;
    //self.view.layer.borderColor=isWhiteScheme?nil:[[UIColor lightGrayColor] CGColor];
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOpacity = 0.1;
    self.view.layer.shadowOffset = CGSizeMake(0, 3);

}

@end
