//
//  NewsContentViewController.m
//  SinaFinance
//
//  Created by Du Dan on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsContentViewController2.h"
#import "ShareData.h"   
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "NewsXmlParser.h"
#import "MyCustomToolbar.h"
#import "LoadingView.h"
#import "LoadingErrorView.h"
#import "UIImageView+WebCache.h"
#import "RegexKitLite.h"
#import "inputShowController.h"
#import "UserCommentedViewController.h"
#import "ComposeWeiboViewController.h"
#import "LoginViewController.h"
#import "Util.h"
#import "TextNewsContentView.h"
#import "NewsObject.h"
#import "MyTool.h"
#import "NormalImageViewController.h"
#import "WeiboFuncPuller.h"
#import "NewsFuncPuller.h"
#import "NewsFavoritePuller.h"
#import "LKTipCenter.h"
#import "LKWebViewController.h"
#import "CommentTableView.h"

//#define NEWS_CONTENT_URL @"http://data.3g.sina.com.cn/api/art.php?id=%@&version=2"//http://10.210.74.95:9999/news/content
#define NEWS_CONTENT_URL @"http://api.news.sina.com.cn/news/content?auth_type=uuid&auth_id=%@&format=xml&mode=cooked&wapurl=%@&fromID=60219010"
//#define NEWS_CONTENT_URL @"http://10.210.74.95:9999/news/content?auth_type=uuid&auth_id=%@&format=xml&mode=cooked&wapurl=%@&fromID=60219010"
#define NEWS_SEARCH_CONTENT_URL @"http://api.news.sina.com.cn/news/content?auth_type=uuid&auth_id=%@&format=xml&mode=cooked&url=%@&fromID=60219010"//&deviceID=%@"
#define NEWS3_CONTENT_URL @"http://api.news.sina.com.cn/news/content?short_url=%@&format=json&mode=cooked"
#define NEWS2_CONTENT_URL @"http://api.news.sina.com.cn/news/content?url=%@&format=json&mode=cooked"

#define SMALL_FONTSIZE 12
#define BIG_FONTSIZE 20

@interface NewsContentViewController2()
@property (nonatomic, retain) inputShowController* inputController;
//@property (nonatomic, retain) NSArray *imagesArray;
@property (nonatomic, retain) NSMutableArray *imageTextArray;
@property (nonatomic, retain) UIView *bottomView;

- (void)loadSubViews;
- (NSString*)analyseTextContent:(NSString*)original;
- (void)showNewsContentWithImages;
-(void)backgroundBtnClicked:(UIButton*)sender;

@end

@implementation NewsContentViewController2
{
    BOOL bInited;
}

@synthesize inputController;
@synthesize imageTextArray;
@synthesize sourceURL;
@synthesize delegate;
@synthesize bottomView;
@synthesize commentCount;

- (void)requestDataFromURL:(NSURL*)url type:(NewsContentType)type cache:(BOOL)useCache
{
    NSLog(@"newscontent url: %@", [url absoluteString]);

    if(url == nil) return;
    
    [errorView removeFromSuperview];
    [self.view addSubview:loadingView];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:type],@"NewsContentType", nil];
    [dict setValue:[NSNumber numberWithBool:useCache] forKey:@"cache"];
    [dict setValue:url forKey:@"url"];
    
    if (asiRequest) {
        [asiRequest clearDelegatesAndCancel];
        asiRequest = nil;
    }
    asiRequest = [[ASIHTTPRequest alloc] initWithURL:url];
    asiRequest.delegate = self;
    [asiRequest addRequestHeader:@"Accept-Encoding" value:@"gzip"];
    [asiRequest startAsynchronous];
    asiRequest.userInfo = dict;
    
    
    ASIDownloadCache *cache = [ASIDownloadCache sharedCache];
    [asiRequest setDownloadCache:cache];
    [asiRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    if (useCache) {
        [asiRequest setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    }
    [asiRequest setSecondsToCache:60*60*24*30]; // Cache for 30 days
}

#pragma mark
#pragma mark ASIHTTPRequest Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [loadingView removeFromSuperview];
    NSString* requstString = request.responseString;
    NSDictionary *dict = request.userInfo;
    NewsContentType type = [[dict objectForKey:@"NewsContentType"] intValue];
    NSNumber* cacheNumber = [dict objectForKey:@"cache"];
    NSURL* url = [dict objectForKey:@"url"];
    
    NSArray *array = nil;
    if(type == kNewsContentNormal){
        if([NewsXmlParser parseNewsContentXmlWithData:request.responseData]){
            array = [NSArray arrayWithArray:[NewsXmlParser parseNewsContentXmlWithData:request.responseData]];
        }
    }
    else if(type == kNewsContentSearch){
        if([NewsXmlParser parseSearchContentXmlWithData:request.responseData]){
            array = [NSArray arrayWithArray:[NewsXmlParser parseSearchContentXmlWithData:request.responseData]];
            if(imagesArray){
                [imagesArray release];
                imagesArray = nil;
            }
            imagesArray = [[NewsXmlParser parseNewsContentImagesWithData:request.responseData] retain];
        }
    }
    if(type == kNewsContentNormal2){
        if([NewsXmlParser parseNewsContent2XmlWithData:request.responseData]){
            array = [NSArray arrayWithArray:[NewsXmlParser parseNewsContent2XmlWithData:request.responseData]];
            if(imagesArray){
                [imagesArray release];
                imagesArray = nil;
            }
            imagesArray = [[NewsXmlParser parseNewsContent2ImagesWithData:request.responseData] retain];
        }
    }
    
    if(array){
        if(errorView){
            [errorView removeFromSuperview];
        }
        [contentDict release];
        contentDict = nil;
        contentDict = [[array objectAtIndex:0] retain];
        
        [self loadContents];
        //[self loadSubViews];
        [self getComments];
    }
    else{
        if ([cacheNumber boolValue]) {
            [self requestDataFromURL:url type:type cache:NO];
        }
        else
        {
            if(errorView == nil){
                errorView = [[LoadingErrorView alloc] initWithFrame:CGRectMake(0, 44, 320, UI_MAX_HEIGHT -110)];
            }
            errorView.customTipString = @"抱歉，该新闻内容为空。";
            [self.view addSubview:errorView];
        }
    }
}

