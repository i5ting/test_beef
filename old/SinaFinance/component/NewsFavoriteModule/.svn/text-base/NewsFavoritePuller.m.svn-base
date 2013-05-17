//
//  NewsFavoritePuller.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsFavoritePuller.h"
#import "ASIFormDataRequest.h"
#import "WeiboLoginManager.h"
#import "MyTool.h"
#import "NSData+base64.h"
#import "JSONKit.h"
#import "NewsObject.h"
#import "ASINetworkQueue.h"
#import "CommentDataList.h"
#import "LKTipCenter.h"

NSString* HttpAPI_FavoriteNews = @"http://roll.news.sina.com.cn/api/weibo_subscribe/weibo_collect_add.php";
NSString* HttpAPI_RemoveFavoriteNews = @"http://roll.news.sina.com.cn/api/weibo_subscribe/weibo_collect_delete.php";
NSString* HttpAPI_FavoriteNewsList = @"http://roll.news.sina.com.cn/api/weibo_subscribe/weibo_collect_list.php";

@interface NewsFavoritePuller ()
@property(assign,readonly)NSDictionary* oAuthData;
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
-(void)afterDefaultSuccessed:(NSArray*)resultArray userRequst:(ASIHTTPRequest*)request notifyName:(NSString*)notifyName;
-(void)afterDefaultFailed:(ASIHTTPRequest*)request notifyName:(NSString*)notifyName;
@end

@implementation NewsFavoritePuller
@synthesize oAuthData;
@synthesize downloadQueue=mDownloadQueue;
@synthesize requester;

+ (id)getInstance
{
    static NewsFavoritePuller* s_messageManager = nil;
	if (s_messageManager == nil)
	{
		//没有创建则创建
		s_messageManager = [[NewsFavoritePuller alloc] init];
        
	}
	return s_messageManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(NewsFavoriteObjectAdded:)
                   name:NewsFavoriteObjectAddedNotification 
                 object:nil];
        [nc addObserver:self selector:@selector(NewsFavoriteObjectFailed:)
                   name:NewsFavoriteObjectFailedNotification 
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

-(NSDictionary*)oAuthData
{
    return [[WeiboLoginManager getInstance] oAuthData];
}

-(void)NewsFavoriteObjectAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    NSNumber* errorCode = [userInfo valueForKey:@"error"];
    if ([stageNumber intValue]==Stage_Request_FavoriteNews)
    {
        NSString* tipString = @"已成功收藏此条新闻,可在设置中查看";
        [[LKTipCenter defaultCenter] postTopTipWithMessage:tipString time:2.0 color:nil];
    }
}

-(void)NewsFavoriteObjectFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* errorCode = [userInfo valueForKey:RequsetError];
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    if([stageNumber intValue]==Stage_Request_FavoriteNews){
        NSString* tipString = @"收藏新闻失败了";
        if (errorCode&&[errorCode intValue]==4) {
            tipString = @"收藏新闻失败,已到50条收藏上限!";
        }
        else if (errorCode&&[errorCode intValue]==2) {
            tipString = @"收藏新闻失败,重复收藏!可在设置中查看";
        }
        else
        {
            tipString = @"收藏新闻失败,请检查网络后重试!";
        }
        [[LKTipCenter defaultCenter] postTopTipWithMessage:tipString time:2.0 color:nil];
    }
}

