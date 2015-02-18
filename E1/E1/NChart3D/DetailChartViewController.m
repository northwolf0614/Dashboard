//
//  DetailChartViewController.m
//  E1
//
//  Created by Jack Lin on 2/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "DetailChartViewController.h"
#import "Definations.h"
#import "SliderCell.h"
#import "SwitchCell.h"
#import "ChartDataManager.h"




@interface DetailChartViewController ()<UINavigationBarDelegate>
@property(nonatomic,strong)UITableView* configView;
@property(nonatomic,strong) NSDictionary* chartTypeSeriesInfo;
@property(nonatomic,strong) NSString* chartType;
@property(nonatomic,strong) NSString* currentYear;
@property(nonatomic,strong) NChartDataModel* chartDataBack;
@property(nonatomic,strong) UIView* coverView;

@end

@implementation DetailChartViewController
- (NSUInteger)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskLandscape;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationBar.delegate=self;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    UIBarButtonItem* rightBarButtonItem=[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleRightButtonItem:)];
    self.navItem.rightBarButtonItem=rightBarButtonItem;
    
    if (!self.isAdded) {
        self.navItem.title=self.dataForNChart.chartCaption;
    }
    else
        self.navItem.title=@"New Chart";
    
    
    

    self.configView=[[UITableView alloc] init];
    self.configView.translatesAutoresizingMaskIntoConstraints=NO;
    
    self.contentView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.chartViewContainer addSubview:self.contentView];
    [self.chartViewContainer addSubview:self.configView];
    //
    self.configView.dataSource=self;
    self.configView.delegate=self;
    [self.configView registerNib:[UINib nibWithNibName:NSStringFromClass([SliderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SliderCell class])];
    [self.configView registerNib:[UINib nibWithNibName:NSStringFromClass([SwitchCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SwitchCell class])];
    [self.configView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"configTableViewCell"];
    self.chartTypeSeriesInfo=@{@"BAR":@[@"In call",@"Inactive"],@"COLUMN":@[@"Closed",@"Opened",@"Active"],@"RADAR":@[@"Converted",@"Quoted"],@"AREA":@[@"Bind",@"Quoted",@"EStimate"]};
    self.currentYear=@"2014";
    if (!self.isAdded)
    {
        self.chartDataBack=[self.dataForNChart copy];
    }
    self.chartView.userInteractionEnabled=YES;
    self.configView.backgroundColor=kcdetailViewConrtollerTableViewBackColor;
    self.configView.bounces=NO;
    self.configView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.chartViewContainer.backgroundColor=[UIColor lightGrayColor];
    [self setupLayout];
}

-(void)setupLayout
{
    if (self.label==nil)
    {
        self.label=[[UILabel alloc] init];
        self.label.backgroundColor=[UIColor clearColor];
        self.label.text=self.dataForNChart.labelText;
        self.label.textColor=kcCharColor;
        self.label.translatesAutoresizingMaskIntoConstraints=NO;
        self.label.font=[UIFont fontWithName:@"Arial" size:120];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.userInteractionEnabled = NO;
        self.label.numberOfLines = 1;
        self.label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self.contentView addSubview:self.label];
    }
    //if (self.dataForNChart.dataForNextView!=nil)
    if (self.percentageView==nil&&self.dataForNChart.dataForNextView!=nil)
    {
        self.percentageView=nil;
        float percent=[self.dataForNChart.dataForNextView.percentage floatValue];
        self.percentageView=[[ProgressBar alloc] initWithFinalPercentage:percent color1:kcLikeBlue color2:kcLikeRed];
        //self.percentageView=[[ProgressBar alloc] initWithFinalPercentage:percent color1:[UIColor blackColor] color2:[UIColor blueColor]];
        self.percentageView.translatesAutoresizingMaskIntoConstraints=NO;
        self.percentageView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.percentageView];
    }
    if (self.percentageView!=nil&&self.dataForNChart.dataForNextView==nil)
    {
        [self.percentageView removeFromSuperview];
        self.percentageView=nil;
    
    
    }
    
    
    NSArray* constraints=[self.contentView constraints];
    if ([constraints count]>0)
    {
        [self.contentView removeConstraints:constraints];
    }
    
    if (self.percentageView!=nil)
    {
        
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[percentageView]-0-[label(125)]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label,@"percentageView":self.percentageView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label,@"percentageView":self.percentageView}]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[percentageView(220)]-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label,@"percentageView":self.percentageView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[label(109)]->=0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label,@"percentageView":self.percentageView}]];
        
    }
    if (self.percentageView==nil) 
    {
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[label(125)]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[label(109)]-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.chartView,@"label":self.label }]];
    }
    if([self.contentView.subviews containsObject:self.coverView])
    {
        //self.coverView.hidden=NO;
        [self.coverView removeFromSuperview];
        [self.contentView addSubview:self.coverView];
        self.coverView.frame=self.contentView.bounds;
        [UIView animateWithDuration:0.45 animations:^{
            self.coverView.alpha=1;
        }];
        
    }
    else
    {
        [self.contentView addSubview:self.coverView];
        self.coverView.frame=self.contentView.bounds;
        [UIView animateWithDuration:0.45 animations:^{
            self.coverView.alpha=1;
        }];

    }
    [self.contentView setNeedsLayout];
    //[self.chartViewContainer setNeedsLayout];
    
}
-(BOOL)shouldBeAddToPreviousPage
{
    BOOL indicator=YES;
    NChartDataModel* data=self.dataForNChart;
    NChartDataModel* dataBack=self.chartDataBack;
    if (data==nil||!self.isAdded)
    {
        return NO;
    }
    else
    {
        if (self.isAdded)
        {
            
            for (NSString* key in data.chartDataForDrawing.allKeys)
            {
                switch (((PrototypeDataModel*)[data.chartDataForDrawing objectForKey:key]).seriesType)
                {
                    case BAR:
                    {
                        
                        if(((PrototypeDataModel*)[data.chartDataForDrawing objectForKey:key]).chartAxisXValues==nil)
                        {
                            indicator=NO;
                            break;
                        }
                        break;
                    }
                    case COLUMN:
                    case RADAR:
                    case LINE:
                    case AREA:
                    {
                        if(((PrototypeDataModel*)[data.chartDataForDrawing objectForKey:key]).chartAxisYValues==nil)
                        {
                            indicator=NO;
                            break;
                        }
                        break;
                    }
                        
                        
                    default:
                        break;
                }
                
                
            }
        }
        else
        {
            if (![data.chartDataForDrawing isEqualToDictionary:dataBack.chartDataForDrawing])
            {
                return NO;
            }
        }
        
    }
    return indicator;
    
}

