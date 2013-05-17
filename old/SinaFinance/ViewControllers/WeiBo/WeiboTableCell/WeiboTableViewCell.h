//
//  WeiboTableViewCell.h
//  SinaNews
//
//  Created by shieh exbice on 11-11-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FullWeiboTableViewCell;

@protocol WeiboCell_Delegate <NSObject>

@optional
-(void)cell:(UITableViewCell*)cell imageClicked:(NSString*)imageUrl;
-(void)cell:(UITableViewCell*)cell commentClicked:(UIButton*)sender;
-(void)cell:(UITableViewCell*)cell repostClicked:(UIButton*)sender;
-(void)cell:(UITableViewCell*)cell favoriteClicked:(UIButton*)sender;
-(void)cell:(UITableViewCell*)cell contentClicked:(UIButton*)sender;

@end

@interface FullWeiboTableViewCell : UITableViewCell
{
    NSString* avatar;
    NSString* sourceDevice;
    NSString* nameString;
    NSDate* createDate;
    NSString* contentString;
    NSString* urlString;
    NSInteger repostCount;
    NSInteger commentCont;
    BOOL hasValidate;
    id data;
    BOOL hasInit;
    BOOL repostedFeed;
}

@property(nonatomic,retain)NSString* avatar;
@property(nonatomic,retain)NSString* sourceDevice;
@property(nonatomic,retain)NSString* nameString;
@property(nonatomic,retain)NSDate* createDate;
@property(nonatomic,retain)NSString* contentString;
@property(nonatomic,retain)NSString* urlString;
@property(nonatomic,assign)NSInteger repostCount;
@property(nonatomic,assign)NSInteger commentCont;
@property(nonatomic,assign)BOOL hasValidate;
@property(nonatomic,assign)NSInteger validateType;
@property(nonatomic,assign)BOOL repostedFeed;
@property(nonatomic,retain)id data;
@property(nonatomic,assign)id<WeiboCell_Delegate> delegate;

-(void)reloadData;
-(void)reloadTimeString;
@end