-(void)startFavoriteNewsWithSender:(id)sender newsurl:(NSString*)newsurl title:(NSString*)title videoImg:(NSString*)videoImg videoURL:(NSString*)videoURL
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    
    NSString* httpAPI = HttpAPI_FavoriteNews;
    
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
    
    NSString* uid = [self.oAuthData objectForKey:LoginReturnKey_User_id];
    if(uid)
    {
        NSString* idkey = @"uid";
        [dict setObject:uid forKey:idkey];
        [orderArray addObject:idkey];
    }
    
    NSString *urlStr = [MyTool urlParmFormatWithSourceString:httpAPI FromDict:dict order:orderArray useEncode:YES];
    NSString* idkey = @"content";
    NSString* argJson = @"";
    if (title) {
        if (argJson&&![argJson isEqualToString:@""]) {
            argJson = [argJson stringByAppendingFormat:@",\"title\":\"%@\"",title];
        } 
        else
        {
            argJson = [argJson stringByAppendingFormat:@"\"title\":\"%@\"",title];
        }
    }
    
    if (newsurl) {
        if (argJson&&![argJson isEqualToString:@""]) {
            argJson = [argJson stringByAppendingFormat:@",\"url\":\"%@\"",newsurl];
        } 
        else
        {
            argJson = [argJson stringByAppendingFormat:@"\"url\":\"%@\"",newsurl];
        }
    }
    /*
    if (videoImg) {
        if (argJson&&![argJson isEqualToString:@""]) {
            argJson = [argJson stringByAppendingFormat:@",\"videoimg\":\"%@\"",videoImg];
        } 
        else
        {
            argJson = [argJson stringByAppendingFormat:@"\"videoimg\":\"%@\"",videoImg];
        }
    }
    
    if (videoURL) {
        if (argJson&&![argJson isEqualToString:@""]) {
            argJson = [argJson stringByAppendingFormat:@",\"videourl\":\"%@\"",videoURL];
        } 
        else
        {
            argJson = [argJson stringByAppendingFormat:@"\"videourl\":\"%@\"",videoURL];
        }
    }
    */
    if (argJson) {
        argJson = [NSString stringWithFormat:@"{%@}",argJson];
    }
    
    NSString* jsonStringEnc = [NSString stringWithFormat:@"&%@=%@",idkey,[argJson rawUrlEncode]];
    urlStr = [urlStr stringByAppendingString:jsonStringEnc];
    
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (YES) {
        [headerDict setValue:@"no-cache" forKey:@"cache_control"];
        [headerDict setValue:@"no-cache" forKey:@"Pragma"];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:nil order:nil api:urlStr stage:Stage_Request_FavoriteNews userInfo:nil headerDict:headerDict bInback:NO];
    [headerDict release];
}

-(void)startRemoveFavoriteNewsWithSender:(id)sender idstr:(NSString*)idstr inBack:(BOOL)bInBack
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    
    NSString* uid = [self.oAuthData objectForKey:LoginReturnKey_User_id];
    
    NSString* urlStr = nil;
    urlStr = [NSString stringWithFormat:@"%@?uid=%@&id=%@",HttpAPI_RemoveFavoriteNews,uid,idstr];
    
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (YES) {
        [headerDict setValue:@"no-cache" forKey:@"cache_control"];
        [headerDict setValue:@"no-cache" forKey:@"Pragma"];
    }
    
    NSArray* apiCode = [NSArray arrayWithObjects:urlStr,nil];
    
    [self startAPIRequest:sender withAPICode:apiCode pagename:nil pagevalue:0 countname:nil countvalue:0 args:nil stage:Stage_Request_RemoveFavoriteNews otherUserInfo:nil headerInfo:headerDict inBack:bInBack];
    [headerDict release];
}

