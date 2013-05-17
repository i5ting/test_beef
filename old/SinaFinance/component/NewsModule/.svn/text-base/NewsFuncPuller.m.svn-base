//
//  NewsFuncPuller.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsFuncPuller.h"
#import "ASIHTTPRequest.h"
#import "NSData+base64.h"
#import "CommentContentList.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "MyTool.h"
#import "JSONKit.h"
#import "LKTipCenter.h"

NSString* HttpAPI_CommentNews = @"http://comment5.news.sina.com.cn/cmnt/submit_client";
NSString* HttpAPI_NewsContent = @"http://api.news.sina.com.cn/news/content";
NSString* HttpAPI_CommentList = @"http://comment5.news.sina.com.cn/page/info";
NSString* HttpAPI_SearchNewsList = @"http://api.search.sina.com.cn/?auth_type=uuid&auth_id=xx&format=json&c=news&q=xx&page=all&col=1_7";


@interface NewsFuncPuller () 
@property(assign,readonly)NSDictionary* oAuthData;
@property(retain)ASIHTTPRequest* requester;

-(void)afterCommentContentSuccessed:(NSDictionary*)jsonDict userRequst:(ASIHTTPRequest*)request;
-(void)startHttpAPIRequestV2:(NSString*)method data:(NSDictionary*)dict order:(NSArray*)orderArray api:(NSString*)HttpAPI stage:(NSInteger)stageInteger userInfo:(NSDictionary*)userData headerDict:(NSDictionary*)headerDict bInback:(BOOL)bInback;
-(void)startHttpAPIRequstByURL:(NSURL*)url headerDict:(NSDictionary*)headerDict userInfo:(NSDictionary*)info stage:(NSInteger)stageInt inBack:(BOOL)bInBack;
-(void)startAPIRequest:(id)sender withAPICode:(NSArray*)codeArray pagename:(NSString*)pageName pagevalue:(NSInteger)pageValue countname:(NSString*)countName countvalue:(NSInteger)countValue args:(NSArray*)args stage:(NSInteger)stage otherUserInfo:(NSDictionary*)oUserInfo headerInfo:(NSDictionary*)headerDict inBack:(BOOL)bInBack;
-(void)addRequestToDowloadQueue:(ASIHTTPRequest*)request;
-(void)addRequestToOfflineQueue:(ASIHTTPRequest*)request;
-(void)afterDefaultSuccessed:(NSDictionary*)jsonDict userRequst:(ASIHTTPRequest*)request dataname:(NSString*)dateName notifyName:(NSString*)notifyName;
-(void)afterDefaultSuccessed:(NSArray*)resultArray userRequst:(ASIHTTPRequest*)request notifyName:(NSString*)notifyName;
-(void)afterDefaultFailed:(ASIHTTPRequest*)request notifyName:(NSString*)notifyName;
-(void)sendNotificationWithName:(NSString*)nofityName stage:(NSInteger)stage info:(NSDictionary*)info;
-(void)mainThreadRunningNotification:(NSDictionary*)argInfo;
@end

@implementation NewsFuncPuller
@synthesize oAuthData;
@synthesize downloadQueue=mDownloadQueue;
@synthesize requester;


+ (id)getInstance
{
    static NewsFuncPuller* s_messageManager = nil;
	if (s_messageManager == nil)
	{
		//没有创建则创建
		s_messageManager = [[NewsFuncPuller alloc] init];
        
	}
	return s_messageManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(CommonNewsSucceed:)
                   name:CommonNewsSucceedNotification 
                 object:nil];
        [nc addObserver:self selector:@selector(CommonNewsFailed:)
                   name:CommonNewsFailedNotification 
                 object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mDownloadQueue release];
    [requester release];
    [super dealloc];
}

-(NSDictionary*)oAuthData
{
    return [[WeiboLoginManager getInstance] oAuthData];
}

-(void)CommonNewsSucceed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    if ([stageNumber intValue]==Stage_Request_CommentNews)
    {
        NSString* tipString = @"新闻评论已成功发布";
        [[LKTipCenter defaultCenter] postTopTipWithMessage:tipString time:2.0 color:nil];
    }
}

