//
//  WeiboLoginManager.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StockLoginManager.h"
#import "RegValueSaver.h"
#import "MyTool.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "ASINetworkQueue.h"
#import "NSData+base64.h"

#define HttpAPI_StockLogin @"https://login.sina.com.cn/sso/login.php"
#define StockLoginReturnKey_User_id @"uid"
#define Key_StockLoginDataInternal @"Key_StockLoginDataInternal"

@interface StockLoginManager ()
@property(nonatomic,retain)NSDictionary* loginData;
@property(nonatomic,retain)ASIHTTPRequest* asiRequest;

-(void)initalDownloadQueue;
-(void)addRequestToDowloadQueue:(ASIHTTPRequest*)request;
-(void)afterLoginSuccessed:(ASIHTTPRequest *)request;
-(void)afterLoginFailed:(ASIHTTPRequest *)request;
-(void)startRealLoginV2WithInfo:(NSDictionary*)info;
-(NSMutableDictionary*)rawAuth2DictRetOrder:(NSMutableArray*)orderArray loginDict:(NSDictionary*)loginDict;
-(void)startLoginV2Request:(NSDictionary*)dict order:(NSArray*)orderArray httpAPI:(NSString*)api userInfo:(NSDictionary*)info;
-(void)mainThreadRunningNotification:(NSDictionary*)argInfo;
-(void)restartHttpAPIRequst:(ASIHTTPRequest*)request;
@end

@implementation StockLoginManager
@synthesize downloadQueue=mDownloadQueue;
@synthesize loginData = mLoginData,oAuthData = mOAuthData;
@synthesize hasLogined;
@synthesize loginedAccount,loginedID;
@synthesize asiRequest;

+ (id)getInstance
{
    static StockLoginManager* s_messageManager = nil;
	if (s_messageManager == nil)
	{
		//没有创建则创建
		s_messageManager = [[StockLoginManager alloc] init];
        
	}
	return s_messageManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self initalDownloadQueue];
    }
    return self;
}

-(void)dealloc
{
    [mLoginData release];
    [mOAuthData release];
    [loginedAccount release];
    [loginedID release];
    [asiRequest release];
    [mDownloadQueue release];
    [super dealloc];
}

-(NSString*)loginedAccount
{
    NSString* rtval = nil;
    if (self.hasLogined) {
        rtval = [self.oAuthData objectForKey:Key_StockLogin_Username];
    }
    return rtval;
}

-(NSString*)loginedID
{
    NSString* rtval = nil;
    if (self.hasLogined) {
        rtval = [self.oAuthData objectForKey:StockLoginReturnKey_User_id];
        if (!rtval) {
            NSString* loginAccount = [self loginedAccount];
            rtval = [[RegValueSaver getInstance] findUIDFromAccount:loginAccount accountType:AccountTypeStock];
        }
    }
    return rtval;
}

-(void)startReloginWithTaskDict:(NSDictionary*)dict
{
    [self performSelectorOnMainThread:@selector(startReloginMainThreadWithTaskDict:) withObject:dict waitUntilDone:NO];
}

-(void)startReloginMainThreadWithTaskDict:(NSDictionary*)dict
{
    if(hasLogined&&self.loginData)
    {
        if (self.loginData) {
            NSMutableDictionary* newDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [newDict setValue:self.loginData forKey:Key_StockLoginDataInternal];
            if (dict) {
                [newDict addEntriesFromDictionary:dict];
            }
            [self startRealLoginV2WithInfo:newDict];
            [newDict release];
        }
    }
}

-(void)startLogin:(NSDictionary*)loginData
{
    if (loginData==nil||[loginData count]==0) {
        NSString* userID = [[RegValueSaver getInstance] readSystemInfoForKey:RegKey_StockCurrentAccount];
        NSDictionary* oldLoginData = nil;
        if (userID) {
            oldLoginData = [[RegValueSaver getInstance] readUserInfoForKey:RegKey_StockUserData_LoginDict userID:userID accountType:AccountTypeStock];
            self.oAuthData = nil;
        }
        if (!self.oAuthData) {
            if (oldLoginData) {
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
                [dict setValue:oldLoginData forKey:Key_StockLoginDataInternal];
                [self startRealLoginV2WithInfo:dict];
                [dict release];
            }
        }
        else
        {
            self.loginData = oldLoginData;
            [self afterLoginSuccessed:nil];
        }
    }
    else
    {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dict setValue:loginData forKey:Key_StockLoginDataInternal];
        [self startRealLoginV2WithInfo:dict];
        [dict release];
    }
}

