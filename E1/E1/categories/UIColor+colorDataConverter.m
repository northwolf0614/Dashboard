
#import "UIColor+colorDataConverter.h"

@implementation UIColor (colorDataConverter)
-(NSArray*)converToArray
{
    CGFloat red, green, blue, alpha;
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    NSArray* array=[NSArray arrayWithObjects:[NSNumber numberWithFloat:red],[NSNumber numberWithFloat:green],[NSNumber numberWithFloat:blue],[NSNumber numberWithFloat:alpha], nil];
    return array;
    
    
}



-(UIColor*)restoreFromArray:(NSArray*)colorArray
{
    
    
    
    UIColor* color=[UIColor colorWithRed:[((NSNumber*)colorArray[0]) floatValue] green:[((NSNumber*)colorArray[1]) floatValue] blue:[((NSNumber*)colorArray[2]) floatValue] alpha:[((NSNumber*)colorArray[3]) floatValue]];
    return color;
    
    
}
@end
