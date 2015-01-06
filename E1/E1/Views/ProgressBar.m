//
//  ProgressBar.m


#import "ProgressBar.h"
#import "Definations.h"
@interface ProgressBar()
//@property(nonatomic,assign) CGFloat percent;

//@property(nonatomic,strong) CAShapeLayer* backgroundLayer;
@property(nonatomic,strong) CABasicAnimation* animation;
@property(nonatomic,strong) CABasicAnimation* animation1;
@property(nonatomic,strong) UIColor* color1;
@property(nonatomic,strong) UIColor* color2;
@property(nonatomic,strong) NSNumber* FloatingNumber;
@property(nonatomic,strong) NSNumber* valuePerStep;
@property(nonatomic,strong) NSTimer* timer;
@property(nonatomic,strong) NSNumber* changingValue;
-(void)setPercent:(CGFloat)percent animated:(BOOL)animated;
@end

@implementation ProgressBar

-(void)dealloc
{
    NSLog(@"This is dealloc in ProgressBar");
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.animationLayer.frame =self.bounds;
    //setup the path
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    CGFloat radius= self.animationLayer.frame.size.width>self.animationLayer.frame.size.height? self.animationLayer.frame.size.height/2:self.animationLayer.frame.size.width/2;
    radius-=kcProgress_Line_Width/2;
    [circlePath addArcWithCenter:CGPointMake(CGRectGetMidX(self.animationLayer.bounds), CGRectGetMidY(self.animationLayer.bounds)) radius: radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    //set up path1
    UIBezierPath *circlePath1 = [UIBezierPath bezierPath];
    float endPoint=0.0f;
    if ((1.5*M_PI+self.finalPercentage*2*M_PI)>=2*M_PI)
    {
        endPoint=(1.5*M_PI+self.finalPercentage*2*M_PI)-2*M_PI;
        
        
    }
    else
        endPoint=1.5*M_PI+self.finalPercentage*2*M_PI;
    
    [circlePath1 addArcWithCenter:CGPointMake(CGRectGetMidX(self.animationLayer.bounds), CGRectGetMidY(self.animationLayer.bounds)) radius: radius startAngle:1.5*M_PI endAngle:endPoint clockwise:YES];
    
    //set up path2
    UIBezierPath *circlePath2 = [UIBezierPath bezierPath];
    [circlePath2 addArcWithCenter:CGPointMake(CGRectGetMidX(self.animationLayer.bounds), CGRectGetMidY(self.animationLayer.bounds)) radius: radius startAngle:endPoint  endAngle:1.5*M_PI clockwise:YES];

    //setup the background layer
//    self.backgroundLayer.frame=self.animationLayer.bounds;
//    self.backgroundLayer.path = circlePath.CGPath;
//    self.backgroundLayer.strokeColor = [[UIColor lightGrayColor] CGColor];
//    self.backgroundLayer.fillColor = [[UIColor clearColor] CGColor];
//    self.backgroundLayer.lineWidth = kcTrack_LineE_Width;
    //setup the progress layer
    self.progressLayer.frame=self.animationLayer.bounds;
    self.progressLayer.strokeColor = [self.color1 CGColor];
    self.progressLayer.fillColor = [[UIColor clearColor] CGColor];
    self.progressLayer.lineWidth=kcProgress_Line_Width;
    self.progressLayer.strokeEnd=0.f;//use this property to set up the default value
    self.progressLayer.path=circlePath1.CGPath;
//
    self.progressLayerPlus.frame=self.animationLayer.bounds;
    self.progressLayerPlus.strokeColor = [self.color2 CGColor];
    self.progressLayerPlus.fillColor = [[UIColor clearColor] CGColor];
    self.progressLayerPlus.lineWidth=kcProgress_Line_Width;
    self.progressLayerPlus.strokeEnd=0.f;//use this property to set up the default value
    self.progressLayerPlus.path=circlePath2.CGPath;
}
- (id)initWithFinalPercentage:(CGFloat)percentage color1:(UIColor*)color1 color2:(UIColor*)color2
{
    self= [super initWithFrame:CGRectZero];
    if (self) {
        
        //_percent=0;
        self.animationLayer= [CALayer layer];
        [self.layer addSublayer:self.animationLayer];
        
        //self.backgroundLayer = [CAShapeLayer layer];
        self.progressLayer = [CAShapeLayer layer];
        self.progressLayerPlus = [CAShapeLayer layer];
        //[self.animationLayer addSublayer:self.backgroundLayer];
        [self.animationLayer addSublayer:self.progressLayer];
        [self.animationLayer addSublayer:self.progressLayerPlus];
        self.animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];//this place the input parameter must be strokeEnd
        self.animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];//this place the input parameter must be strokeEnd
        self.color1=color1;
        self.color2=color2;
        self.finalPercentage=percentage;
        self.chart.background = [NChartSolidColorBrush solidColorBrushWithColor:kcWidgetBackColor];


    }
    return  self;
    
}

-(void)setPercent:(CGFloat)percent animated:(BOOL)animated
{
    //NSLog(@"current percent is %f",percent);

    if (animated)
    {
        
        CABasicAnimation *animation;
        animation = self.animation;//this place the input parameter must be strokeEnd
        [animation setFromValue:[NSNumber numberWithFloat:0.0f] ];
        //[animation setFromValue:0 ];
        [animation setToValue:[NSNumber numberWithFloat:1.0f]];
        [animation setDuration:kcAnimationTime/2];
        [animation setRemovedOnCompletion:NO];
        [animation setFillMode:kCAFillModeForwards];//must set up this property, otherwise this class does not work properly
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [animation setDelegate:self];
        [animation setValue:@"ProgressBarAnimation" forKey:@"animationBar"];
        // Add the animation to our layer
        [[self progressLayer] addAnimation:animation forKey:nil];
    }
    
    

}
-(void)deleteAnimatedProgress
{
    [CATransaction begin];
    [self.animationLayer removeAllAnimations];//delete the animations relevant to this layer
    [self.animationLayer removeFromSuperlayer];//delete the layer, then the layer will disappear
    [CATransaction commit];
}
-(void)setTextForMiddleLabel:(NSNumber*) number animation:(BOOL)isAnimated animationTime:(float)duration
{
    [self setPercent:self.finalPercentage  animated:YES];
    [super setTextForMiddleLabel:number animation:isAnimated animationTime:duration];

    
    
}
#pragma CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    if ([[animation valueForKey:@"animationBar"] isEqualToString:@"ProgressBarAnimation"]) {
        CABasicAnimation *animation1;
        animation1 = self.animation1;
        //[animation1 setFromValue:[NSNumber numberWithFloat:self.percent] ];
        [animation1 setFromValue:[NSNumber numberWithDouble:0.0f] ];
        [animation1 setToValue:[NSNumber numberWithDouble:1.0f]];
        [animation1 setDuration:kcAnimationTime/2];
        [animation1 setRemovedOnCompletion:NO];
        [animation1 setFillMode:kCAFillModeForwards];//must set up this property, otherwise this class does not work properly
        [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [animation1 setDelegate:self];
        //[animation1 setValue:[NSString stringWithFormat:@"%f", percent] forKey:@"animation1"];
        // Add the animation to our layer
        [[self progressLayerPlus] addAnimation:animation1 forKey:nil];
    }
    
    
    
}
-(void)animationDidStart:(CAAnimation *)animation
{
    //NSLog(@"this is animationID=%s starting",[[animation valueForKey:@"animationBar"] UTF8String]);
    
}

@end
