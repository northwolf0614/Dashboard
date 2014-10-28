//
//  DashBoardView.m
//  E1
//
//  Created by Jack Lin on 20/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DashBoardView.h"

@interface DashBoardView()<CLLocationManagerDelegate,MKMapViewDelegate>
//subviews：

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
    //[self.percentageView1 setPercent:percent animated:animated];
    
}

-(id)init
{
    self= [super init];
    if (self!=nil) {
        self.percentageView= [[GradientPercentView alloc] init];
        //self.percentageView1= [[GradientPercentView alloc] init];
        self.statisticsAnalyzerView=[[StatisticsAnalyzerView alloc] init];
        self.paragraphView= [[ParagraphView alloc] init];
        self.pieCharView = [[PieChartView alloc] init];
        self.mapView=[[MKMapView alloc] init];
        self.mapView.delegate=self;
        self.mapView.alpha=kcMapViewAlpha;
        //show the user's location
        self.mapView.showsUserLocation=YES;
        
        [self.percentageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.statisticsAnalyzerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.paragraphView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.pieCharView setTranslatesAutoresizingMaskIntoConstraints:NO];
        //map view is supposed to be added firstly
        
        [self addSubview:self.mapView];
        [self addSubview:self.percentageView];
        [self addSubview:self.statisticsAnalyzerView];
        [self addSubview:self.paragraphView];
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
    [UIView animateWithDuration:0.5 animations:
     ^{
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
       
        NSDictionary* viewDict    = @{      @"mapView":         self.mapView,
                                       @"pieChartView":      self.pieCharView,
                                       @"statisticsView":     self.statisticsAnalyzerView,
                                       @"paragraphView":      self.paragraphView,
                                       @"percentageView":     self.percentageView
                                            
                                    };
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=100-[mapView(==pieChartView)]-20-[pieChartView(300)]->=100-|" options:0 metrics:0 views:viewDict]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=100-[statisticsView(==paragraphView)]-20-[paragraphView(300)]->=100-|" options:0 metrics:0 views:viewDict]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=100-[percentageView(300)]->=100-|" options:0 metrics:0 views:viewDict]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=200-[mapView(==statisticsView)]-20-[statisticsView(300)]->=200-|" options:0 metrics:0 views:viewDict]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=200-[pieChartView(==paragraphView)]-20-[paragraphView(300)]->=200-|" options:0 metrics:0 views:viewDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=200-[mapView(==statisticsView)]-20-[statisticsView(300)]-20-[percentageView(300)]->=200-|" options:0 metrics:0 views:viewDict]];

        
        
        

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
-(void)updateAnalysis
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
