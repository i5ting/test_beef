//
//  Util.m
//  SinaFinance
//
//  Created by Du Dan on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Util.h"
#import "ShareData.h"

@implementation Util

+ (NSString*)convertToSHA1:(NSString*)input
{
    
    NSData *data = [input dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

+ (NSString *)md5:(NSString *)str { 
    const char *cStr = [str UTF8String]; 
    unsigned char result[32]; 
    CC_MD5( cStr, strlen(cStr), result ); 
    return [NSString stringWithFormat: 
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7], 
            result[8], result[9], result[10], result[11], 
            result[12], result[13], result[14], result[15] 
            ]; 
}

+ (NSString*)decodeUTF8String:(NSString*)encodedString
{
    NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return decodedString;
}


//#define kDEFAULT_DATE_TIME_FORMAT (@"eee, dd MMM yyyy HH:mm:ss ZZZ")
#define kDEFAULT_DATE_TIME_FORMAT (@"eee, dd MMM yyyy HH:mm:ss ZZZZ")
+(NSDate *)NSStringDateToNSDate:(NSString *)string {    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    NSDate *date = [formatter dateFromString:string];
    
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate:date];
    NSDate *bjdate = [NSDate dateWithTimeInterval: seconds sinceDate:date];
    
    [formatter release];
    return bjdate;
}

+ (NSString*)constructSymbol:(NSArray*)symbols
{
    NSString *symbolString = [[[NSString alloc] init] autorelease];
    int count = symbols.count;
    for(int i = 0; i < count - 1; i++){
        symbolString = [symbolString stringByAppendingFormat:@"%@,",[symbols objectAtIndex:i]];
    }
    symbolString = [symbolString stringByAppendingFormat:@"%@",[symbols lastObject]];
    return symbolString;
}

+ (BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string]; 
    
    int val; 
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}

+ (BOOL)isPureFloat:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string]; 
    
    float val; 
    
    return [scan scanFloat:&val] && [scan isAtEnd];
}

+ (BOOL)isDigtal:(NSString *)string
{
    BOOL rtval = NO;
    if (string&&[string length]>0) {
        if ([self isPureInt:string]) {
            rtval = YES;
        }
        else if([self isPureFloat:string])
        {
            rtval = YES;
        }
    }
    
    return rtval;
}

+ (NSString*)formatBigNumber:(NSString*)numString
{
    BOOL isDigtal = [Util isDigtal:numString];
    NSString* suffixStr = @"";
    while (!isDigtal&&[numString length]>0) {
        NSString* thisString = [numString substringFromIndex:[numString length]-1];
        numString = [numString substringToIndex:[numString length]-1];
        suffixStr = [thisString stringByAppendingString:suffixStr];
        isDigtal = [Util isDigtal:numString];
    }
    NSString *outputString = @"";
    if (numString&&[numString length]>0) {
        float number = [numString floatValue];
        const long long int billion = 100000000;//8E+1;
        const long long int million = 1000000;//6E+1;
        const long int tenthousand = 10000;//4E+1;
        if(number - billion > 0){
            outputString = [NSString stringWithFormat:@"%.02f亿",number / billion];
        }
        else if(number - tenthousand > 0){
            outputString = [NSString stringWithFormat:@"%.02f万",number / tenthousand];
        }
        else{
            outputString = [NSString stringWithFormat:@"%@", [Util formatNullString: numString]];
        }
        //    NSLog(@"outputString: %@", outputString);
    }
    if (suffixStr) {
        if (![outputString hasSuffix:suffixStr]) {
            outputString = [outputString stringByAppendingString:suffixStr];
        }
    }
    return outputString;
}

