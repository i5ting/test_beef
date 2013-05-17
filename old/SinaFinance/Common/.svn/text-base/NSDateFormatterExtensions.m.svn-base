
#import "NSDateFormatterExtensions.h"

@implementation NSDateFormatter (MyExtensions)

+(NSDateFormatter *)csvDateFormatter
{
    static NSDateFormatter *df = nil;
    if (!df) {
        df = [[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [df setDateFormat:@"yyyyMMdd"];
    }
    return df;
}

+(NSDateFormatter *)xmlDateFormatter
{
    static NSDateFormatter *df = nil;
    if (!df) {
        df = [[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [df setDateFormat:@"yyyy-MM-dd"];
    }
    return df;
}

+(NSDateFormatter *)dateTimeFormatter
{
    static NSDateFormatter *df = nil;
    if (!df) {
        df = [[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return df;
}


+(NSDateFormatter *)xmlTimeFormatter
{
    static NSDateFormatter *df = nil;
    if (!df) {
        df = [[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [df setDateFormat:@"HH:mm:ss"];
    }
    return df;
}

+(NSDateFormatter *)monthDateFormatter
{
    static NSDateFormatter *df = nil;
    if (!df) {
        df = [[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [df setDateFormat:@"yyyy-MM"];
    }
    return df;
}

+(NSDateFormatter *)dayDateFormatter
{
    static NSDateFormatter *df = nil;
    if (!df) {
        df = [[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [df setDateFormat:@"MM-dd"];
    }
    return df;
}

@end

