//
//  StatisticsPostWorker.h
//  E1
//
//  Created by Jack Lin on 18/10/2014.
//  Copyright (c) 2014 EY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPService.h"
@interface StatisticsPostWorker : NSObject <HTTPServiceDelegate>

- (void)startRequestStatistics;
- (void)cancelRequestStatistics;
@end
