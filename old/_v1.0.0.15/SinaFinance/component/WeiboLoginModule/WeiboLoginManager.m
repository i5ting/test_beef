//
//  WeiboLoginManager.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WeiboLoginManager.h"
#import "RegValueSaver.h"
#import "MyTool.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "LKTipCenter.h"

#define LoginReturnKey_User_id @"uid"
#define Key_LoginDataInternal @"Key_LoginDataInternal"

NSString* OAUTH2_Client_ID = @"client_id";
NSString* OAUTH2_Client_Secret = @"client_secret";
NSString* OAUTH2_Grant_Type = @"grant_type";
NSString* OAUTH2_Username = @"username";
NSString* OAUTH2_Password = @"password";

NSString* HttpAPIV2_Login = @"https://api.weibo.com/oauth2/access_token";

@interface WeiboLoginManager ()
@property(nonatomic,retain)NSDictionary* loginData;
@property(nonatomic,retain)ASIHTTPRequest* asiRequest;
@property(retain)NSString* APPVALUE;
@property(retain)NSString* APPSECRET;

-(void)initalDownloadQueue;
-(void)addRequestToDowloadQueue:(ASIHTTPRequest*)request;
-(void)afterLoginSuccessed:(ASIHTTPRequest *)request info:(NSDictionary*)info;
-(void)afterLoginFailed:(ASIHTTPRequest *)request info:(NSDictionary*)info;
-(void)startRealLoginV2WithInfo:(NSDictionary*)info;
-(NSMutableDictionary*)rawAuth2DictRetOrder:(NSMutableArray*)orderArray loginDict:(NSDictionary*)loginDict;
-(void)startLoginV2Request:(NSDictionary*)dict order:(NSArray*)orderArray httpAPI:(NSString*)api userInfo:(NSDictionary*)info;
-(void)mainThreadRunningNotification:(NSDictionary*)argInfo;
@end

@implementation WeiboLoginManager
@synthesize downloadQueue=mDownloadQueue;
@synthesize loginData = mLoginData,oAuthData = mOAuthData;
@synthesize hasLogined;
@synthesize loginedAccount,loginedID;
@synthesize asiRequest;
@synthesize APPVALUE,APPSECRET;
@synthesize appKey,appSecret;

+ (id)getInstance
{
    static WeiboLoginManager* s_messageManager = nil;
	if (s_messageManager == nil)
	{
		//没有创建则创建
		s_messageManager = [[WeiboLoginManager alloc] init];
        
	}
	return s_messageManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self initNotification];
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
    [APPVALUE release];
    [APPSECRET release];
    [mDownloadQueue release];
    [appKey release];
    [appSecret release];
    
    [super dealloc];
}

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(LoginedSuccessed:)
               name:LoginSuccessedNotification 
             object:nil];
    [nc addObserver:self selector:@selector(LoginFailed:)
               name:LoginFailedNotification 
             object:nil];
    [nc addObserver:self selector:@selector(LogoutSuccessed:)
               name:LogoutSuccessedNotification 
             object:nil];
}

-(void)LoginedSuccessed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* silenceNumber = [userInfo valueForKey:SilenceLoginKey];
    NSString* userName = [userInfo valueForKey:Key_Login_Username];
    
    if(!(silenceNumber&&[silenceNumber boolValue]))
    {
        NSString* tipString = [NSString stringWithFormat:@"帐号(%@)登录成功",userName];
//        [[LKTipCenter defaultCenter] postTopTipWithMessage:tipString time:2.0 color:nil];
        
        [SVProgressHUD dismissWithError:tipString afterDelay:2.0];
        
    }
}

-(void)LoginFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* silenceNumber = [userInfo valueForKey:SilenceLoginKey];
    NSString* userName = [userInfo valueForKey:Key_Login_Username];
    
    if(!(silenceNumber&&[silenceNumber boolValue]))
    {
        NSString* tipString = [NSString stringWithFormat:@"帐号(%@)登录失败",userName];
        [SVProgressHUD dismissWithError:tipString afterDelay:2.0];
//        [[LKTipCenter defaultCenter] postTopTipWithMessage:tipString time:2.0 color:nil];
    }
}

