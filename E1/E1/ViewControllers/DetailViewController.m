//
//  DetailViewController.m
//  E1
//
//  Created by Jack Lin on 23/02/2015.
//  Copyright (c) 2015 EY. All rights reserved.
//

#import "DetailViewController.h"
#import "Definations.h"
#import "SwitchCell.h"
#import "ChartDataManager.h"
#import "ChildDetailChartViewController.h"
#import "GerneralChartViewController.h"
#import "GeneralCollectionViewCell.h"
#import "OneViewCell.h"
#import "TwoViewCell.h"
#import "ChildDetailChartViewController.h"
#import "PredictionConfigViewController.h"
#import "PredictionCellTableViewCell.h"
#import "MeetingCoordinator.h"
#import "GameNavigationController.h"


@interface DetailViewController ()

@property(nonatomic,strong) UITableView* configView;
@property(nonatomic,strong) NSDictionary* chartTypeSeriesInfo;
@property(nonatomic,strong) NSString* chartType;
@property(nonatomic,strong) NSString* currentYear;
@property(nonatomic,strong) NChartDataModel* chartDataBack;
@property(nonatomic,assign) BOOL isAdded;

@property(nonatomic,strong) NSString* pageName;

//@property(nonatomic,strong) UIView* coverView;
//@property(nonatomic,strong) UICollectionView* collectionView;
@property(nonatomic,strong) UICollectionViewFlowLayout* flowLayout;
@property(nonatomic,strong) NSArray* sectionNames;
@property(nonatomic,assign) float predictionViewRate;
@property(nonatomic,strong) UIView* predictionView;
@property(nonatomic,assign) unsigned int base;
@property(nonatomic,assign) float multiplier1;
@property(nonatomic,assign) float multiplier2;
@property(nonatomic,assign) float cellHeightRate;
@property(nonatomic,assign) NSArray* currentConfigs;
@property(nonatomic,assign) BOOL isMeeting;


@end

@implementation DetailViewController