-(void)loadContents
{
    NSString* newCommentCount = @"0";
    if (commentCount) {
        newCommentCount = commentCount;
    }
    NSString* commentCountFromContent = [contentDict objectForKey:NEWSCONTENT_COMMENTNUM_KEY];
    if (commentCountFromContent) {
        if ([commentCountFromContent intValue]>[newCommentCount intValue]) {
            newCommentCount = commentCountFromContent;
        }
    }
    NSString* formantCommentCount = [NSString stringWithFormat:@"评论(%@)",newCommentCount];
    [readComments setTitle:formantCommentCount forState:UIControlStateNormal];
    
    [readComments sizeToFit];
    CGRect readCommentsRect = readComments.frame;
    readCommentsRect.origin.x = 320 - readCommentsRect.size.width - 15;
    readCommentsRect.origin.y = 44/2 - readCommentsRect.size.height/2;
    readComments.frame = readCommentsRect;
    
    if (!contentNormalView) {
        contentNormalView = [[OPNewsContentView alloc] initWithFrame:CGRectMake(0, 44, 320, UI_MAX_HEIGHT -110)];
        contentNormalView.delegate = self;
        [self.view addSubview:contentNormalView];
    }
    else
    {
        [contentNormalView clear];
    }
    
    NSString* title = [contentDict valueForKey:NEWSCONTENT_TITLE_KEY];
    contentNormalView.titleString = title;
    NSString* content = [contentDict valueForKey:NEWSCONTENT_DESC_KEY];
    contentNormalView.contentString = content;
    NSString* mediaStr = [contentDict valueForKey:NEWSCONTENT_SOURCE_KEY];
    contentNormalView.media = mediaStr;
    NSString* createTimeStr = [contentDict valueForKey:NEWSCONTENT_DATE_KEY];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* newFormatDate = [formater dateFromString:createTimeStr];
    contentNormalView.createDate = newFormatDate;
    [formater release];
    NSMutableArray* picArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int imgIndex=0; imgIndex<[imagesArray count]; imgIndex++) {
        NSString *imgUrl = [[imagesArray objectAtIndex:imgIndex] objectForKey:NEWSIMAGE_URL_KEY];
        NSString *title = [[imagesArray objectAtIndex:imgIndex] objectForKey:NEWSIMAGE_TITLE_KEY];
        NSInteger imgWidth = [[[imagesArray objectAtIndex:imgIndex] objectForKey:NEWSIMAGE_WIDTH_KEY] intValue];
        NSInteger imgHeight = [[[imagesArray objectAtIndex:imgIndex] objectForKey:NEWSIMAGE_HEIGHT_KEY] intValue];
        if ([MyTool isRetina]) {
            imgWidth = imgWidth/2;
            imgHeight = imgHeight/2;
        }
        ImageURLData* urlData = [[ImageURLData alloc] init];
        urlData.imageURL = imgUrl;
        urlData.imageTitle = title;
        urlData.imageSize = CGSizeMake(imgWidth, imgHeight);
        [picArray addObject:urlData];
        [urlData release];
    }
    
    contentNormalView.picURLArray = picArray;
    
    NSString* videoVid = [contentDict valueForKey:NEWSCONTENT_VideoVid];
    NSString* videoImg = [contentDict valueForKey:NEWSCONTENT_VideoImg];
    if (videoVid&&![videoVid isEqualToString:@""]&&![videoVid isEqualToString:@"0"]) {
        VideoData* newData = [[VideoData alloc] init];
        newData.videoURL = videoVid;
        newData.imageURL = videoImg;
        contentNormalView.videoData = newData;
        [newData release];
    }
    [contentNormalView reloadData];
    [picArray release];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [loadingView removeFromSuperview];
    if(errorView == nil){
        errorView = [[LoadingErrorView alloc] initWithFrame:CGRectMake(0, 44, 320,460- self.bottomView.bounds.size.height-44)];
    }
    [self.view addSubview:errorView];
}

- (void)reframeScrollView
{
    CGRect frame = contentTextView.frame;
    frame.size.height = contentTextView.contentSize.height;
    contentTextView.frame = frame;
    [contentScrollView addSubview:contentTextView];
    
    contentScrollView.contentSize = CGSizeMake(320, contentTextView.frame.origin.y + contentTextView.contentSize.height);
}

