//
//  StockFuncPuller.h
//  SinaFinance
//
//  Created by shieh exbice on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboLoginManager.h"
#import "CommentDataList.h"


#define mystock_cn_curStockStatusNotificationName @"mystock_cn_curStockStatusNotificationName"
#define mystock_hk_curStockStatusNotificationName @"mystock_hk_curStockStatusNotificationName"
#define mystock_us_curStockStatusNotificationName @"mystock_us_curStockStatusNotificationName"

#define StockObjectAddedNotification @"StockObjectAddedNotification"
#define StockObjectFailedNotification @"StockObjectFailedNotification"


#define StockListType_GlobalWorldIndex @"world_index" //全球指数
#define StockListType_AsiaPacificIndex @"asia_pacific" //亚太指数
#define StockListType_EuropeIndex @"europe_index" //欧洲指数
#define StockListType_AmericaIndex @"america_index" //美洲指数
#define StockListType_AfricaIndex @"africa_index" //非洲指数
#define StockListType_AmericaAricaIndex @"ameafr_index" //美非指数
#define StockListType_GlobalWorldGood @"world_good" //全球商品
#define StockListType_ForiegnExchangeBasic @"forex_basic" //外汇基本汇率
#define StockListType_ForiegnExchangeCross @"forex_cross" //外汇交叉汇率
#define StockListType_HuRize @"sh_rise" //沪涨
#define StockListType_HuDrop @"sh_drop" //沪跌
#define StockListType_HuVolume @"sh_volume" //沪成交量
#define StockListType_ShenRize @"sz_rise" //深涨
#define StockListType_ShenDrop @"sz_drop" //深跌
#define StockListType_ShenVolume @"sz_volume" //深成交量
#define StockListType_HongkongRize @"hk_rise" //港涨
#define StockListType_HongkongDrop @"hk_drop" //港跌
#define StockListType_HongkongVolume @"hk_volume" //港成交量
#define StockListType_HongkongHot @"hk_hot" //热门港股
#define StockListType_USChina @"us_china" //美股中国股
#define StockListType_USTech @"us_tech" //美股科技股
#define StockListType_USHot @"us_hot" //美股热门
#define StockListType_PlateRize @"plate_rise" //领涨板块
#define StockListType_PlateDrop @"plate_drop" //领跌板块


#define StockFunc_MultiStock_input @"input"

#define StockFunc_OneStock_name @"cn_name"
#define StockFunc_OneStock_amount @"amount"
#define StockFunc_OneStock_price @"price"
#define StockFunc_OneStock_symbol @"symbol"
#define StockFunc_OneStock_ZHANGDIEFU @"chg"
#define StockFunc_OneStock_ZHANGDIEZHI @"diff"

//#define StockFunc_OneStock_amount @"amount"
#define StockFunc_OneStock_avg_price @"avg_price"
#define StockFunc_OneStock_change @"change"
#define StockFunc_OneStock_change_avg_price @"change_avg_price"
#define StockFunc_OneStock_code @"code"
#define StockFunc_OneStock_count @"count"
//#define StockFunc_OneStock_name @"name"
#define StockFunc_OneStock_symbol @"symbol"
#define StockFunc_OneStock_symbol_change @"symbol_change"
#define StockFunc_OneStock_symbol_diff @"symbol_diff"
#define StockFunc_OneStock_symbol_name @"symbol_name"
#define StockFunc_OneStock_symbol_price @"symbol_price"
#define StockFunc_OneStock_volume @"volume"

#define StockFunc_Onefund_Symbol @"Symbol"
#define StockFunc_Onefund_name @"ShortName"
#define StockFunc_Onefund_value @"JJJZ"
#define StockFunc_Onefund_rate @"JRRate"

#define StockFunc_SingleStockInfo_amount @"amount"
#define StockFunc_SingleStockInfo_change @"chg"
#define StockFunc_SingleStockInfo_name @"cn_name"
#define StockFunc_SingleStockInfo_different @"diff"
#define StockFunc_SingleStockInfo_en_name @"en_name"
#define StockFunc_SingleStockInfo_high @"high"
#define StockFunc_SingleStockInfo_high52 @"high52"
#define StockFunc_SingleStockInfo_hq_day @"hq_day"
#define StockFunc_SingleStockInfo_hq_time @"hq_time"
#define StockFunc_SingleStockInfo_last_close @"last_close"
#define StockFunc_SingleStockInfo_low @"low"
#define StockFunc_SingleStockInfo_low52 @"low52"
#define StockFunc_SingleStockInfo_open @"open"
#define StockFunc_SingleStockInfo_pe @"pe"
#define StockFunc_SingleStockInfo_price @"price"
#define StockFunc_SingleStockInfo_volume @"volume"
#define StockFunc_SingleStockInfo_total_volume @"total_volume"
#define StockFunc_SingleStockInfo_status @"status"
//五档盘口
#define StockFunc_SingleStockInfo_five_buy @"five_buy"
#define StockFunc_SingleStockInfo_five_sell @"five_sell"

