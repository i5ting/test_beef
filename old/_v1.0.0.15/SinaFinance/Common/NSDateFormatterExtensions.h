
#import <Foundation/Foundation.h>

@interface NSDateFormatter (MyExtensions)

+(NSDateFormatter *)csvDateFormatter;
+(NSDateFormatter *)xmlDateFormatter;
+(NSDateFormatter *)xmlTimeFormatter;
+(NSDateFormatter *)dateTimeFormatter;
+(NSDateFormatter *)monthDateFormatter;
+(NSDateFormatter *)dayDateFormatter;

@end

