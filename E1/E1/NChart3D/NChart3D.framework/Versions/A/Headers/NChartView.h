/**
 * This file is the part of NChart3D Framework
 * http://www.nchart3d.com
 *
 * File: NChartView.h
 * Version: "1.7.1"
 *
 * Copyright (C) 2014 Nulana LTD. All Rights Reserved.
 */

#import <UIKit/UIKit.h>
#import "NChart.h"


/**
 * The NChartView class provides a view to display the chart. This view can be added anywhere to view the hierarchy of
 * the app.
 */
@interface NChartView : UIView

/**
 * Get chart instance. It is created with the view's creation and destroyed with its destruction.
 * @see NChart.
 */
@property (nonatomic, readonly) NChart *chart;

/**
 * Flag determining if view is allowed to recreate internal rendering data structures (YES) or not (NO). The deafult
 * value is YES.
 * @discussion Use this flag to temporary lock the updating of the view. You may need to lock it (by setting NO to this
 * poperty) in viewWillDisappear of your view controller and unlock it (by setting YES) in viewWillAppear. This kind of
 * locking helps to avoid troubles related to the updating of invisible OpenGLES-based views (because in iOS 8+ such
 * updating leads to OpenGLES crash).
 */
@property (nonatomic, assign) BOOL isUpdatingEnabled;

@end
