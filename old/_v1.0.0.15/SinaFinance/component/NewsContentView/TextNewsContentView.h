//
//  TextNewsContentView.h
//  SinaNews
//
//  Created by shieh exbice on 11-11-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleContentViewSetting.h"
#import "VideoItemInContentView.h"
#import "ArticleContentView.h"
#import "OPNewsContentView.h"

@class TextNewsContentView;

@protocol TextContentDelegate <NSObject,UIScrollViewDelegate>

-(void)viewClicked:(TextNewsContentView*)view;
-(void)view:(TextNewsContentView*)aView imageClicked:(NSString*)imageURL;
-(void)view:(TextNewsContentView*)aView urlClicked:(NSString*)url;
-(void)view:(TextNewsContentView*)aView allCommentClicked:(UIButton *)sender;
-(void)view:(TextNewsContentView*)aView relativeURLClicked:(NSString*)url;
-(UIView*)view:(TextNewsContentView*)aView extraViewWithData:(id)data margin:(NSInteger)margin width:(NSInteger)width fontSize:(NSInteger)fontSize;
-(UIView*)view:(TextNewsContentView*)aView titleSymbolWithData:(id)data margin:(NSInteger)margin width:(NSInteger)width fontSize:(NSInteger)fontSize;
@end

@interface NormalNewsContentView : UIView {
    NSString* titleString;
    NSDate* createDate;
    NSString* media;
    NSArray* picURLArray;
    NSString* contentString;
    id<TextContentDelegate> delegate;
}

@property(nonatomic,assign)id<TextContentDelegate> delegate;
@property(nonatomic,retain)NSString* titleString;
@property(nonatomic,retain)NSDate* createDate;
@property(nonatomic,retain)NSString* media;
@property(nonatomic,retain)NSString* declare;
@property(nonatomic,retain)NSString* preMedia;
@property(nonatomic,retain)NSString* clickurl;
@property(nonatomic,retain)NSArray* picURLArray;
@property(nonatomic,retain)NSArray* commentArray;
@property(nonatomic,retain)NSArray* relativeNewsArray;
@property(nonatomic,retain)VideoData* videoData;
@property(nonatomic,retain)id extraData;
@property(nonatomic,retain)id titleSymbolData;
@property(nonatomic,retain)NSString* contentString;
@property(nonatomic,retain)SingleContentViewSetting* setting;
@property(nonatomic,assign)BOOL bHtmlStyle;
@property(nonatomic,assign)BOOL bSourceHtml;
@property (nonatomic, assign) BOOL bDateBeforeSource;
@property(nonatomic,retain)NSString* bottomDeclare;

-(void)clear;
-(void)reloadData;
-(void)reloadCommentData;
- (void)setContentFont:(BOOL)isLargeFont;
@end


@interface TextNewsContentView : UIScrollView
{
    NSString* titleString;
    NSDate* createDate;
    NSString* media;
    NSArray* picURLArray;
    NSString* contentString;
    id<TextContentDelegate> delegate;
    
@private
    NSMutableArray* imageViewArray;
    NSMutableArray* imageClickArray;
    NSMutableArray* picLabelArray;
}

@property(nonatomic,assign)id<TextContentDelegate> delegate;
@property(nonatomic,retain)NSString* titleString;
@property(nonatomic,retain)NSDate* createDate;
@property(nonatomic,retain)NSString* media;
@property(nonatomic,retain)NSString* declare;
@property(nonatomic,retain)NSString* preMedia;
@property(nonatomic,retain)NSString* clickurl;
@property(nonatomic,retain)NSArray* picURLArray;
@property(nonatomic,retain)NSArray* commentArray;
@property(nonatomic,retain)NSArray* relativeNewsArray;
@property(nonatomic,retain)VideoData* videoData;
@property(nonatomic,retain)id extraData;
@property(nonatomic,retain)id titleSymbolData;
@property(nonatomic,retain)NSString* contentString;
@property(nonatomic,retain)SingleContentViewSetting* setting;
@property(nonatomic,retain)NSString* info1String;
@property(nonatomic,retain)NSString* info2String;
@property(nonatomic,assign)BOOL bHtmlStyle;
@property(nonatomic,assign)BOOL bSourceHtml;
@property (nonatomic, assign) BOOL bDateBeforeSource;
@property(nonatomic,retain)NSString* bottomDeclare;

-(void)clear;
-(void)reloadData;
-(void)reloadCommentData;
- (void)setContentFont:(BOOL)isLargeFont;

@end

