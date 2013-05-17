//
//  TextNewsContentView.m
//  SinaNews
//
//  Created by shieh exbice on 11-11-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TextNewsContentView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "ArticleContentView.h"
#import "NewsObject.h"
#import "VideoItemInContentView.h"

#define kTextNewsContentView_TitleView 12121
#define kTextNewsContentView_DateLabel 12122
#define kTextNewsContentView_info1Label 22122
#define kTextNewsContentView_info2Label 22123
#define kTextNewsContentView_MediaLabel 12123
#define kTextNewsContentView_ContentLabel 12124
#define kTextNewsContentView_Seperator 12125


#define kNews_TitleFontSize (18.0)


@interface NormalNewsContentView () 
@property(nonatomic,retain)ArticleContentView* contentView;
@end

@implementation NormalNewsContentView

@synthesize delegate,titleString,createDate,media,declare,preMedia,picURLArray,videoData,contentString,bottomDeclare;
@synthesize contentView,setting;
@synthesize bHtmlStyle;
@synthesize bSourceHtml;
@synthesize bDateBeforeSource;
@synthesize clickurl;
@synthesize commentArray;
@synthesize relativeNewsArray;
@synthesize extraData;
@synthesize titleSymbolData;

-(void)dealloc
{
    [contentView release];
    [titleString release];
    [createDate release];
    [media release];
    [preMedia release];
    [clickurl release];
    [picURLArray release];
    [videoData release];
    [contentString release];
    [setting release];
    [commentArray release];
    [relativeNewsArray release];
    [declare release];
    [extraData release];
    [titleSymbolData release];
    [bottomDeclare release];
    
    [super dealloc];
}

-(void)clear
{
    [self.contentView removeFromSuperview];
    self.contentView.imageDelegate = nil;
    self.contentView = nil;
    self.titleString = nil;
    self.createDate = nil;
    self.media = nil;
    self.picURLArray = nil;
    self.videoData = nil;
    self.contentString = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([delegate respondsToSelector:@selector(viewClicked:)]) {
        [delegate viewClicked:self];
    }
}

-(void)reloadCommentData
{
    SSingleNewsModel* myModel = contentView.myModel;
    myModel.commentSet = self.commentArray;
    [contentView reLoadComment];
}

-(void)reloadData
{
    if (!self.setting) {
        setting = [[SingleContentViewSetting alloc] init];
    }
    
    SSingleNewsModel* myModel = [[SSingleNewsModel alloc] init];
    NSString* newString = contentString;
    int contentLen = [contentString length];
    //    if (contentLen>20000) {
    //        newString = [contentString substringToIndex:20000];
    //        newString = [newString stringByAppendingString:@"......"];
    //    }
    myModel.content = newString;
    myModel.title = self.titleString;
    myModel.createTime = self.createDate;
    myModel.media = self.media;
    myModel.declare = self.declare;
    myModel.bottomDeclare = self.bottomDeclare;
    myModel.clickurl = self.clickurl;
    myModel.commentSet = self.commentArray;
    myModel.relativeNewsArray = self.relativeNewsArray;
    myModel.extraData = self.extraData;
    myModel.titleSymbolData = self.titleSymbolData;
    if (videoData) {
        SVideoModel* videoModel = [[SVideoModel alloc] init];
        videoModel.vid = videoData.videoURL;
        SImageModel* imageModel = [[SImageModel alloc] init];
        imageModel.url = videoData.imageURL;
        imageModel.fullPath = videoData.imageURL;
        imageModel.widthValue = 400;
        imageModel.heightValue = 300;
        videoModel.thumb = imageModel;
        myModel.video = videoModel;
        [imageModel release];
        [videoModel release];
    }
    if (picURLArray&&[picURLArray count]) {
        NSMutableArray* picArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i<[picURLArray count]; i++) {
            ImageURLData* urlData = [picURLArray objectAtIndex:i];
            SImageModel* imageModel = [[SImageModel alloc] init];
            imageModel.url = urlData.imageURL;
            imageModel.fullPath = urlData.imageURL;
            imageModel.widthValue = urlData.imageSize.width;
            imageModel.heightValue = urlData.imageSize.height;
            imageModel.title = urlData.imageTitle;
            [picArray addObject:imageModel];
            [imageModel release];
        }
        myModel.imagesSet = picArray;
        [picArray release];
    }
    
    if (self.contentView) {
        [self.contentView removeFromSuperview];
        self.contentView = nil;
    }
    contentView = [[ArticleContentView alloc] initWithFrame:self.bounds
                                                      model:myModel
                                                    setting:setting];
    contentView.bHtmlStyle = bHtmlStyle;
    contentView.bSourceHtml = bSourceHtml;
    contentView.bDateBeforeSource = bDateBeforeSource;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    contentView.imageDelegate = self;
    [contentView onLoad];
    [self addSubview:contentView];
    
    [myModel release];
}

