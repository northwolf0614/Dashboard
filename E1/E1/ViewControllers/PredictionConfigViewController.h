//
//  PredictionConfigViewController.h
//  E1
//
//  Created by Jack Lin on 27/02/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PredictionViewDelegate <NSObject>

-(void)saveConfig:(UIViewController*)vc;
-(void)calculate:(UIViewController*)vc;
-(void)submitSuccessfully:(UIViewController*)vc;


@end
@interface PredictionConfigViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIButton *saveConfig;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UIButton *calculate;
@property(weak,nonatomic) id<PredictionViewDelegate> delegate;
- (IBAction)onSaveConfig:(id)sender;
- (IBAction)onCalculate:(id)sender;
- (IBAction)onSubmit:(id)sender;

- (IBAction)onConfig1Switched:(id)sender;
- (IBAction)onConfig2Switched:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *config1Switch;
@property (weak, nonatomic) IBOutlet UISwitch *config2Switch;


@end
