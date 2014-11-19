//
//  ProgressBar.m


#import "ProgressBar.h"
#import "Definations.h"
@interface ProgressBar()
//@property(nonatomic,assign) CGFloat percent;
@property(nonatomic,strong) CAShapeLayer* progressLayer;
@property(nonatomic,strong) CAShapeLayer* progressLayerPlus;
@property(nonatomic,strong) CALayer* animationLayer;
@property(nonatomic,strong) CAShapeLayer* backgroundLayer;
@property(nonatomic,strong) CABasicAnimation* animation;
@property(nonatomic,strong) CABasicAnimation* animation1;
@property(nonatomic,strong) UIColor* color1;
@property(nonatomic,strong) UIColor* color2;
@property(nonatomic,assign) CGFloat finalPercentage;


@property(nonatomic,strong) UILabel* middleLabel;
@property(nonatomic,strong) NSNumber* FloatingNumber;
@property(nonatomic,strong) NSNumber* valuePerStep;
@property(nonatomic,strong) NSTimer* timer;
@property(nonatomic,strong) NSNumber* changingValue;
@end

@implementation ProgressBar

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
    self.backgroundLayer.frame=self.animationLayer.bounds;
    self.backgroundLayer.path = circlePath.CGPath;
    self.backgroundLayer.strokeColor = [[UIColor lightGrayColor] CGColor];
    self.backgroundLayer.fillColor = [[UIColor clearColor] CGColor];
    self.backgroundLayer.lineWidth = kcTrack_LineE_Width;
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
    
    CGFloat width=self.frame.size.width;
    CGFloat height=self.frame.size.height;
    CGFloat labelWidth= self.middleLabel.frame.size.width;
    CGFloat labelHeight=self.middleLabel.frame.size.height;
    CGFloat value= width>height? height:width;
    self.middleLabel.frame=CGRectMake(0.5*(width-labelWidth), 0.5*(height-labelHeight), 0.5*value, 0.5*value);
    //self.middleLabel.center=self.center;
    
    
    
    
        //self.didUpdateStraints=NO;
    
//    self.chart.legend.textColor=kcCharColor;
//    self.chart.cartesianSystem.xAxis.textColor=kcCharColor;


}
- (id)initWithFinalPercentage:(CGFloat)percentage color1:(UIColor*)color1 color2:(UIColor*)color2
{
    self= [super init];
    if (self) {
        //_percent=0;
        self.animationLayer= [CALayer layer];
        [self.layer addSublayer:self.animationLayer];
        
        self.backgroundLayer = [CAShapeLayer layer];
        self.progressLayer = [CAShapeLayer layer];
        self.progressLayerPlus = [CAShapeLayer layer];
        [self.animationLayer addSublayer:self.backgroundLayer];
        [self.animationLayer addSublayer:self.progressLayer];
        [self.animationLayer addSublayer:self.progressLayerPlus];
        self.animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];//this place the input parameter must be strokeEnd
        self.animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];//this place the input parameter must be strokeEnd
        self.color1=color1;
        self.color2=color2;
        self.finalPercentage=percentage;
        
        self.middleLabel=[[UILabel alloc] init];
        self.middleLabel.backgroundColor=[UIColor clearColor];
        self.middleLabel.hidden=YES;
        self.middleLabel.textColor=kcLikeRed;
        self.middleLabel.font=[UIFont fontWithName:@"Arial" size:80];
        self.middleLabel.adjustsFontSizeToFitWidth = YES;
        self.middleLabel.userInteractionEnabled = NO;
        self.middleLabel.numberOfLines = 1;
        self.middleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.middleLabel.hidden=YES;
        [self addSubview:self.middleLabel];
        self.chart.background = [NChartSolidColorBrush solidColorBrushWithColor:kcWidgetBackColor];


    }
    return  self;
    
}

-(void)setPercent:(CGFloat)percent animated:(BOOL)animated
{
    NSLog(@"current percent is %f",percent);

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
        [animation setValue:@"0" forKey:@"animation"];
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



-(void)enableMiddleLabel
{
    self.middleLabel.hidden=NO;
}
-(void)disableMiddleLabel
{
    self.middleLabel.hidden=YES;
}

-(void)setTextForMiddleLabel:(NSNumber*) number animation:(BOOL)isAnimated animationTime:(float)duration
{
    [self setPercent:self.finalPercentage  animated:YES];
    [super setTextForMiddleLabel:number animation:isAnimated animationTime:duration];

    
    
}
-(void)onTimer:(NSTimer *)timer
{
    float val=[self.changingValue floatValue];
    val+=[self.valuePerStep floatValue];
    self.changingValue= [NSNumber numberWithFloat:val];
    if ([self.changingValue floatValue]<=[self.FloatingNumber floatValue])
    {
        if ([self.changingValue floatValue]>=1)
            self.middleLabel.text=[NSString stringWithFormat:@"%d",(int)[self.changingValue floatValue]] ;
        if ([self.changingValue floatValue]>0&&[self.changingValue floatValue]<1)
            self.middleLabel.text=[NSString stringWithFormat:@"0.%d",(int)([self.changingValue floatValue]*100)];
    }
    else
        [self.timer setFireDate:[NSDate distantFuture]];
    
    
}

#pragma CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    if ([[animation valueForKey:@"animation"] isEqualToString:@"0"]) {
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
    NSLog(@"this is animationID=%s starting",[[animation valueForKey:@"animation"] UTF8String]);
    
}
@end
