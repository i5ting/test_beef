//
//  XmlParser.m
//  SinaFinance
//
//  Created by Du Dan on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsXmlParser.h"
#import "GDataXMLNode.h"
#import "NewsListView.h"
#import "NewsContentViewController2.h"
#import "NSDateFormatterExtensions.h"
#import "Util.h"
#import "JSONKit.h"

@implementation NewsXmlParser

+ (NSArray*)parseNewsXmlWithData:(NSData*)data
{
    NSMutableArray *newsArray = [[[NSMutableArray alloc] init] autorelease];

    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"title"] objectAtIndex:0];
                //NSLog(@"News title: %@", element.stringValue);
                [dict setValue:[NSString stringWithString:element.stringValue] forKey:NEWSLIST_TITLE_KEY];
                element = [[item elementsForName:@"pubDate"] objectAtIndex:0];
//                NSLog(@"news date: %@", element.stringValue);
                NSDate *date = [Util NSStringDateToNSDate:element.stringValue];
                NSString *dateString = [[NSDateFormatter dateTimeFormatter] stringFromDate:date];
                [dict setValue:dateString forKey:NEWSLIST_DATE_KEY];
                element = [[item elementsForName:@"source"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSLIST_SOURCE_KEY];
                element = [[item elementsForName:@"link"] objectAtIndex:0];
//                NSLog(@"news link: %@", element.stringValue);
                [dict setValue:element.stringValue forKey:NEWSLIST_URL_KEY];
                element = [[item elementsForName:@"id"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSLIST_ID_KEY];
                [newsArray addObject:dict];
            }
            return newsArray;
        }
    }
    return nil;
}

+ (NSArray*)parseHeadlineXmlWithData:(NSData*)data
{
    NSMutableArray *newsArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//channel/item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"title"] objectAtIndex:0];
                //NSLog(@"News title: %@", element.stringValue);
                [dict setValue:[NSString stringWithString:element.stringValue] forKey:NEWSLIST_TITLE_KEY];
                element = [[item elementsForName:@"pubDate"] objectAtIndex:0];
//                NSLog(@"news date: %@", element.stringValue);
                NSDate *date = [Util NSStringDateToNSDate:element.stringValue];
                NSString *dateString = [[NSDateFormatter dateTimeFormatter] stringFromDate:date];
                [dict setValue:dateString forKey:NEWSLIST_DATE_KEY];
                element = [[item elementsForName:@"source"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSLIST_SOURCE_KEY];
                element = [[item elementsForName:@"link"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSLIST_URL_KEY];
                element = [[item elementsForName:@"id"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSLIST_ID_KEY];
                [newsArray addObject:dict];
                
                if(newsArray.count == 3) break;
            }
            return newsArray;
        }
    }
    return nil;
}

+ (NSArray*)parseNewsContentXmlWithData:(NSData*)data
{
    NSMutableArray *newsArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        NSString *path = @"//channel/item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                GDataXMLElement *element = [[item elementsForName:@"title"] objectAtIndex:0];
                //NSLog(@"News title: %@", element.stringValue);
                [dict setValue:[NSString stringWithString:element.stringValue] forKey:NEWSCONTENT_TITLE_KEY];
                element = [[item elementsForName:@"url"] objectAtIndex:0];
                [dict setValue:[NSString stringWithString:element.stringValue] forKey:NEWSCONTENT_URL_KEY];
                
                element = [[item elementsForName:@"pubDate"] objectAtIndex:0];
                NSDate *date = [Util NSStringDateToNSDate:element.stringValue];
                NSString *dateString = [[NSDateFormatter dateTimeFormatter] stringFromDate:date];
                [dict setValue:dateString forKey:NEWSCONTENT_DATE_KEY];
                element = [[item elementsForName:@"source"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSCONTENT_SOURCE_KEY];
                element = [[item elementsForName:@"description"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSCONTENT_DESC_KEY];
                element = [[item elementsForName:@"commentnum"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSCONTENT_COMMENTNUM_KEY];
                [newsArray addObject:dict];
            }
            return newsArray;
        }
    }
    return nil;
}

