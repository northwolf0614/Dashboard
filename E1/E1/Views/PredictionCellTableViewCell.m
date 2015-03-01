//
//  PredictionCellTableViewCell.m
//  E1
//
//  Created by Jack Lin on 1/03/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import "PredictionCellTableViewCell.h"
#import "Definations.h"

@implementation PredictionCellTableViewCell

- (void)awakeFromNib {
    self.predictionSlide.continuous=YES;
    self.predictionValue.text=@"";

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)valueChanged:(id)sender {
    if ([sender isEqual: self.predictionSlide])
    {
        float val=self.predictionSlide.value;
        //val=round(val*100)/100;
        
        
        
        
        
        
        if ([self.predictionName.text isEqualToString:kcPredictionBaseName])
        {
            NSString* newString=[NSString stringWithFormat:@"%d",(unsigned int)val];
            self.predictionValue.text=newString;
            if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(baseSlideValueChanged:)])
            {
                [self.delegate baseSlideValueChanged:(unsigned int)val];
            }
        }
        else if ([self.predictionName.text isEqualToString:kcPredictionM1Name])
        {
            NSString* newString=[NSString stringWithFormat:@"%.2f",val];
            self.predictionValue.text=newString;
            if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(multiplier1SlideValueChanged:)])
            {
                [self.delegate multiplier1SlideValueChanged:val];
            }
        }
        else if ([self.predictionName.text isEqualToString:kcPredictionM2Name])
        {
            NSString* newString=[NSString stringWithFormat:@"%.2f",val];
            self.predictionValue.text=newString;
            if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(multiplier2SlideValueChanged:)])
            {
                [self.delegate multiplier2SlideValueChanged:val];
            }
        }
        
        
        
        
        
        
        
        
    }
   
    
    
}
@end
