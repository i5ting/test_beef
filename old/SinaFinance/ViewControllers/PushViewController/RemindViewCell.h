//
//  RemindViewCell.h
//  SinaNews
//
//  Created by shieh exbice on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RemindViewCell;

@protocol RemindViewCell_Delegate <NSObject>

-(void)cell:(RemindViewCell*)cell closeClicked:(id)data;

@end

@interface RemindViewCell : UITableViewCell
{
    NSString* nameString;
    NSDate* createDate;
    id data;
    BOOL hasInit;
}

@property(nonatomic,retain)NSString* nameString;
@property(nonatomic,retain)NSDate* createDate;
@property(nonatomic,retain)id data;
@property(nonatomic,assign)id<RemindViewCell_Delegate> delegate;
@property(nonatomic,assign)BOOL hideRemove;
@property(nonatomic,assign)BOOL is_has_readed;

-(void)reloadData;


-(void)set_has_readed_avatar:(BOOL)is_readed;

@end