- (NSString*)analyseTextContent:(NSString*)original
{
    //NSString *newContent = [[NSString alloc] init];
//    imageTextArray = [[NSMutableArray alloc] init];
    
    NSArray *componentOne = [original componentsSeparatedByString:@"{{"];
    
    if(componentOne.count == 1){
        return original;
    }
    
    NSInteger index = 0;
    NSInteger imgInContent = 0;
    for(NSString *subContentOne in componentOne){
        if(subContentOne.length > 1){
            NSArray *componentTwo = [subContentOne componentsSeparatedByString:@"}}"];
            if(componentTwo.count > 1){//It is image text
                if(index < componentOne.count - 1){
                    NSInteger imageIndex = [[componentTwo objectAtIndex:0] intValue];
                    NSLog(@"image index: %d", imageIndex);
                    [imageTextArray addObject:[NSString stringWithFormat:@"image:%d",imageIndex]];
                    imgInContent++;
                    NSString *imageText = [componentTwo lastObject];
                    NSArray *separatedByEnter = [imageText componentsSeparatedByString:@"\n"];
                    for(NSString *subString in separatedByEnter){
                        if([subString length] > 1){
                            [imageTextArray addObject:subString];
                        }
                    }
                }
                else{
                    NSInteger imageIndex = [[componentTwo objectAtIndex:0] intValue];
                    //NSLog(@"image index: %d", imageIndex);
                    [imageTextArray addObject:[NSString stringWithFormat:@"image:%d",imageIndex]];
                    imgInContent++;
                    NSArray *separatedByEnter = [[componentTwo lastObject] componentsSeparatedByString:@"\n"];
                    for(NSString *subString in separatedByEnter){
                        if([subString length] > 1){
                            subString = [subString stringByReplacingOccurrencesOfString:@" " withString:@""];
                            [imageTextArray addObject:subString];
//                            NSLog(@"subString: %@\n", subString);
                        }
                    }
                    //newContent = [separatedByEnter lastObject];
                }
            }
            else{
                [imageTextArray addObject:[componentTwo lastObject]];
            }
        }
        index++;
    }
    
    //    for (int i = imgInContent+1; i < imagesArray.count; i++) {
    //        [stbImages addObject:[imagesArray objectAtIndex:i]];
    //        NSLog(@"stbImages: %@\n", [imagesArray objectAtIndex:i]);
    //    }
    
    return nil;//[newContent autorelease];
}

- (void)reloadTextGraphics:(NSInteger)winWidth
{
    NSInteger height = 80;//contentTextView.frame.origin.y;
    NSInteger index = 0;
    BOOL previousIsImage = NO;
    for(UIView *subView in contentScrollView.subviews){
        //if(index < imageTextArray.count){
        if([subView isKindOfClass:[UITextView class]]){
            UITextView *textView = (UITextView*)subView;
            textView.editable = NO;
            CGRect frame = textView.frame;
            textView.frame = CGRectMake(frame.origin.x, height, winWidth - 20, frame.size.height);
            frame = textView.frame;
            frame.size.height = textView.contentSize.height;
            textView.frame = frame;
            height += textView.contentSize.height;
            previousIsImage = NO;
            //NSLog(@"textview height: %f", textView.contentSize.height);
        }
        else if([subView isKindOfClass:[UIImageView class]]){
            UIImageView *imgView = (UIImageView*)subView;
            CGRect frame = imgView.frame;
            frame.origin.x = (winWidth - frame.size.width) / 2;
            if(previousIsImage){
                frame.origin.y = height + 20;
            }
            else{
                frame.origin.y = height;
            }
            imgView.frame = frame;
            if(previousIsImage){
                height += frame.size.height + 20;
            }
            else{
                height += frame.size.height;
            }
            previousIsImage = YES;
            //NSLog(@"image height: %f", frame.size.height);
        }
        //}
        index++;
    }
//    textGraphicsHeight = height;
//    NSLog(@"textGraphicsHeight: %i", textGraphicsHeight);
}

- (void)showNewsContentWithImages
{
    BOOL isImageInserted = NO;
    NSInteger imgIndex = 0;
    NSInteger height = 80;
    NSString *imageTitle = @"";
    for (int i = 0; i < imageTextArray.count; i++) {
        if([[imageTextArray objectAtIndex:i] hasPrefix:@"image"]){
            //Get the image index
            NSArray *array = [[imageTextArray objectAtIndex:i] componentsSeparatedByString:@":"];
            imgIndex = [[array lastObject] intValue] - 1;
            
            NSString *imgUrl = [[imagesArray objectAtIndex:imgIndex] objectForKey:NEWSIMAGE_URL_KEY];
            NSString *title = [[imagesArray objectAtIndex:imgIndex] objectForKey:NEWSIMAGE_TITLE_KEY];
            NSInteger imgWidth = [[[imagesArray objectAtIndex:imgIndex] objectForKey:NEWSIMAGE_WIDTH_KEY] intValue] / 2;
            NSInteger imgHeight = [[[imagesArray objectAtIndex:imgIndex] objectForKey:NEWSIMAGE_HEIGHT_KEY] intValue] / 2;
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
//            [imageView setImageWithURL:[NSURL URLWithString:imgUrl]];
            imageView.frame = CGRectMake((self.view.frame.size.width-imgWidth)/2, height, imgWidth, imgHeight);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            //            [imageView.layer setBorderColor:[UIColor grayColor].CGColor];
            //            [imageView.layer setBorderWidth:2.0];
            [contentScrollView addSubview:imageView];
            [imageView release];
            height += imgHeight;
            
            if(title){
                UITextView *titleView = [[[UITextView alloc] init] autorelease];
                //UILabel *titleView = [[[UILabel alloc] init] autorelease];
                titleView.text = title;
                //titleView.editable = NO;
                //titleView.scrollEnabled = NO;
                titleView.backgroundColor = [UIColor clearColor];
                titleView.frame = CGRectMake(0, height, 320, 30);
                titleView.font = [UIFont fontWithName:APP_FONT_NAME size:12];
                titleView.textAlignment = UITextAlignmentCenter;
                titleView.textColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0];
                [contentScrollView addSubview: titleView];
                height += titleView.frame.size.height;
                imageTitle = title;
            }
            isImageInserted = YES;
        }
        else{
            //if([[imageTextArray objectAtIndex:i] rangeOfString:imageTitle].location == NSNotFound){
            //if(![[imageTextArray objectAtIndex:i] hasPrefix:imageTitle] || ![[imageTextArray objectAtIndex:i] hasSuffix:imageTitle] || ![[imageTextArray objectAtIndex:i] isEqualToString:imageTitle]){
            if(isImageInserted == NO){
                UITextView *imageText = [[[UITextView alloc] init] autorelease];
                imageText.backgroundColor = [UIColor clearColor];
                imageText.font = [UIFont fontWithName:APP_FONT_NAME size:14];
                imageText.textAlignment = UITextAlignmentLeft;
                imageText.editable = NO;
                imageText.text = [imageTextArray objectAtIndex:i];
                imageText.textColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0];
                imageText.contentMode = UIViewContentModeScaleAspectFit;
                [contentScrollView addSubview: imageText];
                imageText.frame = CGRectMake(10, height, 300, imageText.contentSize.height);
                imageText.scrollEnabled = NO;
                height += imageText.contentSize.height;
            }
            //height += 30;
            isImageInserted = NO;
        }
    } 
    contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, height + 50);
}

