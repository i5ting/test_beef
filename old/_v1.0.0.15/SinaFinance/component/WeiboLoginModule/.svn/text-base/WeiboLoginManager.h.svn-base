//
//  WeiboLoginManager.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*
 需要weibo的appkey和appsecret
 
 */


#import <Foundation/Foundation.h>

#define Key_Login_Username @"Login_Username"
#define Key_Login_Password @"Login_Password"
#define RegKey_AccountOrder @"accountorder"
#define RegKey_CurrentAccount @"currentaccount"
#define RegKey_UserData_TokenDict @"tokendict"
#define RegKey_UserData_LoginDict @"logindict"

#define OAUTH2_TOKEN @"access_token"
#define OAUTH2_Source @"source"

#define LoginReturnKey_User_id @"uid"
#define LoginReturnKeyV2_Token OAUTH2_TOKEN

#define ReLoginNotification @"ReLoginNotification"

#define LoginSuccessedNotification @"LoginSuccessedNotification"
#define LoginFailedNotification @"LoginFailedNotification"
#define LogoutSuccessedNotification @"LogoutSuccessedNotification"

#define NavObjectsAddedNotification @"NavObjectsAddedNotification"
#define NavObjectsFailedNotification @"NavObjectsFailedNotification"
#define NetworkPublishSuccessNotification @"NetworkPublishSuccessNotification"
#define NetworkPublishFaildedNotification @"NetworkPublishFaildedNotification"

#define RequsetStage @"RequsetStage"
#define RequsetSender @"RequsetSender"
#define RequsetCurArgs @"RequsetCurArgs"
#define RequsetDate @"RequsetDate"
#define RequsetArgs @"RequsetArgs"
#define RequsetPage @"RequsetPage"
#define RequsetCount @"RequsetCount"
#define RequsetArray @"RequsetArray"
#define RequsetSourceArray @"RequsetSourceArray"
#define RequsetRemoveFirst @"RequsetRemoveFirst"
#define RequsetDataList @"RequsetDataList"
#define RequsetOrder @"RequsetOrder"
#define RequsetError @"RequsetError"
#define RequsetErrorString @"RequsetErrorString"
#define RequsetType @"RequsetType"
#define RequsetIgnorePageEnd @"RequsetIgnorePageEnd"
#define RequsetLastDate @"RequsetLastDate"
#define RequsetDateKey @"RequsetDateKey"
#define RequsetDateFormatter @"RequsetDateFormatter"
#define RequsetRetry @"RequsetRetry"
#define RequsetSeperate @"RequsetSeperate"
#define RequsetExtra @"RequsetExtra"
#define RequsetInfo @"RequsetInfo"
#define RequsetOrderArray @"RequsetOrderArray"
#define RequsetPreRequset @"RequsetPreRequset"

#define LoginDictRequestkey @"LoginDictRequestkey"
#define LoginDictOAuthkey @"LoginDictOAuthkey"
#define LoginDictObjectkey @"LoginDictObjectkey"
#define LoginDictSELkey @"LoginDictSELkey"
#define AccountTypeWeibo @"Weibo"
#define SilenceLoginKey @"SilenceLogin"

enum RequestType
{
    RequestType_List,
    RequestType_content
};

enum LoginErrorCode
{
    ErrorCode_Unknown,
    ErrorCode_UserNamePassword,
};

@class ASIHTTPRequest;
@class ASINetworkQueue;

@interface WeiboLoginManager : NSObject
{
    NSDictionary* mLoginData;
    NSDictionary* mOAuthData;
    ASIHTTPRequest* asiRequest;
    ASINetworkQueue* mDownloadQueue;
    NSString* appKey;
    NSString* appSecret;
}

@property(retain)ASINetworkQueue* downloadQueue;
@property(retain)NSString* appKey;
@property(retain)NSString* appSecret;
@property(assign)BOOL hasLogined;
@property(assign)NSString* loginedAccount;
@property(assign)NSString* loginedID;
@property(retain)NSDictionary* oAuthData;

+ (id)getInstance;

-(void)startReloginWithTaskDict:(NSDictionary*)dict;
-(void)startLogin:(NSDictionary*)loginData;
-(void)startLogin:(NSDictionary*)loginData force:(BOOL)bForce;
-(void)startLogout;

@end