-(void)CommonNewsFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    if ([stageNumber intValue]==Stage_Request_CommentNews)
    {
        NSString* tipString = @"新闻评论发布失败了";
        [[LKTipCenter defaultCenter] postTopTipWithMessage:tipString time:2.0 color:nil];
    }
}

-(void)startCommentNewsWithSender:(id)sender channelid:(NSString*)channelID newsid:(NSString*)newsID content:(NSString*)content
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSString* httpAPI = HttpAPI_CommentNews;
    //NSString* httpAPI = @"http://220.181.84.178/cmnt/submit_client";
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    NSString* newKey = [[WeiboLoginManager getInstance] appKey];
    [dict setObject:newKey forKey:OAUTH2_Source];
    [orderArray addObject:OAUTH2_Source];
    
    if (channelID) {
        NSString* idKey = @"channel";
        [dict setObject:channelID forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (newsID) {
        NSString* idKey = @"newsid";
        [dict setObject:newsID forKey:idKey];
        [orderArray addObject:idKey];
    }
    if (content) {
        NSString* idKey = @"content";
        httpAPI = [httpAPI stringByAppendingFormat:@"?%@=%@&ie=utf-8",idKey,[content rawUrlEncode]];
    }
    
    [dict setValue:[NSDate date] forKey:RequsetDate];
    if (sender) {
        [dict setValue:sender forKey:RequsetSender];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_CommentNews userInfo:dict headerDict:nil bInback:NO];
}

-(void)startNewsContentWithSender:(id)sender urlString:(NSString*)urlStr args:(NSArray*)args dataList:(CommentDataList*)dataList bInback:(BOOL)bInback
{
    BOOL bBack = bInback;
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    urlStr = [NSString stringWithFormat:@"%@?url=%@&format=json&mode=cooked",HttpAPI_NewsContent,urlStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setValue:[NSDate date] forKey:RequsetDate];
    if (args) {
        args = [NSArray arrayWithArray:args];
        [dict setValue:args forKey:RequsetArgs];
    }
    if (sender) {
        [dict setValue:sender forKey:RequsetSender];
    }
    [dict setValue:[NSNumber numberWithInt:RequestType_content] forKey:RequsetType];
    if (dataList) {
        [dict setValue:dataList forKey:RequsetDataList];
    }
    
    [self startHttpAPIRequstByURL:url headerDict:nil userInfo:dict stage:Stage_Request_NewsContent inBack:bBack];
}

-(void)startCommentListWithSender:(id)sender page:(NSInteger)page withAPICode:(NSArray*)codeArray args:(NSArray*)args dataList:(CommentDataList*)dataList bInback:(BOOL)bInback
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (dataList) {
        [dict setValue:dataList forKey:RequsetDataList];
    }
    [dict setValue:[NSNumber numberWithInt:RequestType_List] forKey:RequsetType];
    [self startAPIRequest:sender withAPICode:codeArray pagename:@"page" pagevalue:page countname:nil countvalue:0 args:args stage:Stage_Request_CommentList otherUserInfo:dict headerInfo:nil inBack:bInback];
    [dict release];
} 

-(void)startCommentContentWithSender:(id)sender page:(NSInteger)page count:(NSInteger)count withChannel:(NSString*)channel newsID:(NSString*)newsID args:(NSArray*)args dataList:(CommentDataList*)dataList bInback:(BOOL)bInback
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSString* urlStr = [NSString stringWithFormat:@"%@?format=json&channel=%@&newsid=%@&group=0&page=%d&num=%d&oe=utf-8&list=all",HttpAPI_CommentList,channel,newsID,page,count];
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (dataList) {
        [dict setValue:dataList forKey:RequsetDataList];
    }
    NSArray* apiCode = [NSArray arrayWithObjects:urlStr,nil];
    [self startAPIRequest:sender withAPICode:apiCode pagename:@"page" pagevalue:page countname:@"num" countvalue:count args:args stage:Stage_Request_CommentContent otherUserInfo:dict headerInfo:nil inBack:bInback];
    [dict release];
}

