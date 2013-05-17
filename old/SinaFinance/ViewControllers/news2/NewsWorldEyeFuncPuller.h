//
//
//  NewsWorldEyeFuncPuller
//  SinaFinance
//
//  Created by sang on 10/26/12.
//
//
#import <Foundation/Foundation.h>
#import "WeiboLoginManager.h"


#define NewsList_source @"source"



#define NewsIndexScroll_tid @"tid"
#define NewsIndexScroll_category @"category"
#define NewsIndexScroll_type @"type"
#define NewsIndexScroll_order @"order"
#define NewsIndexScroll_ptime @"ptime"
#define NewsIndexScroll_mtime @"mtime"
#define NewsIndexScroll_url @"url"
#define NewsIndexScroll_comment @"comment"
#define NewsIndexScroll_title @"title"
#define NewsIndexScroll_content @"content"
#define NewsIndexScroll_hdcontent @"hdcontent"
#define NewsIndexScroll_image @"image"



#define NewsIndexList_nid @"nid"
#define NewsIndexList_category @"category"
#define NewsIndexList_type @"type"
#define NewsIndexList_order @"order"
#define NewsIndexList_ptime @"ptime"
#define NewsIndexList_mtime @"mtime"
#define NewsIndexList_url @"url"
#define NewsIndexList_comment @"comment"
#define NewsIndexList_title @"title"
#define NewsIndexList_content @"content"
#define NewsIndexList_hdcontent @"hdcontent"
#define NewsIndexList_image @"image"
#define NewsIndexList_channel_id @"channel_id"
#define NewsIndexList_createdatetime @"createdatetime"
#define NewsIndexList_images @"images"
#define NewsIndexList_video @"video"
#define NewsIndexList_content_type @"content_type"
#define NewsIndexList_ext_content @"ext_content"




#define CommonListSucceedNotification @"CommonListSucceedNotification"
#define CommonListFailedNotification @"CommonListFailedNotification"

@class CommentDataList;
@class ASINetworkQueue;
@class ASIHTTPRequest;

@interface NewsWorldEyeFuncPuller : NSObject
{
    ASINetworkQueue* mDownloadQueue;
    ASIHTTPRequest* requester;
}

@property(retain)ASINetworkQueue* downloadQueue;

+ (id)getInstance;

-(void)startListWithSender:(id)sender page:(NSInteger)page endTime:(NSTimeInterval)etime count:(NSInteger)countPerPage withAPICode:(NSArray*)codeArray args:(NSArray*)args dataList:(CommentDataList*)dataList bInback:(BOOL)bInback;

@end
