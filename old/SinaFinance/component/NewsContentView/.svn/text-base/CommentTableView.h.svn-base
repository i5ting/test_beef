//
//  CommentTableView.h
//  SinaNews
//
//  Created by shieh exbice on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableCell : UITableViewCell
{
    BOOL hasInit;
}

@property(nonatomic,retain)NSString* titleString;
@property(nonatomic,retain)NSString* contentString;
@property(nonatomic,retain)NSDate* createDate;
@property(nonatomic,assign)NSInteger leftrightmargin;
@property(nonatomic,retain)id data;
-(void)reloadData;
@end

@interface CommentTableView : UIView

@property(nonatomic,assign)BOOL nightMode;
@property(nonatomic,retain)NSArray* dataArray;
@property(nonatomic,assign)NSInteger leftrightMargin;
@property(nonatomic,assign)id delegate;
-(NSInteger)fitHeight;
-(void)reloadData;

@end

@protocol CommentTableView_delegate <NSObject>

-(void)commentTableView:(CommentTableView*)view allContentClicked:(UIButton*)sender;

@end
