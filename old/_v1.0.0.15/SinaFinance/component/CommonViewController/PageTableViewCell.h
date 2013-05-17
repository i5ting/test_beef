//
//  PageTableViewCell.h
//  SinaNews
//
//  Created by shieh exbice on 11-12-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum PageCellType
{
    PageCellType_Normal = 0,
    PageCellType_Loading,
    PageCellType_Ending
};

@class PageTableViewCell;

@protocol PageTableViewCell_Delegate <NSObject>

-(void)cell:(PageTableViewCell*)cell didclicked:(UIButton*)sender;

@end

@interface PageTableViewCell : UITableViewCell
{
    BOOL hasInit;
    NSInteger type;
    BOOL clickable;
}

@property(nonatomic,assign)id<PageTableViewCell_Delegate> delegate;
@property(nonatomic,retain)NSString* tipString;
@property(nonatomic,retain)UIColor* tipColor;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)BOOL clickable;

-(void)setTipString:(NSString *)tipString forType:(NSInteger)type;
-(void)setTipColor:(UIColor *)tipColor forType:(NSInteger)type;
-(void)reloadData;

@end