- (void)setContentFont:(BOOL)isLargeFont
{
    [contentView setContentFont:isLargeFont];
}

-(void)view:(ArticleContentView*)aView imageClicked:(NSString*)imageURL
{
    if ([delegate respondsToSelector:@selector(viewClicked:)]) {
        [delegate viewClicked:self];
    }
    if ([delegate respondsToSelector:@selector(view:imageClicked:)]) {
        [delegate view:self imageClicked:imageURL];
    }
    
}

-(void)view:(ArticleContentView*)aView clickedMode:(NSInteger)mode
{
    if ([delegate respondsToSelector:@selector(viewClicked:)]) {
        [delegate viewClicked:self];
    }
}

-(void)view:(ArticleContentView*)aView urlClicked:(NSString*)url
{
    if ([delegate respondsToSelector:@selector(view:urlClicked:)]) {
        [delegate view:self urlClicked:url];
    }
}

-(void)view:(ArticleContentView*)aView allCommentClicked:(UIButton *)sender
{
    if ([delegate respondsToSelector:@selector(view:allCommentClicked:)]) {
        [delegate view:self allCommentClicked:sender];
    }
}

-(void)view:(ArticleContentView*)aView relativeURLClicked:(NSString*)url
{
    if ([delegate respondsToSelector:@selector(view:relativeURLClicked:)]) {
        [delegate view:self relativeURLClicked:url];
    }
}

-(UIView*)view:(ArticleContentView*)aView extraViewWithData:(id)data margin:(NSInteger)margin width:(NSInteger)width fontSize:(NSInteger)fontSize
{
    UIView* rtval = nil;
    if ([delegate respondsToSelector:@selector(view:extraViewWithData:margin:width:fontSize:)]) {
        rtval = [delegate view:self extraViewWithData:data margin:margin width:width fontSize:fontSize];
    }
    return rtval;
}

-(UIView*)view:(ArticleContentView*)aView titleSymbolWithData:(id)data margin:(NSInteger)margin width:(NSInteger)width fontSize:(NSInteger)fontSize
{
    UIView* rtval = nil;
    if ([delegate respondsToSelector:@selector(view:titleSymbolWithData:margin:width:fontSize:)]) {
        rtval = [delegate view:self titleSymbolWithData:data margin:margin width:width fontSize:fontSize];
    }
    return rtval;
}

@end



@interface TextNewsButton : UIButton
@property(nonatomic,retain)id data;
@end

@implementation TextNewsButton
@synthesize data;

-(void)dealloc
{
    [data release];
    [super dealloc];
}

@end


@interface TextNewsContentView ()
@property(nonatomic,retain)VideoItemInContentView* vieoView;
@property(nonatomic,retain)NSMutableArray* imageViewArray;
@property(nonatomic,retain)NSMutableArray* imageClickArray;
@property(nonatomic,retain)NSMutableArray* picLabelArray;
-(void)myLayoutSubviews;
@end

@implementation TextNewsContentView

