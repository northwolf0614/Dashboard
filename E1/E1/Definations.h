//
//  Definations.h
//  E1
//
//  Created by Jack Lin on 20/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#ifndef E1_Definations_h
#define E1_Definations_h

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

             #define kcPagesArrayName @"QBEPagesArray549"
       #define kcDefaultChartName @"defaultNChartName549"
#define kcDefaultDataFielName @"kcDefaultDataFielName549.plist"
#define kcNchartViewlicense @"iQRg8UB5hqZL29rD54FU0+WsjCwkhO7bPEhpWYhLYXmkuiiS1KB59qPd8U2H+bJU6mdBscwqZzIcXRYyo7w4wdd7yUhZUYEoXfuK/XdiA3aBb8QM3MsFyocP7VDtcYF4B1rEVVmsor4JYaVXSonyDoLyvRn670fPQZd0ItllYoRtjF5oJv/NML7cqP5W/Cpro6eLn1u4onfo6xzGG/4Fs/B/rZtbOoQ9MFO1Q74Uj/aeTcnri5llWx071zURtL1L0e3COZ+oQ96xlPVZk2Cun0Lol0nyglf6C4RKifMbnCEtGRIL30aLMvKeC1JT8kc36xyLgpRYF4Ggrx8EY+PwbYxBOmkt1i8JJNrFThUs1DMDGBw0sA51CTNu4SIGgUDVjMBZZFrECvjzrwhkdTjBEXXLxFAEhm5ApsTxiKvdFIiqISHMtQGtcMnh5oIBszO1ucGzPH3kweyTY8jAfqunDw2+vLXgsR+BxpCoBcHwd6Tb8HcVd0TB2J6jeMEmjLOwIYE64mPPcI9rcWdbQ0fBcmAiTAzsc2TcQDSVgH2pRhKf1QzBxnyls1GXsVoFqRoRsqalwFLzOqnU6ZByftHJdI6W8CRjb0Yl54TS3I0BlvURShYyCfzkQEC+QZ4+xmCpOFtBIcbITN8NK5h5NtA3C9EkiMH4p9gurIsIofAssOM="

//#define kcMiddleLabelSize 80
//#define kcMiddleLabelXAlignmentAdjustment 70
//#define kcMiddleLabelYAlignmentAdjustment 100
#define kcMinmumMarkSize 10
#define kcMaximumMarkSize 20

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kcLikeRed RGBA(238.0,46.0,90.0,1)
#define kcLikeBlue RGBA(129.0,207.0,224.0,1)
#define kcLikeOrange RGBA(236.0,150.0,48.0,1)
#define kcWholeBackColor RGBA(32.0,32.0,37.0,1)
#define kcWidgetBackColor RGBA(23.0,21.0,26.0,1)
#define kcLikeGray RGBA(47.0,45.0,55.0,1)
#define kcCharColor RGBA(86.0,83.0,102.0,1)
#define kcMasterTitle @"Page Navigation"
#define kcTRANSITION_TIME 1
#define kcControllerTransitionTime 0.45

#define kcMasterWidth 256

#define FontWithSize(s) /*[UIFont fontWithName:@"Helvetica" size:s]*/ [UIFont systemFontOfSize:s]

#define kcPageTableCellHeight 44.0f

#endif