- (NSString*)formatNewsContent:(NSString*)content
{
    NSArray *strings = [content componentsSeparatedByString:@"\n"];
    NSString *newContent = [[NSString alloc] init];
    for(NSString *subString in strings){
        if(subString.length > 1){
//            NSLog(@"subString: %@", subString);
            newContent = [newContent stringByAppendingFormat:@"%@\n",subString];
        }
    }
    return [newContent autorelease];
}

- (void)loadSubViews
{
    imageTextArray = [[NSMutableArray alloc] init];

    NSString* newCommentCount = @"0";
    if (commentCount) {
        newCommentCount = commentCount;
    }
    NSString* commentCountFromContent = [contentDict objectForKey:NEWSCONTENT_COMMENTNUM_KEY];
    if (commentCountFromContent) {
        if ([commentCountFromContent intValue]>[newCommentCount intValue]) {
            newCommentCount = commentCountFromContent;
        }
    }
    NSString* formantCommentCount = [NSString stringWithFormat:@"评论(%@)",newCommentCount];
    [readComments setTitle:formantCommentCount forState:UIControlStateNormal];
    contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, UI_MAX_HEIGHT -110)];
    contentScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentScrollView];
    
    NSString *title = [contentDict objectForKey:NEWSCONTENT_TITLE_KEY];
    NSString *date = [contentDict objectForKey:NEWSCONTENT_DATE_KEY];
    NSString *source = [contentDict objectForKey:NEWSCONTENT_SOURCE_KEY];
    NSString *content = [contentDict objectForKey:NEWSCONTENT_DESC_KEY];
    
    //content = [self formatNewsContent:content];
    //NSSet *trimSet = [NSSet setWithObjects:@"{|TABLE",@"|-",@"|}", nil];
    content = [content stringByReplacingOccurrencesOfString:@"{|TABLE" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"|-" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"|}" withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"||" withString:@""];
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *myregex = @"<[^>]*>"; //regex to remove any html tag
    content = [content stringByReplacingOccurrencesOfRegex:myregex withString:@""];
    
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 40)] autorelease];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:16];
    CGSize titleSize = [title sizeWithFont:titleLabel.font];
    NSLog(@"titleSize.width: %f", titleSize.width);
    if(titleSize.width > 300){
//        NSMutableString *twoRowTitle = [[[NSMutableString alloc] initWithString:title] autorelease];
//        [twoRowTitle insertString:@"\n" atIndex:title.length/2];
        CGRect frame = titleLabel.frame;
        frame.size.width = titleSize.width / 2 + 10;
        frame.origin.x = (320 - frame.size.width) / 2;
        titleLabel.frame = frame;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.textAlignment = UITextAlignmentLeft;
//        titleLabel.text = twoRowTitle;
    }
    else{
        titleLabel.textAlignment = UITextAlignmentCenter;
    }
    titleLabel.numberOfLines = 2;
    [contentScrollView addSubview:titleLabel];
    
    UILabel *infoLabel = [[[UILabel alloc] initWithFrame:CGRectMake(5, 50, 310, 20)] autorelease];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.text = [NSString stringWithFormat:@"%@ %@", source,date];
    infoLabel.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1.0];
    infoLabel.font = [UIFont fontWithName:APP_FONT_NAME size:10];
    infoLabel.textAlignment = UITextAlignmentCenter;
    [contentScrollView addSubview:infoLabel];
    
    contentTextView = (TextNewsContentView *)[[UITextView alloc] initWithFrame:CGRectMake(5, 60, 310, UI_MAX_HEIGHT -110)];
//    contentTextView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 60, 310, UI_MAX_HEIGHT -110)];
    contentTextView.backgroundColor = [UIColor clearColor];
//    [contentTextView loadHTMLString:content baseURL:nil];
//    contentTextView.textColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1.0];
//    contentTextView.font = [UIFont fontWithName:APP_FONT_NAME size:currentFontSize];
    CGRect frame = contentTextView.frame;
    frame.size.height = contentTextView.contentSize.height;
    contentTextView.frame = frame;
//    contentTextView.editable = NO;
    contentTextView.scrollEnabled = NO;
    //contentScrollView.contentSize = CGSizeMake(320, 40 + 20 + contentTextView.contentSize.height);
    
    [self analyseTextContent:content];
    if(imagesArray.count > 0 && imageTextArray.count > 0){
        [self showNewsContentWithImages];
        [self reloadTextGraphics:320];
    }
    else{
        NSInteger height = contentTextView.frame.origin.y + 30;
        if(imagesArray.count > 0){
            for(NSDictionary *dict in imagesArray){
                NSString *imgUrl = [dict objectForKey:NEWSIMAGE_URL_KEY];
//                NSString *title = [dict objectForKey:NEWSIMAGE_TITLE_KEY];
                NSInteger imgWidth = [[dict objectForKey:NEWSIMAGE_WIDTH_KEY] intValue] / 2;
                NSInteger imgHeight = [[dict objectForKey:NEWSIMAGE_HEIGHT_KEY] intValue] / 2;
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
                //            [imageView setImageWithURL:[NSURL URLWithString:imgUrl]];
                imageView.frame = CGRectMake((self.view.frame.size.width-imgWidth)/2, height, imgWidth, imgHeight);
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                //            [imageView.layer setBorderColor:[UIColor grayColor].CGColor];
                //            [imageView.layer setBorderWidth:2.0];
                [contentScrollView addSubview:imageView];
                [imageView release];
                height += imgHeight + 20;
            }
        }
        if(imageTextArray.count > 0){
            NSString *content = @"";
            for(NSString *item in imageTextArray){
                if(![item hasPrefix:@"image"]){
                    content = [content stringByAppendingFormat:@"%@\n",item];
                }     
            }
//            contentTextView.text = content;
        }
        else{
//            contentTextView.text = content;
        }
        CGRect frame = contentTextView.frame;
        frame.origin.y = height;
        contentTextView.frame = frame;
        [contentScrollView addSubview:contentTextView];
        [self reframeScrollView];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapTextField)];
    
    //modify this number to recognizer number of tap
    [singleTap setNumberOfTapsRequired:1];
    [contentScrollView addGestureRecognizer:singleTap];
    [singleTap release];
}