-(void)handleRightButtonItem:(id) sender
{
    //need save operation
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 
                             }];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DetailChartViewController class]) owner:self options:nil];
    self.view = [nibs objectAtIndex:0];
    
    NSArray *nibs1 = [[NSBundle mainBundle] loadNibNamed:@"coverView" owner:self options:nil];
    self.coverView = [nibs1 objectAtIndex:0];
        
    
    
}




-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    NSArray* constraints=[self.chartViewContainer constraints];
    if ([constraints count]>0) {
        [self.chartViewContainer removeConstraints:constraints];
    }
    
    
    switch (toInterfaceOrientation)
    {
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            
        {
            
            
            [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView(550)]-0-[tableView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.contentView,@"tableView":self.configView }]];
            [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.contentView,@"tableView":self.configView }]];
            [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.contentView,@"tableView":self.configView }]];
            [self.chartViewContainer setNeedsLayout];
            
            
            break;
        }
            
        
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            
        {
            [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.contentView,@"tableView":self.configView }]];
            [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.contentView,@"tableView":self.configView }]];
            [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chartView(550)]-0-[tableView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.contentView,@"tableView":self.configView }]];
            [self.chartViewContainer setNeedsLayout];
            
            
            break;
        }
            
        default:
            break;
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray* constraints=[self.chartViewContainer constraints];
    if ([constraints count]>0) {
        [self.chartViewContainer removeConstraints:constraints];
    }
    
    
    switch (self.interfaceOrientation)
    {
        
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        
        {
            
            
            [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView(550)]-0-[tableView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.contentView,@"tableView":self.configView }]];
            [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.contentView,@"tableView":self.configView }]];
            [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.contentView,@"tableView":self.configView }]];
            [self.chartViewContainer setNeedsLayout];
            
            
            break;
        }
            
        
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.contentView,@"tableView":self.configView }]];
            [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.contentView,@"tableView":self.configView }]];
            [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chartView(550)]-0-[tableView]-0-|" options:0 metrics:0 views:@{ @"chartView" : self.contentView,@"tableView":self.configView }]];
            [self.chartViewContainer setNeedsLayout];
            
            
            break;
        }
            
        default:
            break;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isAdded) {
        return 3;
    }
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;//only one record =year sliderCelll
    }
    if (self.isAdded)
    {
        if (section==1)
        {
            return [self.chartTypeSeriesInfo.allKeys count];
        }
        if (section==2)
        {
            if ([self.chartType isEqualToString:@"BAR"]) {
                return [[self.chartTypeSeriesInfo objectForKey:@"BAR"] count];
            }
            if ([self.chartType isEqualToString:@"COLUMN"]) {
                return [[self.chartTypeSeriesInfo objectForKey:@"COLUMN"] count];
            }
            if ([self.chartType isEqualToString:@"RADAR"]) {
                return [[self.chartTypeSeriesInfo objectForKey:@"RADAR"] count];
            }
            if ([self.chartType isEqualToString:@"AREA"]) {
                return [[self.chartTypeSeriesInfo objectForKey:@"AREA"] count];
            }
        }
    }
    else
    {
        if (section==1) {
            return [self.dataForNChart.chartDataForDrawing.allKeys count];
        }
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kcPageTableCellHeight;
    
}
#pragma mark -<UITableViewDelegate>
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =nil;
    
    if (indexPath.section==0)
    {
        cell= [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SliderCell class])];
        ((SliderCell*)cell).delegate=self;
        
    }
    if (indexPath.section==1) {
        if (self.isAdded) {
            cell= [tableView dequeueReusableCellWithIdentifier:@"configTableViewCell"];
            cell.textLabel.text=[self.chartTypeSeriesInfo.allKeys objectAtIndex:indexPath.row];
        }
        else
        {
            cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SwitchCell class])];
            ((SwitchCell*)cell).seriesName.text=[self.dataForNChart.chartDataForDrawing.allKeys objectAtIndex:indexPath.row];
            ((SwitchCell*)cell).seriesSwitch.on=YES;
        }
    }
    if (indexPath.section==2)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SwitchCell class])];
        ((SwitchCell*)cell).seriesName.text=[[self.chartTypeSeriesInfo objectForKey:self.chartType] objectAtIndex:indexPath.row];
    }
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
    
    
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"Years";
    }
    if (section==1) {
        if (self.isAdded) {
            return @"Seriea Type";
        }
        else
        {
            return @"Serie Names";
        }
    }
    if (section==2) {
        if (self.isAdded) {
            return @"Serie Names";
        }
    }
    return nil;
}

