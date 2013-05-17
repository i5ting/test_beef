//
//  OPArticleView.m
//  SinaNews
//
//  Created by fabo on 12-10-17.
//
//

#import "OPArticleView.h"
#import "OPTextParser.h"
#import "OPMoviePlayController.h"
#import "OPCoreTextView.h"
#import "OPImageScrollViewController.h"
#import "CommentTableView.h"
#import "RelativeNewsTableView.h"
#import "ArticleTitleLabel.h"
#import "NewsContentVariable.h"
#import "ArticleDeclareView.h"
#import "CustomImageView.h"
#import "MyTool.h"
#import "CustomScrollViewForContent.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface OPArticleScroll : UIScrollView

@end

@implementation OPArticleScroll

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(view:clickedMode:)]) {
        [self.delegate view:self clickedMode:0];
    }
}

@end

@implementation OPImageModel

@synthesize fullPath,heightValue,widthValue,title;


-(void)dealloc
{
    [fullPath release];
    [title release];
    [super dealloc];
}

@end

@implementation OPVideoModel

@synthesize thumb,vid;

-(void)dealloc
{
    [thumb release];
    [vid release];
    [super dealloc];
}

@end

@implementation OPSingleNewsModel

@synthesize imagesSet,content,title,declare,createTime,media,url,video;
@synthesize clickurl;
@synthesize commentSet;
@synthesize relativeNewsArray;
@synthesize extraData;
@synthesize titleSymbolData;
@synthesize bottomDeclare;

-(void)dealloc
{
    [imagesSet release];
    [content release];
    [title release];
    [declare release];
    [createTime release];
    [media release];
    [url release];
    [clickurl release];
    [video release];
    [commentSet release];
    [relativeNewsArray release];
    [extraData release];
    [titleSymbolData release];
    [bottomDeclare release];
    
    [super dealloc];
}

@end


@interface OPArticleView ()

@property(nonatomic,retain)OPMoviePlayController* playController;
@property(nonatomic,retain)OPImageScrollViewController* imageScrollController;
@property(nonatomic,retain)NSMutableArray* ShowedSubViews;
@property(nonatomic,retain)UILabel* curTitleLabel;
@property(nonatomic,retain)UIView* curTipView;
@property(nonatomic,retain)UILabel* curSourceLabel;
@property(nonatomic,retain)UIView* curSeperatorView;
@property(nonatomic,retain)UIView* curVideoView;
@property(nonatomic,retain)UIView* curImageView;
@property(nonatomic,retain)UILabel* curImageLabel;

@property(nonatomic,retain)OPCoreTextView* curCoreText;
@property(nonatomic,retain)ClickURLBtn* curClickURL;
@property(nonatomic,retain)RelativeNewsTableView* curRelativeTable;
@property(nonatomic,retain)CommentTableView* curCommentTable;
@property(nonatomic,retain)OPTextParser* curTextParser;

@property(nonatomic,retain)NSMutableArray* curCustomViews;

@end

@implementation OPArticleView
@synthesize contentScrollView;
@synthesize myModel,mySetting;
@synthesize playController;
@synthesize imageScrollController;
@synthesize delegate;
@synthesize bDateBeforeSource;
@synthesize ShowedSubViews;
@synthesize nightMode;
@synthesize nonImageMode;
@synthesize curTitleLabel;
@synthesize curTipView;
@synthesize curSourceLabel;
@synthesize curSeperatorView;
@synthesize curVideoView;
@synthesize curImageView;
@synthesize curImageLabel;
@synthesize curCoreText;
@synthesize curClickURL;
@synthesize curRelativeTable;
@synthesize curCommentTable;
@synthesize curTextParser;
@synthesize curCustomViews;

- (id) initWithFrame:(CGRect)frame
			   model:(OPSingleNewsModel*)newModel
			 setting:(OPContentSetting*)newSetting
{
	self = [super initWithFrame:frame];
	if (self != nil) {
        [self initUI];
        [self initNotification];
		self.mySetting = newSetting;
		self.myModel = newModel;
		self.contentScrollView.delegate = self;
        self.backgroundColor = [UIColor clearColor];
    
	}
	
	return self;
}

-(void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:@"DayNightModeNotification" object:nil];
    [contentScrollView release];
    [mySetting release];
    [myModel release];
    [playController stopVideo];
    [playController release];
    [imageScrollController release];
    [ShowedSubViews release];
    [curTitleLabel release];
    [curTipView release];
    [curSourceLabel release];
    [curSeperatorView release];
    [curVideoView release];
    [curImageView release];
    [curImageLabel release];
    [curCoreText release];
    [curClickURL release];
    [curRelativeTable release];
    [curCommentTable release];
    [curTextParser release];
    
    [self safeReleaseCustomViews];
    
    [super dealloc];
}

