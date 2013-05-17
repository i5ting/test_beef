//
//  StockBarPuller.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentDataList.h"
#import "WeiboFuncPuller.h"


#define StockBar_HotBarList_name @"name"
#define StockBar_HotBarList_nick @"nick"
#define StockBar_HotBarList_bid @"bid"

#define StockBar_OneStockList_name @"bname"
#define StockBar_OneStockList_uid @"uid"
#define StockBar_OneStockList_bid @"bid"
#define StockBar_OneStockList_title @"title"
#define StockBar_OneStockList_time @"ctime"
#define StockBar_OneStockList_src @"src"
#define StockBar_OneStockList_url @"url"
#define StockBar_OneStockList_uname @"uname"
#define StockBar_OneStockList_isTop @"isTop"
#define StockBar_OneStockList_ip @"ip"
#define StockBar_OneStockList_lastip @"lastip"
#define StockBar_OneStockList_views @"views"
#define StockBar_OneStockList_reply @"reply"
#define StockBar_OneStockList_isNotice @"isNotice"
#define StockBar_OneStockList_tid @"tid"
#define StockBar_OneStockList_lastctime @"lastctime"

#define StockBar_OneReplyList_uid @"uid"
#define StockBar_OneReplyList_bid @"bid"
#define StockBar_OneReplyList_title @"title"
#define StockBar_OneReplyList_time @"ctime"
#define StockBar_OneReplyList_link @"link"
#define StockBar_OneReplyList_type @"type"
#define StockBar_OneReplyList_src @"src"
#define StockBar_OneReplyList_keyword @"keyword"
#define StockBar_OneReplyList_quotepid @"quotepid"
#define StockBar_OneReplyList_uname @"uname"
#define StockBar_OneReplyList_ip @"ip"
#define StockBar_OneReplyList_video @"video"
#define StockBar_OneReplyList_content @"content"
#define StockBar_OneReplyList_pid @"pid"
#define StockBar_OneReplyList_ipplace @"ipplace"
#define StockBar_OneReplyList_status @"status"


#define StockBarObjectAddedNotification @"StockBarObjectAddedNotification"
#define StockBarObjectFailedNotification @"StockBarObjectFailedNotification"

enum StockBar_RequestError
{
    StockBar_RequestError_Unknown,
    StockBar_RequestError_Not_Exists
};

enum StockBarStage
{
    Stage_Request_HotBarList,
    Stage_Request_OneStockBarList,
    Stage_Request_SendStockSubject,
    Stage_Request_OneStockBarReplyList
};

@class ASINetworkQueue;

@interface StockBarPuller : NSObject
{
    ASINetworkQueue* mDownloadQueue;
}

@property(retain)ASINetworkQueue* downloadQueue;

+ (id)getInstance;
-(void)startHotBarListWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList;
-(void)startOneStockBarListWithSender:(id)sender stockName:(NSString*)stockName bid:(NSString*)bid count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList;
-(void)startSendStockSubjectWithSender:(id)sender stockName:(NSString*)stockName bid:(NSString*)bid tid:(NSString*)tid quotePid:(NSString*)quotePid title:(NSString*)title content:(NSString*)content args:(NSArray*)args userInfo:(id)userInfo;
-(void)startOneStockBarReplyListWithSender:(id)sender stockName:(NSString*)stockName bid:(NSString*)bid tid:(NSString*)tid count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList;

@end