-(void)LogoutSuccessed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSString* userName = [userInfo valueForKey:Key_Login_Username];
    NSString* tipString = [NSString stringWithFormat:@"帐号(%@)已注销",userName];
    [SVProgressHUD dismissWithError:tipString afterDelay:2.0];
//    [[LKTipCenter defaultCenter] postTopTipWithMessage:tipString time:2.0 color:nil];
}

-(NSString*)APPVALUE
{
    return self.appKey;
}

-(NSString*)APPSECRET
{
    return self.appSecret;
}

-(NSString*)loginedAccount
{
    NSString* rtval = nil;
    if (self.hasLogined) {
        rtval = [self.oAuthData objectForKey:Key_Login_Username];
    }
    return rtval;
}

-(NSString*)loginedID
{
    NSString* rtval = nil;
    if (self.hasLogined) {
        rtval = [self.oAuthData objectForKey:LoginReturnKey_User_id];
        if (!rtval) {
            NSString* loginAccount = [self loginedAccount];
            rtval = [[RegValueSaver getInstance] findUIDFromAccount:loginAccount accountType:AccountTypeWeibo];
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
    NSDictionary* oldLoginData = nil;
    if (!self.loginData) {
        NSString* userID = [[RegValueSaver getInstance] readSystemInfoForKey:RegKey_CurrentAccount];
        if (userID) {
            oldLoginData = [[RegValueSaver getInstance] readUserInfoForKey:RegKey_UserData_LoginDict userID:userID accountType:AccountTypeWeibo];
        }
    }
    else {
        oldLoginData = self.loginData;
    }
    if (oldLoginData) {
        NSMutableDictionary* newDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [newDict setValue:oldLoginData forKey:Key_LoginDataInternal];
        [newDict setValue:[NSNumber numberWithBool:YES] forKey:SilenceLoginKey];
        if (dict) {
            [newDict addEntriesFromDictionary:dict];
        }
        
        [self startRealLoginV2WithInfo:newDict];
        [newDict release];
    }
    else {
        NSMutableDictionary* newDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [newDict setValue:[NSNumber numberWithBool:YES] forKey:SilenceLoginKey];
        if (dict) {
            [newDict addEntriesFromDictionary:dict];
        }
        [self restartHttpAPIWithUserInfo:newDict];
        [newDict release];
    }
}

-(void)startLogin:(NSDictionary*)loginData
{
    [self startLogin:loginData force:NO];
}

-(void)startLogin:(NSDictionary*)loginData force:(BOOL)bForce
{
    if (loginData==nil||[loginData count]==0) {
        NSString* userID = [[RegValueSaver getInstance] readSystemInfoForKey:RegKey_CurrentAccount];
        NSDictionary* oldLoginData = nil;
        if (userID) {
            oldLoginData = [[RegValueSaver getInstance] readUserInfoForKey:RegKey_UserData_LoginDict userID:userID accountType:AccountTypeWeibo];
            self.oAuthData = [[RegValueSaver getInstance] readUserInfoForKey:RegKey_UserData_TokenDict userID:userID accountType:AccountTypeWeibo];
        }
        if (!self.oAuthData) {
            if (oldLoginData) {
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
                [dict setValue:oldLoginData forKey:Key_LoginDataInternal];
                [self startRealLoginV2WithInfo:dict];
                [dict release];
            }
        }
        else
        {
            self.loginData = oldLoginData;
            NSMutableDictionary* resultDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [resultDict setValue:[NSNumber numberWithBool:YES] forKey:SilenceLoginKey];
            NSString* accountName = [oldLoginData objectForKey:Key_Login_Username];
            [resultDict setValue:accountName forKey:Key_Login_Username];
            [self afterLoginSuccessed:nil info:resultDict];
            [resultDict release];
            if (oldLoginData&&bForce) {
                NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
                [dict setValue:oldLoginData forKey:Key_LoginDataInternal];
                [dict setValue:[NSNumber numberWithBool:YES] forKey:SilenceLoginKey];
                [self startRealLoginV2WithInfo:dict];
                [dict release];
            }
        }
    }
    else
    {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dict setValue:loginData forKey:Key_LoginDataInternal];
        [self startRealLoginV2WithInfo:dict];
        [dict release];
    }
}

-(void)startRealLoginV2WithInfo:(NSDictionary*)info
{
    NSDictionary* loginData = [info valueForKey:Key_LoginDataInternal];
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [self rawAuth2DictRetOrder:orderArray loginDict:loginData];
    [self startLoginV2Request:dict order:orderArray httpAPI:HttpAPIV2_Login userInfo:info];
}

-(NSMutableDictionary*)rawAuth2DictRetOrder:(NSMutableArray*)orderArray loginDict:(NSDictionary*)loginDict
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:self.APPVALUE forKey:OAUTH2_Client_ID];
    [orderArray addObject:OAUTH2_Client_ID];
    [dict setObject:self.APPSECRET forKey:OAUTH2_Client_Secret];
    [orderArray addObject:OAUTH2_Client_Secret];
    [dict setObject:@"password" forKey:OAUTH2_Grant_Type];
    [orderArray addObject:OAUTH2_Grant_Type];
    NSString* userName = [loginDict objectForKey:Key_Login_Username];
    [dict setObject:userName forKey:OAUTH2_Username];
    [orderArray addObject:OAUTH2_Username];
    NSString* password = [loginDict objectForKey:Key_Login_Password];
    [dict setObject:password forKey:OAUTH2_Password];
    [orderArray addObject:OAUTH2_Password];
    
    return dict;
}