- (id)initWithNewsID:(NSString*)nID
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:NEWS_CONTENT_URL, nID]];
        [self requestDataFromURL:url type:kNewsContentNormal cache:YES];
    }
    return self;
}

- (id)initWithWapURL:(NSString*)urlString
{
    self = [super init];
    if (self) {
        self.sourceURL = urlString;
        NSString *encodeURL = [Util urlencode:urlString];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:NEWS_CONTENT_URL, constant_ipad_uuid, encodeURL]];
        [self requestDataFromURL:url type:kNewsContentSearch cache:YES];
    }
    return self;
}

- (id)initWithNewsURL:(NSString*)urlString
{
    self = [super init];
    if (self) {
        self.sourceURL = urlString;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:NEWS_SEARCH_CONTENT_URL, constant_ipad_uuid, urlString]];
        [self requestDataFromURL:url type:kNewsContentSearch cache:YES];
    }
    return self;
}

- (id)initWithNewsURL2:(NSString*)urlString
{
    self = [super init];
    if (self) {
        self.sourceURL = urlString;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:NEWS2_CONTENT_URL, urlString]];
        [self requestDataFromURL:url type:kNewsContentNormal2 cache:YES];
    }
    return self;
}

- (id)initWithNewsURL3:(NSString*)urlString
{
    self = [super init];
    if (self) {
        self.sourceURL = urlString;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:NEWS3_CONTENT_URL, urlString]];
        [self requestDataFromURL:url type:kNewsContentNormal2 cache:YES];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [sourceURL release];
    [asiRequest clearDelegatesAndCancel];
    [asiRequest release];
    if(contentScrollView){
        [contentScrollView release];
    }
    if(contentTextView){
        [contentTextView release];
    }
    if(contentDict){
        [contentDict release];
    }
    [contentNormalView release];
    [loadingView release];
////    [smallFntBtn release];
////    [bigFntBtn release];
//    [errorView release];
    if(imagesArray){
        [imagesArray release];
    }
    if(imageTextArray){
        [imageTextArray release];
    }
    [bottomView release];
//    if(inputController){
//        [inputController release];
//    }
    [commentCount release];
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)initToolbar
{
    MyCustomToolbar *topToolbar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    [self.view addSubview:topToolbar];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:backBtn];
    
    readComments = [UIButton buttonWithType:UIButtonTypeCustom];
    readComments.frame = CGRectMake(190, 7, 120, 30);
//    [readComments setBackgroundImage:[UIImage imageNamed:@"toolbar_btn_bg.png"] forState:UIControlStateNormal];
    readComments.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:16];
    readComments.titleLabel.textAlignment = UITextAlignmentRight;
    readComments.titleLabel.contentMode = UIViewContentModeScaleAspectFit;
    [readComments addTarget:self action:@selector(handleReadComments) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:readComments];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(110, 0, 100, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    titleLabel.text = @"正文";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolbar addSubview:titleLabel];

    
//    smallFntBtn = [[UIButton alloc] init];
//    smallFntBtn.frame = CGRectMake(230, 12, 24, 21);
//    //[smallFntBtn setTitle:@"小字" forState:UIControlStateNormal];
//    [smallFntBtn setBackgroundImage:[UIImage imageNamed:@"smallfont.png"] forState:UIControlStateNormal];
//    [smallFntBtn setBackgroundImage:[UIImage imageNamed:@"smallfont_selected.png"] forState:UIControlStateSelected];
//    [smallFntBtn setBackgroundImage:[UIImage imageNamed:@"smallfont_selected.png"] forState:UIControlStateHighlighted];
//    [smallFntBtn addTarget:self action:@selector(handleSmallFontPressed) forControlEvents:UIControlEventTouchUpInside];
//    [topToolbar addSubview:smallFntBtn];
//    
//    bigFntBtn = [[UIButton alloc] init];
//    bigFntBtn.frame = CGRectMake(270, 12, 24, 21);
//    //[bigFntBtn setTitle:@"大字" forState:UIControlStateNormal];
//    [bigFntBtn setBackgroundImage:[UIImage imageNamed:@"bigfont.png"] forState:UIControlStateNormal];
//    [bigFntBtn setBackgroundImage:[UIImage imageNamed:@"bigfont_selected.png"] forState:UIControlStateSelected];
//    [bigFntBtn setBackgroundImage:[UIImage imageNamed:@"bigfont_selected.png"] forState:UIControlStateHighlighted];
//    [bigFntBtn addTarget:self action:@selector(handleBigFontPressed) forControlEvents:UIControlEventTouchUpInside];
//    [topToolbar addSubview:bigFntBtn];
}

- (void)initBottomBar
{
    CGRect Bounds = self.view.bounds;
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Bounds.size.height-45, 320, 45)];
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    
    UIImageView *bg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"news_content_bottom_back.png"]] autorelease];
    bg.frame = CGRectMake(0, 0, 320, 45);
    [bottomView addSubview:bg];
    
