//
//  StockFuncPuller.m
//  SinaFinance
//
//  Created by shieh exbice on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StockFuncPuller.h"
#import "ASIFormDataRequest.h"
#import "MyTool.h"
#import "NSData+base64.h"
#import "JSONKit.h"
#import "NewsObject.h"
#import "ASINetworkQueue.h"
#import "CommentDataList.h"
#import "UIDevice-Reachability.h"
#import "StockLoginManager.h"
#import "XMLReader.h"
#import "ASIDownloadCache.h"

#define StockObjectAddedInternalNotification @"StockObjectAddedInternalNotification"
#define StockObjectFailedInternalNotification @"StockObjectFailedInternalNotification"

NSString* HttpAPI_StockListHost = @"http://stock2.finance.sina.com.cn/iphone/api/json.php/HqService.getList";
NSString* HttpAPI_OneStockInfoHost = @"http://stock2.finance.sina.com.cn/iphone/api/json.php/HqService.getHq";
NSString* HttpAPI_MultiStockInfoHost = @"http://stock.finance.sina.com.cn/iphone/api/json.php/HqService.getHqListAll";
NSString* HttpAPI_OneFundInfoHost = @"http://money.finance.sina.com.cn/fund_center/api/json.php/NetValue_Service.getNetValueForIPone";
NSString* HttpAPI_OneFundTypeHost = @"http://money.finance.sina.com.cn/fund_center/api/json.php/NetValue_Service.getSymbolType";
NSString* HttpAPI_OneFundNetValueHost = @"http://money.finance.sina.com.cn/fund_center/api/json.php/NetValue_Service.getNetValueForIPone";

NSString* HttpAPI_OneStockNewsHost = @"http://stock2.finance.sina.com.cn/iphone/api/json.php/NewsService.getNews?___qn=3";
NSString* HttpAPI_OneCnStockReportHost = @"http://vip.stock.finance.sina.com.cn/q/api/json.php/ReportService.getList?___oe=utf-8&kind=lastest&t1=2";
NSString* HttpAPI_OneCnStockNoticeHost = @"http://money.finance.sina.com.cn/api/json.php/CB_AllService.getBulletinList";
NSString* HttpAPI_OneHkStockNoticeHost = @"http://stock.finance.sina.com.cn/hkstock/api/json.php/CompanyNoticeService.getNotice_wap";
NSString* HttpAPI_OneCnStockReportContentHost = @"http://vip.stock.finance.sina.com.cn/q/api/json.php/ReportService.getShow?&simple=1";
NSString* HttpAPI_OneCnStockNoticeContentHost = @"http://money.finance.sina.com.cn/api/json.php/CB_AllService.getAllBulletinDetailInfo";
NSString* HttpAPI_OneHkStockNoticeContentHost = @"http://stock.finance.sina.com.cn/hkstock/api/openapi.php/CompanyNoticeService.getOneNotice_wap?___qn=3";

NSString* HttpAPI_ObtainMyGroupAPIVersion = @"http://money.finance.sina.com.cn/work/get_version.php?source=iphone_app&key=f3b2ca9bfb5fd3343c536ec7c0fb0afa&itype=inteface_addr&params=portfolios";
NSString* HttpAPI_MyStockListHost = @"http://stock2.finance.sina.com.cn/iphone/api/json.php/HqService.getHqList";
NSString* HttpAPI_MyFundListHost = @"http://stock.finance.sina.com.cn/iphone/api/json.php/HqService.getFundHqList";
NSString* HttpAPI_AddStockSuggestHost = @"http://suggest3.sinajs.cn/suggest/type=41,11,12,13,21,22,23,24,25,26,31&key=${1}";
NSString* HttpAPI_AddStockSuggestHost_CN = @"http://suggest3.sinajs.cn/suggest/type=11,12,13&key=${1}";
NSString* HttpAPI_AddStockSuggestHost_HK = @"http://suggest3.sinajs.cn/suggest/type=31,32&key=${1}";
NSString* HttpAPI_AddStockSuggestHost_US = @"http://suggest3.sinajs.cn/suggest/type=41&key=${1}";
NSString* HttpAPI_AddStockSuggestHost_FUND = @"http://suggest3.sinajs.cn/suggest/type=21,22,23,24,25,26&key=${1}";
NSString* HttpAPI_StockLookupHost = @"http://biz.finance.sina.com.cn/suggest/lookup_forwap.php?q=${1}";
NSString* HttpAPI_SearchHotStockHost = @"http://finance.sina.com.cn/realstock/company/hotstock_daily_a.txt";
NSString* HttpAPI_AddStockRemindSuggestHost = @"http://suggest3.sinajs.cn/suggest/type=11,12,31,41&key=${1}";
NSString* HttpAPI_StockRemindStartupHost = @"http://money.finance.sina.com.cn/portfolio3/api/json_alert3.php/callback/AlertInterfaceService.setUserTerminalActiveSts";
NSString* HttpAPI_StockRemindUserInfoHost = @"http://money.finance.sina.com.cn/portfolio3/api/json_alert3.php/null/AlertInterfaceService.userTerminalInfo";
NSString* HttpAPI_StockRemindAddInfoHost = @"http://money.finance.sina.com.cn/portfolio3/api/json_alert3.php/null/AlertService2.addAlertByJson";
NSString* HttpAPI_StockRemindRemoveInfoHost = @"http://money.finance.sina.com.cn/portfolio3/api/json_alert3.php/null/AlertService2.removeAlertByJson";
NSString* HttpAPI_StockRemindUpdateInfoHost = @"http://money.finance.sina.com.cn/portfolio3/api/json_alert3.php/null/AlertService2.updateAlertByJson";
NSString* HttpAPI_StockRemindListHost = @"http://money.finance.sina.com.cn/portfolio3/api/json_alert3.php/null/AlertService2.listAlerts?source=iphone_app&markets=sh,sz,hk,us";
NSString* HttpAPI_StockRemindHistoryListHost = @"http://money.finance.sina.com.cn/portfolio3/api/json_alert3.php/null/SendSummaryService.getAlertSendList?source=iphone_app&chr_encoding=0&search_days=10";


@interface StockFuncPuller ()
@property(retain)NSDictionary* groupAPIDict;
@property(assign,readonly)NSDictionary* oAuthData;
@property(retain)ASIHTTPRequest* requester;
@property(retain)NSMutableArray* seperateRequestArray;

-(void)startHttpAPIRequestV2:(NSString*)method data:(NSDictionary*)dict order:(NSArray*)orderArray api:(NSString*)HttpAPI stage:(NSInteger)stageInteger userInfo:(NSDictionary*)userData headerDict:(NSDictionary*)headerDict bInback:(BOOL)bInback;
-(void)startAPIRequest:(id)sender withAPICode:(NSArray*)codeArray pagename:(NSString*)pageName pagevalue:(NSInteger)pageValue countname:(NSString*)countName countvalue:(NSInteger)countValue args:(NSArray*)args stage:(NSInteger)stage otherUserInfo:(NSDictionary*)oUserInfo headerInfo:(NSDictionary*)headerDict inBack:(BOOL)bInBack useCache:(BOOL)useCache;
-(void)befereGroupAPICalledWithMethod:(NSString*)method data:(NSDictionary*)dict order:(NSArray*)orderArray api:(NSString*)HttpAPI stage:(NSInteger)stageInteger userInfo:(NSDictionary*)userData headerDict:(NSDictionary*)headerDict bInback:(BOOL)bInback searchKey:(NSString*)searchKey;
-(void)afterGroupAPIAdded:(NSDictionary*)userInfo api:(NSString*)api;
-(void)startMyGroupWithSender:(id)sender service:(NSString*)service task:(NSString*)task stock:(NSArray*)stock groupPID:(NSString*)groupPID stage:(NSInteger)stage args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info;
-(void)startHttpAPIRequstByURL:(NSURL*)url headerDict:(NSDictionary*)headerDict userInfo:(NSDictionary*)info stage:(NSInteger)stageInt inBack:(BOOL)bInBack useCache:(BOOL)useCache;
-(void)sendNotificationWithName:(NSString*)nofityName stage:(NSInteger)stage info:(NSDictionary*)info;
-(void)mainThreadRunningNotification:(NSDictionary*)argInfo;
-(void)clearRequestQueue;
-(void)initalDownloadQueue;
-(void)afterDefaultSuccessed:(NSDictionary*)jsonDict userRequst:(ASIHTTPRequest*)request dataname:(NSString*)dateName notifyName:(NSString*)notifyName;
-(void)afterDefaultSuccessed:(NSArray*)resultArray userRequst:(ASIHTTPRequest*)request notifyName:(NSString*)notifyName;
-(void)afterDefaultFailed:(ASIHTTPRequest*)request notifyName:(NSString*)notifyName;
- (void)requestFailed:(ASIHTTPRequest *)request;
-(void)retryRequest:(ASIHTTPRequest*)request loginKey:(NSString*)loginKey;
-(void)startObtainMyGroupAPIVersionWithSender:(id)sender args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startObtainMyGroupAPIWithSender:(id)sender version:(NSString*)version args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
@end

@implementation StockFuncPuller
{
    NSDictionary* groupAPIDict;
    NSMutableArray* seperateRequestArray;
}
@synthesize downloadQueue;
@synthesize requester;
@synthesize oAuthData;
@synthesize groupAPIDict;
@synthesize seperateRequestArray;

+ (id)getInstance
{
    static StockFuncPuller* s_messageManager = nil;
	if (s_messageManager == nil)
	{
		//没有创建则创建
		s_messageManager = [[StockFuncPuller alloc] init];
        
	}
	return s_messageManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self 
               selector:@selector(MyGroupAPIAdded:) 
                   name:StockObjectAddedNotification  
                 object:nil];
        [nc addObserver:self 
               selector:@selector(MyGroupAPIFailed:) 
                   name:StockObjectFailedNotification 
                 object:nil];
        [nc addObserver:self 
               selector:@selector(StockObjectAddedInternal:) 
                   name:StockObjectAddedInternalNotification  
                 object:nil];
        [nc addObserver:self 
               selector:@selector(StockObjectFailedInternal:) 
                   name:StockObjectFailedInternalNotification 
                 object:nil];
        
        
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [requester release];
    [groupAPIDict release];
    [seperateRequestArray release];
    [super dealloc];
}

-(NSDictionary*)oAuthData
{
    return [[WeiboLoginManager getInstance] oAuthData];
}

-(ASINetworkQueue*)downloadQueue
{
    if (!downloadQueue) {
        return [[WeiboLoginManager getInstance] downloadQueue];
    }
    else {
        return downloadQueue;
    }
}

