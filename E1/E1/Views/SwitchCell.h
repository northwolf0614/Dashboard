//
//  SwitchCell.h
//  E1
//
//  Created by Jack Lin on 29/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <UIKit/UIKit.h>
BOOL isWhiteScheme;
@protocol SwitchDelegate <NSObject>

-(void)switchValueChaged:(BOOL)isOn sender:(id)sender;

@end
@interface SwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *seriesName;
@property (weak, nonatomic) IBOutlet UISwitch *seriesSwitch;
- (IBAction)isSwitched:(id)sender;
@property(weak, nonatomic) id<SwitchDelegate> delegate;

@end
