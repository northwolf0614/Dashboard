//
//  DashboardMapViewController.m
//  E1
//
//  Created by Lei Zhao on 29/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DashboardMapViewController.h"
#import <MapKit/MapKit.h>

@interface DashboardMapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (nonatomic, strong) MKMapView* mapView;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) NSNumber* distance;
@end

@implementation DashboardMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.titleItem setTitle:@"Map"];

    self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
    self.mapView.alpha = kcMapViewAlpha;
    self.mapView.showsUserLocation = YES;
    [self.contentView addSubview:self.mapView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mapView]-0-|" options:0 metrics:0 views:@{ @"mapView" : self.mapView }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[mapView]-0-|" options:0 metrics:0 views:@{ @"mapView" : self.mapView }]];
    [self setupLocationManager];

    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupLocationManager
{
    //initiate the location manager
    self.locationManager = [[CLLocationManager alloc] init];
    //set the ordinary accuracy to help to save power
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}
- (void)setupMapForLocatoion:(CLLocation*)newLocation
{
    self.distance = [NSNumber numberWithFloat:kDefaultDistance];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = newLocation.coordinate.latitude;
    coordinate.longitude = newLocation.coordinate.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, [self.distance doubleValue] * 2, [self.distance doubleValue] * 2);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
}

#pragma CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager
    didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*)oldLocation
{
    [self.locationManager stopUpdatingLocation];
    self.currentLocation = newLocation;
    [self setupMapForLocatoion:newLocation];
}
- (void)locationManager:(CLLocationManager*)manager
       didFailWithError:(NSError*)error
{
}
@end