-(void)MyGroupAPIAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_ObtainMyGroupAPIVersion)
        {
            NSString* version = [userInfo valueForKey:RequsetExtra];
            id oldUserInfo = [userInfo valueForKey:RequsetInfo];
            [self startObtainMyGroupAPIWithSender:self version:version args:nil dataList:nil userInfo:oldUserInfo];
        }
        else if ([stageNumber intValue]==Stage_Request_ObtainMyGroupAPI)
        {
            NSDictionary* versionDict = [userInfo valueForKey:RequsetExtra];
            NSDictionary* oldUserInfo = [userInfo valueForKey:RequsetInfo];
            self.groupAPIDict = versionDict;
            NSString* searchKey = [oldUserInfo valueForKey:PullerData_HTTPAPI_SearchKey];
            NSString* service = [oldUserInfo valueForKey:PullerData_RequestAPI];
            NSString* httpAPI = [self.groupAPIDict valueForKey:searchKey];
            if (service) {
                if ([httpAPI rangeOfString:@"PortfoliosService"].location!=NSNotFound) {
                    httpAPI = [httpAPI stringByReplacingOccurrencesOfString:@"PortfoliosService" withString:service];
                }
                else {
                    httpAPI = [httpAPI stringByReplacingOccurrencesOfString:@"USstockService" withString:service];
                }
            }
#ifdef TEST
            if ([httpAPI rangeOfString:@"iphone_zx_test"].location==NSNotFound) {
                httpAPI = [httpAPI stringByReplacingOccurrencesOfString:@"iphone_zx" withString:@"zx_client_t_test"];
            }
            else {
                httpAPI = [httpAPI stringByReplacingOccurrencesOfString:@"iphone_zx_test" withString:@"zx_client_t_test"];
            }
#else
            if ([httpAPI rangeOfString:@"iphone_zx_test"].location==NSNotFound) {
                httpAPI = [httpAPI stringByReplacingOccurrencesOfString:@"iphone_zx" withString:@"zx_client_t"];
            }
            else {
                httpAPI = [httpAPI stringByReplacingOccurrencesOfString:@"iphone_zx_test" withString:@"zx_client_t"];
            }
#endif
            httpAPI = [[httpAPI componentsSeparatedByString:@"?"] objectAtIndex:0];
            [self afterGroupAPIAdded:oldUserInfo api:httpAPI];
        }
        else if([stageNumber intValue]==Stage_Request_MultiStockInfo)
        {
            NSArray* array = [userInfo valueForKey:RequsetArray];
            ASIHTTPRequest* oldRequest = [userInfo valueForKey:RequsetInfo];
            NSDictionary* oldUserInfo = oldRequest.userInfo;
            NSDictionary* extraDict = [oldUserInfo valueForKey:RequsetExtra];
            if (oldRequest.tag==Stage_Request_StockRemindList) {
                NSDictionary* dict = [extraDict valueForKey:@"dict"];
                NSArray* dataArray = [dict valueForKey:@"data"];
                for (NSMutableDictionary* realDict in dataArray) {
                    NSString* oldSymbol = [realDict valueForKey:StockFunc_RemindStockList_fullsymbol];
                    for (NewsObject* oneObject in array) {
                        NSString* inputSymbol = [oneObject valueForKey:StockFunc_MultiStock_input];
                        if ([[inputSymbol lowercaseString] isEqualToString:[oldSymbol lowercaseString]]) {
                            [realDict addEntriesFromDictionary:oneObject.dataDict];
                            break;
                        }
                    }
                }
                [self afterDefaultSuccessed:dict userRequst:oldRequest dataname:nil notifyName:StockObjectAddedNotification];
            }
            else if (oldRequest.tag==Stage_Request_StockRemindHistoryList)
            {
                NSDictionary* dict = [extraDict valueForKey:@"dict"];
                NSArray* dataArray = [dict valueForKey:@"data"];
                for (NSMutableDictionary* realDict in dataArray) {
                    NSString* oldSymbol = [realDict valueForKey:StockFunc_RemindHistoryList_fullsymbol];
                    for (NewsObject* oneObject in array) {
                        NSString* inputSymbol = [oneObject valueForKey:StockFunc_MultiStock_input];
                        if ([[inputSymbol lowercaseString] isEqualToString:[oldSymbol lowercaseString]]) {
                            [realDict addEntriesFromDictionary:oneObject.dataDict];
                            break;
                        }
                    }
                }
                [self afterDefaultSuccessed:dict userRequst:oldRequest dataname:nil notifyName:StockObjectAddedNotification];
            }
        }
        else if ([stageNumber intValue]==Stage_Request_StockList)
        {
            NSArray* sourceArray = [userInfo valueForKey:RequsetSourceArray];
            ASIHTTPRequest* oldRequest = [userInfo valueForKey:RequsetInfo];
            NSString* oldURLString = [oldRequest.url absoluteString];
            NSString* oldType = [MyTool urlString:oldURLString valueForKey:@"type"];
            NSDictionary* oldUserInfo = oldRequest.userInfo;
            NSMutableDictionary* extraDict = [oldUserInfo valueForKey:RequsetExtra];
            NSMutableArray* oldSourceArray = [extraDict valueForKey:@"data"];
            NSMutableDictionary* marketIndexDict = [self modifiedMarketIndexDictWithArray:sourceArray type:oldType];
            if(marketIndexDict&&oldSourceArray)
            {
                if ([[marketIndexDict objectForKey:@"cn_name"] isEqual:@"恒指"]) {
                    [marketIndexDict setObject:@"恒生指数" forKey:@"cn_name"];
                }
                
                if ([[marketIndexDict objectForKey:@"cn_name"] isEqual:@"纳指"]) {
                    [marketIndexDict setObject:@"纳斯达克" forKey:@"cn_name"];
                }
                
                if ([[marketIndexDict objectForKey:@"cn_name"] isEqual:@"道指"]) {
                    [marketIndexDict setObject:@"道琼斯" forKey:@"cn_name"];
                }
                
                [oldSourceArray addObject:marketIndexDict];
            }
            [self afterDefaultSuccessed:extraDict userRequst:oldRequest dataname:nil notifyName:StockObjectAddedNotification];
        }
        
    }
}

-(void)afterGroupAPIAdded:(NSDictionary*)userInfo api:(NSString*)api
{
    NSString* method = [userInfo valueForKey:PullerData_RequestMethod];
    NSDictionary* data = [userInfo valueForKey:PullerData_RequestData];
    NSArray* orderArray = [userInfo valueForKey:PullerData_RequestOrder];
    NSString* httpAPI = [userInfo valueForKey:PullerData_RequestAPI];
    NSNumber* stageNumber = [userInfo valueForKey:PullerData_RequestStage];
    NSDictionary* oldUserInfo = [userInfo valueForKey:PullerData_RequestUserInfo];
    NSDictionary* headerDict = [userInfo valueForKey:PullerData_RequestHeaderDict];
    NSNumber* inBackNumber = [userInfo valueForKey:PullerData_RequestInBack];
    [self startHttpAPIRequestV2:method data:data order:orderArray api:api stage:[stageNumber intValue] userInfo:oldUserInfo headerDict:headerDict bInback:[inBackNumber boolValue]];
}

-(void)MyGroupAPIFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        NSDictionary* oldUserInfo = [userInfo valueForKey:RequsetInfo];
        if ([oldUserInfo isKindOfClass:[NSDictionary class]]) {
            ASIHTTPRequest* requst = [[ASIHTTPRequest alloc] initWithURL:nil];
            NSDictionary* realUserInfo = [oldUserInfo valueForKey:PullerData_RequestUserInfo];
            requst.userInfo = realUserInfo;
            NSNumber* oldStageNumber = [realUserInfo valueForKey:RequsetStage];
            requst.tag = [oldStageNumber intValue];
            [self requestFailed:requst];
            [requst release];
        }
        else if([oldUserInfo isKindOfClass:[ASIHTTPRequest class]])
        {
            ASIHTTPRequest* oldRequest = (ASIHTTPRequest*)oldUserInfo;
            [self requestFailed:oldRequest];
        }
    }
}

-(void)StockObjectAddedInternal:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    if ([stageNumber intValue]==Stage_Request_StockRemindList) {
         ASIHTTPRequest* requset = [notify.userInfo valueForKey:RequsetPreRequset];
        NSDictionary* extraDict = [requset.userInfo valueForKey:RequsetExtra];
        NSMutableDictionary* dict = [extraDict valueForKey:@"dict"];
        NSArray* dataArray = [dict valueForKey:@"data"];
        NSMutableArray* symbolArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary* oneInfo in dataArray) {
            NSString* symbol = [oneInfo valueForKey:StockFunc_RemindStockList_fullsymbol];
            [symbolArray addObject:symbol];
        }
        [self startMultiStockInfoWithSender:self symbol:[symbolArray componentsJoinedByString:@","] args:nil dataList:nil userInfo:requset];
        [symbolArray release];
    }
    else if ([stageNumber intValue]==Stage_Request_StockRemindHistoryList) {
        ASIHTTPRequest* requset = [notify.userInfo valueForKey:RequsetPreRequset];
        NSDictionary* extraDict = [requset.userInfo valueForKey:RequsetExtra];
        NSMutableDictionary* dict = [extraDict valueForKey:@"dict"];
        NSArray* dataArray = [dict valueForKey:@"data"];
        NSMutableArray* symbolArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary* oneInfo in dataArray) {
            NSString* symbol = [oneInfo valueForKey:StockFunc_RemindHistoryList_fullsymbol];
            [symbolArray addObject:symbol];
        }
        [self startMultiStockInfoWithSender:self symbol:[symbolArray componentsJoinedByString:@","] args:nil dataList:nil userInfo:requset];
        [symbolArray release];
    }
    else if ([stageNumber intValue]==Stage_Request_StockList)
    {
        ASIHTTPRequest* requset = [notify.userInfo valueForKey:RequsetPreRequset];
        [[StockFuncPuller getInstance] startStockListWithSender:self type:@"world_index" symbol:nil count:100 page:1 args:nil dataList:nil userInfo:requset];
    }
    
}

-(void)StockObjectFailedInternal:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    ASIHTTPRequest* requset = [notify.userInfo valueForKey:RequsetPreRequset];
    [self requestFailed:requset];
}
-(void)startStockListWithSender:(id)sender type:(NSString*)type symbol:(NSString*)symbol count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info orderInfo:(NSArray *)order
{
    
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockListHost;
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
    
    if (type) {
        NSString* idKey = @"type";
        [dict setObject:[NSString stringWithFormat:@"%@",type] forKey:idKey];
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
    if (info) {
        [userDict setObject:info forKey:RequsetInfo];
    }
    
    if(order) {
        [userDict setObject:order forKey:RequsetOrderArray];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_StockList userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startStockListWithSender:(id)sender type:(NSString*)type symbol:(NSString*)symbol count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockListHost;
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
    
    if (type) {
        NSString* idKey = @"type";
        [dict setObject:[NSString stringWithFormat:@"%@",type] forKey:idKey];
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
    if (info) {
        [userDict setObject:info forKey:RequsetInfo];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_StockList userInfo:userDict headerDict:nil bInback:NO];
}

-(BOOL)checkIfNeedAddMarketIndexToStockListWithCurType:(NSString*)type
{
    BOOL rtval = NO;
    if(type)
    {
        if ([type isEqualToString:StockListType_HuRize]) {
            rtval = YES;
        }
        else if ([type isEqualToString:StockListType_HuDrop]) {
            rtval = YES;
        }
        else if ([type isEqualToString:StockListType_ShenRize]) {
            rtval = YES;
        }
        else if ([type isEqualToString:StockListType_ShenDrop]) {
            rtval = YES;
        }// hk
        else if([type isEqualToString:StockListType_HongkongRize])
        {
            rtval = YES;
        }
        else if([type isEqualToString:StockListType_HongkongDrop])
        {
            rtval = YES;
        }
        else if([type isEqualToString:StockListType_HongkongVolume])
        {
            rtval = YES;
        }
        else if([type isEqualToString:StockListType_HongkongHot])
        {
            rtval = YES;
        }
        //end hk
        else if([type isEqualToString:StockListType_USChina])
        {
            rtval = YES;
        }
        else if([type isEqualToString:StockListType_USTech])
        {
            rtval = YES;
        }

        
    }
    return rtval;
}

-(NSMutableDictionary*)modifiedMarketIndexDictWithArray:(NSArray*)dataArray type:(NSString*)oldType
{
    
    NSMutableDictionary* rtval = nil;
    for (NSDictionary* oneDict in dataArray) {
        NSString* oneName = [oneDict valueForKey:StockFunc_OneStock_name];
        
        NSLog(@"oneName = %@",oneName);
        NSString* needIndexKeyString = nil;
        if ([oldType isEqualToString:StockListType_HuRize]) {
            needIndexKeyString = @"上证";
        }
        else if([oldType isEqualToString:StockListType_HuDrop])
        {
            needIndexKeyString = @"上证";
        }
        else if([oldType isEqualToString:StockListType_ShenRize])
        {
            needIndexKeyString = @"深成";
        }
        else if([oldType isEqualToString:StockListType_ShenDrop])
        {
            needIndexKeyString = @"深成";
        }
        // hk       
        else if([oldType isEqualToString:StockListType_HongkongRize])
        {
            needIndexKeyString = @"恒指";
        }
        else if([oldType isEqualToString:StockListType_HongkongDrop])
        {
            needIndexKeyString = @"恒指";
        }
        else if([oldType isEqualToString:StockListType_HongkongVolume])
        {
            needIndexKeyString = @"恒指";
        }
        else if([oldType isEqualToString:StockListType_HongkongHot])
        {
            needIndexKeyString = @"恒指";
        
        }
        //end hk
        //us
        else if([oldType isEqualToString:StockListType_USChina])
        {
            needIndexKeyString = @"纳指";//美股中国股
        }
        else if([oldType isEqualToString:StockListType_USTech])
        {
            needIndexKeyString = @"道指";//美股科技股
        }
        //end us
        
        if (needIndexKeyString) {
            if ([oneName isEqualToString:needIndexKeyString]) {
                if (!rtval) {
                    rtval = [NSMutableDictionary dictionaryWithCapacity:0];
                }
                [rtval addEntriesFromDictionary:oneDict];
                //[rtval setValue:@"大盘指数" forKey:StockFunc_OneStock_name];
                break;
            }
        }
        
    }
    return rtval;
}

-(void)startListWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)page withAPICode:(NSArray*)codeArray args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info bInback:(BOOL)bInback
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setObject:[NSString stringWithFormat:@"%d",page] forKey:RequsetPage];
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
    [userDict setValue:[NSNumber numberWithInt:RequestType_List] forKey:RequsetType];
    [self startAPIRequest:sender withAPICode:codeArray pagename:@"page" pagevalue:page countname:nil countvalue:countPerPage args:args stage:Stage_Request_APIList otherUserInfo:userDict headerInfo:nil inBack:bInback useCache:NO];
    [userDict release];
}