-(void)safeReleaseCustomViews
{
    if (curCustomViews) {
        for (CustomImageView* oneView in curCustomViews) {
            oneView.delegate = nil;
            [oneView cancelCurrentImageLoad];
        }
        [curCustomViews release];
        curCustomViews = nil;
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

-(void)initUI
{
    if (!contentScrollView) {
        contentScrollView = [[OPArticleScroll alloc] initWithFrame:self.bounds];
        [self addSubview:contentScrollView];
        contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
}

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:@"DayNightModeNotification" object:nil];
    [nc addObserver:self
		   selector:@selector(DayNightModeChanged:)
			   name:@"DayNightModeNotification"
			 object:nil];
    [nc addObserver:self
		   selector:@selector(NonImageModeChanged:)
			   name:@"DayNightModeNotification"
			 object:nil];
}


#define ARTICLE_OFFSET 10.0
#define CONTROL_SPACE   10.0
#pragma mark -
- (void)layoutArticle
{
    if (ShowedSubViews) {
        for (UIView* oneSub in ShowedSubViews) {
            [oneSub removeFromSuperview];
        }
    }
    [self safeReleaseCustomViews];
    [self.playController stopVideo];
    self.ShowedSubViews = [NSMutableArray arrayWithCapacity:0];
    CGFloat yoffset = 0;
    CGFloat width = self.contentScrollView.bounds.size.width - mySetting.contentSpaceBetweenEdge * 2;
    
    NSInteger titleTop = yoffset+mySetting.titleSpaceBetweenTop;;
    yoffset += [self layoutTitle2:yoffset];
    
    yoffset += [self layoutDeclare:yoffset];
    
    yoffset += [self layoutSource:yoffset];
    
    CGFloat margin = mySetting.titleSpaceBetweenEdge;
    CGRect tipRect = CGRectMake(margin-6, titleTop, 4, yoffset-titleTop);
    UIView* tempView = [[[UIView alloc] initWithFrame:tipRect] autorelease];
    tempView.backgroundColor = [UIColor redColor];
    if (nightMode) {
        [MyTool addCoverViewToView:tempView];
    }
    [self.contentScrollView addSubview:tempView];
    [self.ShowedSubViews addObject:tempView];
    self.curTipView = tempView;
    
    yoffset += [self layoutSeperate:yoffset];

    yoffset += [self layoutVideo:yoffset];
    
    OPTextParser *parser = [[[OPTextParser alloc] init] autorelease];
    CGFloat textSize = mySetting.textFontSize;
    parser.fontSize = textSize;
    if (nightMode) {
        parser.color = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0];
    }
    else
    {
        parser.color = [UIColor blackColor];
    }
    NSMutableArray* imageArray = [NSMutableArray arrayWithCapacity:0];
    for (OPImageModel* oneImage in myModel.imagesSet) {
        NSMutableDictionary* oneDict = [NSMutableDictionary dictionaryWithCapacity:0];
        [oneDict setValue:[NSNumber numberWithFloat:oneImage.widthValue] forKey:@"width"];
        [oneDict setValue:[NSNumber numberWithFloat:oneImage.heightValue] forKey:@"height"];
        [oneDict setValue:oneImage.fullPath forKey:@"url"];
        [imageArray addObject:oneDict];
    }
    parser.articleImages = imageArray;
    [parser doParse:myModel.content];
    OPTextParser* p = parser;
    self.curTextParser = parser;
    CGFloat height = [p textHeight:width];

    // 先检查是否需要图文混排，如果不需要则将图片统一处理
    if (p.parsedImages.count == 0)
    {
        yoffset += [self layoutImages:yoffset];
    }
    
    yoffset += GAPBETWEENCONTENTITEM;
    OPCoreTextView *coreText = [[[OPCoreTextView alloc] initWithFrame:CGRectMake(mySetting.contentSpaceBetweenEdge, yoffset, width, height)] autorelease];
    coreText.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    coreText.contentString = p.attributedContent;
    coreText.imageDelegate = self;
    coreText.images = p.parsedImages;
    coreText.backgroundColor = [UIColor clearColor];
    [self.contentScrollView addSubview:coreText];
    [self.ShowedSubViews addObject:coreText];
    self.curCoreText = coreText;
    self.curCoreText.nightMode = self.nightMode;
    yoffset += height;
    
    yoffset += [self layoutClickURL:yoffset];
    
    // 显示相关新闻
    if (myModel.relativeNewsArray&&[myModel.relativeNewsArray count]>0) {
        yoffset += [self layoutRelativeNews:yoffset];
    }
    
    // layout commnet
    if (myModel.commentSet&&[myModel.commentSet count]>0) {
        yoffset += [self layoutComment:yoffset];
    }

    // TODO: 需要在全部布局之后重新计算
    self.contentScrollView.contentSize = CGSizeMake(width, yoffset);
    
}