@synthesize delegate;
@synthesize titleString,createDate,media,declare,preMedia,picURLArray,contentString,bottomDeclare;
@synthesize imageViewArray,picLabelArray,imageClickArray;
@synthesize videoData,vieoView;
@synthesize setting;
@synthesize info1String,info2String;
@synthesize bHtmlStyle;
@synthesize bSourceHtml;
@synthesize bDateBeforeSource;
@synthesize clickurl;
@synthesize commentArray;
@synthesize relativeNewsArray;
@synthesize extraData;
@synthesize titleSymbolData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.tag = kTextNewsContentView_TitleView;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:102/255.0 blue:204/255.0 alpha:1.0];
        titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:18.0];
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
        [titleLabel release];
        
        UIImageView* seperator = [[UIImageView alloc] initWithFrame:CGRectZero];
        seperator.tag = kTextNewsContentView_Seperator;
        UIImage* seperatorImage = [UIImage imageNamed:@"contentHorizontalSeparateLine.png"];
        seperatorImage = [seperatorImage stretchableImageWithLeftCapWidth:1.0 topCapHeight:1.0];
        seperator.image = seperatorImage;
        [self addSubview:seperator];
        [seperator release];
        
        UILabel* info1 = [[UILabel alloc] initWithFrame:CGRectZero];
        info1.tag = kTextNewsContentView_info1Label;
        info1.backgroundColor = [UIColor clearColor];
        info1.font = [UIFont systemFontOfSize:12.0];
        info1.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self addSubview:info1];
        [info1 release];
        
        UILabel* info2 = [[UILabel alloc] initWithFrame:CGRectZero];
        info2.tag = kTextNewsContentView_info2Label;
        info2.backgroundColor = [UIColor clearColor];
        info2.font = [UIFont systemFontOfSize:12.0];
        info2.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self addSubview:info2];
        [info2 release];
        
        UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        dateLabel.tag = kTextNewsContentView_DateLabel;
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont systemFontOfSize:12.0];
        dateLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self addSubview:dateLabel];
        [dateLabel release];
        
        UILabel* mediaLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mediaLabel.tag = kTextNewsContentView_MediaLabel;
        mediaLabel.backgroundColor = [UIColor clearColor];
        mediaLabel.font = [UIFont systemFontOfSize:12.0];
        mediaLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self addSubview:mediaLabel];
        [mediaLabel release];
        
        MyLabelView* contentLabel = [[MyLabelView alloc] initWithFrame:CGRectZero];
        contentLabel.tag = kTextNewsContentView_ContentLabel;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:16.0];
        contentLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        contentLabel.delegate = self;
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        [contentLabel release];
        
        /*
         // 单击的 Recognizer    
         UITapGestureRecognizer* singleRecognizer;    
         singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];   
         singleRecognizer.numberOfTapsRequired = 1; 
         // 单击    
         [self addGestureRecognizer:singleRecognizer];  
         [singleRecognizer release];
         */
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(WebCacheImageSuccessed:) name:WebCacheImageSuccessedNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    MyLabelView* contentTextLabel = (MyLabelView*)[self viewWithTag:kTextNewsContentView_ContentLabel];
    contentTextLabel.delegate = nil;
    [contentTextLabel stopLoading];
    [titleString release];
    [createDate release];
    [media release];
    [preMedia release];
    [clickurl release];
    [picURLArray release];
    [contentString release];
    [imageViewArray release];
    [imageClickArray release];
    [picLabelArray release];
    [videoData release];
    [vieoView release];
    [setting release];
    [info1String release];
    [info2String release];
    [commentArray release];
    [relativeNewsArray release];
    [declare release];
    [extraData release];
    [titleSymbolData release];
    [bottomDeclare release];
    
    [super dealloc];
}

- (void)setContentFont:(BOOL)isLargeFont
{
    
}

