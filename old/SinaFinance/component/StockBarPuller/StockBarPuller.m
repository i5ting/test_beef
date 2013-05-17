//
//  StockBarModule.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StockBarPuller.h"
#import "ASIFormDataRequest.h"
#import "MyTool.h"
#import "NSData+base64.h"
#import "JSONKit.h"
#import "NewsObject.h"
#import "ASINetworkQueue.h"
#import "CommentDataList.h"
#import "UIDevice-Reachability.h"
#import "LKTipCenter.h"

NSString* HttpAPI_StockBarHost = @"http://f2.bar.sina.com.cn";

@interface StockBarPuller ()
@property(retain)ASIHTTPRequest* requester;

-(void)startHttpAPIRequestV2:(NSString*)method data:(NSDictionary*)dict order:(NSArray*)orderArray api:(NSString*)HttpAPI stage:(NSInteger)stageInteger userInfo:(NSDictionary*)userData headerDict:(NSDictionary*)headerDict bInback:(BOOL)bInback;
-(void)startAPIRequest:(id)sender withAPICode:(NSArray*)codeArray pagename:(NSString*)pageName pagevalue:(NSInteger)pageValue countname:(NSString*)countName countvalue:(NSInteger)countValue args:(NSArray*)args stage:(NSInteger)stage otherUserInfo:(NSDictionary*)oUserInfo headerInfo:(NSDictionary*)headerDict inBack:(BOOL)bInBack;
-(void)startHttpAPIRequstByURL:(NSURL*)url headerDict:(NSDictionary*)headerDict userInfo:(NSDictionary*)info stage:(NSInteger)stageInt inBack:(BOOL)bInBack;
-(void)sendNotificationWithName:(NSString*)nofityName stage:(NSInteger)stage info:(NSDictionary*)info;
-(void)mainThreadRunningNotification:(NSDictionary*)argInfo;
-(void)addRequestToOfflineQueue:(ASIHTTPRequest*)request;
-(void)addRequestToDowloadQueue:(ASIHTTPRequest*)request;
-(void)clearRequestQueue;
-(void)initalDownloadQueue;
-(void)afterDefaultSuccessed:(NSDictionary*)jsonDict userRequst:(ASIHTTPRequest*)request dataname:(NSString*)dateName notifyName:(NSString*)notifyName;
-(void)afterDefaultSuccessed:(NSArray*)resultArray userRequst:(ASIHTTPRequest*)request notifyName:(NSString*)notifyName;
-(void)afterDefaultFailed:(ASIHTTPRequest*)request notifyName:(NSString*)notifyName;
- (void)requestFailed:(ASIHTTPRequest *)request;
@end

@implementation StockBarPuller
@synthesize downloadQueue=mDownloadQueue;
@synthesize requester;

+ (id)getInstance
{
    static StockBarPuller* s_messageManager = nil;
	if (s_messageManager == nil)
	{
		//没有创建则创建
		s_messageManager = [[StockBarPuller alloc] init];
        
	}
	return s_messageManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(StockBarObjectAdded:)
                   name:StockBarObjectAddedNotification 
                 object:nil];
        [nc addObserver:self selector:@selector(StockBarObjectFailed:)
                   name:StockBarObjectFailedNotification 
                 object:nil];
    }
    return self;
}

-(void)dealloc
{
    [mDownloadQueue release];
    [requester release];
    [super dealloc];
}

-(void)StockBarObjectAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    NSDictionary* curArgs = [userInfo valueForKey:RequsetCurArgs];
    if ([stageNumber intValue]==Stage_Request_SendStockSubject)
    {
        NSString* tid = [curArgs valueForKey:@"tid"];
        NSString* tipString = @"新主题发表成功";
        if (tid) {
            tipString = @"主题已成功回复";
        }
        [[LKTipCenter defaultCenter] postTopTipWithMessage:tipString time:2.0 color:nil];
    }
}

-(void)StockBarObjectFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    NSNumber* errorNumber = [userInfo valueForKey:RequsetStage];
    if ([stageNumber intValue]==Stage_Request_SendStockSubject)
    {
        
    }
}

