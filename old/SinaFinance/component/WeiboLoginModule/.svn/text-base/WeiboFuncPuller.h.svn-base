//
//  WeiboFuncPuller.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboLoginManager.h"
#import "CommentDataList.h"

#define WeiboObject_CreateDate @"created_at"
#define WeiboObject_id @"id"
#define WeiboObject_idstr @"idstr"
#define WeiboObject_text @"text"
#define WeiboObject_source @"source"
#define WeiboObject_comments_count @"comments_count"
#define WeiboObject_reposts_count @"reposts_count"
#define WeiboObject_favorited @"favorited"
#define WeiboObject_truncated @"truncated"
#define WeiboObject_in_reply_to_status_id @"in_reply_to_status_id"
#define WeiboObject_in_reply_to_user_id @"in_reply_to_user_id"
#define WeiboObject_in_reply_to_screen_name @"in_reply_to_screen_name"
#define WeiboObject_thumbnail_pic @"thumbnail_pic"
#define WeiboObject_bmiddle_pic @"bmiddle_pic"
#define WeiboObject_original_pic @"original_pic"
#define WeiboObject_geo @"geo"
#define WeiboObject_mid @"mid"
#define WeiboObject_user @"user"

#define WeiboUserObject_id @"id"
#define WeiboUserObject_idstr @"idstr"
#define WeiboUserObject_screen_name @"screen_name"
#define WeiboUserObject_name @"name"
#define WeiboUserObject_gender @"gender"
#define WeiboUserObject_avatar_large @"avatar_large"
#define WeiboUserObject_verified @"verified"
#define WeiboUserObject_verified_type @"verified_type"
#define WeiboUserObject_province @"province"
#define WeiboUserObject_city @"city"
#define WeiboUserObject_location @"location"
#define WeiboUserObject_description @"description"
#define WeiboUserObject_url @"url"
#define WeiboUserObject_profile_image_url @"profile_image_url"
#define WeiboUserObject_domain @"domain"
#define WeiboUserObject_gender @"gender"
#define WeiboUserObject_followers_count @"followers_count"
#define WeiboUserObject_friends_count @"friends_count"
#define WeiboUserObject_statuses_count @"statuses_count"
#define WeiboUserObject_favourites_count @"favourites_count"
#define WeiboUserObject_created_at @"created_at"
#define WeiboUserObject_following @"following"
#define WeiboUserObject_allow_all_act_msg @"allow_all_act_msg"
#define WeiboUserObject_geo_enabled @"geo_enabled"
#define WeiboUserObject_verified @"verified"
#define WeiboUserObject_verifiedtype @"verified_type"
#define WeiboUserObject_retweeted_status @"retweeted_status"

#define WeiboCommentObject_created_at @"created_at"
#define WeiboCommentObject_id @"id"
#define WeiboCommentObject_text @"text"
#define WeiboCommentObject_source @"source"
#define WeiboCommentObject_user @"user"
#define WeiboCommentObject_mid @"mid"
#define WeiboCommentObject_idstr @"idstr"
#define WeiboCommentObject_reply_comment @"reply_comment"

#define WeiboDefaultV2Group_created_at @"created_at"
#define WeiboDefaultV2Group_description @"description"
#define WeiboDefaultV2Group_id @"id"
#define WeiboDefaultV2Group_idstr @"idstr"
#define WeiboDefaultV2Group_like_count @"like_count"
#define WeiboDefaultV2Group_member_count @"member_count"
#define WeiboDefaultV2Group_mode @"mode"
#define WeiboDefaultV2Group_name @"name"
#define WeiboDefaultV2Group_profile_image_url @"profile_image_url"
#define WeiboDefaultV2Group_user @"user"
#define WeiboDefaultV2Group_visible @"visible"

#define WeiboGroup_created_at @"created_at"
#define WeiboGroup_description @"description"
#define WeiboGroup_id @"id"
#define WeiboGroup_idstr @"idstr"
#define WeiboGroup_like_count @"like_count"
#define WeiboGroup_member_count @"member_count"
#define WeiboGroup_mode @"mode"
#define WeiboGroup_name @"name"
#define WeiboGroup_profile_image_url @"profile_image_url"
#define WeiboGroup_user @"user"
#define WeiboGroup_visible @"visible"

#define CommonWeiboSucceedNotification @"CommonWeiboSucceedNotification"
#define CommonWeiboFailedNotification @"CommonWeiboFailedNotification"

@class CommentDataList;
@class ASINetworkQueue;