- (NSUInteger)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskLandscape;
}
-(id)initWithDrawingData:(NChartDataModel*)drawingData  isAddedChart:(BOOL)isAdded page:(NSString*)pageName
{
    NSLog(@"This is initWithDrawingData in GerneralChartViewController");
    if (self=[super init])
    {
        if (drawingData!=nil)
        {
            self.dataForNChart=drawingData;
        }
        self.isAdded=isAdded;
        self.shouldDynamic=isAdded;
        if (isAdded)
        {
            self.predictionViewRate=0.1f;
        }
        else
            self.predictionViewRate=0.22f;
        
        self.pageName=[pageName copy];
        
        
        
    }
    return self;
}
-(void)setupCollectionView
{
    self.flowLayout=[[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GeneralCollectionViewCell"];
    self.collectionView.pagingEnabled=NO;
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView registerClass:[GeneralCollectionViewCell class] forCellWithReuseIdentifier:[GeneralCollectionViewCell reuseIdentifier]];
    [self.collectionView registerClass:[OneViewCell class] forCellWithReuseIdentifier:[OneViewCell reuseIdentifier]];
    [self.collectionView registerClass:[NChartViewCell class] forCellWithReuseIdentifier:[NChartViewCell reuseIdentifier]];
    [self.collectionView registerClass:[TwoViewCell class] forCellWithReuseIdentifier:[TwoViewCell reuseIdentifier]];
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.collectionView setBackgroundColor:kcWholeBackColor];
    [self.collectionView setUserInteractionEnabled:YES];
    [self.chartViewContainer addSubview:self.collectionView];

}
-(void)setupTableView
{
    self.configView=[[UITableView alloc] init];
    self.configView.translatesAutoresizingMaskIntoConstraints=NO;
    self.configView.dataSource=self;
    self.configView.delegate=self;
    [self.configView registerNib:[UINib nibWithNibName:NSStringFromClass([SwitchCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SwitchCell class])];
    [self.configView registerNib:[UINib nibWithNibName:NSStringFromClass([SliderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SliderCell class])];
    [self.configView registerNib:[UINib nibWithNibName:NSStringFromClass([PredictionCellTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PredictionCellTableViewCell class])];
    [self.configView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"configTableViewCell"];
    self.configView.backgroundColor=kcdetailViewConrtollerTableViewBackColor;
    self.configView.bounces=NO;
    self.configView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.chartViewContainer addSubview:self.configView];
    
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self initialization];
    self.navigationBar.delegate=self;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    UIBarButtonItem* rightBarButtonItem=[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleRightButtonItem:)];
    self.navItem.rightBarButtonItem=rightBarButtonItem;
    
    
    if (!self.isAdded) {
        self.navItem.title=self.dataForNChart.chartCaption;
         self.chartDataBack=[self.dataForNChart copy];
    }
    else
        self.navItem.title=@"New Chart";
    
    [self setupCollectionView];
    [self setupTableView];
    [self setupPredictionView];


}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
}
-(void)setupPredictionView
{
    //PredictionConfigViewController* pvc=[[PredictionConfigViewController alloc] init];
    PredictionConfigViewController* pvc=[[PredictionConfigViewController alloc] initWithIndication:self.isAdded data:self.dataForNChart.prediction];
    pvc.delegate=self;
    self.predictionView=pvc.view;
    [self.chartViewContainer addSubview:pvc.view];
    [self addChildViewController:pvc];
    [pvc didMoveToParentViewController:self];
}
-(void)initialization
{
    self.chartTypeSeriesInfo=@{@"BAR":@[@"In call",@"Inactive"],@"COLUMN":@[@"Closed",@"Opened",@"Active"],@"RADAR":@[@"Converted",@"Quoted"],@"AREA":@[@"Bind",@"Quoted",@"EStimate"]};
    NSArray* sectionNames=@[@"Years",@"Serial Type",@"Serie Names",@"Motor Rating Config"];
    self.sectionNames=[NSMutableArray arrayWithArray:sectionNames];
    if (self.dataForNChart!=nil)
    {
        self.currentYear=self.dataForNChart.labelText;
    }
    else
        self.currentYear=@"2014";
    _cellHeightRate=0.9;
}
-(RESULT)shouldBeAddToPreviousPage
{
    RESULT indicator=SHOULD_INSERT;
    NChartDataModel* data=self.dataForNChart;
    //NChartDataModel* dataBack=self.chartDataBack;
    if (data==nil)
    {
        return SHOULD_NONE;
    }
    if (!self.isAdded)
    {
        return SHOULD_UPDATE;
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
                            indicator=SHOULD_NONE;
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
                            indicator=SHOULD_NONE;
                            break;
                        }
                        break;
                    }
                        
                        
                    default:
                        break;
                }
                
                
            }
        }
//        else
//        {
//            if (![data.chartDataForDrawing isEqualToDictionary:dataBack.chartDataForDrawing])
//            {
//                return NO;
//            }
//        }
        
    }
    return indicator;
    
}

