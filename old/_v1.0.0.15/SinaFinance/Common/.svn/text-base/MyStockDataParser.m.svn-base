//
//  MyStockDataParser.m
//  SinaFinance
//
//  Created by Du Dan on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyStockDataParser.h"
#import "Util.h"

@implementation MyStockDataParser

+ (NSString*)getPid:(NSString*)itemString
{
    NSArray *array = [itemString componentsSeparatedByString:@","];
    NSString *item1 = [array objectAtIndex:0];//"pid":"370139"
    array = [item1 componentsSeparatedByString:@":"];
    NSString *item2 = [array lastObject];//"370139"
    NSRange range = NSMakeRange(1, item2.length-2);
    NSString *pid = [item2 substringWithRange:range];//370139
    
    return pid;
}

+ (NSString*)getName:(NSString*)itemString
{
    NSArray *array = [itemString componentsSeparatedByString:@","];
    NSString *item1 = [array objectAtIndex:1];//"name":"%E5%9B%BD%E4%BC%81%E8%82%A1"
    array = [item1 componentsSeparatedByString:@":"];
    NSString *item2 = [array lastObject];//"%E5%9B%BD%E4%BC%81%E8%82%A1"
    NSRange range = NSMakeRange(1, item2.length-2);
    NSString *name = [item2 substringWithRange:range];//%E5%9B%BD%E4%BC%81%E8%82%A1
    name = [Util decodeUTF8String:name];
    
    return name;
}

+ (NSArray*)getSymbols:(NSString*)itemString
{
    NSMutableArray *symbols = [[NSMutableArray alloc] init];
    NSArray *array = [itemString componentsSeparatedByString:@"\"symbols\":"];
    NSString *item1 = [array lastObject];//["00941","03988","03328","03968","01398","02628","02318","00763","00728","00390","01688"]
    NSRange range = NSMakeRange(1, item1.length-2);
    NSString *content = [item1 substringWithRange:range];//"00941","03988","03328","03968","01398","02628","02318","00763","00728","00390","01688"
    NSArray *items = [content componentsSeparatedByString:@","];
    NSLog(@"symbols: ");
    for(NSString *string in items){
        range = NSMakeRange(1, string.length-2);
        NSString *item = [string substringWithRange:range];
        [symbols addObject:item];
        NSLog(@"%@, ", item);
    }
    
    return [symbols autorelease];
}

+ (NSArray*)HKGroupDataParser:(NSString*)originalData
{
    NSMutableArray *myGroups = [[NSMutableArray alloc] init];
    NSRange range = NSMakeRange(1, originalData.length - 2);
    NSString *content = [originalData substringWithRange:range];//[originalData substringFromIndex:1];
//    content = [content substringToIndex: originalData.length - 2];
//    NSLog(@"content: %@", content);
    
    NSArray *tempArray = [content componentsSeparatedByString:@"}"];
    for(NSString *string in tempArray){
        NSArray *array1 = [string componentsSeparatedByString:@"{"];
        NSString *item = [array1 lastObject];
        NSLog(@"item: %@", item);
        if(item.length > 0){
            NSString *pid = [self getPid:item];
            NSString *name = [self getName:item];
            NSArray *symbols = [self getSymbols:item];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:pid, @"MyStockGroupPid", 
                                  name, @"MyStockGroupName",
                                  symbols, @"MyStockGroupSymbols",
                                  nil];
            [myGroups addObject:dict];
        }
    }
    return [myGroups autorelease];
}

@end