-(void)WebCacheImageSuccessed:(NSNotification*)notify
{
    id object = [notify object];
    for (int k=0;k<[imageViewArray count];k++) {
        UIImageView* oneView = [imageViewArray objectAtIndex:k];
        TextNewsButton* clickBtn = [imageClickArray objectAtIndex:k];
        if (oneView==object) {
            NSURL* url = [oneView imageURL];
            NSString* urlString = [url absoluteString];
            for (int i=0;i<[picURLArray count];i++) {
                ImageURLData* oneData = [picURLArray objectAtIndex:i];
                if (oneData.imageURL&&[oneData.imageURL length]>0) {
                    if ([oneData.imageURL isEqualToString:urlString]) {
                        oneData.imageSize = oneView.image.size;
                    }
                }
            }
            CGRect imageRect = oneView.frame;
            CGSize imageNewSize = CGSizeMake(oneView.image.size.width/2, oneView.image.size.height/2);
            if (!CGSizeEqualToSize(imageNewSize, imageRect.size)) {
                imageRect.size = imageNewSize;
                oneView.frame = imageRect;
                clickBtn.frame = imageRect;
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(myLayoutSubviews) object:nil];
                [self performSelector:@selector(myLayoutSubviews) withObject:nil afterDelay:0.001];
            }
            
            break;
        }
    }
}

