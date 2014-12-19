//
//  SliderCell.m
//  E1
//
//  Created by Jack Lin on 29/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "SliderCell.h"
@interface SliderCell()
@property(nonatomic,strong) NSString* previousYear;
@end
@implementation SliderCell

- (void)awakeFromNib {
    self.yearSlider.minimumValue=2001.0f;
    self.yearSlider.maximumValue=2014.0f;
    self.yearSlider.continuous=YES;
    self.yearSlider.value=2001.0f;
    self.year.text=@"2001";
    self.previousYear=@"";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)yearChanged:(id)sender
{
    if ([sender isEqual: self.yearSlider]) {
        self.year.text=[NSString stringWithFormat:@"%d",((int)self.yearSlider.value)];
    }
    if (![self.previousYear isEqualToString:self.year.text])
    {
        self.previousYear=self.year.text;
        if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(sliderValueChaged:)])
            
        {
            [self.delegate sliderValueChaged:self.year.text];
        }
    }
    
    
    
    
}
@end