+(NSString *)urlencode: (NSString *)url
{
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                            @"@" , @"&" , @"=" , @"+" ,
                            @"$" , @"," , @"[" , @"]",
                            @"#", @"!", @"'", @"(", 
                            @")", @"*", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
                             @"%3A" , @"%40" , @"%26" ,
                             @"%3D" , @"%2B" , @"%24" ,
                             @"%2C" , @"%5B" , @"%5D", 
                             @"%23", @"%21", @"%27",
                             @"%28", @"%29", @"%2A", nil];
    
    int len = [escapeChars count];
    
    NSMutableString *temp = [url mutableCopy];
    
    int i;
    for(i = 0; i < len; i++)
    {
        
        [temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    
    NSString *out = [NSString stringWithString: temp];
    
    return out;
}

+(NSString*)formatNullString:(NSString*)inputStr
{
    if(inputStr){
        return [NSString stringWithFormat:@"%@", inputStr];
    }
    return @"";
}

#pragma mark
#pragma mark For Handling Chart Ticks' Values
+ (BOOL)notRightNum:(double)number
{
//    NSLog(@"not a right num passed in:%f",number);
    unsigned int tempH = (unsigned int)round(number * 100);
//    NSLog(@"tempH:%d,%d",tempH,3%100);
    if(tempH % 100 != 0){ //Not an integer
        if(tempH % 10 == 0){
            tempH /= 10;
        }
        if(tempH % 5 != 0 && tempH % 2 != 0){
//            NSLog(@"%f not a right night",number);
            return true;
        }
    }
//    NSLog(@"%f is a right number",number);
    return false;
}

+ (unsigned int)narrowCount:(unsigned int)count isVolume:(BOOL)isVolume
{
    if(isVolume){
        while (count > 4) {
            if(count % 2 == 0){
                count /= 2;
            }
            else if(count % 3 == 0){
                count /= 3;
            }
            else break;
        }
    }
    else{
        if(count > 7){
            if(count % 3 == 0){
                count /= 3;
            }
            else if(count % 4 == 0){
                count /= 4;
            }
            else if(count % 2 == 0){
                count /= 2;
            }
        }
    }
    //    NSLog(@"======================%d",count);
    return count;
}

+ (NSDictionary*)adjustExtValue:(double)max min:(double)min isVolume:(BOOL)isVolume
{
    NSLog(@"passed in:%f,%f",max,min);
    //    NSMutableArray *countArr = [[[NSMutableArray alloc] init] autorelease];
    double asEqual = -0.000001;
    
    double mediant = (max + min) / 2;
    
    NSArray *countArr = nil;
    if(isVolume){
        countArr = [NSArray arrayWithObjects:[NSNumber numberWithInt: 4],
                    //[NSNumber numberWithInt: 5],
                    //[NSNumber numberWithInt: 6],
                    //[NSNumber numberWithInt: 7],
                    //[NSNumber numberWithInt: 8],
                    //[NSNumber numberWithInt: 9],
                    //[NSNumber numberWithInt: 10],
                    //[NSNumber numberWithInt: 12],
                    //[NSNumber numberWithInt: 14],
                    //[NSNumber numberWithInt: 15],
                    //[NSNumber numberWithInt: 16],
                    //[NSNumber numberWithInt: 18],
                    //[NSNumber numberWithInt: 20], 
                    nil];
    }
    else{
        countArr = [NSArray arrayWithObjects:[NSNumber numberWithInt: 4],
                         [NSNumber numberWithInt: 5],
                         [NSNumber numberWithInt: 6],
                         //[NSNumber numberWithInt: 7],
//                         [NSNumber numberWithInt: 8],
                         [NSNumber numberWithInt: 9],
                         [NSNumber numberWithInt: 10],
                         [NSNumber numberWithInt: 12],
                         //[NSNumber numberWithInt: 14],
                         [NSNumber numberWithInt: 15],
                         [NSNumber numberWithInt: 16],
                         [NSNumber numberWithInt: 18],
                         [NSNumber numberWithInt: 20], nil];
    }
    NSArray *stepNumArr = [NSArray arrayWithObjects:[NSNumber numberWithInt: 1],
                           [NSNumber numberWithInt: 2],
                           //[NSNumber numberWithInt: 3],
                           [NSNumber numberWithInt: 4],
                           [NSNumber numberWithInt: 5],
                           [NSNumber numberWithInt: 6],
                           [NSNumber numberWithInt: 8],nil];
    //    unsigned int countArr[] = {4,5,6,7,8,9,10,12,14,15,16,18,20};
    //    unsigned int stepNumArr[] = {1,2,3,4,5,6,8};
    
    BOOL gotResult = NO;
    float realStep;
    float base;
    float high;
    float low;
    float selectedMax;
    float selectedMin;
    float distance;
    float step;
    //    float range;
    NSNumber *range = nil;
    NSInteger count = 0;
    NSString *highStr;
    NSString *lowStr;
    //    NSInteger roun = 2;
    
    for(NSNumber *ct in countArr){
        distance = (max - min) / [ct intValue];
        gotResult = NO;
        step = pow(10, -2);
        
        while(!gotResult){
            for(NSNumber *num in stepNumArr){
                //                NSLog(@"count: %d", count);
                realStep = step * [num intValue];
                if(realStep - distance > asEqual){
                    //if(realStep > distance){
                    if([ct intValue] % 2 == 0){ //Even
                        base = round(mediant / realStep) * realStep;
                        highStr = [NSString stringWithFormat:@"%.05f", base + [ct intValue]/ 2 * realStep];
                        lowStr = [NSString stringWithFormat:@"%.05f", base - [ct intValue]/ 2 * realStep];
                    }
                    else{ //Odd
                        base = round((mediant + realStep/2)/realStep) * realStep;
                        highStr = [NSString stringWithFormat:@"%.05f", base + ([ct intValue] - 1)/ 2 * realStep];
                        lowStr = [NSString stringWithFormat:@"%.05f", base - ([ct intValue] + 1)/ 2 * realStep];
                    }
                    high = [highStr doubleValue];
                    low = [lowStr doubleValue];
                    
                    if(high - max > asEqual && low - min < asEqual){
                        gotResult = YES;
                        if(low < 0){
                            high -= low;
                            low = 0;
                        }
                        if(!isVolume){
//                            NSLog(@"count: %@,high: %f   low: %f",ct, high, low);
                        }

                        if(!range){
                            range = [NSNumber numberWithFloat: high - low];
                            selectedMax = high;
                            selectedMin = low;
                            count = [ct intValue];
                            
//                            NSLog(@"first high: %f   low: %f by %d", high, low,count);
                            break;
                        }
                        
                        float temp = (high - low) / [Util narrowCount:[ct intValue] isVolume:isVolume];
                        if(round(temp * 100) != 1 && round(temp * 10) != 1){
                            if([self notRightNum:temp]){
//                                NSLog(@"odd gap");
                                break;
                            }
                        }
                        
                        if(high - low > [range floatValue]){
//                            NSLog(@"not a closer range");
                            break;
                        }
                        else if(high - low == [range floatValue]){
//                            NSLog(@"same range");
                            float maxOffset = selectedMax - max;
                            float minOffset = min - selectedMin;
                            float oldOffset = abs(maxOffset - minOffset);
//                            NSLog(@"old offset:%f",oldOffset);
                            maxOffset = high - max;
                            minOffset = min - low;
                            float newOffset = abs(maxOffset - minOffset);
//                            NSLog(@"new offset:%f",newOffset);
                            if(newOffset >= oldOffset){
//                                NSLog(@"use former one");
                                break;
                            }
                            else if(newOffset == oldOffset && count == 4){
//                                NSLog(@"ignore first");
                            }
                        }
                        if([self notRightNum:high] || [self notRightNum:low])
                            break;
                        
                        range = [NSNumber numberWithFloat: high - low];
                        selectedMax = high;
                        selectedMin = low;
                        count = [ct intValue];
//                        NSLog(@"new selected:%f,%f,by %d",selectedMax,selectedMin,count);
                        //                        NSLog(@"count: %d", count);
                        break;
                    }
                }
            }
            step *= 10;
        }
    }
    unsigned int newcount = [self narrowCount:count isVolume:isVolume];
    //    high = [self roundFloatNumber:high];
    //    low = [self roundFloatNumber:low];
//    NSLog(@"##############%f,%f",selectedMax,selectedMin);
//    NSLog(@"finally %f,%f,%d",selectedMax,selectedMin,newcount);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:selectedMax],@"high",
                          [NSNumber numberWithFloat:selectedMin], @"low",
                          [NSNumber numberWithInt:newcount], @"count",
                          nil];
    return dict;
}

