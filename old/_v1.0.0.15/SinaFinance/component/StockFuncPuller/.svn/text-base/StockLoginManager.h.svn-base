//
//  WeiboLoginManager.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Key_StockLogin_Username @"StockLogin_Username"
#define Key_StockLogin_Password @"StockLogin_Password"
#define RegKey_StockAccountOrder @"stockaccountorder"
#define RegKey_StockCurrentAccount @"stockcurrentaccount"
#define RegKey_StockUserData_TokenDict @"stocktokendict"
#define RegKey_StockUserData_LoginDict @"stocklogindict"
#define StockKeyReturn_Ticket @"ticket"
#define StockKeyReturn_uid @"uid"

#define LoginDictRequestkey @"LoginDictRequestkey"
#define LoginDictOAuthkey @"LoginDictOAuthkey"
#define LoginDictObjectkey @"LoginDictObjectkey"
#define LoginDictSELkey @"LoginDictSELkey"

#define StockLoginSuccessedNotification @"StockLoginSuccessedNotification"
#define StockLoginFailedNotification @"StockLoginFailedNotification"
#define StockLogoutSuccessedNotification @"StockLogoutSuccessedNotification"
#define AccountTypeStock @"Stock"

#define PullerData_RequestMethod @"RequestMethod"
#define PullerData_RequestData @"RequestData"
#define PullerData_RequestOrder @"RequestOrder"
#define PullerData_RequestAPI @"RequestAPI"
#define PullerData_RequestStage @"RequestStage"
#define PullerData_RequestUserInfo @"RequestUserInfo"
#define PullerData_RequestHeaderDict @"RequestHeaderDict"
#define PullerData_RequestInBack @"RequestInBack"
#define PullerData_HTTPAPI_SearchKey @"HTTPAPISearchKey"

@class ASIHTTPRequest;
@class ASINetworkQueue;

@interface StockLoginManager : NSObject
{
    NSDictionary* mLoginData;
    NSDictionary* mOAuthData;
    ASIHTTPRequest* asiRequest;
    ASINetworkQueue* mDownloadQueue;
}
@property(retain)ASINetworkQueue* downloadQueue;
@property(assign)BOOL hasLogined;
@property(assign)NSString* loginedAccount;
@property(assign)NSString* loginedID;
@property(retain)NSDictionary* oAuthData;

+ (id)getInstance;

-(void)startReloginWithTaskDict:(NSDictionary*)dict;
-(void)startLogin:(NSDictionary*)loginData;
-(void)startLogout;

@end
