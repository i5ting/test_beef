//
//  DataListTableView.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentDataList.h"
#import "EGORefreshTableHeaderView.h"
#import "NewsObject.h"
#import "PageTableViewCell.h"

enum DataListPageState
{
    PageState_Normal = 0,
    PageState_Loading,
    PageState_End
};

enum DataListLoadedState
{
    LoadedState_Unkown = -1,
    LoadedState_Err = 0,
    LoadedState_Suc
};

@interface DataListTableView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    id delegate;
    CommentDataList* dataList;
    NSMutableArray* selectID;
    UITableView* tableView;
    EGORefreshTableHeaderView* refreshView;
    BOOL hasPageMode;
    BOOL hasHeaderMode;
    NSInteger pageMode;
    BOOL autoNextPage;
}

@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)NSArray* selectID;
@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)EGORefreshTableHeaderView* refreshView;
@property(nonatomic,retain)UITableView* tableView;
@property(nonatomic,assign)BOOL hasHeaderMode;
@property(nonatomic,assign)BOOL hasPageMode;
@property(nonatomic,assign)NSInteger pageMode;
@property(nonatomic,assign)BOOL autoNextPage;
@property(nonatomic,retain)UILabel* backLabel; //直接赋值，不要设置label的内部属性。
@property(nonatomic,retain)NSString* defaultSucBackString;
@property(nonatomic,retain)NSString* defaultErrBackString;
@property(nonatomic,retain)NSString* defaultLoadingBackString;
@property(nonatomic,assign,readonly)NSArray* objects;

-(void)reloadData;
- (void)doneLoading;
- (void)doneLoadingWithReloadTable:(BOOL)needReload pageEnd:(BOOL)bEnd;
- (void)doneLoadingWithReloadTable:(BOOL)needReload pageEnd:(BOOL)bEnd state:(NSInteger)state;
-(void)startLoadingUI;
-(void)startLoadingUIWithShowHeader:(BOOL)bShowHeader;
-(void)scrollTop:(BOOL)animate;
-(void)scrollEnd:(BOOL)animate;
-(BOOL)checkRefreshByDate:(NSTimeInterval)timeInterval;
@end

@protocol DataListViewDelegate <NSObject>

-(UITableViewCell*)dataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object;
-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object;
@optional
- (NSInteger)dataListView:(DataListTableView*)view numberOfSectionsForObjects:(NSArray*)objects;
-(NSInteger)dataListView:(DataListTableView*)view numberOfRowsInSection:(NSInteger)section;
-(void)dataListView:(DataListTableView*)view didSelectedAtIndexPath:(NSIndexPath*)path object:(NewsObject*)object;
-(BOOL)dataListViewCancelDidMore:(DataListTableView*)view;
-(void)dataListViewDidScroll:(DataListTableView*)view;
-(void)dataListViewWillBeginDragging:(DataListTableView*)view;
-(void)dataListViewDidMoreClicked:(DataListTableView*)view;
-(void)dataListViewDidRefreshTriggered:(DataListTableView*)view;
-(PageTableViewCell*)dataListView:(DataListTableView*)view PageCellStyleIdentifier:(NSString*)identifier;
- (CGFloat)dataListView:(DataListTableView*)view heightForHeaderInSection:(NSInteger)section;
- (NSString *)dataListView:(DataListTableView*)view titleForHeaderInSection:(NSInteger)section;
- (UIView *)dataListView:(DataListTableView*)view viewForHeaderInSection:(NSInteger)section;
- (BOOL)dataListView:(DataListTableView *)view canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCellEditingStyle)dataListView:(DataListTableView *)view editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)dataListView:(DataListTableView *)view commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)dataListView:(DataListTableView *)view canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)dataListView:(DataListTableView *)view moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
@end