-(void)startLoginV2Request:(NSDictionary*)dict order:(NSArray*)orderArray httpAPI:(NSString*)api userInfo:(NSDictionary*)info
{
    NSString *urlStr = [MyTool urlParmFormatWithSourceString:api FromDict:dict order:orderArray useEncode:YES];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSDictionary* loginData = [info valueForKey:Key_LoginDataInternal];
    NSString* accountName = [loginData objectForKey:Key_Login_Username];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL :url];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    NSMutableDictionary* userDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [userDict setValue:accountName forKey:Key_Login_Username];
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
    NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
    NSMutableDictionary* dict = [resultString mutableObjectFromJSONString];
    NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
    ASIHTTPRequest* taskRequst = [userInfo valueForKey:LoginDictRequestkey];
    
    if (dict&&[dict count]>0&&![dict objectForKey:@"error"]) {
        NSDictionary* userInfo = request.userInfo;
        NSString* accountName = [userInfo objectForKey:Key_Login_Username];
        NSDictionary* loginData = [userInfo valueForKey:Key_LoginDataInternal];
        NSString* userID = [dict objectForKey:LoginReturnKey_User_id];
        [dict setValue:accountName forKey:Key_Login_Username];
        self.oAuthData = dict;
        if (userID) {
            [[RegValueSaver getInstance] saveAccountDictValue:userID forKey:accountName accountType:AccountTypeWeibo];
            [[RegValueSaver getInstance] saveSystemInfoValue:userID forKey:RegKey_CurrentAccount encryptString:NO];
            [[RegValueSaver getInstance] saveUserInfoValue:dict forKey:RegKey_UserData_TokenDict userID:userID accountType:AccountTypeWeibo encryptString:YES];
            [[RegValueSaver getInstance] saveUserInfoValue:loginData forKey:RegKey_UserData_LoginDict userID:userID accountType:AccountTypeWeibo encryptString:YES];
        }
        self.loginData = loginData;
        if (!taskRequst) {
            [self afterLoginSuccessed:request info:request.userInfo];
        }
    }
    else
    {
        if (!taskRequst) {
            NSString* errorCodeNumber = [dict objectForKey:@"error_code"];
            if ([errorCodeNumber intValue]==21325) {
                [userInfo setValue:[NSNumber numberWithInt:ErrorCode_UserNamePassword] forKey:RequsetError];
            }
            [self afterLoginFailed:request info:request.userInfo];
        }
    }
    [resultString release];
    
    if (taskRequst) {
        [self restartHttpAPIRequst:request];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSDictionary* userInfo = request.userInfo;
    ASIHTTPRequest* taskRequst = [userInfo valueForKey:LoginDictRequestkey];
    if (!taskRequst) {
        [self afterLoginFailed:request info:request.userInfo];
    }
    else {
        [self restartHttpAPIRequst:request];
    }
}

