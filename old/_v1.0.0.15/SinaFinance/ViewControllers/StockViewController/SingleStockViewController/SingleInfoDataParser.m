//
//  SingleInfoDataParser.m
//  SinaFinance
//
//  Created by shieh exbice on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SingleInfoDataParser.h"
#import "NewsObject.h"
#import "StockFuncPuller.h"

@implementation SingleInfoDataParser

+ (NSArray*)parseCNStockTableXmlWithData:(NewsObject*)oneObject
{
    NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
    const NSArray *names = [NSArray arrayWithObjects:@"开盘价",@"昨收盘",@"最低价",@"最高价",@"成交量",@"成交额",@"换手率",@"市盈率",@"总市值",@"流通市值",nil];
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:names.count] autorelease];
    
    NSString* tempString = [oneObject valueForKey:@"open"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"last_close"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"low"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"high"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"volume"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"amount"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"turnover"];
    if([tempString floatValue] != 0.0){
        [array addObject:tempString];
    }
    else{
        [array addObject:@"--"];
    }
    tempString = [oneObject valueForKey:@"pe"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"total_volume"];
    if (tempString) {
        if([tempString floatValue] != 0.0){
            [array addObject:tempString];
        }
        else{
            [array addObject:@"--"];
        }
    }
    else {
        [array addObject:@""];
    }
    tempString = [oneObject valueForKey:@"free_volume"];
    if (tempString) {
        if([tempString floatValue] != 0.0){
            [array addObject:tempString];
        }
        else{
            [array addObject:@"--"];
        }
    }
    else {
        [array addObject:@""];
    }
    
    for(int i = 0; i < names.count; i++){
        [returnArray addObject:[names objectAtIndex:i]];
        [returnArray addObject:[array objectAtIndex:i]];
    }
    return returnArray;
}

+ (NSArray*)parseUSStockTableXmlWithData:(NewsObject*)oneObject
{
    NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
    const NSArray *names = [NSArray arrayWithObjects:@"开盘价",@"昨收盘",@"最低价",@"最高价",@"52周最低",@"52周最高",@"成交量",@"市盈率",nil];
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:names.count] autorelease];
    
    NSString* tempString = [oneObject valueForKey:@"open"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"last_close"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"low"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"high"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"low52"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"high52"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"volume"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"pe"];
    if([tempString floatValue] != 0.0){
        [array addObject:tempString];
    }
    else{
        [array addObject:@"--"];
    }
    
    for(int i = 0; i < names.count; i++){
        [returnArray addObject:[names objectAtIndex:i]];
        [returnArray addObject:[array objectAtIndex:i]];
    }
    return returnArray;
}

+ (NSArray*)parseHKStockTableXmlWithData:(NewsObject*)oneObject
{
    NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
    const NSArray *names = [NSArray arrayWithObjects:@"开盘价",@"昨收盘",@"最低价",@"最高价",@"52周最低",@"52周最高",@"成交量",@"成交额",@"市盈率",@"总市值",nil];
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:names.count] autorelease];
    
    NSString* tempString = [oneObject valueForKey:@"open"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"last_close"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"low"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"high"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"low52"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"high52"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"volume"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"amount"];
    [array addObject:tempString];
    tempString = [oneObject valueForKey:@"pe"];
    if([tempString floatValue] != 0.0){
        [array addObject:tempString];
    }
    else{
        [array addObject:@"--"];
    }
    tempString = [oneObject valueForKey:@"total_volume"];
    if (tempString) {
        if([tempString floatValue] != 0.0){
            [array addObject:tempString];
        }
        else{
            [array addObject:@"--"];
        }
    }
    else {
        [array addObject:@""];
    }
    for(int i = 0; i < names.count; i++){
        [returnArray addObject:[names objectAtIndex:i]];
        [returnArray addObject:[array objectAtIndex:i]];
    }
    return returnArray;
}

@end
