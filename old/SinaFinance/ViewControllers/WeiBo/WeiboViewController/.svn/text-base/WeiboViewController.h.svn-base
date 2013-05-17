//
//  WeiboViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BCViewController.h"

@class BCMultiTabBar;
@class DataListTableView;
@class CommentDataList;

@interface WeiboViewController : BCViewController
{
    BCMultiTabBar* curMultiTabBar;
    DataListTableView* dataTableView;
    CommentDataList* dataList;
    NSMutableArray* selectID;
    CommentDataList* groupList;
    NSArray* groupID;
    NSInteger oldGroupColumn;
    CommentDataList* customGroupList;
    NSArray* customGroupID;
    NSInteger curPage;
    NSInteger countPerPage;
    UIView* errorView;
    BOOL bInitedNotify;
    BOOL initedUI;
}

-(void)exit;

@end
