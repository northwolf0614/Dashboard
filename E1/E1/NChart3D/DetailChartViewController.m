//
//  DetailChartViewController.m
//  E1
//
//  Created by Jack Lin on 2/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DetailChartViewController.h"
#import "Definations.h"

@interface DetailChartViewController ()
//@property(nonatomic,assign) BOOL isShowMiddleLabel;
@end

@implementation DetailChartViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
//    self.chartView = [[AbstractNChartView alloc] init];
//    self.chartView.chart.licenseKey = kcNchartViewlicense;
//    self.chartView.chart.cartesianSystem.margin = NChartMarginMake(0, 0, 0, 0);
//    self.chartView.chart.shouldAntialias = YES;
//    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //[self.chartViewContainer addSubview:self.chartView];
    [self.chartViewContainer addSubview:self.contentView];
    self.contentView.translatesAutoresizingMaskIntoConstraints=NO;
//    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView }]];
//    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView }]];
    
    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:0 metrics:0 views:@{ @"contentView" : self.contentView }]];
    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:0 metrics:0 views:@{ @"contentView" : self.contentView }]];

    
//    self.configurationViewContainer.backgroundColor=[UIColor redColor];
//    
//    self.chartView.chart.cartesianSystem.xAxis.dataSource = (id)self;
//    self.chartView.chart.cartesianSystem.yAxis.dataSource = (id)self;
//    self.chartView.chart.cartesianSystem.zAxis.dataSource = (id)self;
//    self.chartView.chart.cartesianSystem.yAlongX.visible=NO;
//    
//    self.chartView.chart.cartesianSystem.xAlongY.visible=NO;
//    self.chartView.chart.cartesianSystem.borderVisible=NO;
//    self.chartView.chart.cartesianSystem.yAxis.caption.visible=NO;
//    self.chartView.chart.cartesianSystem.yAxis.visible=NO;
//    self.chartView.chart.cartesianSystem.xAxis.majorTicks.visible=NO;
//    self.chartView.chart.cartesianSystem.xAxis.minorTicks.visible=NO;
//    self.chartView.chart.background = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor darkGrayColor]];
//    [self setupLabels];
    

}

//-(id)initWithChartData:(NChartDataModel*) dataForChart;
//{
//    
//    if (self=[super init]) {
//        self.dataForChartView=dataForChart;
//    }
//    return self;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DetailChartViewController class]) owner:self options:nil];
    self.view = [nibs objectAtIndex:0];
    
    //self.view=self.contentView;
    
}

//-(void)setupLabels
//{
//    self.isShowMiddleLabel=NO;
//    NSArray* keysArray=self.dataForChartView.chartDataForDrawing.allKeys;
//    int seriesNumber=[keysArray count];
//    BOOL seriesTypeIndicator=YES;
//    BOOL dataNumberIndicator=YES;
//    
//    for (int count=0; count<[keysArray count]; count++)//for every series
//    {
//        NSString* key=[keysArray objectAtIndex:count];
//        NSeriesType seriesType=[[self.dataForChartView.chartDataForDrawing objectForKey:key] seriesType];
//        int dataNumber=[[[self.dataForChartView.chartDataForDrawing objectForKey:key] chartAxisXValues] count];
//        
//        if (dataNumber>1)
//        {
//            dataNumberIndicator=NO;
//            break;
//        }
//        if (seriesType!=BAR&&seriesType!=DOUGHNUT)
//        {
//            seriesTypeIndicator=NO;
//            break;
//        }
//    }
//    if (seriesNumber==2&&seriesTypeIndicator&&dataNumberIndicator)//is bar or doughnut and there is only one piece of data and in this chart only 2 series.
//    {
//        self.isShowMiddleLabel=YES;
//    }
//    
//    
//    
//    
//}
//
//
//
//
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    double total=0.0f;
//    if (self.isShowMiddleLabel)
//    {
//        
//        [self.chartView enableMiddleLabel];
//        NSArray* keysArray=self.dataForChartView.chartDataForDrawing.allKeys;
//        for (int count=0; count<[keysArray count]; count++)//for every series
//        {
//            NSString* key=[keysArray objectAtIndex:count];
//            if ([[self.dataForChartView.chartDataForDrawing objectForKey:key] seriesType]==BAR)
//            {
//                
//                if ([[[self.dataForChartView.chartDataForDrawing objectForKey:key] chartAxisXValues] count]>1) {
//                    return;
//                }
//                total+=[[[[self.dataForChartView.chartDataForDrawing objectForKey:key] chartAxisXValues] objectAtIndex:0] doubleValue];
//            }
//            if ([[self.dataForChartView.chartDataForDrawing objectForKey:key] seriesType]==DOUGHNUT)
//            {
//                
//                if ([[[self.dataForChartView.chartDataForDrawing objectForKey:key] chartAxisYValues] count]>1)
//                {
//                    return;
//                }
//                total+=[[[[self.dataForChartView.chartDataForDrawing objectForKey:key] chartAxisYValues] objectAtIndex:0] doubleValue];
//            }
//            
//            
//            
//        }
//        if (total>1)
//        {
//            [self.chartView setTextForMiddleLabel:[NSString stringWithFormat:@"%d",(int)total]];
//        }
//        if (total>0&&total<1)
//            [self.chartView setTextForMiddleLabel:[NSString stringWithFormat:@"0.%d",(int)(total*10)]];
//        
//        
//    }
//    
//    
//    
//    
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
