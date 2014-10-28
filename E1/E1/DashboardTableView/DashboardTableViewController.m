//
//  DashboardTableViewController.m
//  E1
//
//  Created by Lei Zhao on 28/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DashboardTableViewController.h"
#import "DashboardTwinCell.h"
#import <MapKit/MapKit.h>
#import "GradientPercentView.h"
#import "StatisticsAnalyzerView.h"
#import "CorePlot-CocoaTouch.h"
#import "ParagraphView.h"
#import "PieChartView.h"

@interface DashboardTableViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) GradientPercentView* percentageView;
@property (nonatomic,strong) StatisticsAnalyzerView* statisticsAnalyzerView;
@property(nonatomic,strong)  ParagraphView* paragraphView;
@property(nonatomic,strong)  PieChartView* pieCharView;

@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) NSNumber* distance;
@end

@implementation DashboardTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //mapview
    self.mapView=[[MKMapView alloc] init];
    self.mapView.delegate=self;
    self.mapView.alpha=kcMapViewAlpha;    
    self.mapView.showsUserLocation=YES;
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setupLocationManager];
    
    self.percentageView= [[GradientPercentView alloc] init];
    self.statisticsAnalyzerView=[[StatisticsAnalyzerView alloc] init];
    self.paragraphView= [[ParagraphView alloc] init];
    self.pieCharView = [[PieChartView alloc] init];
    
    [self.percentageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.statisticsAnalyzerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.paragraphView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.pieCharView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellClassName = NSStringFromClass([DashboardTwinCell class]);
    DashboardTwinCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:cellClassName bundle:nil] forCellReuseIdentifier:cellClassName];
        cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    }
    
    [[cell.leftView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[cell.rightView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    switch (indexPath.row) {
        case 0:
            [cell.leftView addSubview:self.mapView];
            [cell.rightView addSubview:self.percentageView];
            [self.percentageView setPercent:0.9 animated:YES];
            break;
        case 1:
            [cell.leftView addSubview:self.statisticsAnalyzerView];
            [cell.rightView addSubview:self.paragraphView];
            [self.paragraphView updateCorePlotViews];
            break;
        case 2:
            [cell.leftView addSubview:self.pieCharView];
            [self.pieCharView  updateCorePlotViews];
            break;
        default:
            break;
    }
    
    if (cell.leftView.subviews.count > 0) {
        [cell.leftView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subview]-0-|" options:0 metrics:0 views:@{@"subview":cell.leftView.subviews[0]}]];
        [cell.leftView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[subview]-0-|" options:0 metrics:0 views:@{@"subview":cell.leftView.subviews[0]}]];
    }
    if (cell.rightView.subviews.count > 0) {
        [cell.rightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[subview]-0-|" options:0 metrics:0 views:@{@"subview":cell.rightView.subviews[0]}]];
        [cell.rightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[subview]-0-|" options:0 metrics:0 views:@{@"subview":cell.rightView.subviews[0]}]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)updateAnalysis
{
    [self.statisticsAnalyzerView startAnalyzeStatistics];
}
//-(void)setNeedsDisplay
//{
//    [super setNeedsDisplay];
//    [self.statisticsAnalyzerView setNeedsDisplay];
//}

-(CPTPlotRange *)CPTPlotRangeFromFloat:(float)location length:(float)length
{
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(location) length:CPTDecimalFromFloat(length)];
    
}
-(void)updateCorePlotViews
{
    [self.paragraphView updateCorePlotViews];
    [self.pieCharView  updateCorePlotViews];
}

#pragma mark - Map
-(void)setupLocationManager
{
    //initiate the location manager
    self.locationManager = [[CLLocationManager alloc]init] ;
    //set the ordinary accuracy to help to save power
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
}
- (void)setupMapForLocatoion:(CLLocation *)newLocation
{
    self.distance=[NSNumber numberWithFloat:kDefaultDistance];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = newLocation.coordinate.latitude;
    coordinate.longitude = newLocation.coordinate.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, [self.distance doubleValue]*2,[self.distance doubleValue]*2);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    self.currentLocation=newLocation;
    [self setupMapForLocatoion:newLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
    
}

@end
