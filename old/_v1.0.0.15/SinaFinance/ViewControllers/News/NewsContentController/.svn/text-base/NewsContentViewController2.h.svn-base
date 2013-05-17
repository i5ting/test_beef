//
//  NewsContentViewController.h
//  SinaFinance
//
//  Created by Du Dan on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextNewsContentView.h"

#define NEWSCONTENT_TITLE_KEY @"NewsContentTitle"
#define NEWSCONTENT_URL_KEY @"NewsContentURL"
#define NEWSCONTENT_SOURCE_KEY @"NewsContentSource"
#define NEWSCONTENT_DATE_KEY @"NewsContentDate"
#define NEWSCONTENT_DESC_KEY @"NewsContentDescription"
#define NEWSCONTENT_COMMENTID_KEY @"NewsCommentID"
#define NEWSCONTENT_COMMENTNUM_KEY @"NewsCommentNum"
#define NEWSCONTENT_VideoImg @"NewsVideoImg"
#define NEWSCONTENT_VideoVid @"NewsVideoVid"


#define NEWSIMAGE_URL_KEY @"NewsImageUrl"
#define NEWSIMAGE_TITLE_KEY @"NewsImageTitle"
#define NEWSIMAGE_HEIGHT_KEY @"NewsImageHeight"
#define NEWSIMAGE_WIDTH_KEY @"NewsImageWidth"

@class LoadingView2;
@class LoadingErrorView;
@class inputShowController;
@class ASIHTTPRequest;
@class NormalNewsContentView;

typedef enum{
    kNewsContentNormal,
    kNewsContentNormal2,
    kNewsContentSearch,
}NewsContentType;

@interface NewsContentViewController2 : UIViewController <UITextFieldDelegate>
{
    UIScrollView *contentScrollView;
    NormalNewsContentView* contentNormalView;
    TextNewsContentView *contentTextView;
    UIButton *readComments;
//    UIWebView *contentTextView;
    NSDictionary *contentDict;
    
    NSInteger currentFontSize;
//    UIButton *smallFntBtn;
//    UIButton *bigFntBtn;
    
    LoadingView2 *loadingView;
    LoadingErrorView *errorView;
    
    NSArray *imagesArray;
    NSMutableArray *imageTextArray;
    
    UIView *bottomView;
    
    inputShowController* inputController;
    
    ASIHTTPRequest *asiRequest;
    NSString* sourceURL;
    BOOL isAlertShown;
}
@property (nonatomic, retain) NSString* commentCount;
@property (nonatomic, retain) NSString* sourceURL;
@property (nonatomic, assign) id delegate;

- (id)initWithNewsID:(NSString*)nID;
- (id)initWithWapURL:(NSString*)urlString;
- (id)initWithNewsURL:(NSString*)urlString;//For searching
- (id)initWithNewsURL2:(NSString*)urlString;
- (id)initWithNewsURL3:(NSString*)urlString; //For http://t.cn/* 短郁闷

@end

@protocol NewsController_Delegate <NSObject>

-(void)controllerBackClicked:(UIViewController*)controller;

@end
