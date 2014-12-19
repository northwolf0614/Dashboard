//
//  Definations.h
//  E1
//
//  Created by Jack Lin on 20/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#ifndef E1_Definations_h
#define E1_Definations_h

extern BOOL isWhiteScheme;

#define kDefaultDistance 1000 //in meter

#define kcRequestComplete 200
#define kcUserCancel 800
#define kcExtentionCommandTooLong 700

#define kcURL @"http://aws.ey-tec.com/cc/service/statistics"
#define kcUserName @"su"
#define kcPassword @"gw"
#define kcHTTPBody @"{\"id\":\"2\",\"method\":\"getUserStatistics\",\"params\":[\"su\"],\"jsonrpc\":\"2.0\"}"

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kcProgress_Line_Width 10
#define kcTrack_LineE_Width 2
#define kcAnimationTime (kcTRANSITION_TIME+0.5)
#define kcMapViewAlpha 0.25

#define kReferenceToAnchorPointOfLayer CGPointMake(0, 0) //camera's positon with reference to anchor
#define kRotationAngle M_PI / 3.5
#define kDistanceFromCameraAndSurfaceOfZEqualToZero 200

#define kcDefaultShadowRadius 5
#define kcDefaultShadowOpacity 0.5
#define kcDefaultShadowOffset CGSizeMake(10, 10)

//#define GREEN_PLOT_IDENTIFIER       @"Green Plot"
#define kcQBE_Products_History @"QBE_Product_History"
#define kcQBE_Products_PieChart @"QBE Product Piechart"

#define kcPieChartRadius 50
#define kcCorePlotGraphPadding 10
#define kcPieChartTitleFontSize 10
#define UsingFileStoreData

             #define kcPagesArrayName @"QBEPagesArray724"
       #define kcDefaultChartName @"defaultNChartName724"
#define kcDefaultDataFielName @"kcDefaultDataFielName724.plist"
#define kcNchartViewlicense @"dxT1ldau+whHrwY2UJq0T7GC366XeRzCGd80oqM7LHQZkiJCGVvxvyg2GFAYDpes35YvxjrVYW0oJdMMovXfUFpxSUcjiT9Lw6VC+xRzBsCcn/BtVLJnz33N0I1cXnDTesrbeVnrV0O0vysqMINuADO4mFL6FAMm9fDN54RIR1ly5bOI52Yw/GUaD9xCD//jAVcZrNxJSOz6h4eyufeM7deCuihnf65Cxj6e5zgQ3J0JKvCiosdX40PqYx6FnWbHDKJ+/avpSicgJ4GaRIrhmDLPQmTZtnwnAmRp9e3nGJY9XHl1vj3tIZwQRvbzbHpMhW4FUGXsrVNe2zIwzKOj8mwFTnHVe5ILoeUUHg7+mhZmkuxsjZT/AIhVfFBaAo1h1ycd9L9SxUj5Pke/8VLJW0q+75oeFk7rh8WEf7NmvWP4I2dedzTpkCOiV1tM13UR43uhwleNNvDWkbJLespzj8+O1y6KwqB5SUM52a602SY5ZtSF6dlWb0CG3gr6usFayA7PPQn0YHqtyI7NjuJ5zS4fOw4VVAlVroNxCLv59AvEnNVeBq3i6Xni+Tky8CwVZfHJpkRORw5X2oTuKwQi98jT7t9UnAfmGtgj0NhOmpwYEJ28fvsg1cHLRMAnyoPMCvuwYtlJB/kdsPhF/gmve/Ef6MaRLvucKIjB2GYo5EA="

#define kcMinmumMarkSize 10
#define kcMaximumMarkSize 20

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kcLikeRed RGBA(238.0,46.0,90.0,1)
#define kcLikeBlue RGBA(129.0,207.0,224.0,1)
#define kcLikeOrange RGBA(236.0,150.0,48.0,1)
//#define kcLikeGray RGBA(47.0,45.0,55.0,1)
#define kcLikeGray [UIColor darkGrayColor]

#define kcWholeBackColor isWhiteScheme? RGBA(32.0,32.0,37.0,1):[UIColor whiteColor]
#define kcWidgetBackColor isWhiteScheme? RGBA(23.0,21.0,26.0,1):[UIColor whiteColor]
//#define kcNavigationBarColor isWhiteScheme? RGBA(23.0,21.0,26.0,1):RGBA(255.0,252.0,252.0,0.5)
//#define kcNavigationBarColor isWhiteScheme? RGBA(23.0,21.0,26.0,1):RGBA(223.0,223.0,223.0,0.3)
#define kcNavigationBarColor isWhiteScheme? RGBA(23.0,21.0,26.0,1):[UIColor whiteColor]


#define kcCharColor isWhiteScheme? RGBA(86.0,83.0,102.0,1):RGBA(86.0,83.0,102.0,1)
#define kcdetailViewConrtollerTableViewBackColor isWhiteScheme? RGBA(23.0,21.0,26.0,0.2):RGBA(223.0,223.0,223.0,0.3)
//#define kcWholeBackColor isWhiteScheme? [UIColor whiteColor]:RGBA(32.0,32.0,37.0,1)
//#define kcWidgetBackColor isWhiteScheme? [UIColor whiteColor]:RGBA(23.0,21.0,26.0,1)
//#define kcNavigationBarColor isWhiteScheme? [UIColor lightGrayColor]:RGBA(23.0,21.0,26.0,1)
//#define kcCharColor isWhiteScheme? RGBA(86.0,83.0,102.0,1):RGBA(86.0,83.0,102.0,1)

#define kcMasterTitle @"Page Navigation"
#define kcTRANSITION_TIME 1
#define kcControllerTransitionTime 0.45
#define KcPopoverWidth 256
#define kcMasterWidth 256
#define FontWithSize(s) /*[UIFont fontWithName:@"Helvetica" size:s]*/ [UIFont systemFontOfSize:s]
#define kcCollectionViewCellLHSpace 10
#define kcCollectionViewCellPHSpace 37
#define kcCollectionViewCellPVSpace 19
#define kcQBELogoMovingDistance -270
#define kcQBELoginBoxWidth 200
#define kcQBELoginBoxHeight 200
#define kcConstantSpace 20


#define kcPageTableCellHeight 44.0f
#define kcDefaultYear @"2014"

#define ARC4RANDOM_MAX      0x100000000





#endif