-(void)startRealLoginV2WithInfo:(NSDictionary*)info
{
    NSDictionary* loginData = [info valueForKey:Key_StockLoginDataInternal];
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [self rawAuth2DictRetOrder:orderArray loginDict:loginData];
    [self startLoginV2Request:dict order:orderArray httpAPI:HttpAPI_StockLogin userInfo:info];
}

-(NSMutableDictionary*)rawAuth2DictRetOrder:(NSMutableArray*)orderArray loginDict:(NSDictionary*)loginDict
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:@"finance_client" forKey:@"entry"];
    [orderArray addObject:@"entry"];
    NSString* userName = [loginDict valueForKey:Key_StockLogin_Username];
    [dict setObject:userName forKey:@"username"];
    [orderArray addObject:@"username"];
    NSString* passWord = [loginDict valueForKey:Key_StockLogin_Password];
    [dict setObject:passWord forKey:@"password"];
    [orderArray addObject:@"password"];
    [dict setObject:@"finance" forKey:@"service"];
    [orderArray addObject:@"service"];
    [dict setObject:@"TEXT" forKey:@"returntype"];
    [orderArray addObject:@"returntype"];    
    return dict;
}

-(void)startLoginV2Request:(NSDictionary*)dict order:(NSArray*)orderArray httpAPI:(NSString*)api userInfo:(NSDictionary*)info
{
    NSString *urlStr = [MyTool urlParmFormatWithSourceString:api FromDict:dict order:orderArray useEncode:YES];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSDictionary* loginData = [info valueForKey:Key_StockLoginDataInternal];
    NSString* accountName = [loginData objectForKey:Key_StockLogin_Username];
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL :url];
    [request setRequestMethod:@"POST"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    request.stringEncoding = enc;
    for (NSString* key in orderArray) {
        [request addPostValue:[dict valueForKey:key] forKey:key];

    }
    [request setDelegate:self];
    
    NSMutableDictionary* userDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [userDict setValue:accountName forKey:Key_StockLogin_Username];
    if (info) {
        [userDict addEntriesFromDictionary:info];
    }
    request.userInfo = userDict;
    ASIHTTPRequest* taskRequst = [userDict valueForKey:LoginDictRequestkey];
    if (taskRequst) {
        [self addRequestToDowloadQueue:request];
    }
    else {
        if (self.asiRequest) {
            [self.asiRequest clearDelegatesAndCancel];
            self.asiRequest = nil;
        }
        self.asiRequest = request;
        [request startAsynchronous];
    }
    [userDict release];
    [request release];
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

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString* resultString = request.responseString;
    NSMutableDictionary* dict = [resultString mutableObjectFromJSONString];
    NSDictionary* userInfo = request.userInfo;
    ASIHTTPRequest* taskRequst = [userInfo valueForKey:LoginDictRequestkey];
    
    if (dict&&[dict count]>0&&![dict objectForKey:@"error"]) {
        NSDictionary* userInfo = request.userInfo;
        NSString* accountName = [userInfo objectForKey:Key_StockLogin_Username];
        NSDictionary* loginData = [userInfo valueForKey:Key_StockLoginDataInternal];
        NSString* userID = [dict objectForKey:StockLoginReturnKey_User_id];
        [dict setValue:accountName forKey:Key_StockLogin_Username];
        self.oAuthData = dict;
        if (userID) {
            [[RegValueSaver getInstance] saveAccountDictValue:userID forKey:accountName accountType:AccountTypeStock];
            [[RegValueSaver getInstance] saveSystemInfoValue:userID forKey:RegKey_StockCurrentAccount encryptString:NO];
            [[RegValueSaver getInstance] saveUserInfoValue:dict forKey:RegKey_StockUserData_TokenDict userID:userID accountType:AccountTypeStock encryptString:YES];
            [[RegValueSaver getInstance] saveUserInfoValue:loginData forKey:RegKey_StockUserData_LoginDict userID:userID accountType:AccountTypeStock encryptString:YES];
        }
        self.loginData = loginData;
        if (!taskRequst) {
            [self afterLoginSuccessed:request];
        }
    }
    else
    {
        if (!taskRequst) {
            [self afterLoginFailed:request];
        }
    }
    
    if (taskRequst) {
        [self restartHttpAPIRequst:request];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSDictionary* userInfo = request.userInfo;
    ASIHTTPRequest* taskRequst = [userInfo valueForKey:LoginDictRequestkey];
    if (!taskRequst) {
        [self afterLoginFailed:request];
    }
    else {
        [self restartHttpAPIRequst:request];
    }
}

-(void)restartHttpAPIRequst:(ASIHTTPRequest*)request
{
    NSDictionary* userInfo = request.userInfo;
    ASIHTTPRequest* taskRequst = [userInfo valueForKey:LoginDictRequestkey];
    id object = [userInfo valueForKey:LoginDictObjectkey];
    NSString* selString = [userInfo valueForKey:LoginDictSELkey];
    SEL sel = NSSelectorFromString(selString);
    NSString* oauthKey = [userInfo valueForKey:LoginDictOAuthkey];
    NSString* method = taskRequst.requestMethod;
    if ([method.uppercaseString isEqualToString:@"POST"]) {
        if ([taskRequst isKindOfClass:[ASIFormDataRequest class]]) {
            NSString* token = [self.oAuthData objectForKey:StockKeyReturn_Ticket];
            
            [(ASIFormDataRequest*)taskRequst setPostValue:token forKey:oauthKey];
        }
    }
    
    {
        NSString* token = [self.oAuthData objectForKey:StockKeyReturn_Ticket];
        NSString* urlString = [taskRequst.url absoluteString];
        if ([urlString rangeOfString:oauthKey].location!=NSNotFound) {
            urlString = [MyTool urlString:urlString replaceStringKey:[oauthKey rawUrlEncode] withValueString:[token rawUrlEncode]];
            NSURL* url = [NSURL URLWithString:urlString];
            taskRequst.url = url;
        }
    }
    
    ASIFormDataRequest* newRequest = [[ASIFormDataRequest alloc] initWithURL:taskRequst.url];
    newRequest.delegate = taskRequst.delegate;
    newRequest.requestMethod = taskRequst.requestMethod;
    newRequest.userInfo = taskRequst.userInfo;
    newRequest.tag = taskRequst.tag;
    newRequest.requestHeaders = taskRequst.requestHeaders;
    
    if ([taskRequst isKindOfClass:[ASIFormDataRequest class]]) {
        newRequest.postData = ((ASIFormDataRequest*)taskRequst).postData;
        newRequest.fileData = ((ASIFormDataRequest*)taskRequst).fileData;
        newRequest.stringEncoding = ((ASIFormDataRequest*)taskRequst).stringEncoding;
        newRequest.postFormat = ((ASIFormDataRequest*)taskRequst).postFormat;
        
    }
    
    [object performSelector:sel withObject:newRequest];
    [newRequest release];
}

-(void)afterLoginSuccessed:(ASIHTTPRequest *)request
{
    self.hasLogined = YES;
    
    NSMutableDictionary* notifyDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [notifyDict setObject:StockLoginSuccessedNotification forKey:@"postNotificationName"];
    
    [self performSelectorOnMainThread:@selector(mainThreadRunningNotification:) withObject:notifyDict waitUntilDone:NO];
}

-(void)afterLoginFailed:(ASIHTTPRequest *)request
{
    self.loginData = nil;
    self.oAuthData = nil;
    self.hasLogined = NO;
    NSMutableDictionary* notifyDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [notifyDict setObject:StockLoginFailedNotification forKey:@"postNotificationName"];
    
    [self performSelectorOnMainThread:@selector(mainThreadRunningNotification:) withObject:notifyDict waitUntilDone:NO];
}

-(void)startLogout
{
    self.hasLogined = NO;
    self.loginData = nil;
    self.oAuthData = nil;
    [[RegValueSaver getInstance] saveSystemInfoValue:nil forKey:RegKey_StockCurrentAccount encryptString:NO];
    
    NSMutableDictionary* notifyDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [notifyDict setObject:StockLogoutSuccessedNotification forKey:@"postNotificationName"];
    
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