-(void)handleRightButtonItem:(id) sender
{
//    MeetingCoordinator* meetingController=[[MeetingCoordinator alloc] init];
//    //GameNavigationController* navController=[[GameNavigationController alloc] initWithRootViewController:meetingController];
//    [self presentViewController:meetingController animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DetailViewController class]) owner:self options:nil];
    self.view = [nibs objectAtIndex:0];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSUInteger sizebuffer=20;
    
    NSUInteger width= self.chartViewContainer.frame.size.width;
    NSUInteger height= self.chartViewContainer.frame.size.height;
    NSNumber* widthForCollectionView=[NSNumber numberWithInt:((int)((width*2)/3))];
    NSNumber* heightForCollectionView=[NSNumber numberWithInt:((int)(height))];
    NSNumber* widthForPredictionView=[NSNumber numberWithInt:((int)((width)/3))];
    NSNumber* heightForPredictionView=[NSNumber numberWithInt:((int)(height*self.predictionViewRate))];
    NSNumber* heightForTableView=[NSNumber numberWithInt:((int)(height*(1-self.predictionViewRate)))];
    NSNumber* widthForTableView=[NSNumber numberWithInt:((int)((width)/3))];
    
    
    
    NSUInteger cellWidth=[widthForCollectionView integerValue]-2*sizebuffer;
    NSUInteger cellHeight=[heightForCollectionView integerValue]*_cellHeightRate-2*sizebuffer;
    self.flowLayout.itemSize=CGSizeMake(cellWidth,cellHeight);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(sizebuffer,sizebuffer,sizebuffer,sizebuffer);
    NSArray* constraints=[self.chartViewContainer constraints];
    NSDictionary* metrics=@{@"widthForCollectionView":widthForCollectionView,@"heightForPredictionView":heightForPredictionView,@"widthForPredictionView":widthForPredictionView,@"heightForTableView":heightForTableView,@"widthForTableview":widthForTableView};
    NSDictionary* views=@{ @"chartView" : self.collectionView,@"tableView":self.configView,@"predictionView": self.predictionView};
    if ([constraints count]>0)
    {
        [self.chartViewContainer removeConstraints:constraints];
    }
    
//    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView(width)]-0-[tableView]-0-|" options:0 metrics:@{ @"width" :widthForCollectionView } views:@{ @"chartView" : self.collectionView,@"tableView":self.configView }]];
//    
//    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chartView]-0-|" options:0 metrics:@{ @"width" :widthForCollectionView } views:@{ @"chartView" : self.collectionView,@"tableView":self.configView }]];
//    
//    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:@{ @"width" :widthForCollectionView } views:@{ @"chartView" : self.collectionView,@"tableView":self.configView }]];
    

    
    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-[tableView(widthForTableview)]-0-|" options:0 metrics:metrics views:views]];
    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView]-0-[predictionView(widthForPredictionView)]-0-|" options:0 metrics:metrics views:views]];
    
    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chartView]-0-|" options:0 metrics:metrics views:views]];
    
    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView(heightForTableView)]-0-[predictionView]|" options:0 metrics:metrics views:views]];
    
    [self.chartViewContainer setNeedsUpdateConstraints];
    [self.chartViewContainer updateConstraintsIfNeeded];
    
    
}



