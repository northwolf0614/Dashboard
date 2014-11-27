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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.titleItem.rightBarButtonItem setTarget:self];
    [self.titleItem.rightBarButtonItem setAction:@selector(handleRightButtonItem:)];
    
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
}

@end