-(void)startSearchFinanceNewsWithSender:(id)sender searchString:(NSString*)searchString lastps:(NSString*)ps lastpf:(NSString*)pf count:(NSInteger)countPerPage page:(NSInteger)page args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_SearchNewsList;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (searchString) {
        NSString* idKey = @"q";
        [dict setObject:searchString forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (YES) {
        NSString* idString = @"page";
        [dict setObject:[NSString stringWithFormat:@"%d",page] forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (ps&&pf) {
        NSString* idString = @"ps";
        [dict setObject:ps forKey:idString];
        [orderArray addObject:idString];
        idString = @"pf";
        [dict setObject:pf forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (YES) {
        NSString* idString = @"auth_value";
        [dict setObject:@"b0b847e5-d7f4-f9d6-4db0-5c4e-712bff9b" forKey:idString];
        [orderArray addObject:idString];
        //每个项目一个
    }
    
    if (countPerPage>0) {
        NSString* idKey = @"count";
        [dict setObject:[NSString stringWithFormat:@"%d",countPerPage] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    [userDict setObject:[NSString stringWithFormat:@"%d",page] forKey:RequsetPage];
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    if (args) {
        [userDict setValue:args forKey:RequsetArgs];
    }
    if (dataList) {
        [userDict setObject:dataList forKey:RequsetDataList];
    }
    if (info) {
        [userDict setObject:info forKey:RequsetInfo];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_SearchNews userInfo:userDict headerDict:nil bInback:NO];
}

-(void)afterCommentContentSuccessed:(NSDictionary*)jsonDict userRequst:(ASIHTTPRequest*)request
{
    NSDictionary* newsDict = [jsonDict objectForKey:@"news"];
    NSArray* cmntlist = [jsonDict objectForKey:@"cmntlist"];
    NSDictionary* replydict = [jsonDict objectForKey:@"replydict"];
    
    NewsObject* newsObject = [[NewsObject alloc] initWithJsonDictionary:newsDict];
    
    NSDictionary* commentDict = nil;
    NSEnumerator* objectEnumerator = [cmntlist objectEnumerator];
    NSMutableArray* orderList = [[NSMutableArray alloc] initWithCapacity:0];
    while (commentDict = [objectEnumerator nextObject]) {
        NewsObject* commentObject = [[NewsObject alloc] initWithJsonDictionary:commentDict];
        [orderList addObject:commentObject];
        [commentObject release];
    }
    
    NSArray* commentArray = nil;
    NSString* oneKey = nil;
    objectEnumerator = [[replydict allKeys] objectEnumerator];
    NSMutableDictionary* relationList = [[NSMutableDictionary alloc] initWithCapacity:0];
    while (oneKey = [objectEnumerator nextObject]) {
        NSMutableArray* relationDeepArray = [[NSMutableArray alloc] initWithCapacity:0];
        commentArray = [replydict objectForKey:oneKey];
        for (int i=0; i<[commentArray count]; i++) {
            commentDict = [commentArray objectAtIndex:i];
            NewsObject* commentObject = [[NewsObject alloc] initWithJsonDictionary:commentDict];
            [relationDeepArray addObject:commentObject];
            [commentObject release];
        }
        [relationList setObject:relationDeepArray forKey:oneKey];
        [relationDeepArray release];
    }
    CommentContentList* commentList = [[CommentContentList alloc] init];
    [commentList addContentObjectsWithOrderList:orderList relationList:relationList news:newsObject];
    
    NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
    [userInfo setValue:commentList forKey:RequsetExtra];
    
    [self afterDefaultSuccessed:orderList userRequst:request notifyName:CommonNewsSucceedNotification];

    [orderList release];
    [relationList release];
    [newsObject release];
    
    [commentList release];
}

-(void)startAPIRequest:(id)sender withAPICode:(NSArray*)codeArray pagename:(NSString*)pageName pagevalue:(NSInteger)pageValue countname:(NSString*)countName countvalue:(NSInteger)countValue args:(NSArray*)args stage:(NSInteger)stage otherUserInfo:(NSDictionary*)oUserInfo headerInfo:(NSDictionary*)headerDict inBack:(BOOL)bInBack
{
    if ([codeArray count]>0) {
        if (args) {
            args = [NSArray arrayWithArray:args];
        }
        NSString* urlStr = [codeArray objectAtIndex:0];
        if (pageName) {
            urlStr = [MyTool urlString:urlStr replaceStringKey:pageName withValueString:[NSString stringWithFormat:@"%d",pageValue]];
        }
        if (countName) {
            urlStr = [MyTool urlString:urlStr replaceStringKey:countName withValueString:[NSString stringWithFormat:@"%d",countValue]];
        }
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
        if (sender) {
            [dict setValue:sender forKey:RequsetSender];
        }
        [dict setValue:[NSDate date] forKey:RequsetDate];
        if (args) {
            [dict setObject:args forKey:RequsetArgs];
        }
        [dict setObject:[NSNumber numberWithInt:pageValue] forKey:RequsetPage];
        if (oUserInfo) {
            [dict addEntriesFromDictionary:oUserInfo];
        }
        
        [self startHttpAPIRequstByURL:url headerDict:headerDict userInfo:dict stage:stage inBack:bInBack];
    }
}

-(void)startHttpAPIRequstByURL:(NSURL*)url headerDict:(NSDictionary*)headerDict userInfo:(NSDictionary*)info stage:(NSInteger)stageInt inBack:(BOOL)bInBack
{
    ASIFormDataRequest* request = [[[ASIFormDataRequest alloc] initWithURL :url] autorelease];
    request.tag = stageInt;
    request.userInfo = info;
    
    if (headerDict) {
        NSArray* headerKey = [headerDict allKeys];
        for (NSString* oneKey in headerKey) {
            NSString* oneValue = [headerDict valueForKey:oneKey];
            [request addRequestHeader:oneKey value:oneValue];
        }
    } 
    [request addRequestHeader:@"Accept-Encoding" value:@"gzip"];
    [request setDelegate:self];
    request.finishWithThread = YES;
    if (!bInBack) {
        [self addRequestToDowloadQueue:request];
    }
    else
    {
        [self addRequestToOfflineQueue:request];
    }
}

-(void)startHttpAPIRequestV2:(NSString*)method data:(NSDictionary*)dict order:(NSArray*)orderArray api:(NSString*)HttpAPI stage:(NSInteger)stageInteger userInfo:(NSDictionary*)userData headerDict:(NSDictionary*)headerDict bInback:(BOOL)bInback
{
    NSString *urlStr = nil;
    if ([[method uppercaseString] isEqualToString:@"POST"]) {
        urlStr = HttpAPI;
    }
    else
    {
        if (dict&&orderArray) {
            urlStr = [MyTool urlParmFormatWithSourceString:HttpAPI FromDict:dict order:orderArray useEncode:YES];
        }
        else
        {
            urlStr = HttpAPI;
        }
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    
    ASIFormDataRequest* request = [[[ASIFormDataRequest alloc] initWithURL :url] autorelease];
    request.tag = stageInteger;
    request.userInfo = userData;
    if ([[method uppercaseString] isEqualToString:@"POST"]) {
        [request setRequestMethod:@"POST"];
        for (NSString* onekey in orderArray) {
            NSString* oneValue = [dict objectForKey:onekey];
            [request setPostValue:oneValue forKey:onekey];
        }
    }
    if (headerDict) {
        NSArray* headerKey = [headerDict allKeys];
        for (NSString* oneKey in headerKey) {
            NSString* oneValue = [headerDict valueForKey:oneKey];
            [request addRequestHeader:oneKey value:oneValue];
        }
    } 
    [request addRequestHeader:@"Accept-Encoding" value:@"gzip"];
    [request setDelegate:self];
    request.finishWithThread = YES;
    
    if (!bInback) {
        [self addRequestToDowloadQueue:request];
    }
    else
    {
        [self addRequestToOfflineQueue:request];
    }
}

-(void)clearRequestQueue
{
    [mDownloadQueue cancelAllOperations];
    self.downloadQueue = nil;
}

-(void)initalDownloadQueue
{
    if (!mDownloadQueue) {
        mDownloadQueue = [[ASINetworkQueue alloc] init];
        [mDownloadQueue setShouldCancelAllRequestsOnFailure:NO];
        [mDownloadQueue setDelegate:self];
    }
}

-(void)addRequestToDowloadQueue:(ASIHTTPRequest*)request
{
    if (self.requester) {
        [self.requester clearDelegatesAndCancel];
        self.requester = nil;
    }
    self.requester = request;
    [request startAsynchronous];
    
    //    [self initalDownloadQueue];
    //    [self.downloadQueue addOperation:request];
    //    [self.downloadQueue go];
}

-(void)addRequestToOfflineQueue:(ASIHTTPRequest*)request
{
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self afterDefaultFailed:request notifyName:CommonNewsFailedNotification];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag==Stage_Request_CommentNews)
    {
        NSString* resultString = request.responseString;
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary* resultDict = nil;
            resultDict = [jsonDict objectForKey:@"result"];
            NSDictionary* statusDict = [resultDict objectForKey:@"status"];
            NSString* codeValue = [statusDict objectForKey:@"code"];
            if ([codeValue isKindOfClass:[NSNumber class]]) {
                codeValue = [NSString stringWithFormat:@"%@",codeValue];
            }
            if ([codeValue isEqualToString:@"0"]) {
                [self afterDefaultSuccessed:nil userRequst:request notifyName:CommonNewsSucceedNotification];
            }
            else
            {
                [self afterDefaultFailed:request notifyName:CommonNewsFailedNotification];
            }
        }
        else
        {
            if (!resultString) {
                [self afterDefaultSuccessed:nil userRequst:request notifyName:CommonNewsSucceedNotification];
            }
            else
            {
                [self afterDefaultFailed:request notifyName:CommonNewsFailedNotification];
            }
            
        }
    }
    else if(request.tag==Stage_Request_NewsContent)
    {
        NSString* resultString = request.responseString;
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary* resultDict = nil;
            resultDict = [jsonDict objectForKey:@"result"];
            NSDictionary* statusDict = [resultDict objectForKey:@"status"];
            NSString* codeValue = [statusDict objectForKey:@"code"];
            if ([codeValue isKindOfClass:[NSNumber class]]) {
                codeValue = [NSString stringWithFormat:@"%@",codeValue];
            }
            if ([codeValue isEqualToString:@"0"]) {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:nil notifyName:CommonNewsSucceedNotification];
            }
            else
            {
                [self afterDefaultFailed:request notifyName:CommonNewsFailedNotification];
            }
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonNewsFailedNotification];
        }
    }
    else if(request.tag==Stage_Request_CommentList)
    {
        NSString* resultString = request.responseString;
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary* resultDict = [jsonDict objectForKey:@"result"];
            NSDictionary* statusDict = [resultDict objectForKey:@"status"];
            NSString* codeValue = [statusDict objectForKey:@"code"];
            if ([codeValue isKindOfClass:[NSNumber class]]) {
                codeValue = [NSString stringWithFormat:@"%@",codeValue];
            }
            if ([codeValue isEqualToString:@"0"]) {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:nil notifyName:CommonNewsSucceedNotification];
            }
            else
            {
                [self afterDefaultFailed:request notifyName:CommonNewsFailedNotification];
            }
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonNewsFailedNotification];
        }
    }
    else if(request.tag==Stage_Request_CommentContent)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary* resultDict = [jsonDict objectForKey:@"result"];
            NSDictionary* statusDict = [resultDict objectForKey:@"status"];
            NSString* codeValue = [statusDict objectForKey:@"code"];
            if ([codeValue isKindOfClass:[NSNumber class]]) {
                codeValue = [NSString stringWithFormat:@"%@",codeValue];
            }
            if ([codeValue isEqualToString:@"0"]) {
                [self afterCommentContentSuccessed:resultDict userRequst:request];
            }
            else
            {
                [self afterDefaultFailed:request notifyName:CommonNewsFailedNotification];
            }
            
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonNewsFailedNotification];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_SearchNews)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary* resultDict = [jsonDict objectForKey:@"result"];
            NSDictionary* statusDict = [resultDict objectForKey:@"status"];
            NSString* codeValue = [statusDict objectForKey:@"code"];
            if ([codeValue isKindOfClass:[NSNumber class]]) {
                codeValue = [NSString stringWithFormat:@"%@",codeValue];
            }
            if ([codeValue isEqualToString:@"0"]) {
                [self afterDefaultSuccessed:resultDict userRequst:request dataname:@"list" notifyName:CommonNewsSucceedNotification];
            }
            else
            {
                [self requestFailed:request];
            }
            
        }
        else
        {
            [self requestFailed:request];
        }
        [resultString release];
    }
    
}

