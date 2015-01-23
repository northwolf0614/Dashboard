//
//  ProgressBar.m


#import "Progress.h"
#import "Definations.h"
@interface Progress()
@property(nonatomic,strong) CAShapeLayer* maskLayer;
@property(nonatomic,strong) CAShapeLayer* progressLayer;
@property(nonatomic,strong) CAShapeLayer* progressLayerPlus;
@property(nonatomic,strong) CALayer* animationLayer;
@property(nonatomic,strong) UILabel* middleLabel;


@property(nonatomic,strong) NSNumber* floatingNumber;
@property(nonatomic,strong) NSNumber* valuePerStep;
@property(nonatomic,strong) NSTimer* timer;
@property(nonatomic,strong) NSNumber* changingValue;
@property(nonatomic,assign) float animationDurationTime;
@property(nonatomic,assign) ProgressType progressType;

@property(nonatomic,assign) CGFloat finalPercentage;
@property(nonatomic,strong) UIColor* color1;
@property(nonatomic,strong) UIColor* color2;




-(void)setPercent:(CGFloat)percent animated:(BOOL)animated;

-(void)deleteAnimatedProgress;


@end

@implementation Progress

-(void)dealloc
{
    NSLog(@"This is dealloc in ProgressBar");
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    //[self updateData];
    self.animationLayer.frame =self.bounds;

    
    CGFloat radius= self.animationLayer.frame.size.width>self.animationLayer.frame.size.height? self.animationLayer.frame.size.height/2:self.animationLayer.frame.size.width/2;
    radius-=kcProgress_Line_Width/2;
    
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
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath addArcWithCenter:CGPointMake(CGRectGetMidX(self.animationLayer.bounds), CGRectGetMidY(self.animationLayer.bounds)) radius: radius startAngle:1.5*M_PI endAngle:3.5*M_PI clockwise:YES];
    
    self.progressLayer.frame=self.animationLayer.bounds;
    self.progressLayer.strokeColor = [self.color1 CGColor];
    self.progressLayer.fillColor = [[UIColor clearColor] CGColor];
    self.progressLayer.lineWidth=kcProgress_Line_Width;
    self.progressLayer.path=circlePath1.CGPath;
    self.progressLayer.strokeEnd=1.0f;
    //
    self.progressLayerPlus.frame=self.animationLayer.bounds;
    self.progressLayerPlus.strokeColor = [self.color2 CGColor];
    self.progressLayerPlus.fillColor = [[UIColor clearColor] CGColor];
    self.progressLayerPlus.lineWidth=kcProgress_Line_Width;
    self.progressLayerPlus.path=circlePath2.CGPath;
    self.progressLayerPlus.strokeEnd=1.0f;
    
    self.maskLayer.frame=self.animationLayer.bounds;
    self.maskLayer.strokeColor = [[UIColor blackColor] CGColor];
    self.maskLayer.fillColor = [[UIColor clearColor] CGColor];
    self.maskLayer.lineWidth=kcProgress_Line_Width;
    self.maskLayer.strokeEnd=0.f;//use this property to set up the default value
    self.maskLayer.path=maskPath.CGPath;
    
    [self layoutLabel];
}
-(void)layoutLabel
{
    CGFloat width=self.frame.size.width;
    CGFloat height=self.frame.size.height;
    CGFloat value= width>height? height:width;
    self.middleLabel.frame=CGRectMake(0, 0, 0.5*value, 0.5*value);
    self.middleLabel.center=self.center;
}

-(id)init
{
    
    if (self= [super init]) {
        
        self.animationLayer= [CALayer layer];
        [self.layer addSublayer:self.animationLayer];
        self.progressLayer = [CAShapeLayer layer];
        self.progressLayerPlus = [CAShapeLayer layer];
        self.maskLayer=[CAShapeLayer layer];
        [self.animationLayer addSublayer:self.progressLayer];
        [self.animationLayer addSublayer:self.progressLayerPlus];
        //self.animationLayer.mask=self.maskLayer;
        [self setupMiddleLabel];
        
    }
    return  self;
    
}
-(void)setupMiddleLabel
{
    self.middleLabel=[[UILabel alloc] init];
    self.middleLabel.backgroundColor=[UIColor clearColor];
    //self.middleLabel.backgroundColor=[UIColor blueColor];
    self.middleLabel.hidden=NO;
    self.middleLabel.textColor=kcLikeRed;
    self.middleLabel.font=[UIFont fontWithName:@"Arial" size:60];
    self.middleLabel.adjustsFontSizeToFitWidth = YES;
    self.middleLabel.userInteractionEnabled = NO;
    self.middleLabel.numberOfLines = 1;
    self.middleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.middleLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.middleLabel];
    self.userInteractionEnabled=NO;
    
}