-(UIView*)coreTextView:(OPCoreTextView*)view viewWithURLString:(NSString*)urlString bounds:(CGRect)bounds
{
    CustomImageView *imageView = [[[CustomImageView alloc] init] autorelease];
    
    imageView.delegate = self;
    
    imageView.isNeedBorder = NO;
    imageView.border = 4;
    
    CGRect imageRect = bounds;
    CGRect tempFrame = imageRect;
    CGRect customRect = CGRectMake(0, 0, 100, 50);
    imageView.frame = customRect;
    imageView.frame = imageRect;
    if (nonImageMode) {
        NSURL* checkURL = [NSURL URLWithString:urlString];
        UIImage* realImage = [[SDWebImageManager sharedManager] imageWithURL:checkURL];
        if (realImage) {
            [imageView setContentImageWithFrame:tempFrame imageURL:urlString placeImage:[UIImage imageNamed:@"oparticle_photo_back.png"]];
        }
        else
        {
            [imageView setContentImageWithFrame:tempFrame imageURL:nil placeImage:[UIImage imageNamed:@"oparticle_photo_back.png"]];
            UILabel* tempLabel = [[UILabel alloc] init];
            tempLabel.backgroundColor = [UIColor clearColor];
            tempLabel.text = @"点击切换到有图模式";
            tempLabel.font = [UIFont systemFontOfSize:14.0];
            tempLabel.textAlignment = UITextAlignmentCenter;
            tempLabel.frame = CGRectMake(0, 80, 140, 20);
            [imageView addSubview:tempLabel];
            [tempLabel release];
            
        }
        
    }
    else
    {
        [imageView setContentImageWithFrame:tempFrame imageURL:urlString placeImage:[UIImage imageNamed:@"oparticle_photo_back.png"]];
    }
    
    if (nightMode) {
        [MyTool addCoverViewToView:imageView];
    }
    if (!curCustomViews) {
        curCustomViews = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [curCustomViews addObject:imageView];
    return imageView;
}

-(CGFloat)layoutTitle2:(CGFloat)yoffset
{
    CGFloat rtval = 0.0;
    rtval += mySetting.titleSpaceBetweenTop;
	CGFloat viewWidth = self.bounds.size.width;
    CGFloat margin = mySetting.titleSpaceBetweenEdge;
    
    CGRect titleRect = CGRectMake(margin, yoffset+rtval, viewWidth-2*margin, 100);
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:titleRect];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentLeft;
	titleLabel.lineBreakMode = UILineBreakModeWordWrap;
	titleLabel.numberOfLines = 0;
    UIColor* titleColor = [mySetting titleFontColor];
    if (nightMode) {
        titleColor = [UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1.0];
    }
	titleLabel.textColor = titleColor;
	[titleLabel setText:myModel.title];
	UIFont *font = [UIFont fontWithName:mySetting.titleFontName size:mySetting.titleFontSize];
	[titleLabel setFont:font];
    [self.contentScrollView addSubview:titleLabel];
    [self.ShowedSubViews addObject:titleLabel];
    self.curTitleLabel = titleLabel;
    [titleLabel release];
    [titleLabel sizeToFit];
    titleRect = titleLabel.frame;
    rtval += titleRect.size.height;
    return rtval;
}

-(CGFloat)layoutTitle:(CGFloat)yoffset
{
    CGFloat rtval = 0.0;
    rtval += mySetting.titleSpaceBetweenTop;
	CGFloat viewWidth = self.bounds.size.width;
    UIView* titleSymbol = nil;
    CGSize titleSymbbolSize = CGSizeZero;
    if ([delegate respondsToSelector:@selector(view:titleSymbolWithData:margin:width:fontSize:)]) {
        id titleData = self.myModel.titleSymbolData;
        titleSymbol = [delegate view:self titleSymbolWithData:titleData margin:mySetting.titleSpaceBetweenEdge width:viewWidth fontSize:mySetting.titleFontSize];
        if (titleSymbol) {
            titleSymbbolSize = titleSymbol.bounds.size;
        }
    }
    CGFloat margin = mySetting.titleSpaceBetweenEdge+titleSymbbolSize.width;
    CGSize sizeOfString = [myModel.title sizeWithFont:[UIFont fontWithName:mySetting.titleFontName size:mySetting.titleFontSize]
                                    constrainedToSize:CGSizeMake (viewWidth - margin*2, 500)
                                        lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat maxWidth = viewWidth - margin*2;
    int extraLen = 0;
    NSString* firstline = @"";
    if (sizeOfString.height>=mySetting.titleFontSize*2) {
        while (extraLen==0||sizeOfString.height>=mySetting.titleFontSize*3) {
            CGSize oldSize = sizeOfString;
            int stirngLen = [myModel.title length];
            NSInteger subLen = stirngLen/2+extraLen;
            if (subLen<=stirngLen)
            {
                NSString* tempString = [myModel.title substringWithRange:NSMakeRange(0, subLen)];
                firstline = tempString;
                CGSize tempSize = [tempString sizeWithFont:[UIFont fontWithName:mySetting.titleFontName size:mySetting.titleFontSize]];
                if (tempSize.width>maxWidth) {
                    tempSize.width = maxWidth;
                }
                sizeOfString = [myModel.title sizeWithFont:[UIFont fontWithName:mySetting.titleFontName size:mySetting.titleFontSize]
                                         constrainedToSize:CGSizeMake (tempSize.width + 5, 500)
                                             lineBreakMode:UILineBreakModeWordWrap];
                if (tempSize.width>sizeOfString.width) {
                    sizeOfString.width = tempSize.width;
                }
                if (extraLen>0&&oldSize.width==tempSize.width) {
                    break;
                }
                extraLen++;
            }
            else
            {
                break;
            }
        }
        
    }
    
    if (titleSymbol) {
        NSInteger symbolPos = yoffset;
        NSInteger symbolExtraPos = 0;
        if (mySetting.titleFontSize>titleSymbbolSize.height) {
            symbolExtraPos = mySetting.titleFontSize/2 - titleSymbbolSize.height/2;
            symbolPos += symbolExtraPos;
        }
        float originX =  viewWidth/2 - sizeOfString.width/2 - titleSymbbolSize.width;
        CGRect symbolRect = CGRectMake(originX, symbolPos, titleSymbbolSize.width, titleSymbbolSize.height);
        
        titleSymbol.frame = symbolRect;
        [self.contentScrollView addSubview:titleSymbol];
    }
    
    NSInteger tempPos = yoffset+rtval;
    NSInteger extraPos = 0;
    if (mySetting.titleFontSize<titleSymbbolSize.height) {
        extraPos = titleSymbbolSize.height/2 - mySetting.titleFontSize/2;
        tempPos += extraPos;
    }
    
    CGRect titleRect = CGRectMake(self.bounds.size.width/2-sizeOfString.width/2, tempPos, sizeOfString.width, sizeOfString.height);
    ArticleTitleLabel* titleLabel = [[ArticleTitleLabel alloc] initWithFrame:titleRect];
    titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.lineBreakMode = UILineBreakModeWordWrap;
	titleLabel.numberOfLines = 50;
    titleLabel.firstLine = firstline;
    UIColor* titleColor = [mySetting titleFontColor];
	titleLabel.textColor = titleColor;
	[titleLabel setText:myModel.title];
	UIFont *font = [UIFont fontWithName:mySetting.titleFontName size:mySetting.titleFontSize];
	[titleLabel setFont:font];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentScrollView addSubview:titleLabel];
    [titleLabel release];
    
    NSInteger newHeight = sizeOfString.height + extraPos;
    if (newHeight>titleSymbbolSize.height) {
        rtval += newHeight;
    }
    else
    {
        rtval += titleSymbbolSize.height;
    }
    return rtval;
}

