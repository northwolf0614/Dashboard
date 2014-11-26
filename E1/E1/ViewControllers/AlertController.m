//
//  AlertController.m
//  E1
//
//  Created by Jack Lin on 26/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AlertController.h"

@interface AlertController ()

@end

@implementation AlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self findUIbutton:self.view];
}
-(void)findUIbutton:(UIView*)rootView
{
    if (rootView!=nil&&[[rootView subviews] count]>0)
    {
        NSArray* subViews=[rootView subviews];
        for (UIView* aSubiew in subViews)
        {
//            if ([aSubiew isKindOfClass:[UIButton class]]) {
//                NSLog(@"find UIbutton!");
//                break;
//            }
//            else
            NSLog(@"class: %@", NSStringFromClass([aSubiew class]));
            if ([aSubiew isKindOfClass:[UICollectionView class]])
            {
                NSLog(@"collection sec: %ld", [((UICollectionView*)aSubiew) numberOfSections]);
                NSLog(@"collection item: %ld", [((UICollectionView*)aSubiew) numberOfItemsInSection:0]);
                UICollectionView* cc = (UICollectionView*)aSubiew;
                UICollectionViewCell* cell = [cc cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                [self findUIbutton:cell];
                NSLog(@"collection finished collection");
            }
            if ([aSubiew isKindOfClass:[UITableView class]])
            {
                NSLog(@"table sec: %ld", [((UITableView*)aSubiew) numberOfSections]);
                NSLog(@"table item: %ld", [((UITableView*)aSubiew) numberOfRowsInSection:0]);
                UITableView* cc = (UITableView*)aSubiew;
                UITableViewCell* cell = [cc cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                [self findUIbutton:cell];
                NSLog(@"table finished collection");
            }

            [self findUIbutton:aSubiew];
                
        }
    }
}
//-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
//{
//    [super dismissViewControllerAnimated:flag completion:completion];
//    NSLog(@"This is dismiss function");
//}

//-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
//{
//    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
//    NSLog(@"This is present function");
//}
@end
