//
//  NewsFuncPuller.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboLoginManager.h"
#import "CommentDataList.h"

//NewsObjectType_Normal
#define NEWS_ID @"id"
#define NEWS_URL @"url"
#define NEWS_CHANNEL @"channel-id"
#define NEWS_CREATETIME @"createdatetime"
#define NEWS_TITLE @"title"
#define NEWS_LEVEL @"level"
#define NEWS_SHORTTITLE @"short_title"
#define NEWS_MEDIA @"media"
#define NEWS_CONTENT @"content"
#define NEWS_TOTALCOMMENTS @"total_comments"
#define NEWS_Custom_ReadState @"custom_readstate"

#define NEWS_IMAGES_URL @"images|>0|>url"

#define NEWS_TYPE @"type"
#define NEWS_IMG @"img"
#define NEWS_VID @"vid"
#define NEWS_TIMELEN @"time_len"
#define NEWS_MEDIANAME @"media_name"
#define NEWS_FIRSTDATE @"first_date"
#define NEWS_COLUMNID @"column_id"
#define NEWS_COLUMNNAME @"column_name"
#define NEWS_COLUMNURL @"column_url"

#define NEWS_VideoVid @"video|>ipad"
#define NEWS_VideoImg @"video|>thumb"

//ScrollNews
#define SCROLLNEWS_ID @"id"
#define SCROLLNEWS_TYPE @"type"
#define SCROLLNEWS_TITLE @"title"
#define SCROLLNEWS_URL @"url"
#define SCROLLNEWS_CREATETIME @"createdatetime"

//NewsObjectType_Picture
#define PICNEWS_ID @"id"
#define PICNEWS_SID @"sid"
#define PICNEWS_NAME @"name"
#define PICNEWS_URL @"url"
#define PICNEWS_IMAGEURL @"img_url"

#define FocusNews_ID @"album_id"
#define FocusNews_sid @"sid"
#define FocusNews_title @"title"
#define FocusNews_URL @"url"
#define FocusNews_ShortTitle @"short_title"
#define FocusNews_image @"image"

//newscontent
#define NEWSCONTENT_TYPE @"type"
#define NEWSCONTENT_CONTENTTYPE @"content-type"
#define NEWSCONTENT_URL @"url"
#define NEWSCONTENT_ID @"id"
#define NEWSCONTENT_CHANNELID @"channel-id"
#define NEWSCONTENT_CREATETIME @"createdatetime"
#define NEWCONTENT_menddatetime @"menddatetime"
#define NEWSCONTENT_TITLE @"title"
#define NEWSCONTENT_LEVEL @"level"
#define NEWSCONTENT_KEYWORDS @"keywords"
#define NEWSCONTENT_SORTTITLE @"short_title"
#define NEWSCONTENT_MEDIA @"media"
#define NEWSCONTENT_CONTENT @"content"
#define NEWSCONTENT_commentid @"comment|>commentid"
#define NEWSCONTENT_commentCount @"comment|>show_count"

#define CommentContentObject_mid @"mid"
#define CommentContentObject_channel @"channel"
#define CommentContentObject_newsid @"newsid"
#define CommentContentObject_status @"status"
#define CommentContentObject_time @"time"
#define CommentContentObject_agree @"agree"
#define CommentContentObject_against @"against"
#define CommentContentObject_length @"length"
#define CommentContentObject_rank @"rank"
#define CommentContentObject_vote @"vote"
#define CommentContentObject_level @"level"
#define CommentContentObject_parent @"parent"
#define CommentContentObject_thread @"thread"
#define CommentContentObject_uid @"uid"
#define CommentContentObject_nick @"nick"
#define CommentContentObject_usertype @"usertype"
#define CommentContentObject_content @"content"
#define CommentContentObject_ip @"ip"
#define CommentContentObject_area @"area"
#define CommentContentObject_config @"config"

#define SearchNews_calchint @"calchint"
#define SearchNews_datetime @"datetime"
#define SearchNews_intro @"intro"
#define SearchNews_media @"media"
#define SearchNews_origin_title @"origin_title"
#define SearchNews_short_title @"short_title"
#define SearchNews_title @"title"
#define SearchNews_url @"url"

#define CommonNewsSucceedNotification @"CommonNewsSucceedNotification"
#define CommonNewsFailedNotification @"CommonNewsFailedNotification"

enum NewsFuncStage
{
    Stage_Request_CommentNews,
    Stage_Request_NewsContent,
    Stage_Request_CommentList,
    Stage_Request_CommentContent,
    Stage_Request_SearchNews
};

@class ASINetworkQueue;
@class ASIHTTPRequest;

@interface NewsFuncPuller : NSObject
{
    ASINetworkQueue* mDownloadQueue;
    ASIHTTPRequest* requester;
}

@property(retain)ASINetworkQueue* downloadQueue;

+ (id)getInstance;

-(void)startCommentNewsWithSender:(id)sender channelid:(NSString*)channelID newsid:(NSString*)newsID content:(NSString*)content;
-(void)startNewsContentWithSender:(id)sender urlString:(NSString*)urlStr args:(NSArray*)args dataList:(CommentDataList*)dataList bInback:(BOOL)bInback;
-(void)startCommentListWithSender:(id)sender page:(NSInteger)page withAPICode:(NSArray*)codeArray args:(NSArray*)args dataList:(CommentDataList*)dataList bInback:(BOOL)bInback;
-(void)startCommentContentWithSender:(id)sender page:(NSInteger)page count:(NSInteger)count withChannel:(NSString*)channel newsID:(NSString*)newsID args:(NSArray*)args dataList:(CommentDataList*)dataList bInback:(BOOL)bInback;
-(void)startSearchFinanceNewsWithSender:(id)sender searchString:(NSString*)searchString lastps:(NSString*)ps lastpf:(NSString*)pf count:(NSInteger)countPerPage page:(NSInteger)page args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;

@end