-(void)startOneStockInfoWithSender:(id)sender type:(NSString*)type symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_OneStockInfoHost;
    if (type&&[[type lowercaseString] isEqualToString:@"fund"]) {
        httpAPI = HttpAPI_OneFundInfoHost;
    }
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (type&&![[type lowercaseString] isEqualToString:@"fund"]) {
        NSString* idKey = @"type";
        [dict setObject:[NSString stringWithFormat:@"%@",type] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (symbol) {
        NSString* idKey = @"symbol";
        [dict setObject:[NSString stringWithFormat:@"%@",symbol] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_OneStockInfo userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startMultiStockInfoWithSender:(id)sender symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_MultiStockInfoHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (symbol) {
        NSString* idKey = @"symbol";
        [dict setObject:[NSString stringWithFormat:@"%@",symbol] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_MultiStockInfo userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startOneStockNewsWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)page type:(NSString*)type symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_OneStockNewsHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (type) {
        NSString* idKey = @"type";
        [dict setObject:[NSString stringWithFormat:@"%@",type] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (symbol) {
        NSString* idKey = @"symbol";
        [dict setObject:[NSString stringWithFormat:@"%@",symbol] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (countPerPage>0) {
        NSString* idKey = @"num";
        [dict setObject:[NSString stringWithFormat:@"%d",countPerPage] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (page>0) {
        NSString* idKey = @"page";
        [dict setObject:[NSString stringWithFormat:@"%d",page] forKey:idKey];
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_OneStockNews userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startOneCnStockReportWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)page symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_OneCnStockReportHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (symbol) {
        NSString* idKey = @"symbol";
        [dict setObject:[NSString stringWithFormat:@"%@",symbol] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (countPerPage>0) {
        NSString* idKey = @"num";
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_OneCnStockReport userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startOneCnStockNoticeWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)page symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_OneCnStockNoticeHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (symbol) {
        NSString* idKey = @"PaperCode";
        if ([symbol hasPrefix:@"sz"]||[symbol hasPrefix:@"sh"]) {
            symbol = [symbol substringFromIndex:2];
        }
        [dict setObject:[NSString stringWithFormat:@"%@",symbol] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (countPerPage>0) {
        NSString* idKey = @"Display";
        [dict setObject:[NSString stringWithFormat:@"%d",countPerPage] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (page>0) {
        NSString* idKey = @"page";
        [dict setObject:[NSString stringWithFormat:@"%d",page] forKey:idKey];
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_OneCnStockNotice userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startOneHKStockNoticeWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)page symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_OneHkStockNoticeHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (symbol) {
        NSString* idKey = @"symbol";
        [dict setObject:[NSString stringWithFormat:@"%@",symbol] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (countPerPage>0) {
        NSString* idKey = @"perpage";
        [dict setObject:[NSString stringWithFormat:@"%d",countPerPage] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (page>0) {
        NSString* idKey = @"start";
        [dict setObject:[NSString stringWithFormat:@"%d",countPerPage*(page-1)] forKey:idKey];
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_OneHkStockNotice userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startOneCnStockReportContentWithSender:(id)sender rptid:(NSString*)rptid args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_OneCnStockReportContentHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (rptid) {
        NSString* idKey = @"rptid";
        [dict setObject:[NSString stringWithFormat:@"%@",rptid] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_OneCnStockReportContent userInfo:userDict headerDict:nil bInback:NO useCache:YES];
}

-(void)startOneCnStockNoticeContentWithSender:(id)sender symbol:(NSString*)symbol noticeID:(NSString*)noticeID args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_OneCnStockNoticeContentHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (symbol) {
        NSString* idKey = @"PaperCode";
        [dict setObject:[NSString stringWithFormat:@"%@",symbol] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (noticeID) {
        NSString* idKey = @"ID";
        [dict setObject:[NSString stringWithFormat:@"%@",noticeID] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_OneCnStockNoticeContent userInfo:userDict headerDict:nil bInback:NO useCache:YES];
}

-(void)startOneHKStockNoticeContentWithSender:(id)sender noticeID:(NSString*)noticeID args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_OneHkStockNoticeContentHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];

    
    if (noticeID) {
        NSString* idKey = @"aid";
        [dict setObject:[NSString stringWithFormat:@"%@",noticeID] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_OneHkStockNoticeContent userInfo:userDict headerDict:nil bInback:NO useCache:YES];
}

-(void)startOneFundTypeWithSender:(id)sender symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_OneFundTypeHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (symbol) {
        NSString* idKey = @"symbol";
        [dict setObject:[NSString stringWithFormat:@"%@",symbol] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_OneFundType userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startOneFundNetValueWithSender:(id)sender symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_OneFundNetValueHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (symbol) {
        NSString* idKey = @"symbol";
        [dict setObject:[NSString stringWithFormat:@"%@",symbol] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_OneFundNetValue userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startStockChartWithSender:(id)sender url:(NSString*)urlString args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = urlString;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_StockChart userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startObtainMyGroupAPIVersionWithSender:(id)sender args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_ObtainMyGroupAPIVersion;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_ObtainMyGroupAPIVersion userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startObtainMyGroupAPIWithSender:(id)sender version:(NSString*)version args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_ObtainMyGroupAPIVersion;
    httpAPI = [httpAPI stringByAppendingFormat:@",%@",version];
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_ObtainMyGroupAPI userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startMyGroupAddStockWithSender:(id)sender service:(NSString*)service  stock:(NSArray*)stocks command:(NSString*)command groupPID:(NSString*)groupPID args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    [self startMyGroupWithSender:sender service:service task:command stock:stocks groupPID:groupPID stage:Stage_Request_AddMyGroup args:args dataList:dataList seperateRequst:NO userInfo:info];
}

-(void)startMyGroupRemoveStockWithSender:(id)sender service:(NSString*)service stock:(NSArray*)stocks command:(NSString*)command groupPID:(NSString*)groupPID args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    [self startMyGroupWithSender:sender service:service task:command stock:stocks groupPID:groupPID stage:Stage_Request_RemoveMyGroup args:args dataList:dataList seperateRequst:NO userInfo:info];
}

-(void)startMyGroupReorderStockWithSender:(id)sender service:(NSString*)service stock:(NSArray*)stocks command:(NSString*)command groupPID:(NSString*)groupPID args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    [self startMyGroupWithSender:sender service:service task:command stock:stocks groupPID:groupPID stage:Stage_Request_ReorderMyGroup args:args dataList:dataList seperateRequst:NO userInfo:info];
}

-(void)startMyGroupListWithSender:(id)sender service:(NSString*)service command:(NSString*)command args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info
{
    [self startMyGroupWithSender:sender service:service task:command stock:nil groupPID:nil stage:Stage_Request_ObtainMyGroupList args:args dataList:dataList seperateRequst:NO userInfo:info];
}

-(void)startMyGroupWithSender:(id)sender service:(NSString*)service task:(NSString*)task stock:(NSArray*)stock groupPID:(NSString*)groupPID stage:(NSInteger)stage args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info
{
    BOOL hasLogined =  [[WeiboLoginManager getInstance] hasLogined];
    NSDictionary* authDict = self.oAuthData;
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = nil;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (YES) {
        NSString* iphonezx_key = @"45*&=<09>?";
        NSString* idString = @"key";
        NSString* idValue = nil;
        if ([task isEqualToString:StockFunc_GroupAPI_full_pinfo]) {
            idValue = [MyTool MD5DigestFromString:iphonezx_key];
        }
        else if ([task isEqualToString:StockFunc_GroupAPI_bat_jia]||[task isEqualToString:StockFunc_GroupAPI_bat_del])
        {
            NSString* newStock = @"";
            for (NSString* oneStock in stock) {
                if (![newStock isEqualToString:@""]) {
                    newStock = [newStock stringByAppendingFormat:@",%@",oneStock];
                }
                else {
                    newStock = [newStock stringByAppendingFormat:@"%@",oneStock];
                }
            }
            newStock = [newStock rawUrlEncode];
            NSString* keySource = [NSString stringWithFormat:@"%@%@%@",iphonezx_key,newStock,groupPID];
            idValue = [MyTool MD5DigestFromString:keySource];
            NSMutableDictionary* extraDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [extraDict setValue:stock forKey:@"stock"];
            [userDict setValue:extraDict forKey:RequsetExtra];
            [extraDict release];
        }
        else if([task isEqualToString:StockFunc_GroupAPI_upd_order])
        {
            NSString* newStock = @"";
            for (NSString* oneStock in stock) {
                if (![newStock isEqualToString:@""]) {
                    newStock = [newStock stringByAppendingFormat:@",%@",oneStock];
                }
                else {
                    newStock = [newStock stringByAppendingFormat:@"%@",oneStock];
                }
            }
            newStock = [newStock rawUrlEncode];
            NSString* keySource = [NSString stringWithFormat:@"%@%@%@%@",iphonezx_key,newStock,groupPID,@"step"];
            idValue = [MyTool MD5DigestFromString:keySource];
            NSMutableDictionary* extraDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [extraDict setValue:stock forKey:@"stock"];
            [userDict setValue:extraDict forKey:RequsetExtra];
            [extraDict release];
        }
        [dict setObject:idValue forKey:idString];
        [orderArray addObject:idString];
    }
    if (YES) {
        NSString* idString = @"source";
        [dict setObject:@"iphone_app" forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (authDict) {
        NSString* idString = @"wb_actoken";
        NSString* tickect = [authDict valueForKey:LoginReturnKeyV2_Token];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (authDict) {
        NSString* idString = @"p_sid";
        NSString* tickect = [authDict valueForKey:LoginReturnKey_User_id];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (YES) {
        if ([task isEqualToString:StockFunc_GroupAPI_upd_order]) {
            NSString* idString = @"ordertype";
            [dict setObject:@"step" forKey:idString];
            [orderArray addObject:idString];
        }
    }
    
    if (groupPID) {
        NSString* idString = @"pid";
        [dict setObject:groupPID forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (stock) {
        NSString* idString = @"scode";
        NSString* newStock = @"";
        for (NSString* oneStock in stock) {
            if (![newStock isEqualToString:@""]) {
                newStock = [newStock stringByAppendingFormat:@",%@",oneStock];
            }
            else {
                newStock = [newStock stringByAppendingFormat:@"%@",oneStock];
            }
        }
        [dict setObject:newStock forKey:idString];
        [orderArray addObject:idString];
    }
    
    [userDict setValue:[NSNumber numberWithInt:stage] forKey:RequsetStage];
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
    
    if (seperateRequst) {
        [userDict setObject:[NSNumber numberWithBool:YES] forKey:RequsetSeperate];
    }
    
    if (self.groupAPIDict) {
        httpAPI = [self.groupAPIDict valueForKey:task];
        if ([httpAPI rangeOfString:@"PortfoliosService"].location!=NSNotFound) {
            httpAPI = [httpAPI stringByReplacingOccurrencesOfString:@"PortfoliosService" withString:service];
        }
        else {
            httpAPI = [httpAPI stringByReplacingOccurrencesOfString:@"USstockService" withString:service];
        }
        
#ifdef TEST
        if ([httpAPI rangeOfString:@"iphone_zx_test"].location==NSNotFound) {
            httpAPI = [httpAPI stringByReplacingOccurrencesOfString:@"iphone_zx" withString:@"zx_client_t_test"];
        }
        else {
            httpAPI = [httpAPI stringByReplacingOccurrencesOfString:@"iphone_zx_test" withString:@"zx_client_t_test"];
        }
#else
        if ([httpAPI rangeOfString:@"iphone_zx_test"].location==NSNotFound) {
            httpAPI = [httpAPI stringByReplacingOccurrencesOfString:@"iphone_zx" withString:@"zx_client_t"];
        }
        else {
            httpAPI = [httpAPI stringByReplacingOccurrencesOfString:@"iphone_zx_test" withString:@"zx_client_t"];
        }
#endif
        httpAPI = [[httpAPI componentsSeparatedByString:@"?"] objectAtIndex:0];
        [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:stage userInfo:userDict headerDict:nil bInback:NO];
    }
    else {
        httpAPI = service;
        httpAPI = [[httpAPI componentsSeparatedByString:@"?"] objectAtIndex:0];
        [self befereGroupAPICalledWithMethod:@"POST" data:dict order:orderArray api:httpAPI stage:stage userInfo:userDict headerDict:nil bInback:NO searchKey:task];
    }
}

-(void)befereGroupAPICalledWithMethod:(NSString*)method data:(NSDictionary*)dict order:(NSArray*)orderArray api:(NSString*)HttpAPI stage:(NSInteger)stageInteger userInfo:(NSDictionary*)userData headerDict:(NSDictionary*)headerDict bInback:(BOOL)bInback searchKey:(NSString*)searchKey
{
    NSMutableDictionary* afterAPI_userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    [afterAPI_userInfo setValue:method forKey:PullerData_RequestMethod];
    [afterAPI_userInfo setValue:dict forKey:PullerData_RequestData];
    [afterAPI_userInfo setValue:orderArray forKey:PullerData_RequestOrder];
    [afterAPI_userInfo setValue:HttpAPI forKey:PullerData_RequestAPI];
    [afterAPI_userInfo setValue:[NSNumber numberWithInt:stageInteger] forKey:PullerData_RequestStage];
    [afterAPI_userInfo setValue:userData forKey:PullerData_RequestUserInfo];
    [afterAPI_userInfo setValue:headerDict forKey:PullerData_RequestHeaderDict];
    [afterAPI_userInfo setValue:[NSNumber numberWithBool:bInback] forKey:PullerData_RequestInBack];
    [afterAPI_userInfo setValue:searchKey forKey:PullerData_HTTPAPI_SearchKey];
    [self startObtainMyGroupAPIVersionWithSender:self args:nil dataList:nil userInfo:afterAPI_userInfo];
    [afterAPI_userInfo release];
}

-(void)startMyStockListWithSender:(id)sender type:(NSString*)type subtype:(NSString*)subType symbol:(NSString*)symbol count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_MyStockListHost;
    if([type isEqualToString:@"fund"])
    {
        httpAPI = HttpAPI_MyFundListHost;
    }
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
    
    if (type) {
        NSString* idKey = @"type";
        if([type isEqualToString:@"fund"])
        {
            if (subType) {
                [dict setObject:[NSString stringWithFormat:@"%@",subType] forKey:idKey];
                [orderArray addObject:idKey];
            }
        }
        else {
            [dict setObject:[NSString stringWithFormat:@"%@",type] forKey:idKey];
            [orderArray addObject:idKey];
        }
    }
    if (symbol) {
        httpAPI = [MyTool urlString:httpAPI replaceStringKey:@"symbol" withValueString:symbol];
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
    if (info) {
        [userDict setObject:info forKey:RequsetInfo];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_MyStockList userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startStockSuggestWithSender:(id)sender name:(NSString*)name type:(NSInteger)type subtype:(NSString*)subtype count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_AddStockSuggestHost;
    if (type>0) {
        httpAPI = HttpAPI_AddStockRemindSuggestHost;
    }
    else {
        if (subtype) {
            if ([[subtype lowercaseString] isEqualToString:@"cn"]) {
                httpAPI = HttpAPI_AddStockSuggestHost_CN;
            }
            else if([[subtype lowercaseString] isEqualToString:@"hk"])
            {
                httpAPI = HttpAPI_AddStockSuggestHost_HK;
            }
            else if([[subtype lowercaseString] isEqualToString:@"us"])
            {
                httpAPI = HttpAPI_AddStockSuggestHost_US;
            }
            else if([[subtype lowercaseString] isEqualToString:@"fund"])
            {
                httpAPI = HttpAPI_AddStockSuggestHost_FUND;
            }
        }
    }
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (name) {
        NSString* idString = @"${1}";
        NSString * encodedParam =  [name rawUrlEncode];
        
        httpAPI = [httpAPI stringByReplacingOccurrencesOfString:idString withString:encodedParam];
    }
    
//    if (countPerPage>0) {
//        NSString* idKey = @"num";
//        [dict setObject:[NSString stringWithFormat:@"%d",countPerPage] forKey:idKey];
//        [orderArray addObject:idKey];
//    }
    
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
    if (info) {
        [userDict setObject:info forKey:RequsetInfo];
    }
    if (seperateRequst) {
        [userDict setObject:[NSNumber numberWithBool:YES] forKey:RequsetSeperate];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_AddStockSuggest userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startOneStockLookupWithSender:(id)sender name:(NSString*)name forLeast:(BOOL)forLeast args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info;
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockLookupHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (name) {
        NSString* idKey = @"q";
        [dict setObject:name forKey:idKey];
        [orderArray addObject:idKey];
    }

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
    if (name) {
        NSMutableDictionary* curargs = [NSMutableDictionary dictionaryWithCapacity:0];
        [curargs setValue:name forKey:@"name"];
        [curargs setValue:[NSNumber numberWithBool:forLeast] forKey:@"forleast"];
        [userDict setValue:curargs forKey:RequsetCurArgs];
    }
    
    if (seperateRequst) {
        [userDict setObject:[NSNumber numberWithBool:YES] forKey:RequsetSeperate];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_OneStockLookup userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startStockLookupWithSender:(id)sender name:(NSString*)name forLeast:(BOOL)forLeast args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info;
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockLookupHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (name) {
        NSString* idKey = @"q";
        [dict setObject:name forKey:idKey];
        [orderArray addObject:idKey];
    }
    
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
    if (name) {
        NSMutableDictionary* curargs = [NSMutableDictionary dictionaryWithCapacity:0];
        [curargs setValue:name forKey:@"name"];
        [curargs setValue:[NSNumber numberWithBool:forLeast] forKey:@"forleast"];
        [userDict setValue:curargs forKey:RequsetCurArgs];
    }
    
    if (seperateRequst) {
        [userDict setObject:[NSNumber numberWithBool:YES] forKey:RequsetSeperate];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_StockLookup userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startSearchHotStockWithSender:(id)sender args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_SearchHotStockHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];

    
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
    if (seperateRequst) {
        [userDict setObject:[NSNumber numberWithBool:YES] forKey:RequsetSeperate];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_SearchHotStock userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startStockRemindStartupWithSender:(id)sender device:(NSString*)device bOn:(BOOL)bOn userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }

    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockRemindStartupHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSDictionary* authDict = self.oAuthData;
    
    if (YES) {
        NSString* idKey = @"source";
        [dict setObject:@"iphone_app" forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (authDict) {
        NSString* idString = @"wb_actoken";
        NSString* tickect = [authDict valueForKey:LoginReturnKeyV2_Token];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (authDict) {
        NSString* idString = @"p_sid";
        NSString* tickect = [authDict valueForKey:LoginReturnKey_User_id];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (YES) {
        NSString* idKey = @"active_sts";
        NSString* onString = bOn==YES?@"2":@"0";
        [dict setObject:onString forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (device) {
        NSString* idKey = @"terminal_id";
        NSString* deviceUniqueMD5 = device;
        [dict setObject:deviceUniqueMD5 forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    if (info) {
        [userDict setObject:info forKey:RequsetInfo];
    }
    
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_Request_StockRemindStartup userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startStockRemindUserInfoWithSender:(id)sender device:(NSString*)device args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockRemindUserInfoHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (YES) {
        NSString* idKey = @"source";
        [dict setObject:@"iphone_app" forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    NSDictionary* authDict = self.oAuthData;
    if (authDict) {
        NSString* idString = @"wb_actoken";
        NSString* tickect = [authDict valueForKey:LoginReturnKeyV2_Token];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (authDict) {
        NSString* idString = @"p_sid";
        NSString* tickect = [authDict valueForKey:LoginReturnKey_User_id];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (device) {
        NSString* idKey = @"terminal_id";
        NSString* deviceUniqueMD5 = device;
        [dict setObject:deviceUniqueMD5 forKey:idKey];
        [orderArray addObject:idKey];
    }
    
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
    
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_Request_StockRemindUserInfo userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startStockRemindAddInfoWithSender:(id)sender symbol:(NSString*)symbol risePrice:(NSString*)rise fallPrice:(NSString*)fall incpercent:(NSString*)incpercent decpercent:(NSString*)decpercent userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockRemindAddInfoHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (YES) {
        NSString* idKey = @"source";
        [dict setObject:@"iphone_app" forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    NSDictionary* authDict = self.oAuthData;
    if (authDict) {
        NSString* idString = @"wb_actoken";
        NSString* tickect = [authDict valueForKey:LoginReturnKeyV2_Token];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (authDict) {
        NSString* idString = @"p_sid";
        NSString* tickect = [authDict valueForKey:LoginReturnKey_User_id];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (symbol) {
        NSString* idKey = @"alert_code";
        [dict setObject:symbol forKey:idKey];
        [orderArray addObject:idKey];
        NSMutableDictionary* extraDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [extraDict setValue:symbol forKey:@"symbol"];
        [userDict setValue:extraDict forKey:RequsetExtra];
        [extraDict release];
    }
    
    if (rise) {
        NSString* idKey = @"rise_price";
        [dict setObject:rise forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (fall) {
        NSString* idKey = @"fall_price";
        [dict setObject:fall forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (incpercent) {
        NSString* idKey = @"incpercent";
        [dict setObject:incpercent forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (decpercent) {
        NSString* idKey = @"decpercent";
        [dict setObject:decpercent forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    if (info) {
        [userDict setObject:info forKey:RequsetInfo];
    }
    
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_Request_StockRemindAddInfo userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startStockRemindRemoveInfoWithSender:(id)sender setID:(NSString*)setID userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockRemindRemoveInfoHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (YES) {
        NSString* idKey = @"source";
        [dict setObject:@"iphone_app" forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    NSDictionary* authDict = self.oAuthData;
    if (authDict) {
        NSString* idString = @"wb_actoken";
        NSString* tickect = [authDict valueForKey:LoginReturnKeyV2_Token];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (authDict) {
        NSString* idString = @"p_sid";
        NSString* tickect = [authDict valueForKey:LoginReturnKey_User_id];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (setID) {
        NSString* idKey = @"set_id";
        [dict setObject:setID forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    if (info) {
        [userDict setObject:info forKey:RequsetInfo];
    }
    
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_Request_StockRemindRemoveInfo userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startStockRemindUpdateInfoWithSender:(id)sender setID:(NSString*)setID risePrice:(NSString*)rise fallPrice:(NSString*)fall incpercent:(NSString*)incpercent decpercent:(NSString*)decpercent userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockRemindUpdateInfoHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (YES) {
        NSString* idKey = @"source";
        [dict setObject:@"iphone_app" forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    NSDictionary* authDict = self.oAuthData;
    if (authDict) {
        NSString* idString = @"wb_actoken";
        NSString* tickect = [authDict valueForKey:LoginReturnKeyV2_Token];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (authDict) {
        NSString* idString = @"p_sid";
        NSString* tickect = [authDict valueForKey:LoginReturnKey_User_id];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (setID) {
        NSString* idKey = @"set_id";
        [dict setObject:setID forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (rise) {
        NSString* idKey = @"rise_price";
        [dict setObject:rise forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (fall) {
        NSString* idKey = @"fall_price";
        [dict setObject:fall forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (incpercent) {
        NSString* idKey = @"incpercent";
        [dict setObject:incpercent forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (decpercent) {
        NSString* idKey = @"decpercent";
        [dict setObject:decpercent forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    if (info) {
        [userDict setObject:info forKey:RequsetInfo];
    }
    
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_Request_StockRemindUpdateInfo userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startStockRemindListWithSender:(id)sender args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockRemindListHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (YES) {
        NSString* idKey = @"source";
        [dict setObject:@"iphone_app" forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    NSDictionary* authDict = self.oAuthData;
    if (authDict) {
        NSString* idString = @"wb_actoken";
        NSString* tickect = [authDict valueForKey:LoginReturnKeyV2_Token];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (authDict) {
        NSString* idString = @"p_sid";
        NSString* tickect = [authDict valueForKey:LoginReturnKey_User_id];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
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
    if (seperateRequst) {
        [userDict setObject:[NSNumber numberWithBool:YES] forKey:RequsetSeperate];
    }
    
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_Request_StockRemindList userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startStockRemindHistoryListWithSender:(id)sender device:(NSString*)device args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_StockRemindHistoryListHost;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (YES) {
        NSString* idKey = @"source";
        [dict setObject:@"iphone_app" forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    NSDictionary* authDict = self.oAuthData;
    if (authDict) {
        NSString* idString = @"wb_actoken";
        NSString* tickect = [authDict valueForKey:LoginReturnKeyV2_Token];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (authDict) {
        NSString* idString = @"p_sid";
        NSString* tickect = [authDict valueForKey:LoginReturnKey_User_id];
        [dict setObject:tickect forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (device) {
        NSString* idKey = @"terminal_id";
        NSString* deviceUniqueMD5 = device;
        [dict setObject:deviceUniqueMD5 forKey:idKey];
        [orderArray addObject:idKey];
    }
    
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
    
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_Request_StockRemindHistoryList userInfo:userDict headerDict:nil bInback:NO];
}

-(void)testAPI
{
    NSString* httpAPI = @"http://platform.sina.com.cn/video/movie?app_key=2313859705";
    [self startHttpAPIRequestV2:@"GET" data:nil order:nil api:httpAPI stage:Stage_Request_TestAPI userInfo:nil headerDict:nil bInback:NO];
}

-(void)startHttpAPIRequestV2:(NSString*)method data:(NSDictionary*)dict order:(NSArray*)orderArray api:(NSString*)HttpAPI stage:(NSInteger)stageInteger userInfo:(NSDictionary*)userData headerDict:(NSDictionary*)headerDict bInback:(BOOL)bInback
{
    [self startHttpAPIRequestV2:method data:dict order:orderArray api:HttpAPI stage:stageInteger userInfo:userData headerDict:headerDict bInback:bInback useCache:NO];
}

-(void)startHttpAPIRequestV2:(NSString*)method data:(NSDictionary*)dict order:(NSArray*)orderArray api:(NSString*)HttpAPI stage:(NSInteger)stageInteger userInfo:(NSDictionary*)userData headerDict:(NSDictionary*)headerDict bInback:(BOOL)bInback useCache:(BOOL)useCache
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

    if (useCache) {
        ASIDownloadCache *cache = [ASIDownloadCache sharedCache];
        [request setDownloadCache:cache];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setSecondsToCache:60*60*24*30];
        [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    }
    
#ifdef DEBUG
    NSLog(@"http requset=%@,urlstr=%@",request,urlStr);
#endif
    
    if (!bInback) {
        NSNumber* seperateRequst = [userData valueForKey:RequsetSeperate];
        if (seperateRequst&&[seperateRequst boolValue]) {
            [self addRequestToSeperateStart:request];
        }
        else {
            [self addRequestToDowloadQueue:request];
        }
        
    }
    else
    {
        [self addRequestToOfflineQueue:request];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSInteger tagInteger = request.tag;
    if(request.tag==Stage_Request_StockList)
    {
        NSUInteger upSize = request.postLength;
        NSUInteger downSize = [[request rawResponseData] length];
        
        
       NSString *f=    [NSString stringWithFormat:@"Recving\n%@/%@",[Util number2String:upSize],[Util number2String:downSize]];
        NSLog(@"%@",f);
        
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
        NSMutableDictionary* jsonDict = [newString mutableObjectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* codeNumber = [jsonDict objectForKey:@"code"];
            if ([codeNumber isKindOfClass:[NSString class]]) {
                codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
            }
            if (([codeNumber isKindOfClass:[NSNumber class]]&&[codeNumber intValue]==0)||([codeNumber isKindOfClass:[NSNull class]])) 
            {
                NSString* oldUrlString = [request.url absoluteString];
                NSString* typeValue = [MyTool urlString:oldUrlString valueForKey:@"type"];
                if ([self checkIfNeedAddMarketIndexToStockListWithCurType:typeValue]) {
                    NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
                    [userInfo setValue:jsonDict forKey:RequsetExtra];
                    [self afterDefaultSuccessed:nil userRequst:request dataname:nil notifyName:StockObjectAddedInternalNotification];
                }
                else {
                    [self afterDefaultSuccessed:jsonDict userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
                }
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
    else if(request.tag==Stage_Request_MyStockList)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
        NSDictionary* jsonDict = [newString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* codeNumber = [jsonDict objectForKey:@"code"];
            if ([codeNumber isKindOfClass:[NSString class]]) {
                codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
            }
            if (([codeNumber isKindOfClass:[NSNumber class]]&&[codeNumber intValue]==0)||([codeNumber isKindOfClass:[NSNull class]])) 
            {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
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
    else if(request.tag==Stage_Request_APIList)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
        NSArray* jsonArray = [newString objectFromJSONString];
        if (jsonArray) {
            NSMutableDictionary* jsonDict = [NSMutableDictionary dictionaryWithObject:jsonArray forKey:@"data"];
            if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
                NSNumber* codeNumber = [jsonDict objectForKey:@"code"];
                if ([codeNumber isKindOfClass:[NSString class]]) {
                    codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
                }
                if ([codeNumber intValue]==0) {
                    [self afterDefaultSuccessed:jsonDict userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
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
        }
        else {
            [self requestFailed:request];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_OneStockInfo||request.tag==Stage_Request_MultiStockInfo)
    {
        
        NSUInteger upSize = request.postLength;
        NSUInteger downSize = [[request rawResponseData] length];
        
        
        NSString *f=    [NSString stringWithFormat:@"Recving\n%@/%@",[Util number2String:upSize],[Util number2String:downSize]];
        NSLog(@"个股-Stage_Request_OneStockInfo-%@",f);
        
        
        
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            resultString = [[NSString alloc] initWithData:request.responseData encoding:enc];
        }
        NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
        NSDictionary* jsonDict = [newString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* codeNumber = [jsonDict objectForKey:@"code"];
            if ([codeNumber isKindOfClass:[NSString class]]) {
                codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
            }
            else if(!codeNumber){
                jsonDict = [NSDictionary dictionaryWithObject:jsonDict forKey:@"data"];
            }
            if ([codeNumber intValue]==0) {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
            }
            else
            {
                NSLog(@"error:%@",[jsonDict valueForKey:@"msg"]);
                [self requestFailed:request];
            }
        }
        else
        {
            [self requestFailed:request];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_OneStockNews)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
        NSDictionary* jsonDict = [newString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* codeNumber = [jsonDict objectForKey:@"code"];
            if ([codeNumber isKindOfClass:[NSString class]]) {
                codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
            }
            if ([codeNumber intValue]==0) {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
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
    else if(request.tag==Stage_Request_OneCnStockReport||request.tag==Stage_Request_OneCnStockNotice)
    {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:enc];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
        NSDictionary* jsonDict = [newString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* codeNumber = [jsonDict objectForKey:@"code"];
            if ([codeNumber isKindOfClass:[NSString class]]) {
                codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
            }
            if ([codeNumber intValue]==0) {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
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
    else if(request.tag==Stage_Request_OneHkStockNotice)
    {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:enc];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
        if ([[newString lowercaseString] isEqualToString:@"null"]) {
            [self afterDefaultSuccessed:nil userRequst:request notifyName:StockObjectAddedNotification];
        }
        else {
            NSMutableArray* jsonArray = [newString mutableObjectFromJSONString];
            if (jsonArray&&[jsonArray isKindOfClass:[NSArray class]]) {
                NSMutableDictionary* oneDict = [[NSMutableDictionary alloc] initWithCapacity:0];
                [oneDict setValue:jsonArray forKey:@"data"];
                [self afterDefaultSuccessed:oneDict userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
                [oneDict release];
            }
            else
            {
                [self requestFailed:request];
            }
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_OneFundType)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
        NSString* realValue = nil;
        if ([newString hasPrefix:@"new String("]) {
            realValue = [newString substringWithRange:NSMakeRange(12, newString.length-12-2)];
            NSMutableDictionary* realdict = [[NSMutableDictionary alloc] initWithCapacity:0];
            NSMutableArray* realArray = [[NSMutableArray alloc] initWithCapacity:0];
            [realdict setValue:realValue forKey:StockFunc_SingleStockInfo_fundtype];
            NewsObject* oneObject = [[NewsObject alloc]initWithJsonDictionary:realdict];
            [realArray addObject:oneObject];
            
            [self afterDefaultSuccessed:realArray userRequst:request notifyName:StockObjectAddedNotification];
            [oneObject release];
            [realdict release];
            [realArray release];
        }
        else {
            [self requestFailed:request];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_OneFundNetValue)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
        NSMutableDictionary* jsonDict = [newString mutableObjectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* codeNumber = [jsonDict objectForKey:@"code"];
            if ([codeNumber isKindOfClass:[NSString class]]) {
                codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
            }
            if ([codeNumber intValue]==0) {
                NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
                NSString* exchange = [jsonDict valueForKey:StockFunc_Chart_exchange];
                if (exchange) {
                    if ([exchange isKindOfClass:[NSNull class]]) {
                        [jsonDict setValue:@"" forKey:StockFunc_Chart_exchange];
                    }
                    else if([exchange isKindOfClass:[NSString class]]&&[exchange isEqualToString:@"<Null>"])
                    {
                        [jsonDict setValue:@"" forKey:StockFunc_Chart_exchange];
                    }
                }
                [userInfo setValue:jsonDict forKey:RequsetExtra];
                [self afterDefaultSuccessed:nil userRequst:request notifyName:StockObjectAddedNotification];
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
    else if(request.tag==Stage_Request_StockChart)
    {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* responseString = [[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding] autorelease];
        
        NSUInteger upSize = request.postLength;
        NSUInteger downSize = [[request rawResponseData] length];
        
        
        NSString *f=    [NSString stringWithFormat:@"Recving\n%@/%@",[Util number2String:upSize],[Util number2String:downSize]];
        NSLog(@"个股-Stage_Request_StockChart-%@",f);
        

        if ([responseString length]>0&&[responseString rangeOfString:@"<svg"].location!=NSNotFound)
        {
            NSMutableDictionary* userInfo = (NSMutableDictionary*)[request userInfo];
            NSString* urlKey = [userInfo valueForKey:RequsetInfo];
            
            
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:responseString,StockFunc_SingleStockInfo_localsvg, nil];
            NewsObject* newObject = [[NewsObject alloc] initWithJsonDictionary:dict];
            NSArray* array = [[NSArray alloc] initWithObjects:newObject, nil];
            [userInfo setValue:responseString forKey:RequsetExtra];
            
            [self afterDefaultSuccessed:array userRequst:request notifyName:StockObjectAddedNotification];
            
            [array release];
            [newObject release];
            [dict release];
        }
        else {
            [self requestFailed:request];
        }

    }
    else if(request.tag==Stage_Request_ObtainMyGroupAPIVersion)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        
        NSDictionary* versionDict = [resultString objectFromJSONString];
        if (versionDict) {
            NSString* version = [versionDict valueForKey:StockFunc_GroupAPI_Version];
            NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
            [userInfo setValue:version forKey:RequsetExtra];
            [self afterDefaultSuccessed:nil userRequst:request notifyName:StockObjectAddedNotification];
        }
        else {
            [self requestFailed:request];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_ObtainMyGroupAPI)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        
        NSDictionary* versionDict = [resultString objectFromJSONString];
        if (versionDict) {
            NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
            [userInfo setValue:versionDict forKey:RequsetExtra];
            [self afterDefaultSuccessed:nil userRequst:request notifyName:StockObjectAddedNotification];
        }
        else {
            [self requestFailed:request];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_ObtainMyGroupList)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        
        NSArray* versionDict = [resultString objectFromJSONString];
        BOOL bError = NO;
        if (versionDict) {
            BOOL resultError = NO;
            if ([versionDict isKindOfClass:[NSDictionary class]]) {
                 NSNumber* resultNumber = [(NSDictionary*)versionDict valueForKey:@"result"];
                if (resultNumber) {
                    resultError = YES;
                    bError= YES;
                    NSString* resultMsg = [(NSDictionary*)versionDict valueForKey:@"msg"];
                    NSLog(@"Group error!msg=%@,url=%@",[resultMsg decodeUTF8String],request.url.absoluteString);
                }
            }
            if (!resultError) {
                NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
                NSArray* groupArray = versionDict;
                NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary* onePid in groupArray) {
                    NSMutableDictionary* newDict = [[NSMutableDictionary alloc] initWithDictionary:onePid];
                    NSString* name = [newDict valueForKey:StockFunc_GroupInfo_name];
                    NSString* newName = [name decodeUTF8String];
                    [newDict setValue:newName forKey:StockFunc_GroupInfo_name];
                    NewsObject* oneObject = [[NewsObject alloc] initWithJsonDictionary:newDict];
                    [newArray addObject:oneObject];
                    [newDict release];
                    [oneObject release];
                }
                [userInfo setValue:versionDict forKey:RequsetExtra];
                [self afterDefaultSuccessed:newArray userRequst:request notifyName:StockObjectAddedNotification];
                [newArray release];
            }
            else {
                bError = YES;
            }
            
        }
        else {
            bError = YES;
        }
        if (bError) {
            [self retryRequest:request loginKey:@"wb_actoken"];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_AddMyGroup||request.tag==Stage_Request_RemoveMyGroup||request.tag==Stage_Request_ReorderMyGroup)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        
        NSArray* versionDict = [resultString objectFromJSONString];
        BOOL bError = NO;
        if (versionDict) {
            BOOL resultError = NO;
            if ([versionDict isKindOfClass:[NSDictionary class]]) {
                NSNumber* resultNumber = [(NSDictionary*)versionDict valueForKey:@"result"];
                NSString* resultMsg = [(NSDictionary*)versionDict valueForKey:@"msg"];
                NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
                NSMutableDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
                [extraDict setValue:[resultMsg decodeUTF8String] forKey:@"msg"];
                if (resultNumber&&![[resultNumber stringValue] hasSuffix:@"00"]) {
                    resultError = YES;
                    bError= YES;
                }
                NSLog(@"Group error!msg=%@,url=%@",[resultMsg decodeUTF8String],request.url.absoluteString);
            }
            else {
                resultError = YES;
                bError= YES;
            }
            if (!resultError) {
                [self afterDefaultSuccessed:nil userRequst:request notifyName:StockObjectAddedNotification];
            }
            else {
                bError = YES;
            }
            
        }
        else {
            bError = YES;
        }
        if (bError) {
            [self retryRequest:request loginKey:@"wb_actoken"];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_AddStockSuggest)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        
        NSRange firstQuote = [resultString rangeOfString:@"\""];
        if (firstQuote.location!=NSNotFound) {
            NSRange secondQuote = [resultString rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(firstQuote.location+firstQuote.length, resultString.length - firstQuote.location-firstQuote.length)];
            NSString* newString = [resultString substringFromIndex:firstQuote.length+firstQuote.location];
            newString = [newString substringToIndex:secondQuote.location - firstQuote.length-firstQuote.location];
            
            NSArray* suggests = [newString componentsSeparatedByString:@";"];
            
            NSMutableArray* resultArray = [[NSMutableArray alloc] initWithCapacity:0];
            if (newString&&[newString length]>0) {
                for (NSString* oneSuggest in suggests) {
                    NSMutableDictionary* oneInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
                    NSArray* infoArray = [oneSuggest componentsSeparatedByString:@","];
                    for (int j=0;j<[infoArray count];j++) {
                        NSString* oneCell = [infoArray objectAtIndex:j];
                        if (j==0) {
                            [oneInfo setValue:oneCell forKey:StockFunc_Suggest_nasdac];
                        }
                        else if (j==1) {
                            [oneInfo setValue:oneCell forKey:StockFunc_Suggest_type];
                        }
                        else if (j==2) {
                            [oneInfo setValue:oneCell forKey:StockFunc_Suggest_symbol];
                        }
                        else if (j==3) {
                            NSString* index0String = [infoArray objectAtIndex:0];
                            NSString* index2String = [infoArray objectAtIndex:2];
                            if ([index0String isEqualToString:index2String]) {
                                if ([oneCell rangeOfString:index2String].location!=NSNotFound&&[oneCell rangeOfString:@" "].location==NSNotFound) {
                                    [oneInfo setValue:oneCell forKey:StockFunc_Suggest_full_symbol];
                                }
                                else {
                                    [oneInfo setValue:index0String forKey:StockFunc_Suggest_full_symbol];
                                }
                            }
                            else {
                                if ([oneCell rangeOfString:@" "].location!=NSNotFound) {
                                    [oneInfo setValue:index2String forKey:StockFunc_Suggest_full_symbol];
                                }
                                else {
                                    [oneInfo setValue:oneCell forKey:StockFunc_Suggest_full_symbol];
                                }
                            }
                            
                        }
                        else if (j==4) {
                            [oneInfo setValue:oneCell forKey:StockFunc_Suggest_name];
                        }
                    }
                    [resultArray addObject:oneInfo];
                    [oneInfo release];
                }
            }
            NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
            [userInfo setValue:resultArray forKey:RequsetExtra];
            [self afterDefaultSuccessed:nil userRequst:request notifyName:StockObjectAddedNotification];
            [resultArray release];
        }
        else {
            [self requestFailed:request];
        }
        
        [resultString release];
    } else if(request.tag==Stage_Request_OneStockLookup)
    {
        NSDictionary* userInfo = request.userInfo;
        NSDictionary* curArgs = [userInfo valueForKey:RequsetCurArgs];
        NSString* name = [curArgs valueForKey:@"name"];
        NSNumber* forleastNumber = [curArgs valueForKey:@"forleast"];
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:enc];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        
        NSString *newXMLStr = [resultString stringByReplacingOccurrencesOfString:@"encoding=\"GBK\"" withString:@"encoding=\"UTF-8\""];
        newXMLStr = [newXMLStr stringByReplacingOccurrencesOfString:@"encoding=\"gb2312\"" withString:@"encoding=\"UTF-8\""];
        
        NSError* error = nil;
        NSDictionary* xmlDict = [XMLReader dictionaryForXMLString:newXMLStr error:&error];
        if (error) {
            NSLog(@"error=%@",error);
        }
        NSDictionary* itemArray = [xmlDict valueForKey:@"root"];
        if (itemArray) {
            NSDictionary* realDict = [itemArray valueForKey:@"item"];
            if (realDict) {
                NSMutableArray* realDictArray = [[NSMutableArray alloc] initWithCapacity:0];
                NSMutableArray* resultArray = [[NSMutableArray alloc] initWithCapacity:0];
                if ([realDict isKindOfClass:[NSDictionary class]]) {
                    [realDictArray addObject:realDict];
                }
                else {
                    [realDictArray addObjectsFromArray:(NSArray*)realDict];
                }
                for (NSDictionary* oneItem in realDictArray) {
                    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] initWithCapacity:0];
                    NSArray* allKeys = oneItem.allKeys;
                    for (NSString* oneKey in allKeys) {
                        NSDictionary* value = [oneItem valueForKey:oneKey];
                        if ([value isKindOfClass:[NSDictionary class]]) {
                            NSString* realValue = [value valueForKey:@"text"];
                            realValue = [realValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            if ([[oneKey lowercaseString] isEqualToString:@"country"]) {
                                if ([[realValue lowercaseString] isEqualToString:@"stock"]) {
                                    realValue = @"cn";
                                }
                            }
                            NSLog(@"%@ := %@",oneKey,realValue);
                            [tempDict setValue:realValue forKey:oneKey];
                        }
                    }
                    NSString* type = [tempDict valueForKey:StockFunc_RemindStockInfo_type];
                    NSString* code = [tempDict valueForKey:StockFunc_RemindStockInfo_symbol];
                    NSString* cnName = [tempDict valueForKey:StockFunc_RemindStockInfo_name];
                    
                    NSString* symbol = code;
                    if (![type isEqualToString:@"cn"]&&![type isEqualToString:@"hk"]&&![type isEqualToString:@"us"]&&![type isEqualToString:@"fund"]) {
                        symbol = [NSString stringWithFormat:@"%@%@",type,code];
                    }
                    NSString* marketSymbol = symbol;
                    if ([type isEqualToString:@"hk"]||[type isEqualToString:@"us"]) {
                        marketSymbol = [type stringByAppendingString:symbol];
                    }
                    [tempDict setValue:marketSymbol forKey:StockFunc_RemindStockInfo_marketsymbol];
                    [tempDict setValue:symbol forKey:StockFunc_RemindStockInfo_fullsymbol];
                    
                    NSString *n = [name uppercaseString];
                    NSString *s = [symbol uppercaseString];
                    //
                    //                    NSRange range = [s rangeOfString:n];
                    //                    if (range.location!=NSNotFound) {
                    //
                    //                    }
                    //
                    
                    
                    NSLog(@"%@ := %@",n,s);
                    if ([n isEqualToString:s] ) {
                        [resultArray addObject:tempDict];
                    }
                    
                    [tempDict release];
                }
                
                if ([resultArray count]>1&&[forleastNumber boolValue]==YES) {
                    int foundsymbolcount = 0;
                    int foundsymbolindex = 0;
                    int foundnameCount = 0;
                    int foundnameIndex = 0;
                    for (int i=0; i<[resultArray count]; i++) {
                        NSDictionary* tempDict = [resultArray objectAtIndex:i];
                        NSString* oneSymbol = [tempDict valueForKey:StockFunc_RemindStockInfo_fullsymbol];
                        NSString* oneName = [tempDict valueForKey:StockFunc_RemindStockInfo_name];
                        if ([oneSymbol isEqualToString:name]) {
                            foundsymbolcount++;
                            foundsymbolindex = i;
                        }
                        if ([oneName isEqualToString:name]) {
                            foundnameCount++;
                            foundnameIndex = i;
                        }
                    }
                    if (foundsymbolcount==1) {
                        NSDictionary* tempDict = [resultArray objectAtIndex:foundsymbolindex];
                        [tempDict retain];
                        [resultArray removeAllObjects];
                        [resultArray addObject:tempDict];
                        [tempDict release];
                    }
                    else if(foundnameCount==1)
                    {
                        NSDictionary* tempDict = [resultArray objectAtIndex:foundnameIndex];
                        [tempDict retain];
                        [resultArray removeAllObjects];
                        [resultArray addObject:tempDict];
                        [tempDict release];
                    }
                    else {
                        [resultArray removeAllObjects];
                    }
                }
                
                [self afterDefaultSuccessed:resultArray userRequst:request notifyName:StockObjectAddedNotification];
                [realDictArray release];
                [resultArray release];
            }
            else {
                [self afterDefaultSuccessed:nil userRequst:request notifyName:StockObjectAddedNotification];
            }
        }
        else {
            [self requestFailed:request];
        }
        
        [resultString release];
    }
    else if(request.tag==Stage_Request_StockLookup)
    {
        NSDictionary* userInfo = request.userInfo;
        NSDictionary* curArgs = [userInfo valueForKey:RequsetCurArgs];
        NSString* name = [curArgs valueForKey:@"name"];
        NSNumber* forleastNumber = [curArgs valueForKey:@"forleast"];
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:enc];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        
        NSString *newXMLStr = [resultString stringByReplacingOccurrencesOfString:@"encoding=\"GBK\"" withString:@"encoding=\"UTF-8\""];
        newXMLStr = [newXMLStr stringByReplacingOccurrencesOfString:@"encoding=\"gb2312\"" withString:@"encoding=\"UTF-8\""];
        
        NSError* error = nil;
        NSDictionary* xmlDict = [XMLReader dictionaryForXMLString:newXMLStr error:&error];
        if (error) {
            NSLog(@"error=%@",error);
        }
        NSDictionary* itemArray = [xmlDict valueForKey:@"root"];
        if (itemArray) {
            NSDictionary* realDict = [itemArray valueForKey:@"item"];
            if (realDict) {
                NSMutableArray* realDictArray = [[NSMutableArray alloc] initWithCapacity:0];
                NSMutableArray* resultArray = [[NSMutableArray alloc] initWithCapacity:0];
                if ([realDict isKindOfClass:[NSDictionary class]]) {
                    [realDictArray addObject:realDict];
                }
                else {
                    [realDictArray addObjectsFromArray:(NSArray*)realDict];
                }
                for (NSDictionary* oneItem in realDictArray) {
                    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] initWithCapacity:0];
                    NSArray* allKeys = oneItem.allKeys;
                    for (NSString* oneKey in allKeys) {
                        NSDictionary* value = [oneItem valueForKey:oneKey];
                        if ([value isKindOfClass:[NSDictionary class]]) {
                            NSString* realValue = [value valueForKey:@"text"];
                            realValue = [realValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                            if ([[oneKey lowercaseString] isEqualToString:@"country"]) {
                                if ([[realValue lowercaseString] isEqualToString:@"stock"]) {
                                    realValue = @"cn";
                                }
                            }
                            NSLog(@"%@ := %@",oneKey,realValue);
                            [tempDict setValue:realValue forKey:oneKey];
                        }
                    }
                    NSString* type = [tempDict valueForKey:StockFunc_RemindStockInfo_type];
                    NSString* code = [tempDict valueForKey:StockFunc_RemindStockInfo_symbol];
                    NSString* cnName = [tempDict valueForKey:StockFunc_RemindStockInfo_name];
                    
                    NSString* symbol = code;
                    if (![type isEqualToString:@"cn"]&&![type isEqualToString:@"hk"]&&![type isEqualToString:@"us"]&&![type isEqualToString:@"fund"]) {
                        symbol = [NSString stringWithFormat:@"%@%@",type,code];
                    }
                    NSString* marketSymbol = symbol;
                    if ([type isEqualToString:@"hk"]||[type isEqualToString:@"us"]) {
                        marketSymbol = [type stringByAppendingString:symbol];
                    }
                    [tempDict setValue:marketSymbol forKey:StockFunc_RemindStockInfo_marketsymbol];
                    [tempDict setValue:symbol forKey:StockFunc_RemindStockInfo_fullsymbol];
                    
                    NSString *n = [name uppercaseString];
                    NSString *s = [symbol uppercaseString];
//                    
//                    NSRange range = [s rangeOfString:n];
//                    if (range.location!=NSNotFound) {
//                        
//                    }
//                    
                    [resultArray addObject:tempDict];
                    
//                    NSLog(@"%@ := %@",n,s);
//                    if ([n isEqualToString:s] ) {
                        
//                    }
                    
                    [tempDict release];
                }
                
                if ([resultArray count]>1&&[forleastNumber boolValue]==YES) {
                    int foundsymbolcount = 0;
                    int foundsymbolindex = 0;
                    int foundnameCount = 0;
                    int foundnameIndex = 0;
                    for (int i=0; i<[resultArray count]; i++) {
                        NSDictionary* tempDict = [resultArray objectAtIndex:i];
                        NSString* oneSymbol = [tempDict valueForKey:StockFunc_RemindStockInfo_fullsymbol];
                        NSString* oneName = [tempDict valueForKey:StockFunc_RemindStockInfo_name];
                        if ([oneSymbol isEqualToString:name]) {
                            foundsymbolcount++;
                            foundsymbolindex = i;
                        }
                        if ([oneName isEqualToString:name]) {
                            foundnameCount++;
                            foundnameIndex = i;
                        }
                    }
                    if (foundsymbolcount==1) {
                        NSDictionary* tempDict = [resultArray objectAtIndex:foundsymbolindex];
                        [tempDict retain];
                        [resultArray removeAllObjects];
                        [resultArray addObject:tempDict];
                        [tempDict release];
                    }
                    else if(foundnameCount==1)
                    {
                        NSDictionary* tempDict = [resultArray objectAtIndex:foundnameIndex];
                        [tempDict retain];
                        [resultArray removeAllObjects];
                        [resultArray addObject:tempDict];
                        [tempDict release];
                    }
                    else {
                        [resultArray removeAllObjects];
                    }
                }
                
                [self afterDefaultSuccessed:resultArray userRequst:request notifyName:StockObjectAddedNotification];
                [realDictArray release];
                [resultArray release];
            }
            else {
                [self afterDefaultSuccessed:nil userRequst:request notifyName:StockObjectAddedNotification];
            }
        }
        else {
            [self requestFailed:request];
        }
        
        [resultString release];
    }
    else if(request.tag==Stage_Request_StockRemindStartup)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSString* newString = resultString;
        if ([resultString hasPrefix:@"callback"]) {
            newString = [resultString substringFromIndex:8];
        }
        newString = [MyTool formatlizeJSonStringWith:newString];
        NSDictionary* jsonDict = [newString objectFromJSONString];
        if (jsonDict) {
            NSLog(@"start remind error=%@",[[jsonDict valueForKey:@"msg"] decodeUTF8String]);
        }
        else {
            [self retryRequest:request loginKey:@"wb_actoken"];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_StockRemindUserInfo)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        
        [resultString release];
    }
    else if(request.tag==Stage_Request_StockRemindAddInfo||request.tag==Stage_Request_StockRemindUpdateInfo||request.tag==Stage_Request_StockRemindRemoveInfo)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
        NSMutableDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
        if (!extraDict) {
            extraDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [userInfo setValue:extraDict forKey:RequsetExtra];
            [extraDict release];
        }
        NSArray* versionDict = [resultString objectFromJSONString];
        BOOL bError = NO;
        if (versionDict) {
            BOOL resultError = NO;
            if ([versionDict isKindOfClass:[NSDictionary class]]) {
                NSNumber* resultNumber = [(NSDictionary*)versionDict valueForKey:@"status"];
                NSString* resultMsg = [(NSDictionary*)versionDict valueForKey:@"msg"];
                [extraDict setValue:[resultMsg decodeUTF8String] forKey:@"msg"];
                if (resultNumber&&[resultNumber intValue]==0) {
                    resultError = YES;
                    bError= YES;
                }
                NSLog(@"Group error!msg=%@,url=%@",[resultMsg decodeUTF8String],request.url.absoluteString);
            }
            else {
                resultError = YES;
                bError= YES;
            }
            if (!resultError) {
                [self afterDefaultSuccessed:nil userRequst:request notifyName:StockObjectAddedNotification];
            }
            else {
                bError = YES;
            }
            
        }
        else {
            bError = YES;
        }
        if (bError) {
            [self retryRequest:request loginKey:@"wb_actoken"];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_StockRemindList)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
        NSMutableDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
        if (!extraDict) {
            extraDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [userInfo setValue:extraDict forKey:RequsetExtra];
            [extraDict release];
        }
        NSDictionary* versionDict = [resultString mutableObjectFromJSONString];
        BOOL bError = NO;
        BOOL bUnLogined = NO;
        if (versionDict) {
            BOOL resultError = NO;
            if ([versionDict isKindOfClass:[NSDictionary class]]) {
                NSNumber* resultNumber = [(NSDictionary*)versionDict valueForKey:@"status"];
                NSString* resultMsg = [(NSDictionary*)versionDict valueForKey:@"msg"];
                NSMutableDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
                [extraDict setValue:[resultMsg decodeUTF8String] forKey:@"msg"];
                if (resultNumber&&[resultNumber intValue]==0) {
                    resultError = YES;
                    bError= YES;
                }
                NSNumber* codeNumber = [(NSDictionary*)versionDict valueForKey:@"code"];
                if (codeNumber&&[codeNumber intValue]==24031) {
                    bUnLogined = YES;
                }
                NSLog(@"Group error!msg=%@,url=%@",[resultMsg decodeUTF8String],request.url.absoluteString);
            }
            else {
                resultError = YES;
                bError= YES;
            }
            if (!resultError) {
                NSArray* dataArray = [versionDict valueForKey:@"data"];
                if ([dataArray isKindOfClass:[NSNull class]]) {
                    dataArray = nil;
                }
                for (NSMutableDictionary* oneInfo in dataArray) {
                    NSString* code = [oneInfo valueForKey:StockFunc_RemindStockList_alert_code];
                    NSString* market = [oneInfo valueForKey:StockFunc_RemindStockList_market];
                    NSString* fullSymbol = [NSString stringWithFormat:@"%@%@",market,code];
                    [oneInfo setValue:fullSymbol forKey:StockFunc_RemindStockList_fullsymbol];
                }
                
                NSMutableDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
                [extraDict setValue:versionDict forKey:@"dict"];
                if (dataArray&&[dataArray count]>0) {
                    [self afterDefaultSuccessed:nil userRequst:request dataname:nil notifyName:StockObjectAddedInternalNotification];
                }
                else {
                    [self afterDefaultSuccessed:nil userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
                }
            }
            else {
                bError = YES;
            }
            
        }
        else {
            bError = YES;
        }
        if (bError) {
            NSNumber* retryNumber = [userInfo valueForKey:RequsetRetry];
            BOOL bUnloginedError = NO;
            if (retryNumber&&[retryNumber intValue]>0) {
                if (bUnLogined) {
                    bUnloginedError = YES;
                }
            }
            if (bUnloginedError) {
                [self afterDefaultSuccessed:nil userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
            }
            else {
                [self retryRequest:request loginKey:@"wb_actoken"];
            }
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_StockRemindHistoryList)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
        NSMutableDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
        if (!extraDict) {
            extraDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [userInfo setValue:extraDict forKey:RequsetExtra];
            [extraDict release];
        }
        NSDictionary* versionDict = [resultString mutableObjectFromJSONString];
        BOOL bError = NO;
        BOOL bUnLogined = NO;
        if (versionDict) {
            BOOL resultError = NO;
            if ([versionDict isKindOfClass:[NSDictionary class]]) {
                NSNumber* resultNumber = [(NSDictionary*)versionDict valueForKey:@"status"];
                NSString* resultMsg = [(NSDictionary*)versionDict valueForKey:@"msg"];
                NSMutableDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
                [extraDict setValue:[resultMsg decodeUTF8String] forKey:@"msg"];
                if (resultNumber&&[resultNumber intValue]==0) {
                    resultError = YES;
                    bError= YES;
                }
                NSNumber* codeNumber = [(NSDictionary*)versionDict valueForKey:@"code"];
                if (codeNumber&&[codeNumber intValue]==24031) {
                    bUnLogined = YES;
                }
                NSLog(@"Group error!msg=%@,url=%@",[resultMsg decodeUTF8String],request.url.absoluteString);
            }
            else {
                resultError = YES;
                bError= YES;
            }
            if (!resultError) {
                NSArray* dataArray = [versionDict valueForKey:@"data"];
                for (NSMutableDictionary* oneInfo in dataArray) {
                    NSString* code = [oneInfo valueForKey:StockFunc_RemindHistoryList_alert_code];
                    NSString* market = [oneInfo valueForKey:StockFunc_RemindHistoryList_market];
                    NSString* fullSymbol = [NSString stringWithFormat:@"%@%@",market,code];
                    [oneInfo setValue:fullSymbol forKey:StockFunc_RemindHistoryList_fullsymbol];
                }
                
                NSMutableDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
                [extraDict setValue:versionDict forKey:@"dict"];
                if (dataArray&&[dataArray count]>0) {
                    [self afterDefaultSuccessed:nil userRequst:request dataname:nil notifyName:StockObjectAddedInternalNotification];
                }
                else {
                    [self afterDefaultSuccessed:nil userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
                }
            }
            else {
                bError = YES;
            }
            
        }
        else {
            bError = YES;
        }
        if (bError) {
            NSNumber* retryNumber = [userInfo valueForKey:RequsetRetry];
            BOOL bUnloginedError = NO;
            if (retryNumber&&[retryNumber intValue]>0) {
                if (bUnLogined) {
                    bUnloginedError = YES;
                }
            }
            if (bUnloginedError) {
                [self afterDefaultSuccessed:nil userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
            }
            else {
                [self retryRequest:request loginKey:@"wb_actoken"];
            }
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_OneCnStockReportContent)
    {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:enc];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
        NSDictionary* jsonDict = [newString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* codeNumber = [jsonDict objectForKey:@"code"];
            if ([codeNumber isKindOfClass:[NSString class]]) {
                codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
            }
            if ([codeNumber intValue]==0) {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
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
    else if(request.tag==Stage_Request_OneCnStockNoticeContent)
    {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:enc];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
        NSDictionary* jsonDict = [newString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary* dataDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dataDict setValue:jsonDict forKey:@"data"];
            [self afterDefaultSuccessed:dataDict userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
            [dataDict release];
        }
        else
        {
            [self requestFailed:request];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_OneHkStockNoticeContent)
    {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:enc];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
        NSDictionary* jsonDict = [newString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSDictionary* resultDict = [jsonDict valueForKey:@"result"];
            [self afterDefaultSuccessed:resultDict userRequst:request dataname:nil notifyName:StockObjectAddedNotification];
        }
        else
        {
            [self requestFailed:request];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_SearchHotStock)
    {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:enc];
        if (!resultString) {
            resultString = [request.responseString retain];
        }
        
        NSRange range = [resultString rangeOfString:@"/*"];
        if (range.location!=NSNotFound) {
            NSString* newString = [resultString substringToIndex:range.location];
            NSArray* jsonDict = [newString mutableObjectFromJSONString];
            if (jsonDict&&[jsonDict isKindOfClass:[NSArray class]]) {
                for (NSMutableDictionary* oneDict in jsonDict) {
                    NSString* symbol = [oneDict valueForKey:SearchHotStock_symbol];
                    if ([symbol hasPrefix:@"sh"]||[symbol hasPrefix:@"sz"]) {
                        [oneDict setValue:@"cn" forKey:SearchHotStock_type];
                    }
                }
                [self afterDefaultSuccessed:jsonDict userRequst:request notifyName:StockObjectAddedNotification];
            }
            else
            {
                [self requestFailed:request];
            }
        }
        else {
            [self requestFailed:request];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_TestAPI)
    {
        NSString* requestString = request.responseString;
        [self afterDefaultSuccessed:nil userRequst:request notifyName:StockObjectAddedNotification];
    }
    else
    {
        [self afterDefaultSuccessed:nil userRequst:request notifyName:StockObjectAddedNotification];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
    NSDictionary* userInfo = request.userInfo;
    NSNumber* sender = [userInfo valueForKey:RequsetSender];
    NSDictionary* jsonDict = [resultString objectFromJSONString];
#ifdef DEBUG
    NSLog(@"stockrequstfailed,stage=%@,url=%@,error=%@",[userInfo valueForKey:RequsetStage],request.url.absoluteURL,[request.error description]);
#endif
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
    
    BOOL useOldRequst = NO;
    ASIHTTPRequest* oldRequest = [userInfo valueForKey:RequsetInfo];
    if (oldRequest&&[oldRequest isKindOfClass:[ASIHTTPRequest class]]) {
        if ([sender intValue]==(NSInteger)self) {
            useOldRequst = YES;
        }
    }
    
    if (useOldRequst) {
        [self afterDefaultFailed:oldRequest notifyName:StockObjectFailedNotification];
    }
    else {
        [self afterDefaultFailed:request notifyName:StockObjectFailedNotification];
    }
}

-(void)retryRequest:(ASIHTTPRequest*)request loginKey:(NSString*)loginKey
{
    NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
    NSNumber* retryNumber = [userInfo valueForKey:RequsetRetry];
    
    if (retryNumber&&[retryNumber intValue]>0) {
        [self requestFailed:request];
    }
    else {
        [userInfo setValue:[NSNumber numberWithInt:1] forKey:RequsetRetry];
        NSMutableDictionary* taskDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [taskDict setValue:request forKey:LoginDictRequestkey];
        [taskDict setValue:self forKey:LoginDictObjectkey];
        NSNumber* seperateNumber = [userInfo valueForKey:RequsetSeperate];
        NSString* selString = nil;
        if (seperateNumber&&[seperateNumber boolValue]==YES) {
            selString = NSStringFromSelector(@selector(addRequestToSeperateStart:));
        }
        else {
            selString = NSStringFromSelector(@selector(addRequestToDowloadQueue:));
        }
        [taskDict setValue:selString forKey:LoginDictSELkey];
        [taskDict setValue:loginKey forKey:LoginDictOAuthkey];
        [[WeiboLoginManager getInstance] startReloginWithTaskDict:taskDict];
        [taskDict release];
    }
}

-(void)clearRequestQueue
{
    self.downloadQueue = nil;
}

-(void)initalDownloadQueue
{

}


#define sss @"http://stock.finance.sina.com.cn/iphone/api/xml.php/HqService.getClosedDay?type=%@"
-(void)getAllHolidayData
{
    //实例化一个NSDateFormatter对象    
    
    //alloc后对不使用的对象别忘了release
    
    NSArray *a =[NSArray arrayWithObjects:@"us",@"hk",@"cn", nil];
    
    for (NSString *str in a) {
       
        [self getHolidayDataByCounty:str];
    }
}

-(void)getHolidayDataByCounty:(NSString *)c{
     NSString *url = [NSString stringWithFormat:sss,c];
    
    __block ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:
                                       [NSURL URLWithString:url]] ;
    [request setCompletionBlock:^{
        NSLog(@"%@",@"开始获取假日数据-----------");
        
        if ([request responseStatusCode] == 200) {
            
            NSString *resultString = [[NSString alloc] initWithData:request.responseData encoding:0x80000632];

            if (!resultString) {
                return;
            }

            NSString *newXMLStr = [resultString stringByReplacingOccurrencesOfString:@"encoding=\"gbk\"" withString:@"encoding=\"UTF-8\""];
            newXMLStr = [newXMLStr stringByReplacingOccurrencesOfString:@"encoding=\"gb2312\"" withString:@"encoding=\"UTF-8\""];
            newXMLStr = [newXMLStr stringByReplacingOccurrencesOfString:@"-" withString:@"-"];
            
            
            
            NSError* error = nil;
            NSDictionary* xmlDict = [XMLReader dictionaryForXMLString:newXMLStr error:&error];
            
            if (error) {
                NSLog(@"getHolidayDataByCounty error=%@",error);
            }
            NSMutableArray *holidayArray = [NSMutableArray array];
            
            NSDictionary* itemArray = [xmlDict valueForKey:@"root"];
            if (itemArray) {
                NSDictionary* dataDict = [itemArray valueForKey:@"data"];
                NSDictionary* realDict = [dataDict valueForKey:@"item"];

                for (NSDictionary *s in realDict) {
                    NSMutableDictionary *itemInfo = [NSMutableDictionary dictionaryWithCapacity:4];
//                     NSLog(@"error=%@",s);
                    NSString *day = [[ s valueForKey:@"day"] valueForKey:@"text"];
                    NSString *end = [[ s valueForKey:@"end"] valueForKey:@"text"];
                    NSString *msg = [[ s valueForKey:@"msg"]  valueForKey:@"text"];
                    NSString *start = [[ s valueForKey:@"start"]  valueForKey:@"text"];
                    
                    
                    day = [day stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    end = [end stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    msg = [msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    start = [start stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    
                    [itemInfo setObject:day forKey:@"day"];
                    [itemInfo setObject:end forKey:@"end"];
                    [itemInfo setObject:msg forKey:@"msg"];
                    [itemInfo setObject:start forKey:@"start"];
                    
                    [holidayArray addObject:itemInfo];
                }
            }
            
            NSString *k = [NSString stringWithFormat:@"%@_holiday_data_array",c];
            [[NSUserDefaults standardUserDefaults] setObject:holidayArray forKey:k ];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            [self getHolidayDataArrayByName:c];
        }
        
    }];
    
    [request setFailedBlock:^{
        NSLog(@"获取假日数据 error:%@",[request error]);
    }];
    
    [self.downloadQueue  addOperation:request];
    [self.downloadQueue  go];
    
}

/**
 * 根据名字去除假日数组
 *
 */
-(BOOL)getHolidayDataArrayByName:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *k = [NSString stringWithFormat:@"%@_holiday_data_array",str];    
    NSArray *harray =  (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:k];
    
    BOOL ret = NO;
    for (NSDictionary *dict  in harray) {
        if ([[dict objectForKey:@"day"] isEqualToString:currentDateStr]) {
            ret = YES;
        }
    }

    [dateFormatter release];
    
    return ret;
}


/**
 * 根据名字去除假日数组
 *
 */
-(NSString *)getHolidayNameByCounty:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *k = [NSString stringWithFormat:@"%@_holiday_data_array",str];
    NSArray *harray =  (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:k];
    
    NSString  *ret = @"";
    for (NSDictionary *dict  in harray) {
//        NSLog(@"#### dic = %@, %@,msg = %@",[dict objectForKey:@"day"],currentDateStr,[dict objectForKey:@"msg"]);
        NSString *day = (NSString *)[dict objectForKey:@"day"];
        day = [day stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
//        NSLog(@" --is %d, %@",[day isEqualToString:currentDateStr],day);
        if ([day isEqualToString:currentDateStr]) {
            NSString *msg =  [dict objectForKey:@"msg"];
            //接口返回数据不统一，有的有休市，有的没有，所以此处统统去掉
            return [msg stringByReplacingOccurrencesOfString:@"休市" withString:@""];
        }
    }
    
    [dateFormatter release];
    
    return ret;
}




-(void)getHolidayData
{
    //实例化一个NSDateFormatter对象
  
    //alloc后对不使用的对象别忘了release
    
    
    __block ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:
                                       [NSURL URLWithString:api_holiday_url]] ;
    [request setCompletionBlock:^{
        NSLog(@"%@",@"开始获取假日数据-----------");
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        
        if ([request responseStatusCode] == 200) {
            NSDictionary *s = [[request responseData] objectFromJSONData];
            NSArray *hdays = [s objectForKey:@"hdays"];
            for (int i=0; i < [hdays count]; i++) {
                NSString *_str = (NSString *)[hdays objectAtIndex:i];
                if ([_str isEqualToString:currentDateStr]){
                    NSLog(@"INFO：%@是有效假日，股市休市",currentDateStr);
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:is_current_date_holiday_key ];
                }
            }
        }
        [dateFormatter release];
    }];
    
    [request setFailedBlock:^{
        NSLog(@"获取假日数据 error:%@",[request error]);
    }];
    
    [self.downloadQueue  addOperation:request];
    [self.downloadQueue  go];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:is_current_date_holiday_key ];
}
//http://stock2.finance.sina.com.cn/iphone/api/json.php/HqService.getList?page=1&num=100&type=world_index
-(void)getStockStatusData
{
    __block ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:
                                       [NSURL URLWithString:@"http://stock2.finance.sina.com.cn/iphone/api/json.php/HqService.getList?page=1&num=100&type=world_index"]] ;
    [request setCompletionBlock:^{
        if ([request responseStatusCode] == 200) {
            
 
            NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
            if (!resultString) {
                resultString = [request.responseString retain];
            }
            NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
            NSMutableDictionary* jsonDict = [newString mutableObjectFromJSONString];
            if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"curStockStatusNotificationName" object:nil userInfo:[jsonDict objectForKey:@"data"]];
                
            } 
            
        } 
    }];
    
    [request setFailedBlock:^{
        NSLog(@"获取getStockStatusData数据 error:%@",[request error]);
    }];
    
    int i = [[[NSUserDefaults standardUserDefaults] objectForKey:app_current_tab_index] intValue];
    
    if (i==0) {
        //[request startAsynchronous];
        [self.downloadQueue  addOperation:request];
        [self.downloadQueue  go];
    }

}



-(void)addRequestToSeperateStart:(ASIHTTPRequest*)request
{
    NSDictionary* userData = request.userInfo;
    NSNumber* requestStage = [userData valueForKey:RequsetStage];
    NSNumber* requestSender = [userData valueForKey:RequsetSender];
    if (!seperateRequestArray) {
        seperateRequestArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else {
        for (int i=[seperateRequestArray count]-1;i>=0;i--) {
            NSDictionary* oneData = [seperateRequestArray objectAtIndex:i];
            NSNumber* oldSperate = [oneData valueForKey:RequsetStage];
            NSNumber* oldSender = [oneData valueForKey:RequsetSender];
            ASIHTTPRequest* oldRequest = [oneData valueForKey:@"request"];
            [oldRequest clearDelegatesAndCancel];
            if (oldSender&&oldSperate&&requestStage&&requestSender) {
                if ([oldSender intValue]==[requestSender intValue]&&[requestStage intValue]==[oldSperate intValue]) {
                    [seperateRequestArray removeObject:oneData];
                }
            }
        }
    }
    NSMutableDictionary* dataDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dataDict setValue:requestSender forKey:RequsetSender];
    [dataDict setValue:requestStage forKey:RequsetStage];
    [dataDict setValue:request forKey:@"request"];
    [seperateRequestArray addObject:dataDict];
    [dataDict release];
    [request startAsynchronous];
}

-(void)addRequestToDowloadQueue:(ASIHTTPRequest*)request
{
    //[self initalDownloadQueue];
    [self.downloadQueue addOperation:request];
    [self.downloadQueue go];
}

-(void)addRequestToOfflineQueue:(ASIHTTPRequest*)request
{
    
}

-(void)startAPIRequest:(id)sender withAPICode:(NSArray*)codeArray pagename:(NSString*)pageName pagevalue:(NSInteger)pageValue countname:(NSString*)countName countvalue:(NSInteger)countValue args:(NSArray*)args stage:(NSInteger)stage otherUserInfo:(NSDictionary*)oUserInfo headerInfo:(NSDictionary*)headerDict inBack:(BOOL)bInBack useCache:(BOOL)useCache
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
        
        [self startHttpAPIRequstByURL:url headerDict:headerDict userInfo:dict stage:stage inBack:bInBack useCache:useCache];
    }
}

-(void)startHttpAPIRequstByURL:(NSURL*)url headerDict:(NSDictionary*)headerDict userInfo:(NSDictionary*)info stage:(NSInteger)stageInt inBack:(BOOL)bInBack useCache:(BOOL)useCache
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
    
    if (useCache) {
        ASIDownloadCache *cache = [ASIDownloadCache sharedCache];
        [request setDownloadCache:cache];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setSecondsToCache:60*60*24*30];
        [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    }
    
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
    
    NSArray* defaultArray = [self afterDefaultSuccessed:jsonDict userRequst:request dataname:dateName];
    [self afterDefaultSuccessed:defaultArray userRequst:request notifyName:notifyName];
}

-(NSArray*)afterDefaultSuccessed:(NSDictionary*)jsonDict userRequst:(ASIHTTPRequest*)request dataname:(NSString*)dateName
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
    
    NSMutableArray* defaultArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
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
    
    if ([info objectForKey:RequsetOrderArray]) {
        //TODO:
        NSLog(@"Data is =%@",array);
        NSArray *orderArray = (NSArray *)[info objectForKey:RequsetOrderArray];
        NSString *key = [orderArray objectAtIndex:0];
        NSString *type = [orderArray objectAtIndex:1];
        
        if ( [type isEqualToString:@"asc"]||[type isEqualToString:@"desc"]  ) {
           return [Util sort:array key:key type:type];
        }
    }
    
    
    return defaultArray;
}

-(void)afterDefaultSuccessed:(NSArray*)resultArray userRequst:(ASIHTTPRequest*)request notifyName:(NSString*)notifyName
{
    NSMutableDictionary* info = (NSMutableDictionary*)request.userInfo;
    NSArray* args = [info objectForKey:RequsetArgs];
    NSNumber* page = [info objectForKey:RequsetPage];
    NSNumber* offlineType = [info objectForKey:RequsetType];
    NSMutableArray* sourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray* objectArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NewsObject* oneObject in resultArray) {
        if ([oneObject isKindOfClass:[NewsObject class]]) {
            [sourceArray addObject:oneObject.newsData];
            [objectArray addObject:oneObject];
        }
        else if([oneObject isKindOfClass:[NSDictionary class]])
        {
            [sourceArray addObject:(NSDictionary*)oneObject];
            NewsObject* newObject = [[NewsObject alloc] initWithJsonDictionary:(NSDictionary*)oneObject];
            [objectArray addObject:newObject];
            [newObject release];
        }
    }
    
    CommentDataList* dataList = [info objectForKey:RequsetDataList];
    if (dataList) {
        if (page&&[page intValue]>1) {
            [dataList addCommnetContents:objectArray IDList:args];
        }
        else
        {
            [dataList refreshCommnetContents:objectArray IDList:args];
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
    [notifyDict setObject:request forKey:RequsetPreRequset];
    if (resultArray) {
        [notifyDict setObject:objectArray forKey:RequsetArray];
        [notifyDict setValue:sourceArray forKey:RequsetSourceArray];
    }
    [sourceArray release];
    [objectArray release];
    
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
    [notifyDict setObject:request forKey:RequsetPreRequset];
    
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

#pragma mark - mystock tips

//http://stock2.finance.sina.com.cn/iphone/api/json.php/HqService.getList?page=1&num=100&type=sh_rise
-(void)getStockStatusData_cn
{
    __block ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:
                                       [NSURL URLWithString:@"http://stock2.finance.sina.com.cn/iphone/api/json.php/HqService.getList?page=1&num=100&type=sh_rise"]] ;
    [request setCompletionBlock:^{
        if ([request responseStatusCode] == 200) {
            
            
            NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
            if (!resultString) {
                resultString = [request.responseString retain];
            }
            NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
            NSMutableDictionary* jsonDict = [newString mutableObjectFromJSONString];
            if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:mystock_cn_curStockStatusNotificationName object:nil userInfo:[jsonDict objectForKey:@"hq_info"]];
                
            }
            
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"获取getStockStatusData数据 error:%@",[request error]);
    }];
    
   
        //[request startAsynchronous];
    [self.downloadQueue  addOperation:request];
    [self.downloadQueue  go];
    
    
}

//http://stock2.finance.sina.com.cn/iphone/api/json.php/HqService.getList?page=1&num=100&type=hk_hot
-(void)getStockStatusData_hk
{
    __block ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:
                                       [NSURL URLWithString:@"http://stock2.finance.sina.com.cn/iphone/api/json.php/HqService.getList?page=1&num=100&type=hk_hot"]] ;
    [request setCompletionBlock:^{
        if ([request responseStatusCode] == 200) {
            
            
            NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
            if (!resultString) {
                resultString = [request.responseString retain];
            }
            NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
            NSMutableDictionary* jsonDict = [newString mutableObjectFromJSONString];
            if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:mystock_hk_curStockStatusNotificationName object:nil userInfo:[jsonDict objectForKey:@"hq_info"]];
                
            }
            
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"获取getStockStatusData数据 error:%@",[request error]);
    }];
    
    [self.downloadQueue  addOperation:request];
    [self.downloadQueue  go];
    
}

//http://stock2.finance.sina.com.cn/iphone/api/json.php/HqService.getList?page=1&num=100&type=us_china
-(void)getStockStatusData_us
{
    __block ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:
                                       [NSURL URLWithString:@"http://stock2.finance.sina.com.cn/iphone/api/json.php/HqService.getList?page=1&num=100&type=us_china"]] ;
    [request setCompletionBlock:^{
        if ([request responseStatusCode] == 200) {
            
            
            NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
            if (!resultString) {
                resultString = [request.responseString retain];
            }
            NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
            NSMutableDictionary* jsonDict = [newString mutableObjectFromJSONString];
            if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:mystock_us_curStockStatusNotificationName object:nil userInfo:[jsonDict objectForKey:@"hq_info"]];
                
            }
            
        }
    }];
    
    [request setFailedBlock:^{
        NSLog(@"获取getStockStatusData数据 error:%@",[request error]);
    }];
    
    [self.downloadQueue  addOperation:request];
    [self.downloadQueue  go];
    
}
@end
