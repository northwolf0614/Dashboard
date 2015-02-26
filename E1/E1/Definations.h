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


#define kcPagesArrayName @"QBEPagesArray793"

#define kcDefaultPageName @"defaultPageName778"
#define kcDataBaseFileName @"chartsDataBase778.sqlite"
#define kcNchartViewlicense @"f2P07zYKnHZTMfHyw4GTZxEMUqhzjQXDtUgVVMxrJJdxGsTqULDIDJlLrm7PZKeOvenH48E91ge9Swvkq5NEt0hJ1C13CHxLRDYtHeSm2eFiVW6M1RCZcsQnjGIOqAJ1jEkKy9k5vWCC39+3Dxg6HRH20owiMPBx2sWxM2C4Q13MRQNxBCYljQP5exUEab2fcAMsBYJNa/3GzVmZYeT40MVLw2w5C5WeSKkvfDjHRyLo4f9kYELsXrCEYNdF+4/BYfX4Ofi698WIThR7GL726s+NHkz1tAuP2Aeho2nuwiQU4/SYLnRZVZmUTIQTk95i3JUugGIou9fJU2S7/Jd34xJ46jnbQAmfQsEoiSSA9xn5mArl7Xx8KpL+bCBHzidggCDVWNaBauXTg0teYwFMJUcDL008nPyE4T5/nAon78t+5eHlPhijtnpCugFAKIfaeEhhomkcUwX7GTQPmW6wLxUY0lKTAXUlMVQFhY+A+ZB6olVw40LiAqufUryFl2iODP4n61/Zpzyva6+nbfx2wUsJG3vLZATG/5K0MlV0AAcpTUQjJghz7nEHmUlw4V7Mo1948QEkDIx3rO1h650LcWgF1PDsc93daC77qjkwG6z5/21XK+mCvZk7y7uDqzoMsRWBYqjBGHNFt0RYbqn6BX6U3JrNI3IXbmEaB3H7YeI="


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
#define kcTRANSITION_TIME 0.85
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
#define kcMaxCellsinOneScreen 6

#define kcCellWidth 328
#define kcCellHeight 365

#define kcOffsetBuffer 100




#endif





