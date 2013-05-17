//
//  NewsListFuncPuller.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboLoginManager.h"

#define NewsList_top @"top"
#define NewsList_url @"url"
#define NewsList_shorttitle @"short_title"
#define NewsList_title @"title"
#define NewsList_id @"id"
#define NewsList_type @"type"
#define NewsList_contenttype @"content-type"
#define NewsList_date @"createdatetime"
#define NewsList_channelid @"channel-id"
#define NewsList_media @"media"
#define NewsList_timestamp @"timestamp"
#define NewsList_commentid @"comment|>commentid"
#define NewsList_videothumb @"video|>thumb"
#define NewsList_videovid @"video|>ipad"
#define NewsList_videourl @"video|>url"
#define NewsList_comments @"comment|>total_count"
#define NewsList_showcomments @"comment|>show_count"
#define NewsList_qreplycomments @"comment|>qreply_count"

#define NewsList_source @"source"

#define CommonListSucceedNotification @"CommonListSucceedNotification"
#define CommonListFailedNotification @"CommonListFailedNotification"

@class CommentDataList;
@class ASINetworkQueue;
@class ASIHTTPRequest;

@interface NewsListFuncPuller : NSObject
{
    ASINetworkQueue* mDownloadQueue;
    ASIHTTPRequest* requester;
}

@property(retain)ASINetworkQueue* downloadQueue;

+ (id)getInstance;

-(void)startListWithSender:(id)sender page:(NSInteger)page endTime:(NSTimeInterval)etime count:(NSInteger)countPerPage withAPICode:(NSArray*)codeArray args:(NSArray*)args dataList:(CommentDataList*)dataList bInback:(BOOL)bInback;

@end