#pragma <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cellView = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section==1&&self.isAdded)
    {
        self.coverView.hidden=NO;
        if (cellView.accessoryType == UITableViewCellAccessoryNone)
        {
            cellView.accessoryType=UITableViewCellAccessoryCheckmark;
            self.chartType=cellView.textLabel.text;
            [self.configView reloadData];
        }
        for (int count=0; count<[self.chartTypeSeriesInfo.allKeys count]; count++)
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:1]];
            if (cell.accessoryType!=UITableViewCellAccessoryNone&&count!=indexPath.row) {
                cell.accessoryType=UITableViewCellAccessoryNone;
            }

        }
//        if (self.dataForNChart!=nil)
//        {
//            self.dataForNChart=nil;
//        }
        if ([cellView.textLabel.text isEqualToString:@"COLUMN"])
        {
            if (self.dataForNChart!=nil) {
                self.dataForNChart=nil;
            }
            self.dataForNChart= [ChartDataManager templateColumnChartData];
            if (self.dataForNChart.dataForNextView!=nil&&[self.dataForNChart.dataForNextView isKindOfClass:[NChartDataModel class]])
            {
                self.dataForNChartPlus=self.dataForNChart.dataForNextView;
            }
                //self.dataForNChartPlus=drawingData.dataForNextView;
            
            [self setupAxesType];
            [self setupLayout];
        }
        if ([cellView.textLabel.text isEqualToString:@"BAR"])
        {
            if (self.dataForNChart!=nil) {
                self.dataForNChart=nil;
            }
            self.dataForNChart= [ChartDataManager templateBarChartData];

            [self setupAxesType];
            [self setupLayout];
        }
    
        if ([cellView.textLabel.text isEqualToString:@"RADAR"])
        {
            if (self.dataForNChart!=nil) {
                self.dataForNChart=nil;
            }
            self.dataForNChart= [ChartDataManager templateRadarChartData];
            
            [self setupAxesType];
            [self setupLayout];
        }
        if ([cellView.textLabel.text isEqualToString:@"AREA"])
        {
            if (self.dataForNChart!=nil) {
                self.dataForNChart=nil;
            }
            self.dataForNChart= [ChartDataManager templateAreaChartData];
            if (self.dataForNChart.dataForNextView!=nil&&[self.dataForNChart.dataForNextView isKindOfClass:[NChartDataModel class]])
            {
                self.dataForNChartPlus=self.dataForNChart.dataForNextView;
            }
            //self.dataForNChartPlus=drawingData.dataForNextView;
            
            [self setupAxesType];
            [self setupLayout];

        }
        
        
        
        
        
        
        
    }
    
    
    
    
}