+ (NSArray*)parseNewsContent2XmlWithData:(NSData*)data
{
    NSMutableArray *newsArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSDictionary* jsonDict = [data objectFromJSONData];
    if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
        NSDictionary* resultDict = nil;
        resultDict = [jsonDict objectForKey:@"result"];
        NSDictionary* statusDict = [resultDict objectForKey:@"status"];
        NSNumber* codeValue = [statusDict objectForKey:@"code"];
        if ([codeValue isKindOfClass:[NSString class]]) {
            codeValue = [NSNumber numberWithInt:[(NSString*)codeValue intValue]];
        }
        if ([codeValue intValue]==0) {
            NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
            NSArray* dataArray = [resultDict valueForKey:@"data"];
            for (NSDictionary* dataDict in dataArray) {
                NSString* title = [dataDict valueForKey:@"title"];
                [dict setValue:title forKey:NEWSCONTENT_TITLE_KEY];
                NSString* urlString = [dataDict valueForKey:@"url"];
                [dict setValue:urlString forKey:NEWSCONTENT_URL_KEY];
                NSString* dateString = [dataDict valueForKey:@"createdatetime"];
                NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
                [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
                [formatter setDateFormat:[NSString stringWithString:@"EEE, dd MMM yyyy HH:mm:ss z"]];
                NSDate* formatDate = [formatter dateFromString:dateString];
                [formatter setLocale:[NSLocale currentLocale]];
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString* formatnDateString = [formatter stringFromDate:formatDate];
                [dict setValue:formatnDateString forKey:NEWSCONTENT_DATE_KEY];
                NSArray* commentArray = [dataDict valueForKey:@"comment"];
                [dict setValue:[commentArray valueForKey:@"show_count"] forKey:NEWSCONTENT_COMMENTNUM_KEY];
                
                [dict setValue:[dataDict valueForKey:@"content"] forKey:NEWSCONTENT_DESC_KEY];
                NSDictionary* videoDict = [dataDict valueForKey:@"video"];
                [dict setValue:[videoDict valueForKey:@"thumb"] forKey:NEWSCONTENT_VideoImg];
                [dict setValue:[videoDict valueForKey:@"ipad"] forKey:NEWSCONTENT_VideoVid];
                NSString* sourceStr = [dataDict valueForKey:@"media"];
                if (sourceStr) {
                    [dict setValue:sourceStr forKey:NEWSCONTENT_SOURCE_KEY];
                }
                else {
                    [dict setValue:@"未知" forKey:NEWSCONTENT_SOURCE_KEY];
                }
                [dict setValue:[commentArray valueForKey:@"commentid"] forKey:NEWSCONTENT_COMMENTID_KEY];
                [newsArray addObject:dict];
            }
        }
    }
    
    if ([newsArray count]>0) {
        return newsArray;
    }
    return nil;
}


+ (NSArray*)parseNewsSearchXmlWithData:(NSData*)data
{
    NSMutableArray *newsArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//list/item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"title"] objectAtIndex:0];
                NSString *title = element.stringValue;
                [dict setValue:element.stringValue forKey:NEWSLIST_TITLE_KEY];
                element = [[item elementsForName:@"datetime"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSLIST_DATE_KEY];
                element = [[item elementsForName:@"media"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSLIST_SOURCE_KEY];
                element = [[item elementsForName:@"url"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSLIST_URL_KEY];
                if(title){
                    [newsArray addObject:dict];
                }
            }
            return newsArray;
        }
    }
    return nil;
}

+ (NSArray*)parseSearchContentXmlWithData:(NSData*)data
{
    NSMutableArray *newsArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        NSString *path = @"//data/item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(items.count > 0){
            for (GDataXMLElement *item in items){
                GDataXMLElement *element = [[item elementsForName:@"title"] objectAtIndex:0];
                //NSLog(@"News title: %@", element.stringValue);
                [dict setValue:[NSString stringWithString:element.stringValue] forKey:NEWSCONTENT_TITLE_KEY];
                element = [[item elementsForName:@"url"] objectAtIndex:0];
                [dict setValue:[NSString stringWithString:element.stringValue] forKey:NEWSCONTENT_URL_KEY];
                element = [[item elementsForName:@"createdatetime"] objectAtIndex:0];
                NSDate *date = [Util NSStringDateToNSDate:element.stringValue];
                NSString *dateString = [[NSDateFormatter dateTimeFormatter] stringFromDate:date];
                [dict setValue:dateString forKey:NEWSCONTENT_DATE_KEY];
                element = [[item elementsForName:@"media"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSCONTENT_SOURCE_KEY];
                element = [[item elementsForName:@"content"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSCONTENT_DESC_KEY];
                
                NSArray *comments = [item elementsForName:@"comment"];
                if(comments.count){
                    element = [[[comments lastObject] elementsForName:@"commentid"] objectAtIndex:0];
                    [dict setValue:element.stringValue forKey:NEWSCONTENT_COMMENTID_KEY];
//                element = [[item elementsForName:@"commentnum"] objectAtIndex:0];
                    element = [[[comments lastObject] elementsForName:@"show_count"] objectAtIndex:0];
                    [dict setValue:element.stringValue forKey:NEWSCONTENT_COMMENTNUM_KEY];
                }
                [newsArray addObject:dict];
            }
            return newsArray;
        }
    }
    return nil;
}

+ (NSArray*)parseNewsContentCommentWithData:(NSData*)data
{
    NSMutableArray *newsArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//data/comment";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"show_count"] objectAtIndex:0];
                [dict setValue:[NSString stringWithString:element.stringValue] forKey:NEWSCONTENT_COMMENTNUM_KEY];
                
                [newsArray addObject:dict];
            }
            return newsArray;
        }
    }
    return nil;
}