-(void)startHotBarListWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockBarHost;
    httpAPI = [httpAPI stringByAppendingString:@"?s=bar&a=get_hot_bars&type=json"];
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];

    if (YES) {
        NSString* idString = @"page";
        [dict setObject:[NSString stringWithFormat:@"%d",npage] forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (countPerPage>0) {
        NSString* idKey = @"num";
        [dict setObject:[NSString stringWithFormat:@"%d",countPerPage] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setObject:[NSString stringWithFormat:@"%d",npage] forKey:RequsetPage];
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    if (args) {
        [userDict setValue:args forKey:RequsetArgs];
    }
    if (dataList) {
        [userDict setObject:dataList forKey:RequsetDataList];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_HotBarList userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startOneStockBarListWithSender:(id)sender stockName:(NSString*)stockName bid:(NSString*)bid count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockBarHost;
    httpAPI = [httpAPI stringByAppendingString:@"?s=bar&type=json"];
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (YES) {
        NSString* idString = @"page";
        [dict setObject:[NSString stringWithFormat:@"%d",npage] forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (countPerPage>0) {
        NSString* idKey = @"num";
        [dict setObject:[NSString stringWithFormat:@"%d",countPerPage] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (stockName&&!bid) {
        NSString* idKey = @"bname";
        [dict setObject:[NSString stringWithFormat:@"%@",stockName] forKey:idKey];
        [orderArray addObject:idKey];
    }
    if (bid) {
        NSString* idKey = @"bid";
        [dict setObject:[NSString stringWithFormat:@"%@",bid] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setObject:[NSString stringWithFormat:@"%d",npage] forKey:RequsetPage];
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    if (args) {
        [userDict setValue:args forKey:RequsetArgs];
    }
    if (dataList) {
        [userDict setObject:dataList forKey:RequsetDataList];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_OneStockBarList userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startSendStockSubjectWithSender:(id)sender stockName:(NSString*)stockName bid:(NSString*)bid tid:(NSString*)tid quotePid:(NSString*)quotePid title:(NSString*)title content:(NSString*)content args:(NSArray*)args userInfo:(id)userInfo
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockBarHost;
//    httpAPI = [httpAPI stringByAppendingString:@"?s=thread&a=post&source=sina_finance_cilent_ios"];
    httpAPI = [httpAPI stringByAppendingString:@"?s=thread&a=post"];
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (stockName&&!bid) {
        NSString* idKey = @"name";
        [dict setObject:[NSString stringWithFormat:@"%@",stockName] forKey:idKey];
        [orderArray addObject:idKey];
    }
    if (bid) {
        NSString* idKey = @"bid";
        [dict setObject:[NSString stringWithFormat:@"%@",bid] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (tid) {
        NSString* idKey = @"tid";
        [dict setObject:[NSString stringWithFormat:@"%@",tid] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (quotePid) {
        NSString* idKey = @"quotePid";
        [dict setObject:[NSString stringWithFormat:@"%@",quotePid] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    NSString* ipString = [[UIDevice currentDevice] localIPAddress];
    if (YES) {
        NSString* idKey = @"ip";
        //if (!(ipString&&[ipString length]>0&&[MyTool isLegalIP:ipString])) 
        if(YES)
        {
            NSDate* curDate = [NSDate date];
            NSTimeInterval interval = [curDate timeIntervalSince1970];
            NSInteger aaaInterval = (int)interval;
            ipString = [NSString stringWithFormat:@"169.1%d.1%d.1%d",(aaaInterval/10000)%100,(aaaInterval/100)%100,(aaaInterval)%100];
        }
        [dict setObject:[NSString stringWithFormat:@"%@",ipString] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (title||content) {
        if (!title) {
            title = ipString;
        }
        NSString* idKey = nil;
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        if (title&&[title length]>0) {
            idKey = @"title";
            title = [title rawUrlEncodeByEncoding:enc];
            httpAPI = [MyTool urlString:httpAPI replaceStringKey:idKey withValueString:title];
        }
        
        if (!content) {
            content = @" ";
        }
        idKey = @"content";
        NSString* newContent = [content rawUrlEncodeByEncoding:enc];
        httpAPI = [MyTool urlString:httpAPI replaceStringKey:idKey withValueString:newContent];
    }
    
    NSString* loginedID = [[WeiboLoginManager getInstance] loginedID];
    if (loginedID) {
        NSString* idKey = @"uid";
        [dict setObject:[NSString stringWithFormat:@"%@",loginedID] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (loginedID) {
        NSString* idKey = @"anonymous";
        [dict setObject:[NSString stringWithFormat:@"%@",@"0"] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    if (args) {
        [userDict setValue:args forKey:RequsetArgs];
    }
    if (userInfo) {
        [userDict setValue:userInfo forKey:RequsetInfo];
    }
    NSMutableDictionary* curArgs = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (tid) {
        [curArgs setValue:tid forKey:@"tid"];
    }
    if (bid) {
        [curArgs setValue:bid forKey:@"bid"];
    }
    if (stockName) {
        [curArgs setValue:stockName forKey:@"stock"];
    }
    [userDict setValue:curArgs forKey:RequsetCurArgs];
    [curArgs release];
    
    
//    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_SendStockSubject userInfo:userDict headerDict:nil bInback:NO];
    
    BOOL bInback = NO;
    NSDictionary* headerDict = nil;
    NSString* method = @"GET";
    NSInteger stageInteger = Stage_Request_SendStockSubject;
    NSString *urlStr = nil;
    if ([[method uppercaseString] isEqualToString:@"POST"]) {
        urlStr = httpAPI;
    }
    else
    {
        if (dict&&orderArray) {
            urlStr = [MyTool urlParmFormatWithSourceString:httpAPI FromDict:dict order:orderArray useEncode:YES];
        }
        else
        {
            urlStr = httpAPI;
        }
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    
    ASIFormDataRequest* request = [[[ASIFormDataRequest alloc] initWithURL :url] autorelease];
    request.tag = stageInteger;
    [request setRequestMethod:method];
    request.userInfo = userDict;
    if ([[method uppercaseString] isEqualToString:@"POST"]) {
        
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
    [request setTimeOutSeconds:30.0];
    NSInteger contentLen = [content length];
    if (contentLen<5000) {
        if (!bInback) {
            [self addRequestToDowloadQueue:request];
        }
        else
        {
            [self addRequestToOfflineQueue:request];
        }
    }
    else {
        NSMutableDictionary* oldInfo = (NSMutableDictionary*)request.userInfo;
        [oldInfo setValue:@"正文过长" forKey:RequsetErrorString];
        [self requestFailed:request];
    }
}

-(void)startOneStockBarReplyListWithSender:(id)sender stockName:(NSString*)stockName bid:(NSString*)bid tid:(NSString*)tid count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockBarHost;
    httpAPI = [httpAPI stringByAppendingString:@"?s=thread&type=json"];
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (YES) {
        NSString* idString = @"page";
        [dict setObject:[NSString stringWithFormat:@"%d",npage] forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (countPerPage>0) {
        NSString* idKey = @"num";
        [dict setObject:[NSString stringWithFormat:@"%d",countPerPage] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (stockName&&!bid) {
        NSString* idKey = @"bname";
        [dict setObject:[NSString stringWithFormat:@"%@",stockName] forKey:idKey];
        [orderArray addObject:idKey];
    }
    if (bid) {
        NSString* idKey = @"bid";
        [dict setObject:[NSString stringWithFormat:@"%@",bid] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (tid) {
        NSString* idKey = @"tid";
        [dict setObject:[NSString stringWithFormat:@"%@",tid] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setObject:[NSString stringWithFormat:@"%d",npage] forKey:RequsetPage];
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    if (args) {
        [userDict setValue:args forKey:RequsetArgs];
    }
    if (dataList) {
        [userDict setObject:dataList forKey:RequsetDataList];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_OneStockBarReplyList userInfo:userDict headerDict:nil bInback:NO];
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

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag==Stage_Request_HotBarList)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* codeNumber = [jsonDict objectForKey:@"ret"];
            if ([codeNumber isKindOfClass:[NSString class]]) {
                codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
            }
            if ([codeNumber intValue]>0) {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:nil notifyName:StockBarObjectAddedNotification];
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
    else if(request.tag==Stage_Request_OneStockBarList)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* codeNumber = [jsonDict objectForKey:@"ret"];
            if ([codeNumber isKindOfClass:[NSString class]]) {
                codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
            }
            if ([codeNumber intValue]>0) {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:nil notifyName:StockBarObjectAddedNotification];
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
    else if(request.tag==Stage_Request_SendStockSubject)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* codeNumber = [jsonDict objectForKey:@"ret"];
            if ([codeNumber isKindOfClass:[NSString class]]) {
                codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
            }
            if ([codeNumber intValue]>0) {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:nil notifyName:StockBarObjectAddedNotification];
            }
            else
            {
                NSNumber* reason = [jsonDict objectForKey:@"reason"];
                NSLog(@"request error reason=%@",reason);
                NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
                [userInfo setValue:reason forKey:RequsetErrorString];
                [self requestFailed:request];
            }
        }
        else
        {
            [self requestFailed:request];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_OneStockBarReplyList)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSString* errorString = [jsonDict valueForKey:@"reason"];
            if (errorString) {
                NSLog(@"requestFailed:%@",errorString);
            }
            NSNumber* codeNumber = [jsonDict objectForKey:@"ret"];
            if ([codeNumber isKindOfClass:[NSString class]]) {
                codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
            }
            if ([codeNumber intValue]>0) {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:nil notifyName:StockBarObjectAddedNotification];
            }
            else if(errorString)
            {
                NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
                [userInfo setValue:errorString forKey:RequsetErrorString];
                [userInfo setValue:[NSNumber numberWithInt:StockBar_RequestError_Unknown] forKey:RequsetError];
                [self requestFailed:request];
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

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
    NSDictionary* jsonDict = [resultString objectFromJSONString];
    if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
        NSNumber* codeNumber = [jsonDict objectForKey:@"ret"];
        if ([codeNumber isKindOfClass:[NSString class]]) {
            codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
        }
        if ([codeNumber intValue]==0) {
            NSString* errorString = [jsonDict valueForKey:@"reason"];
            NSLog(@"requestFailed:%@",errorString);
        }
    }
    [resultString release];
    NSLog(@"requestFailed.error.description:%@",request.error.description);
    [self afterDefaultFailed:request notifyName:StockBarObjectFailedNotification];
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
    [self initalDownloadQueue];
    [self.downloadQueue addOperation:request];
    [self.downloadQueue go];
}

-(void)addRequestToOfflineQueue:(ASIHTTPRequest*)request
{
    
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