-(CGFloat)layoutDeclare:(CGFloat)yoffset
{
    CGFloat rtval = 0.0;
    if (myModel.declare&&[myModel.declare compare:@""] != NSOrderedSame)
	{
        rtval += GAPBETWEENCONTENSEPRARATELINE;
        NSInteger margin = mySetting.titleSpaceBetweenEdge + 10;
        CGFloat viewWidth = self.frame.size.width;
		CGSize sizeOfString = [myModel.declare sizeWithFont:[UIFont fontWithName:mySetting.sourceFontName size:mySetting.sourceFontSize]
                                          constrainedToSize:CGSizeMake (viewWidth - margin*2, 500)
                                              lineBreakMode:UILineBreakModeWordWrap];
        
        
        CGRect tempFrame = CGRectMake(0, yoffset+rtval-4, viewWidth, sizeOfString.height+8);
        DeclareView *titleLabel = [[DeclareView alloc] initWithFrame:tempFrame];
        
        CGRect stringRect = CGRectMake((viewWidth-sizeOfString.width)/2, 4, sizeOfString.width, sizeOfString.height);
        UIFont *font = [UIFont fontWithName:mySetting.sourceFontName size:mySetting.sourceFontSize];
        UITextAlignment align = UITextAlignmentCenter;
        [titleLabel setString:myModel.declare stringRect:stringRect margin:margin-10 font:font fontColor:[mySetting sourceFontColor] textAlignment:align];
        [self.contentScrollView addSubview:titleLabel];
        [self.ShowedSubViews addObject:titleLabel];
        [titleLabel release];
		
		rtval += sizeOfString.height;
	}
    else
    {
        rtval += 0;
    }
    return rtval;
}

-(CGFloat)layoutSource:(CGFloat)yoffset
{
    CGFloat rtval = 0.0;
    rtval += GAPBETWEENCONTENSEPRARATELINE;
	NSMutableString * sourceString = [NSMutableString stringWithCapacity:0];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSDate *date = myModel.createTime;
	NSString *description = [dateFormatter stringFromDate:date];
	[dateFormatter release];
    CGFloat margin = mySetting.titleSpaceBetweenEdge;
	
	if (myModel.media&&[myModel.media compare:@""] !=NSOrderedSame)
	{
        NSString* mediaStr = myModel.media;
        if ([mediaStr length]>12) {
            mediaStr = [mediaStr substringWithRange:NSMakeRange(0, 11)];
            mediaStr = [mediaStr stringByAppendingString:@"..."];
        }
        mediaStr = [NSString stringWithFormat:@"来源:%@",mediaStr];
        if (!bDateBeforeSource) {
            [sourceString appendString:mediaStr];
            [sourceString appendString:@"  "];
            [sourceString appendString:description];
        }
        else
        {
            [sourceString appendString:description];
            [sourceString appendString:@"  "];
            [sourceString appendString:mediaStr];
        }
		
		CGFloat viewWidth = self.bounds.size.width;
		CGSize sizeOfSource = [sourceString sizeWithFont:[UIFont fontWithName:mySetting.sourceFontName size:mySetting.sourceFontSize]
                                       constrainedToSize:CGSizeMake (viewWidth - mySetting.contentSpaceBetweenEdge*2, 90000)
                                           lineBreakMode:UILineBreakModeWordWrap];
        
        NSInteger width = viewWidth - mySetting.contentSpaceBetweenEdge*2;
        CGRect tempFrame = CGRectMake(margin, yoffset+rtval, viewWidth-2*margin, sizeOfSource.height);
        
        
        UILabel *sourceLabel = [[UILabel alloc] initWithFrame:tempFrame];
        
        sourceLabel.textAlignment = UITextAlignmentLeft;
        sourceLabel.lineBreakMode = UILineBreakModeWordWrap;
        sourceLabel.numberOfLines = 50;
        [sourceLabel setText:sourceString];
        [sourceLabel setFont:[UIFont fontWithName:mySetting.sourceFontName size:mySetting.sourceFontSize]];
        sourceLabel.textColor = [mySetting sourceFontColor];
        if (nightMode) {
            sourceLabel.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1.0];
        }
        [sourceLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentScrollView addSubview:sourceLabel];
        [self.ShowedSubViews addObject:sourceLabel];
        self.curSourceLabel = sourceLabel;
        [sourceLabel release];
        
		rtval += sizeOfSource.height;
	}
    return rtval;
}

-(CGFloat)layoutSeperate:(CGFloat)yoffset
{
    CGFloat rtval = 0.0;
    rtval += GAPBETWEENCONTENSEPRARATELINE;
	CGFloat viewWidth = self.frame.size.width;
    
    CGFloat width = viewWidth - mySetting.titleSpaceBetweenEdge*2;
    CGRect tempFrame = CGRectMake((viewWidth-width)/2, yoffset+rtval, width, 1);
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"contentHorizontalSeparateLine.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]];
	imageView.frame = tempFrame;
    if (nightMode) {
        [MyTool addCoverViewToView:imageView];
    }
	[self.contentScrollView addSubview:imageView];
    [self.ShowedSubViews addObject:imageView];
    self.curSeperatorView = imageView;
    [imageView release];
    
	rtval += 1;
    return rtval;
}

