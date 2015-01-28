#import <UIKit/UIKit.h>
#import "NChartDataModel.h"
#import "ChartView.h"
typedef enum : NSUInteger {
    Bar,
    Circle,
} ProgressType;
@class Progress;

@protocol ProgressBarDataSource <NSObject>

-(UIColor*)colorForfirstBar:(Progress*) progressView;
-(UIColor*)colorForSecondBar:(Progress*) progressView;
-(NSNumber*)finalPercentage:(Progress*) progressView;

-(NSNumber*)plusChartFloatingNumber:(Progress*) progressView;
-(CGFloat)animationTime:(Progress*) progressView;
-(ProgressType)progressType:(Progress*)progressView;

@end


//@interface ProgressBar : AbstractNChartView
@interface Progress : UIView

@property(nonatomic,assign) BOOL isAnimating;
@property(nonatomic,weak) id<ProgressBarDataSource>delegate;

-(void)showSeries:(BOOL)isAnimated;
-(void)updateData;
-(void)clean;

@end
