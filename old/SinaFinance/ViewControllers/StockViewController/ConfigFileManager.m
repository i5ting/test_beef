//
//  ConfigFileManager.m
//  SinaFinance
//
//  Created by shieh exbice on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ConfigFileManager.h"
#import "CommentDataList.h"
#import "JSONKit.h"
#import "JSONConfigDownloader.h"

@interface ConfigFileManager ()
-(CommentDataList*)stockListConfigDataList;

@end

@implementation ConfigFileManager

+ (id)getInstance
{
    static ConfigFileManager* s_messageManager = nil;
	if (s_messageManager == nil)
	{
		//没有创建则创建
		s_messageManager = [[ConfigFileManager alloc] init];
        
	}
	return s_messageManager;
}

-(CommentDataList*)stockListConfigDataList
{
    static CommentDataList* dataList = nil;
    if (!dataList) {
        dataList = [[self dataListFromFileName:@"stockconfig.json"] retain];
    }
    return dataList;
}

-(CommentDataList*)singleStockConfigDataList
{
    static CommentDataList* dataList = nil;
    if (!dataList) {
        dataList = [[self dataListFromFileName:@"singlestockconfig.json"] retain];
    }
    return dataList;
}

-(CommentDataList*)dataListFromFileName:(NSString*)fileName
{
    NSArray* commentArray = [[JSONConfigDownloader getInstance] jsonOjbectWithJSONConfigFile:fileName];
    if ([commentArray isKindOfClass:[NSDictionary class]]) {
        commentArray = [NSMutableArray arrayWithObject:commentArray];
    }
    NSMutableArray* configArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary* oneDict in commentArray) {
        NewsObject* oneObject = [[NewsObject alloc] initWithJsonDictionary:oneDict];
        [configArray addObject:oneObject];
        [oneObject release];
    }
    CommentDataList* dataList = [[[CommentDataList alloc] init] autorelease];
    [dataList refreshCommnetContents:configArray IDList:nil];
    [dataList reloadShowedDataWithIDList:nil];
    [configArray release];
    return dataList;
}

@end
