//
//  ParagraphViewController.m
//  E1
//
//  Created by Jack Lin on 29/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "ParagraphViewController.h"
#import "Definations.h"
#import "ParagraphView.h"

@interface ParagraphViewController ()
@property (nonatomic, strong) NSMutableArray* dataForPlot;
@property (nonatomic, strong) ParagraphView* paragraphView;
@end

@implementation ParagraphViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.paragraphView = [[ParagraphView alloc] init];
    [self.contentView addSubview:self.paragraphView];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[paragraphView]-0-|" options:0 metrics:0 views:@{ @"paragraphView" : self.paragraphView }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[paragraphView]-0-|" options:0 metrics:0 views:@{ @"paragraphView" : self.paragraphView }]];
    [self.paragraphView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.paragraphView.boundLinePlot.dataSource = self;
    [self setupDataForParagraphView];

    // Do any additional setup after loading the view.
}
- (void)setupDataForParagraphView
{
    self.dataForPlot = [NSMutableArray arrayWithCapacity:100];
    NSUInteger i;
    for (i = 0; i < 100; i++) {
        id x = [NSNumber numberWithFloat:0 + i * 0.05];
        id y = [NSNumber numberWithFloat:1.2 * rand() / (float)RAND_MAX + 1.2];
        [self.dataForPlot addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.paragraphView updateCorePlotViews];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot*)plot
{

    if ([plot isKindOfClass:[CPTScatterPlot class]] && [plot.identifier isEqual:kcQBE_Products_History]) {
        return self.dataForPlot.count;
    }
    return 0;
}

// 返回每个扇形的比例

- (NSNumber*)numberForPlot:(CPTPlot*)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{

    if ([plot isKindOfClass:[CPTScatterPlot class]] && [plot.identifier isEqual:kcQBE_Products_History]) {

        NSString* key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
        NSNumber* num = [[_dataForPlot objectAtIndex:idx] valueForKey:key];
        if ([(NSString*)plot.identifier isEqualToString:kcQBE_Products_History]) {
            if (fieldEnum == CPTScatterPlotFieldY) {
                num = [NSNumber numberWithDouble:[num doubleValue] + 1.0];
            }
        }

        return num;
    }
    return nil;
}

@end