-(void)startFavariteListNews:(NSInteger)nPage args:(NSArray*)args dataList:(CommentDataList*)dataList bInback:(BOOL)bInback
{
    
    NSString* httpAPI = HttpAPI_FavoriteNewsList;
    NSString* ListPage = nil;
    
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
    
    NSString* uid = [self.oAuthData objectForKey:LoginReturnKey_User_id];
    if(uid)
    {
        NSString* idkey = @"uid";
        [dict setObject:uid forKey:idkey];
        [orderArray addObject:idkey];
    }
    if(nPage <= 0)
    {
        ListPage = [NSString stringWithFormat:@"%d", 1];
    }
    else
    {
        ListPage = [NSString stringWithFormat:@"%d", nPage];
    }
    NSString* idkey = @"page";
    [dict setObject:ListPage forKey:idkey];
    [orderArray addObject:idkey];
    
    NSString* pagesizekey = @"pagesize";
    [dict setObject:@"60" forKey:pagesizekey];
    [orderArray addObject:pagesizekey];
    
    NSMutableDictionary* notifyinfodict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [notifyinfodict setObject:[NSNumber numberWithInt:[ListPage intValue]] forKey:RequsetPage];
    if (dataList) {
        [notifyinfodict setValue:dataList forKey:RequsetDataList];
    }
    if (args) {
        [notifyinfodict setValue:args forKey:RequsetArgs];
    }
    
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (YES) {
        [headerDict setValue:@"no-cache" forKey:@"cache_control"];
        [headerDict setValue:@"no-cache" forKey:@"Pragma"];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_FavoriteNewsList userInfo:notifyinfodict headerDict:headerDict bInback:bInback];
    
    [headerDict release];
    
}
-(void)afterFavoriteNewsListSuccessed:(NSDictionary*)jsonDict userRequst:(ASIHTTPRequest*)request
{
    NSMutableArray* favoriteArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableArray* keyarray = [NSMutableArray arrayWithArray:[jsonDict allKeys]];
    [keyarray sortUsingSelector:@selector(compare:)];
    for (id key in keyarray) {
        if(![key isEqualToString:@"page"])
        {
            NSDictionary* dict = [jsonDict objectForKey:key];
            NSString* content = [dict objectForKey:@"content"];
            if (![content isKindOfClass:[NSNull class]])
            {
                NSDictionary* contentDict = [content objectFromJSONString];
                NSMutableDictionary* newDict = [[NSMutableDictionary alloc] initWithDictionary:contentDict];
                [newDict setValue:[dict valueForKey:@"id"] forKey:@"id"];
                NewsObject* FavoriteNewsObject = [[NewsObject alloc] initWithJsonDictionary:newDict];
                [favoriteArray addObject:FavoriteNewsObject];
                [FavoriteNewsObject release];
                [newDict release];
            }
        }
    }
    
    [self afterDefaultSuccessed:favoriteArray userRequst:request notifyName:NewsFavoriteObjectAddedNotification];
    [favoriteArray release];
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
    if(request.tag==Stage_Request_FavoriteNews)
    {
        NSString* resultString = request.responseString;
        if (resultString) {
            NSNumber* resultNumber = [NSNumber numberWithInt:[resultString intValue]];
            if ([resultNumber intValue]==1) {
                [self afterDefaultSuccessed:nil userRequst:request notifyName:NewsFavoriteObjectAddedNotification];
            }
            else
            {
                NSMutableDictionary* infoDict = (NSMutableDictionary*)request.userInfo; 
                if (!infoDict) {
                    infoDict = [[NSMutableDictionary alloc] initWithCapacity:0];
                    request.userInfo = infoDict;
                    [infoDict release];
                }
                [infoDict setValue:resultString forKey:RequsetError];
                [self afterDefaultFailed:request notifyName:NewsFavoriteObjectFailedNotification];
            }
        }
        else
        {
            [self afterDefaultFailed:request notifyName:NewsFavoriteObjectFailedNotification];
        }
    }
    else if(request.tag == Stage_Request_FavoriteNewsList)
    {
        NSString* resultString = request.responseString;
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if([jsonDict  isKindOfClass:[NSDictionary class]])
        {
            [self afterFavoriteNewsListSuccessed:jsonDict userRequst:request];
        }
        else
        {
            [self afterDefaultSuccessed:nil userRequst:request notifyName:NewsFavoriteObjectFailedNotification];
        }
    }
    else if(request.tag==Stage_Request_RemoveFavoriteNews)
    {
        NSString* resultString = request.responseString;
        if ([resultString isEqualToString:@"1"]) {
            [self afterDefaultSuccessed:nil userRequst:request notifyName:NewsFavoriteObjectAddedNotification];
        }
        else
        {
            [self afterDefaultFailed:request notifyName:NewsFavoriteObjectFailedNotification];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self afterDefaultFailed:request notifyName:NewsFavoriteObjectFailedNotification];
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