//    UITextField *commentsTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 8, 230, 30)];
//    commentsTextField.backgroundColor = [UIColor whiteColor];
//    commentsTextField.delegate = self;
//    [bottomView addSubview:commentsTextField];
    
    UIButton *write3 = [[UIButton alloc] init];
    [write3 setBackgroundImage:[UIImage imageNamed:@"news_content_bottom_repost.png"] forState:UIControlStateNormal];
    write3.frame = CGRectMake(30, 10, 32, 24);
    write3.titleLabel.textColor = [UIColor whiteColor];
    [write3 addTarget:self action:@selector(handleRepost) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:write3];
    [write3 release];
    
    UIButton *write4 = [[UIButton alloc] init];
    [write4 setBackgroundImage:[UIImage imageNamed:@"news_content_bottom_favourite.png"] forState:UIControlStateNormal];
    write4.frame = CGRectMake(90, 11, 23, 23);
    write4.titleLabel.textColor = [UIColor whiteColor];
    [write4 addTarget:self action:@selector(handleFavorite) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:write4];
    [write4 release];
    
    UIButton *write2 = [[UIButton alloc] init];
    [write2 setBackgroundImage:[UIImage imageNamed:@"news_content_bottom_font_big.png"] forState:UIControlStateNormal];
    write2.frame = CGRectMake(140, 10, 35, 25);
    write2.titleLabel.textColor = [UIColor whiteColor];
    [write2 addTarget:self action:@selector(fontSizeBigClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:write2];
    [write2 release];
    
    UIButton *write = [[UIButton alloc] init];
    [write setBackgroundImage:[UIImage imageNamed:@"news_content_bottom_font_small.png"] forState:UIControlStateNormal];
    write.frame = CGRectMake(200, 11, 37, 23);
    write.titleLabel.textColor = [UIColor whiteColor];
    [write addTarget:self action:@selector(fontSizeSmallClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:write];
    [write release];
    
    
    UIButton *writeComments = [[UIButton alloc] init];
    [writeComments setBackgroundImage:[UIImage imageNamed:@"news_content_bottom_write.png"] forState:UIControlStateNormal];
    writeComments.frame = CGRectMake(260, 12, 22, 20);
    [writeComments addTarget:self action:@selector(handleWriteComments) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:writeComments];
    [writeComments release];
    
//    
//    UIButton *closeInput = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeInput.frame = CGRectMake(0, 44, 320, UI_MAX_HEIGHT -110);
//    [closeInput addTarget:self action:@selector(handleCloseInput) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:closeInput];
//    [self.view bringSubviewToFront:closeInput];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    [self initToolbar];
    [self initBottomBar];
    currentFontSize = [ShareData sharedManager].newsFontSize;
    
    loadingView = [[LoadingView2 alloc] initWithFrame:CGRectMake(0, 44, 320, UI_MAX_HEIGHT -110)];
    
    if (!bInited) {
        bInited = YES;
        [self initNotification];
    }
}

-(void)getComments{
    NSString *commentID = [contentDict objectForKey:NEWSCONTENT_COMMENTID_KEY];
    
    NSString* totalString = commentID;//[self.newsObject valueForKey:NEWSCONTENT_commentid];
    NSArray* totalList = [totalString componentsSeparatedByString:@":"];
    if ([totalList count]==2) {
        NSString* channel = [totalList objectAtIndex:0];
        NSString* newsID = [totalList objectAtIndex:1];
        NSArray *selectID = [[[NSArray alloc] initWithObjects:@"newscomment", nil] autorelease];
        
        [[NewsFuncPuller getInstance]startCommentContentWithSender:self page:1 count:1 withChannel:channel newsID:newsID args:selectID dataList:nil bInback:NO];
    }
}

-(void)initNotification
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self 
           selector:@selector(CommentPublishSucceed:) 
               name:@"NewsCommentPublishSucceed"
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(CommentPublishFailed:) 
               name:@"NewsCommentPublishFailed"
             object:nil];
    
    [nc addObserver:self
           selector:@selector(CommentContentAdded:)
               name:CommonNewsSucceedNotification
             object:nil];
    
    
    [nc addObserver:self
           selector:@selector(CommentContentAdded:) 
               name:CommonWeiboSucceedNotification 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(CommentContentFailed:) 
               name:CommonWeiboFailedNotification
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(CommentContentFailed:) 
               name:CommonWeiboFailedNotification
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(MPMoviePlayerDidEnterFullscreen:) 
               name:MPMoviePlayerDidEnterFullscreenNotification
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(MPMoviePlayerDidExitFullscreen:) 
               name:MPMoviePlayerDidExitFullscreenNotification
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(MPMoviePlayerWillExitFullscreen:) 
               name:MPMoviePlayerWillExitFullscreenNotification
             object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
//    [ShareData sharedManager].newsFontSize = currentFontSize;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([ShareData sharedManager].isStockItemView && [ShareData sharedManager].viewIsLoading == NO){
        if (interfaceOrientation!=UIInterfaceOrientationPortraitUpsideDown) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)handleBackPressed
{
    BOOL isPushBack = [[NSUserDefaults standardUserDefaults] boolForKey:@"is_push_back"];
    
    if (isPushBack) {
 
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"initTabToPushController" object:nil];
//        
//        if ([delegate respondsToSelector:@selector(controllerBackClicked:)]) {
//            [delegate controllerBackClicked:self];
//        }
//        if(inputController.isStarted){
//            [inputController stopInput];
//        }
//        
//        [self.navigationController popViewControllerAnimated:NO];
//        [ShareData sharedManager].newsFontSize = currentFontSize;
//        
//         
//        
//        
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"is_push_back"];
    }else{
     
    }
    
    
    if ([delegate respondsToSelector:@selector(controllerBackClicked:)]) {
        [delegate controllerBackClicked:self];
    }
    if(inputController.isStarted){
        [inputController stopInput];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [ShareData sharedManager].newsFontSize = currentFontSize;
    
    
}

