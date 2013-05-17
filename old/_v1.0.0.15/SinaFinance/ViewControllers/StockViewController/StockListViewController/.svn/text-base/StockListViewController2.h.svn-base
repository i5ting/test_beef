//
//  StockListViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushViewController.h"
#import "LoginViewController.h"
@class DataListTableView;
@class CommentDataList;
@class NewsObject;

typedef enum{
    StockListType_MyStock=0,
    StockListType_SHZhangDie,
    StockListType_Guba,
    StockListType_HotUSAStock,
    StockListType_HKStockRanking,
    StockListType_GlobalStock,
    StockListType_Fund,
    StockListType_ForeignExchange,
    StockListType_GlobalProduct,
    StockListType_Search
}StockListType;

typedef enum{
    BarType_None,
    BarType_Fixed,
    BarType_Scroll
}BarType;

typedef enum{
    StringStyle_source = 0,
    StringStyle_dot2,
    StringStyle_symbol_dot2,
    StringStyle_dot2_percent,
    StringStyle_amount,
    StringStyle_dot3,
    StringStyle_symbol_dot3,
    StringStyle_dot3_percent,
    StringStyle_dot4,
    StringStyle_symbol_dot4,
    StringStyle_dot4_percent
}StringStyle;

@interface TableHeaderColumnData : NSObject
{
    CGFloat width;
    NSString* headerString;
}

@property(nonatomic,assign)CGFloat width;
@property(nonatomic,retain)NSString* headerString;

@end



@interface StockListViewController2 : UIViewController
{
    NSArray* requestTypes;
    NSArray* requestshowNames;
    NSString* titleString;
    NSArray* columnDatas;
    NSInteger barType;
    NSInteger subBarType;
    
    DataListTableView* dataTableView;
    CommentDataList* dataList;
    NSMutableArray* selectID;
    NSInteger curPage;
    NSInteger countPerPage;
    BOOL bInited;
    
    NewsObject* configItem;
    
    NSCalendar *_calendar;
    NSDate *_now;
    NSDateComponents *_comps;
    UILabel *_tip;
    UILabel *_tip2;
    NSTimer *_timer;
    //当前天是否为节假日，只需在viewdidload里判断即可
    BOOL _isDateHoloday;
    int multi_bar_cur_index;
}

@property(nonatomic,assign)BOOL isMystockDefaultView;//是否是自选股。
@property(nonatomic,assign)BOOL isMyStockType;//是否是自选股。
@property(nonatomic,retain)NSDictionary* statusDict;

@property(nonatomic,assign)NSInteger barType;
@property(nonatomic,assign)NSInteger subBarType;

- (id)initWithItem:(NewsObject*)oneConfigItem;

+(NSString*)formatFloatString:(NSString*)sourceString style:(NSString*)style;

+ (StockListViewController2 *)sharedInstance;

-(void)initView;
@end
