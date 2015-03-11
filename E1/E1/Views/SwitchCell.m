//
//  SwitchCell.m
//  E1
//
//  Created by Jack Lin on 29/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "SwitchCell.h"
#import "Definations.h"

@implementation SwitchCell

- (void)awakeFromNib
{
    self.seriesSwitch.on=!isWhiteScheme;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

    // Configure the view for the selected state
}

- (IBAction)isSwitched:(id)sender
{
    
    isWhiteScheme=!self.seriesSwitch.isOn;
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(switchValueChaged:sender:)])
    {
        [self.delegate switchValueChaged:self.seriesSwitch.isOn sender:(id)sender];
        
    }
    
}
@end
