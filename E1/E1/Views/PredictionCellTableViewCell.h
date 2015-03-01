//
//  PredictionCellTableViewCell.h
//  E1
//
//  Created by Jack Lin on 1/03/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PredictionCellTableViewCellDelegate <NSObject>

-(void)baseSlideValueChanged:(unsigned int)newValue;
-(void)multiplier1SlideValueChanged:(float)newValue;
-(void)multiplier2SlideValueChanged:(float)newValue;

@end
@interface PredictionCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *predictionName;

@property (weak, nonatomic) IBOutlet UILabel *predictionValue;
@property (weak, nonatomic) id<PredictionCellTableViewCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UISlider *predictionSlide;
- (IBAction)valueChanged:(id)sender;


@end