#pragma <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isAdded) {
        return self.sectionNames.count;
    }
    else
        return self.sectionNames.count-1;
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
        if (section==3)
        {
            return kcPredicitonNum;
        }
    }
    else
    {
        if (section==1) {
            return [self.dataForNChart.chartDataForDrawing.allKeys count];
        }
        if (section==2) {
            return kcPredicitonNum;
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
        ((SliderCell*)cell).year.text=self.currentYear;
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *yearNumber = [f numberFromString:self.currentYear];
        ((SliderCell*)cell).yearSlider.value=[yearNumber floatValue];
        
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
        if (self.isAdded)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SwitchCell class])];
            ((SwitchCell*)cell).seriesName.text=[[self.chartTypeSeriesInfo objectForKey:self.chartType] objectAtIndex:indexPath.row];
           
        }
        else
        {
            NSArray* strKeys=@[kcPredictionBaseName,kcPredictionM1Name,kcPredictionM2Name];
            //NSDictionary* predictionItems=@{kcPredictionBaseName:[NSNumber numberWithFloat:250.0f],kcPredictionM1Name:[NSNumber numberWithFloat:1.0f],kcPredictionM2Name:[NSNumber numberWithFloat:1.0f]};
            NSDictionary* predictionRanges=@{kcPredictionBaseName:@[[NSNumber numberWithFloat:200.0f],[NSNumber numberWithFloat:300.0f]],kcPredictionM1Name:@[[NSNumber numberWithFloat:0.8f],[NSNumber numberWithFloat:1.2f]],kcPredictionM2Name:@[[NSNumber numberWithFloat:0.8f],[NSNumber numberWithFloat:1.2f]]};
            
            NSString* strKey=[strKeys objectAtIndex:indexPath.row];
            NSString* strName=[strKeys objectAtIndex:indexPath.row];
            cell= [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PredictionCellTableViewCell class])];
            ((PredictionCellTableViewCell*)cell).delegate=self;
            ((PredictionCellTableViewCell*)cell).predictionName.text=strName;
            float minVal=[[[predictionRanges valueForKey:strKey] objectAtIndex:0] floatValue];
            ((PredictionCellTableViewCell*)cell).predictionSlide.minimumValue=minVal;
            ((PredictionCellTableViewCell*)cell).predictionSlide.maximumValue=[[[predictionRanges valueForKey:strKey] objectAtIndex:1] floatValue];
            if (self.currentConfigs==nil) {
                ((PredictionCellTableViewCell*)cell).predictionSlide.value=minVal;
                ((PredictionCellTableViewCell*)cell).predictionValue.text=[NSString stringWithFormat:@"%.2f",minVal];
            }
            
            
            
            if (self.currentConfigs!=nil) {
                float val=[[self.currentConfigs objectAtIndex:indexPath.row] floatValue];
                ((PredictionCellTableViewCell*)cell).predictionSlide.value=val;
                ((PredictionCellTableViewCell*)cell).predictionValue.text=[NSString stringWithFormat:@"%.2f",val];
                
            }
            
            
        }
    }
    if (indexPath.section==3)
    {
        NSArray* strKeys=@[kcPredictionBaseName,kcPredictionM1Name,kcPredictionM2Name];
        //NSDictionary* predictionItems=@{kcPredictionBaseName:[NSNumber numberWithFloat:250.0f],kcPredictionM1Name:[NSNumber numberWithFloat:1.0f],kcPredictionM2Name:[NSNumber numberWithFloat:1.0f]};
        NSDictionary* predictionRanges=@{kcPredictionBaseName:@[[NSNumber numberWithFloat:200.0f],[NSNumber numberWithFloat:300.0f]],kcPredictionM1Name:@[[NSNumber numberWithFloat:0.8f],[NSNumber numberWithFloat:1.2f]],kcPredictionM2Name:@[[NSNumber numberWithFloat:0.8f],[NSNumber numberWithFloat:1.2f]]};
        
        NSString* strKey=[strKeys objectAtIndex:indexPath.row];
        NSString* strName=[strKeys objectAtIndex:indexPath.row];
        cell= [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PredictionCellTableViewCell class])];
        ((PredictionCellTableViewCell*)cell).delegate=self;
        ((PredictionCellTableViewCell*)cell).predictionName.text=strName;
        ((PredictionCellTableViewCell*)cell).predictionSlide.minimumValue=[[[predictionRanges valueForKey:strKey] objectAtIndex:0] floatValue];
        ((PredictionCellTableViewCell*)cell).predictionSlide.maximumValue=[[[predictionRanges valueForKey:strKey] objectAtIndex:1] floatValue];
        
        
        
        
        
        
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
    if (self.isAdded) {
        if (section==1) {
            return @"Series Types";
        }
        if (section==2) {
            return @"Series Names";
        }
        if (section==3) {
            return @"Motor Rating Config";
        }
    }
    else
    {
        if (section==1) {
            return @"Series Names";
        }
        if (section==2) {
            return @"Motor Rating Config";
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
        //self.coverView.hidden=NO;
        NChartDataModel* chartData=nil;
        if (cellView.accessoryType == UITableViewCellAccessoryNone)
        {
            cellView.accessoryType=UITableViewCellAccessoryCheckmark;
            self.chartType=cellView.textLabel.text;
            [self.configView reloadData];
        }
        for (int count=0; count<[self.chartTypeSeriesInfo.allKeys count]; count++)
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:1]];
            if (cell.accessoryType!=UITableViewCellAccessoryNone&&count!=indexPath.row)
            {
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            
        }
        if ([cellView.textLabel.text isEqualToString:@"COLUMN"])
        {
            chartData= [ChartDataManager templateColumnChartData:self.pageName];
        }
        if ([cellView.textLabel.text isEqualToString:@"BAR"])
        {
            chartData= [ChartDataManager templateBarChartData:self.pageName];

        }
        
        if ([cellView.textLabel.text isEqualToString:@"RADAR"])
        {
            chartData= [ChartDataManager templateRadarChartData:self.pageName];

        }
        if ([cellView.textLabel.text isEqualToString:@"AREA"])
        {
            chartData= [ChartDataManager templateAreaChartData:self.pageName];

            
        }
        self.dataForNChart=chartData;
    }
}