#define StockFunc_SingleStockInfo_fundname @"sname"
#define StockFunc_SingleStockInfo_fundtype @"type"

#define StockFunc_SingleStockInfo_localsvg @"localsvg"
#define StockFunc_SingleStockInfo_svgdata @"svgdata"

#define StockFunc_GroupAPI_all_p @"all_p"
#define StockFunc_GroupAPI_full_pinfo @"full_pinfo"
#define StockFunc_GroupAPI_bat_jia @"bat_jia"
#define StockFunc_GroupAPI_bat_del @"bat_del"
#define StockFunc_GroupAPI_upd_order @"upd_order"

#define StockFunc_GroupAPI_Version @"version_id"

#define StockFunc_GroupInfo_AStock @"a"
#define StockFunc_GroupInfo_fundStock @"fund"
#define StockFunc_GroupInfo_usStock @"us"
#define StockFunc_GroupInfo_hkStock @"hk"
#define StockFunc_GroupInfo_pid @"pid"
#define StockFunc_GroupInfo_name @"name"
#define StockFunc_GroupInfo_hqtype @"hqtype"
#define StockFunc_GroupInfo_symbols @"symbols"

#define StockFunc_Chart_exchange @"exchange"
#define StockFunc_Chart_ssStatus @"ssStatus"

#define StockFunc_Suggest_nasdac @"nasdac"
#define StockFunc_Suggest_type @"type"
#define StockFunc_Suggest_symbol @"symbol"
#define StockFunc_Suggest_full_symbol @"full_symbol"
#define StockFunc_Suggest_name @"name"

#define StockFunc_RemindStockInfo_name @"cname"
#define StockFunc_RemindStockInfo_symbol @"symbol"
#define StockFunc_RemindStockInfo_fullsymbol @"fullsymbol"
#define StockFunc_RemindStockInfo_marketsymbol @"marketsymbol"
#define StockFunc_RemindStockInfo_type @"country"

#define StockFunc_RemindStockList_name @"cn_name"
#define StockFunc_RemindStockList_fullsymbol @"fullsymbol"
#define StockFunc_RemindStockList_price @"price"
#define StockFunc_RemindStockList_symbol @"symbol"

#define StockFunc_RemindStockList_set_id @"set_id"
#define StockFunc_RemindStockList_sso_id @"sso_id"
#define StockFunc_RemindStockList_alert_type @"alert_type"
#define StockFunc_RemindStockList_market @"market"
#define StockFunc_RemindStockList_alert_code @"alert_code"
#define StockFunc_RemindStockList_rise_price @"rise_price"
#define StockFunc_RemindStockList_fall_price @"fall_price"
#define StockFunc_RemindStockList_incpercent @"incpercent"
#define StockFunc_RemindStockList_decpercent @"decpercent"
#define StockFunc_RemindStockList_cretime @"cretime"
#define StockFunc_RemindStockList_updtime @"updtime"
#define StockFunc_RemindStockList_is_valid @"is_valid"
#define StockFunc_RemindStockList_supdtime @"supdtime"
#define StockFunc_RemindStockList_alert_config @"alert_config"
#define StockFunc_RemindStockList_send_status @"send_status"

#define StockFunc_RemindHistoryList_send_content @"send_content"
#define StockFunc_RemindHistoryList_alert_code @"alert_code"
#define StockFunc_RemindHistoryList_market @"market"
#define StockFunc_RemindHistoryList_fullsymbol @"fullsymbol"
#define StockFunc_RemindHistoryList_symbol @"symbol"
#define StockFunc_RemindHistoryList_set_id @"set_id"
#define StockFunc_RemindHistoryList_sendtime @"sendtime"
#define StockFunc_RemindHistoryList_name @"cn_name"

#define StockFunc_News_createDate @"create_date"
#define StockFunc_News_createTime @"create_time"
#define StockFunc_News_media_source @"media_source"
#define StockFunc_News_short_title @"short_title"
#define StockFunc_News_title @"title"
#define StockFunc_News_url @"url"

#define StockFunc_CNReport_title @"title"
#define StockFunc_CNReport_rpt_name @"rpt_name"
#define StockFunc_CNReport_aid @"report_id"
#define StockFunc_CNReport_orgname @"orgname"
#define StockFunc_CNReport_author @"author"
#define StockFunc_CNReport_createDate @"adddate"