//- (void)handleSmallFontPressed
//{
//    if(currentFontSize > SMALL_FONTSIZE){
//        currentFontSize -= 2;
////        contentTextView.font = [UIFont fontWithName:APP_FONT_NAME size:currentFontSize];
//        [self reframeScrollView];
//    }
//    
//    if(currentFontSize <= SMALL_FONTSIZE){
//        smallFntBtn.enabled = NO;
//    }
//    
//    if(currentFontSize < BIG_FONTSIZE){
//        bigFntBtn.enabled = YES;
//    }
//}
//
//-(void)handleBigFontPressed
//{
//    if(currentFontSize < BIG_FONTSIZE){
//        currentFontSize += 2;
//        contentTextView.font = [UIFont fontWithName:APP_FONT_NAME size:currentFontSize];
//        [self reframeScrollView];
//    }
//    
//    if(currentFontSize >= BIG_FONTSIZE){
//        bigFntBtn.enabled = NO;
//    }
//    
//    if(currentFontSize > SMALL_FONTSIZE){
//        smallFntBtn.enabled = YES;
//    }
//}

- (void)handleSingleTapTextField//handleCloseInput
{
    if(inputController.isStarted){
        [inputController stopInput];
    }
}

- (void)handleRepost
{
    [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"weibo_pic"];
    ComposeWeiboViewController* composeController = [[ComposeWeiboViewController alloc] initWithNibName:@"ComposeWeiboViewController" bundle:nil];
    composeController.isSnap = YES;
    composeController.type = ComposeType_repost;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString* titleString = [contentDict objectForKey:NEWSCONTENT_TITLE_KEY];
    NSString* urlString = [contentDict objectForKey:NEWSCONTENT_URL_KEY];
    NSString* preString = nil;
    if (urlString&&titleString) {
        preString = [NSString stringWithFormat:@"%@ %@ ",titleString,urlString];
    }
    else {
        preString = @"";
    }
    composeController.preString = preString;
    composeController.type = ComposeType_repostNews;
    [dict release];
    UIImage *image = [self getTableImage:self.view];
    NSData *imgData  =  UIImagePNGRepresentation(image);
    [[NSUserDefaults standardUserDefaults] setObject:imgData forKey:@"weibo_pic"];
    [self.navigationController pushViewController:composeController animated:YES];
    [composeController release];
}

-(UIImage*)getTableImage:(UIView*)realView
{
    [realView sizeToFit];
    CGSize captureSize = realView.bounds.size;
	UIGraphicsBeginImageContextWithOptions(captureSize, NO, [[UIScreen mainScreen] scale]);
    [realView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (void)handleFavorite
{
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    if (hasLogined) 
    {        
        NSString* titleString = [contentDict objectForKey:NEWSCONTENT_TITLE_KEY];
        NSString* urlString = self.sourceURL;
        [[NewsFavoritePuller getInstance] startFavoriteNewsWithSender:nil newsurl:urlString title:titleString videoImg:nil videoURL:nil];
    }
    else
    {
        LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        
        [self.navigationController pushViewController:loginController animated:YES];
        [loginController release];
    }
}

- (void)handleWriteComments
{
    if([[WeiboLoginManager getInstance] hasLogined]){
        if(inputController == nil){
            inputController = [[inputShowController alloc] init];
            inputController.parentView = self.view;
            inputController.delegate = self;
        }
        
        [inputController startInput];
    }
    else{
        LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginController animated:YES];
    }
    isAlertShown = NO;
}

- (void)handleReadComments
{
    [self.inputController stopInput];
    NSString *commentID = [contentDict objectForKey:NEWSCONTENT_COMMENTID_KEY];
    UserCommentedViewController *commentsController = [[[UserCommentedViewController alloc] initWithCommentID:commentID] autorelease];
    [self.navigationController pushViewController:commentsController animated:YES];
}

-(void)fontSizeSmallClicked:(UIButton*)btn
{
    [contentNormalView setContentFont:NO];
}

-(void)fontSizeBigClicked:(UIButton*)btn
{
    [contentNormalView setContentFont:YES];
}

-(void)viewClicked:(TextNewsContentView*)view
{
    [self backgroundBtnClicked:nil];
}

-(void)view:(TextNewsContentView*)aView imageClicked:(NSString*)imageURL
{
    NormalImageViewController* controller = [[NormalImageViewController alloc] init];
    NSArray* array = [[NSArray alloc] initWithObjects:imageURL, nil];
    controller.imageObjectList = array;
    [array release];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)backgroundBtnClicked:(UIButton*)sender
{
    [self.inputController stopInput];
}

#pragma mark -
#pragma mark inputShowController
-(void)controller:(inputShowController*)controller text:(NSString*)content
{
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    if (!hasLogined) {
        LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        
        [self.navigationController pushViewController:loginController animated:YES];
        [loginController release];
    }
    else
    {
        NSString* userId = [[WeiboLoginManager getInstance] loginedID];
        [[WeiboFuncPuller getInstance] startUserInfoWeiboWithSender:self uid:userId username:nil info:content];
    }
}

#pragma mark -
#pragma mark networkfinished
- (void)CommentPublishSucceed:(NSNotification*)notify
{
    NSLog(@"CommentPublishSucceed");
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary: notify.userInfo];
    NSString *text = [dict objectForKey:@"ResultText"];
    
    if(!isAlertShown){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:text delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alert show];
        isAlertShown = YES;
    }
}

- (void)CommentPublishFailed:(NSNotification*)notify
{
    NSLog(@"CommentPublishFailed");
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary: notify.userInfo];
    NSString *text = [dict objectForKey:@"ResultText"];
    if(!isAlertShown){
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:text delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alert show];
        isAlertShown = YES;
    }
}