-(void)restartHttpAPIRequst:(ASIHTTPRequest*)request
{
    NSDictionary* userInfo = request.userInfo;
    [self restartHttpAPIWithUserInfo:userInfo];
}

-(void)restartHttpAPIWithUserInfo:(NSDictionary*)userInfo
{
    ASIHTTPRequest* taskRequst = [userInfo valueForKey:LoginDictRequestkey];
    id object = [userInfo valueForKey:LoginDictObjectkey];
    NSString* selString = [userInfo valueForKey:LoginDictSELkey];
    SEL sel = NSSelectorFromString(selString);
    NSString* oauthKey = [userInfo valueForKey:LoginDictOAuthkey];
    NSString* method = taskRequst.requestMethod;
    if ([method.uppercaseString isEqualToString:@"POST"]) {
        if ([taskRequst isKindOfClass:[ASIFormDataRequest class]]) {
            NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
            
            [(ASIFormDataRequest*)taskRequst setPostValue:token forKey:oauthKey];
        }
    }
    
    {
        
        NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
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

-(void)afterLoginSuccessed:(ASIHTTPRequest *)request info:(NSDictionary*)info
{
    self.hasLogined = YES;
    
    NSMutableDictionary* notifyDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [notifyDict setObject:LoginSuccessedNotification forKey:@"postNotificationName"];
    [notifyDict setObject:NSStringFromClass([self class]) forKey:@"object"];
    NSMutableDictionary* userDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (info) {
        [userDict addEntriesFromDictionary:info];
    }
    [notifyDict setObject:userDict forKey:@"userInfo"];
    [userDict release];
    
    [self performSelectorOnMainThread:@selector(mainThreadRunningNotification:) withObject:notifyDict waitUntilDone:NO];
}

-(void)afterLoginFailed:(ASIHTTPRequest *)request info:(NSDictionary*)info
{
    NSMutableDictionary* notifyDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [notifyDict setObject:LoginFailedNotification forKey:@"postNotificationName"];
    [notifyDict setObject:NSStringFromClass([self class]) forKey:@"object"];
    NSMutableDictionary* userDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (info) {
        [userDict addEntriesFromDictionary:info];
    }
    [notifyDict setObject:userDict forKey:@"userInfo"];
    [userDict release];
    [self performSelectorOnMainThread:@selector(mainThreadRunningNotification:) withObject:notifyDict waitUntilDone:NO];
}

-(void)startLogout
{
    NSMutableDictionary* info = [[NSMutableDictionary alloc] initWithCapacity:0];
    [info setValue:[self.loginData valueForKey:Key_Login_Username] forKey:Key_Login_Username];
    self.hasLogined = NO;
    self.loginData = nil;
    self.oAuthData = nil;
    [[RegValueSaver getInstance] saveSystemInfoValue:nil forKey:RegKey_CurrentAccount encryptString:NO];
    
    NSMutableDictionary* notifyDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [notifyDict setObject:LogoutSuccessedNotification forKey:@"postNotificationName"];
    [notifyDict setObject:NSStringFromClass([self class]) forKey:@"object"];
    NSMutableDictionary* userDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (info) {
        [userDict addEntriesFromDictionary:info];
    }
    [info release];
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