- (CGFloat)layoutVideo:(CGFloat)yoffset
{
    CGFloat rtval = 0.0;
    if (self.myModel.video.vid
        && [self.myModel.video.vid intValue] != 0) {
        rtval += GAPBETWEENCONTENTVIDEO;
        NSString *videoImg = self.myModel.video.thumb.fullPath;
        NSString *videoID = self.myModel.video.vid;
        self.playController = [[[OPMoviePlayController alloc] initWithVideoID:videoID] autorelease];
        NSInteger realHeight = self.playController.view.bounds.size.height;
        NSInteger realWidth = self.playController.view.bounds.size.width;
//        NSInteger height = myModel.video.thumb.heightValue;
//        NSInteger width = myModel.video.thumb.widthValue;
//        NSInteger realHeight = [MyTool isRetina]?height/2:height;
//        NSInteger realWidth = [MyTool isRetina]?width/2:width;
        self.playController.view.frame = CGRectMake((self.bounds.size.width - realWidth) /2, yoffset+rtval, realWidth, realHeight);
        if (nightMode) {
            [MyTool addCoverViewToView:self.playController.view];
        }
        [self.contentScrollView addSubview:self.playController.view];
        [self.ShowedSubViews addObject:self.playController.view];
        self.curVideoView = self.playController.view;
        
        [self.playController.videoImage loadImage:[NSURL URLWithString:videoImg] useDefaultImage:YES];
        rtval += realHeight;
    }
    
    return rtval;
}