#pragma mark - push has readed file utils
/**
 * 要闻推送
 */
+(NSString *)get_push_has_readed_file_name{
    NSString *retStr = [NSString  stringWithFormat:@"%@",@"remindnews"];
    return retStr;
}

/**
 * 提醒推送 
 由于提醒要区分用户，所以增加了loginID
 */
+(NSString *)get_tixing_has_readed_file_name{
    NSString *retStr = [NSString  stringWithFormat:@"%@",@"apsdatalisttable"];
    
    NSString* loginID = [[WeiboLoginManager getInstance] loginedID];
    if (loginID) {
        retStr = [retStr stringByAppendingFormat:@"_%@",loginID];
    }
    
    return retStr;
}

#define K	(1024)
#define M	(K * 1024)
#define G	(M * 1024)



+ (NSString *)number2String:(int64_t)n
{
	if ( n < K )
	{
		return [NSString stringWithFormat:@"%dB", n];
	}
	else if ( n < M )
	{
		return [NSString stringWithFormat:@"%.2fK", (float)n / (float)K];
	}
	else if ( n < G )
	{
		return [NSString stringWithFormat:@"%.2fM", (float)n / (float)M];
	}
	else
	{
		return [NSString stringWithFormat:@"%.2fG", (float)n / (float)G];
	}
}



