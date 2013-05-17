//
//  Util.h
//  SinaFinance
//
//  Created by Du Dan on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


//#define K	(1024)
//#define M	(K * 1024)
//#define G	(M * 1024)
//

@interface Util : NSObject

+ (NSString*)convertToSHA1:(NSString*)input;
+ (NSString *)md5:(NSString *)str;
+ (NSString*)decodeUTF8String:(NSString*)encodedString;
+(NSDate *)NSStringDateToNSDate:(NSString *)string;
+ (NSString*)constructSymbol:(NSArray*)symbols;
+ (NSString*)formatBigNumber:(NSString*)numString;
+(NSString *)urlencode: (NSString *)url;
+(NSString*)formatNullString:(NSString*)inputStr;
+ (unsigned long long)roundLargeNumber:(double)num;
+ (NSDictionary*)adjustExtValue:(double)max min:(double)min isVolume:(BOOL)isVolume;


+(NSString *)get_push_has_readed_file_name;
+(NSString *)get_tixing_has_readed_file_name;

+(NSString *)get_push_tixing_table_name;

+(void)set_refresh_btn_bg_png:(UIButton *)refreshBtn;

+ (NSString *)number2String:(int64_t)n;


/**
 dump dictionary
 */
+(void)dumpDictionary:(NSDictionary *)dict;


+(NSArray *)sort:(NSArray *)data key:(NSString *)k type:(NSString *)t;

/**
沪市A股(988只）：sh60XXXX
深市A股(1566只)：sz300XXX
sz00XXXX
沪市B股(55只)：sh9009XX
深市B股(59只)：sz200XXX
美股的代码是字母,简称有中文和英文
 */
+(NSString *)get_total_symbol_string:(NSString *)pre_str;


@end


/**

#import <mach/mach_time.h>
@interface CalculateRunTime : NSObject
CGFloat BUNRTimeBlock (void (^block)(void));
@end



@implementation CalculateRunTime
CGFloat BNRTimeBlock (void (^block)(void)) {
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return -1.0;
    uint64_t start = mach_absolute_time ();    //开始时间
    block ();
    uint64_t end = mach_absolute_time ();     //结束时间
    uint64_t elapsed = end - start;
    uint64_t nanos = elapsed * info.numer / info.denom;
    NSLog(@"代码执行时间:%f",(CGFloat)nanos / NSEC_PER_SEC);
    return (CGFloat)nanos / NSEC_PER_SEC;
}
@end

*/