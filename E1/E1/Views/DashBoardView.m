//
//  DashBoardView.m
//  E1
//
//  Created by Jack Lin on 20/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DashBoardView.h"
#import <MapKit/MapKit.h>
#import "Definations.h"
#import "GradientPercentView.h"

@interface DashBoardView()<CLLocationManagerDelegate,MKMapViewDelegate>
//subviews：
@property(nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) GradientPercentView* percentageView;
//location related
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) NSNumber* distance;
//constraints related
@property (nonatomic,assign) BOOL didSetupConstraints;
//
-(void)setupLocationManager;

@end
@implementation DashBoardView
-(void)setPercent:(CGFloat)percent animated:(BOOL)animated
{
    [self.percentageView setPercent:percent animated:animated];
}

-(id)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self!=nil) {
        self.percentageView= [[GradientPercentView alloc] init];
        
        self.mapView=[[MKMapView alloc] init];
        self.mapView.delegate=self;
        self.mapView.alpha=0.25;
        //show the user's location
        self.mapView.showsUserLocation=YES;
        
        [self.percentageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        
        [self addSubview:self.mapView];
        [self addSubview:self.percentageView];
        self.didSetupConstraints=NO;
        [self setupLocationManager];
        
        
    }
    return self;

}

-(void)layoutSubviews
{
    
    //[super layoutSubviews];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [super layoutSubviews];
    
    
    
}

-(void)updateConstraints
{
    
    [super updateConstraints];
    if (self.didSetupConstraints) {
        return;
    }
    else
    {
        
            NSArray *tmpConstraints;

            NSDictionary* views    = @{ @"mapView"      :   self.mapView,
                                        @"percentageView1" :      self.percentageView,
                                        
                                        };
            tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mapView]-0-|" options:0 metrics:nil views:views];
            [self addConstraints:tmpConstraints];
            tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[percentageView1]-50-|" options:0 metrics:nil views:views];
            [self addConstraints:tmpConstraints];
            tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[mapView]-0-|" options:0 metrics:nil views:views];
            [self addConstraints:tmpConstraints];
            tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[percentageView1]-20-|" options:0 metrics:nil views:views];
            [self addConstraints:tmpConstraints];
            self.didSetupConstraints=YES;
            
            
            
        }
    
        
}

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





#pragma CLLocationManagerDelegate
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