#pragma <SliderDelegate>
-(void)sliderValueChaged:(NSString*)newValue
{
    //NSLog(@"this is new value %@",newValue);
    self.dataForNChart.labelText=newValue;
    
    //if (![newValue isEqualToString:self.dataForNChart.labelText])
    {
        self.shouldDynamic=YES;
    }
    
    
    [self.collectionView reloadData];
    
    
    
}

#pragma <UINavigationBarDelegate>
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;//temporarily
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell=nil;
    //NChartDataModel* data=self.dataForNChart;
    if (self.dataForNChart==nil)
    {
        //if (self.isAdded)
        {
            cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GeneralCollectionViewCell class])  forIndexPath:indexPath];
            cell.backgroundColor=kcWidgetBackColor;
            return cell;
        }
        
    }
    else
    {
        NChartDataModel* chartData=self.dataForNChart;
        if (chartData.dataForNextView!=nil)
        {
            
            cell=(TwoViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TwoViewCell class]) forIndexPath:indexPath];
            ((TwoViewCell*)cell).yearLabel.text=chartData.labelText;
            ChildDetailChartViewController* itemViewController=[[ChildDetailChartViewController alloc] initWithDrawingData:chartData views:[NSArray arrayWithObjects:((TwoViewCell*)cell).chartView,((TwoViewCell*)cell).percentageView,nil] isAddedChart:self.shouldDynamic ];
                                                                
            [((TwoViewCell*)cell).chartView setupDelegate:itemViewController];
            ((TwoViewCell*)cell).percentageView.delegate=itemViewController;

            [self addChildViewController:itemViewController];
            [((TwoViewCell*)cell).contentView addSubview:itemViewController.view];
            [itemViewController didMoveToParentViewController:self];
            
        }
        else
        {
            if (chartData.floatingNumber!=nil)
            {
                cell=(OneViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([OneViewCell class]) forIndexPath:indexPath];
                ((OneViewCell*)cell).yearLabel.text=chartData.labelText;
                
                ChildDetailChartViewController* itemViewController=[[ChildDetailChartViewController alloc] initWithDrawingData:chartData views:[NSArray arrayWithObjects:((OneViewCell*)cell).chartView,nil] isAddedChart:self.shouldDynamic ];
                [((OneViewCell*)cell).chartView setupDelegate:itemViewController];
                
                [self addChildViewController:itemViewController];
                [((OneViewCell*)cell).contentView addSubview:itemViewController.view];
                [itemViewController didMoveToParentViewController:self];
            }
            else
            {
                cell=(NChartViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NChartViewCell class]) forIndexPath:indexPath];
                ((NChartViewCell*)cell).yearLabel.text=chartData.labelText;
                
                ChildDetailChartViewController* itemViewController=[[ChildDetailChartViewController alloc] initWithDrawingData:chartData views:[NSArray arrayWithObjects:((NChartViewCell*)cell).chartView,nil] isAddedChart:self.shouldDynamic ];
                [((NChartViewCell*)cell).chartView setupDelegate:itemViewController];
                [self addChildViewController:itemViewController];
                [((NChartViewCell*)cell).contentView addSubview:itemViewController.view];
                [itemViewController didMoveToParentViewController:self];
                
            }
            
        }
        
        
        
        
    }
    return cell;
    
    


}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    
}
- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setNeedsUpdateConstraints];
    
    NSLog(@"This is willDisplayCell ");
}




- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}
#pragma <PredictionViewDelegate>
-(void)saveConfig:(UIViewController*)vc
{
    self.predictionViewRate=0.22f;
    [UIView animateWithDuration:0.45 animations:^{
        [self viewDidLayoutSubviews];
    }];
    



}
-(ChartPrediction*)findChartprediction:(NSInteger)index data:(NSSet*)dataSet
{
    if (dataSet!=nil)
    {
        for (NSObject* o in dataSet) {
            if ([o isKindOfClass:[ChartPrediction class]]&&[((ChartPrediction*)o).key integerValue]==index)
            {
                return (ChartPrediction*)o;
                
            }
        }
        return nil;
    }
    return nil;
    
}