#define StockFunc_CNReportContent_title @"title"
#define StockFunc_CNReportContent_symbol @"symbol"
#define StockFunc_CNReportContent_rpt_name @"rpt_name"
#define StockFunc_CNReportContent_content @"reportinfo"
#define StockFunc_CNReportContent_aid @"id"
#define StockFunc_CNReportContent_report_id @"report_id"
#define StockFunc_CNReportContent_orgname @"orgname"
#define StockFunc_CNReportContent_isvalid @"isvalid"
#define StockFunc_CNReportContent_industry @"industry"
#define StockFunc_CNReportContent_author @"author"
#define StockFunc_CNReportContent_adddate @"adddate"

#define StockFunc_HKNotice_title @"AFFICHE_TITLE"
#define StockFunc_HKNotice_publishdate @"PUBLISH_DATE"
#define StockFunc_HKNotice_entrydate @"ENTRY_TIME"
#define StockFunc_HKNotice_aid @"FINET_AFFICHE_ID"

#define StockFunc_HKNoticeContent_content @"AFFICHE_CONTENT"
#define StockFunc_HKNoticeContent_title @"AFFICHE_TITLE"
#define StockFunc_HKNoticeContent_title_tc @"AFFICHE_TITLE_TC"
#define StockFunc_HKNoticeContent_edited @"EDITED_FLAG"
#define StockFunc_HKNoticeContent_entrydate @"ENTRY_TIME"
#define StockFunc_HKNoticeContent_FINETDB_MASK @"FINETDB_MASK"
#define StockFunc_HKNoticeContent_aid @"FINET_AFFICHE_ID"
#define StockFunc_HKNoticeContent_publishdate @"PUBLISH_DATE"

#define StockFunc_CNNotice_Announmt @"Announmt"
#define StockFunc_CNNotice_Bourse @"Bourse"
#define StockFunc_CNNotice_CompanyCode @"CompanyCode"
#define StockFunc_CNNotice_aid @"ID"
#define StockFunc_CNNotice_createDate @"date"
#define StockFunc_CNNotice_origin @"origin"
#define StockFunc_CNNotice_pdf_flag @"pdf_flag"
#define StockFunc_CNNotice_pdf_status @"pdf_status"
#define StockFunc_CNNotice_title @"title"
#define StockFunc_CNNotice_stitle @"stitle"
#define StockFunc_CNNotice_type @"type"

#define StockFunc_CNNoticeContent_Announmt @"Announmt"
#define StockFunc_CNNoticeContent_Bourse @"Bourse"
#define StockFunc_CNNoticeContent_Content @"Content"
#define StockFunc_CNNoticeContent_companycode @"companycode"
#define StockFunc_CNNoticeContent_end_date @"end_date"
#define StockFunc_CNNoticeContent_origin @"origin"
#define StockFunc_CNNoticeContent_pdf_flag @"pdf_flag"
#define StockFunc_CNNoticeContent_aid @"ID"
#define StockFunc_CNNoticeContent_PaperCode @"PaperCode"
#define StockFunc_CNNoticeContent_Title @"Title"

#define SearchHotStock_symbol @"symbol"
#define SearchHotStock_name @"name"
#define SearchHotStock_type @"type"


enum StockFuncStage
{
    Stage_Request_StockList,
    Stage_Request_MyStockList,
    Stage_Request_APIList,
    Stage_Request_OneStockInfo,
    Stage_Request_MultiStockInfo,
    Stage_Request_OneStockNews,
    Stage_Request_OneCnStockReport,
    Stage_Request_OneCnStockNotice,
    Stage_Request_OneHkStockNotice,
    Stage_Request_OneCnStockReportContent,
    Stage_Request_OneCnStockNoticeContent,
    Stage_Request_OneHkStockNoticeContent,
    Stage_Request_OneFundType,
    Stage_Request_OneFundNetValue,
    Stage_Request_StockChart,
    Stage_Request_ObtainMyGroupAPIVersion,
    Stage_Request_ObtainMyGroupAPI,
    Stage_Request_ObtainMyGroupList,
    Stage_Request_AddMyGroup,
    Stage_Request_RemoveMyGroup,
    Stage_Request_ReorderMyGroup,
    Stage_Request_AddStockSuggest,
    Stage_Request_StockLookup,
    Stage_Request_OneStockLookup,
    Stage_Request_StockRemindStartup,
    Stage_Request_StockRemindUserInfo,
    Stage_Request_StockRemindAddInfo,
    Stage_Request_StockRemindRemoveInfo,
    Stage_Request_StockRemindUpdateInfo,
    Stage_Request_StockRemindList,
    Stage_Request_StockRemindHistoryList,
    Stage_Request_SearchHotStock,
    Stage_Request_TestAPI
};

@class ASINetworkQueue;

