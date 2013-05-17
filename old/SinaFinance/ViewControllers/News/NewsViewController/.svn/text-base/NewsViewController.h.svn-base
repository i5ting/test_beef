//
//  NewsViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsIndexFuncPuller.h"
#import "News2.h"
#import "OPScrollView.h"
#import "WorldEyeScrollView.h"
#import "IndexTableViewCell.h"
#import "CurStockStatusView.h"
#import "WorldEyeTableViewCell.h"

@class CommentDataList;
@class TitleDropButton;
@class BCMultiTabBar;
@class DataListTableView;

#define news_index_request_url @"http://platform.sina.com.cn/client/list?app_key=3346933778&partid=1&len=%d&page=%d"
#define news_worldeye_request_url @"http://platform.sina.com.cn/global_eye/wap_api?app_key=3346933778&lastid=%@&size=20"


@interface NewsViewController : UIViewController<OPScrollViewDelegate>
{
    CommentDataList* dataList;
    TitleDropButton *titleBtn;
    UIButton *refreshBtn;
    NSInteger curTitleIndex;
    BCMultiTabBar* curMultiTabBar;
    NSArray* selectID;
    DataListTableView* dataTableView;
    
    CurStockStatusView *_curStockStatusView;
    
//    NewsIndexViewController *_newsIndexViewController;
}


+ (NewsViewController *)sharedInstance;

-(void)update_push_xinwen_num;

@end
