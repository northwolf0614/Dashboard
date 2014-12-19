//
//  DashboardItemViewController.h
//  E1
//
//  Created by Lei Zhao on 29/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UINavigationBar *naviBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;
-(void)handleRightButtonItem:(id) sender;

@end

//@protocol ImageDownloadOperationDelegate <NSObject>

//- (void)operation:(ImageDownloadOperation *)operation didFinishWithData:(NSData *)aData;

//@end