#pragma <SliderDelegate>
-(void)sliderValueChaged:(NSString*)newValue
{
    NSLog(@"this is new value %@",newValue);
    [UIView animateWithDuration:0.45 animations:^{
        self.coverView.alpha=0.0f;
    }];
    self.currentYear=newValue;
    int x;
    float percent;
    if (self.label!=nil) {
        self.label.text=newValue;
        self.dataForNChart.labelText=newValue;
    }
    self.isNeedsUpdate=YES;
    if (self.dataForNChart.floatingNumber!=nil)
    {
        [self.chartView addMiddleLabel];
        percent = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
        x = arc4random() % 100;
//        if (self.dataForNChart.chartType==AREA)
//        {
//            self.dataForNChart.floatingNumber=[NSNumber numberWithFloat:percent];
//            self.dataForNChart.percentage=[NSNumber numberWithFloat:percent];
//        }
        if (self.dataForNChart.chartType==BAR) {
            
            self.dataForNChart.floatingNumber=[NSNumber numberWithFloat:x];
            self.dataForNChart.percentage=[NSNumber numberWithFloat:percent];

        }
        

    }
    else
        [self.chartView deleteMiddleLabel];
        
    if (self.dataForNChart.dataForNextView.floatingNumber!=nil)
    {
        [self.percentageView addMiddleLabel];

        percent = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
        x = arc4random() % 100;
        if (self.dataForNChart.chartType==AREA)
        {
            self.dataForNChart.dataForNextView.floatingNumber=[NSNumber numberWithFloat:percent];
            self.dataForNChart.dataForNextView.percentage=[NSNumber numberWithFloat:percent];
        }
        if (self.dataForNChart.chartType==COLUMN)
        {

            self.dataForNChart.dataForNextView.floatingNumber=[NSNumber numberWithFloat:x];
            self.dataForNChart.dataForNextView.percentage=[NSNumber numberWithFloat:percent];
        }

    }
    else
        [self.percentageView deleteMiddleLabel];
    
    
    [self showSeries];
}