-(void)handleSingleTapFrom
{
    if ([delegate respondsToSelector:@selector(viewClicked:)]) {
        [delegate viewClicked:self];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)setPicURLArray:(NSArray *)aPicURLArray
{
    if (picURLArray!=aPicURLArray) {
        [picURLArray release];
        picURLArray = aPicURLArray;
        [picURLArray retain];
    }
    if (!imageViewArray) {
        imageViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else
    {
        for (UIImageView* oneImageView in imageViewArray) {
            [oneImageView cancelCurrentImageLoad];
            [oneImageView removeFromSuperview];
        }
    }
    
    if (!imageClickArray) {
        imageClickArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else {
        for (UIButton* oneImageBtn in imageClickArray) {
            [oneImageBtn removeFromSuperview];
        }
    }
    
    [imageViewArray removeAllObjects];
    [imageClickArray removeAllObjects];
    
    if (!picLabelArray) {
        picLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else
    {
        for (UILabel* oneLabel in picLabelArray) {
            [oneLabel removeFromSuperview];
        }
    }
    
    [picLabelArray removeAllObjects];
    for (int i=0;i<[picURLArray count];i++) {
        ImageURLData* oneData = [picURLArray objectAtIndex:i];
        CGRect imageViewRect = CGRectMake(0, 0, oneData.imageSize.width, oneData.imageSize.height);
        if (CGSizeEqualToSize(oneData.imageSize, CGSizeZero)) {
            imageViewRect = CGRectMake(0, 0, 30, 30);
        }
        UIImageView* oneImageView = [[UIImageView alloc] initWithFrame:imageViewRect];
        oneImageView.layer.borderWidth  =1;    
        oneImageView.layer.borderColor= [[UIColor blackColor] CGColor];   
        [imageViewArray addObject:oneImageView];
        [self addSubview:oneImageView];
        [oneImageView release];
        
        TextNewsButton* oneImageBtn = [[TextNewsButton alloc] init];
        oneImageBtn.layer.borderWidth  =1;    
        oneImageBtn.layer.borderColor= [[UIColor blackColor] CGColor];  
        [imageClickArray addObject:oneImageBtn];
        [oneImageBtn addTarget:self action:@selector(imageClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:oneImageBtn];
        [oneImageBtn release];
        
        UILabel* oneLabel = [[UILabel alloc] init];
        oneLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        oneLabel.font = [UIFont systemFontOfSize:14.0];
        oneLabel.textAlignment = UITextAlignmentCenter;
        oneLabel.text = oneData.imageTitle;
        oneLabel.numberOfLines = 0;
        oneLabel.backgroundColor = [UIColor clearColor];
        [picLabelArray addObject:oneLabel];
        [self addSubview:oneLabel];
        [oneLabel release];
    }
    
    [self setNeedsLayout];
    
    //[self performSelector:@selector(loadImageURL) withObject:nil afterDelay:0.01];
}

-(void)imageClicked:(TextNewsButton*)sender
{
    if ([delegate respondsToSelector:@selector(view:imageClicked:)]) {
        NSString* urlString = sender.data;
        [delegate view:self imageClicked:urlString];
    }
}

-(void)loadImageURL:(NSInteger)index
{
    if (index>=0) {
        NSString* oneURL = nil;
        if (index<[picURLArray count]) {
            ImageURLData* oneData = [picURLArray objectAtIndex:index];
            oneURL = oneData.imageURL;
        }
        UIImageView* oneView = [imageViewArray objectAtIndex:index];
        TextNewsButton* imageBtn = [imageClickArray objectAtIndex:index];
        //UIImage* placeImage = [UIImage imageNamed:@"bottomBtnNews01.png"];
        UIImage* placeImage = [UIImage imageNamed:@"pic_item_loading.png"];
        NSURL* url = [NSURL URLWithString:oneURL];
        imageBtn.data = oneURL;
        [oneView setImageWithURL:url placeholderImage:placeImage];
    }
    else
    {
        for (int i=0;i<[imageViewArray count];i++) {
            NSString* oneURL = nil;
            if (i<[picURLArray count]) {
                ImageURLData* oneData = [picURLArray objectAtIndex:i];
                oneURL = oneData.imageURL;
            }
            UIImageView* oneView = [imageViewArray objectAtIndex:i];
            TextNewsButton* imageBtn = [imageClickArray objectAtIndex:i];
            //UIImage* placeImage = [UIImage imageNamed:@"bottomBtnNews01.png"];
            UIImage* placeImage = [UIImage imageNamed:@"pic_item_loading.png"];
            NSURL* url = [NSURL URLWithString:oneURL];
            imageBtn.data = oneURL;
            [oneView setImageWithURL:url placeholderImage:placeImage];
        }
    }
    
}

-(void)clear
{
    [vieoView clear];
    self.titleString = nil;
    self.createDate = nil;
    self.media = nil;
    self.picURLArray = nil;
    self.videoData = nil;
    self.contentString = nil;
    [self reloadData];
}

-(void)reloadCommentData
{
    
}

-(void)reloadData
{
    if (!self.setting) {
        setting = [[SingleContentViewSetting alloc] init];
    }
    
    UILabel* titleLabel = (UILabel*)[self viewWithTag:kTextNewsContentView_TitleView];
    titleLabel.text = titleString;
    titleLabel.textColor = setting.titleFontColor;
    titleLabel.font = [UIFont fontWithName:setting.titleFontName size:setting.titleFontSize];
    UIImageView* seperator = (UIImageView*)[self viewWithTag:kTextNewsContentView_Seperator]; 
    if (!titleString||[titleString isEqualToString:@""]) {
        seperator.alpha = 0.0;
    }
    else
    {
        seperator.alpha = 1.0;
    }
    
    UILabel* info1Label = (UILabel*)[self viewWithTag:kTextNewsContentView_info1Label];
    info1Label.textColor = setting.sourceFontColor;
    info1Label.font = [UIFont fontWithName:setting.sourceFontName size:setting.sourceFontSize];
    if (info1String) {
        NSString* newStr = [info1String stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        info1Label.text = newStr;
    }
    else
    {
        info1Label.text = nil;
    }
    
    UILabel* info2Label = (UILabel*)[self viewWithTag:kTextNewsContentView_info2Label];
    info2Label.textColor = setting.sourceFontColor;
    info2Label.font = [UIFont fontWithName:setting.sourceFontName size:setting.sourceFontSize];
    if (info2String) {
        NSString* newStr = [info2String stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        info2Label.text = newStr;
    }
    else
    {
        info2Label.text = nil;
    }
    
    UILabel* dateLabel = (UILabel*)[self viewWithTag:kTextNewsContentView_MediaLabel];
    dateLabel.textColor = setting.sourceFontColor;
    dateLabel.font = [UIFont fontWithName:setting.sourceFontName size:setting.sourceFontSize];
    NSString* dateString = @"";
    if (createDate) {
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        dateString = [formater stringFromDate:createDate];
        [formater release];
    }
    dateLabel.text = dateString;
    
    UILabel* mediaLabel = (UILabel*)[self viewWithTag:kTextNewsContentView_DateLabel];
    mediaLabel.textColor = setting.sourceFontColor;
    mediaLabel.font = [UIFont fontWithName:setting.sourceFontName size:setting.sourceFontSize];
    if (media) {
        NSString* mediaStr = [media stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* preString = preMedia;
        if (!preString) {
            preString = @"来源";
        }
        mediaLabel.text = [NSString stringWithFormat:@"%@:%@",preString,mediaStr];
    }
    else
    {
        mediaLabel.text = @"";
    }
    
    MyLabelView* contentTextLabel = (MyLabelView*)[self viewWithTag:kTextNewsContentView_ContentLabel];
    contentTextLabel.textColor = setting.textFontColor;
    contentTextLabel.font = [UIFont fontWithName:setting.textFontName size:setting.textFontSize];
    if (contentString) {
        NSString* newString = contentString;
        int contentLen = [contentString length];
        //        if (contentLen>20000) {
        //            newString = [contentString substringToIndex:20000];
        //            newString = [newString stringByAppendingString:@"......"];
        //        }
        contentTextLabel.text = newString;
    }
    else
    {
        contentTextLabel.text = nil;
    }
    
    if (!vieoView) {
        vieoView = [[VideoItemInContentView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
        [self addSubview:vieoView];
    }
    
    if (videoData) {
        VideoData* newData = [[VideoData alloc] init];
        newData.imageURL = videoData.imageURL;
        NSString* videoURL =  [NSString stringWithFormat:@"http://v.iask.com/v_play_ipad.php?vid=%@",videoData.videoURL] ;
        newData.videoURL =videoURL;
        vieoView.videoData = newData;
        [newData release];
    }
    else
    {
        vieoView.videoData = nil;
    }
    
    [self myLayoutSubviews];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self myLayoutSubviews];
}

-(void)myLayoutSubviews
{
    int titleMargin = 15;
    CGRect mainRect = self.bounds;
    mainRect.origin.y = titleMargin;
    mainRect.origin.x = titleMargin;
    mainRect.size.width -= 2*titleMargin;
    
    
    mainRect.size.height -= 2*titleMargin;
    UILabel* titleLabel = (UILabel*)[self viewWithTag:kTextNewsContentView_TitleView];
    CGRect titleRect = self.bounds;
    
    
    CGSize titleSize = [self.titleString sizeWithFont:titleLabel.font];
    
    if (titleSize.width > mainRect.size.width) 
    {
        CGRect frame = titleLabel.frame;
        NSInteger count = (titleSize.width+ mainRect.size.width -1)/mainRect.size.width;
        frame.size.height = count*titleSize.height;
        frame.size.width = titleSize.width / count + 15;
        
        frame.origin.x = (320 - frame.size.width) / 2;
        frame.origin.y = titleMargin;
        titleLabel.frame = frame;
        titleRect = frame;
        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.textAlignment = UITextAlignmentCenter;
    }
    else
    {
        titleRect.origin.y = titleMargin;
        titleLabel.frame = titleRect;
        [titleLabel sizeToFit];
        titleRect.size = titleLabel.frame.size;
        titleRect.origin.x = mainRect.origin.x + mainRect.size.width/2 - titleRect.size.width/2;
        titleLabel.frame = titleRect;
    }
    
    UILabel* info1Label = (UILabel*)[self viewWithTag:kTextNewsContentView_info1Label];
    CGRect info1Rect = titleRect;
    info1Rect.origin.x = 0;
    info1Rect.origin.y += info1Rect.size.height + 10;
    [info1Label sizeToFit];
    info1Rect.size = info1Label.frame.size;
    
    UILabel* info2Label = (UILabel*)[self viewWithTag:kTextNewsContentView_info2Label];
    CGRect info2Rect = info1Rect;
    if (info1Rect.size.width>0) {
        info2Rect.origin.x += info2Rect.size.width + 15;
    }
    else {
        info2Rect.origin.x = 0;
    }
    [info2Label sizeToFit];
    info2Rect.size = info2Label.frame.size;
    
    BOOL hasInfoRect = NO;
    CGRect topRect = titleRect;
    if (info2Rect.size.height>0||info1Rect.size.height>0) {
        if (info2Rect.origin.x + info2Rect.size.width - info1Rect.origin.x>mainRect.size.width) {
            if (info1Rect.size.width>0) {
                info1Rect.size.width = mainRect.size.width - (info2Rect.size.width + 15);
                info2Rect.origin.x = info1Rect.size.width + 15;
            }
        }
        
        int info1RealX = mainRect.origin.x + mainRect.size.width/2 - (info2Rect.origin.x + info2Rect.size.width - info1Rect.origin.x)/2;
        info1Rect.origin.x = info1RealX;
        if (info1Rect.size.width>0) {
            info2Rect.origin.x = info1Rect.origin.x + info1Rect.size.width + 15;
        }
        else {
            info2Rect.origin.x = info1RealX;
        }
        
        info2Label.frame = info2Rect;
        info1Label.frame = info1Rect;
        
        NSInteger info1Bottom = info1Rect.origin.y + info1Rect.size.height;
        NSInteger info2Bottom = info2Rect.origin.y + info2Rect.size.height;
        int maxBottom = info1Bottom>info2Bottom?info1Bottom:info2Bottom;
        topRect = CGRectMake(titleRect.origin.x, titleRect.origin.y, titleRect.size.width, maxBottom - titleRect.origin.y);
        hasInfoRect = YES;
    }
    
    UILabel* dateLabel = (UILabel*)[self viewWithTag:kTextNewsContentView_DateLabel];
    CGRect dateRect = topRect;
    dateRect.origin.x = 0;
    if(hasInfoRect)
    {
        dateRect.origin.y += dateRect.size.height + 4;
    }
    else {
        dateRect.origin.y += dateRect.size.height + 10;
    }
    [dateLabel sizeToFit];
    dateRect.size = dateLabel.frame.size;
    
    UILabel* mediaLabel = (UILabel*)[self viewWithTag:kTextNewsContentView_MediaLabel];
    CGRect mediaRect = dateRect;
    if (dateRect.size.width>0) {
        mediaRect.origin.x += mediaRect.size.width + 15;
    }
    else {
        mediaRect.origin.x = 0;
    }
    [mediaLabel sizeToFit];
    mediaRect.size = mediaLabel.frame.size;
    
    if (mediaRect.origin.x + mediaRect.size.width - dateRect.origin.x>mainRect.size.width) {
        if (dateRect.size.width>0) {
            dateRect.size.width = mainRect.size.width - (mediaRect.size.width + 15);
            mediaRect.origin.x = dateRect.size.width + 15;
        }
    }
    
    int dateRealX = mainRect.origin.x + mainRect.size.width/2 - (mediaRect.origin.x + mediaRect.size.width - dateRect.origin.x)/2;
    dateRect.origin.x = dateRealX;
    if (dateRect.size.width>0) {
        mediaRect.origin.x = dateRect.origin.x + dateRect.size.width + 15;
    }
    else {
        mediaRect.origin.x = dateRealX;
    }
    
    mediaLabel.frame = mediaRect;
    dateLabel.frame = dateRect;
    
    NSInteger seprateY = 0;
    if (dateRect.size.height==0&&mediaRect.size.height==0) {
        seprateY = dateRect.origin.y;
    }
    else {
        NSInteger dateBottom = dateRect.origin.y + dateRect.size.height;
        NSInteger mediaBottom = mediaRect.origin.y + mediaRect.size.height;
        seprateY = mediaBottom>dateBottom?mediaBottom:dateBottom;
        seprateY +=2;
    }
    
    UIImageView* seperator = (UIImageView*)[self viewWithTag:kTextNewsContentView_Seperator]; 
    CGRect seperatorRect = seperator.frame;
    seperatorRect.size.height = seperator.image.size.height;
    seperatorRect.size.width = self.bounds.size.width - 10*2;
    seperatorRect.origin.y = seprateY;
    seperatorRect.origin.x = 10;
    seperator.frame = seperatorRect;
    
    CGRect contentRect = CGRectMake(mainRect.origin.x, seperatorRect.origin.y + seperatorRect.size.height +10, mainRect.size.width, mainRect.size.height);
    
    if (videoData) {
        vieoView.hidden = NO;
        CGRect videoRect = vieoView.frame;
        videoRect.origin.x = contentRect.origin.x + contentRect.size.width/2 - videoRect.size.width/2;
        videoRect.origin.y = contentRect.origin.y;
        vieoView.frame = videoRect;
        contentRect.size.height = contentRect.size.height - videoRect.size.height - 10;
        contentRect.origin.y = videoRect.origin.y + videoRect.size.height + 10;
    }
    else
    {
        vieoView.hidden = YES;
    }
    
    int imageMargin = 8;
    int extraHeight = 0;
    for (int i=0;i<[imageViewArray count];i++) {
        [self loadImageURL:i];
        UIImageView* oneImageView = [imageViewArray objectAtIndex:i];
        TextNewsButton* imageBtn = [imageClickArray objectAtIndex:i];
        CGRect imageRect = contentRect;
        imageRect.size = oneImageView.frame.size;
        if (imageRect.size.width + 2*imageMargin >self.bounds.size.width) {
            int oldWidth = imageRect.size.width;
            imageRect.size.width = self.bounds.size.width - 2*imageMargin;
            imageRect.size.height = imageRect.size.width* imageRect.size.height/oldWidth;
        }
        imageRect.origin.x = imageRect.origin.x + mainRect.size.width/2 - imageRect.size.width/2;
        imageRect.origin.y += extraHeight;
        oneImageView.frame = imageRect;
        imageBtn.frame = imageRect;
        extraHeight += imageRect.size.height + 4;
        
        UILabel* oneLabel = [picLabelArray objectAtIndex:i];
        oneLabel.numberOfLines = 0;
        CGRect imageLabelRect = contentRect;
        imageLabelRect.origin.y += extraHeight;
        imageLabelRect.size = mainRect.size;
        oneLabel.frame = imageLabelRect;
        [oneLabel sizeToFit];
        imageLabelRect.size.height = oneLabel.frame.size.height;
        imageLabelRect.origin.x = mainRect.origin.x;
        oneLabel.frame = imageLabelRect;
        extraHeight += imageLabelRect.size.height + 6;
    }
    if ([imageViewArray count]>0) {
        extraHeight += 4;
    }
    
    UILabel* contentTextLabel = (UILabel*)[self viewWithTag:kTextNewsContentView_ContentLabel];
    /*
     UILabel* tempLabel = [[UILabel alloc] init];
     tempLabel.numberOfLines = 0;
     UIFont* tempFont = contentTextLabel.font;
     tempLabel.font = tempFont;
     tempLabel.text = contentTextLabel.text;
     tempLabel.frame = contentTextLabel.frame;
     CGRect contentTextRect = tempLabel.frame;
     contentTextRect.size.width = contentRect.size.width;
     contentTextRect.size.height = 10;
     tempLabel.frame = contentTextRect;
     [tempLabel sizeToFit];
     CGSize newSize = tempLabel.frame.size;
     contentTextRect.size = newSize;
     contentTextRect.origin.y = contentRect.origin.y + extraHeight;
     contentTextRect.origin.x = contentRect.origin.x;
     contentTextLabel.frame = contentTextRect;
     [tempLabel releacontentTextLabel	MyLabelView *	0x841ac00se];
     */
    CGRect contentTextRect = contentTextLabel.frame;
    contentTextRect.size.width = mainRect.size.width;
    contentTextRect.size.height = 10;
    contentTextLabel.frame = contentTextRect;
    CGSize tempSize = CGSizeMake(contentTextRect.size.width, 99999999);
    tempSize = [contentTextLabel sizeThatFits:tempSize];
    contentTextRect.size = tempSize;
    contentTextRect.origin.y = contentRect.origin.y + extraHeight;
    contentTextRect.origin.x = contentRect.origin.x;
    contentTextLabel.frame = contentTextRect;
    
    int maxHeight = contentTextRect.origin.y + contentTextRect.size.height;
    maxHeight = maxHeight > self.bounds.size.height ? maxHeight : self.bounds.size.height+1;
    self.contentSize = CGSizeMake(self.bounds.size.width, maxHeight);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([delegate respondsToSelector:@selector(viewClicked:)]) {
        [delegate viewClicked:self];
    }
}

@end


