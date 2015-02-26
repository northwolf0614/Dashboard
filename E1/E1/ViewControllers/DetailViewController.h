//
//  DetailViewController.h
//  E1
//
//  Created by Jack Lin on 23/02/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractNChartViewController.h"
#import "AbstractNChartView.h"
#import "DoubleNChartWithLabelViewController.h"
#import "SliderCell.h"

@interface DetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SliderDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UINavigationBarDelegate>


-(BOOL)shouldBeAddToPreviousPage;
-(id)initWithDrawingData:(NChartDataModel*)drawingData  isAddedChart:(BOOL)isAdded;
@property(strong,nonatomic) NChartDataModel* dataForNChart;
@property (weak, nonatomic) IBOutlet UIView *chartViewContainer;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end