+ (NSArray*)parseNewsContentImagesWithData:(NSData*)data
{
    NSMutableArray *newsArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//images/item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"url"] objectAtIndex:0];
                [dict setValue:[NSString stringWithString:element.stringValue] forKey:NEWSIMAGE_URL_KEY];
                element = [[item elementsForName:@"title"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSIMAGE_TITLE_KEY];
                element = [[item elementsForName:@"height"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSIMAGE_HEIGHT_KEY];
                element = [[item elementsForName:@"width"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSIMAGE_WIDTH_KEY];
                
                [newsArray addObject:dict];
            }
            return newsArray;
        }
    }
    return nil;
}

+ (NSArray*)parseNewsContent2ImagesWithData:(NSData*)data
{
    NSMutableArray *newsArray = [[[NSMutableArray alloc] init] autorelease];
    
    NSDictionary* jsonDict = [data objectFromJSONData];
    if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
        NSDictionary* resultDict = nil;
        resultDict = [jsonDict objectForKey:@"result"];
        NSDictionary* statusDict = [resultDict objectForKey:@"status"];
        NSNumber* codeValue = [statusDict objectForKey:@"code"];
        if ([codeValue isKindOfClass:[NSString class]]) {
            codeValue = [NSNumber numberWithInt:[(NSString*)codeValue intValue]];
        }
        if ([codeValue intValue]==0) {
            
            NSArray* dataArray = [resultDict valueForKey:@"data"];
            for (NSDictionary* dataDict in dataArray) {
                NSArray* imageArray = [dataDict valueForKey:@"images"];
                if ([imageArray count]>0) {
                    for (NSDictionary* imageDict in imageArray) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
                        [dict setValue:[imageDict valueForKey:@"url"] forKey:NEWSIMAGE_URL_KEY];
                        [dict setValue:[imageDict valueForKey:@"title"] forKey:NEWSIMAGE_TITLE_KEY];
                        [dict setValue:[imageDict valueForKey:@"height"] forKey:NEWSIMAGE_HEIGHT_KEY];
                        [dict setValue:[imageDict valueForKey:@"width"] forKey:NEWSIMAGE_WIDTH_KEY];
                        [newsArray addObject:dict];
                        [dict release];
                    }
                    
                }
            }
        }
    }
    
    if ([newsArray count]>0) {
        return newsArray;
    }
    return nil;
}

+ (NSArray*)parseStockSearchXmlWithData:(NSData*)data
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"symbol"] objectAtIndex:0];
                //NSLog(@"News title: %@", element.stringValue);
                [dict setValue:[NSString stringWithString:element.stringValue] forKey:STOCK_SEARCH_SYMBOL_KEY];
                element = [[item elementsForName:@"country"] objectAtIndex:0];
//                NSLog(@"country: %@", element.stringValue);
                [dict setValue:element.stringValue forKey:STOCK_SEARCH_COUNTRY_KEY];
                element = [[item elementsForName:@"cname"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_SEARCH_CNAME_KEY];
                
                [dict setValue:@"StockSearch" forKey:@"SearchType"];
                
                [array addObject:dict];
            }
            return array;
        }
    }return nil;
}

//+ (NSArray*)parseStockDataXmlWithData:(NSData*)data
//{
//    NSMutableArray *array = [[NSMutableArray alloc] init];
//    
//    NSError *error = nil;
//    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
//    if(error == nil){
//        NSString *path = @"//future";
//        NSArray *items = [doc nodesForXPath:path error:&error];
//        if(error == nil){
//            for (GDataXMLElement *item in items){
//                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
//                GDataXMLElement *element = [[item elementsForName:@"code"] objectAtIndex:0];
//                [dict setValue:[NSString stringWithString:element.stringValue] forKey:STOCK_DATA_CODE_KEY];
//                NSLog(@"Stock code: %@", element.stringValue);
//                element = [[item elementsForName:@"name"] objectAtIndex:0];
//                [dict setValue:[NSString stringWithString:element.stringValue] forKey:STOCK_DATA_NAME_KEY];
//                element = [[item elementsForName:@"zuixin"] objectAtIndex:0];
//                [dict setValue:element.stringValue forKey:STOCK_DATA_PRICE_KEY];
//                element = [[item elementsForName:@"zhangdiee"] objectAtIndex:0];
//                [dict setValue:element.stringValue forKey:STOCK_DATA_ZHANGDIEE_KEY];
//                element = [[item elementsForName:@"zhangdiefu"] objectAtIndex:0];
//                [dict setValue:element.stringValue forKey:STOCK_DATA_ZHANGDIEFU_KEY];
//                
//                [array addObject:dict];
//            }
//            return [array autorelease];
//        }
//    }return nil;
//}

