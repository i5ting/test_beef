//
//  ItemPageViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
// 三列的
#import <UIKit/UIKit.h>
#import "DataButton.h"


@interface PageItemCell : DataButton {
@private
    NSInteger curIndex;
    NSString* title;
}
@property(nonatomic,assign)NSInteger curIndex;
@property(nonatomic,retain)NSString* title;

@end

@interface ItemPageView : UIView
{
    NSInteger countPerPage;
    CGSize sizePerItem;
    CGSize paddingSize;
    NSInteger curPage;
    BOOL hasPageControll;
    UIImageView* backImageView;
    id delegate;
}

@property(nonatomic,assign)NSInteger countPerPage;
@property(nonatomic,assign)CGSize sizePerItem;
@property(nonatomic,assign)CGSize paddingSize;
@property(nonatomic,assign)NSInteger curPage;
@property(nonatomic,assign)BOOL hasPageControll;
@property(nonatomic,retain)UIImageView* backImageView;
@property(nonatomic,assign)BOOL sameSapcer;
@property(nonatomic,assign)id delegate;
-(void)reloadData;

@end

@protocol ItemPageView_Delegate <NSObject>

-(PageItemCell*)pageView:(ItemPageView*)view cellWithIndex:(NSInteger)index;
- (NSInteger)numberOfCellsInPageView:(ItemPageView *)view;
-(void)pageView:(ItemPageView*)view cellClickedWithCell:(PageItemCell*)cell byBtn:(BOOL)byBtn;
@end
