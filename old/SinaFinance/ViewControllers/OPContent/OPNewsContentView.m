//
//  OPNewsContentView.m
//  SinaNews
//
//  Created by fabo on 12-10-22.
//
//

#import "OPNewsContentView.h"
#import "OPArticleView.h"
#import "NewsObject.h"
#import "SDWebImageManager.h"

@interface OPNewsContentView ()
@property(nonatomic,retain)OPArticleView* contentView;
@end

@implementation OPNewsContentView

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
@synthesize nightMode;
@synthesize nonImageMode;
@synthesize nonImageModeNoRelaod;

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

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
    self.contentView.delegate = nil;
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
    OPSingleNewsModel* myModel = contentView.myModel;
    myModel.commentSet = self.commentArray;
    [contentView reLoadComment];
    
}

-(void)reloadData
{
    if (!self.setting) {
        setting = [[SingleContentViewSetting alloc] init];
    }
    
    OPSingleNewsModel* myModel = [[OPSingleNewsModel alloc] init];
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
        OPVideoModel* videoModel = [[OPVideoModel alloc] init];
        videoModel.vid = videoData.videoURL;
        OPImageModel* imageModel = [[OPImageModel alloc] init];
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
            OPImageModel* imageModel = [[OPImageModel alloc] init];
            imageModel.fullPath = urlData.imageURL;
            imageModel.widthValue = urlData.imageSize.width;
            imageModel.heightValue = urlData.imageSize.height;
            imageModel.title = urlData.imageTitle;
            if (nonImageMode) {
                NSURL* checkURL = [NSURL URLWithString:urlData.imageURL];
                UIImage* realImage = [[SDWebImageManager sharedManager] imageWithURL:checkURL];
                if (realImage) {
                    [picArray addObject:imageModel];
                }
                else
                {
                    imageModel.widthValue = 140.0;
                    imageModel.heightValue = 100.0;
                    [picArray addObject:imageModel];
                }
            }
            else
            {
                [picArray addObject:imageModel];
            }
            [imageModel release];
        }
        myModel.imagesSet = picArray;
        [picArray release];
    }
    
    if (self.contentView) {
        [self.contentView removeFromSuperview];
        self.contentView = nil;
    }
    
    OPContentSetting* newSetting = [[OPContentSetting alloc] init];
    newSetting.sourceFontSize = setting.sourceFontSize;
    newSetting.textFontSize = setting.textFontSize;
    newSetting.titleFontSize = setting.titleFontSize;
    newSetting.sourceFontName = setting.sourceFontName;
    newSetting.textFontName = setting.textFontName;
    newSetting.titleFontName = setting.titleFontName;
    newSetting.titleFontColor = setting.titleFontColor;
    newSetting.sourceFontColor = setting.sourceFontColor;
    newSetting.textFontColor = setting.textFontColor;
    newSetting.relativeTextSize = setting.relativeTextSize;
    newSetting.relativeTitleSize = setting.relativeTitleSize;
    contentView = [[OPArticleView alloc] initWithFrame:self.bounds
                                                 model:myModel
                                               setting:newSetting];
    
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    contentView.delegate = self;
    contentView.nightMode = self.nightMode;
    contentView.nonImageMode = self.nonImageMode;
    [contentView layoutArticle];
    [self addSubview:contentView];
    [newSetting release];
    [myModel release];
}

-(CGFloat)posYOfScroll
{
    if (contentView.contentScrollView) {
        return contentView.contentScrollView.contentOffset.y;
    }
    else
        return 0.0;
}

-(void)setScrollToPos:(CGFloat)pos
{
    if (contentView.contentScrollView) {
        CGPoint po = contentView.contentScrollView.contentOffset;
        CGSize pSize = contentView.contentScrollView.contentSize;
        CGSize pboundsize = contentView.contentScrollView.bounds.size;
        if (pSize.height-pboundsize.height>pos) {
            po.y = pos;
        }
        else
        {
            po.y = pSize.height-pboundsize.height;
        }
        contentView.contentScrollView.contentOffset = po;
    }
}

-(void)setNightMode:(BOOL)anightMode
{
    nightMode = anightMode;
    self.contentView.nightMode = anightMode;
}