+ (NSArray*)parseStockDataWithData:(NSData*)data
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//data/item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"cn_name"] objectAtIndex:0];
                //                NSLog(@"name: %@", element.stringValue);
                if(element.stringValue.length == 0) continue;
                
                element = [[item elementsForName:@"symbol"] objectAtIndex:0];
                [dict setValue:[NSString stringWithString:element.stringValue] forKey:STOCK_DATA_CODE_KEY];
                //                NSLog(@"Stock code: %@", element.stringValue);
                element = [[item elementsForName:@"cn_name"] objectAtIndex:0];
                [dict setValue:[NSString stringWithString:element.stringValue] forKey:STOCK_DATA_NAME_KEY];
                element = [[item elementsForName:@"price"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_PRICE_KEY];
                element = [[item elementsForName:@"diff"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_ZHANGDIEE_KEY];
                element = [[item elementsForName:@"chg"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_ZHANGDIEFU_KEY];
                element = [[item elementsForName:@"amount"] objectAtIndex:0];
                //                NSLog(@"amount: %@", element.stringValue);
                if(element){
                    [dict setValue:[Util formatBigNumber:element.stringValue] forKey:STOCK_DATA_AMOUNT_KEY];
                }
                [array addObject:dict];
            }
            return array;
        }
    }return nil;
}


+ (NSArray*)parseUSAStockDataWithData:(NSData*)data
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//stocks/stock";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"code"] objectAtIndex:0];
                [dict setValue:[NSString stringWithString:element.stringValue] forKey:STOCK_DATA_CODE_KEY];
//                NSLog(@"Stock code: %@", element.stringValue);
                element = [[item elementsForName:@"name"] objectAtIndex:0];
                [dict setValue:[NSString stringWithString:element.stringValue] forKey:STOCK_DATA_NAME_KEY];
                element = [[item elementsForName:@"zuixin"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_PRICE_KEY];
                element = [[item elementsForName:@"zhangdiee"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_ZHANGDIEE_KEY];
                element = [[item elementsForName:@"zhangdiefu"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_ZHANGDIEFU_KEY];
                
                [array addObject:dict];
            }
            return array;
        }
    }return nil;
}

+ (NSArray*)parseStockItemNewsWithData:(NSData*)data
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//data/item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"title"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSLIST_TITLE_KEY];
                element = [[item elementsForName:@"create_date"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSLIST_DATE_KEY];
                element = [[item elementsForName:@"media_source"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSLIST_SOURCE_KEY];
                element = [[item elementsForName:@"url"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:NEWSLIST_URL_KEY];
                
                [array addObject:dict];
            }
            return array;
        }
    }return nil;
}

+ (NSArray*)parseCandleStickXmlWithData:(NSData*)data
{
    NSData *xmlData = [NSData dataWithData:data];
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//data/item";
        NSArray *items = [doc nodesForXPath:path error:&error];
         if(error == nil && items.count > 0){
//            NSInteger index = 0;
            for (GDataXMLElement *item in items){
//                if(index == 0) {index++; continue;}
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"open"] objectAtIndex:0];
                [dict setValue:[NSDecimalNumber decimalNumberWithString:element.stringValue] forKey:@"open"];
                element = [[item elementsForName:@"high"] objectAtIndex:0];
                [dict setValue:[NSDecimalNumber decimalNumberWithString:element.stringValue]  forKey:@"high"];
                element = [[item elementsForName:@"low"] objectAtIndex:0];
                [dict setValue:[NSDecimalNumber decimalNumberWithString:element.stringValue]  forKey:@"low"];
                element = [[item elementsForName:@"close"] objectAtIndex:0];
                [dict setValue:[NSDecimalNumber decimalNumberWithString:element.stringValue]  forKey:@"close"];
                element = [[item elementsForName:@"volume"] objectAtIndex:0];
                [dict setValue:[NSDecimalNumber decimalNumberWithString:element.stringValue]  forKey:@"volume"];
                
                element = [[item elementsForName:@"day"] objectAtIndex:0];
                if(element){
//                    NSLog(@"xml date: %@", element.stringValue);
                    NSDate *theDate = [[NSDateFormatter xmlDateFormatter] dateFromString:element.stringValue];
//                    NSLog(@"xml date after formatter: %@", [theDate description]);
                    [dict setValue:theDate forKey:@"date"];
                }
                else{
                    element = [[item elementsForName:@"day_time"] objectAtIndex:0];
                    NSDate *theDate = [[NSDateFormatter dateTimeFormatter] dateFromString:element.stringValue];
                    [dict setValue:theDate forKey:@"date"];
                }
                
                [array addObject:dict];
            }
            return array;
        }
    }
    return nil;
}

+ (NSArray*)parseTimeChartXmlWithData:(NSData*)data
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *pricePath = @"//data/pre_price";
        NSArray *prices = [doc nodesForXPath:pricePath error:nil];
        GDataXMLElement *elm = [prices objectAtIndex:0];
        NSDecimalNumber *pre_price = [NSDecimalNumber decimalNumberWithString:elm.stringValue];
//        NSLog(@"pre_price: %f", [pre_price floatValue]);
        NSString *path = @"//data/min/item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count){
