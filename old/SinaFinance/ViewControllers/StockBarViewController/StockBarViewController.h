//
//  StockBarViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataListTableView;
@class CommentDataList;
@class DropDownTabBar;

@interface StockBarViewController : UIViewController
{
    DataListTableView* dataTableView;
    CommentDataList* dataList;
    NSMutableArray* selectID;
    DropDownTabBar* tabBarView;
    NSInteger curPage;
    NSInteger countPerPage;
    BOOL bInited;
}

@end
