//
//  ChartDataAdapter.h
//  E1
//
//  Created by Jack Lin on 10/11/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import "NChartDataModel.h"

@interface ChartDataAdapter : NChartDataModel
@property(nonatomic,copy) NSString* floatingNumber;
+(ChartDataAdapter*)AdaptedData:(NChartDataModel*)primitiveData;
@end