- (CGFloat)layoutImages:(CGFloat)yoffset
{
    CGFloat rtval = 0.0;
    if ([self.myModel.imagesSet count]>0) {
        if ([self.myModel.imagesSet count]==1) {
            rtval += GAPBETWEENCONTENTIMAGE;
            CGFloat viewWidth = self.bounds.size.width;
            
            CGSize photoSize = CGSizeMake(0, 0);
            
            CGFloat photoSpaceBetweenEdge = mySetting.titleSpaceBetweenEdge;
            OPImageModel* firstPhoto = (OPImageModel*)[self.myModel.imagesSet lastObject];
            
            if (firstPhoto.widthValue>0&&firstPhoto.heightValue>0) {
                if (firstPhoto.widthValue > viewWidth - 2*photoSpaceBetweenEdge) {
                    photoSize.width = viewWidth - 2*photoSpaceBetweenEdge;
                    photoSize.height = firstPhoto.heightValue * (photoSize.width / firstPhoto.widthValue);
                }
                else
                {
                    photoSize.width = firstPhoto.widthValue;
                    photoSize.height = firstPhoto.heightValue;
                }
            }
            else
            {
                photoSize.width = 100;
                photoSize.height = 100;
            }
            
            photoSize.width += 8;
            photoSize.height += 8;
            
            CGRect customRect = CGRectMake(0, 0, 100, 50);
            CustomImageView *imageView = [[CustomImageView alloc] initWithFrame:customRect];
            imageView.delegate = self;
            
            imageView.isNeedBorder = YES;
            imageView.border = 4;
            
            CGRect imageRect = CGRectMake((viewWidth - photoSize.width)/2, yoffset+rtval, photoSize.width, photoSize.height);
            CGRect tempFrame = imageRect;
            imageView.frame = imageRect;
            if (nonImageMode) {
                NSURL* checkURL = [NSURL URLWithString:firstPhoto.fullPath];
                UIImage* realImage = [[SDWebImageManager sharedManager] imageWithURL:checkURL];
                if (realImage) {
                    [imageView setContentImageWithFrame:tempFrame imageURL:firstPhoto.fullPath placeImage:[UIImage imageNamed:@"oparticle_photo_back.png"]];
                }
                else
                {
                    [imageView setContentImageWithFrame:tempFrame imageURL:nil placeImage:[UIImage imageNamed:@"oparticle_photo_back.png"]];
                    UILabel* tempLabel = [[UILabel alloc] init];
                    tempLabel.backgroundColor = [UIColor clearColor];
                    tempLabel.text = @"点击切换到有图模式";
                    tempLabel.frame = CGRectMake(0, 80, 140, 20);
                    tempLabel.font = [UIFont systemFontOfSize:14.0];
                    tempLabel.textAlignment = UITextAlignmentCenter;
                    [imageView addSubview:tempLabel];
                    [tempLabel release];
                    
                }
                
            }
            else
            {
                [imageView setContentImageWithFrame:tempFrame imageURL:firstPhoto.fullPath placeImage:[UIImage imageNamed:@"oparticle_photo_back.png"]];
            }
            self.curImageView = imageView;
            if (nightMode) {
                [MyTool addCoverViewToView:self.curImageView];
            }
            [self.contentScrollView addSubview:imageView];
            [self.ShowedSubViews addObject:imageView];
            if (!curCustomViews) {
                curCustomViews = [[NSMutableArray alloc] initWithCapacity:0];
            }
            [curCustomViews addObject:imageView];
            [imageView release];
            
            rtval += photoSize.height;
            
            rtval += [self layoutPhotoText:yoffset+rtval];
        }
        else
        {
            rtval += GAPBETWEENCONTENTSCROLLVIEW;
            
            NSMutableArray* ImageWidthArray = [NSMutableArray arrayWithCapacity:0];
            CGFloat viewWidth = self.bounds.size.width;
            NSInteger scrollHeight = [MyTool isRetina]?SCROLLVIEWHEIGHT/2:SCROLLVIEWHEIGHT;
            
            CGRect customFrame = CGRectMake((viewWidth - SCROLLVIEWWIDTH)/2, yoffset+rtval, SCROLLVIEWWIDTH, scrollHeight);
            
            
            CustomScrollViewForContent *customView = [[CustomScrollViewForContent alloc] initWithFrame:customFrame];
            
            NSArray* images = self.myModel.imagesSet;
            CGRect scrollFrame = customView.scrollView.frame;
            UIScrollView *scrollView = customView.scrollView;
            customView.images = images;

            CGFloat orignX = 0;
            for (int i = 0; i < images.count; i++)
            {
                OPImageModel *onePhoto = [images objectAtIndex:i];
                
                CGFloat zoomRate = 1.0;
                
                CGRect tempFrame = CGRectMake(0, 0, 0, 0);
                CGFloat newWidth = onePhoto.widthValue;
                CGFloat newHeight = onePhoto.heightValue;
                if (onePhoto.heightValue > scrollFrame.size.height)
                {
                    zoomRate = ((CGFloat)scrollFrame.size.height) / onePhoto.heightValue;
                    newWidth = onePhoto.widthValue * zoomRate;
                    newHeight = onePhoto.heightValue * zoomRate;
                }
                else
                {
                    tempFrame.origin.y = (scrollFrame.size.height - onePhoto.heightValue) / 2;
                }
                tempFrame.origin.x = orignX;
                tempFrame.size.width = newWidth;
                tempFrame.size.height = newHeight;
                CustomImageView *imageView = [[CustomImageView alloc] init];
                CGRect customRect = CGRectMake(0, 0, 100, 50);
                imageView.frame =customRect;
                imageView.delegate = self;
                
                imageView.isNeedBorder = NO;
                imageView.border = 4;
                imageView.frame = tempFrame;
                NSURL* url = [NSURL URLWithString:onePhoto.fullPath];
                if (nonImageMode) {
                    NSURL* checkURL = url;
                    UIImage* realImage = [[SDWebImageManager sharedManager] imageWithURL:checkURL];
                    if (realImage) {
                        [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"oparticle_photo_back.png"]];
                    }
                    else
                    {
                        [imageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"oparticle_photo_back.png"]];
                        UILabel* tempLabel = [[UILabel alloc] init];
                        tempLabel.backgroundColor = [UIColor clearColor];
                        tempLabel.text = @"点击切换到有图模式";
                        tempLabel.font = [UIFont systemFontOfSize:14.0];
                        tempLabel.textAlignment = UITextAlignmentCenter;
                        tempLabel.frame = CGRectMake(0, 80, 140, 20);
                        [imageView addSubview:tempLabel];
                        [tempLabel release];
                        
                    }
                    
                }
                else
                {
                    [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"oparticle_photo_back.png"]];
                }
                
                imageView.imageURL = onePhoto.fullPath;
                
                [scrollView addSubview:imageView];
                if (!curCustomViews) {
                    curCustomViews = [[NSMutableArray alloc] initWithCapacity:0];
                }
                [curCustomViews addObject:imageView];
                [imageView release];
                [ImageWidthArray addObject:[NSNumber numberWithFloat:newWidth]];
                orignX += newWidth + 10;		
            }
            if (orignX < scrollFrame.size.width)
            {
                CGFloat gap = (scrollFrame.size.width - orignX) / 2;
                CGFloat firstWidth = [[ImageWidthArray objectAtIndex:0] floatValue];
                CGFloat lastWidth = [[ImageWidthArray lastObject] floatValue];
                [ImageWidthArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:(firstWidth + gap)]];
                [ImageWidthArray replaceObjectAtIndex:(ImageWidthArray.count -1) withObject:[NSNumber numberWithFloat:(lastWidth + gap)]];
                for (UIImageView *oneView in scrollView.subviews)
                {
                    if ([oneView isKindOfClass:[UIImageView class]])
                    {
                        CGRect newFrame = oneView.frame;
                        newFrame.origin.x += gap;
                        oneView.frame = newFrame;
                    }
                }
            }
            else if ((orignX > scrollFrame.size.width + 100))
            {
                [customView addLabelView];
            }
            
            scrollView.contentSize = CGSizeMake(orignX - 10, scrollFrame.size.height);
            if (nightMode) {
                [MyTool addCoverViewToView:customView];
            }
            [self.contentScrollView addSubview:customView];
            self.curImageView = customView;
            [customView release];
            
            rtval += scrollHeight;
        }
    }
    
    return rtval;
}

-(void)CustomImageViewClicked:(CustomImageView*)aView
{
    if ([delegate respondsToSelector:@selector(view:imageClicked:)]) {
        [delegate view:self imageClicked:aView.imageURL];
    }
}

-(void)CustomImageViewFinishLoading:(CustomImageView*)view size:(CGSize)imageSize
{
    BOOL needReload = NO;
    NSString* oldImageString = view.imageURL;
    for (OPImageModel* model in self.myModel.imagesSet) {
        if ([model.fullPath isEqualToString:oldImageString]) {
            if (model.heightValue==0&&model.widthValue==0) {
                model.widthValue = imageSize.width;
                model.heightValue = imageSize.height;
                needReload = YES;
            }
        }
        if (needReload) {
            
        }
    }
    
    if (needReload) {
        ;
    }
}

