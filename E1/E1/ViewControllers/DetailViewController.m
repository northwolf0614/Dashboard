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


@interface DetailViewController ()

@property(nonatomic,strong) UITableView* configView;
@property(nonatomic,strong) NSDictionary* chartTypeSeriesInfo;
@property(nonatomic,strong) NSString* chartType;
@property(nonatomic,strong) NSString* currentYear;
@property(nonatomic,strong) NChartDataModel* chartDataBack;
@property(nonatomic,assign) BOOL isAdded;

@property(nonatomic,strong) UIView* coverView;
@property(nonatomic,strong) UICollectionView* collectionView;
@property(nonatomic,strong) UICollectionViewFlowLayout* flowLayout;
@end

@implementation DetailViewController

- (NSUInteger)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskLandscape;
}
-(id)initWithDrawingData:(NChartDataModel*)drawingData  isAddedChart:(BOOL)isAdded
{
    NSLog(@"This is initWithDrawingData in GerneralChartViewController");
    if (self=[super init])
    {
        if (drawingData!=nil)
        {
            self.dataForNChart=drawingData;
        }
        self.isAdded=isAdded;
        
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


}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
}
-(void)initialization
{
    self.chartTypeSeriesInfo=@{@"BAR":@[@"In call",@"Inactive"],@"COLUMN":@[@"Closed",@"Opened",@"Active"],@"RADAR":@[@"Converted",@"Quoted"],@"AREA":@[@"Bind",@"Quoted",@"EStimate"]};
    if (self.dataForNChart!=nil) {
        self.currentYear=self.dataForNChart.labelText;
    }
    else
        self.currentYear=@"2014";
    
    
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
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DetailViewController class]) owner:self options:nil];
    self.view = [nibs objectAtIndex:0];
    
    NSArray *nibs1 = [[NSBundle mainBundle] loadNibNamed:@"coverView" owner:self options:nil];
    self.coverView = [nibs1 objectAtIndex:0];
    self.coverView.backgroundColor=[UIColor clearColor];
    
    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSUInteger sizebuffer=20;
    NSUInteger width= self.chartViewContainer.frame.size.width;
    NSUInteger height= self.chartViewContainer.frame.size.height;
    NSNumber* widthForCollectionView=[NSNumber numberWithInt:((int)((width*2)/3))];
    NSNumber* heightForCollectionView=[NSNumber numberWithInt:((int)(height))];
    NSUInteger cellWidth=[widthForCollectionView integerValue]-2*sizebuffer;
    NSUInteger cellHeight=[heightForCollectionView integerValue]*0.5-2*sizebuffer;
    self.flowLayout.itemSize=CGSizeMake(cellWidth,cellHeight);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(sizebuffer,sizebuffer,sizebuffer,sizebuffer);
    NSArray* constraints=[self.chartViewContainer constraints];
    if ([constraints count]>0)
    {
        [self.chartViewContainer removeConstraints:constraints];
    }
    
    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chartView(width)]-0-[tableView]-0-|" options:0 metrics:@{ @"width" :widthForCollectionView } views:@{ @"chartView" : self.collectionView,@"tableView":self.configView }]];
    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chartView]-0-|" options:0 metrics:@{ @"width" :widthForCollectionView } views:@{ @"chartView" : self.collectionView,@"tableView":self.configView }]];
    [self.chartViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-|" options:0 metrics:@{ @"width" :widthForCollectionView } views:@{ @"chartView" : self.collectionView,@"tableView":self.configView }]];
    
    [self.chartViewContainer setNeedsUpdateConstraints];
    [self.chartViewContainer updateConstraintsIfNeeded];
    
    
}



#pragma <UITableViewDataSource>
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
            chartData= [ChartDataManager templateColumnChartData];
        }
        if ([cellView.textLabel.text isEqualToString:@"BAR"])
        {
            chartData= [ChartDataManager templateBarChartData];

        }
        
        if ([cellView.textLabel.text isEqualToString:@"RADAR"])
        {
            chartData= [ChartDataManager templateRadarChartData];

        }
        if ([cellView.textLabel.text isEqualToString:@"AREA"])
        {
            chartData= [ChartDataManager templateAreaChartData];

            
        }
        self.dataForNChart=chartData;
    }
}

#pragma <SliderDelegate>
-(void)sliderValueChaged:(NSString*)newValue
{
    NSLog(@"this is new value %@",newValue);
    [UIView animateWithDuration:0.45 animations:^{
        self.coverView.alpha=0.0f;
    }];
    self.dataForNChart.labelText=newValue;
    
    //if (![newValue isEqualToString:self.dataForNChart.labelText])
    {
        self.isAdded=YES;
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
            ChildDetailChartViewController* itemViewController=[[ChildDetailChartViewController alloc] initWithDrawingData:chartData views:[NSArray arrayWithObjects:((TwoViewCell*)cell).chartView,((TwoViewCell*)cell).percentageView,nil] isAddedChart:self.isAdded ];
                                                                
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
                
                ChildDetailChartViewController* itemViewController=[[ChildDetailChartViewController alloc] initWithDrawingData:chartData views:[NSArray arrayWithObjects:((OneViewCell*)cell).chartView,nil] isAddedChart:self.isAdded ];
                [((OneViewCell*)cell).chartView setupDelegate:itemViewController];
                
                [self addChildViewController:itemViewController];
                [((OneViewCell*)cell).contentView addSubview:itemViewController.view];
                [itemViewController didMoveToParentViewController:self];
            }
            else
            {
                cell=(NChartViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NChartViewCell class]) forIndexPath:indexPath];
                ((NChartViewCell*)cell).yearLabel.text=chartData.labelText;
                
                ChildDetailChartViewController* itemViewController=[[ChildDetailChartViewController alloc] initWithDrawingData:chartData views:[NSArray arrayWithObjects:((NChartViewCell*)cell).chartView,nil] isAddedChart:self.isAdded ];
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
    
    NSLog(@"This is willDisplayCell ");
}




- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}




@end
