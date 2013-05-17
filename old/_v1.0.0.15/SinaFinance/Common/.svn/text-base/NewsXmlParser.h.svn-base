//
//  XmlParser.h
//  SinaFinance
//
//  Created by Du Dan on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//NewsList
#define NEWSLIST_ID_KEY @"NewsListID"
#define NEWSLIST_TITLE_KEY @"NewsListTitle"
#define NEWSLIST_DATE_KEY @"NewsListDate"
#define NEWSLIST_SOURCE_KEY @"NewsListSource"
#define NEWSLIST_URL_KEY @"NewsListURL"

//Stock Search Keys
#define STOCK_SEARCH_SYMBOL_KEY @"StockSearchSymbol"
#define STOCK_SEARCH_COUNTRY_KEY @"StockSearchCountry"
#define STOCK_SEARCH_CNAME_KEY @"StockSearchCname"

//Stock Data
#define STOCK_DATA_CODE_KEY @"StockDataCode"
#define STOCK_DATA_NAME_KEY @"StockDataName"
#define STOCK_DATA_PRICE_KEY @"StockDataPrice"
#define STOCK_DATA_ZHANGDIEE_KEY @"StockDataZhangdiee"
#define STOCK_DATA_ZHANGDIEFU_KEY @"StockDataZhangdiefu"
#define STOCK_DATA_AMOUNT_KEY @"StockDataAmount"
#define STOCK_DATA_TIME_KEY @"StockDataTime"

//Fund Net Value Data
#define FUND_NETVALUE_SYMBOL_KEY @"FundNetValueSymbol"
#define FUND_NETVALUE_NAME_KEY @"FundNetValueName"
#define FUND_NETVALUE_PERNAV_KEY @"FundNetValuePerNav"
#define FUND_NETVALUE_TOTALNAV_KEY @"FundNetValueTotalNav"
#define FUND_NETVALUE_NAVRATE_KEY @"FundNetValueNavRate"
#define FUND_NETVALUE_YESTERDAYNAV_KEY @"FundNetValueYesterdayNav"
#define FUND_NETVALUE_NAVA_KEY @"FundNetValueNavA"
#define FUND_NETVALUE_SGSTAT_KEY @"FundNetValueSgStat"
#define FUND_NETVALUE_SHSTAT_KEY @"FundNetValueShStat"
#define FUND_NETVALUE_RGSTAT_KEY @"FundNetValueRgStat"
#define FUND_NETVALUE_NAVDATE_KEY @"FundNetValueNavDate"
#define FUND_NETVALUE_MANAGER_KEY @"FundNetValueManager"
#define FUND_NETVALUE_COMPANY_KEY @"FundNetValueCompany"
#define FUND_NETVALUE_JJLX_KEY @"FundNetValueJJLX"
#define FUND_NETVALUE_JJZFE_KEY @"FundNetValueJJZFE"
#define FUND_NETVALUE_STARTDATE_KEY @"FundNetValueStartDate"
#define FUND_NETVALUE_ENDDATE_KEY @"FundNetValueEndDate"
#define FUND_NETVALUE_EXCHANGE_KEY @"FundNetValueExchange"
#define FUND_NETVALUE_DIFF_KEY @"FundNetValueDiff"
#define FUND_NETVALUE_CHG_KEY @"FundNetValueChg"
#define FUND_NETVALUE_DISCOUNTRATE_KEY @"FundNetValueDiscountRate"
#define FUND_NETVALUE_AMOUNT_KEY @"FundNetValueAmount"
#define FUND_NETVALUE_7DAYRATE_KEY @"FundNetValue7DayRate"
#define FUND_NETVALUE_WPERNAV_KEY @"FundNetValueWPerNav"
#define FUND_NETVALUE_PRICE_KEY @"FundNetValuePrice"
#define FUND_NETVALUE_LASTCLOSE_KEY @"FundNetValueLastClose"
#define FUND_NETVALUE_OPEN_KEY @"FundNetValueOpen"
#define FUND_NETVALUE_HIGH_KEY @"FundNetValueHigh"
#define FUND_NETVALUE_LOW_KEY @"FundNetValueLow"
#define FUND_NETVALUE_HQDAY_KEY @"FundNetValueHqDay"
#define FUND_NETVALUE_HQTIME_KEY @"FundNetValueHqTime"


@interface NewsXmlParser : NSObject
{
}

+ (NSArray*)parseNewsXmlWithData:(NSData*)data;
+ (NSArray*)parseHeadlineXmlWithData:(NSData*)data;
+ (NSArray*)parseNewsSearchXmlWithData:(NSData*)data;
+ (NSArray*)parseNewsContentXmlWithData:(NSData*)data;
+ (NSArray*)parseNewsContent2XmlWithData:(NSData*)data;
+ (NSArray*)parseNewsContentImagesWithData:(NSData*)data;
+ (NSArray*)parseNewsContent2ImagesWithData:(NSData*)data;
+ (NSArray*)parseNewsContentCommentWithData:(NSData*)data;

+ (NSArray*)parseSearchContentXmlWithData:(NSData*)data;
+ (NSArray*)parseStockSearchXmlWithData:(NSData*)data;
//+ (NSArray*)parseStockDataXmlWithData:(NSData*)data;
+ (NSArray*)parseUSAStockDataWithData:(NSData*)data;
+ (NSArray*)parseStockItemNewsWithData:(NSData*)data;
+ (NSArray*)parseStockDataWithData:(NSData*)data;

//StockItem Chart
+ (NSArray*)parseCandleStickXmlWithData:(NSData*)data;
+ (NSArray*)parseTimeChartXmlWithData:(NSData*)data;
+ (NSArray*)parseHKTimeChartXmlWithData:(NSData*)data;

//StockItem Table
+ (NSArray*)parseCNStockTableXmlWithData:(NSData*)data;
+ (NSArray*)parseUSStockTableXmlWithData:(NSData*)data;
+ (NSArray*)parseHKStockTableXmlWithData:(NSData*)data;
+ (NSDictionary*)parseStockInfoXmlWithData:(NSData*)data;
+ (NSDictionary*)parseUSStockInfoXmlWithData:(NSData*)data;

//Fund
+ (NSString*)parseFundTypeXmlWithData:(NSData*)data;
+(NSDictionary*)parseOFFundNetValueXmlWithData:(NSData*)data;
+(NSDictionary*)parseCFFundNetValueXmlWithData:(NSData*)data;
+(NSDictionary*)parseMoneyFundNetValueXmlWithData:(NSData*)data;
+ (NSArray*)parseOFFundChartXmlWithData:(NSData*)data;
+ (NSArray*)parseFundHQXmlWithData:(NSData*)data;
+ (NSArray*)parseOFFundHQXmlWithData:(NSData*)data;

@end
