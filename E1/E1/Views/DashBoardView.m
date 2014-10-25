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
#import "StatisticsAnalyzerView.h"
#import "CorePlot-CocoaTouch.h"
#import "ParagraphView.h"
#import "PieChartView.h"



@interface DashBoardView()<CLLocationManagerDelegate,MKMapViewDelegate>
//subviews：
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) GradientPercentView* percentageView;
@property (nonatomic,strong) GradientPercentView* percentageView1;
@property (nonatomic,strong) StatisticsAnalyzerView* statisticsAnalyzerView;
@property(nonatomic,strong)  ParagraphView* paragraphView;
@property(nonatomic,strong)  PieChartView* pieCharView;


//locations related
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) CLLocation *currentLocation;
@property (nonatomic,strong) NSNumber* distance;
//constraints related
@property (nonatomic,assign) BOOL didSetupConstraints;

//plot related
@property(nonatomic,strong) CPTXYGraph * graph;


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
        self.statisticsAnalyzerView=[[StatisticsAnalyzerView alloc] init];
        self.paragraphView= [[ParagraphView alloc] init];
        self.pieCharView = [[PieChartView alloc] init];
        
        
        self.mapView=[[MKMapView alloc] init];
        self.mapView.delegate=self;
        self.mapView.alpha=kcMapViewAlpha;
        //show the user's location
        self.mapView.showsUserLocation=YES;
        
        [self.percentageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.percentageView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.statisticsAnalyzerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.paragraphView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.pieCharView setTranslatesAutoresizingMaskIntoConstraints:NO];
        //map view is supposed to be added firstly
        [self addSubview:self.mapView];
        //[self addSubview:self.percentageView];
        //[self addSubview:self.percentageView1];
        //[self addSubview:self.statisticsAnalyzerView];
        //[self addSubview:self.paragraphView];
        [self addSubview:self.pieCharView];
        
        
        self.didSetupConstraints=NO;
        [self setupLocationManager];
        
        
    }
    return self;

}

-(void)layoutSubviews
{
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.5 animations:^{
        
        [super layoutSubviews];
    }];
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
        
        NSDictionary* views    = @{
                                   @"mapView"      :      self.mapView,
                                   @"percentageView0" :      self.percentageView,
                                   @"percentageView1" :      self.percentageView1,
                                   @"statisticsView" :      self.statisticsAnalyzerView,
                                   //@"paragraphView" :      self.paragraphView,
                                   @"paragraphView" :      self.pieCharView,
                                   
                                            };
        /*
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mapView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];
        
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[paragraphView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];
        
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[statisticsView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];
        
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[percentageView0(==percentageView1)]-10-[percentageView1(50)]-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];
        
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[mapView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];
        
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[percentageView0(50)]-[statisticsView(100)]-[paragraphView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[percentageView1(==percentageView0)]-[statisticsView(100)]-[paragraphView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];
         */
        
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mapView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];
        
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[paragraphView]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:tmpConstraints];
        tmpConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[mapView(==paragraphView)]-0-[paragraphView]-0-|" options:0 metrics:nil views:views];
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
-(void)startAnalyzeStatistics
{
    [self.statisticsAnalyzerView startAnalyzeStatistics];
}
-(void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [self.statisticsAnalyzerView setNeedsDisplay];
}

-(CPTPlotRange *)CPTPlotRangeFromFloat:(float)location length:(float)length
{
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(location) length:CPTDecimalFromFloat(length)];
    
}
-(void)updateCorePlotViews
{
    [self.paragraphView updateCorePlotViews];
    [self.pieCharView  updateCorePlotViews];
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