#pragma mark - NChart Data Source
- (NSArray*)seriesDataSourcePointsForSeries:(NChartSeries*)series
{
    
    NSMutableArray* result = [NSMutableArray array];
    //NSUInteger base=[self.dataForNChart.chartDataForDrawing count];
    //NSLog(@"series data source  is %@",[series.dataSource class]);
    NSArray* keysArray=nil;
    NSArray* xValues=nil;
    NSArray* yValues=nil;
    NSeriesType seriesType;
    if (series.tag< [self.dataForNChart.chartDataForDrawing count])
        //if (![series.dataSource isKindOfClass:[DoubleNChartWithLabelViewController class]])
    {
        keysArray=self.dataForNChart.chartDataForDrawing.allKeys;
        xValues=[[self.dataForNChart.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] chartAxisXValues];
        yValues=[[self.dataForNChart.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] chartAxisYValues];
        seriesType=[[self.dataForNChart.chartDataForDrawing objectForKey:[keysArray objectAtIndex:series.tag]] seriesType];
    }
//    else
//        
//    {
//        keysArray=self.dataForNChartPlus.chartDataForDrawing.allKeys;
//        xValues=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:[keysArray objectAtIndex:(series.tag-base)]] chartAxisXValues];
//        yValues=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:[keysArray objectAtIndex:(series.tag-base)]] chartAxisYValues];
//        seriesType=[[self.dataForNChartPlus.chartDataForDrawing objectForKey:[keysArray objectAtIndex:(series.tag-base)]] seriesType];
//    }
    if (seriesType==LINE)
    {
//        if (!self.isAdded)
//        {
////            if ([self.currentYear isEqualToString:kcDefaultYear])
////            {
////                for (int count=0;count<[xValues count];count++)
////                {
////                    NSNumber* yValueObject=[yValues objectAtIndex:count];
////                    double yValueDouble=[yValueObject doubleValue];
////                    NSNumber* xValueObject=[xValues objectAtIndex:count];
////                    int xValueInt=[xValueObject intValue];
////                    NChartPointState *state = [NChartPointState pointStateAlignedToXWithX:xValueInt Y:yValueDouble];
////                    state.marker = [NChartMarker new] ;
////                    state.marker.shape = NChartMarkerShapeCircle;
////                    state.marker.brush=[NChartSolidColorBrush solidColorBrushWithColor:kcLikeRed];
////                    //state.marker.size=1.0f;//maybe not working
////                    [result addObject:[NChartPoint pointWithState:state forSeries:series]];
////                    
////                    
////                    
////                }
////                return result;
////            }
////            else
//            {
//                for (int count=0;count<[xValues count];count++)
//                {
//
//                    double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
//                    NChartPointState *state = [NChartPointState pointStateAlignedToXWithX:count Y:val];
//                    state.marker = [NChartMarker new] ;
//                    state.marker.shape = NChartMarkerShapeCircle;
//                    state.marker.brush=[NChartSolidColorBrush solidColorBrushWithColor:kcLikeRed];
//                    //state.marker.size=1.0f;//maybe not working
//                    [result addObject:[NChartPoint pointWithState:state forSeries:series]];
//                    
//                    
//                    
//                    
//                }
//                return result;
//                
//            }
//        }
        //else
        {
            NSMutableArray* yVals=[NSMutableArray array];//
            for (int count=0;count<[xValues count];count++)
            {
                
                double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
                NChartPointState *state = [NChartPointState pointStateAlignedToXWithX:count Y:val];
                state.marker = [NChartMarker new] ;
                state.marker.shape = NChartMarkerShapeCircle;
                state.marker.brush=[NChartSolidColorBrush solidColorBrushWithColor:kcLikeRed];
                //state.marker.size=1.0f;//maybe not working

                [yVals addObject:[NSNumber numberWithDouble:val]];//
                [result addObject:[NChartPoint pointWithState:state forSeries:series]];
                
                
                
                
            }
            
            NSArray* keys=[self.dataForNChart.chartDataForDrawing allKeys];
            PrototypeDataModel* rawData=[self.dataForNChart.chartDataForDrawing objectForKey:[keys objectAtIndex:series.tag]];//
            rawData.chartAxisYValues=[yVals copy];//
            [self.dataForNChart.chartDataForDrawing setObject:rawData forKey:[keys objectAtIndex:series.tag]];
            
            return result;
            
        }
        
        
    }
    else if (seriesType==COLUMN)
    {
//        if (!self.isAdded)
//        {
////            if ([self.currentYear isEqualToString:kcDefaultYear])
////            {
////                for (int count=0;count<[xValues count];count++)
////                {
////                    NSNumber* yValueObject=[yValues objectAtIndex:count];
////                    double yValueDouble=[yValueObject doubleValue];
////                    NSNumber* xValueObject=[xValues objectAtIndex:count];
////                    int xValueInt=[xValueObject intValue];
////                    NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState pointStateAlignedToXWithX:xValueInt Y:yValueDouble] forSeries:series];
////                    [result addObject:aPoint];
////                    
////                    
////                }
////                return result;
////            }
////            else
//            {
//                for (int count=0;count<[xValues count];count++)
//                {
//                    double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
//                    NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState pointStateAlignedToXWithX:count Y:val] forSeries:series];
//                    [result addObject:aPoint];
//                    //NSLog(@"the double number is %f",val);
//                    
//                    
//                }
//                return result;
//                
//            }
//            
//        
//        
//        }
        
        //else
        {
            NSMutableArray* yVals=[NSMutableArray array];//
            for (int count=0;count<[xValues count];count++)
            {
                double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
                NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState pointStateAlignedToXWithX:count Y:val] forSeries:series];
                [yVals addObject:[NSNumber numberWithDouble:val]];//
                [result addObject:aPoint];
                //NSLog(@"the double number is %f",val);
                
                
            }
            NSArray* keys=[self.dataForNChart.chartDataForDrawing allKeys];
            PrototypeDataModel* rawData=[self.dataForNChart.chartDataForDrawing objectForKey:[keys objectAtIndex:series.tag]];//
            rawData.chartAxisYValues=[yVals copy];//
            [self.dataForNChart.chartDataForDrawing setObject:rawData forKey:[keys objectAtIndex:series.tag]];
            
            return result;
        }
    }
    else if (seriesType==BAR)
    {
//        if (!self.isAdded)
//        {
//            
////            if ([self.currentYear isEqualToString:kcDefaultYear])
////            {
////            
////                for (int count=0;count<[xValues count];count++)
////                {
////                    NSNumber* xValueObject=[xValues objectAtIndex:count];
////                    double xValueDouble=[xValueObject doubleValue];
////                    NSNumber* yValueObject=[yValues objectAtIndex:count];
////                    int yValueInt=[yValueObject intValue];
////                    NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState pointStateAlignedToYWithX:xValueDouble Y:yValueInt] forSeries:series];
////                    [result addObject:aPoint];
////                    
////                    
////                }
////                return result;
////            }
////            else
//            {
//                for (int count=0;count<[xValues count];count++)
//                {
//                    double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
//                    NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState pointStateAlignedToYWithX:val Y:count] forSeries:series];
//                    [result addObject:aPoint];
//                    
//                    
//                }
//
//                return result;
//            }
//            
//        
//        
//        }
        //else
        {   NSMutableArray* xVals=[NSMutableArray array];//
            for (int count=0;count<[yValues count];count++)
            {
                double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
                NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState pointStateAlignedToYWithX:val Y:count] forSeries:series];
                [xVals addObject:[NSNumber numberWithDouble:val]];//
                [result addObject:aPoint];
                
                
            }
            NSArray* keys=[self.dataForNChart.chartDataForDrawing allKeys];
            PrototypeDataModel* rawData=[self.dataForNChart.chartDataForDrawing objectForKey:[keys objectAtIndex:series.tag]];//
            rawData.chartAxisXValues=[xVals copy];//
            [self.dataForNChart.chartDataForDrawing setObject:rawData forKey:[keys objectAtIndex:series.tag]];
            return result;
            
        }
    }
    else if (seriesType==DOUGHNUT)
    {
        for (int count=0;count<[xValues count];count++)
        {
            NSNumber* yValueObject=[yValues objectAtIndex:count];
            double yValueDouble=[yValueObject doubleValue];
            //NSNumber* xValueObject=[xValues objectAtIndex:count];
            //int xValueInt=[xValueObject intValue];
            NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState pointStateWithCircle:count value:yValueDouble] forSeries:series ];
            [result addObject:aPoint];
            
        }
        return result;
        
        
    }
    
    else if (seriesType==RADAR)
    {
//        if (!self.isAdded)
//        {
////            if ([self.currentYear isEqualToString:kcDefaultYear])
////            {
////                
////                for (int count=0;count<[xValues count];count++)
////                {
////                    NSNumber* xValueObject=[xValues objectAtIndex:count];
////                    double xValueInt=[xValueObject intValue];
////                    
////                    NSNumber* yValueObject=[yValues objectAtIndex:count];
////                    double yValueDouble=[yValueObject doubleValue];
////                    //NSNumber* xValueObject=[xValues objectAtIndex:count];
////                    //int xValueInt=[xValueObject intValue];
////                    NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState
////                                                                     pointStateAlignedToXZWithX:xValueInt
////                                                                     Y:yValueDouble
////                                                                     Z:self.chartViewPlus.chart.drawIn3D &&
////                                                                     (self.chartViewPlus.chart.cartesianSystem.valueAxesType ==
////                                                                      NChartValueAxesTypeAbsolute) ? series.tag : 0]
////                                                          forSeries:series];
////                    
////                    [result addObject:aPoint];
////                    
////                }
////                return result;
////            }
////            else
//            {
//                for (int count=0;count<[xValues count];count++)
//                {
//
//                    double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
//                    NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState
//                                                                     pointStateAlignedToXZWithX:count
//                                                                     Y:val
//                                                                     Z:self.chartViewPlus.chart.drawIn3D &&
//                                                                     (self.chartViewPlus.chart.cartesianSystem.valueAxesType ==
//                                                                      NChartValueAxesTypeAbsolute) ? series.tag : 0]
//                                                          forSeries:series];
//                    
//                    [result addObject:aPoint];
//                    
//                }
//                return result;
//                
//            }
//    
//    
//        }
        //else
        {
            NSMutableArray* yVals=[NSMutableArray array];//
            for (int count=0;count<[xValues count];count++)
            {
                
                double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
                NChartPoint* aPoint=[NChartPoint pointWithState:[NChartPointState
                                                                 pointStateAlignedToXZWithX:count
                                                                 Y:val
                                                                 Z:self.chartViewPlus.chart.drawIn3D &&
                                                                 (self.chartViewPlus.chart.cartesianSystem.valueAxesType ==
                                                                  NChartValueAxesTypeAbsolute) ? series.tag : 0]
                                                      forSeries:series];
                
                [result addObject:aPoint];
                [yVals addObject:[NSNumber numberWithDouble:val]];//
                
            }
            NSArray* keys=[self.dataForNChart.chartDataForDrawing allKeys];
            PrototypeDataModel* rawData=[self.dataForNChart.chartDataForDrawing objectForKey:[keys objectAtIndex:series.tag]];//
            rawData.chartAxisYValues=[yVals copy];//
            [self.dataForNChart.chartDataForDrawing setObject:rawData forKey:[keys objectAtIndex:series.tag]];
            return result;
            
        }
    }
    if (seriesType==AREA)
    {
        //        if (!self.isAdded)
        //        {
        ////            if ([self.currentYear isEqualToString:kcDefaultYear])
        ////            {
        ////                for (int count=0;count<[xValues count];count++)
        ////                {
        ////                    NSNumber* yValueObject=[yValues objectAtIndex:count];
        ////                    double yValueDouble=[yValueObject doubleValue];
        ////                    NSNumber* xValueObject=[xValues objectAtIndex:count];
        ////                    int xValueInt=[xValueObject intValue];
        ////                    NChartPointState *state = [NChartPointState pointStateAlignedToXWithX:xValueInt Y:yValueDouble];
        ////                    state.marker = [NChartMarker new] ;
        ////                    state.marker.shape = NChartMarkerShapeCircle;
        ////                    state.marker.brush=[NChartSolidColorBrush solidColorBrushWithColor:kcLikeRed];
        ////                    //state.marker.size=1.0f;//maybe not working
        ////                    [result addObject:[NChartPoint pointWithState:state forSeries:series]];
        ////
        ////
        ////
        ////                }
        ////                return result;
        ////            }
        ////            else
        //            {
        //                for (int count=0;count<[xValues count];count++)
        //                {
        //
        //                    double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
        //                    NChartPointState *state = [NChartPointState pointStateAlignedToXWithX:count Y:val];
        //                    state.marker = [NChartMarker new] ;
        //                    state.marker.shape = NChartMarkerShapeCircle;
        //                    state.marker.brush=[NChartSolidColorBrush solidColorBrushWithColor:kcLikeRed];
        //                    //state.marker.size=1.0f;//maybe not working
        //                    [result addObject:[NChartPoint pointWithState:state forSeries:series]];
        //
        //
        //
        //
        //                }
        //                return result;
        //
        //            }
        //        }
        //else
        {
            NSMutableArray* yVals=[NSMutableArray array];//
            for (int count=0;count<[xValues count];count++)
            {
                
                double val = floorf(((double)arc4random() / ARC4RANDOM_MAX) * 100.0f)/100.0f;//0-1 random double number
                NChartPointState *state = [NChartPointState pointStateAlignedToXWithX:count Y:val];
                //state.marker = [NChartMarker new] ;
                //state.marker.shape = NChartMarkerShapeCircle;
                //state.marker.brush=[NChartSolidColorBrush solidColorBrushWithColor:kcLikeRed];
                //state.marker.size=1.0f;//maybe not working
                
                [yVals addObject:[NSNumber numberWithDouble:val]];//
                [result addObject:[NChartPoint pointWithState:state forSeries:series]];
                
                
                
                
            }
            
            NSArray* keys=[self.dataForNChart.chartDataForDrawing allKeys];
            PrototypeDataModel* rawData=[self.dataForNChart.chartDataForDrawing objectForKey:[keys objectAtIndex:series.tag]];//
            rawData.chartAxisYValues=[yVals copy];//
            [self.dataForNChart.chartDataForDrawing setObject:rawData forKey:[keys objectAtIndex:series.tag]];
            
            return result;
            
        }
        
        
    }
    
    
    return nil;
    
    
}
#pragma <UINavigationBarDelegate>
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
    return UIBarPositionTopAttached;
}





@end