enum WeiboFuncStage
{
    Stage_RequestV2_Publish,
    Stage_RequestV2_RepostWeibo,
    Stage_RequestV2_CommentWeibo,
    Stage_RequestV2_FavariteWeibo,
    Stage_RequestV2_ObtainGroupListWeibo,
    Stage_RequestV2_CommentListWeibo,
    Stage_Request_V2CreateGroupWeibo,
    Stage_Request_V2GroupMembersWeibo,
    Stage_Request_V2CreateFriendshipWeibo,
    Stage_Request_V2BatchCreateFriendshipWeibo,
    Stage_Request_V2ObtainWeibo,
    Stage_Request_V2UserInfoWeibo,
    Stage_Request_V2AddGroupMemberWeibo,
    Stage_Request_ContentListDefaultWeibo,
    Stage_Request_ColumnListDefaultWeibo,
    Stage_Request_RemoveDefaultWeibo,
    Stage_Request_AddDefaultWeibo,
    Stage_Request_V2RemoveGroupMemberWeibo,
    Stage_Request_DefalutV2_GroupListWeibo,
    Stage_Request_DefalutV2_ContentListWeibo
};

enum RequestError
{
    RequestError_Unknown,
    RequestError_List_Not_Exists,
    RequestError_User_Not_Exists,
    RequestError_Account_Not_Open,
    //重复内容-暂未处理
    RequestError_repeat_content
};

@interface WeiboFuncPuller : NSObject
{
    NSString* loginedGroupID;
    ASINetworkQueue* mDownloadQueue;
}

@property(retain)ASINetworkQueue* downloadQueue;

+ (id)getInstance;

-(void)startPublishV2:(NSString*)aStatus;
-(void)startRepostV2WeiboWithID:(NSString*)mID content:(NSString*)aText;
-(void)startCommentV2WeiboWithID:(NSString*)mID content:(NSString*)aText;
-(void)startFavariteWeiboV2WithID:(NSString*)mID;

-(void)startV2ObtainGroupListWithSender:(id)sender args:(NSArray*)args;
-(void)startV2ObtainWithSender:(id)sender groupID:(NSString*)gID count:(NSInteger)count page:(NSInteger)npage max_id:(NSString*)maxID lastID:(NSString*)lastID args:(NSArray*)args weiboList:(CommentDataList*)weiboList;
-(void)startCommentListV2WeiboWithSender:(id)sender ID:(NSString*)mID count:(NSInteger)countPerPage page:(NSInteger)npage max_id:(NSString*)maxID args:(NSArray*)args dataList:(CommentDataList*)dataList;
-(void)startCreateGroupWeiboWithSender:(id)sender groupName:(NSString*)groupName;
-(void)startCreateDefaultNewsGroupWeiboWithSender:(id)sender;
-(void)startGroupMembersWeiboWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)npage cursor:(NSString*)cursor args:(NSArray*)args dataList:(CommentDataList*)dataList;
-(void)startGroupMembersWeiboWithSender:(id)sender userID:(NSString*)userID count:(NSInteger)countPerPage page:(NSInteger)npage cursor:(NSString*)cursor args:(NSArray*)args dataList:(CommentDataList*)dataList;
-(void)startCreateFriendshipWeiboWithSender:(id)sender uid:(NSString*)uid username:(NSString*)username;
-(void)startBatchCreateFriendshipWeiboWithSender:(id)sender uids:(NSArray*)uids;
-(void)startUserInfoWeiboWithSender:(id)sender uid:(NSString*)uid username:(NSString*)username info:(id)info;
-(void)startUserInfoWeiboWithSender2:(id)sender uid:(NSString*)uid username:(NSString*)username info:(id)info  image:(NSData *)img;
-(void)startAddGroupMemberWeiboWithSender:(id)sender userid:(NSString*)userid groupid:(NSString*)groupid;
-(void)startAddGroupMemberWeiboWithSender:(id)sender userid:(NSString*)userid;
-(void)startRemoveGroupMemberWeiboWithSender:(id)sender userid:(NSString*)userid groupid:(NSString*)groupid;
-(void)startRemoveGroupMemberWeiboWithSender:(id)sender userid:(NSString*)userid;

-(void)startAddDefaultWeiboWithSender:(id)sender weiboID:(NSString*)weiboID nickName:(NSString*)nickName;
-(void)startRemoveDefaultWeiboWithSender:(id)sender weiboID:(NSString*)weiboID;
-(void)startColumnListDefaultWeiboWithSender:(id)sender args:(NSArray*)args dataList:(CommentDataList*)dataList;
-(void)startContentListDefaultWeiboWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)npage max_id:(NSString*)maxID lastID:(NSString*)lastID args:(NSArray*)args weiboList:(CommentDataList*)weiboList;

-(void)startDefaultV2GroupListWithSender:(id)sender args:(NSArray*)args dataList:(CommentDataList*)dataList;
-(void)startContentListDefault2WeiboWithSender:(id)sender groupID:(NSString*)gID count:(NSInteger)countPerPage page:(NSInteger)npage max_id:(NSString*)maxID lastID:(NSString*)lastID args:(NSArray*)args weiboList:(CommentDataList*)weiboList;

@end
