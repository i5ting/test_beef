//
//  CommentTableView.h
//  SinaNews
//
//  Created by shieh exbice on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelativeNewsCell : UITableViewCell
{
    BOOL hasInit;
}

@property(nonatomic,assign)CGFloat textSize;
@property(nonatomic,retain)NSString* titleString;
@property(nonatomic,retain)NSString* contentString;
@property(nonatomic,retain)NSDate* createDate;
@property(nonatomic,assign)NSInteger leftrightmargin;
@property(nonatomic,retain)id data;
-(void)reloadData;
@end

@interface RelativeNewsTableView : UIView

@property(nonatomic,retain)NSArray* dataArray;
@property(nonatomic,assign)NSInteger leftrightMargin;
@property(nonatomic,assign)CGFloat titleSize;
@property(nonatomic,assign)CGFloat textSize;
@property(nonatomic,assign)id delegate;
-(NSInteger)fitHeight;
-(void)reloadData;
@property(nonatomic,assign)BOOL nightMode;

@end

@protocol RelativeNewsTableView_delegate <NSObject>

-(void)RelativeNewsTableView:(RelativeNewsTableView*)view relativeURLClicked:(NSString*)url;

@end