//            NSInteger index = 0;
            for (GDataXMLElement *item in items){
                //if(index == 0) {index++; continue;}
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"mintime"] objectAtIndex:0];
//                NSString *dateString = [[NSDateFormatter xmlDateFormatter] stringFromDate:[NSDate date]];
//                NSString *finalString = [NSString stringWithFormat:@"%@ %@",dateString, element.stringValue];
                NSDate *theDate = [[NSDateFormatter xmlTimeFormatter] dateFromString:element.stringValue];
                [dict setValue:theDate forKey:@"date"];
                element = [[item elementsForName:@"price"] objectAtIndex:0];
                float price = [element.stringValue floatValue];
                [dict setValue:[NSDecimalNumber decimalNumberWithString:element.stringValue]  forKey:@"price"];
                
                element = [[item elementsForName:@"volume"] objectAtIndex:0];
//                NSInteger volume = [element.stringValue intValue];
                [dict setValue:[NSDecimalNumber decimalNumberWithString:element.stringValue]  forKey:@"volume"];
                
                element = [[item elementsForName:@"avg_price"] objectAtIndex:0];
                [dict setValue:[NSDecimalNumber decimalNumberWithString:element.stringValue]  forKey:@"avg_price"];
                
                [dict setValue:pre_price forKey:@"pre_price"];
                    
                if(price != 0.0){
                    [array addObject:dict];
                }
            }
            return array;
        }
    }
    return nil;
}

+ (NSArray*)parseHKTimeChartXmlWithData:(NSData*)data
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *pricePath = @"//data/pre_price";
        NSArray *prices = [doc nodesForXPath:pricePath error:nil];
        GDataXMLElement *elm = [prices objectAtIndex:0];
        NSDecimalNumber *pre_price = [NSDecimalNumber decimalNumberWithString:elm.stringValue];
//        NSLog(@"pre_price: %f", [pre_price floatValue]);
        NSString *path = @"//data/min/item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count){
//            NSInteger index = 0;
            NSDecimalNumber *amountSum = [NSDecimalNumber decimalNumberWithString:@"0"];
            NSDecimalNumber *volumeSum = [NSDecimalNumber decimalNumberWithString:@"0"];
            for (GDataXMLElement *item in items){
//                if(index == 0) {index++; continue;}
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"mintime"] objectAtIndex:0];
                //                NSString *dateString = [[NSDateFormatter xmlDateFormatter] stringFromDate:[NSDate date]];
                //                NSString *finalString = [NSString stringWithFormat:@"%@ %@",dateString, element.stringValue];
                NSDate *theDate = [[NSDateFormatter xmlTimeFormatter] dateFromString:element.stringValue];
                [dict setValue:theDate forKey:@"date"];
                element = [[item elementsForName:@"price"] objectAtIndex:0];
                float price = [element.stringValue floatValue];
                if(price != 0.0){
                    [dict setValue:[NSDecimalNumber decimalNumberWithString:element.stringValue]  forKey:@"price"];
                    
                    element = [[item elementsForName:@"volume"] objectAtIndex:0];
                    volumeSum = [volumeSum decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:element.stringValue]];
                    [dict setValue:[NSDecimalNumber decimalNumberWithString:element.stringValue]  forKey:@"volume"];
                    
                    element = [[item elementsForName:@"amount"] objectAtIndex:0];
                    amountSum = [amountSum decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:element.stringValue]];
                    
                    if([volumeSum intValue]){
                        [dict setValue:[amountSum decimalNumberByDividingBy:volumeSum] forKey:@"avg_price"];
//                        NSLog(@"avg_price: %f",[[dict objectForKey:@"avg_price"] floatValue]);
                    }
                    else{
                        element = [[item elementsForName:@"price"] objectAtIndex:0];
                        [dict setValue:[NSDecimalNumber decimalNumberWithString:element.stringValue]  forKey:@"avg_price"];
                    }
                    
                    [dict setValue:pre_price forKey:@"pre_price"];
                    
                    [array addObject:dict];
                }
            }
            return array;
        }
    }
    return nil;
}

+ (NSDictionary*)parseStockInfoXmlWithData:(NSData*)data
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//data";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                GDataXMLElement *element = [[item elementsForName:@"price"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_PRICE_KEY];
                element = [[item elementsForName:@"diff"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_ZHANGDIEE_KEY];
                element = [[item elementsForName:@"chg"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_ZHANGDIEFU_KEY];
                
                element = [[item elementsForName:@"hq_day"] objectAtIndex:0];
                NSString *hqDate = [NSString stringWithFormat:@"%@", element.stringValue];
                element = [[item elementsForName:@"hq_time"] objectAtIndex:0];
                hqDate = [hqDate stringByAppendingFormat:@" %@", element.stringValue];
                [dict setValue:hqDate forKey:STOCK_DATA_TIME_KEY];
            }
        }
    }
    return [dict autorelease];
}

+ (NSDictionary*)parseUSStockInfoXmlWithData:(NSData*)data
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//data";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                GDataXMLElement *element = [[item elementsForName:@"ustime"] objectAtIndex:0];
//                [dict setValue:element.stringValue forKey:@"ustime"];
                [dict setValue:element.stringValue forKey:STOCK_DATA_TIME_KEY];
                element = [[item elementsForName:@"newprice"] objectAtIndex:0];