-(void)afterDefaultSuccessed:(NSDictionary*)jsonDict userRequst:(ASIHTTPRequest*)request dataname:(NSString*)dateName notifyName:(NSString*)notifyName
{
    NSMutableArray* array = nil;
    if (!dateName) {
        array = [jsonDict objectForKey:@"data"];
    }
    else
    {
        array = [jsonDict objectForKey:dateName];
    }
    if ([array isKindOfClass:[NSDictionary class]]) {
        array = [NSMutableArray arrayWithObject:array];
    }
    else if (![array isKindOfClass:[NSArray class]]) {
        array = nil;
    }
    NSMutableDictionary* info = (NSMutableDictionary*)request.userInfo;
    int validCount = array?[array count]:0;
    NSNumber* removedNumber = [info objectForKey:RequsetRemoveFirst];
    if (removedNumber) {
        validCount = validCount -1;
    }
    if (!info) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
        request.userInfo = dict;
        info = dict;
        [dict release];
    }
    else if(![info isKindOfClass:[NSMutableDictionary class]])
    {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dict addEntriesFromDictionary:info];
        request.userInfo = dict;
        info = dict;
        [dict release];
    }
    [info setValue:[NSNumber numberWithInt:validCount] forKey:@"count"];
    NSNumber* page = [info objectForKey:RequsetPage];
    NSString* orderString = [info objectForKey:RequsetOrder];
    NSDate* oldDate = [info objectForKey:RequsetLastDate];
    NSString* dateKey = [info objectForKey:RequsetDateKey];
    NSDateFormatter* dateFormatter = [info objectForKey:RequsetDateFormatter];
    if (oldDate&&dateKey&&dateFormatter) {
        for (int i=[array count]-1; i>=0; i--) {
            NSDictionary* tempDict = [array objectAtIndex:i];
            NSString* oneDateStr = [tempDict valueForKey:dateKey];
            NSDate* newFormatDate = [dateFormatter dateFromString:oneDateStr];
            if ([newFormatDate timeIntervalSinceDate:oldDate]>=0) {
                [array removeObjectAtIndex:i];
            }
        }
    }
    
    
    NSMutableArray* orderArray = nil;
    if (orderString&&![orderString isEqualToString:@""]) {
        orderArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
        for (int i=0; i<[array count]; i++) {
            NSMutableDictionary* oneObject = [array objectAtIndex:i];
            if ([oneObject isKindOfClass:[NSMutableDictionary class]]) {
                NSString* orderValue = [oneObject objectForKey:orderString];
                NSNumber* orderNumber = [NSNumber numberWithInt:[orderValue intValue]];
                [oneObject setValue:orderNumber forKey:orderString];
            }
            [orderArray addObject:oneObject];
        }
    }
    
    if (orderString&&![orderString isEqualToString:@""]) {
        if (removedNumber&&[removedNumber boolValue]) {
            if ([orderArray count]>0&&page&&[page intValue]>1) {
                [orderArray removeObjectAtIndex:0];
            }
        }
    }
    
    if (orderString&&![orderString isEqualToString:@""]) {
        NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:orderString ascending:NO]; 
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sorter count:1]; 
        [sorter release];
        [orderArray sortUsingDescriptors:sortDescriptors];
        [sortDescriptors release];
        array= orderArray;
    }
    
    NSMutableArray* defaultArray = [[NSMutableArray alloc] initWithCapacity:0];
    if ([array isKindOfClass:[NSArray class]]) {
        NSEnumerator* enumerator = [array objectEnumerator];
        NSDictionary* newsDict = nil;
        while (newsDict = [enumerator nextObject]) {            
            if ([newsDict isKindOfClass:[NSDictionary class]]&&[[newsDict allKeys] count]>0) {
                NewsObject* defalutObject = [[NewsObject alloc] initWithJsonDictionary:newsDict];
                [defaultArray addObject:defalutObject];
                [defalutObject release];
            }
        }
    }
    else if([array isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* newsDict = (NSDictionary*)array;
        NewsObject* defalutObject = [[NewsObject alloc] initWithJsonDictionary:newsDict];
        [defaultArray addObject:defalutObject];
        [defalutObject release];
    }
    
    [orderArray release];
    
    if (!(orderString&&![orderString isEqualToString:@""]))
    {
        if (removedNumber&&[removedNumber boolValue]) {
            if ([defaultArray count]>0&&page&&[page intValue]>1) {
                [defaultArray removeObjectAtIndex:0];
            }
        }
    }
    
    [self afterDefaultSuccessed:defaultArray userRequst:request notifyName:notifyName];
    
    [defaultArray release];
}

