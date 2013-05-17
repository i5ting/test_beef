//
//  WeiboFuncPuller.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WeiboFuncPuller.h"
#import "MyTool.h"
#import "UIDevice-Hardware.h"
#import "NSData+base64.h"
#import "WeiboLoginManager.h"
#import "ASIFormDataRequest.h"
#import "NewsObject.h"
#import "CommentDataList.h"
#import "ASINetworkQueue.h"
#import "JSONKit.h"
#import "RegValueSaver.h"
#import "LKTipCenter.h"
#import "MobClick.h"

NSString* WeiboDefaultGroupName = @"新闻订阅";
NSString* WeiboSavedGroupID = @"WeiboSavedGroupID";

NSString* HttpAPIV2_Publish = @"https://api.weibo.com/2/statuses/update.json";
NSString* HttpAPIV2_RepostWeibo = @"https://api.weibo.com/2/statuses/repost.json";
NSString* HttpAPIV2_CommentWeibo = @"https://api.weibo.com/2/comments/create.json";
NSString* HttpAPIV2_FavariteWeibo = @"https://api.weibo.com/2/favorites/create.json";
NSString* HttpAPIV2_CommentListWeibo = @"https://api.weibo.com/2/comments/show.json";
NSString* HttpAPIV2_ObtainGroupListWeibo = @"https://api.weibo.com/2/friendships/groups.json";
NSString* HttpAPIV2_CreateGroupWeibo = @"https://api.weibo.com/2/friendships/groups/create.json";
NSString* HttpAPIV2_GroupMembersWeibo = @"https://api.weibo.com/2/friendships/groups/members.json";
NSString* HttpAPIV2_CreateFriendshipWeibo = @"https://api.weibo.com/2/friendships/create.json";
NSString* HttpAPIV2_BatchCreateFriendshipWeibo = @"http://api.sina.com.cn/weibo/2/friendships/create_batch.json";
NSString* HttpAPIV2_AddGroupMemberWeibo = @"https://api.weibo.com/2/friendships/groups/members/add.json";
NSString* HttpAPIV2_UserInfoWeibo = @"https://api.weibo.com/2/users/show.json";
NSString* HttpAPIV2_ObtainWeibo = @"https://api.weibo.com/2/statuses/friends_timeline.json";
NSString* HttpAPIV2_ObtainGroupWeibo = @"https://api.weibo.com/2/friendships/groups/timeline.json";
NSString* HttpAPI_ColumnListDefaultWeibo = @"http://roll.news.sina.com.cn/api/weibo_subscribe/news_client_list.php";
NSString* HttpAPI_AddDefaultWeibo = @"http://roll.news.sina.com.cn/api/weibo_subscribe/news_client_add.php";
NSString* HttpAPI_RemoveDefaultWeibo = @"http://roll.news.sina.com.cn/api/weibo_subscribe/news_client_del.php";
NSString* HttpAPI_ContentListDefaultWeibo = @"http://topic.t.sina.com.cn/interface/api/news_client_feed";
NSString* HttpAPIV2_RemoveGroupMemberWeibo = @"https://api.weibo.com/2/friendships/groups/members/destroy.json";

NSString* HttpAPI_DefalutV2_GroupListWeibo = @"http://api.sina.com.cn/weibo/wb/get_friendships_groups.json";
NSString* HttpAPI_DefalutV2_ContentListWeibo = @"http://api.sina.com.cn/weibo/wb/get_friendships_groups_timeline.json";

@interface WeiboFuncPuller ()
@property(assign,readonly)NSDictionary* oAuthData;
@property (retain)NSString* loginedGroupID;
@property(retain)ASIHTTPRequest* requester;

-(NSMutableDictionary*)rawV2PublishWithRetOrder:(NSMutableArray*)orderArray status:(NSString*)aStatus;
-(void)afterObtainGroupListWeiboSuccessed:(NSDictionary*)jsonDict userRequst:(ASIHTTPRequest*)request;
-(NSString*)curDefaultWeiboID;
-(void)startContentListDefaultWeiboWithSender:(id)sender defaultID:(NSString*)mID count:(NSInteger)countPerPage page:(NSInteger)npage max_id:(NSString*)maxID lastID:(NSString*)lastID args:(NSArray*)args weiboList:(CommentDataList*)weiboList;
-(void)startAddDefaultWeiboWithSender:(id)sender defaultID:(NSString*)mID weiboID:(NSString*)weiboID nickName:(NSString*)nickName;
-(void)startRemoveDefaultWeiboWithSender:(id)sender defaultID:(NSString*)mID weiboID:(NSString*)weiboID;
-(void)startColumnListDefaultWeiboWithSender:(id)sender defaultID:(NSString*)mID args:(NSArray*)args dataList:(CommentDataList*)dataList;

-(void)addRequestToDowloadQueue:(ASIHTTPRequest*)request;
-(void)addRequestToOfflineQueue:(ASIHTTPRequest*)request;
-(void)startAPIRequest:(id)sender withAPICode:(NSArray*)codeArray pagename:(NSString*)pageName pagevalue:(NSInteger)pageValue countname:(NSString*)countName countvalue:(NSInteger)countValue args:(NSArray*)args stage:(NSInteger)stage otherUserInfo:(NSDictionary*)oUserInfo headerInfo:(NSDictionary*)headerDict inBack:(BOOL)bInBack;
-(void)startHttpAPIRequstByURL:(NSURL*)url headerDict:(NSDictionary*)headerDict userInfo:(NSDictionary*)info stage:(NSInteger)stageInt inBack:(BOOL)bInBack;
-(void)startHttpAPIRequestV2:(NSString*)method data:(NSDictionary*)dict order:(NSArray*)orderArray api:(NSString*)HttpAPI stage:(NSInteger)stageInteger userInfo:(NSDictionary*)userData headerDict:(NSDictionary*)headerDict bInback:(BOOL)bInback;
-(void)afterDefaultSuccessed:(NSDictionary*)jsonDict userRequst:(ASIHTTPRequest*)request dataname:(NSString*)dateName notifyName:(NSString*)notifyName;
-(void)afterDefaultSuccessed:(NSArray*)resultArray userRequst:(ASIHTTPRequest*)request notifyName:(NSString*)notifyName;
- (void)requestFailed:(ASIHTTPRequest *)request;
-(void)afterDefaultFailed:(ASIHTTPRequest*)request notifyName:(NSString*)notifyName;
-(void)sendNotificationWithName:(NSString*)nofityName stage:(NSInteger)stage info:(NSDictionary*)info;
-(void)mainThreadRunningNotification:(NSDictionary*)argInfo;
@end

