#import <UIKit/UIKit.h>
#import "NChartDataModel.h"
#import "AbstractNChartView.h"

@interface ProgressBar : AbstractNChartView



@property (nonatomic, readonly, getter=isAnimating) BOOL animating;
////-(void)enableRightTopLabel;
//-(void)enableMiddleLabel;
////-(void)disableRightTopLabel;
//-(void)disableMiddleLabel;
-(void)setTextForMiddleLabel:(NSNumber*) number animation:(BOOL)isAnimated animationTime:(float)duration;
//-(void)setTextForTopRightLabel:(NSString*) text;
//-(id)initWithFrame:(CGRect)frame strokeWidth:(CGFloat)strokeWidth color: (UIColor*) strokeColor;
-(void)setPercent:(CGFloat)percent animated:(BOOL)animated;
-(void)deleteAnimatedProgress;
- (id)initWithFinalPercentage:(CGFloat)percentage color1:(UIColor*)color1 color2:(UIColor*)color2;
//-(void)setTextForMiddleLabel:(NSNumber*) number animation:(BOOL)isAnimated animationTime:(float)duration percentage:(NSNumber*)percent;
@end