-(CGFloat)layoutPhotoText:(CGFloat)yoffset
{
    CGFloat rtval = 0.0;
    if (self.myModel.imagesSet&&[self.myModel.imagesSet count]==1) {
        OPImageModel* firstPhoto = (OPImageModel*)[self.myModel.imagesSet lastObject];
        if (firstPhoto.title&&[firstPhoto.title length]>0) {
            rtval += 0;
            
            CGFloat viewWidth = self.bounds.size.width;
            NSString *text = firstPhoto.title;
            CGSize sizeOfContent = [text sizeWithFont:[UIFont fontWithName:mySetting.textFontName size:mySetting.textFontSize]
                                    constrainedToSize:CGSizeMake (viewWidth - mySetting.contentSpaceBetweenEdge*2, 90000)
                                        lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat width = viewWidth - mySetting.contentSpaceBetweenEdge*2;
            CGRect tempFrame = CGRectMake((viewWidth-width)/2, yoffset+rtval, width, sizeOfContent.height);
            
            
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:tempFrame];
            
            contentLabel.textAlignment = UITextAlignmentCenter;
            contentLabel.lineBreakMode = UILineBreakModeWordWrap;
            contentLabel.numberOfLines = 90000;
            [contentLabel setText:text];
            contentLabel.textColor = [mySetting imageFontColor];
            if (nightMode) {
                contentLabel.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1.0];
            }
            [contentLabel setFont:[UIFont fontWithName:mySetting.textFontName size:14]];
            [contentLabel setBackgroundColor:[UIColor clearColor]];
            [self.contentScrollView addSubview:contentLabel];
            [self.ShowedSubViews addObject:contentLabel];
            self.curImageLabel = contentLabel;
            [contentLabel release];
            
            rtval += sizeOfContent.height;
        }
    }
    return rtval;
}

-(CGFloat)layoutText:(CGFloat)yoffset
{
    
}

-(CGFloat)layoutClickURL:(CGFloat)offset
{
    CGFloat rtval = 0.0;
    if (myModel.clickurl&&[myModel.clickurl length])
    {
        rtval += GAPBETWEENCLICKURL;

        NSString* sourceString = myModel.clickurl;
        CGFloat viewWidth = self.bounds.size.width;
        CGSize sizeOfSource = [sourceString sizeWithFont:[UIFont fontWithName:mySetting.textFontName size:mySetting.textFontSize]
                                       constrainedToSize:CGSizeMake (viewWidth - mySetting.contentSpaceBetweenEdge*2, 90000)
                                           lineBreakMode:UILineBreakModeWordWrap];
        
        CGRect tempFrame = CGRectMake(mySetting.contentSpaceBetweenEdge, offset+rtval, viewWidth - mySetting.contentSpaceBetweenEdge*2, sizeOfSource.height);
        
        ClickURLBtn *clickURLBtn = [[ClickURLBtn alloc] initWithFrame:tempFrame];
        
        clickURLBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [clickURLBtn setTitle:sourceString forState:UIControlStateNormal];
        [clickURLBtn setTitleColor:[UIColor colorWithRed:9/255.0 green:178/255.0 blue:249/255.0 alpha:1.0] forState:UIControlStateNormal];
        clickURLBtn.titleLabel.numberOfLines = 0;
        [clickURLBtn addTarget:self action:@selector(urlClicked:) forControlEvents:UIControlEventTouchUpInside];
        clickURLBtn.titleLabel.font = [UIFont fontWithName:mySetting.textFontName size:mySetting.textFontSize];
        clickURLBtn.data = sourceString;
        
        if (nightMode) {
            [MyTool addCoverViewToView:clickURLBtn];
        }
        [self.contentScrollView addSubview:clickURLBtn];
        [self.ShowedSubViews addObject:clickURLBtn];
        self.curClickURL = clickURLBtn;
        [clickURLBtn release];
        
        rtval += sizeOfSource.height;
    }
    return rtval;
}

-(void)urlClicked:(ClickURLBtn*)sender
{
    NSString* content = sender.data;
    if ([delegate respondsToSelector:@selector(view:urlClicked:)]) {
        [delegate view:self urlClicked:content];
    }
}

- (void)reLoadComment
{
    CGSize contentSize = self.contentScrollView.contentSize;
    CGFloat yoffset = contentSize.height;
    // layout commnet
    if (myModel.commentSet&&[myModel.commentSet count]>0) {
        yoffset += [self layoutComment:yoffset];
    }
    
    // TODO: 需要在全部布局之后重新计算
    self.contentScrollView.contentSize = CGSizeMake(contentSize.width, yoffset);
}

- (void)setContentFont:(BOOL)isLargeFont
{
    [self layoutArticle];
}

-(void)commentTableView:(CommentTableView*)view allContentClicked:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(view:allCommentClicked:)]) {
        [delegate view:self allCommentClicked:sender];
    }
}

-(CGFloat)layoutComment:(CGFloat)yoffset
{
    CGFloat rtval = 0.0;
    if (!(myModel.relativeNewsArray&&[myModel.relativeNewsArray count]>0)) {
        rtval += GAPBETWEENCONTENTITEM;
    }
    CGRect commentRect = CGRectMake(0, yoffset+rtval, self.bounds.size.width, 100);
    CommentTableView* ctableView = [[CommentTableView alloc] initWithFrame:commentRect];
    ctableView.dataArray = myModel.commentSet;
    ctableView.leftrightMargin = mySetting.contentSpaceBetweenEdge;
    NSInteger commentHeight = ctableView.fitHeight;
    commentRect.size.height = commentHeight;
    ctableView.frame = commentRect;
    ctableView.delegate = self;
    ctableView.nightMode = nightMode;
    [ctableView reloadData];
    [self.contentScrollView addSubview:ctableView];
    [self.ShowedSubViews addObject:ctableView];
    self.curCommentTable = ctableView;
    [ctableView release];
    rtval += commentHeight;
    return rtval;
}