-(void)afterDefaultSuccessed:(NSArray*)resultArray userRequst:(ASIHTTPRequest*)request notifyName:(NSString*)notifyName
{
    NSDictionary* info = request.userInfo;
    NSArray* args = [info objectForKey:RequsetArgs];
    NSNumber* page = [info objectForKey:RequsetPage];
    NSNumber* offlineType = [info objectForKey:RequsetType];
    CommentDataList* dataList = [info objectForKey:RequsetDataList];
    if (dataList) {
        if (page&&[page intValue]>1) {
            [dataList addCommnetContents:resultArray IDList:args];
        }
        else
        {
            [dataList refreshCommnetContents:resultArray IDList:args];
        }
        [dataList setLoadedStateInfoWithIDList:args value:1];
    }
    
    NSNumber* ignorePageEnd = [info valueForKey:RequsetIgnorePageEnd];
    if (!(ignorePageEnd&&[ignorePageEnd boolValue])) {
        NSString* urlString = [request.url absoluteString];
        NSString* count = [MyTool urlString:urlString valueForKey:@"num"];
        if (!count) {
            [MyTool urlString:urlString valueForKey:@"count"];
        }
        if (count&&[count intValue]>0&&dataList) {
            int resultCount = [resultArray count];
            if (resultCount==[count intValue]) {
                [dataList setPageEndInfoWithIDList:args value:NO];
            }
            else
            {
                [dataList setPageEndInfoWithIDList:args value:YES];
            }
        }
    }
    NSMutableDictionary* notifyDict = [NSMutableDictionary dictionaryWithCapacity:3];
    
    id sender = [info objectForKey:RequsetSender];
    if (sender) {
        [notifyDict setObject:sender forKey:RequsetSender];
    }
    NSDate* date = [info objectForKey:RequsetDate];
    if (date) {
        [notifyDict setObject:date forKey:RequsetDate];
    }
    NSNumber* errorCode = [info objectForKey:RequsetError];
    if (errorCode) {
        [notifyDict setObject:errorCode forKey:RequsetError];
    }
    NSString* errorString = [info objectForKey:RequsetErrorString];
    if (errorString) {
        [notifyDict setObject:errorString forKey:RequsetErrorString];
    }
    if (args) {
        [notifyDict setObject:args forKey:RequsetArgs];
    }
    if (page) {
        [notifyDict setObject:page forKey:RequsetPage];
    }
    if (offlineType) {
        [notifyDict setObject:offlineType forKey:RequsetType];
    }
    if (dataList) {
        [notifyDict setObject:dataList forKey:RequsetDataList];
    }
    if (resultArray) {
        [notifyDict setObject:resultArray forKey:RequsetArray];
    }
    id extraObject = [info objectForKey:RequsetExtra];
    if (extraObject) {
        [notifyDict setObject:extraObject forKey:RequsetExtra];
    }
    id realInfo = [info objectForKey:RequsetInfo];
    if (realInfo) {
        [notifyDict setObject:realInfo forKey:RequsetInfo];
    }
    id curArgs = [info objectForKey:RequsetCurArgs];
    if (curArgs) {
        [notifyDict setObject:curArgs forKey:RequsetCurArgs];
    }
    
    notifyName = notifyName==nil?NavObjectsAddedNotification:notifyName;
    [self sendNotificationWithName:notifyName stage:request.tag info:notifyDict];
}