@implementation WeiboFuncPuller
@synthesize oAuthData;
@synthesize downloadQueue=mDownloadQueue;
@synthesize loginedGroupID;
@synthesize requester;

+ (id)getInstance
{
    static WeiboFuncPuller* s_messageManager = nil;
	if (s_messageManager == nil)
	{
		//没有创建则创建
		s_messageManager = [[WeiboFuncPuller alloc] init];
        
	}
	return s_messageManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(ReLogin:)
                   name:ReLoginNotification 
                 object:nil];
        [nc addObserver:self selector:@selector(LoginedSuccessed:)
                   name:LoginSuccessedNotification 
                 object:nil];
        [nc addObserver:self selector:@selector(LoginFailed:)
                   name:LoginFailedNotification 
                 object:nil];
        [nc addObserver:self selector:@selector(LogoutSuccessed:)
                   name:LogoutSuccessedNotification 
                 object:nil];
        [nc addObserver:self selector:@selector(CommonWeiboSucceed:)
                   name:CommonWeiboSucceedNotification 
                 object:nil];
        [nc addObserver:self selector:@selector(CommonWeiboFailed:)
                   name:CommonWeiboFailedNotification 
                 object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mDownloadQueue release];
    [loginedGroupID release];
    [requester release];
    [super dealloc];
}

-(NSDictionary*)oAuthData
{
    return [[WeiboLoginManager getInstance] oAuthData];
}

-(void)ReLogin:(NSNotification*)notify
{
    NSDictionary* userInfo = [notify userInfo];
    [[WeiboLoginManager getInstance] startReloginWithTaskDict:userInfo];
}

-(void)LoginedSuccessed:(NSNotification*)notify
{
    self.loginedGroupID = nil;
}

-(void)LoginFailed:(NSNotification*)notify
{
    self.loginedGroupID = nil;
}

-(void)LogoutSuccessed:(NSNotification*)notify
{
    self.loginedGroupID = nil;
}

-(void)CommonWeiboSucceed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    if ([stageNumber intValue]==Stage_RequestV2_FavariteWeibo)
    {
        NSString* tipString = @"收藏微博成功了";
         [SVProgressHUD dismissWithSuccess:tipString afterDelay:1.0];
    }
    else if ([stageNumber intValue]==Stage_RequestV2_CommentWeibo)
    {
        NSString* tipString = @"评论微博成功了";
         [SVProgressHUD dismissWithSuccess:tipString afterDelay:1.0];
    }
    else if ([stageNumber intValue]==Stage_RequestV2_RepostWeibo)
    {
        NSString* tipString = @"转发微博成功了";
         [SVProgressHUD dismissWithSuccess:tipString afterDelay:1.0];
    }
    else if ([stageNumber intValue]==Stage_RequestV2_Publish)
    {
        NSString* tipString = @"发布微博成功了";
         [SVProgressHUD dismissWithSuccess:tipString afterDelay:1.0];
    }
     
}

-(void)CommonWeiboFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    NSNumber* errorNumber = [userInfo valueForKey:RequsetStage];
    if ([stageNumber intValue]==Stage_RequestV2_FavariteWeibo)
    {
        NSString* tipString = @"收藏微博失败了";
        [SVProgressHUD dismissWithError:tipString afterDelay:1.0];
        
    }
    else if ([stageNumber intValue]==Stage_RequestV2_CommentWeibo)
    {
        NSString* tipString = @"评论微博失败了";
        [SVProgressHUD dismissWithError:tipString afterDelay:1.0];
    }
    else if ([stageNumber intValue]==Stage_RequestV2_RepostWeibo)
    {
        NSString* tipString = @"转发微博失败了";
        [SVProgressHUD dismissWithError:tipString afterDelay:1.0];
    }
    else if ([stageNumber intValue]==Stage_RequestV2_Publish)
    {
        NSString* tipString = @"发布微博失败了";
        [SVProgressHUD dismissWithError:tipString afterDelay:1.0];
    }
}

-(void)startPublishV2:(NSString*)aStatus
{
    if (aStatus!=nil) {
        NSString* httpAPI = HttpAPIV2_Publish;
        NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableDictionary* dict = [self rawV2PublishWithRetOrder:orderArray status:aStatus];
        NSMutableDictionary* userdict = [NSMutableDictionary dictionaryWithCapacity:0];
        [userdict setValue:[NSDate date] forKey:RequsetDate];
        [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_RequestV2_Publish userInfo:userdict headerDict:nil bInback:NO];
    }
}

-(NSMutableDictionary*)rawV2PublishWithRetOrder:(NSMutableArray*)orderArray status:(NSString*)aStatus
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    if (aStatus) {
        NSString* idKey = @"status";
        [dict setObject:aStatus forKey:idKey];
        [orderArray addObject:idKey];
    }
    return dict;
}