-(void)CommentContentAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* object = [userInfo valueForKey:RequsetSender];
    if ([object isKindOfClass:[NSNumber class]]&&[object intValue]==(int)self)
    {
        NSArray* indexArray = [userInfo objectForKey:RequsetArgs];
        NSArray* objectArray = [userInfo objectForKey:RequsetArray];
        NSNumber* page = [userInfo objectForKey:RequsetPage];
        NSNumber* stageNumber = [userInfo objectForKey:RequsetStage];
        
        if ([stageNumber intValue]==Stage_Request_V2UserInfoWeibo){
            NSString* content = [userInfo valueForKey:RequsetInfo];
            NSString* commentID = [contentDict objectForKey:NEWSCONTENT_COMMENTID_KEY];//[self.newsObject valueForKey:NEWSCONTENT_commentid];
            NSArray* totalList = [commentID componentsSeparatedByString:@":"];
            if ([totalList count]==2) {
                NSString* channel = [totalList objectAtIndex:0];
                NSString* newsID = [totalList objectAtIndex:1];
                [[NewsFuncPuller getInstance] startCommentNewsWithSender:self channelid:channel newsid:newsID content:content];
            }
        }else  if ([stageNumber intValue]==Stage_Request_CommentContent) {
            CommentContentList* commentList = (CommentContentList*)[userInfo objectForKey:RequsetExtra];
            
//            NSLog(@"",[commentList da]);
            
//            NSArray* commentArray = [userInfo valueForKey:@"array"];
            
            NSMutableArray* realCArray = nil;
            for (int i=0; i<5; i++) {
                if([objectArray count]>i)
                {
                    NewsObject* oneCObject = [objectArray objectAtIndex:i];
                    SVCommentModel* newModel = [[SVCommentModel alloc] init];
                    newModel.contentString = [oneCObject valueForKey:CommentContentObject_content];
                    NSString* nickStr = [oneCObject valueForKey:CommentContentObject_nick];
                    if (!(nickStr&&[nickStr length]>0)) {
                        nickStr = @"新浪网友";
                    }
                    NSString* ipStr = [oneCObject valueForKey:CommentContentObject_ip];
                    ipStr = [MyTool IPStringWtihLastComponetHiden:ipStr];
                    NSString* titleStr = [NSString stringWithFormat:@"%@:",nickStr];
                    if ([nickStr isEqualToString:@"手机用户"]||[nickStr isEqualToString:@"客户端用户"]||[nickStr isEqualToString:@"新浪网友"]) {
                        titleStr = [NSString stringWithFormat:@"%@[%@]:",nickStr,ipStr];
                    }
                    newModel.authorString = titleStr;
                    NSString* timeStr = [oneCObject valueForKey:CommentContentObject_time];
                    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
                    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    NSDate* newFormatDate  = [formater dateFromString:timeStr];
                    [formater release];
                    newModel.createDate = newFormatDate;
                    
                    if (!realCArray) {
                        realCArray = [NSMutableArray arrayWithCapacity:0];
                    }
                    [realCArray addObject:newModel];
                    [newModel release];
                    
                }
                else {
                    break;
                }
            }
//            (TextNewsContentView *)
            TextNewsContentView *v = (TextNewsContentView *)contentNormalView;
            v.commentArray = realCArray;
//            [contentTextView setCommentArray:readComments];
            
            
            [v reloadCommentData];
//            [v reloadData];

            
//            curPage = [page intValue];
            
        }

        
    }
}

-(void)CommentContentFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber isKindOfClass:[NSNumber class]]&&[senderNumber intValue]==(int)self)
    {
        NSNumber* stageNumber = [userInfo objectForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_V2UserInfoWeibo){
            NSString* topString = @"发表评论失败了";
            [[LKTipCenter defaultCenter] postTopTipWithMessage:topString time:2.0 color:nil];
            NSNumber* errorCode = [userInfo valueForKey:RequsetError];
            if ([errorCode intValue]==RequestError_User_Not_Exists) {
                [self startOpenMindedWeibo];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {  
    if(alertView.tag==111878)
    {
        if (buttonIndex==1) {
            [self realOpenMindedWeibo];
        }
    }
}  

-(void)startOpenMindedWeibo
{
    UIAlertView* anAlert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"您的帐号未开通微博功能,是否现在开通?", nil)
                                                      message: @"\n" 
                                                     delegate: self
                                            cancelButtonTitle: NSLocalizedString(@"否",nil)
                                            otherButtonTitles: NSLocalizedString(@"是",nil), nil];
    anAlert.tag = 111878;
    [anAlert show];
    [anAlert release];
}

-(void)realOpenMindedWeibo
{
    NSURL* url = [NSURL URLWithString:@"http://weibo.com/signup/full_info.php?nonick=1&lang=zh-cn"];
    LKWebViewController *webVC = [[LKWebViewController alloc] initWithNibName:@"LKWebViewController" bundle:nil url:url];
    webVC.titleString = @"开通微博";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    [webVC release];
}

-(void)MPMoviePlayerDidEnterFullscreen:(NSNotification*)notify
{
    [ShareData sharedManager].viewIsLoading = NO;
    [ShareData sharedManager].isStockItemView = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)MPMoviePlayerWillExitFullscreen:(NSNotification*)notify
{
    MPMoviePlayerController* controller = [notify object];
    [controller stop];
    self.view.hidden = YES;
}

-(void)MPMoviePlayerDidExitFullscreen:(NSNotification*)notify
{
    [ShareData sharedManager].viewIsLoading = NO;
    [ShareData sharedManager].isStockItemView = NO;
    UIViewController* tempViewController = [[UIViewController alloc] init];
    [self.navigationController pushViewController:tempViewController animated:NO];
    [self.navigationController popViewControllerAnimated:NO];
    [tempViewController release];
    self.view.hidden = NO;
}



-(void)view:(TextNewsContentView*)aView allCommentClicked:(UIButton *)sender
{
    [self handleReadComments];
}
@end
