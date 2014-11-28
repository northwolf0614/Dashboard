//
//  DetailChartViewController.m
//  E1
//
//  Created by Jack Lin on 2/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DetailChartViewController.h"
#import "Definations.h"

@interface DetailChartViewController ()
//@property(nonatomic,assign) BOOL isShowMiddleLabel;
@property(nonatomic,strong) UIPopoverController* masterPopoverController;
@end

@implementation DetailChartViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
//    [self.chartViewContainer addSubview:self.contentView];
//    self.contentView.translatesAutoresizingMaskIntoConstraints=NO;
//    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:0 metrics:0 views:@{ @"contentView" : self.contentView }]];
//    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:0 metrics:0 views:@{ @"contentView" : self.contentView }]];
    [self setupConstraints];
    UIBarButtonItem* rightBarButtonItem=[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleRightButtonItem:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

    
}
-(void)handleRightButtonItem:(id) sender
{
    
    [self.navigationController.splitViewController dismissViewControllerAnimated:YES
completion:^{
    
}];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DetailChartViewController class]) owner:self options:nil];
    self.view = [nibs objectAtIndex:0];
    self.configurationViewContainer.hidden=YES;
    
    //self.view=self.contentView;
    
}
//-(void)viewDidLayoutSubviews
//{
//    [self.chartViewContainer addSubview:self.contentView];
//    self.contentView.translatesAutoresizingMaskIntoConstraints=NO;
//    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:0 metrics:0 views:@{ @"contentView" : self.contentView }]];
//    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:0 metrics:0 views:@{ @"contentView" : self.contentView }]];
//    
//    [super viewDidLayoutSubviews];
//    
//    
//}

-(void)setupConstraints
{
    [self.chartViewContainer addSubview:self.contentView];
    self.contentView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:0 metrics:0 views:@{ @"contentView" : self.contentView }]];
    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:0 metrics:0 views:@{ @"contentView" : self.contentView }]];
    [self.chartViewContainer setNeedsLayout];
    //[self.visualEfView setNeedsLayout];
    
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        
    }
    
    
    if (self.masterPopoverController != nil)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}


#pragma mark - <UISplitViewControllerDelegate>

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Settings", @"Settings");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    //popoverController.contentViewController is qual to master navigation controller
    if ([popoverController.contentViewController isKindOfClass:[UINavigationController
                                                                class]])
    {
        self.masterPopoverController = popoverController;
    }
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}



@end
