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
@property(nonatomic,strong) NSArray* layoutForSmallPadding;
@property(nonatomic,strong) NSArray* layoutForLargePadding;

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
    if (self!=nil)
    {
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
    NSDictionary* viewDict    = @{      @"mapView":         self.mapView,
                                        
                                        @"pieChartView":      self.pieCharView,
                                        
                                        @"statisticsView":     self.statisticsAnalyzerView,
                                        
                                        @"paragraphView":      self.paragraphView,
                                        
                                        @"percentageView":     self.percentageView
                                        
                                        
                                        
                                        };
    
    NSDictionary* metrics    = @{      @"smallPadding": @56,
                                       
                                       @"largerPadding":      @141,
                                       
                                       @"size":@400,
                                       
                                       @"standardPadding":@10
                                       
                                       };
    NSArray* constraintsForLargePaddingH1=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-largerPadding-[mapView(==pieChartView)]-largerPadding-[pieChartView(size)]-largerPadding-|" options:0 metrics:metrics views:viewDict];
    NSArray* constraintsForLargePaddingH2=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-largerPadding-[statisticsView(==paragraphView)]-largerPadding-[paragraphView(size)]-largerPadding-|" options:0 metrics:metrics views:viewDict];
    NSArray* constraintsForLargePaddingH3=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-largerPadding-[percentageView(size)]->=standardPadding-|" options:0 metrics:metrics views:viewDict];
    NSArray* constraintsForLargePaddingV1=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-largerPadding-[pieChartView(==paragraphView)]-largerPadding-[paragraphView(size)]->=standardPadding-|" options:0 metrics:metrics views:viewDict];
    NSArray* constraintsForLargePaddingV2=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-largerPadding-[mapView(size)]-largerPadding-[statisticsView(size)]-largerPadding-[percentageView(size)]->=standardPadding-|" options:0 metrics:metrics views:viewDict];
    
    NSArray* constraintsForSmallPaddingH1=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-smallPadding-[mapView(==pieChartView)]-smallPadding-[pieChartView(size)]-smallPadding-|" options:0 metrics:metrics views:viewDict];
    NSArray* constraintsForSmallPaddingH2=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-smallPadding-[statisticsView(==paragraphView)]-smallPadding-[paragraphView(size)]-smallPadding-|" options:0 metrics:metrics views:viewDict];
    NSArray* constraintsForSmallPaddingH3=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-smallPadding-[percentageView(size)]->=standardPadding-|" options:0 metrics:metrics views:viewDict];
    NSArray* constraintsForSmallPaddingV1=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-smallPadding-[pieChartView(==paragraphView)]-smallPadding-[paragraphView(size)]->=standardPadding-|" options:0 metrics:metrics views:viewDict];
    NSArray* constraintsForSmallPaddingV2=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-smallPadding-[mapView(size)]-smallPadding-[statisticsView(size)]-smallPadding-[percentageView(size)]->=standardPadding-|" options:0 metrics:metrics views:viewDict];
    
    NSArray* currentConstraints= [self constraints];
    

    
    
    
    
    //if (self.didSetupConstraints)
    //    return;
    
    //else
    {
       
        
        
        
        
        
        
            
            
        
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-largerPadding-[mapView(==pieChartView)]-largerPadding-[pieChartView(size)]-largerPadding-|" options:0 metrics:metrics views:viewDict]];
            
            
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-largerPadding-[statisticsView(==paragraphView)]-largerPadding-[paragraphView(size)]-largerPadding-|" options:0 metrics:metrics views:viewDict]];
            
            
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-largerPadding-[percentageView(size)]->=standardPadding-|" options:0 metrics:metrics views:viewDict]];
            
            
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-largerPadding-[pieChartView(==paragraphView)]-largerPadding-[paragraphView(size)]->=standardPadding-|" options:0 metrics:metrics views:viewDict]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-largerPadding-[mapView(size)]-largerPadding-[statisticsView(size)]-largerPadding-[percentageView(size)]->=standardPadding-|" options:0 metrics:metrics views:viewDict]];
            

        
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
