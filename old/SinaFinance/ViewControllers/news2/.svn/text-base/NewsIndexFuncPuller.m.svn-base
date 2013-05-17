//
//  NewsIndexFuncPuller.m
//  SinaFinance
//
//  Created by sang on 10/26/12.
//
//

#import "NewsIndexFuncPuller.h"
#import "ASIHTTPRequest.h"
#import "NSData+base64.h"
#import "CommentDataList.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "MyTool.h"
#import "JSONKit.h"

@interface NewsIndexFuncPuller ()
@property(retain)ASIHTTPRequest* requester;

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

@implementation NewsIndexFuncPuller
@synthesize downloadQueue=mDownloadQueue;
@synthesize requester;

+ (id)getInstance
{
    static NewsIndexFuncPuller* s_messageManager = nil;
	if (s_messageManager == nil)
	{
		//没有创建则创建
		s_messageManager = [[NewsIndexFuncPuller alloc] init];
        
	}
	return s_messageManager;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mDownloadQueue release];
    [requester release];
    [super dealloc];
}

-(void)startListWithSender:(id)sender page:(NSInteger)page endTime:(NSTimeInterval)etime count:(NSInteger)countPerPage withAPICode:(NSArray*)codeArray args:(NSArray*)args dataList:(CommentDataList*)dataList bInback:(BOOL)bInback;
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString* urlStr = [codeArray objectAtIndex:0];
    NSString* pageName = @"page";
    NSString* countName = @"num";
    
    NSArray* curAPIs = [NSArray arrayWithObjects:@"http://platform.sina.com.cn/client/list?app_key=3346933778&partid=1", nil];
    if ([curAPIs isEqualToArray:codeArray]) {
         //page=18&len=20

        urlStr = [urlStr stringByAppendingFormat:@"&len=%d",countPerPage];
         urlStr = [urlStr stringByAppendingFormat:@"&page=%d",page];
    }
    
    if (countPerPage>0) {
        urlStr = [urlStr stringByAppendingFormat:@"&%@=%d",countName,countPerPage];
    }
    if (etime>1.0) {
        urlStr = [urlStr stringByAppendingFormat:@"&%@=%d",@"endtime",(int)(etime-1)];
    }
    if (etime>1.0) {
        [dict setObject:[NSNumber numberWithFloat:etime-1] forKey:@"endtime"];
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"NewsIndexFuncPuller url = %@",urlStr);
    if (sender) {
        [dict setValue:sender forKey:RequsetSender];
    }
    [dict setValue:[NSDate date] forKey:RequsetDate];
    if (args) {
        [dict setObject:args forKey:RequsetArgs];
    }
    [dict setObject:[NSNumber numberWithInt:page] forKey:RequsetPage];
    [dict setObject:[NSNumber numberWithInt:countPerPage] forKey:RequsetCount];
    if (dataList) {
        [dict setValue:dataList forKey:RequsetDataList];
    }
    [dict setValue:[NSNumber numberWithInt:RequestType_List] forKey:RequsetType];
    [self startHttpAPIRequstByURL:url headerDict:nil userInfo:dict stage:0 inBack:bInback];
    [dict release];
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
    [self afterDefaultFailed:request notifyName:CommonListFailedNotification];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
    NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
    NSString* resultString = request.responseString;
    NSMutableDictionary* jsonDict = [resultString mutableObjectFromJSONString];
    if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
        NSDictionary* resultDict = nil;
        resultDict = [jsonDict objectForKey:@"result"];
        NSMutableDictionary* statusDict = [resultDict objectForKey:@"status"];
        NSNumber* codeValue = [statusDict objectForKey:@"code"];
        if ([codeValue isKindOfClass:[NSString class]]) {
            codeValue = [NSNumber numberWithInt:[codeValue intValue]];
        }
        if ([codeValue intValue]==0) {
            NSMutableArray* dataArray = [resultDict valueForKey:@"data"];
            
            
            
            if ([dataArray count]>1) {
                
                NSMutableArray *topArray = [(NSDictionary *)[dataArray objectAtIndex:0] objectForKey:@"data"] ;
                NSMutableArray *newsArray = [(NSDictionary *)[dataArray objectAtIndex:1] objectForKey:@"data"] ;
                
                //            NSMutableArray* scrollArray = [dataDict valueForKey:@"scroll"];
                //            NSMutableArray* topArray = [dataDict valueForKey:@"top"];
                for (NSMutableDictionary* topDict in topArray) {
                    [topDict setValue:@"1" forKey:@"top"];
                }
                
                NSMutableArray* tempArray = [[NSMutableArray alloc] initWithCapacity:0];
                //            if ([pageNumber intValue]<=1) {
                //                [tempArray addObjectsFromArray:topArray];
                //                [tempArray addObjectsFromArray:newsArray];
                //            }
                [tempArray addObjectsFromArray:topArray];
                
                NSArray *argeArray = [userInfo valueForKey:RequsetArgs];
 
                NSLog(@"%@",argeArray.description);
                
                NSRange range = [argeArray.debugDescription rangeOfString:@"index"];
                
                if (range.location == NSNotFound ){//不包含
                    [[NSUserDefaults standardUserDefaults] setObject:topArray  forKey:@"worldEyeArray111"];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:topArray  forKey:@"topNewsArray111"];
                }
                
                 
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if ([topArray count]>0) {
                    [tempArray addObject:[newsArray objectAtIndex:0]];
                    [tempArray addObjectsFromArray:newsArray];
                }
                
                
                NSMutableDictionary* usefullDict = [[NSMutableDictionary alloc] initWithCapacity:0];
                [usefullDict setValue:tempArray forKey:@"data"];
                NSNumber* countNumber = [userInfo valueForKey:RequsetCount];
                NSArray* args = [userInfo valueForKey:RequsetArgs];
                CommentDataList* dataList = [userInfo valueForKey:RequsetDataList];
                if ([countNumber intValue]==[newsArray count]) {
                    [dataList setPageEndInfoWithIDList:args value:NO];
                }
                else {
                    [dataList setPageEndInfoWithIDList:args value:YES];
                }
                [userInfo setValue:[NSNumber numberWithBool:YES] forKey:RequsetIgnorePageEnd];
                [self afterDefaultSuccessed:usefullDict userRequst:request dataname:nil notifyName:CommonListSucceedNotification];
                [tempArray release];
                [usefullDict release];
            }else{
//                NSMutableArray *topArray = [(NSDictionary *)[dataArray objectAtIndex:0] objectForKey:@"data"] ;
                NSMutableArray *newsArray = [(NSDictionary *)[dataArray objectAtIndex:0] objectForKey:@"data"] ;
                
#ifdef DEBUG
                for (NSDictionary *d in newsArray) {
                    NSLog(@"%d : %@-- %@",[[d objectForKey:@"id"] intValue],[d objectForKey:@"title"],[d objectForKey:@"url"]);
                }
          
                NSLog(@"------------------------------------------------------------------------------------");
#endif
                //            NSMutableArray* scrollArray = [dataDict valueForKey:@"scroll"];
                //            NSMutableArray* topArray = [dataDict valueForKey:@"top"];
                
                
                NSMutableArray* tempArray = [[NSMutableArray alloc] initWithCapacity:0];
                //            if ([pageNumber intValue]<=1) {
                //                [tempArray addObjectsFromArray:topArray];
                //                [tempArray addObjectsFromArray:newsArray];
                //            }
//                [tempArray addObjectsFromArray:topArray];
                
//                [[NSUserDefaults standardUserDefaults] setObject:topArray  forKey:@"topNewsArray111"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                if ([newsArray count]>0) {
//                    [tempArray addObject:[newsArray objectAtIndex:0]];
                    [tempArray addObjectsFromArray:newsArray];
                }
                
                
                NSMutableDictionary* usefullDict = [[NSMutableDictionary alloc] initWithCapacity:0];
                [usefullDict setValue:tempArray forKey:@"data"];
                NSNumber* countNumber = [userInfo valueForKey:RequsetCount];
                NSArray* args = [userInfo valueForKey:RequsetArgs];
                CommentDataList* dataList = [userInfo valueForKey:RequsetDataList];
                if ([countNumber intValue]==[newsArray count]) {
                    [dataList setPageEndInfoWithIDList:args value:NO];
                }
                else {
                    [dataList setPageEndInfoWithIDList:args value:YES];
                }
                [userInfo setValue:[NSNumber numberWithBool:YES] forKey:RequsetIgnorePageEnd];
                [self afterDefaultSuccessed:usefullDict userRequst:request dataname:nil notifyName:CommonListSucceedNotification];
                [tempArray release];
                [usefullDict release];
                
         
                
            }
            
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonListFailedNotification];
        }
    }
    else
    {
        [self afterDefaultFailed:request notifyName:CommonListFailedNotification];
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