//                [dict setValue:element.stringValue forKey:@"newprice"];
                [dict setValue:element.stringValue forKey:STOCK_DATA_PRICE_KEY];
                element = [[item elementsForName:@"newchg"] objectAtIndex:0];
//                [dict setValue:element.stringValue forKey:@"newchg"];
                [dict setValue:element.stringValue forKey:STOCK_DATA_ZHANGDIEFU_KEY];
                element = [[item elementsForName:@"newdiff"] objectAtIndex:0];
//                [dict setValue:element.stringValue forKey:@"newdiff"];
                [dict setValue:element.stringValue forKey:STOCK_DATA_ZHANGDIEE_KEY];
                element = [[item elementsForName:@"newustime"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:@"newustime"];
            }
        }
    }
    return [dict autorelease];
}

+ (NSArray*)parseCNStockTableXmlWithData:(NSData*)data
{
    NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
    const NSArray *names = [NSArray arrayWithObjects:@"开盘价",@"昨收盘",@"最低价",@"最高价",@"成交量",@"成交额",@"换手率",@"市盈率",@"总市值",@"流通市值",nil];
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:names.count] autorelease];

    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//data";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                GDataXMLElement *element = [[item elementsForName:@"open"] objectAtIndex:0];
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"last_close"] objectAtIndex:0];
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"low"] objectAtIndex:0];
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"high"] objectAtIndex:0];
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"volume"] objectAtIndex:0];
                [array addObject:[Util formatBigNumber:element.stringValue]];
                element = [[item elementsForName:@"amount"] objectAtIndex:0];
                [array addObject:[Util formatBigNumber:element.stringValue]];
                element = [[item elementsForName:@"turnover"] objectAtIndex:0];
                if([element.stringValue floatValue] != 0.0){
                    [array addObject:element.stringValue];
                }
                else{
                    [array addObject:@"--"];
                }
                element = [[item elementsForName:@"pe"] objectAtIndex:0];
                [array addObject:element.stringValue];
                
                element = [[item elementsForName:@"total_volume"] objectAtIndex:0];
                if([element.stringValue intValue] == 0){
                    [array addObject:@"--"];
                }
                else{
                    if(element.stringValue){
                        [array addObject:[Util formatBigNumber:element.stringValue]];
                    }
                    else{
                        [array addObject:@""];
                    }
                }
                
                element = [[item elementsForName:@"free_volume"] objectAtIndex:0];
                if([element.stringValue intValue] == 0){
                    [array addObject:@"--"];
                }
                else{
                    if(element.stringValue){
                        [array addObject:[Util formatBigNumber:element.stringValue]];
                    }
                    else{
                        [array addObject:@""];
                    }
                }
            }
        }
        for(int i = 0; i < names.count; i++){
            [returnArray addObject:[names objectAtIndex:i]];
            [returnArray addObject:[array objectAtIndex:i]];
        }
        return returnArray;
    }
    return nil;
}

+ (NSArray*)parseUSStockTableXmlWithData:(NSData*)data
{
    NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
    const NSArray *names = [NSArray arrayWithObjects:@"开盘价",@"昨收盘",@"最低价",@"最高价",@"52周最低",@"52周最高",@"成交量",@"市盈率",nil];
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:names.count] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//data";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                GDataXMLElement *element = [[item elementsForName:@"open"] objectAtIndex:0];
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"last_close"] objectAtIndex:0];
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"low"] objectAtIndex:0];
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"high"] objectAtIndex:0];
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"low52"] objectAtIndex:0];
                if([element.stringValue intValue] == 0){
                    [array addObject:@"--"];
                }
                else{
                    [array addObject:element.stringValue];
                }
                element = [[item elementsForName:@"high52"] objectAtIndex:0];
                if([element.stringValue intValue] == 0){
                    [array addObject:@"--"];
                }
                else{
                    [array addObject:element.stringValue];
                }
                element = [[item elementsForName:@"volume"] objectAtIndex:0];
                [array addObject:[Util formatBigNumber:element.stringValue]];
                element = [[item elementsForName:@"pe"] objectAtIndex:0];
                if([element.stringValue intValue] == 0){
                    [array addObject:@"--"];
                }
                else{
                    [array addObject:element.stringValue];
                }
            }
        }
        for(int i = 0; i < names.count; i++){
            [returnArray addObject:[names objectAtIndex:i]];
            [returnArray addObject:[array objectAtIndex:i]];
        }
        return returnArray;
    }
    return nil;
}

