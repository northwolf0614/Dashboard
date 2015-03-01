//
//  PredictionConfigViewController.m
//  E1
//
//  Created by Jack Lin on 27/02/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import "PredictionConfigViewController.h"

@interface PredictionConfigViewController ()
@property(nonatomic,strong) NSArray* switchArray;
@property(nonatomic,strong) NSTimer* timer;
@property(nonatomic,strong) NSNumber* changingValue;
@property(nonatomic,assign) float timeInterval;
@property(nonatomic,assign) float timeRange;
@property(nonatomic,assign) NSDictionary* statusDic;
@end

@implementation PredictionConfigViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.switchArray=[NSArray arrayWithObjects:self.config1Switch,self.config2Switch, nil];
    
    //_statusDic=[NSDictionary dictionaryWithObjects:self.switchArray forKeys:@[@"switch1",@"switch2"]];
    for (UISwitch* s in self.switchArray) {
        s.enabled=YES;
        s.on=NO;
    }
    self.progress.hidden=YES;
    self.changingValue=[NSNumber numberWithFloat:0];
    _timeInterval=0.05f;
    _timeRange=3.0f;
    self.calculate.enabled=YES;
    self.saveConfig.enabled=NO;
    self.submit.enabled=NO;
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
    self.submit.enabled=YES;
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
    for (UISwitch* s in self.switchArray) {
        if (s.enabled) {
            self.saveConfig.enabled=YES;
        }
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
    val+=0.05f;
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
        self.saveConfig.enabled=NO;
        if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(submitSuccessfully:)])
        {
            [self.delegate submitSuccessfully:self];
        }
        for (UISwitch* s in self.switchArray) {
            if (s.enabled&&s.on) {
                s.enabled=NO;
            }
        }
        
        
        
    }
    
    

    
}

- (IBAction)onConfig1Switched:(id)sender
{
    if (self.config1Switch.on) {
        [self setupOtherSwitchUsing:self.config1Switch];
    }
    
}

- (IBAction)onConfig2Switched:(id)sender
{
    if (self.config1Switch.on) {
        [self setupOtherSwitchUsing:self.config2Switch];
    }
}

-(void)setupOtherSwitchUsing:(UISwitch*)thisSwitch
{
    for (UISwitch* s in self.switchArray) {
        if (![s isEqual:thisSwitch]&&s.enabled) {
            s.on=NO;
        }
    }
    
    
    
    
}
@end
