//
//  WeiboConfigViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataListTableView,CommentDataList,BCMultiTabBar;

@interface WeiboConfigViewController : UIViewController
{
    BCMultiTabBar* curMultiTabBar;
    DataListTableView* dataTableView;
    CommentDataList* dataList;
    NSArray* selectID;
    CommentDataList* groupList;
    NSMutableArray* groupID;
    NSInteger curPage;
    NSInteger curPageType;
    NSInteger countPerPage;
    NSMutableArray* groupValueArray;
    UIButton* addUserBtn;
    BOOL initedUI;
    BOOL bInitedNotify;
    NSMutableArray* removingObjects;
    UIActivityIndicatorView* addIndicator;
    NSMutableArray* addingUserIDs;
}

@property(nonatomic,retain)CommentDataList* groupList;

@end