-(void)submitSuccessfully:(UIViewController *)vc
{
    if (self.isAdded) {
        self.predictionViewRate=0.1f;
        [UIView animateWithDuration:0.6 animations:^{
            [self viewDidLayoutSubviews];
        }];
    }
    
    if ([vc isKindOfClass:[PredictionConfigViewController class]])
    {
        for (UISwitch* s in ((PredictionConfigViewController*)vc).switchArray )
        {
            if (s.enabled&&s.on) {
                //NSString* strKey=[NSString stringWithFormat:@"%ld",(long)s.tag];
                NSNumber* key=[NSNumber numberWithInteger:s.tag];
                if(self.dataForNChart.prediction==nil)
                    self.dataForNChart.prediction=[NSMutableSet set];
                ChartPrediction* cp=nil;
                if ((cp=[self findChartprediction:s.tag data:self.dataForNChart.prediction])!=nil) {
                    cp.base=[NSNumber numberWithInt:self.base];
                    cp.mult2=[NSNumber numberWithFloat:self.multiplier2];
                    cp.mult1=[NSNumber numberWithFloat:self.multiplier1];
                    cp.key=key;
                }
                else
                {
                    cp=[[ChartPrediction alloc] init];
                    cp.base=[NSNumber numberWithInt:self.base];
                    cp.mult2=[NSNumber numberWithFloat:self.multiplier2];
                    cp.mult1=[NSNumber numberWithFloat:self.multiplier1];
                    cp.key=key;
                    [self.dataForNChart.prediction addObject:cp];
                }
                
                
                
                
                
                    
            }
        }
    }
    
    

//    NSError* error;
//    NSDictionary* dicData=[self.dataForNChart serializeToDicForJSON];
//    if([NSJSONSerialization isValidJSONObject:dicData])
//    {
//        NSData* jsonData=[NSJSONSerialization dataWithJSONObject:dicData  options:0 error:&error];
//        if (error!=nil)
//        {
//            NSLog(@"Converting to JSON data fail:%@",[error localizedDescription]);
//            
//           
//        }
//        /////////////////////////////sending the jsonData via Game Center- above code
//        /////////////////////////////receiving the jsonData via Game Center- following code
//        
//        
//        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
//        
//        if (error != nil)
//        {
//            NSLog(@"convert into JSON error: %@", [error localizedDescription]);
//            return;
//        }
//
//         NChartDataModel* dataForGame=[NChartDataModel deserializeFromJSON:jsonObject];
//
//    }
}
-(void)calculate:(UIViewController*)vc
{
    UICollectionViewFlowLayout* f=[[UICollectionViewFlowLayout alloc] init];
    
    f.scrollDirection=UICollectionViewScrollDirectionVertical;
    float cellHeight=self.flowLayout.itemSize.height;
    float cellWidth=self.flowLayout.itemSize.width;
    UIEdgeInsets inset=self.flowLayout.sectionInset;
    f.itemSize=CGSizeMake(cellWidth, cellHeight*0.5);
    f.sectionInset=inset;
    //DetailViewController* __weak weak_self=self;
    [self.collectionView setCollectionViewLayout:f animated:YES completion:^(BOOL finished) {
        
        //[weak_self.collectionView reloadData];

    }];
    
}
-(void)switch1On:(UIViewController*)vc config:(NSArray*)configData
{
    if ([self.childViewControllers containsObject:vc]) {
        self.currentConfigs=configData;
    }
    [self.configView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    
}
-(void)switch2On:(UIViewController*)vc config:(NSArray*)configData
{
     if ([self.childViewControllers containsObject:vc])
         self.currentConfigs=configData;
    
    [self.configView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone ];

}
#pragma <PredictionCellTableViewCellDelegate>
-(void)baseSlideValueChanged:(unsigned int)newValue
{
    self.base=newValue;
    

}
-(void)multiplier1SlideValueChanged:(float)newValue
{
    self.multiplier1=newValue;
}
-(void)multiplier2SlideValueChanged:(float)newValue
{
    self.multiplier2=newValue;
}


@end
