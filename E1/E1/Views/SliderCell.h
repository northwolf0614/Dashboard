//
//  SliderCell.h
//  E1
//
//  Created by Jack Lin on 29/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SliderDelegate <NSObject>

-(void)sliderValueChaged:(NSString*)newValue;

@end
@interface SliderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UISlider *yearSlider;
@property (weak, nonatomic) id<SliderDelegate> delegate;
- (IBAction)yearChanged:(id)sender;


@end