-(void)startRepostV2WeiboWithID:(NSString*)mID content:(NSString*)aText
{
    NSString* httpAPI = HttpAPIV2_RepostWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    if (mID) {
        NSString* idKey = @"id";
        [dict setObject:mID forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (aText) {
        NSString* idKey = @"status";
        [dict setObject:aText forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_RequestV2_RepostWeibo userInfo:nil headerDict:nil bInback:NO];
}

-(void)startCommentV2WeiboWithID:(NSString*)mID content:(NSString*)aText
{
    NSString* httpAPI = HttpAPIV2_CommentWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    if (mID) {
        NSString* idKey = @"id";
        [dict setObject:mID forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (aText) {
        NSString* idKey = @"comment";
        [dict setObject:aText forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_RequestV2_CommentWeibo userInfo:nil headerDict:nil bInback:NO];
}

-(void)startFavariteWeiboV2WithID:(NSString*)mID
{
    NSString* httpAPI = HttpAPIV2_FavariteWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    if (mID) {
        NSString* idKey = @"id";
        [dict setObject:mID forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_RequestV2_FavariteWeibo userInfo:nil headerDict:nil bInback:NO];
}

-(void)startV2ObtainGroupListWithSender:(id)sender args:(NSArray*)args
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSString* httpAPI = HttpAPIV2_ObtainGroupListWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    NSMutableDictionary* userdict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (sender) {
        [userdict setValue:sender forKey:RequsetSender];
    }
    if (args) {
        [userdict setValue:args forKey:RequsetArgs];
    }
    [userdict setValue:[NSDate date] forKey:RequsetDate];
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_RequestV2_ObtainGroupListWeibo userInfo:userdict headerDict:nil bInback:NO];
}

-(void)afterObtainGroupListWeiboSuccessed:(NSDictionary*)jsonDict userRequst:(ASIHTTPRequest*)request
{
    NSArray* lists = [jsonDict objectForKey:@"lists"];
    NSMutableArray* weiboArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSDictionary* oneList in lists) {
        NewsObject* oneObject = [[NewsObject alloc] initWithJsonDictionary:oneList];
        [weiboArray addObject:oneObject];
        [oneObject release];
        NSString* dataName = [oneList objectForKey:@"name"];
        if ([dataName isEqualToString:WeiboDefaultGroupName]) {
            NSString* idStr = [oneList objectForKey:@"idstr"];
            self.loginedGroupID = idStr;
            NSString* userID = [self.oAuthData objectForKey:LoginReturnKey_User_id];
            [[RegValueSaver getInstance] saveUserInfoValue:idStr forKey:WeiboSavedGroupID userID:userID accountType:AccountTypeWeibo encryptString:NO];
        }
    }
    
    [self afterDefaultSuccessed:weiboArray userRequst:request notifyName:CommonWeiboSucceedNotification];
    [weiboArray release];
}

-(void)startV2ObtainWithSender:(id)sender groupID:(NSString*)gID count:(NSInteger)count page:(NSInteger)npage max_id:(NSString*)maxID lastID:(NSString*)lastID args:(NSArray*)args weiboList:(CommentDataList*)weiboList
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSMutableDictionary* userdict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* httpAPI = HttpAPIV2_ObtainWeibo;
    if (gID) {
        httpAPI = HttpAPIV2_ObtainGroupWeibo;
    }
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (gID) {
        NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
        if (token) {
            [dict setObject:token forKey:OAUTH2_TOKEN];
            [orderArray addObject:OAUTH2_TOKEN];
        }
    }
    else
    {
        NSString* aKey = [[WeiboLoginManager getInstance] appKey];
        [dict setObject:aKey forKey:OAUTH2_Source];
        [orderArray addObject:OAUTH2_Source];
    }
    
    
    if (gID) {
        NSString* idKey = @"list_id";
        [dict setObject:gID forKey:idKey];
        [orderArray addObject:idKey];
    }
    if (maxID) {
        NSString* idKey = @"max_id";
        [dict setObject:maxID forKey:idKey];
        [orderArray addObject:idKey];
        count++;
        [userdict setValue:[NSNumber numberWithBool:YES] forKey:RequsetRemoveFirst];
    }
    else
    {
        if (npage>1) {
            NSString* idKey = @"page";
            [dict setObject:[NSString stringWithFormat:@"%d",npage] forKey:idKey];
            [orderArray addObject:idKey];
        }
    }
    if (count>0) {
        NSString* countKey = @"count";
        [dict setObject:[NSString stringWithFormat:@"%d",count] forKey:countKey];
        [orderArray addObject:countKey];
    }
    
    if (gID) {
        [userdict setObject:gID forKey:@"groupid"];
    }
    if (sender) {
        [userdict setValue:sender forKey:RequsetSender];
    }
    [userdict setValue:[NSDate date] forKey:RequsetDate];
    if (args) {
        [userdict setObject:args forKey:RequsetArgs];
    }
    [userdict setObject:[NSNumber numberWithInt:npage] forKey:RequsetPage];
    if (weiboList) {
        [userdict setObject:weiboList forKey:RequsetDataList];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_V2ObtainWeibo userInfo:userdict headerDict:nil bInback:NO];
}

-(void)startCommentListV2WeiboWithSender:(id)sender ID:(NSString*)mID count:(NSInteger)countPerPage page:(NSInteger)npage max_id:(NSString*)maxID args:(NSArray*)args dataList:(CommentDataList*)dataList
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPIV2_CommentListWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    if (mID) {
        NSString* idKey = @"id";
        [dict setObject:mID forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (maxID) {
        NSString* idKey = @"max_id";
        [dict setObject:maxID forKey:idKey];
        [orderArray addObject:idKey];
        countPerPage += 1;
        [userDict setObject:[NSNumber numberWithBool:YES] forKey:RequsetRemoveFirst];
    }
    
    if (countPerPage>0) {
        NSString* idKey = @"count";
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_RequestV2_CommentListWeibo userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startCreateDefaultNewsGroupWeiboWithSender:(id)sender
{
    [self startCreateGroupWeiboWithSender:sender groupName:WeiboDefaultGroupName];
}

-(void)startCreateGroupWeiboWithSender:(id)sender groupName:(NSString*)groupName
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSString* httpAPI = HttpAPIV2_CreateGroupWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    if (groupName) {
        NSString* idString = @"name";
        [dict setObject:groupName forKey:idString];
        [orderArray addObject:idString];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [headerDict setValue:@"http://www.sina.com.cn" forKey:@"Referer"];
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_Request_V2CreateGroupWeibo userInfo:userDict headerDict:headerDict bInback:NO];
    [headerDict release];
}

-(void)startGroupMembersWeiboWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)npage cursor:(NSString*)cursor args:(NSArray*)args dataList:(CommentDataList*)dataList
{
    if (!loginedGroupID) {
        NSString* userID = [self.oAuthData objectForKey:LoginReturnKey_User_id];
        self.loginedGroupID = [[RegValueSaver getInstance] readUserInfoForKey:WeiboSavedGroupID userID:userID accountType:AccountTypeWeibo];
    }
    
    if (!self.loginedGroupID) {
        [self startV2ObtainGroupListWithSender:sender];
    }
    else
    {
        [self startGroupMembersWeiboWithSender:sender userID:self.loginedGroupID count:countPerPage page:npage cursor:cursor args:args dataList:dataList];
    }
}

-(void)startGroupMembersWeiboWithSender:(id)sender userID:(NSString*)userID count:(NSInteger)countPerPage page:(NSInteger)npage cursor:(NSString*)cursor args:(NSArray*)args dataList:(CommentDataList*)dataList
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPIV2_GroupMembersWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    if (userID) {
        NSString* idString = @"list_id";
        [dict setObject:userID forKey:idString];
        [orderArray addObject:idString];
    }
    
    //    if (cursor) {
    //        NSString* idString = @"cursor";
    //        [dict setObject:cursor forKey:idString];
    //        [orderArray addObject:idString];
    //    }
    if (YES) {
        NSString* idString = @"page";
        [dict setObject:[NSString stringWithFormat:@"%d",npage] forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (countPerPage>0) {
        NSString* idKey = @"count";
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
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_V2GroupMembersWeibo userInfo:userDict headerDict:nil bInback:NO];
}

-(void)startCreateFriendshipWeiboWithSender:(id)sender uid:(NSString*)uid username:(NSString*)username
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPIV2_CreateFriendshipWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    if (uid) {
        NSString* idString = @"uid";
        [dict setObject:uid forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (username) {
        NSString* idString = @"screen_name";
        [dict setObject:username forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [headerDict setValue:@"http://www.sina.com.cn" forKey:@"Referer"];
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_Request_V2CreateFriendshipWeibo userInfo:userDict headerDict:headerDict bInback:NO];
    [headerDict release];
}

-(void)startBatchCreateFriendshipWeiboWithSender:(id)sender uids:(NSArray*)uids
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPIV2_BatchCreateFriendshipWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    if (uids) {
        NSString* idString = @"uids";
        NSString* uidsString = [uids componentsJoinedByString:@","];
        [dict setObject:uidsString forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [headerDict setValue:@"http://www.sina.com.cn" forKey:@"Referer"];
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_Request_V2BatchCreateFriendshipWeibo userInfo:userDict headerDict:headerDict bInback:NO];
    [headerDict release];
}

-(void)startUserInfoWeiboWithSender:(id)sender uid:(NSString*)uid username:(NSString*)username info:(id)info
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPIV2_UserInfoWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    if (uid) {
        NSString* idString = @"uid";
        [dict setObject:uid forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (username) {
        NSString* idString = @"screen_name";
        [dict setObject:username forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    NSMutableDictionary* curArgDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (username) {
        [curArgDict setValue:username forKey:@"username"];
    }
    if (uid) {
        [curArgDict setValue:uid forKey:@"uid"];
    }
    [userDict setValue:curArgDict forKey:RequsetCurArgs];
    [curArgDict release];
    if (info) {
        [userDict setValue:info forKey:RequsetInfo];
    }
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [headerDict setValue:@"http://www.sina.com.cn" forKey:@"Referer"];
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_V2UserInfoWeibo userInfo:userDict headerDict:headerDict bInback:NO];
    [headerDict release];
}


-(void)startUserInfoWeiboWithSender2:(id)sender uid:(NSString*)uid username:(NSString*)username info:(id)info  image:(NSData *)img
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPIV2_UserInfoWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    if (uid) {
        NSString* idString = @"uid";
        [dict setObject:uid forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (username) {
        NSString* idString = @"screen_name";
        [dict setObject:username forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    NSMutableDictionary* curArgDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (username) {
        [curArgDict setValue:username forKey:@"username"];
    }
    if (uid) {
        [curArgDict setValue:uid forKey:@"uid"];
    }
    [userDict setValue:curArgDict forKey:RequsetCurArgs];
    [curArgDict release];
    if (info) {
        [userDict setValue:info forKey:RequsetInfo];
    }
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [headerDict setValue:@"http://www.sina.com.cn" forKey:@"Referer"];
    
    if (img) {
        NSString* picString = @"pic";
        [dict setObject:img forKey:picString];
        [orderArray addObject:picString];
    }
    
    [dict setObject:@"ddd" forKey:@"status"];
    //add v.2.4.0.56
    [self startHttpAPIRequestV2WithPng:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_RequestV2_Publish userInfo:userDict headerDict:headerDict bInback:NO];
    [headerDict release];
}

-(void)startAddGroupMemberWeiboWithSender:(id)sender userid:(NSString*)userid
{
    [self startAddGroupMemberWeiboWithSender:sender userid:userid groupid:self.loginedGroupID];
}

-(void)startAddGroupMemberWeiboWithSender:(id)sender userid:(NSString*)userid groupid:(NSString*)groupid
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPIV2_AddGroupMemberWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    if (userid) {
        NSString* idString = @"uid";
        [dict setObject:userid forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (groupid) {
        NSString* idString = @"list_id";
        [dict setObject:groupid forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [headerDict setValue:@"http://www.sina.com.cn" forKey:@"Referer"];
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_Request_V2AddGroupMemberWeibo userInfo:userDict headerDict:headerDict bInback:NO];
    [headerDict release];
}

-(NSArray*)curWeiboIDListWithLogined:(BOOL)logined
{
    NSMutableArray* rtval = [NSMutableArray arrayWithCapacity:0];
    if (logined) {
        NSString* userID = [self.oAuthData objectForKey:LoginReturnKey_User_id];
        if (!loginedGroupID) {
            self.loginedGroupID = [[RegValueSaver getInstance] readUserInfoForKey:WeiboSavedGroupID userID:userID accountType:AccountTypeWeibo];
        }
        if (self.loginedGroupID&&userID) {
            [rtval addObject:userID];
            [rtval addObject:self.loginedGroupID];
        }
    }
    else
    {
        NSString* defaultID = [self curDefaultWeiboID];
        [rtval addObject:defaultID];
        [rtval addObject:@"id2"];
    }
    
    return rtval;
}


-(void)startRemoveGroupMemberWeiboWithSender:(id)sender userid:(NSString*)userid groupid:(NSString*)groupid
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPIV2_RemoveGroupMemberWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
    if (token) {
        [dict setObject:token forKey:OAUTH2_TOKEN];
        [orderArray addObject:OAUTH2_TOKEN];
    }
    
    if (userid) {
        NSString* idString = @"uid";
        [dict setObject:userid forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (groupid) {
        NSString* idString = @"list_id";
        [dict setObject:groupid forKey:idString];
        [orderArray addObject:idString];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    NSMutableArray* args = [[NSMutableArray alloc] initWithCapacity:0];
    [args addObject:groupid];
    [args addObject:userid];
    [userDict setObject:args forKey:RequsetArgs];
    [args release];
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [headerDict setValue:@"http://www.sina.com.cn" forKey:@"Referer"];
    [self startHttpAPIRequestV2:@"POST" data:dict order:orderArray api:httpAPI stage:Stage_Request_V2RemoveGroupMemberWeibo userInfo:userDict headerDict:headerDict bInback:NO];
    [headerDict release];
}
-(void)startRemoveGroupMemberWeiboWithSender:(id)sender userid:(NSString*)userid
{
    [self startRemoveGroupMemberWeiboWithSender:sender userid:userid groupid:self.loginedGroupID];
}

-(NSString*)curDefaultWeiboID
{
    NSString* rtval = nil;
    static NSString* curweiboID = nil;
    if (!curweiboID) {
        rtval = [[UIDevice currentDevice] macaddress];
        rtval = [MyTool MD5DigestFromString:rtval];
        curweiboID = rtval;
    }
    return rtval;
}

-(void)startAddDefaultWeiboWithSender:(id)sender weiboID:(NSString*)weiboID nickName:(NSString*)nickName
{
    [self startAddDefaultWeiboWithSender:sender defaultID:[self curDefaultWeiboID] weiboID:weiboID nickName:nickName];
}
-(void)startRemoveDefaultWeiboWithSender:(id)sender weiboID:(NSString*)weiboID
{
    [self startRemoveDefaultWeiboWithSender:sender defaultID:[self curDefaultWeiboID] weiboID:weiboID];
}
-(void)startColumnListDefaultWeiboWithSender:(id)sender args:(NSArray*)args dataList:(CommentDataList*)dataList
{
    [self startColumnListDefaultWeiboWithSender:sender defaultID:[self curDefaultWeiboID] args:args dataList:dataList];
}
-(void)startContentListDefaultWeiboWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)npage max_id:(NSString*)maxID lastID:(NSString*)lastID args:(NSArray*)args weiboList:(CommentDataList*)weiboList
{
    [self startContentListDefaultWeiboWithSender:sender defaultID:[self curDefaultWeiboID] count:countPerPage page:npage max_id:maxID lastID:lastID args:args weiboList:weiboList];
}

-(void)startAddDefaultWeiboWithSender:(id)sender defaultID:(NSString*)mID weiboID:(NSString*)weiboID nickName:(NSString*)nickName
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    
    NSString* urlStr = [NSString stringWithFormat:@"%@?uid=%@",HttpAPI_AddDefaultWeibo,mID];
    
    if (weiboID) {
        urlStr = [urlStr stringByAppendingFormat:@"&wb_id=%@",weiboID];
    }
    if (nickName) {
        urlStr = [urlStr stringByAppendingFormat:@"&wb_nickname=%@",[nickName rawUrlEncode]];
    }
    
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (YES) {
        [headerDict setValue:@"no-cache" forKey:@"cache_control"];
        [headerDict setValue:@"no-cache" forKey:@"Pragma"];
    }
    
    NSArray* apiCode = [NSArray arrayWithObjects:urlStr,nil];
    
    [self startAPIRequest:sender withAPICode:apiCode pagename:nil pagevalue:0 countname:nil countvalue:0 args:nil stage:Stage_Request_AddDefaultWeibo otherUserInfo:nil headerInfo:headerDict inBack:NO];
    [headerDict release];
}

-(void)startRemoveDefaultWeiboWithSender:(id)sender defaultID:(NSString*)mID weiboID:(NSString*)weiboID
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSString* urlStr = nil;
    urlStr = [NSString stringWithFormat:@"%@?uid=%@&wb_id=%@",HttpAPI_RemoveDefaultWeibo,mID,weiboID];
    
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (YES) {
        [headerDict setValue:@"no-cache" forKey:@"cache_control"];
        [headerDict setValue:@"no-cache" forKey:@"Pragma"];
    }
    
    NSArray* apiCode = [NSArray arrayWithObjects:urlStr,nil];
    
    [self startAPIRequest:sender withAPICode:apiCode pagename:nil pagevalue:0 countname:nil countvalue:0 args:nil stage:Stage_Request_RemoveDefaultWeibo otherUserInfo:nil headerInfo:headerDict inBack:NO];
    [headerDict release];
}

-(void)startColumnListDefaultWeiboWithSender:(id)sender defaultID:(NSString*)mID args:(NSArray*)args dataList:(CommentDataList*)dataList
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSString* urlStr = nil;
    urlStr = [NSString stringWithFormat:@"%@?uid=%@",HttpAPI_ColumnListDefaultWeibo,mID];
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (YES) {
        [headerDict setValue:@"no-cache" forKey:@"cache_control"];
        [headerDict setValue:@"no-cache" forKey:@"Pragma"];
    }
    
    NSArray* apiCode = [NSArray arrayWithObjects:urlStr,nil];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setValue:dataList forKey:RequsetDataList];
    [dict setValue:args forKey:RequsetArgs];
    [self startAPIRequest:sender withAPICode:apiCode pagename:nil pagevalue:0 countname:nil countvalue:1 args:args stage:Stage_Request_ColumnListDefaultWeibo otherUserInfo:dict headerInfo:headerDict inBack:NO];
    [dict release];
    [headerDict release];
}

-(void)afterColumnListDefaultWeiboSuccessed:(NSArray*)jsonDict userRequst:(ASIHTTPRequest*)request
{
    NSDictionary* info = request.userInfo;
    NSArray* lists = jsonDict;
    NSMutableArray* weiboArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (NSDictionary* dict in lists) {
        NSMutableDictionary* newDict = [[NSMutableDictionary alloc] initWithCapacity:4];
        [newDict setValue:[dict valueForKey:@"nickname"] forKey:WeiboUserObject_name];
        [newDict setValue:[dict valueForKey:@"nickname"] forKey:WeiboUserObject_screen_name];
        [newDict setValue:[dict valueForKey:@"uid"] forKey:WeiboUserObject_idstr];
        [newDict setValue:[dict valueForKey:@"uid"] forKey:WeiboUserObject_id];
        [newDict setValue:[dict valueForKey:@"isdefalut"] forKey:@"isdefault"];
        NewsObject* newObject = [[NewsObject alloc] initWithJsonDictionary:newDict];
        [newDict release];
        [weiboArray addObject:newObject];
        [newObject release];
    }
    
    NSArray* args = [info objectForKey:RequsetArgs];
    CommentDataList* dataList = [info objectForKey:RequsetDataList];
    if (dataList&&args) {
        [dataList refreshCommnetContents:weiboArray IDList:args];
    }
    
    [self afterDefaultSuccessed:weiboArray userRequst:request notifyName:CommonWeiboSucceedNotification];
    [weiboArray release];
}

-(void)startContentListDefaultWeiboWithSender:(id)sender defaultID:(NSString*)mID count:(NSInteger)countPerPage page:(NSInteger)npage max_id:(NSString*)maxID lastID:(NSString*)lastID args:(NSArray*)args weiboList:(CommentDataList*)weiboList
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_ContentListDefaultWeibo;
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (mID) {
        NSString* idKey = @"id";
        [dict setObject:mID forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (maxID) {
        NSString* idKey = @"max_id";
        [dict setObject:maxID forKey:idKey];
        [orderArray addObject:idKey];
        countPerPage += 1;
        [userDict setObject:[NSNumber numberWithBool:YES] forKey:RequsetRemoveFirst];
    }
    else
    {
        NSString* idKey = @"page";
        [dict setObject:[NSString stringWithFormat:@"%d",npage] forKey:idKey];
        [orderArray addObject:idKey];
        if (lastID) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
            formatter.dateFormat = @"EEE MMM dd HH:mm:ss z yyyy";
            NSDate* newFormatDate = [formatter dateFromString:lastID];
            //NSDate* newFormatDate = [ASIHTTPRequest dateFromRFC1123String:createDateStr];
            
            if (newFormatDate) {
                [userDict setObject:newFormatDate forKey:RequsetLastDate];
                [userDict setObject:WeiboObject_CreateDate forKey:RequsetDateKey];
                [userDict setObject:formatter forKey:RequsetDateFormatter];
            }
            [formatter release];
        }
    }
    
    if (countPerPage>0) {
        NSString* idKey = @"count";
        [dict setObject:[NSString stringWithFormat:@"%d",countPerPage] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (YES) {
        [headerDict setValue:@"no-cache" forKey:@"cache_control"];
        [headerDict setValue:@"no-cache" forKey:@"Pragma"];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setObject:[NSString stringWithFormat:@"%d",npage] forKey:RequsetPage];
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    if (args) {
        [userDict setValue:args forKey:RequsetArgs];
    }
    if (weiboList) {
        [userDict setObject:weiboList forKey:RequsetDataList];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_ContentListDefaultWeibo userInfo:userDict headerDict:headerDict  bInback:NO];
    [headerDict release];
}

-(void)startDefaultV2GroupListWithSender:(id)sender args:(NSArray*)args dataList:(CommentDataList*)dataList
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    NSString* urlStr = nil;
    urlStr = [NSString stringWithFormat:@"%@?user=finance",HttpAPI_DefalutV2_GroupListWeibo];
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (YES) {
        [headerDict setValue:@"no-cache" forKey:@"cache_control"];
        [headerDict setValue:@"no-cache" forKey:@"Pragma"];
    }
    
    NSArray* apiCode = [NSArray arrayWithObjects:urlStr,nil];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setValue:dataList forKey:RequsetDataList];
    [dict setValue:args forKey:RequsetArgs];
    [self startAPIRequest:sender withAPICode:apiCode pagename:nil pagevalue:0 countname:nil countvalue:1 args:nil stage:Stage_Request_DefalutV2_GroupListWeibo otherUserInfo:dict headerInfo:headerDict inBack:NO];
    [dict release];
    [headerDict release];
}

-(void)startContentListDefault2WeiboWithSender:(id)sender groupID:(NSString*)gID count:(NSInteger)countPerPage page:(NSInteger)npage max_id:(NSString*)maxID lastID:(NSString*)lastID args:(NSArray*)args weiboList:(CommentDataList*)weiboList
{
    if (sender) {
        sender = [NSNumber numberWithInt:((int)sender)];
    }
    if (args) {
        args = [NSArray arrayWithArray:args];
    }
    NSMutableDictionary* userDict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSString* httpAPI = HttpAPI_DefalutV2_ContentListWeibo;
    httpAPI = [httpAPI stringByAppendingString:@"?user=finance"];
    NSMutableArray* orderArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (gID) {
        NSString* idKey = @"list_id";
        [dict setObject:gID forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    if (maxID) {
        NSString* idKey = @"max_id";
        [dict setObject:maxID forKey:idKey];
        [orderArray addObject:idKey];
        countPerPage += 1;
        [userDict setObject:[NSNumber numberWithBool:YES] forKey:RequsetRemoveFirst];
    }
    else
    {
        NSString* idKey = @"page";
        [dict setObject:[NSString stringWithFormat:@"%d",npage] forKey:idKey];
        [orderArray addObject:idKey];
        if (lastID) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
            formatter.dateFormat = @"EEE MMM dd HH:mm:ss z yyyy";
            NSDate* newFormatDate = [formatter dateFromString:lastID];
            //NSDate* newFormatDate = [ASIHTTPRequest dateFromRFC1123String:createDateStr];
            
            if (newFormatDate) {
                [userDict setObject:newFormatDate forKey:RequsetLastDate];
                [userDict setObject:WeiboObject_CreateDate forKey:RequsetDateKey];
                [userDict setObject:formatter forKey:RequsetDateFormatter];
            }
            [formatter release];
        }
    }
    
    if (countPerPage>0) {
        NSString* idKey = @"count";
        [dict setObject:[NSString stringWithFormat:@"%d",countPerPage] forKey:idKey];
        [orderArray addObject:idKey];
    }
    
    NSMutableDictionary* headerDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (YES) {
        [headerDict setValue:@"no-cache" forKey:@"cache_control"];
        [headerDict setValue:@"no-cache" forKey:@"Pragma"];
    }
    
    if (sender) {
        [userDict setObject:sender forKey:RequsetSender];
    }
    [userDict setObject:[NSString stringWithFormat:@"%d",npage] forKey:RequsetPage];
    [userDict setValue:[NSDate date] forKey:RequsetDate];
    if (args) {
        [userDict setValue:args forKey:RequsetArgs];
    }
    if (weiboList) {
        [userDict setObject:weiboList forKey:RequsetDataList];
    }
    
    [self startHttpAPIRequestV2:@"GET" data:dict order:orderArray api:httpAPI stage:Stage_Request_DefalutV2_ContentListWeibo userInfo:userDict headerDict:headerDict  bInback:NO];
    [headerDict release];
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


-(void)startHttpAPIRequestV2WithPng:(NSString*)method data:(NSDictionary*)dict order:(NSArray*)orderArray api:(NSString*)HttpAPI stage:(NSInteger)stageInteger userInfo:(NSDictionary*)userData headerDict:(NSDictionary*)headerDict bInback:(BOOL)bInback
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
    
     
    NSString* HttpAPIV2_PublishPng = @"https://api.weibo.com/2/statuses/upload.json";
    NSURL *url = [NSURL URLWithString:HttpAPIV2_PublishPng];
    
//    ASIFormDataRequest* request = [[[ASIFormDataRequest alloc] initWithURL :url] autorelease];
    ASIFormDataRequest* request = [[[ASIFormDataRequest alloc] initWithURL :url] autorelease];
//    if (stageInteger==Stage_RequestV2_Publish) {
        if ([dict valueForKey:@"pic"]) {
            request.postFormat = ASIMultipartFormDataPostFormat;
        }
//    }
    
    [request addPostValue:[userData objectForKey:RequsetInfo] forKey:@"status"];
    [request setData:[dict objectForKey:@"pic"] withFileName:@"auth_header.png"andContentType:@"image/png"forKey:@"pic"];
    
    request.tag = stageInteger;
    request.userInfo = userData;
    if ([[method uppercaseString] isEqualToString:@"POST"]) {
        [request setRequestMethod:@"POST"];
        for (NSString* onekey in orderArray) {
            NSString* oneValue = [dict objectForKey:onekey];
            if ([oneValue isKindOfClass:[NSData class]]) {
                [request addData:(NSData*)oneValue forKey:onekey];
            }
            else {
                [request setPostValue:oneValue forKey:onekey];
            }
            
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
    
//    [request startAsynchronous];
    
    [self initalDownloadQueue];
    [self.downloadQueue addOperation:request];
    [self.downloadQueue go];
    
}

-(void)addRequestToOfflineQueue:(ASIHTTPRequest*)request
{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag==Stage_RequestV2_Publish)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        NSDictionary* jsonDict = [resultString objectFromJSONString];
//        NSTestLog(@"weibo fun requestFinished jsondict= %@",jsonDict);
        
//        NSString *s = [NSString stringWithString:@"{ quantity = 3,type = book}"];

        
        
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* errorCode = [jsonDict objectForKey:@"error_code"];
            NSString* errorMsg =[jsonDict objectForKey:@"error"];
        
            if (!errorCode) {
                [self afterDefaultSuccessed:nil userRequst:request notifyName:CommonWeiboSucceedNotification];
            }
            else {
                NSString* token = [self.oAuthData objectForKey:LoginReturnKeyV2_Token];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%@:%@-%@",errorCode,errorMsg,token],@"error_code", nil];
                [MobClick startWithAppkey:UMENG_KEY reportPolicy:REALTIME channelId:nil];
                [MobClick event:@"weibo_ret_code" attributes:dict];
                
                
                if([errorCode intValue]==20003||[errorCode intValue]==20603)
                {
                    NSMutableDictionary* info = (NSMutableDictionary*)request.userInfo;
                    [info setObject:[NSNumber numberWithInt:RequestError_User_Not_Exists] forKey:RequsetError];
                }
                
                //TODO:重复内容提示
                if ([errorCode intValue] == 20019) {
                    NSMutableDictionary* info = (NSMutableDictionary*)request.userInfo;
                    [info setObject:[NSNumber numberWithInt:RequestError_repeat_content] forKey:RequsetError];
                }
                [self requestFailed:request];
            }
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
        [resultString release];
    }
    else if(request.tag==Stage_RequestV2_RepostWeibo)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            [self afterDefaultSuccessed:nil userRequst:request notifyName:CommonWeiboSucceedNotification];
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
        [resultString release];
    }
    else if(request.tag==Stage_RequestV2_CommentWeibo)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            [self afterDefaultSuccessed:nil userRequst:request notifyName:CommonWeiboSucceedNotification];
        }
        else
        {
             [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
        [resultString release];
    }
    else if(request.tag==Stage_RequestV2_FavariteWeibo)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            [self afterDefaultSuccessed:nil userRequst:request notifyName:CommonWeiboSucceedNotification];
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
        [resultString release];
    }
    else if(request.tag==Stage_RequestV2_ObtainGroupListWeibo)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* errorCode = [jsonDict valueForKey:@"error_code"];
            if (!errorCode) {
                NSNumber* totalNumber = [jsonDict valueForKey:@"total_number"];
                NSArray* lists = [jsonDict valueForKey:@"lists"];
                if (lists&&totalNumber) {
                    if ([lists count]==[totalNumber intValue]) {
                        [self afterObtainGroupListWeiboSuccessed:jsonDict userRequst:request];
                    }
                    else
                    {
                        NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
                        [userInfo setValue:[NSNumber numberWithInt:RequestError_Account_Not_Open] forKey:RequsetError];
                        [self requestFailed:request];
                    }
                }
                else {
                    [self requestFailed:request];
                }
            }
            else {
                [self requestFailed:request];
            }
        }
        else
        {
            [self requestFailed:request];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_V2ObtainWeibo)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* errorCode = [jsonDict valueForKey:@"error_code"];
            if (!errorCode) {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:@"statuses" notifyName:CommonWeiboSucceedNotification];
            }
            else if([errorCode intValue]==20003||[errorCode intValue]==20603)
            {
                NSMutableDictionary* info = (NSMutableDictionary*)request.userInfo;
                [info setObject:[NSNumber numberWithInt:RequestError_User_Not_Exists] forKey:RequsetError];
                
                [self afterDefaultSuccessed:nil userRequst:request dataname:@"statuses" notifyName:CommonWeiboSucceedNotification];
            }
            else
            {
                [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
            }
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
        [resultString release];
    }
    else if(request.tag==Stage_RequestV2_CommentListWeibo)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            [self afterDefaultSuccessed:jsonDict userRequst:request dataname:@"comments" notifyName:CommonWeiboSucceedNotification];
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_V2CreateGroupWeibo)
    {
        NSString* resultString = request.responseString;
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]])
        {
            NSString* error_code = [jsonDict valueForKey:@"error_code"];
            if (!error_code||[error_code intValue]==20608) {
                NewsObject* newsObject = [[NewsObject alloc] initWithJsonDictionary:jsonDict];
                NSMutableArray* resultArray = [[NSMutableArray alloc] initWithObjects:newsObject, nil];
                
                NSString* dataName = [newsObject valueForKey:WeiboUserObject_name];
                if ([dataName isEqualToString:WeiboDefaultGroupName]) {
                    NSString* idStr = [newsObject valueForKey:WeiboUserObject_idstr];
                    self.loginedGroupID = idStr;
                    NSString* userID = [self.oAuthData objectForKey:LoginReturnKey_User_id];
                    [[RegValueSaver getInstance] saveUserInfoValue:idStr forKey:WeiboSavedGroupID userID:userID accountType:AccountTypeWeibo encryptString:NO];
                }
                
                [self afterDefaultSuccessed:resultArray userRequst:request notifyName:CommonWeiboSucceedNotification];
                [resultArray release];
                [newsObject release];
            }
            else {
                [self requestFailed:request];
            }
        }
        else
        {
            [self requestFailed:request];
        }
    }
    else if(request.tag==Stage_Request_V2GroupMembersWeibo)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            [self afterDefaultSuccessed:jsonDict userRequst:request dataname:@"users" notifyName:CommonWeiboSucceedNotification];
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_V2CreateFriendshipWeibo)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* errorCode = [jsonDict objectForKey:@"error_code"];
            if(!errorCode)
            {
                NewsObject* newsObject = [[NewsObject alloc] initWithJsonDictionary:jsonDict];
                NSArray* newsArray = [[NSArray alloc] initWithObjects:newsObject, nil];
                [self afterDefaultSuccessed:newsArray userRequst:request notifyName:CommonWeiboSucceedNotification];
                [newsObject release];
                [newsArray release];
            }
            else if([errorCode intValue]==20506)
            {
                [self afterDefaultSuccessed:nil userRequst:request notifyName:CommonWeiboSucceedNotification];
            }
            else
            {
                [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
            }
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_V2BatchCreateFriendshipWeibo)
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
                [self afterDefaultSuccessed:nil userRequst:request notifyName:CommonWeiboSucceedNotification];
            }
            else
            {
                [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
            }
            
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
    }
    else if(request.tag==Stage_Request_V2UserInfoWeibo)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* errorCode = [jsonDict objectForKey:@"error_code"];
            if(!errorCode)
            {
                NewsObject* newsObject = [[NewsObject alloc] initWithJsonDictionary:jsonDict];
                NSArray* newsArray = [[NSArray alloc] initWithObjects:newsObject, nil];
                [self afterDefaultSuccessed:newsArray userRequst:request notifyName:CommonWeiboSucceedNotification];
                [newsObject release];
                [newsArray release];
            }
            else if([errorCode intValue]==20003||[errorCode intValue]==20603)
            {
                NSMutableDictionary* info = (NSMutableDictionary*)request.userInfo;
                [info setObject:[NSNumber numberWithInt:RequestError_User_Not_Exists] forKey:RequsetError];
                
                [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
            }
            else
            {
                [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
            }
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_V2AddGroupMemberWeibo||request.tag==Stage_Request_V2RemoveGroupMemberWeibo)
    {
        NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSNumber* errorCode = [jsonDict objectForKey:@"error_code"];
            if(!errorCode)
            {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:@"users" notifyName:CommonWeiboSucceedNotification];
            }
            else
            {
                [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
            }
            
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
        [resultString release];
    }
    else if(request.tag==Stage_Request_AddDefaultWeibo)
    {
        NSString* resultString = request.responseString;
        if ([resultString isEqualToString:@"1"]) {
            [self afterDefaultSuccessed:nil userRequst:request notifyName:CommonWeiboSucceedNotification];
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
    }
    else if(request.tag==Stage_Request_RemoveDefaultWeibo)
    {
        NSString* resultString = request.responseString;
        if ([resultString isEqualToString:@"1"]) {
            [self afterDefaultSuccessed:nil userRequst:request notifyName:CommonWeiboSucceedNotification];
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
    }
    else if(request.tag==Stage_Request_ColumnListDefaultWeibo)
    {
        NSString* resultString = request.responseString;
        NSArray* jsonDict = [resultString objectFromJSONString];
        [self afterColumnListDefaultWeiboSuccessed:jsonDict userRequst:request];
    }
    else if(request.tag==Stage_Request_ContentListDefaultWeibo)
    {
        NSString* resultString = request.responseString;
        NSDictionary* jsonDict = [resultString objectFromJSONString];
        if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
            NSArray* weiboArray = [jsonDict objectForKey:@"statuses"];
            if (weiboArray) {
                [self afterDefaultSuccessed:jsonDict userRequst:request dataname:@"statuses" notifyName:CommonWeiboSucceedNotification];
            }
            else
            {
                [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
            }
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
    }
    else if(request.tag==Stage_Request_DefalutV2_GroupListWeibo)
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
                NSDictionary* dataDict = [resultDict valueForKey:@"data"];
                [self afterDefaultSuccessed:dataDict userRequst:request dataname:@"lists" notifyName:CommonWeiboSucceedNotification];
            }
            else
            {
                [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
            }
            
        }
        else
        {
            [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
        }
    }
    else if(request.tag==Stage_Request_DefalutV2_ContentListWeibo)
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
            if ([codeValue isEqualToString:@"0"])
            {
                NSDictionary* weiboArray = [resultDict objectForKey:@"data"];
                if (weiboArray) {
                    [self afterDefaultSuccessed:weiboArray userRequst:request dataname:@"statuses" notifyName:CommonWeiboSucceedNotification];
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
        else
        {
            [self requestFailed:request];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self afterDefaultFailed:request notifyName:CommonWeiboFailedNotification];
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
//    [SVProgressHUD s]
//    [self dismissWithSuccess];
 
  
//    [SVProgressHUD dismiss]
}

//-(void)dismissSVPSuc{
//    [SVProgressHUD showSuccessWithStatus:@"发送成功"];
//    [self performSelector:@selector(dismissSVP) withObject:nil afterDelay:1];
//}
//
//-(void)dismissSVPErr{
//    [SVProgressHUD showSuccessWithStatus:@"发送失败"];
//        [self performSelector:@selector(dismissSVP) withObject:nil afterDelay:1];
//
//}
//-(void)dismissSVP{
//    if ([SVProgressHUD isVisible]) {
//         
//    }
//    [SVProgressHUD dismiss];    
//}

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
