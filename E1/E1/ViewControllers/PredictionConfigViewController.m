//
//  PredictionConfigViewController.m
//  E1
//
//  Created by Jack Lin on 27/02/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import "PredictionConfigViewController.h"
#import "NChartDataModel.h"
#import "MeetingCoordinator.h"

@interface PredictionConfigViewController ()

@property(nonatomic,strong) NSTimer* timer;
@property(nonatomic,strong) NSNumber* changingValue;
@property(nonatomic,assign) float timeInterval;
@property(nonatomic,assign) float timeRange;
@property(nonatomic,assign) NSDictionary* statusDic;
@property(nonatomic,strong) NSSet* predictionData;
@end

@implementation PredictionConfigViewController
-(void)updateAppearanceUsing:(NSSet*) predictionData
{
    
    for (UISwitch* s in self.switchArray)
    {
        if (self.isAdd)
        {
            s.enabled=YES;
            s.on=NO;
        }
        else
        {
            s.enabled=NO;
            s.on=NO;
        }
    }
    
    for (ChartPrediction* cp in predictionData)
    {
        for(UISwitch* s in self.switchArray)
            if (s.tag==[cp.key integerValue])
            {
                s.enabled=YES;

            }

        
        
        
    
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateAppearanceUsing:self.predictionData];
}
-(id)initWithIndication:(BOOL)isAddNotification data:(NSSet*)predictionData
{
    if (self=[super init]) {
        self.isAdd=isAddNotification;
        if (!isAddNotification) {
            self.submit.enabled=NO;
            self.saveConfig.enabled=NO;
            
        }
        self.predictionData=predictionData;
    }
    
    
    return self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.switchArray=[NSArray arrayWithObjects:self.config1Switch,self.config2Switch, nil];
    
    self.progress.hidden=YES;
    self.calculate.enabled=YES;
    self.saveConfig.enabled=self.isAdd;
    //self.submit.enabled=NO;
    
    
    self.changingValue=[NSNumber numberWithFloat:0];
    _timeInterval=0.05f;
    _timeRange=3.0f;
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)loadView
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PredictionConfigViewController class]) owner:self options:nil];
    self.view = [nibs objectAtIndex:0];
    self.view.translatesAutoresizingMaskIntoConstraints=NO;

}


- (IBAction)onSaveConfig:(id)sender
{
    //self.submit.enabled=YES;
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(saveConfig:)])
    {
        [self.delegate saveConfig:self];
    }
    

    
}

- (IBAction)onCalculate:(id)sender
{
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(calculate:)])
    {
        [self.delegate calculate:self];
    }

    
    
}
- (IBAction)onSubmit:(id)sender
{
    
    self.progress.hidden=NO;
    self.submit.enabled=NO;
    [self.timer setFireDate:[NSDate distantPast]];
    
    
}

-(void)onTimer:(NSTimer *)timer
{
    float val=[self.changingValue floatValue];
    float step=0.05f;
    val+=step;
    self.changingValue= [NSNumber numberWithFloat:val];
    if ([self.changingValue floatValue]<=_timeRange)
    {
        self.progress.progress=[self.changingValue floatValue];
    }
    else
    {
//        [self.timer invalidate];
//        self.timer=nil;
        [self.timer setFireDate:[NSDate distantFuture]];
        self.changingValue=[NSNumber numberWithFloat:0.0f];

        
        self.progress.hidden=YES;
        self.progress.progress=0.0f;
        self.submit.enabled=YES;
        self.calculate.enabled=YES;
        
//        self.saveConfig.enabled=NO;
        
        
        
        
//        if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(submitSuccessfully:)])
//        {
//            [self.delegate submitSuccessfully:self];
//        }
        for (UISwitch* s in self.switchArray) {
            if (s.enabled&&s.on)
            {
                if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(submitSuccessfully:)])
                {
                    [self.delegate submitSuccessfully:self];
                }
                s.enabled=NO;
            }
        }
        if (self.isAdd)
        {
            for (UISwitch* s in self.switchArray)
            {
                if (!s.enabled)
                    continue;
                else
                {
                    self.saveConfig.enabled=YES;
                    return;
                }
            }
            self.saveConfig.enabled=NO;
        }
        

        
        
        
    }
    
    

    
}
-(NSArray*)findConfigUsingTag:(NSInteger)tag set:(NSSet*)data
{
    for (NSObject* o in data) {
        NSInteger index=[((ChartPrediction*)o).key integerValue];
        if ([o isKindOfClass:[ChartPrediction class]]&&index==tag) {
            return [NSArray arrayWithObjects:((ChartPrediction*)o).base,((ChartPrediction*)o).mult1,((ChartPrediction*)o).mult2, nil];
        }
    }
    return nil;
    
}
- (IBAction)onConfig1Switched:(id)sender
{
    if ([self.config1Switch isEqual:sender])
    {
        if (((UISwitch*)sender).on)
        {
            [self setupOtherSwitchUsing:self.config1Switch];
            if (!self.isAdd) {
                if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(switch2On:config:)]) {
                    NSArray* data=[self findConfigUsingTag:0 set:self.predictionData];
                    [self.delegate switch2On:self config:data];
                }
            }
            
        }
        else
            if (!self.isAdd) {
                if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(switch2On:config:)]) {
                    
                    [self.delegate switch2On:self config:nil];
                }
            }
        
    }
    

    
}

- (IBAction)onConfig2Switched:(id)sender
{
    if ([self.config2Switch isEqual:sender])
    {
        if (((UISwitch*)sender).on)
        {
            [self setupOtherSwitchUsing:self.config2Switch];
            if (!self.isAdd) {
                if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(switch2On:config:)]) {
                    NSArray* data=[self findConfigUsingTag:1 set:self.predictionData];
                    [self.delegate switch2On:self config:data];
                }
            }
            
        }
        else
        {
            if (!self.isAdd) {
                if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(switch2On:config:)]) {
                    
                    [self.delegate switch2On:self config:nil];
                }
            }
            
        }
    }
    

}

-(void)setupOtherSwitchUsing:(UISwitch*)thisSwitch//if other one is enabled, make it off
{
    for (UISwitch* s in self.switchArray) {
        if (![s isEqual:thisSwitch]&&s.enabled) {
            s.on=NO;
            
        }
    }
    
    
    
    
}

@end