+ (NSArray*)parseHKStockTableXmlWithData:(NSData*)data
{
    NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
    const NSArray *names = [NSArray arrayWithObjects:@"开盘价",@"昨收盘",@"最低价",@"最高价",@"52周最低",@"52周最高",@"成交量",@"成交额",@"市盈率",@"总市值",nil];
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:names.count] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//data";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                GDataXMLElement *element = [[item elementsForName:@"open"] objectAtIndex:0];
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"last_close"] objectAtIndex:0];
//                NSLog(@"last_close: %@", element.stringValue);
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"low"] objectAtIndex:0];
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"high"] objectAtIndex:0];
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"low52"] objectAtIndex:0];
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"high52"] objectAtIndex:0];
                [array addObject:element.stringValue];
                element = [[item elementsForName:@"volume"] objectAtIndex:0];
                [array addObject:[Util formatBigNumber:element.stringValue]];
                element = [[item elementsForName:@"amount"] objectAtIndex:0];
                [array addObject:[Util formatBigNumber:element.stringValue]];
                element = [[item elementsForName:@"pe"] objectAtIndex:0];
                if([element.stringValue intValue] == 0){
                    [array addObject:@"--"];
                }
                else{
                    [array addObject:element.stringValue];
                }
                element = [[item elementsForName:@"total_volume"] objectAtIndex:0];
                if([element.stringValue intValue] == 0){
                    [array addObject:@"--"];
                }
                else{
                    if(element.stringValue){
                        [array addObject:[Util formatBigNumber:element.stringValue]];
                    }
                    else{
                        [array addObject:@""];
                    }
                }
            }
        }
        for(int i = 0; i < names.count; i++){
            [returnArray addObject:[names objectAtIndex:i]];
            [returnArray addObject:[array objectAtIndex:i]];
        }
        return returnArray;
    }
    return nil;
}

#pragma mark
#pragma mark Fund Data
+ (NSString*)parseFundTypeXmlWithData:(NSData*)data
{
    NSString *fundType = nil;
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//root";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            GDataXMLElement *element = [items lastObject];
            fundType = [NSString stringWithString:element.stringValue];
        }
    }
    return fundType;
}

