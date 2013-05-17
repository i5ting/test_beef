//
//  OPNewsContentView.h
//  SinaNews
//
//  Created by fabo on 12-10-22.
//
//

#import <UIKit/UIKit.h>
#import "TextNewsContentView.h"

@protocol  TextContentDelegate;

@interface OPNewsContentView : UIView {
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
@property (nonatomic, assign) BOOL nightMode;
@property (nonatomic, assign) BOOL nonImageMode;
@property (nonatomic, assign) BOOL nonImageModeNoRelaod;

-(void)clear;
-(void)reloadData;
-(void)reloadCommentData;
- (void)setContentFont:(BOOL)isLargeFont;
-(CGFloat)posYOfScroll;
-(void)setScrollToPos:(CGFloat)posY;
@end