-(void)setPercent:(CGFloat)percent animated:(BOOL)animated
{
    //NSLog(@"current percent is %f",percent);

    if (animated)
    {
        
        self.animationLayer.mask=self.maskLayer;
        CABasicAnimation *animation;
        //animation = self.animation;//this place the input parameter must be strokeEnd
        animation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];//this place the input parameter must be strokeEnd
        [animation setFromValue:[NSNumber numberWithFloat:0.0f] ];
        //[animation setFromValue:0 ];
        [animation setToValue:[NSNumber numberWithFloat:1.0f]];
        [animation setDuration:self.animationDurationTime];
        [animation setRemovedOnCompletion:NO];
        [animation setFillMode:kCAFillModeForwards];//must set up this property, otherwise this class does not work properly
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        animation.delegate=self;
        [animation setValue:@"ProgressBarAnimation" forKey:@"animationBar"];
        [self.maskLayer addAnimation:animation forKey:nil];
    }
    else
    {
        return ;
    }
    
    

}

-(void)deleteAnimatedProgress
{

    [self.maskLayer removeAllAnimations];
    [self.animationLayer removeFromSuperlayer];//delete the layer, then the layer will disappear

}
-(void)removeFromSuperview
{
    [self deleteAnimatedProgress];
    [super removeFromSuperview];
    
}

-(void)showSeries:(BOOL)isAnimated
{
    [self updateData];
    [self layoutSubviews];
    [self setPercent:0  animated:isAnimated];
    [self showFloatingNumber:isAnimated];
    
    
}


-(void)showFloatingNumber:(BOOL)isAnimated
{
    float duration=self.animationDurationTime;
    NSNumber* number=self.floatingNumber;
    float timeInterval=0.05f;
    float stepNum=duration/timeInterval;
    self.valuePerStep=[NSNumber numberWithFloat:([number floatValue]/stepNum)];
    
    if (!isAnimated)
    {
        if ([number floatValue]>=1)
            self.middleLabel.text=[NSString stringWithFormat:@"%d",(int)[number floatValue]] ;
        if ([number floatValue]>0&&[number floatValue]<1)
        {
            NSString* str=[NSString stringWithFormat:@"%d",(int)([number floatValue]*100)];
            self.middleLabel.text=[str stringByAppendingString:@"%"];
        }
        
        
    }
    else
    {
        self.timer =  [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.changingValue=[NSNumber numberWithFloat:0.0f];
        
        
        
        
    }
}

-(void)onTimer:(NSTimer *)timer
{
    float val=[self.changingValue floatValue];
    val+=[self.valuePerStep floatValue];
    self.changingValue= [NSNumber numberWithFloat:val];
    if ([self.changingValue floatValue]<=[self.floatingNumber floatValue])
    {
        if ([self.changingValue floatValue]>=1)
            self.middleLabel.text=[NSString stringWithFormat:@"%d",(int)[self.changingValue floatValue]] ;
        if ([self.changingValue floatValue]>0&&[self.changingValue floatValue]<1)
        {
            //self.middleLabel.text=[NSString stringWithFormat:@"0.%d",(int)([self.changingValue floatValue]*100)];
            NSString* str=[NSString stringWithFormat:@"%d",(int)([self.changingValue floatValue]*100)];
            
            self.middleLabel.text=[str stringByAppendingString:@"%"];
        }
    }
    else
    {
        //[self.timer setFireDate:[NSDate distantFuture]];
        [self.timer invalidate];
        self.timer=nil;
        
    }
    
    
}
-(void)updateData
{
    
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(colorForSecondBar:)])
    {
        self.color2=[self.delegate colorForSecondBar:self];
        
    }
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(colorForfirstBar:)])
    {
        self.color1=[self.delegate colorForfirstBar:self];
        
    }
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(finalPercentage:)])
    {
        self.finalPercentage=[[self.delegate finalPercentage:self] floatValue];
        
    }
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(animationTime:)])
    {
        self.animationDurationTime=[self.delegate animationTime:self];
        
    }
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(plusChartFloatingNumber:)])
    {
        self.floatingNumber=[self.delegate plusChartFloatingNumber:self] ;
        
    }
    if (self.delegate!=nil&&[self.delegate respondsToSelector:@selector(progressType:)])
    {
        self.progressType=[self.delegate progressType:self];
        
    }


    
}









#pragma CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    if (flag) {
        if ([[animation valueForKey:@"animationBar"] isEqualToString:@"ProgressBarAnimation"])
            self.isAnimating=NO;
    }

    
    
    
    
}
-(void)animationDidStart:(CAAnimation *)animation
{
    if ([[animation valueForKey:@"animationBar"] isEqualToString:@"ProgressBarAnimation"])
        self.isAnimating=YES;
    
}

@end
