//
//  ArticleContentView.h
//  SinaNews
//
//  Created by huangdx on 9/20/10.
//  Copyright 2010 hdx. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "SingleContentViewSetting.h"
#import "VideoInContentView.h"
#import "OPScrollView.h"
#import "News2.h"
@interface MyLabelView : UIWebView

@property(nonatomic,retain)NSString* text;
@property(nonatomic,retain)UIColor* textColor;
@property(nonatomic,retain)UIFont* font;
@property(nonatomic,assign)NSInteger numberOfLines;
@property(nonatomic,assign)BOOL bSourceHtml;
@end

@interface SVCommentModel :NSObject {
    @private
    NSString* authorString;
    NSString* contentString;
    NSDate* createDate;
}

@property(nonatomic,retain)NSString* authorString;
@property(nonatomic,retain)NSString* contentString;
@property(nonatomic,retain)NSDate* createDate;
@end

@interface SVRelativeModel :NSObject {
@private
    NSString* titleString;
    NSString* urlString;
    NSDate* createDate;
}

@property(nonatomic,retain)NSString* titleString;
@property(nonatomic,retain)NSString* urlString;
@property(nonatomic,retain)NSDate* createDate;
@end

@class SVideoModel;

@interface SPagesModel : NSObject {
@private
    NSSet* singlePageSet;
    int totalValue;
}
@property (nonatomic, retain) NSSet* singlePageSet;
@property int totalValue;
@end

@class SSingleNewsModel;
@interface SSinglePageModel : NSObject {
@private
    SPagesModel* pages;
    int indexValue;
    SSingleNewsModel* news;
}
@property (nonatomic, retain) SPagesModel* pages;
@property int indexValue;
@property (nonatomic, assign) SSingleNewsModel* news;

@end

@interface SSingleNewsModel : NSObject {
@private
    NSMutableArray* imagesSet;
    NSString* content;
    NSString* title;
    NSString* declare;
    SVideoModel* video;
    NSDate *createTime;
    NSString *media;
    SSinglePageModel* posPage;
    NSString *url;
    NSString *clickurl;
    NSArray* commentSet;
    NSArray* relativeNewsArray;
    id extraData;
    id titleSymbolData;
}
@property(nonatomic,retain)NSMutableArray* imagesSet;
@property(nonatomic,retain)NSArray* relativeNewsArray;
@property(nonatomic,retain)NSString* content;
@property(nonatomic,retain)NSString* title;
@property(nonatomic,retain)NSString* declare;
@property(nonatomic,retain)SVideoModel* video;
@property(nonatomic,retain)NSDate *createTime;
@property(nonatomic,retain)NSString *media;
@property(nonatomic, retain)SSinglePageModel* posPage;
@property (nonatomic, retain) NSString *url;
@property(nonatomic,retain)NSString *clickurl;
@property(nonatomic,retain)NSArray* commentSet;
@property(nonatomic,retain)id extraData;
@property(nonatomic,retain)id titleSymbolData;
@property(nonatomic,retain)NSString* bottomDeclare;
@end


//正文排版分成三类，普通的，小点大，分页。

typedef enum ContentType
{
	TitleContentType = 0,
    TitleSymbolType,
    DeclareContentType,
    BottomDeclareType,
	CopyrightContentType,
    ClickURLContentType,
    ExtraDataContentType,
    CommentContentType,
    RelativeNewsType,
	ImagesContentType,
	ImageContentType,
	SourceContentType,
	ButtonContentType,
	PhotoTextContentType,
	TextContentType,
	PageNumContentType,
	SeprateLineType,
	VideoContentType,
    TableContentType,
}ContentType;

@class ArticleContentView;
@protocol ArticleContentView_Delegate <NSObject>

-(void)view:(ArticleContentView*)aView imageClicked:(NSString*)imageURL;
-(void)view:(ArticleContentView*)aView clickedMode:(NSInteger)mode;
-(void)view:(ArticleContentView*)aView urlClicked:(NSString*)url;
-(void)view:(ArticleContentView*)aView allCommentClicked:(UIButton*)sender;
-(void)view:(ArticleContentView*)aView relativeURLClicked:(NSString*)url;
-(UIView*)view:(ArticleContentView*)aView extraViewWithData:(id)data margin:(NSInteger)margin width:(NSInteger)width fontSize:(NSInteger)fontSize;
-(UIView*)view:(ArticleContentView*)aView titleSymbolWithData:(id)data margin:(NSInteger)margin width:(NSInteger)width fontSize:(NSInteger)fontSize;
@end

@interface ArticleContentView : UIScrollView <UIScrollViewDelegate> {
	
	SSingleNewsModel* myModel;
	SingleContentViewSetting* mySetting;
	
	//正文分析结果数组
	NSMutableArray *analysisResult;
	
	NSMutableArray *removeImages;
	NSMutableArray *STBImages;
	
	//此数组用于测试，接口提供可以删除
	NSMutableArray *ModelImage;
	
	//view中控件镜像数组，用于更改字体大小
	NSMutableArray *resultCopyArray;
	
	//For memory control
	NSMutableArray *visibleArray;
	NSMutableArray *recycleArray;
	NSMutableArray *allContentArray;
	
	NSMutableArray *ImageWidthArray;
	
	BOOL hasSTBLayout;
	BOOL hasPagingLayout;
	BOOL hasVideoLayout;
	
	NSInteger beginDisplayIndex;
	NSInteger endDisplayIndex;
	
	UIActivityIndicatorView *activeIndicator;
	//UILabel *copyrightLabel;
	UILabel *textLabel;
	UIView *copyrightView;
	//定义分页变量
	NSInteger currentPage;
	NSInteger totalPages;
	NSInteger preArrayConnt;
	CGFloat textFontSize;
	CGFloat titleFontSize;
	CGFloat sourceFontSize;
	CGFloat forwardHeight;
	CGFloat backwardHeight;
	CGFloat lastOffset;
	
	
	CGFloat YPos;
    
    NSMutableArray *tableImages;
    NSMutableArray *tableTexts;
    
    BOOL hadTableLayout;
}
@property (nonatomic, assign) BOOL bHtmlStyle;
@property (nonatomic, assign) BOOL bSourceHtml;
@property (nonatomic, assign) BOOL bDateBeforeSource;
@property (nonatomic, retain) SSingleNewsModel* myModel;
@property (nonatomic, retain) SingleContentViewSetting* mySetting;
@property (nonatomic, assign) id<ArticleContentView_Delegate> imageDelegate;

- (id) initWithFrame:(CGRect)frame
			   model:(SSingleNewsModel*)newModel 
			 setting:(SingleContentViewSetting*)newSetting;

- (void)onLoad;
- (void)reLoadComment;
- (void)setContentFont:(BOOL)isLargeFont;
- (void)analyseContent:(NSString *)content;
//- (void)layoutAuthor:(NSInteger)index;
- (void)layoutTitleAtIndex:(NSInteger)index;
//- (void)refreshImage:(SImageModel *)imageModel;
- (void)LoadNextPageContent:(SSingleNewsModel *)newsModel;

@end