-(void)RelativeNewsTableView:(RelativeNewsTableView*)view relativeURLClicked:(NSString*)url
{
    if ([delegate respondsToSelector:@selector(view:relativeURLClicked:)]) {
        [delegate view:self relativeURLClicked:url];
    }
}

-(CGFloat)layoutRelativeNews:(CGFloat)yoffset
{
    CGFloat rtval = 0.0;
    rtval += GAPBETWEENCONTENTITEM;
    CGRect commentRect = CGRectMake(0, yoffset+rtval, self.bounds.size.width, 100);
    RelativeNewsTableView* ctableView = [[RelativeNewsTableView alloc] initWithFrame:commentRect];
    ctableView.dataArray = myModel.relativeNewsArray;
    ctableView.leftrightMargin = mySetting.contentSpaceBetweenEdge;
    NSInteger commentHeight = ctableView.fitHeight;
    commentRect.size.height = commentHeight;
    ctableView.frame = commentRect;
    ctableView.delegate = self;
    ctableView.nightMode = nightMode;
    [ctableView reloadData];
    [self.contentScrollView addSubview:ctableView];
    [self.ShowedSubViews addObject:ctableView];
    self.curRelativeTable = ctableView;
    [ctableView release];
    rtval += commentHeight;
    return rtval;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([delegate respondsToSelector:@selector(view:clickedMode:)]) {
        [delegate view:self clickedMode:1];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([delegate respondsToSelector:@selector(view:clickedMode:)]) {
        [delegate view:self clickedMode:0];
    }
}

-(void)view:(OPArticleScroll*)aView clickedMode:(NSInteger)mode
{
    if ([delegate respondsToSelector:@selector(view:clickedMode:)]) {
        [delegate view:self clickedMode:0];
    }
}

-(void)DayNightModeChanged:(NSNotification*)notiy
{
    NSNumber* modeNumber = [notiy object];
    if ([modeNumber boolValue]) {
        UIColor* titleColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1.0];
        self.curTitleLabel.textColor = titleColor;
        [MyTool addCoverViewToView:self.curTipView];
        
        self.curSourceLabel.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1.0];
        
        [MyTool addCoverViewToView:self.curSeperatorView];
        [MyTool addCoverViewToView:self.curVideoView];
        [MyTool addCoverViewToView:self.curImageView];
        self.curImageLabel.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1.0];

        OPTextParser *parser = [[[OPTextParser alloc] init] autorelease];
        CGFloat textSize = mySetting.textFontSize;
        parser.fontSize = textSize;
        parser.color = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1.0];
        NSMutableArray* imageArray = [NSMutableArray arrayWithCapacity:0];
        for (OPImageModel* oneImage in myModel.imagesSet) {
            NSMutableDictionary* oneDict = [NSMutableDictionary dictionaryWithCapacity:0];
            [oneDict setValue:[NSNumber numberWithFloat:oneImage.widthValue] forKey:@"width"];
            [oneDict setValue:[NSNumber numberWithFloat:oneImage.heightValue] forKey:@"height"];
            [oneDict setValue:oneImage.fullPath forKey:@"url"];
            [imageArray addObject:oneDict];
        }
        parser.articleImages = imageArray;
        [parser doParse:myModel.content];

        self.curCoreText.contentString = parser.attributedContent;
        self.curCoreText.nightMode = YES;
        [MyTool addCoverViewToView:self.curClickURL];
        self.curRelativeTable.nightMode = YES;
        self.curCommentTable.nightMode = YES;
    }
    else
    {
        UIColor* titleColor = [mySetting titleFontColor];
        self.curTitleLabel.textColor = titleColor;
        [MyTool removeCoverViewFromView:self.curTipView];
        self.curSourceLabel.textColor = [mySetting sourceFontColor];
        [MyTool removeCoverViewFromView:self.curSeperatorView];
        [MyTool removeCoverViewFromView:self.curVideoView];
        [MyTool removeCoverViewFromView:self.curImageView];
        self.curImageLabel.textColor = [mySetting imageFontColor];
        
        
        OPTextParser *parser = [[[OPTextParser alloc] init] autorelease];
        CGFloat textSize = mySetting.textFontSize;
        parser.fontSize = textSize;
        parser.color = [UIColor blackColor];
        NSMutableArray* imageArray = [NSMutableArray arrayWithCapacity:0];
        for (OPImageModel* oneImage in myModel.imagesSet) {
            NSMutableDictionary* oneDict = [NSMutableDictionary dictionaryWithCapacity:0];
            [oneDict setValue:[NSNumber numberWithFloat:oneImage.widthValue] forKey:@"width"];
            [oneDict setValue:[NSNumber numberWithFloat:oneImage.heightValue] forKey:@"height"];
            [oneDict setValue:oneImage.fullPath forKey:@"url"];
            [imageArray addObject:oneDict];
        }
        parser.articleImages = imageArray;
        [parser doParse:myModel.content];
        
        self.curCoreText.contentString = self.curTextParser.attributedContent;
        self.curCoreText.nightMode = NO;
        [MyTool removeCoverViewFromView:self.curClickURL];
        self.curRelativeTable.nightMode = NO;
        self.curCommentTable.nightMode = NO;
    }
}

-(void)NonImageModeChanged:(NSNotification*)notiy
{
    
}

@end
