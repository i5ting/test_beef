//
//  DropDownTabBar.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownTab : UIButton
{
    UIImageView *arrow;
    BOOL hasArrow;
}

@property(nonatomic,retain)id data;
@property(nonatomic,assign)BOOL hasArrow;
@end

@interface DropDownTabBar : UIView
{
    id delegate;
    BOOL hasLoaded;
}

@property(nonatomic,assign)NSInteger curIndex;
@property(nonatomic,assign)NSInteger defautBtnWidth;
@property(nonatomic,assign)NSInteger padding;
@property(nonatomic,assign)NSInteger spacer;
@property(nonatomic,assign)BOOL hasDropDown;
@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)BOOL hasLoaded;

-(void)reloadData;
-(NSString*)titleForIndex:(NSInteger)index;
-(void)setSelected:(NSInteger)index;
-(void)reloadDataWithIndex:(NSNumber*)indexNumber;
@end


@protocol DropDownTabBar_Delegate <NSObject>

-(NSArray*)tabsWithTabBar:(DropDownTabBar*)tabBar;
-(void)tabBar:(DropDownTabBar*)tabBar clickedWithIndex:(NSInteger)index byBtn:(BOOL)byBtn;

@end
