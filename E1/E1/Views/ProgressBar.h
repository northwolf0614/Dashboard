#import <UIKit/UIKit.h>
#import "NChartDataModel.h"
#import "AbstractNChartView.h"
//#import "ProgressBar.h"

@interface ProgressBar : AbstractNChartView



@property (nonatomic, readonly, getter=isAnimating) BOOL animating;
@property(nonatomic,strong) CAShapeLayer* progressLayer;
@property(nonatomic,strong) CAShapeLayer* progressLayerPlus;
@property(nonatomic,strong) CALayer* animationLayer;
@property(nonatomic,assign) CGFloat finalPercentage;
@property(nonatomic,assign) BOOL isAnimating;
-(void)setTextForMiddleLabel:(NSNumber*) number animation:(BOOL)isAnimated animationTime:(float)duration;
//-(void)setTextForTopRightLabel:(NSString*) text;
//-(id)initWithFrame:(CGRect)frame strokeWidth:(CGFloat)strokeWidth color: (UIColor*) strokeColor;

-(void)deleteAnimatedProgress;
- (id)initWithFinalPercentage:(CGFloat)percentage color1:(UIColor*)color1 color2:(UIColor*)color2;
//-(void)setTextForMiddleLabel:(NSNumber*) number animation:(BOOL)isAnimated animationTime:(float)duration percentage:(NSNumber*)percent;
@end
