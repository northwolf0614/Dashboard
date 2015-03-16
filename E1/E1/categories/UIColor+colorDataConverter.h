
#import <Foundation/Foundation.h>

@interface UIColor (colorDataConverter)
-(NSArray*)converToArray;
-(UIColor*)restoreFromArray:(NSArray*)colorArray;
@end