#pragma mark - push table utils
/**
 * 这样定义，主要是推送消息和用户id有关联关系，不然用户切换的时候会有bug
 * 只有提醒表需要这样做，要闻推送是不需要的。
 */
+(NSString *)get_push_tixing_table_name{
    NSString *retStr = [NSString  stringWithFormat:@"%@",@"apsdatalisttable"];
    
    NSString* loginID = [[WeiboLoginManager getInstance] loginedID];
    if (loginID) {
        retStr = [retStr stringByAppendingFormat:@"_%@",loginID];
    }
    
    return retStr;
}


+(void)set_refresh_btn_bg_png:(UIButton *)refreshBtn{
    NSTimeInterval refreshInterval = [[ShareData sharedManager] refreshInterval];

    
    NSString *btn_bg_pic_name = @"refresh_btn.png";
    
    if (refreshInterval == 15.0) {
        btn_bg_pic_name = @"refresh_btn_15.png";
    }
    
    if (refreshInterval == 30.0) {
        btn_bg_pic_name = @"refresh_btn_30.png";
    }
    
    if (refreshInterval == 60.0) {
        btn_bg_pic_name = @"refresh_btn_60.png";
    }
    
    [refreshBtn setImage:[UIImage imageNamed: btn_bg_pic_name] forState:UIControlStateNormal];
}


+(void)dumpDictionary:(NSDictionary *)dict
{
    NSArray *keys;
    int i, count;
    id key, value;
    
    keys = [dict allKeys];
    count = [keys count];
    for (i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [dict objectForKey: key];
        NSLog (@"Key: %@ for value: %@", key, value);
    }
}

/**
 *
 *
 NSArray *arr = @[@{@"index" : @"3%", @"key" : @"value"},
 @{@"index" : @"14%", @"key" : @"value"},
 @{@"index" : @"1%", @"key" : @"value"},
 @{@"index" : @"2%", @"key" : @"value"}];
 
 NSLog(@"%@",arr);
 
 
 
 BNRTimeBlock (^{
 //这里执行你的代码
 [self sort2:arr key:@"index" type:@"asc"];
 });
 
 BNRTimeBlock (^{
 //这里执行你的代码
 [self sort2:arr key:@"index" type:@"desc"];
 });
 
 
 *
 */
+(NSArray *)sort:(NSArray *)data key:(NSString *)k type:(NSString *)t{

    
    NSArray *sortedArray;
    sortedArray = [data sortedArrayUsingComparator:(NSComparator)^(id a, id b) {
        
        NSString *f1 = [[a objectForKey:k] stringByReplacingOccurrencesOfString:@"%" withString:@""];
        double value1 = [f1 doubleValue];
        
        NSString *f2 = [[b objectForKey:k] stringByReplacingOccurrencesOfString:@"%" withString:@""];
        double value2 = [f2 doubleValue];
        
        NSNumber *num1 = [NSNumber numberWithDouble:value1];
        NSNumber *num2 = [NSNumber numberWithDouble:value2];
        
        return [num1 compare:num2];
    }];
    
    
    
    if ([t isEqualToString:@"asc"]) {
        NSLog(@"asc %@",sortedArray);
        return sortedArray;
    }
    
    NSMutableArray *ret = [NSMutableArray array];
    for (int i = [sortedArray count]-1; i>=00; i--) {
        [ret addObject:[sortedArray objectAtIndex:i]];
    }
    NSLog(@"desc %@",ret);
    
    return ret;
}

/**
 沪市A股(988只）：sh60XXXX
 深市A股(1566只)：sz300XXX
                sz00XXXX
 沪市B股(55只)：sh9009XX
 深市B股(59只)：sz200XXX
 美股的代码是字母,简称有中文和英文
 */
+(NSString *)get_total_symbol_string:(NSString *)pre_str{
    NSString *str = pre_str;
    
    //如果确定已有sh或sz就不用处理了
    if ([str hasPrefix:@"sh"]|| [str hasPrefix:@"sz"] ) {
        return str;
    }
    
    if ([str hasPrefix:@"60"]|| [str hasPrefix:@"9009"]) {
        return [NSString stringWithFormat:@"sh%@",pre_str];
    }
    
    if ([str hasPrefix:@"300"] || [str hasPrefix:@"00"]|| [str hasPrefix:@"200"] ) {
        return [NSString stringWithFormat:@"sz%@",pre_str];
    }
    
    return str;
}
@end
