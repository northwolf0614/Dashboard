#import <NChart3D/NChart3D.h>
@class SingleChartView;
@protocol AbstractNChartViewDelegate <NSObject>
-(void) setupAxesTypeForView:(SingleChartView*) chartView;
-(void) setupSeriesForChartView:(SingleChartView*) chartView;
-(NSNumber*)mainChartFloatingNumber:(SingleChartView*) chartView;
-(float) mainChartFloatingNumberAnimationtime:(SingleChartView*) chartView;

@end



@interface SingleChartView : NChartView
@property(nonatomic,weak)   id<AbstractNChartViewDelegate>delegate;
-(void)showSeries:(BOOL)isAnimated;
-(void)setupDelegate:(id)delegate;
-(void)clean;
-(void)updateData;

@end
