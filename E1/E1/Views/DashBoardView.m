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
@property (nonatomic,strong) GradientPercentView* percentageView1;
//@property (nonatomic,strong) GradientPercentView* percentageView2;
//@property (nonatomic,strong) GradientPercentView* percentageView3;

//locations related
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) NSNumber* distance;
//constraints related
//@property (nonatomic,assign) BOOL didSetupConstraints;
//
-(void)setupLocationManager;

@end
@implementation DashBoardView
-(void)setPercent:(CGFloat)percent animated:(BOOL)animated
{
    [self.percentageView setPercent:percent animated:animated];
    [self.percentageView1 setPercent:percent animated:animated];
    
}

-(id)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if (self!=nil) {
        self.percentageView= [[GradientPercentView alloc] init];
        self.percentageView1= [[GradientPercentView alloc] init];
        //self.percentageView2= [[GradientPercentView alloc] init];
        //self.percentageView3= [[GradientPercentView alloc] init];
        
        
        self.mapView=[[MKMapView alloc] init];
        self.mapView.delegate=self;
        self.mapView.alpha=kcMapViewAlpha;
        //show the user's location
        self.mapView.showsUserLocation=YES;
        
        [self.percentageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.percentageView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        
        //map view is supposed to be added firstly
        [self addSubview:self.mapView];
        [self addSubview:self.percentageView];
        [self addSubview:self.percentageView1];
        
        //self.didSetupConstraints=NO;
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
    //if (self.didSetupConstraints) {
    //    return;
    //}
    //else
    {
        
        NSArray *tmpConstraints;
        
        NSDictionary* views    = @{
                                   @"mapView"      :      self.mapView,
                                   @"percentageView0" :      self.percentageView,
                                   @"percentageView1" :      self.percentageView1,
                                   //@"percentageView2" :      self.percentageView2,
                                   //@"percentageView3" :      self.percentageView3,
                                   
                                            };
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mapView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];
        
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[percentageView0(==percentageView1)]-10-[percentageView1]-10-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];
        
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[mapView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];
        
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[percentageView0]-20-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[percentageView1]-20-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];

        //tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[percentageView2]-20-|" options:0 metrics:nil views:views];
        //[self addConstraints:tmpConstraints];

        //tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[percentageView3]-20-|" options:0 metrics:nil views:views];
        //[self addConstraints:tmpConstraints];

        //self.didSetupConstraints=YES;
        
        
            
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
