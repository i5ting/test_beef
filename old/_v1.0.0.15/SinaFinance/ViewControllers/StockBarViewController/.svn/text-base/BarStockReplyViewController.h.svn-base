//
//  BarStockReplyViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataListTableView;
@class CommentDataList;

@interface BarStockReplyViewController : UIViewController
{
    NSString* stockName;
    NSString* stockNick;
    NSString* bid;
    NSString* tid;
    
    DataListTableView* dataTableView;
    CommentDataList* dataList;
    NSMutableArray* selectID;
    NSInteger curPage;
    NSInteger countPerPage;
    BOOL bInited;
}

@property(nonatomic,retain)NSString* stockName;
@property(nonatomic,retain)NSString* stockNick;
@property(nonatomic,retain)NSString* bid;
@property(nonatomic,retain)NSString* tid;

@end