-(void)afterDefaultFailed:(ASIHTTPRequest*)request notifyName:(NSString*)notifyName
{
    NSDictionary* info = request.userInfo;
    NSArray* args = [info objectForKey:RequsetArgs];
    NSNumber* page = [info objectForKey:RequsetPage];
    NSNumber* offlineType = [info objectForKey:RequsetType];
    
    NSMutableDictionary* notifyDict = [NSMutableDictionary dictionaryWithCapacity:3];
    
    id sender = [info objectForKey:RequsetSender];
    if (sender) {
        [notifyDict setObject:sender forKey:RequsetSender];
    }
    NSDate* date = [info objectForKey:RequsetDate];
    if (date) {
        [notifyDict setObject:date forKey:RequsetDate];
    }
    NSNumber* errorCode = [info objectForKey:RequsetError];
    if (errorCode) {
        [notifyDict setObject:errorCode forKey:RequsetError];
    }
    NSString* errorString = [info objectForKey:RequsetErrorString];
    if (errorString) {
        [notifyDict setObject:errorString forKey:RequsetErrorString];
    }
    if (args) {
        [notifyDict setObject:args forKey:RequsetArgs];
    }
    CommentDataList* dataList = [info objectForKey:RequsetDataList];
    if (dataList) {
        [notifyDict setObject:dataList forKey:RequsetDataList];
    }
    if (dataList) {
        [dataList setLoadedStateInfoWithIDList:args value:0];
    }
    if (page) {
        [notifyDict setObject:page forKey:RequsetPage];
    }
    if (offlineType) {
        [notifyDict setObject:offlineType forKey:RequsetType];
    }
    id realInfo = [info objectForKey:RequsetInfo];
    if (realInfo) {
        [notifyDict setObject:realInfo forKey:RequsetInfo];
    }
    id extra = [info objectForKey:RequsetExtra];
    if (extra) {
        [notifyDict setObject:extra forKey:RequsetExtra];
    }
    id curArgs = [info objectForKey:RequsetCurArgs];
    if (curArgs) {
        [notifyDict setObject:curArgs forKey:RequsetCurArgs];
    }
    
    notifyName = notifyName==nil?NavObjectsFailedNotification:notifyName;
    [self sendNotificationWithName:notifyName stage:request.tag info:notifyDict];
}

-(void)sendNotificationWithName:(NSString*)nofityName stage:(NSInteger)stage info:(NSDictionary*)info
{
    NSMutableDictionary* notifyDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [notifyDict setObject:nofityName forKey:@"postNotificationName"];
    [notifyDict setObject:NSStringFromClass([self class]) forKey:@"object"];
    NSMutableDictionary* userDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [userDict setValue:[NSNumber numberWithInt:stage] forKey:RequsetStage];
    if (info) {
        [userDict addEntriesFromDictionary:info];
    }
    [notifyDict setObject:userDict forKey:@"userInfo"];
    [userDict release];
    
    [self performSelectorOnMainThread:@selector(mainThreadRunningNotification:) withObject:notifyDict waitUntilDone:NO];
}

-(void)mainThreadRunningNotification:(NSDictionary*)argInfo
{
    NSString* notifyName = [argInfo objectForKey:@"postNotificationName"];
    id object = [argInfo objectForKey:@"object"];
    NSDictionary* userInfo = [argInfo objectForKey:@"userInfo"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyName object:object userInfo:userInfo];
}

@end