+(NSDictionary*)parseOFFundNetValueXmlWithData:(NSData*)data
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//root";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                GDataXMLElement *element = [[item elementsForName:@"symbol"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_SYMBOL_KEY];
                element = [[item elementsForName:@"sname"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_NAME_KEY];
                element = [[item elementsForName:@"per_nav"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_PERNAV_KEY];
                element = [[item elementsForName:@"total_nav"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_TOTALNAV_KEY];
                element = [[item elementsForName:@"yesterday_nav"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_YESTERDAYNAV_KEY];
                element = [[item elementsForName:@"nav_rate"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_NAVRATE_KEY];
                element = [[item elementsForName:@"nav_a"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_NAVA_KEY];
                element = [[item elementsForName:@"sg_stat"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_SGSTAT_KEY];
                element = [[item elementsForName:@"sh_stat"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_SHSTAT_KEY];
                element = [[item elementsForName:@"rg_stat"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_RGSTAT_KEY];
                element = [[item elementsForName:@"nav_date"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_NAVDATE_KEY];
                element = [[item elementsForName:@"fund_manager"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_MANAGER_KEY];
                element = [[item elementsForName:@"fund_company"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_COMPANY_KEY];
                element = [[item elementsForName:@"jjlx"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_JJLX_KEY];
                element = [[item elementsForName:@"jjzfe"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_JJZFE_KEY];
            }
        }
    }
    return [dict autorelease];
}

+(NSDictionary*)parseCFFundNetValueXmlWithData:(NSData*)data
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//root";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                GDataXMLElement *element = [[item elementsForName:@"symbol"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_SYMBOL_KEY]; 
                element = [[item elementsForName:@"sname"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_NAME_KEY]; 
                element = [[item elementsForName:@"per_nav"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_PERNAV_KEY]; 
                element = [[item elementsForName:@"total_nav"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_TOTALNAV_KEY]; 
                element = [[item elementsForName:@"nav_rate"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_NAVRATE_KEY];
                element = [[item elementsForName:@"discount_rate"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_DISCOUNTRATE_KEY];
                element = [[item elementsForName:@"start_date"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_SYMBOL_KEY]; 
                element = [[item elementsForName:@"end_date"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_ENDDATE_KEY];
                element = [[item elementsForName:@"fund_manager"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_MANAGER_KEY];
                element = [[item elementsForName:@"nav_date"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_NAVDATE_KEY];
                element = [[item elementsForName:@"exchange"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_EXCHANGE_KEY];
                element = [[item elementsForName:@"sg_stat"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_SGSTAT_KEY];
                element = [[item elementsForName:@"sh_stat"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_SHSTAT_KEY];
                element = [[item elementsForName:@"rg_stat"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_RGSTAT_KEY];
                element = [[item elementsForName:@"fund_company"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_COMPANY_KEY];
                element = [[item elementsForName:@"jjzfe"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_JJZFE_KEY];
                element = [[item elementsForName:@"jjlx"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_JJLX_KEY];
                element = [[item elementsForName:@"diff"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_DIFF_KEY];
                element = [[item elementsForName:@"chg"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_CHG_KEY];
                element = [[item elementsForName:@"price"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_PRICE_KEY];
                element = [[item elementsForName:@"last_close"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_LASTCLOSE_KEY];
                element = [[item elementsForName:@"open"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_OPEN_KEY];
                element = [[item elementsForName:@"high"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_HIGH_KEY];
                element = [[item elementsForName:@"low"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_LOW_KEY];
                element = [[item elementsForName:@"hq_day"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_HQDAY_KEY];
                element = [[item elementsForName:@"hq_time"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_HQTIME_KEY];
                element = [[item elementsForName:@"amount"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_AMOUNT_KEY];
            }
        }
    }
    return [dict autorelease];
}

+(NSDictionary*)parseMoneyFundNetValueXmlWithData:(NSData*)data
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//root";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
            for (GDataXMLElement *item in items){
                GDataXMLElement *element = [[item elementsForName:@"symbol"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_SYMBOL_KEY]; 
                element = [[item elementsForName:@"sname"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_NAME_KEY]; 
                element = [[item elementsForName:@"w_per_nav"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_WPERNAV_KEY]; 
                element = [[item elementsForName:@"seven_days_rate"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_7DAYRATE_KEY]; 
                element = [[item elementsForName:@"nav_date"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_NAVDATE_KEY];
                element = [[item elementsForName:@"start_date"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_STARTDATE_KEY];
                element = [[item elementsForName:@"fund_manager"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_MANAGER_KEY];
                element = [[item elementsForName:@"sg_stat"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_SGSTAT_KEY];
                element = [[item elementsForName:@"sh_stat"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_SHSTAT_KEY];
                element = [[item elementsForName:@"rg_stat"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_RGSTAT_KEY];
                element = [[item elementsForName:@"fund_company"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_COMPANY_KEY];
                element = [[item elementsForName:@"jjzfe"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_JJZFE_KEY];
                element = [[item elementsForName:@"jjlx"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:FUND_NETVALUE_JJLX_KEY];
            }
        }
    }
    return [dict autorelease];
}

+ (NSArray*)parseOFFundChartXmlWithData:(NSData*)data
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//root/item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
//            NSInteger index = 0;
            for (GDataXMLElement *item in items){
//                if(index == 0) {index++; continue;}
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"PUBLISHDATE"] objectAtIndex:0];
                NSDate *theDate = [[NSDateFormatter dateTimeFormatter] dateFromString:element.stringValue];
                [dict setValue:theDate forKey:@"date"];
                element = [[item elementsForName:@"SYMBOL"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:@"symbol"];
                element = [[item elementsForName:@"NAV1"] objectAtIndex:0];
                [dict setValue:[NSDecimalNumber decimalNumberWithString:element.stringValue]  forKey:@"nav1"];
                element = [[item elementsForName:@"NAV2"] objectAtIndex:0];
                [dict setValue:[NSDecimalNumber decimalNumberWithString:element.stringValue]  forKey:@"nav2"];
                
                [array addObject:dict];
            }
            return array;
        }
    }
    return nil;
}

+ (NSArray*)parseFundHQXmlWithData:(NSData*)data
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//data/item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
//            NSInteger index = 0;
            for (GDataXMLElement *item in items){
                //if(index == 0) {index++; continue;}
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"name"] objectAtIndex:0];
                
                if(element.stringValue.length == 0) continue;
                
                element = [[item elementsForName:@"symbol"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_CODE_KEY];
                element = [[item elementsForName:@"price"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_PRICE_KEY];
                element = [[item elementsForName:@"name"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_NAME_KEY];
                element = [[item elementsForName:@"diff"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_ZHANGDIEE_KEY];
                element = [[item elementsForName:@"chg"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_ZHANGDIEFU_KEY];
                element = [[item elementsForName:@"nav_date"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_TIME_KEY];
                
                [array addObject:dict];
            }
            return array;
        }
    }
    return nil;
}

+ (NSArray*)parseOFFundHQXmlWithData:(NSData*)data
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    
    NSError *error = nil;
    GDataXMLDocument *doc = [[[GDataXMLDocument alloc] initWithData:data options:0 error:&error] autorelease];
    if(error == nil){
        NSString *path = @"//data/item";
        NSArray *items = [doc nodesForXPath:path error:&error];
        if(error == nil && items.count > 0){
//            NSInteger index = 0;
            for (GDataXMLElement *item in items){
//                if(index == 0) {index++; continue;}
                NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
                GDataXMLElement *element = [[item elementsForName:@"name"] objectAtIndex:0];
                if(element.stringValue.length == 0){
                    continue;
                }
                [dict setValue:element.stringValue forKey:STOCK_DATA_NAME_KEY];
                element = [[item elementsForName:@"price"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_PRICE_KEY];
                element = [[item elementsForName:@"chg"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_ZHANGDIEFU_KEY];
                element = [[item elementsForName:@"symbol"] objectAtIndex:0];
                [dict setValue:element.stringValue forKey:STOCK_DATA_CODE_KEY];
                
                [array addObject:dict];
            }
            return array;
        }
    }
    return nil;
}

@end