@interface StockFuncPuller : NSObject
{
    ASINetworkQueue* downloadQueue;
}

@property(retain)ASINetworkQueue* downloadQueue;

+ (id)getInstance;

-(void)getAllHolidayData;

-(NSString *)getHolidayNameByCounty:(NSString *)str;
/**
 *depreted
 */
-(void)getHolidayData;
-(void)getStockStatusData;
-(void)getStockStatusData_cn;
-(void)getStockStatusData_hk;
-(void)getStockStatusData_us;
-(void)addRequestToSeperateStart:(ASIHTTPRequest*)request;
-(void)addRequestToDowloadQueue:(ASIHTTPRequest*)request;
-(void)addRequestToOfflineQueue:(ASIHTTPRequest*)request;

-(void)startStockListWithSender:(id)sender type:(NSString*)type symbol:(NSString*)symbol count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;

/**
 支持排序，具体按照order数据看，
 order[0]是字段
 order[1]是顺序
 */
-(void)startStockListWithSender:(id)sender type:(NSString*)type symbol:(NSString*)symbol count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info orderInfo:(NSArray *)order;

-(void)startListWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)page withAPICode:(NSArray*)codeArray args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info bInback:(BOOL)bInback;
-(void)startOneStockInfoWithSender:(id)sender type:(NSString*)type symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startMultiStockInfoWithSender:(id)sender symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startOneFundTypeWithSender:(id)sender symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startOneFundNetValueWithSender:(id)sender symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startStockChartWithSender:(id)sender url:(NSString*)urlString args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;

-(void)startOneStockNewsWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)page type:(NSString*)type symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startOneCnStockReportWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)page symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startOneCnStockNoticeWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)page symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startOneHKStockNoticeWithSender:(id)sender count:(NSInteger)countPerPage page:(NSInteger)page symbol:(NSString*)symbol args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startOneCnStockReportContentWithSender:(id)sender rptid:(NSString*)rptid args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startOneCnStockNoticeContentWithSender:(id)sender symbol:(NSString*)symbol noticeID:(NSString*)noticeID args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startOneHKStockNoticeContentWithSender:(id)sender noticeID:(NSString*)noticeID args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;

-(void)startMyGroupListWithSender:(id)sender service:(NSString*)service command:(NSString*)command args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info;
-(void)startMyGroupAddStockWithSender:(id)sender service:(NSString*)service  stock:(NSArray*)stocks command:(NSString*)command groupPID:(NSString*)groupPID args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startMyGroupRemoveStockWithSender:(id)sender service:(NSString*)service stock:(NSArray*)stocks command:(NSString*)command groupPID:(NSString*)groupPID args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startMyGroupReorderStockWithSender:(id)sender service:(NSString*)service stock:(NSArray*)stocks command:(NSString*)command groupPID:(NSString*)groupPID args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startMyStockListWithSender:(id)sender type:(NSString*)type subtype:(NSString*)subType symbol:(NSString*)symbol count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startStockSuggestWithSender:(id)sender name:(NSString*)name type:(NSInteger)type subtype:(NSString*)subtype count:(NSInteger)countPerPage page:(NSInteger)npage args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info;
-(void)startStockLookupWithSender:(id)sender name:(NSString*)name forLeast:(BOOL)forLeast args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info;
-(void)startOneStockLookupWithSender:(id)sender name:(NSString*)name forLeast:(BOOL)forLeast args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info;
-(void)startSearchHotStockWithSender:(id)sender args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info;

-(void)startStockRemindStartupWithSender:(id)sender device:(NSString*)device bOn:(BOOL)bOn userInfo:(id)info;
-(void)startStockRemindUserInfoWithSender:(id)sender device:(NSString*)device args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)startStockRemindAddInfoWithSender:(id)sender symbol:(NSString*)symbol risePrice:(NSString*)rise fallPrice:(NSString*)fall incpercent:(NSString*)incpercent decpercent:(NSString*)decpercent userInfo:(id)info;
-(void)startStockRemindRemoveInfoWithSender:(id)sender setID:(NSString*)setID userInfo:(id)info;
-(void)startStockRemindUpdateInfoWithSender:(id)sender setID:(NSString*)setID risePrice:(NSString*)rise fallPrice:(NSString*)fall incpercent:(NSString*)incpercent decpercent:(NSString*)decpercent userInfo:(id)info;
-(void)startStockRemindListWithSender:(id)sender args:(NSArray*)args dataList:(CommentDataList*)dataList seperateRequst:(BOOL)seperateRequst userInfo:(id)info;
-(void)startStockRemindHistoryListWithSender:(id)sender device:(NSString*)device args:(NSArray*)args dataList:(CommentDataList*)dataList userInfo:(id)info;
-(void)testAPI;

@end