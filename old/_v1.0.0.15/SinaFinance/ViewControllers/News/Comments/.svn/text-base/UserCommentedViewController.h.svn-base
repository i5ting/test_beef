//
//  UserCommentedViewController.h
//  SinaNews
//
//  Created by shieh exbice on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsObject;
@class DataListTableView;
@class CommentDataList;
@class CommentContentList;

@interface UserCommentedViewController : UIViewController
{
    CommentContentList* mCommentContentList;
    NSString *commentID;
    NewsObject* mNewsObject;
    DataListTableView* dataTableView;
    CommentDataList* dataList;
    NSArray* selectID;
    NSInteger curPage;
    NSInteger curPageType;
    NSInteger countPerPage;
}

@property(nonatomic,retain)NewsObject* newsObject;
@property (nonatomic, retain) NSString *commentID;

- (id)initWithCommentID:(NSString*)comID;

@end