- (void)setContentFont:(BOOL)isLargeFont
{
    CGFloat textFontSize;
    CGFloat titleFontSize;
    CGFloat sourceFontSize;
    CGFloat relativeTitleSize;
    CGFloat relativeTextSize;
    CGFloat commentTextSize;
    CGFloat commentTitleSize;
    if (isLargeFont)
	{
		if (contentView.mySetting.textFontSize >= 20) return;
		contentView.mySetting.textFontSize += 2;
		contentView.mySetting.titleFontSize += 2;
		contentView.mySetting.sourceFontSize += 2;
		
        contentView.mySetting.relativeTitleSize += 2;
        contentView.mySetting.relativeTextSize += 2;
        contentView.mySetting.commentTextSize += 2;
        contentView.mySetting.commentTitleSize += 2;
	}
	else
	{
		if (contentView.mySetting.textFontSize <= 8) return;
		contentView.mySetting.textFontSize -= 2;
		contentView.mySetting.titleFontSize -= 2;
		contentView.mySetting.sourceFontSize -= 2;
        contentView.mySetting.relativeTitleSize -= 2;
        contentView.mySetting.relativeTextSize -= 2;
        contentView.mySetting.commentTextSize -= 2;
        contentView.mySetting.commentTitleSize -= 2;
	}
    textFontSize = contentView.mySetting.textFontSize;
    titleFontSize = contentView.mySetting.titleFontSize;
    sourceFontSize = contentView.mySetting.sourceFontSize;
    [SingleContentViewSetting setTitleFontSize:titleFontSize textFontSize:textFontSize SourceFontSize:sourceFontSize];
    [SingleContentViewSetting setRelativeTitleSize:relativeTitleSize relativeTextSize:relativeTextSize commentTextSize:commentTextSize commentTitleSize:commentTitleSize];
    [contentView setContentFont:isLargeFont];
}

-(void)view:(OPArticleView*)aView imageClicked:(NSString*)imageURL
{
    if ([delegate respondsToSelector:@selector(viewClicked:)]) {
        [delegate viewClicked:self];
    }
    if ([delegate respondsToSelector:@selector(view:imageClicked:)]) {
        [delegate view:self imageClicked:imageURL];
    }
    
}

-(void)view:(OPArticleView*)aView clickedMode:(NSInteger)mode
{
    if ([delegate respondsToSelector:@selector(viewClicked:)]) {
        [delegate viewClicked:self];
    }
}

-(void)view:(OPArticleView*)aView urlClicked:(NSString*)url
{
    if ([delegate respondsToSelector:@selector(view:urlClicked:)]) {
        [delegate view:self urlClicked:url];
    }
}

-(void)view:(OPArticleView*)aView allCommentClicked:(UIButton *)sender
{
    if ([delegate respondsToSelector:@selector(view:allCommentClicked:)]) {
        [delegate view:self allCommentClicked:sender];
    }
}

-(void)view:(OPArticleView*)aView relativeURLClicked:(NSString*)url
{
    if ([delegate respondsToSelector:@selector(view:relativeURLClicked:)]) {
        [delegate view:self relativeURLClicked:url];
    }
}

-(UIView*)view:(OPArticleView*)aView extraViewWithData:(id)data margin:(NSInteger)margin width:(NSInteger)width fontSize:(NSInteger)fontSize
{
    UIView* rtval = nil;
    if ([delegate respondsToSelector:@selector(view:extraViewWithData:margin:width:fontSize:)]) {
        rtval = [delegate view:self extraViewWithData:data margin:margin width:width fontSize:fontSize];
    }
    return rtval;
}

-(UIView*)view:(OPArticleView*)aView titleSymbolWithData:(id)data margin:(NSInteger)margin width:(NSInteger)width fontSize:(NSInteger)fontSize
{
    UIView* rtval = nil;
    if ([delegate respondsToSelector:@selector(view:titleSymbolWithData:margin:width:fontSize:)]) {
        rtval = [delegate view:self titleSymbolWithData:data margin:margin width:width fontSize:fontSize];
    }
    return rtval;
}

-(void)setNonImageMode:(BOOL)anonImageMode
{
    if (nonImageMode!=anonImageMode) {
        nonImageMode = anonImageMode;
        [self reloadData];
    }
}

-(BOOL)nonImageModeNoRelaod
{
    return nonImageMode;
}

-(void)setNonImageModeNoRelaod:(BOOL)anonImageModeNoRelaod
{
    if (nonImageMode!=anonImageModeNoRelaod) {
        nonImageMode = anonImageModeNoRelaod;
    }
}

@end
