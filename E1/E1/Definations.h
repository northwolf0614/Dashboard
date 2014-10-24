//
//  Definations.h
//  E1
//
//  Created by Jack Lin on 20/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#ifndef E1_Definations_h
#define E1_Definations_h

#define kDefaultDistance                     1000//in meter

#define kcRequestComplete 200
#define kcUserCancel 800
#define kcExtentionCommandTooLong 700

#define kcURL @"http://aws.ey-tec.com/cc/service/statistics"
#define kcUserName @"su"
#define kcPassword @"gw"
#define kcHTTPBody @"{\"id\":\"2\",\"method\":\"getUserStatistics\",\"params\":[\"su\"],\"jsonrpc\":\"2.0\"}"

#define degreesToRadians(x) (M_PI*(x)/180.0)
#define kcProgress_Line_Width 10
#define kcTrack_LineE_Width 2
#define kcAnimationTime 0.8
#define kcMapViewAlpha 0.25

#define kReferenceToAnchorPointOfLayer CGPointMake(0,0)//camera's positon with reference to anchor
#define kRotationAngle M_PI/3
#define kDistanceFromCameraAndSurfaceOfZEqualToZero 200

#define kcDefaultShadowRadius 5
#define kcDefaultShadowOpacity 0.5
#define kcDefaultShadowOffset CGSizeMake(10,10)

#define GREEN_PLOT_IDENTIFIER       @"Green Plot"
#define BLUE_PLOT_IDENTIFIER        @"Blue Plot"


#endif
