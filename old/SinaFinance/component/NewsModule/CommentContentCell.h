//
//  CommentContentCell.h
//  SinaNews
//
//  Created by shieh exbice on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentContentCell;

@protocol CommentContentCell_Delegate <NSObject>

-(void)expandClickedWithCell:(CommentContentCell*)cell; 

@end

@interface CommentContentCell : UITableViewCell
{
    NSArray* mCommentLevels;
    id data;
    BOOL hasInit;
    BOOL mExpandLevel;
    id<CommentContentCell_Delegate> delegate;
}

@property(nonatomic,retain)NSArray* commentLevels;
@property(nonatomic,retain)id data;
@property(nonatomic,assign)BOOL expandLevel;
@property(nonatomic,assign)id<CommentContentCell_Delegate> delegate;

-(NSString*)hideIPWithSourceIP:(NSString*)ipstr;
-(void)reloadData;
-(void)reloadTimeString;
@end
