//
//  AbstractNChartViewController.m
//  E1
//
//  Created by Lei Zhao on 30/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "AbstractNChartViewController.h"
#import "Definations.h"
#import "NChartDataModel.h"



@interface AbstractNChartViewController ()
@property(nonatomic,assign) BOOL isShowMiddleLabel;
@end

@implementation AbstractNChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.chartView = [[AbstractNChartView alloc] initWithFrame:CGRectZero];
    self.chartView.chart.licenseKey = kcNchartViewlicense;
    self.chartView.chart.cartesianSystem.margin = NChartMarginMake(0, 0, 0, 0);
    self.chartView.chart.shouldAntialias = YES;
    //self.chartView.chart.drawIn3D = YES;
    self.chartView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.chartView];
    self.chartView.chart.cartesianSystem.xAxis.dataSource = (id)self;
    self.chartView.chart.cartesianSystem.yAxis.dataSource = (id)self;
    self.chartView.chart.cartesianSystem.zAxis.dataSource = (id)self;
    
    self.chartView.chart.sizeAxis.dataSource=(id)self;

    self.chartView.chart.cartesianSystem.yAlongX.visible=NO;
    self.chartView.chart.cartesianSystem.xAlongY.visible=NO;
    self.chartView.chart.cartesianSystem.borderVisible=NO;
    self.chartView.chart.cartesianSystem.yAxis.caption.visible=NO;
    self.chartView.chart.cartesianSystem.yAxis.visible=NO;
    self.chartView.chart.cartesianSystem.xAxis.majorTicks.visible=NO;
    self.chartView.chart.cartesianSystem.xAxis.minorTicks.visible=NO;
    self.chartView.chart.background = [NChartSolidColorBrush solidColorBrushWithColor:[UIColor darkGrayColor]];
    
    //[self setupLabels];
    
    
    
    
    
    
}
-(id)initWithDrawingData:(NChartDataModel*)drawingData delegateHolder:(id<ChartSubviewControllerResponse>) delegateImplementer;
{
    if (self=[super init])
    {
        self.dataForNChart=drawingData;
        
        self.delegate=delegateImplementer;
    }
    return self;
}



//-(void)setupLabels
//{
//    self.isShowMiddleLabel=NO;
//    NSArray* keysArray=self.dataForNChart.chartDataForDrawing.allKeys;
//    int seriesNumber=[keysArray count];
//    BOOL seriesTypeIndicator=YES;
//    BOOL dataNumberIndicator=YES;
//    
//    for (int count=0; count<[keysArray count]; count++)//for every series
//    {
//        NSString* key=[keysArray objectAtIndex:count];
//        NSeriesType seriesType=[[self.dataForNChart.chartDataForDrawing objectForKey:key] seriesType];
//        int dataNumber=[[[self.dataForNChart.chartDataForDrawing objectForKey:key] chartAxisXValues] count];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    double total=0.0f;
//    if (self.isShowMiddleLabel)
//    {
//        
//        [self.chartView enableMiddleLabel];
//        NSArray* keysArray=self.dataForNChart.chartDataForDrawing.allKeys;
//        for (int count=0; count<[keysArray count]; count++)//for every series
//        {
//            NSString* key=[keysArray objectAtIndex:count];
//            if ([[self.dataForNChart.chartDataForDrawing objectForKey:key] seriesType]==BAR)
//            {
//                
//                if ([[[self.dataForNChart.chartDataForDrawing objectForKey:key] chartAxisXValues] count]>1) {
//                    return;
//                }
//                total+=[[[[self.dataForNChart.chartDataForDrawing objectForKey:key] chartAxisXValues] objectAtIndex:0] doubleValue];
//            }
//             if ([[self.dataForNChart.chartDataForDrawing objectForKey:key] seriesType]==DOUGHNUT)
//            {
//                
//                if ([[[self.dataForNChart.chartDataForDrawing objectForKey:key] chartAxisYValues] count]>1)
//                {
//                    return;
//                }
//                total+=[[[[self.dataForNChart.chartDataForDrawing objectForKey:key] chartAxisYValues] objectAtIndex:0] doubleValue];
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

@end
