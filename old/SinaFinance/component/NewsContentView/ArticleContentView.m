//
//  ArticleContentView.m
//  SinaNews
//
//  Created by huangdx on 9/20/10.
//  Copyright 2010 hdx. All rights reserved.
//

#import "ArticleContentView.h"
#import "NewsContentVariable.h"
#import "MUser.h"
#import "VideoInContentView.h"
#import "GridViewController.h"
#import "CustomImageView.h"
#import "CustomScrollViewForContent.h"
#import "hExtension.h"
#import "UIImageView+WebCache.h"
#import "MyTool.h"
#import "CommentTableView.h"
#import "RelativeNewsTableView.h"
#import "ArticleTitleLabel.h"
#import "ArticleDeclareView.h"




@implementation MyLabelView
@synthesize numberOfLines;
@synthesize text,textColor,font;
@synthesize bSourceHtml;

-(id)init
{
    self = [super init];
    if (self) {
        NSString *htmlstr = @"<body style=\"margin:0;background-color: transparent;\" ></body>";
        
        [self loadHTMLString:htmlstr baseURL:nil];
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        [self scrollView].scrollEnabled = NO;
    }
    return self;
}

-(void)dealloc
{
    [text release];
    [textColor release];
    [font release];
    
    [super dealloc];
}

-(void)setText:(NSString *)atext
{
    if (text!=atext) {
        NSString* oldText = text;
        text = [atext retain];
        [oldText release];
    }
    [self reloadData];
}

-(void)setTextColor:(UIColor *)atextColor
{
    if (textColor!=atextColor) {
        UIColor* oldTextColor = textColor;
        textColor = [atextColor retain];
        [oldTextColor release];
    }
    [self reloadData];
}

-(void)setFont:(UIFont *)afont
{
    if (font!=afont) {
        UIFont* oldFont = font;
        font = [afont retain];
        [oldFont release];
    }
    [self reloadData];
}

-(void)reloadData
{
    if (self.text&&self.font&&self.textColor) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(loadText) object:nil];
        [self performSelector:@selector(loadText) withObject:nil afterDelay:0.001];
        //[self loadHTMLString:htmlstr baseURL:nil];
    }
}

-(void)loadText
{
    if (self.text&&self.font&&self.textColor) {
        [self stopLoading];
        CGFloat R, G, B;
        const CGFloat *components = CGColorGetComponents(self.textColor.CGColor);
        R = components[0];
        G = components[1];
        B = components[2];
        NSString* newText = [self.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"]; 
        newText = [newText stringByReplacingOccurrencesOfString:@" " withString:@"&nbsp;"];
        if (bSourceHtml) {
            newText = self.text;
        }
//        newText = @"<img src=\"http://s3.finance.sina.com.cn/kzx/img/1349764223674.png\" align=\"left\" alt=\"\" width=\"310\"/>";
        CGRect bounds = self.bounds;
        NSString *htmlstr = [NSString stringWithFormat:@"<div id=\"body\"><html><body style=\"margin:0;background-color: transparent;color:rgb(%d,%d,%d);font-size:%dpx;\"><div style=width:%fpx;word-warp:break-word;word-break:break-all>%@</div></body></html></div>",(int)(R*255),(int)(G*255),(int)(B*255),(int)self.font.pointSize,bounds.size.width,newText];
#ifdef DEBUG
        [MyTool writeToDocument:htmlstr folder:@"test" fileName:@"articletext.html"];
#endif
        self.dataDetectorTypes = UIDataDetectorTypeNone;
        [self loadHTMLString:htmlstr baseURL:nil];
        [self scrollView].scrollEnabled = NO;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
}

-(UIScrollView*)scrollView
{
    NSString* sysVer = [[UIDevice currentDevice] systemVersion];
    NSArray* verComponent = [sysVer componentsSeparatedByString:@"."];
    if ([[verComponent objectAtIndex:0] integerValue]>=5.0) {
        return [super scrollView];
    }
    else
    {
        UIScrollView* rtval = nil;
        NSArray* subArray = [self subviews];
        for (UIView* subView in subArray) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                rtval = (UIScrollView*)subView;
                break;
            }
        }
        return rtval;
    }
}

@end

@implementation SVCommentModel
@synthesize authorString,contentString;
@synthesize createDate;

-(void)dealloc
{
    [authorString release];
    [contentString release];
    [createDate release];
    [super dealloc];
}


@end

@implementation SVRelativeModel
@synthesize titleString,urlString;
@synthesize createDate;

-(void)dealloc
{
    [titleString release];
    [urlString release];
    [createDate release];
    [super dealloc];
}


@end

@implementation SPagesModel

@synthesize singlePageSet,totalValue;

-(void)dealloc
{
    [singlePageSet release];
    [super dealloc];
}

@end

@implementation SSinglePageModel

@synthesize pages,indexValue,news;

-(void)dealloc
{
    [pages release];
    [super dealloc];
}

@end

@implementation SSingleNewsModel

@synthesize imagesSet,content,title,declare,video,createTime,media,posPage,url;
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
    [video release];
    [createTime release];
    [media release];
    [posPage release];
    [url release];
    [clickurl release];
    [commentSet release];
    [relativeNewsArray release];
    [extraData release];
    [titleSymbolData release];
    [bottomDeclare release];
    
    [super dealloc];
}

@end

//私有方法集合
@interface ArticleContentView(PrivateMethods)

- (void) layoutTextAtIndex:(NSInteger)index;
- (void) layoutPhotoTextAtIndex:(NSInteger)index;
- (void) layoutImageAtIndex:(NSInteger)index;
- (void) layoutImages:(NSArray *)images;
- (void) layoutPreImages:(NSInteger)index;
- (void) layoutVideo:(NSInteger)index;
- (NSInteger) LayoutImageArrayAtIndex:(NSInteger)index;
- (void) layoutSourceAtIndex:(NSInteger)index;
- (void) layoutClickToNexePageButtonAtIndex:(NSInteger)index;
- (CGFloat)getTextHeightWithText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)size;
- (void)layoutCopyrightAtIndex:(NSInteger)index;
- (void)layoutPageNumAtIndex:(NSInteger)index;
- (void)layoutSeprateLineAtIndex:(NSInteger)index;
- (void)layoutTableAtIndex:(NSInteger)index;

- (void) separatePhotoTextAndMainText:(NSString *)sourceString atIndex:(NSInteger)index;
- (void) getSortedImageArray:(SSingleNewsModel *)newModel;

@end

@implementation ArticleContentView
{
    CGSize webSize;
    BOOL contentLoaded;
}

@synthesize mySetting;
@synthesize myModel;
@synthesize imageDelegate;
@synthesize bHtmlStyle;
@synthesize bSourceHtml;
@synthesize bDateBeforeSource;

- (id) initWithFrame:(CGRect)frame
			   model:(SSingleNewsModel*)newModel 
			 setting:(SingleContentViewSetting*)newSetting
{
	self = [super initWithFrame:frame];
	if (self != nil) {
		self.mySetting = newSetting;
		self.myModel = newModel;
		self.delegate = self;
		
		//For memory control
		visibleArray = [[NSMutableArray alloc] initWithCapacity:0];
		recycleArray = [[NSMutableArray alloc] initWithCapacity:0];
		allContentArray = [[NSMutableArray alloc] initWithCapacity:0];
		
		textFontSize = mySetting.textFontSize;
		titleFontSize = mySetting.titleFontSize;
		sourceFontSize = mySetting.sourceFontSize;
		self.decelerationRate = 0.8;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = YES;
		preArrayConnt = 0;
		if (myModel.posPage != nil)
		{
			hasPagingLayout = YES;
			currentPage = myModel.posPage.indexValue;
			totalPages = myModel.posPage.pages.totalValue;
			
		}
		
		analysisResult = [[NSMutableArray alloc] initWithCapacity:0];
		
		
	    resultCopyArray = [[NSMutableArray alloc] initWithCapacity:0];
		[self getSortedImageArray:myModel];
		
		//解析正文内容
		[self analyseContent:myModel.content];
		//self.directionalLockEnabled = YES;
		
	}
	
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([imageDelegate respondsToSelector:@selector(view:clickedMode:)]) {
        [imageDelegate view:self clickedMode:0];
    }
}

-(void)setMyModel:(SSingleNewsModel *)amyModel
{
    if (myModel!=amyModel) {
        SSingleNewsModel* oldModel = myModel;
        myModel = [amyModel retain];
        [oldModel release];
    }
    contentLoaded = NO;
    webSize = CGSizeMake(0, 0);

}

#pragma mark --
#pragma mark memory control methods


- (void)addImagesToContentArray:(NSArray *)images
{
	YPos += GAPBETWEENCONTENTSCROLLVIEW;
	NSMutableDictionary *tempImages = [[NSMutableDictionary alloc] initWithCapacity:0];
	[tempImages setObject:[NSNumber numberWithInt:ImagesContentType] forKey:@"type"];
	[tempImages setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
	[tempImages setObject:images forKey:@"content"];
	[tempImages setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
	[allContentArray addObject:tempImages];
	[tempImages release];
	NSInteger scrollHeight = [MyTool isRetina]?SCROLLVIEWHEIGHT/2:SCROLLVIEWHEIGHT;
	YPos += scrollHeight;
}


- (void)analyseImage:(SImageModel *)imageModel
{
	YPos += GAPBETWEENCONTENTIMAGE;
	CGFloat viewWidth = self.bounds.size.width;
	
	CGSize photoSize = CGSizeMake(0, 0);
	//CGPoint photoOrigin = CGPointMake(mySetting.contentSpaceBetweenEdge + generalColumnWidth + mySetting.columnSpaceBetweenColumn, YPos);
	CGFloat photoSpaceBetweenEdge = mySetting.titleSpaceBetweenEdge;
	SImageModel* firstPhoto = imageModel;
    
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
	NSMutableDictionary *tempImage = [[NSMutableDictionary alloc] initWithCapacity:0];
	[tempImage setObject:[NSNumber numberWithInt:ImageContentType] forKey:@"type"];
	[tempImage setObject:[NSNumber numberWithBool:firstPhoto.inDiskValue] forKey:@"inDisk"];
	[tempImage setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
	[tempImage setObject:firstPhoto.url forKey:@"url"];
	[tempImage setObject:firstPhoto.fullPath forKey:@"fullPath"];
	[tempImage setObject:[NSNumber numberWithFloat:photoSize.height] forKey:@"height"];
	[tempImage setObject:[NSNumber numberWithFloat:photoSize.width] forKey:@"width"];
	[tempImage setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
	[tempImage setObject:[NSNumber numberWithFloat:(viewWidth - photoSize.width)/2] forKey:@"originX"];
	[allContentArray addObject:tempImage];
	[tempImage release];
	
	YPos += photoSize.height;	
	
}
- (void)analyseTitle
{
    YPos = mySetting.titleSpaceBetweenTop;
	CGFloat viewWidth = self.bounds.size.width;
    UIView* titleSymbol = nil;
    CGSize titleSymbbolSize = CGSizeZero;
    if ([imageDelegate respondsToSelector:@selector(view:titleSymbolWithData:margin:width:fontSize:)]) {
        id titleData = self.myModel.titleSymbolData;
        titleSymbol = [imageDelegate view:self titleSymbolWithData:titleData margin:mySetting.titleSpaceBetweenEdge width:viewWidth fontSize:titleFontSize];
        if (titleSymbol) {
            titleSymbbolSize = titleSymbol.bounds.size;
        }
    }
    CGFloat margin = mySetting.titleSpaceBetweenEdge+titleSymbbolSize.width;
    CGSize sizeOfString = [myModel.title sizeWithFont:[UIFont fontWithName:mySetting.titleFontName size:titleFontSize]
                                    constrainedToSize:CGSizeMake (viewWidth - margin*2, 500)
                                        lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat maxWidth = viewWidth - margin*2;
    int extraLen = 0;
    NSString* firstline = @"";
    if (sizeOfString.height>=titleFontSize*2) {
        while (extraLen==0||sizeOfString.height>=titleFontSize*3) {
            CGSize oldSize = sizeOfString;
            int stirngLen = [myModel.title length];
            NSInteger subLen = stirngLen/2+extraLen;
            if (subLen<=stirngLen)
            {
                NSString* tempString = [myModel.title substringWithRange:NSMakeRange(0, subLen)];
                firstline = tempString;
                CGSize tempSize = [tempString sizeWithFont:[UIFont fontWithName:mySetting.titleFontName size:titleFontSize]];
                if (tempSize.width>maxWidth) {
                    tempSize.width = maxWidth;
                }
                sizeOfString = [myModel.title sizeWithFont:[UIFont fontWithName:mySetting.titleFontName size:titleFontSize]
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
        NSMutableDictionary *tempSymbol = [[NSMutableDictionary alloc] initWithCapacity:0];
        [tempSymbol setObject:[NSNumber numberWithInt:TitleSymbolType] forKey:@"type"];
        [tempSymbol setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
        [tempSymbol setObject:titleSymbol forKey:@"content"];
        NSInteger symbolPos = YPos;
        NSInteger symbolExtraPos = 0;
        if (titleFontSize>titleSymbbolSize.height) {
            symbolExtraPos = titleFontSize/2 - titleSymbbolSize.height/2;
            symbolPos += symbolExtraPos;
        }
        [tempSymbol setObject:[NSNumber numberWithFloat:symbolPos] forKey:@"originY"];
        float originX =  viewWidth/2 - sizeOfString.width/2 - titleSymbbolSize.width;
        [tempSymbol setObject:[NSNumber numberWithFloat:originX] forKey:@"originX"];
        [tempSymbol setObject:[NSNumber numberWithFloat:titleSymbbolSize.height] forKey:@"height"];
        [tempSymbol setObject:[NSNumber numberWithFloat:titleSymbbolSize.width] forKey:@"width"];
        [allContentArray addObject:tempSymbol];
        [tempSymbol release];
    }
    
    NSMutableDictionary *tempTitle = [[NSMutableDictionary alloc] initWithCapacity:0];
    [tempTitle setObject:[NSNumber numberWithInt:TitleContentType] forKey:@"type"];
    [tempTitle setObject:firstline forKey:@"firstline"];
    [tempTitle setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
    [tempTitle setObject:myModel.title forKey:@"content"];
    [tempTitle setObject:[NSNumber numberWithFloat:sizeOfString.height] forKey:@"height"];
    [tempTitle setObject:[NSNumber numberWithFloat:sizeOfString.width] forKey:@"width"];
    NSInteger tempPos = YPos;
    NSInteger extraPos = 0;
    if (titleFontSize<titleSymbbolSize.height) {
        extraPos = titleSymbbolSize.height/2 - titleFontSize/2;
        tempPos += extraPos;
    }
    [tempTitle setObject:[NSNumber numberWithFloat:tempPos] forKey:@"originY"];
    [allContentArray addObject:tempTitle];
    [tempTitle release];
    
    NSInteger newHeight = sizeOfString.height + extraPos;
    if (newHeight>titleSymbbolSize.height) {
        YPos += newHeight;
    }
    else
    {
        YPos += titleSymbbolSize.height;
    }
}

-(void)analyseDeclare
{
    if (myModel.declare&&[myModel.declare compare:@""] != NSOrderedSame)
	{
		YPos += GAPBETWEENCONTENSEPRARATELINE;
        NSInteger margin = mySetting.titleSpaceBetweenEdge + 10;
        CGFloat viewWidth = self.frame.size.width;
		CGSize sizeOfString = [myModel.declare sizeWithFont:[UIFont fontWithName:mySetting.sourceFontName size:sourceFontSize] 
										constrainedToSize:CGSizeMake (viewWidth - margin*2, 500)
											lineBreakMode:UILineBreakModeWordWrap];
        CGFloat maxWidth = viewWidth - margin*2;
		NSMutableDictionary *tempTitle = [[NSMutableDictionary alloc] initWithCapacity:0];
		[tempTitle setObject:[NSNumber numberWithInt:DeclareContentType] forKey:@"type"];
		[tempTitle setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
		[tempTitle setObject:myModel.declare forKey:@"content"];
        [tempTitle setObject:[NSNumber numberWithBool:YES] forKey:@"center"];
		[tempTitle setObject:[NSNumber numberWithFloat:sizeOfString.height] forKey:@"height"];
        [tempTitle setObject:[NSNumber numberWithFloat:margin] forKey:@"margin"];
		[tempTitle setObject:[NSNumber numberWithFloat:sizeOfString.width] forKey:@"width"];
		[tempTitle setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
		[allContentArray addObject:tempTitle];
		[tempTitle release];
		
		YPos += sizeOfString.height;
	}
}

-(void)analyseBottomDeclare
{
    if (myModel.bottomDeclare&&[myModel.bottomDeclare compare:@""] != NSOrderedSame)
	{
		YPos += GAPBETWEENCONTENSEPRARATELINE;
        NSString* declareString = [NSString stringWithFormat:@"      %@",myModel.bottomDeclare];
        NSInteger margin = mySetting.titleSpaceBetweenEdge + 10;
        CGFloat viewWidth = self.frame.size.width;
		CGSize sizeOfString = [declareString sizeWithFont:[UIFont fontWithName:mySetting.sourceFontName size:sourceFontSize]
                                          constrainedToSize:CGSizeMake (viewWidth - margin*2, 500)
                                              lineBreakMode:UILineBreakModeWordWrap];
		NSMutableDictionary *tempTitle = [[NSMutableDictionary alloc] initWithCapacity:0];
		[tempTitle setObject:[NSNumber numberWithInt:BottomDeclareType] forKey:@"type"];
		[tempTitle setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
		[tempTitle setObject:declareString forKey:@"content"];
        [tempTitle setObject:[NSNumber numberWithBool:NO] forKey:@"center"];
		[tempTitle setObject:[NSNumber numberWithFloat:sizeOfString.height] forKey:@"height"];
        [tempTitle setObject:[NSNumber numberWithFloat:margin] forKey:@"margin"];
		[tempTitle setObject:[NSNumber numberWithFloat:sizeOfString.width] forKey:@"width"];
		[tempTitle setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
		[allContentArray addObject:tempTitle];
		[tempTitle release];
		
		YPos += sizeOfString.height + 20;
	}
}


- (void)analyseSeparateLine
{
	YPos += GAPBETWEENCONTENSEPRARATELINE;
	CGFloat viewWidth = self.frame.size.width;
	
	NSMutableDictionary *tempSeparateLine = [[NSMutableDictionary alloc] initWithCapacity:0];
	[tempSeparateLine setObject:[NSNumber numberWithInt:SeprateLineType] forKey:@"type"];
	[tempSeparateLine setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
	[tempSeparateLine setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
	[tempSeparateLine setObject:[NSNumber numberWithFloat:viewWidth - mySetting.titleSpaceBetweenEdge*2] forKey:@"width"];
	[allContentArray addObject:tempSeparateLine];
	[tempSeparateLine release];
	YPos += 1;	
}

- (NSString *)removeNewLineCharacter:(NSString *)contentString
{
	NSMutableString * removeString = [[NSMutableString alloc] initWithString:contentString];
	for (int i = 0; i < removeString.length; i++)
	{
	    unichar removeCharacter = [removeString characterAtIndex:i];
		if (removeCharacter == '\n')
		{
			if(i + 2 < removeString.length)
			{
				if ([removeString characterAtIndex:i+1] == '\n')
				{
					for (int j = i + 2; j < removeString.length; j++) {
						if ([removeString characterAtIndex:j] == '\n')
						{
							[removeString deleteCharactersInRange:NSMakeRange(j, 1)];
						}
						else {
							i = j;
							break;
						}
                        
					}
				}
			}
		}
	}
	return [removeString autorelease] ;
}
- (void)analyseText:(NSString *)text
{
    YPos +=  GAPBETWEENCONTENTITEM;
    NSString *tmpText = [self removeNewLineCharacter:text];
    CGFloat viewWidth = self.bounds.size.width;
    CGSize sizeOfContent = [tmpText sizeWithFont:[UIFont fontWithName:mySetting.textFontName size:textFontSize]
                               constrainedToSize:CGSizeMake (viewWidth - mySetting.contentSpaceBetweenEdge*2, 900000)
                                   lineBreakMode:UILineBreakModeWordWrap];
    if (bHtmlStyle&&webSize.height>0) {
        sizeOfContent = webSize;
    }
    NSMutableDictionary *tempText = [[NSMutableDictionary alloc] initWithCapacity:0];
    [tempText setObject:[NSNumber numberWithInt:TextContentType] forKey:@"type"];
    [tempText setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
    [tempText setObject:tmpText forKey:@"content"];
    [tempText setObject:[NSNumber numberWithFloat:sizeOfContent.height] forKey:@"height"];
    [tempText setObject:[NSNumber numberWithFloat:viewWidth - mySetting.contentSpaceBetweenEdge*2] forKey:@"width"];
    [tempText setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
    [allContentArray addObject:tempText];
    [tempText release];
    
    YPos += sizeOfContent.height;
}

- (void)analyseImages:(NSArray *)images
{
	YPos += GAPBETWEENCONTENTIMAGE;
	CGFloat viewWidth = self.bounds.size.width;
	int count = 1;
	CGFloat imagesLength = 0;
	
	CGFloat photoSpaceBetweenEdge = mySetting.titleSpaceBetweenEdge;
	
	for (int i = 0; i < images.count; i++)
	{
		SImageModel *onePhoto = [images objectAtIndex:i];
		imagesLength += (onePhoto.widthValue + 8 + IMAGESGAP);
		count++;
	}
	
	if (imagesLength <= viewWidth - 2 * photoSpaceBetweenEdge - (count - 1) * IMAGESGAP)
	{
		CGFloat lengthGap = viewWidth - 2 * photoSpaceBetweenEdge - imagesLength - (count - 1) * IMAGESGAP;
		CGFloat orignX = photoSpaceBetweenEdge + lengthGap / 2;
		CGFloat maxHeight = 0;
	    for (int i = 0; i< images.count; i++)
		{
			SImageModel *onePhoto = [images objectAtIndex:i];
			if (onePhoto.heightValue + 8 >= maxHeight)
			{
				maxHeight = onePhoto.heightValue + 8;
			}
		}
		for (int i = 0; i < images.count; i++)
		{
			SImageModel *onePhoto = [images objectAtIndex:i];
			CGRect tempFrame = CGRectMake(0, 0, onePhoto.widthValue +8, onePhoto.heightValue+8);
			tempFrame.origin.x = orignX;
			tempFrame.origin.y = YPos;
			
			NSMutableDictionary *tempImage = [[NSMutableDictionary alloc] initWithCapacity:0];
			[tempImage setObject:[NSNumber numberWithInt:ImageContentType] forKey:@"type"];
			[tempImage setObject:[NSNumber numberWithBool:onePhoto.inDiskValue] forKey:@"inDisk"];
			[tempImage setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
			[tempImage setObject:onePhoto.url forKey:@"url"];
			[tempImage setObject:onePhoto.fullPath forKey:@"fullPath"];
			[tempImage setObject:[NSNumber numberWithFloat:onePhoto.heightValue + 8] forKey:@"height"];
			[tempImage setObject:[NSNumber numberWithFloat:onePhoto.widthValue + 8] forKey:@"width"];
			[tempImage setObject:[NSNumber numberWithFloat:YPos + (maxHeight - onePhoto.heightValue + 8) / 2] forKey:@"originY"];
			[tempImage setObject:[NSNumber numberWithFloat:orignX] forKey:@"originX"];
			[allContentArray addObject:tempImage];
			[tempImage release];
			
			orignX += onePhoto.widthValue + IMAGESGAP + 8;
		}
		YPos += maxHeight;
	}
	else 
	{
		CGFloat maxHeight = 0;
		CGFloat maxWidth = 0;
	    for (int i = 0; i< images.count; i++)
		{
			SImageModel *onePhoto = [images objectAtIndex:i];
			if (onePhoto.heightValue + 8 >= maxHeight)
			{
				maxHeight = onePhoto.heightValue + 8;
				maxWidth = onePhoto.widthValue + 8;
			}
		}
		CGFloat lengthGap = imagesLength - (viewWidth - 2 * photoSpaceBetweenEdge - (count - 1) * IMAGESGAP);
		CGFloat orignX = photoSpaceBetweenEdge;
		CGFloat zoomRate = maxWidth / imagesLength;
		CGFloat newMaxWidth = maxWidth- zoomRate * lengthGap;
		CGFloat newMaxHeight = maxHeight * (newMaxWidth / maxWidth);
		for (int i = 0; i < images.count; i++)
		{
			SImageModel *onePhoto = [images objectAtIndex:i];
			CGFloat zoomRate = (onePhoto.widthValue + 8) / imagesLength;
			CGFloat newWidth = (onePhoto.widthValue + 8 )- zoomRate * lengthGap;
			CGFloat newHeight = (onePhoto.heightValue + 8) * (newWidth / (onePhoto.widthValue + 8));
			
			NSMutableDictionary *tempImage = [[NSMutableDictionary alloc] initWithCapacity:0];
			[tempImage setObject:[NSNumber numberWithInt:ImageContentType] forKey:@"type"];
			[tempImage setObject:[NSNumber numberWithBool:onePhoto.inDiskValue] forKey:@"inDisk"];
			[tempImage setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
			[tempImage setObject:onePhoto.url forKey:@"url"];
			[tempImage setObject:onePhoto.fullPath forKey:@"fullPath"];
			[tempImage setObject:[NSNumber numberWithFloat:newHeight ] forKey:@"height"];
			[tempImage setObject:[NSNumber numberWithFloat:newWidth ] forKey:@"width"];
			[tempImage setObject:[NSNumber numberWithFloat:(YPos + ( newMaxHeight - newHeight) / 2)] forKey:@"originY"];
			[tempImage setObject:[NSNumber numberWithFloat:orignX] forKey:@"originX"];
			[allContentArray addObject:tempImage];
			[tempImage release];
			
			orignX += (newWidth + IMAGESGAP);
		}
		
		YPos += newMaxHeight;
	}

}

- (void)analyseTopPhotoText:(SImageModel *)imageModel
{
	CGFloat viewWidth = self.bounds.size.width;
	SImageModel* firstPhoto = imageModel;
	NSString *text = firstPhoto.title;
    if (text&&[text length]>0) {
        YPos += GAPBETWEENCONTENTPHOTOTEXT;
        CGSize sizeOfContent = [text sizeWithFont:[UIFont fontWithName:mySetting.textFontName size:textFontSize]
                                constrainedToSize:CGSizeMake (viewWidth - mySetting.contentSpaceBetweenEdge*2, 90000)
                                    lineBreakMode:UILineBreakModeWordWrap];
        
        NSMutableDictionary *tempPhotoText = [[NSMutableDictionary alloc] initWithCapacity:0];
        [tempPhotoText setObject:[NSNumber numberWithInt:PhotoTextContentType] forKey:@"type"];
        [tempPhotoText setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
        [tempPhotoText setObject:text forKey:@"content"];
        [tempPhotoText setObject:[NSNumber numberWithFloat:sizeOfContent.height] forKey:@"height"];
        [tempPhotoText setObject:[NSNumber numberWithFloat:viewWidth - mySetting.contentSpaceBetweenEdge*2] forKey:@"width"];
        [tempPhotoText setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
        [allContentArray addObject:tempPhotoText];
        [tempPhotoText release];
        YPos += sizeOfContent.height;
    }
	
}

- (void)analysePhotoText:(NSInteger)index
{
	YPos += GAPBETWEENCONTENTPHOTOTEXT;
	CGFloat viewWidth = self.bounds.size.width;
	NSString *text = [analysisResult objectAtIndex:index];
	CGSize sizeOfContent = [text sizeWithFont:[UIFont fontWithName:mySetting.textFontName size:textFontSize] 
							constrainedToSize:CGSizeMake (viewWidth - mySetting.contentSpaceBetweenEdge*2, 90000)
								lineBreakMode:UILineBreakModeWordWrap];
	
	NSMutableDictionary *tempPhotoText = [[NSMutableDictionary alloc] initWithCapacity:0];
	[tempPhotoText setObject:[NSNumber numberWithInt:PhotoTextContentType] forKey:@"type"];
	[tempPhotoText setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
	[tempPhotoText setObject:text forKey:@"content"];
	[tempPhotoText setObject:[NSNumber numberWithFloat:sizeOfContent.height] forKey:@"height"];
	[tempPhotoText setObject:[NSNumber numberWithFloat:viewWidth - mySetting.contentSpaceBetweenEdge*2] forKey:@"width"];
	[tempPhotoText setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
	[allContentArray addObject:tempPhotoText];
	[tempPhotoText release];
	YPos += sizeOfContent.height;
}

- (NSInteger)analyseImageArrayAtIndex:(NSInteger)index
{
	
	NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:0];
	int i = index;
	for (; i < analysisResult.count; i++)
	{
		if ([[analysisResult objectAtIndex:i] isKindOfClass:[SImageModel class]] )
		{
			[images addObject:[analysisResult objectAtIndex:i]];
		}
		else
		{
			break;
		}		
	}
	
	if (images.count == 1)
	{
		[self analyseImage:[images objectAtIndex:0]];
		
	}	
	else 
	{
		[self analyseImages:images];
		
	}
	if (i == analysisResult.count) 
	{
		[images release];
		return i;
	}
	[self analysePhotoText: i ];
	
	i += 1;
	[images release];
	return i;
	
}

- (void)addVideoToContentArray
{
	YPos += GAPBETWEENCONTENTVIDEO;
	NSMutableDictionary *tempImages = [[NSMutableDictionary alloc] initWithCapacity:0];
	[tempImages setObject:[NSNumber numberWithInt:VideoContentType] forKey:@"type"];
	[tempImages setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
	[tempImages setObject:myModel.video forKey:@"content"];
    NSInteger height = myModel.video.thumb.heightValue;
    NSInteger width = myModel.video.thumb.widthValue;
    /*
     NSInteger realHeight = height;
     NSInteger realWidth = width;
     if (width>300) {
     realWidth = 300;
     }
     realHeight = (height*realWidth)/width;
     */
    NSInteger realHeight = [MyTool isRetina]?height/2:height;
    NSInteger realWidth = [MyTool isRetina]?width/2:width;
	[tempImages setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
    [tempImages setObject:[NSNumber numberWithFloat:realHeight] forKey:@"height"];
    [tempImages setObject:[NSNumber numberWithFloat:realWidth] forKey:@"width"];
	[allContentArray addObject:tempImages];
	[tempImages release];
	
	YPos += realHeight;
}

- (void)addTableToContentArrayAtIndex:(NSInteger)index
{
	YPos += GAPBETWEENCONTENTSCROLLVIEW;
    //CGFloat viewWidth = self.bounds.size.width;
    
    //    NSInteger maxCount = MAX([tableImages count], [tableTexts count]);
    //    
    //    for (int index = 0; index < maxCount; index++) {
    //        NSString *text = [tableTexts objectAtIndex:index];
    //        CGSize sizeOfContent = [text sizeWithFont:[UIFont fontWithName:mySetting.textFontName size:textFontSize] 
    //                                constrainedToSize:CGSizeMake (viewWidth - mySetting.contentSpaceBetweenEdge*2, 90000)
    //                                    lineBreakMode:UILineBreakModeWordWrap];
    //
    //        if(index < [tableTexts count]){
    //            NSMutableDictionary *tempTableText = [[NSMutableDictionary alloc] initWithCapacity:0];
    //            [tempTableText setObject:[NSNumber numberWithInt:TableTextContentType] forKey:@"type"];
    //            [tempTableText setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
    //            [tempTableText setObject:text forKey:@"content"];
    //            [tempTableText setObject:[NSNumber numberWithFloat:sizeOfContent.height] forKey:@"height"];
    //            [tempTableText setObject:[NSNumber numberWithFloat:viewWidth - mySetting.contentSpaceBetweenEdge*2] forKey:@"width"];
    //            [tempTableText setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
    //            [allContentArray addObject:tempTableText];
    //            [tempTableText release];
    //            
    //            YPos += sizeOfContent.height;
    //        }
    //        
    //        if(index < [tableImages count]){
    //            NSMutableDictionary *tempTables = [[NSMutableDictionary alloc] initWithCapacity:0];
    //            [tempTables setObject:[NSNumber numberWithInt:TableContentType] forKey:@"type"];
    //            [tempTables setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
    //            [tempTables setObject:[tableImages objectAtIndex:index] forKey:@"content"];
    //            [tempTables setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
    //            [allContentArray addObject:tempTables];
    //            [tempTables release];
    //            
    //            UIImage *tableImg = (UIImage*)[tableImages objectAtIndex:index];
    //            YPos += tableImg.size.height;
    //        }
    //    }
    
    //for (int i = 0; i < tableImages.count; i++) {
    if(index < [tableImages count]){
        //        NSString *text = [tableTexts objectAtIndex:index];
        //        CGSize sizeOfContent = [text sizeWithFont:[UIFont fontWithName:mySetting.textFontName size:textFontSize] 
        //                                constrainedToSize:CGSizeMake (viewWidth - mySetting.contentSpaceBetweenEdge*2, 90000)
        //                                    lineBreakMode:UILineBreakModeWordWrap];
        //        //NSLog(@"table text sizeOfContent: %f x %f", sizeOfContent.width, sizeOfContent.height);
        //        YPos += sizeOfContent.height;
        
        NSMutableDictionary *tempTables = [[NSMutableDictionary alloc] initWithCapacity:0];
        [tempTables setObject:[NSNumber numberWithInt:TableContentType] forKey:@"type"];
        [tempTables setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
        [tempTables setObject:[tableImages objectAtIndex:index] forKey:@"content"];
        [tempTables setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
        
        
        UIImage *tableImg = (UIImage*)[tableImages objectAtIndex:index];
        //NSLog(@"tableImg size: %f x %f", tableImg.size.width, tableImg.size.height);
        CGSize imageSize = tableImg.size;
        if (imageSize.width<self.bounds.size.width - 10*2) {
            YPos += tableImg.size.height;
            [tempTables setObject:[NSNumber numberWithFloat:imageSize.width] forKey:@"width"];
            [tempTables setObject:[NSNumber numberWithFloat:imageSize.height] forKey:@"height"];
        }
        else
        {
            CGFloat maxWidth = self.bounds.size.width - 10*2;
            CGFloat maxHeight = imageSize.height*maxWidth/imageSize.width;
            YPos += maxHeight;
            [tempTables setObject:[NSNumber numberWithFloat:maxWidth] forKey:@"width"];
            [tempTables setObject:[NSNumber numberWithFloat:maxHeight] forKey:@"height"];
        }
        [allContentArray addObject:tempTables];
        [tempTables release];
    }
}


- (void)analyseWholeContent
{
    if (hasVideoLayout)
    {
        [self addVideoToContentArray];
    }
    if (hasSTBLayout)
    {
        if (STBImages.count > 0)
        {
            [self addImagesToContentArray:STBImages];
        }
    }
    else 
    {
        [ModelImage removeObjectsInArray:removeImages];
        if (ModelImage.count == 1)
        {
            [self analyseImage:[ModelImage objectAtIndex:0]];
            [self analyseTopPhotoText: [ModelImage objectAtIndex:0] ];
        }
        else if (ModelImage.count > 1)
        {
            [self addImagesToContentArray:ModelImage];
        }
    }
    
    int index = preArrayConnt;
    for (; index < analysisResult.count;)
    {
        NSObject *oneObject = [analysisResult objectAtIndex:index];
        if ([oneObject isKindOfClass:[NSString class]])
        {
            NSString *contentText = (NSString *)oneObject;
            if (!bHtmlStyle) {
                while (contentText.length / 5000 > 0)
                {
                    NSString *tempText = [contentText substringToIndex:5000];
                    [self analyseText:tempText];
                    contentText = [contentText substringFromIndex:5000];
                }
            }
            if (contentText.length > 0)
            {
                [self analyseText:contentText];
            }
            index++;
        }
        else
        {
            index = [self analyseImageArrayAtIndex:index];
        }
        
        if(hadTableLayout){
            [self addTableToContentArrayAtIndex:index - 1];
        }
    }
    preArrayConnt = analysisResult.count; 
    
    /* The number of the tables is over the number of table texts, then add all other tables */
    if(hadTableLayout){
        if(tableImages.count > analysisResult.count){
            for (int index = analysisResult.count; index < tableImages.count; index++) {
                [self addTableToContentArrayAtIndex:index];
            }
        }
    }
}
- (void) analyseButton
{	
	YPos += GAPBETWEENCONTENTBUTTON;
	NSMutableDictionary *tempButton = [[NSMutableDictionary alloc] initWithCapacity:0];
	[tempButton setObject:[NSNumber numberWithInt:ButtonContentType] forKey:@"type"];
	[tempButton setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
	[tempButton setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
	[allContentArray addObject:tempButton];
	[tempButton release];
	
	
	YPos += (CLICKBUTTONHEIGHT + 15);
}

- (void)analyseSource
{
	YPos += GAPBETWEENCONTENSEPRARATELINE;
	NSMutableString * sourceString = [NSMutableString stringWithCapacity:0];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSDate *date = myModel.createTime;
	NSString *description = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	
	if ([myModel.media compare:@""] !=NSOrderedSame)
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
		
		NSMutableDictionary *tempPhotoText = [[NSMutableDictionary alloc] initWithCapacity:0];
		[tempPhotoText setObject:[NSNumber numberWithInt:SourceContentType] forKey:@"type"];
		[tempPhotoText setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
		[tempPhotoText setObject:sourceString forKey:@"content"];
		[tempPhotoText setObject:[NSNumber numberWithFloat:sizeOfSource.height] forKey:@"height"];
		[tempPhotoText setObject:[NSNumber numberWithFloat:viewWidth - mySetting.contentSpaceBetweenEdge*2] forKey:@"width"];
		[tempPhotoText setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
		[allContentArray addObject:tempPhotoText];
		[tempPhotoText release];
		YPos += sizeOfSource.height;
	}
}

- (void)analyseCopyright
{
	YPos += 10;
	NSMutableDictionary *tempCopyright = [[NSMutableDictionary alloc] initWithCapacity:0];
	
	[tempCopyright setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
	[tempCopyright setObject:[NSNumber numberWithInt:CopyrightContentType] forKey:@"type"];
	[tempCopyright setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
	
	[allContentArray addObject:tempCopyright];
	[tempCopyright release];
	
	YPos += CONTENTCOPYRIGHTHEIGHT;
}

- (void)analysePageNumber
{
	YPos += 45;
	
	NSMutableDictionary *tempPageNumber = [[NSMutableDictionary alloc] initWithCapacity:0];
	[tempPageNumber setObject:[NSNumber numberWithInt:PageNumContentType] forKey:@"type"];
	[tempPageNumber setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
	[tempPageNumber setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
	[tempPageNumber setObject:[NSNumber numberWithInt:currentPage] forKey:@"currentPage"];
	[tempPageNumber setObject:[NSNumber numberWithInt:totalPages] forKey:@"totalPage"];
	[allContentArray addObject:tempPageNumber];
	[tempPageNumber release];
	
	YPos += CONTENTCOPYRIGHTHEIGHT;
	
}

- (void) analyseEndOfArticle
{
	if ((hasPagingLayout) && (currentPage < totalPages))
	{
		[self analysePageNumber];
		[self analyseButton];
	}
	else {
		[self analyseCopyright];
	}
    
}

-(void)analyseClickURL
{
    if (myModel.clickurl&&[myModel.clickurl length])
    {
        YPos += GAPBETWEENCLICKURL;
        NSMutableDictionary *tempCopyright = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [tempCopyright setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
        [tempCopyright setObject:[NSNumber numberWithInt:ClickURLContentType] forKey:@"type"];
        [tempCopyright setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
        NSString* sourceString = myModel.clickurl;
        CGFloat viewWidth = self.bounds.size.width;
        CGSize sizeOfSource = [sourceString sizeWithFont:[UIFont fontWithName:mySetting.textFontName size:mySetting.textFontSize] 
                                       constrainedToSize:CGSizeMake (viewWidth - mySetting.contentSpaceBetweenEdge*2, 90000)
                                           lineBreakMode:UILineBreakModeWordWrap];
        [tempCopyright setObject:[NSNumber numberWithFloat:sizeOfSource.height] forKey:@"height"];
		[tempCopyright setObject:[NSNumber numberWithFloat:viewWidth - mySetting.contentSpaceBetweenEdge*2] forKey:@"width"];
        [tempCopyright setObject:sourceString forKey:@"content"];
        [allContentArray addObject:tempCopyright];
        
        [tempCopyright release];
        
        YPos += sizeOfSource.height;
    }
}

-(void)analyseExtraData
{
    if ([imageDelegate respondsToSelector:@selector(view:extraViewWithData:margin:width:fontSize:)]) {
        CGFloat viewWidth = self.bounds.size.width;
        YPos += GAPBETWEENEXTRADATA;
        
        id extraData = myModel.extraData;
        UIView* extraView = [imageDelegate view:self extraViewWithData:extraData margin:mySetting.contentSpaceBetweenEdge width:viewWidth fontSize:textFontSize];
        if (extraView) {
            NSMutableDictionary *tempCopyright = [[NSMutableDictionary alloc] initWithCapacity:0];
            [tempCopyright setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
            [tempCopyright setObject:[NSNumber numberWithInt:ExtraDataContentType] forKey:@"type"];
            [tempCopyright setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
            CGRect extraBounds = extraView.bounds;
            [tempCopyright setObject:[NSNumber numberWithFloat:extraBounds.size.height] forKey:@"height"];
            [tempCopyright setObject:[NSNumber numberWithFloat:extraBounds.size.width] forKey:@"width"];
            [tempCopyright setObject:extraView forKey:@"content"];
            [allContentArray addObject:tempCopyright];
            
            [tempCopyright release];
            
            YPos += extraBounds.size.height;
        }
    }
}

-(void)analyseCommentList
{
    if (myModel.commentSet)
    {
        if (myModel.relativeNewsArray) {
            YPos += GAPBETWEENRELATIVEANDCOMMENT;
        }
        else {
            YPos += GAPBETWEENCLICKURL;
        }
        NSMutableDictionary *tempCopyright = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [tempCopyright setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
        [tempCopyright setObject:[NSNumber numberWithInt:CommentContentType] forKey:@"type"];
        [tempCopyright setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
        NSArray* commentSet = myModel.commentSet;
        CGFloat viewWidth = self.bounds.size.width;
        [tempCopyright setObject:[NSNumber numberWithFloat:viewWidth] forKey:@"width"];
        [tempCopyright setObject:[NSNumber numberWithFloat:mySetting.contentSpaceBetweenEdge] forKey:@"margin"];
        [tempCopyright setObject:commentSet forKey:@"content"];
        [allContentArray addObject:tempCopyright];
        
        CommentTableView* ctableView = [[CommentTableView alloc] init];
        ctableView.dataArray = commentSet;
        ctableView.leftrightMargin = mySetting.contentSpaceBetweenEdge;
        NSInteger commentHeight = ctableView.fitHeight;
        [ctableView release];
        [tempCopyright setObject:[NSNumber numberWithFloat:commentHeight] forKey:@"height"];
		
        
        [tempCopyright release];
        
        YPos += commentHeight;
    }
}

-(void)analyseRelativeNewsList
{
    if (myModel.relativeNewsArray)
    {
        YPos += GAPBETWEENCLICKURL;
        NSMutableDictionary *tempCopyright = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [tempCopyright setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
        [tempCopyright setObject:[NSNumber numberWithInt:RelativeNewsType] forKey:@"type"];
        [tempCopyright setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
        NSArray* relativeNewsSet = myModel.relativeNewsArray;
        CGFloat viewWidth = self.bounds.size.width;
        [tempCopyright setObject:[NSNumber numberWithFloat:viewWidth] forKey:@"width"];
        [tempCopyright setObject:[NSNumber numberWithFloat:mySetting.contentSpaceBetweenEdge] forKey:@"margin"];
        [tempCopyright setObject:relativeNewsSet forKey:@"content"];
        [allContentArray addObject:tempCopyright];
        
        RelativeNewsTableView* ctableView = [[RelativeNewsTableView alloc] init];
        ctableView.dataArray = relativeNewsSet;
        ctableView.leftrightMargin = mySetting.contentSpaceBetweenEdge;
        NSInteger commentHeight = ctableView.fitHeight;
        [ctableView release];
        [tempCopyright setObject:[NSNumber numberWithFloat:commentHeight] forKey:@"height"];
		
        
        [tempCopyright release];
        
        YPos += commentHeight;
    }
}

- (void) analyseFrameOfAllContent
{
	
	[self analyseTitle];
    [self analyseDeclare];
	[self analyseSource];
    [self analyseSeparateLine];
	[self analyseWholeContent];
    [self analyseClickURL];
    [self analyseExtraData];
    [self analyseRelativeNewsList];
    [self analyseCommentList];
    [self analyseBottomDeclare];
    //[self analyseEndOfArticle];
	
	CGFloat viewWidth = self.bounds.size.width;
	self.contentSize = CGSizeMake(viewWidth, YPos);
    
}


- (void)getSortedImageArray:(SSingleNewsModel *)newModel
{
	[ModelImage release];
	ModelImage = nil;
	[removeImages release];
	removeImages = nil;
	removeImages = [[NSMutableArray alloc] initWithCapacity:0];
	
	ModelImage = [[NSMutableArray alloc] initWithCapacity:0];
	NSMutableArray *tempSet = [newModel imagesSet];
	for (int i = 0; i < tempSet.count; i ++)
	{
        SImageModel* oneModel = [tempSet objectAtIndex:i];
	    [ModelImage addObject:oneModel];
	}
    
}


- (NSInteger)getBeginDisplayIndex
{
	NSInteger i = 0;
	forwardHeight =  self.contentOffset.y - PREDISPLAYWIDTH ;
	forwardHeight = forwardHeight > 0 ? forwardHeight : 0;
	
	for (;i <= endDisplayIndex; i++)
	{
		NSDictionary *tempDic = [allContentArray objectAtIndex:i];
		CGFloat tempHeight = [[tempDic objectForKey:@"originY"] floatValue];
		if (tempHeight > forwardHeight) break;
	}
	
	i = i -1;
	return i > 0 ? i : 0;
}

- (NSInteger)getEndDisplayIndex
{
	NSInteger index = beginDisplayIndex;
	backwardHeight = 500 + PREDISPLAYWIDTH + self.contentOffset.y;
	
	for (;index < allContentArray.count; index++)
	{
		NSDictionary *tempDic = [allContentArray objectAtIndex:index];
		CGFloat tempHeight = [[tempDic objectForKey:@"originY"] floatValue];
		if (tempHeight > backwardHeight) break;
	}
	
	return --index;
}

- (void)removeControlFromIndex:(NSInteger)beginIndex to:(NSInteger)endIndex
{
	
	if (beginIndex > endIndex) return;
#if DEBUG
	NSLog(@"Enter into remove mentod, remove from %i to %i",beginIndex,endIndex);
#endif
	for (int index = beginIndex; index <= endIndex; index++)
	{
		for (int i = 0; i < visibleArray.count; i++)
		{
			NSDictionary *tempDic = [visibleArray objectAtIndex:i];
			int controlIndex = [[tempDic objectForKey:@"index"] intValue];
			if (controlIndex == index)
			{
				UIView *oneView = [tempDic objectForKey:@"control"];
				if (recycleArray.count == 5)
				{
					[recycleArray removeLastObject];
				}
				
				[recycleArray addObject:oneView];
				[visibleArray removeObjectAtIndex:i];
				[oneView removeFromSuperview];
#if DEBUG
				NSLog(@"removeView index = %i",index);
#endif
				NSMutableDictionary *mutableDic = [allContentArray objectAtIndex:index];
				[mutableDic setObject:[NSNumber numberWithBool:NO] forKey:@"isDisplayed"];
				break;
			}
		}
	}
#if DEBUG
	NSLog(@"leave the remove method");
#endif
}

- (void)displayControlFromIndex:(NSInteger)beginIndex to:(NSInteger)endIndex
{
	if (beginIndex > endIndex) return;
#if DEBUG
	NSLog(@"displayControlFromIndex Enter the display method,display from %i to %i",beginIndex,endIndex);
#endif
	for (int index = beginIndex; index <= endIndex; index++)
	{
		NSMutableDictionary *tempDic = [allContentArray objectAtIndex:index];
		ContentType type = [[tempDic objectForKey:@"type"] intValue];
		BOOL isDisplayed = [[tempDic objectForKey:@"isDisplayed"] boolValue];
		if (!isDisplayed)
		{
			switch (type) 
			{
				case TitleContentType:
					[self layoutTitleAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
                case TitleSymbolType:
					[self layoutTitleSymbolAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
                case BottomDeclareType:
                    [self layoutBottomDeclareAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
                    
                case DeclareContentType:
					[self layoutDeclareAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
                case ImagesContentType:
					[self layoutPreImages:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
				case VideoContentType:
					[self layoutVideo:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
                    
                case ImageContentType:
					[self layoutImageAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
				case SeprateLineType:
					[self layoutSeprateLineAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
                    
				case PhotoTextContentType:
					[self layoutPhotoTextAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
				case SourceContentType:
					[self layoutSourceAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
				case TextContentType:
					[self layoutTextAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
				case ButtonContentType:
					[self layoutClickToNexePageButtonAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
                case ClickURLContentType:
					[self layoutClickURLAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
                case ExtraDataContentType:
					[self layoutExtraDataAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
                case RelativeNewsType:
					[self layoutRelativeNewsContentAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
                case CommentContentType:
					[self layoutCommentContentAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
				case CopyrightContentType:
					[self layoutCopyrightAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
				case PageNumContentType:
					[self layoutPageNumAtIndex:index];
					[tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
                case TableContentType:
					[self layoutTableAtIndex:index];
                    [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isDisplayed"];
					break;
				default:
					break;
			}
		}
	}
#if DEBUG
	NSLog(@"leave the display method");
#endif
}
- (void) LoadControls
{
	int currentBeginIndex = [self getBeginDisplayIndex];
	int currentEndIndex = [self getEndDisplayIndex];
    
	if ((currentBeginIndex == beginDisplayIndex) && (currentEndIndex == endDisplayIndex)) return;
#if DEBUG
	NSLog(@"cuurentBeginIndex = %i, currentEndIndex = %i",currentBeginIndex,currentEndIndex);
	NSLog(@"beginIndex = %i, endIndex = %i",beginDisplayIndex,endDisplayIndex);
	for (int i = 0; i < visibleArray.count; i++)
	{
		NSDictionary *tempDic = [visibleArray objectAtIndex:i];
		UIView * oneView = [tempDic objectForKey:@"control"];
		if (oneView)
		{
            NSLog(@"index in visibleArray = %i",[[tempDic objectForKey:@"index"] intValue]);
		}
	}
#endif
	
	if (currentBeginIndex > beginDisplayIndex)
	{
		//NSLog(@"FORWARD");
		int deleteEndIndex = (currentBeginIndex - 1) > endDisplayIndex ? endDisplayIndex : (currentBeginIndex-1);
		[self removeControlFromIndex:beginDisplayIndex to:deleteEndIndex];
		
		int displayBeginIndex = (endDisplayIndex + 1) > currentBeginIndex ? (endDisplayIndex + 1) : currentBeginIndex;
		[self displayControlFromIndex:displayBeginIndex to:currentEndIndex];
	}
	else if (currentBeginIndex == beginDisplayIndex) 
	{
		if (currentEndIndex > endDisplayIndex)
		{
            //	NSLog(@"FORWARD");
			[self displayControlFromIndex:(endDisplayIndex + 1) to:currentEndIndex];
		}
		else 
		{
			//NSLog(@"BACKWORD");
			[self removeControlFromIndex:(currentEndIndex + 1) to:endDisplayIndex];
		}
	}
	else
	{
		//NSLog(@"BACKWORD");
		int deleteBeginIndex = (currentEndIndex + 1) > beginDisplayIndex ? (currentEndIndex + 1) : beginDisplayIndex;
		[self removeControlFromIndex:deleteBeginIndex to:endDisplayIndex];
		
		int displayEndIndex = (beginDisplayIndex -1) > currentEndIndex ? currentEndIndex : (beginDisplayIndex -1);
		[self displayControlFromIndex:currentBeginIndex to:displayEndIndex];
	}
	
	beginDisplayIndex = currentBeginIndex;
	endDisplayIndex = currentEndIndex;	
#if DEBUG
	for (int i = 0; i < visibleArray.count; i++)
	{
		NSDictionary *tempDic = [visibleArray objectAtIndex:i];
		UIView * oneView = [tempDic objectForKey:@"control"];
		if (oneView)
		{
			NSLog(@"index in visibleArray = %i",[[tempDic objectForKey:@"index"] intValue]);
		}
	}
#endif	
}

//排版方法，按照顺序进行排版
-(void)onLoad
{
	[self analyseFrameOfAllContent];
	beginDisplayIndex = 0;
	endDisplayIndex = [self getEndDisplayIndex];
	lastOffset = 0;
	[self displayControlFromIndex:beginDisplayIndex to:endDisplayIndex];
	
}

- (void)reLoadComment
{
    if (myModel.commentSet) {
        [self analyseCommentList];
        [self analyseDeclare];
        CGFloat viewWidth = self.bounds.size.width;
        self.contentSize = CGSizeMake(viewWidth, YPos);
        beginDisplayIndex = 0;
        endDisplayIndex = [self getEndDisplayIndex];
        beginDisplayIndex = endDisplayIndex-1;
        lastOffset = self.contentOffset.y;
        [self displayControlFromIndex:beginDisplayIndex to:endDisplayIndex];
    }
}

- (NSString *)removeWhitespaceAndNewlineFromString:(NSString *)sourceString
{
	NSCharacterSet *whiteCharacterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSMutableString *returnString = [sourceString mutableCopy];
	
	for (int i = 0; i < returnString.length; )
	{
		unichar oneCharacter = [returnString characterAtIndex:i];
		if ([whiteCharacterSet characterIsMember:oneCharacter])
		{
			[returnString deleteCharactersInRange:NSMakeRange(0, 1)];
			continue;
		}
		break;
	}
	return [returnString autorelease];
}
- (void )setPhotoTextWithString:(NSString *)contentString atIndex:(NSInteger)index
{
	//NSString *contentStr = [self removeWhitespaceAndNewlineFromString:contentString];
	NSString *originString = [((SImageModel *)[ModelImage objectAtIndex:index]).title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSUInteger biggerLength = originString.length > contentString.length ? contentString.length : originString.length;
	NSUInteger compareLength = biggerLength > 4 ? 4 : biggerLength;
    if(compareLength - 1 < contentString.length && compareLength - 1 < originString.length){//Avoid crashing because of out of range
        if ([[contentString substringToIndex:(compareLength -1)] compare:[originString substringToIndex:(compareLength -1)]] == NSOrderedSame)
        {
            [analysisResult addObject:originString];
        }
        else 
        {
            [analysisResult addObject:originString];
            [analysisResult addObject:contentString];
        }
    }
}

//解析文本内容，分离图注和正文
- (void) separatePhotoTextAndMainText:(NSString *)sourceString atIndex:(NSInteger)index
{
	NSString *photoText = [self removeWhitespaceAndNewlineFromString:sourceString];
	if (photoText.length > 1)
	{
		NSRange lineBreakRange = [photoText rangeOfString:@"\n"];
		if (lineBreakRange.location == NSNotFound)
		{
			NSString *tempString = [photoText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			[self setPhotoTextWithString:tempString atIndex:index];
		}
		else
		{
			[self setPhotoTextWithString:[photoText substringToIndex:lineBreakRange.location] atIndex:index];
			NSString *newTempString = [self removeWhitespaceAndNewlineFromString:[photoText substringFromIndex:lineBreakRange.location + lineBreakRange.length]];
			int templength = [newTempString length];
			if(templength > 0)
			{
			    [analysisResult addObject:newTempString];
			}
		}
	}
	
}

- (void)analyseSTBContent:(NSString *)STBString
{
	NSArray *tempArray = [STBString componentsSeparatedByString:@"{{"];
	for (int index = 0; index < [tempArray count]; index++)
	{
		NSString *tempString = [tempArray objectAtIndex:index];
		NSRange tempRange = [tempString rangeOfString:@"}}"];
		if (tempRange.location != NSNotFound )
		{
			int pictureIndex = [[tempString substringToIndex:tempRange.location ] intValue];
			SImageModel *onePhoto = [ModelImage objectAtIndex:pictureIndex - 1];
			if (!onePhoto)
			{
				NSLog(@"找不到ImageMidModel");
			}
			[STBImages addObject: onePhoto];
			[removeImages addObject:onePhoto];
		}
	}
}

- (BOOL)analyseTableContent:(NSString*)tableString
{
    NSMutableArray *tableArray = [[NSMutableArray alloc] init];
    NSArray *rowArray = [tableString componentsSeparatedByString:@"|-"];
    BOOL hasTable = NO;
	for (int row = 0; row < [rowArray count]; row++)
	{
		NSString *rowString = [rowArray objectAtIndex:row];
        NSArray *colArray = [rowString componentsSeparatedByString:@"||"];
        if (!hasTable) {
            for (NSString* colString in colArray) {
                NSString* tempColString = [colString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                if (tempColString&&![tempColString isEqualToString:@""]) {
                    hasTable = YES;
                }
            }
        }
        [tableArray addObject:colArray];
    }
    
    if (hasTable) {
        GridViewController *gridController = [[GridViewController alloc] initWithGridData:tableArray];
        UIImage *gridImg = [gridController getTableImage];
        [tableImages addObject:gridImg];
        //[analysisResult addObject:gridImg];
        [gridController release];
        [tableArray release];
    }
    return hasTable;
}


//解析正文内容，判断正文的类型
- (void)analyseContent:(NSString *)content
{
	hasSTBLayout = NO;
	hasVideoLayout = NO;
    hadTableLayout = NO;
	NSString *tempContent = [content stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	NSRange stbBeginRange = [tempContent rangeOfString:@"{[STB["];
    NSRange tableBeginRange = [tempContent rangeOfString:@"{|TABLE"];
	NSArray * tempArray;
	if (myModel.video)
	{
		hasVideoLayout = YES;
		
	}
    
    if(tableBeginRange.location != NSNotFound){/* Find the tables */
        [tableImages release];
        tableImages = nil;
        tableImages = [[NSMutableArray alloc] initWithCapacity:0];
        
        [tableTexts release];
        tableTexts = nil;
        tableTexts = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSRange tableBeginRange = [content rangeOfString:@"{|TABLE"];
        if (tableBeginRange.location != NSNotFound) {
            hadTableLayout = NO;
            
            NSArray *tempArray = [content componentsSeparatedByString:@"{|TABLE"];
            if([tempArray count] > 0){
                NSMutableArray *tableData = [[NSMutableArray alloc] initWithCapacity:0];
                NSString* firstString = [tempArray objectAtIndex:0];
                [tableTexts addObject:firstString];
                for (int index = 1; index < [tempArray count]; index++) {
                    //NSLog(@"tempArray[%i]: %@", index, [tempArray objectAtIndex:index]);
                    NSArray *array1 = [[tempArray objectAtIndex:index] componentsSeparatedByString:@"|}"];
                    [tableData addObject:[array1 objectAtIndex:0]];
                    [tableTexts addObject:[array1 lastObject]];
                }
                int analysisResultFisrt = [analysisResult count];
                for (int index = 0; index < tableTexts.count; index++) {
                    [analysisResult addObject:[tableTexts objectAtIndex:index]];
                    //NSLog(@"tableTexts[%i]: %@/n", index, [tableTexts objectAtIndex:index]);
                    //NSLog(@"analysisResult[%i]: %@/n", index, [analysisResult objectAtIndex:index]);
                }
                BOOL removedFirst = NO;
                for (int index = 0; index < tableData.count; index++) {
                    BOOL ret = [self analyseTableContent:[tableData objectAtIndex:index]];
                    //NSLog(@"tableData[%i]: %@/n", index, [tableData objectAtIndex:index]);
                    if(ret)
                    {
                        hadTableLayout = YES;
                    }
                    else
                    {
                        if (!removedFirst) {
                            removedFirst = YES;
                            if ([firstString isEqualToString:@"\n\u3000\u3000\n"]) {
                                [tableTexts removeObjectAtIndex:0];
                                if ([analysisResult count]>analysisResultFisrt) {
                                    [analysisResult removeObjectAtIndex:analysisResultFisrt];
                                }
                                if ([analysisResult count]>analysisResultFisrt) {
                                    NSString* oldString = [analysisResult objectAtIndex:analysisResultFisrt];
                                    if ([oldString hasPrefix:@"\n\n\n"]) {
                                        oldString = [oldString substringFromIndex:3];
                                        [analysisResult replaceObjectAtIndex:analysisResultFisrt withObject:oldString];
                                        //                                        [tableTexts replaceObjectAtIndex:0 withObject:oldString];
                                    }
                                }
                            }
                        }
                    }
                }
                [tableData release];
            }
        }
    }         
    else
    {      /* Find the images */
        if (stbBeginRange.location != NSNotFound)
        {
            hasSTBLayout = YES;
            
            [STBImages release];
            STBImages = nil;
            STBImages = [[NSMutableArray alloc] initWithCapacity:0];
            NSRange stbEndRange = [content rangeOfString:@"]]}"];
            int tempLocation = stbBeginRange.location + stbBeginRange.length;
            [self analyseSTBContent:[content substringWithRange:NSMakeRange(tempLocation, stbEndRange.location - tempLocation)]];
            
            
            tempArray = [[tempContent substringFromIndex:(stbEndRange.location + stbEndRange.length)] componentsSeparatedByString:@"{{"];
        }
        else
        {
            tempArray = [tempContent componentsSeparatedByString:@"{{"];
        }
        for (int index = 0; index < [tempArray count]; index++)
        {
            NSString *tempString = [tempArray objectAtIndex:index];
            NSRange tempRange = [tempString rangeOfString:@"}}"];
            if (tempRange.location != NSNotFound )
            {
                int pictureIndex = [[tempString substringToIndex:tempRange.location ] intValue];
                
                SImageModel *onePhoto = [ModelImage objectAtIndex:pictureIndex - 1];
                [analysisResult addObject: onePhoto];
                [removeImages addObject:onePhoto];
                
                [self separatePhotoTextAndMainText:[tempString substringFromIndex:tempRange.location + tempRange.length] atIndex:(pictureIndex -1)];
                continue;
            }
            if ([tempString compare:@""] != NSOrderedSame)
            {
                //[analysisResult addObject:[self removeWhitespaceAndNewlineFromString:tempString]];
                [analysisResult addObject:tempString];
            }
        }
    }
}

- (void)dealloc {
	self.mySetting = nil;
	self.myModel = nil;
	[analysisResult release];
	[visibleArray release];
	[recycleArray release];
	[allContentArray release];
	[resultCopyArray release];
	[ImageWidthArray release];
	[removeImages release];
	[STBImages release];
	[ModelImage release];
    [tableImages release];
    [super dealloc];
}

- (UIView *)CreatViewFromRecyleWithContentType:(ContentType)type 
{
	Class tempClass = nil;
	switch (type) {
		case TitleContentType:
            tempClass = [ArticleTitleLabel class];
            break;
		case PhotoTextContentType:
            tempClass = [UILabel class];
			break;
        case BottomDeclareType:
        case DeclareContentType:
            tempClass = [DeclareView class];
            break;
		case TextContentType:
            if (!bHtmlStyle) {
                tempClass = [UILabel class];
            }
            else {
                tempClass = [MyLabelView class];
            }
			break;
		case SourceContentType:
			tempClass = [UILabel class];
			break;
		case ImageContentType:
			tempClass = [CustomImageView class];
			break;
		case ImagesContentType:
			tempClass = [CustomScrollViewForContent class];
			break;
		case ButtonContentType:
			tempClass = [UIButton class];
			break;
        case ClickURLContentType:
			tempClass = [ClickURLBtn class];
			break;
        case RelativeNewsType:
			tempClass = [RelativeNewsTableView class];
			break;
        case CommentContentType:
			tempClass = [CommentTableView class];
			break;
		case CopyrightContentType:
			tempClass = [UIImageView class];
			break;
		case PageNumContentType:
			tempClass = [UIView class];
			break;
		case SeprateLineType:
			tempClass = [UIImageView class];
			break;
		case VideoContentType:
			tempClass = [VideoInContentView class];
			break;
            
		default:
			break;
	}
	UIView *tempView =nil;
	for (int i = 0; i < recycleArray.count; i++)
	{
		UIView  *oneView = [recycleArray objectAtIndex:i];
		if ([oneView isKindOfClass:tempClass])
		{
			[oneView retain];
			tempView = oneView;
			[recycleArray removeObjectAtIndex:i];
			break;
		}
	}
	return tempView;
}

-(void)layoutTitleSymbolAtIndex:(NSInteger)index
{
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	CGFloat originX = [[tempDic objectForKey:@"originX"] floatValue];
    CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
	CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
	UIView *symbolView = [tempDic objectForKey:@"content"];
	
	CGRect tempFrame = CGRectMake(originX, originY, width, height);
	
	symbolView.frame = tempFrame;

	[self addSubview:symbolView];
	
	NSDictionary *LalbelDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",symbolView,@"control",nil];
	[visibleArray addObject:LalbelDic];
}

- (void)layoutTitleAtIndex:(NSInteger)index
{
	CGFloat viewWidth = self.bounds.size.width;
	//title
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
	CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
	NSString *tempString = [tempDic objectForKey:@"content"];
    NSString *firstline = [tempDic objectForKey:@"firstline"];
	
	CGRect tempFrame = CGRectMake((viewWidth-width)/2, originY, width, height);
	
	
	ArticleTitleLabel *titleLabel = (ArticleTitleLabel *)[self CreatViewFromRecyleWithContentType:TitleContentType];
	if (!titleLabel) 
	{
		titleLabel = [[ArticleTitleLabel alloc] initWithFrame:tempFrame];
	}
	else
	{
		titleLabel.frame = tempFrame;
	}
    
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.lineBreakMode = UILineBreakModeWordWrap;
	titleLabel.numberOfLines = 50;
    titleLabel.firstLine = firstline;
    UIColor* titleColor = [mySetting titleFontColor];
	titleLabel.textColor = titleColor;
	[titleLabel setText:tempString];
	//UIFont *font = [UIFont boldSystemFontOfSize:titleFontSize];
	UIFont *font = [UIFont fontWithName:mySetting.titleFontName size:titleFontSize];
	[titleLabel setFont:font];
	[titleLabel setBackgroundColor:[UIColor clearColor]];	
	[self addSubview:titleLabel];
	
	NSDictionary *LalbelDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",titleLabel,@"control",nil];
	[visibleArray addObject:LalbelDic];
	[titleLabel release];
	
}

-(void)layoutDeclareAtIndex:(NSInteger)index
{
    CGFloat viewWidth = self.bounds.size.width;
	//title
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
	CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
    CGFloat margin = [[tempDic objectForKey:@"margin"] floatValue];
	NSString *tempString = [tempDic objectForKey:@"content"];
    BOOL center = [[tempDic objectForKey:@"center"] boolValue];
	
	CGRect tempFrame = CGRectMake(0, originY-4, viewWidth, height+8);
	
	
	DeclareView *titleLabel = (DeclareView *)[self CreatViewFromRecyleWithContentType:DeclareContentType];
	if (!titleLabel) 
	{
		titleLabel = [[DeclareView alloc] initWithFrame:tempFrame];
	}
	else
	{
		titleLabel.frame = tempFrame;
	}
    
    CGRect stringRect = CGRectMake((viewWidth-width)/2, 4, width, height);
    UIFont *font = [UIFont fontWithName:mySetting.sourceFontName size:sourceFontSize];
    UITextAlignment align = UITextAlignmentCenter;
    if (!center) {
        align = UITextAlignmentLeft;
    }
    [titleLabel setString:tempString stringRect:stringRect margin:margin-10 font:font fontColor:[mySetting sourceFontColor] textAlignment:align];
    [self addSubview:titleLabel];
	
	NSDictionary *LalbelDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",titleLabel,@"control",nil];
	[visibleArray addObject:LalbelDic];
	[titleLabel release];
}

-(void)layoutBottomDeclareAtIndex:(NSInteger)index
{
    CGFloat viewWidth = self.bounds.size.width;
	//title
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
	CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
    CGFloat margin = [[tempDic objectForKey:@"margin"] floatValue];
	NSString *tempString = [tempDic objectForKey:@"content"];
    BOOL center = [[tempDic objectForKey:@"center"] boolValue];
	
	CGRect tempFrame = CGRectMake(0, originY-4, viewWidth, height+8);
	
	
	DeclareView *titleLabel = (DeclareView *)[self CreatViewFromRecyleWithContentType:BottomDeclareType];
	if (!titleLabel)
	{
		titleLabel = [[DeclareView alloc] initWithFrame:tempFrame];
	}
	else
	{
		titleLabel.frame = tempFrame;
	}
    
    CGRect stringRect = CGRectMake((viewWidth-width)/2, 4, width, height);
    UIFont *font = [UIFont fontWithName:mySetting.sourceFontName size:sourceFontSize];
    UITextAlignment align = UITextAlignmentCenter;
    if (!center) {
        align = UITextAlignmentLeft;
    }
    [titleLabel setString:tempString stringRect:stringRect margin:margin-10 font:font fontColor:[mySetting sourceFontColor] textAlignment:align];
    BOOL needLoad = YES;
    if (bHtmlStyle&&!contentLoaded) {
        needLoad = NO;
    }
    if (needLoad) {
        [self addSubview:titleLabel];
    }
	
	NSDictionary *LalbelDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",titleLabel,@"control",nil];
	[visibleArray addObject:LalbelDic];
	[titleLabel release];
}


- (void) layoutTextAtIndex:(NSInteger)index
{
	CGFloat viewWidth = self.bounds.size.width;
	
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
	CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
	NSString *tempString = [tempDic objectForKey:@"content"];
	
	CGRect tempFrame = CGRectMake((viewWidth-width)/2, originY, width, height);
	
	
	textLabel = (UILabel *)[self CreatViewFromRecyleWithContentType:TextContentType];
	if (!textLabel) 
	{
        if (!bHtmlStyle) {
            textLabel = [[UILabel alloc] initWithFrame:tempFrame];
        }
		else {
            MyLabelView* webView = [[MyLabelView alloc] initWithFrame:tempFrame];
            webView.bSourceHtml = bSourceHtml;
            webView.delegate = self;
            textLabel = (UILabel*)webView;
            
        }
	}
	else
	{
        if ([textLabel isKindOfClass:[MyLabelView class]]) {
            [(MyLabelView*)textLabel setBSourceHtml:bSourceHtml];
        }
		textLabel.frame = tempFrame;
	}
	
	//textLabel.backgroundColor = [UIColor grayColor];
	//[contentLabel sizeToFit];
	textLabel.textColor = [mySetting textFontColor];
    [textLabel setText:tempString];
    [textLabel setBackgroundColor:[UIColor clearColor]];
	[textLabel setFont:[UIFont fontWithName:mySetting.textFontName	size:textFontSize]];
    if (!bHtmlStyle) {
        textLabel.textAlignment = UITextAlignmentLeft;
        textLabel.lineBreakMode = UILineBreakModeWordWrap;
        textLabel.numberOfLines = 0;
        
    }
	
	[self addSubview:textLabel];
	
	NSDictionary *LalbelDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",textLabel,@"control",nil];
	[visibleArray addObject:LalbelDic];
	[textLabel release];
	//YPos += sizeOfContent.height + mySetting.sourceSpaceBetweenText;
	
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.hidden = NO;
    webView.userInteractionEnabled = YES;
    if (!contentLoaded) {
        contentLoaded = YES;
        
        float h;
        NSString *heightString = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"body\").offsetHeight;"];
        h = [heightString floatValue] + 10;
        
        for (NSMutableDictionary *tempDic in allContentArray) {
            ContentType type = [[tempDic objectForKey:@"type"] intValue];
            if (type==TextContentType) {
                [tempDic setValue:[NSNumber numberWithFloat:h] forKey:@"height"];
            }
        }
        CGRect oldRect = webView.bounds;
        if (YES) {
            webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, h);
            webSize = webView.bounds.size;
            [self refreshContent];
        }
    }
    

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType==UIWebViewNavigationTypeReload) {
        return YES;
    }
    else if(navigationType==UIWebViewNavigationTypeOther)
    {
        return YES;
    }
    else if(navigationType==UIWebViewNavigationTypeLinkClicked)
    {
        NSString* string = [[request URL] absoluteString];
        NSArray* supportedImageSuffixs = [NSArray arrayWithObjects:@".tiff",@".tif",@".jpg",@".jpeg",@".gif",@".png",@".bmp",@".BMPf", nil];
        BOOL bImageURL = NO;
        for (NSString* oneSuffix in supportedImageSuffixs) {
            NSInteger length = [oneSuffix length];
            if ([string length]>length) {
                NSString* subString = [string substringWithRange:NSMakeRange([string length]-length, length)];
                if ([[subString lowercaseString] isEqualToString:[oneSuffix lowercaseString]]) {
                    bImageURL = YES;
                    break;
                }
            }
        }
        if (bImageURL) {
            if ([imageDelegate respondsToSelector:@selector(view:imageClicked:)]) {
                [imageDelegate view:self imageClicked:string];
            }
        }
        else
        {
            if ([imageDelegate respondsToSelector:@selector(view:urlClicked:)]) {
                [imageDelegate view:self urlClicked:string];
            }
        }
        return NO;
    }
    return NO;
}

- (void) layoutImageAtIndex:(NSInteger)index
{
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
	CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
	CGFloat originX = [[tempDic objectForKey:@"originX"] floatValue];
	CGRect tempFrame = CGRectMake(originX, originY, width, height);
	BOOL inDisk = [[tempDic objectForKey:@"inDisk"] boolValue];
	NSString *url = [tempDic objectForKey:@"url"];
	
	CustomImageView *imageView = (CustomImageView *)[self CreatViewFromRecyleWithContentType:ImageContentType];
	if (!imageView)
	{
		imageView = [[CustomImageView alloc] init];
	}
	else {
        //		[[SDataCenter sharedCenter] removeCallBackDelegate:imageView];
	}
    
    imageView.delegate = self;
    
	imageView.isNeedBorder = YES;
	imageView.border = 4;
    
    CGRect imageRect = CGRectMake(originX, originY, width, height);
    imageView.frame = imageRect;
	if (inDisk)
	{
        NSString *fullPath = [tempDic objectForKey:@"fullPath"];
        [imageView setContentImageWithFrame:tempFrame imageURL:fullPath placeImage:[UIImage imageNamed:placeholder_photo]];
	}
	else
	{
        [imageView setContentImageWithFrame:tempFrame imageURL:url placeImage:[UIImage imageNamed:placeholder_photo]];
	}
    
	[self addSubview:imageView];
	
	NSDictionary *imageDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",imageView,@"control",nil];
	[visibleArray addObject:imageDic];
	[imageView release];
	//YPos += photoSize.height + mySetting.textSpaceBetweenPhoto;	
	
}

-(void)CustomImageViewClicked:(CustomImageView*)aView
{
    if ([imageDelegate respondsToSelector:@selector(view:imageClicked:)]) {
        if (!aView.imageURL) {
            NSData* imageData = UIImagePNGRepresentation(aView.contentImage);
            aView.imageURL = [MyTool writeToDocument:imageData folder:@"temp" fileName:@"tableimage.png"];
        }
        [imageDelegate view:self imageClicked:aView.imageURL];
    }
}

-(void)CustomImageViewFinishLoading:(CustomImageView*)view size:(CGSize)imageSize
{
    BOOL needReload = NO;
    NSString* oldImageString = view.imageURL;
    for (SImageModel* model in ModelImage) {
        if ([model.url isEqualToString:oldImageString]) {
            if (model.heightValue==0&&model.widthValue==0) {
                model.widthValue = imageSize.width;
                model.heightValue = imageSize.height;
                needReload = YES;
            }
        }
    if (needReload) {
        for (int i=0;i<[allContentArray count];i++) {
            NSMutableDictionary *tempDic = [allContentArray objectAtIndex:i];
            ContentType type = [[tempDic objectForKey:@"type"] intValue];
            if (type==ImageContentType) {
                NSString* url = [tempDic objectForKey:@"url"];
                if ([url isEqualToString:oldImageString]) {
                    CGFloat viewWidth = self.bounds.size.width;
                    
                    CGSize photoSize = CGSizeMake(0, 0);
                    CGFloat photoSpaceBetweenEdge = mySetting.titleSpaceBetweenEdge;
                    if (imageSize.width>0&&imageSize.height>0) {
                        if (imageSize.width > viewWidth - 2*photoSpaceBetweenEdge) {
                            photoSize.width = viewWidth - 2*photoSpaceBetweenEdge;
                            photoSize.height = imageSize.height * (photoSize.width / imageSize.width);
                        }
                        else
                        {
                            photoSize.width = imageSize.width;
                            photoSize.height = imageSize.height;
                        }
                    }
                    else
                    {
                        photoSize.width = 100;
                        photoSize.height = 100;
                    }
                    
                    photoSize.width += 8;
                    photoSize.height += 8;
                    
                    [tempDic setObject:[NSNumber numberWithFloat:photoSize.height] forKey:@"height"];
                    [tempDic setObject:[NSNumber numberWithFloat:photoSize.width] forKey:@"width"];
                    [tempDic setObject:[NSNumber numberWithFloat:(viewWidth - photoSize.width)/2] forKey:@"originX"];
                }
            }
        }
    }
    }
    
    if (needReload) {
        [self refreshContent];
    }
}

- (void)layoutVideo:(NSInteger)index
{
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	SVideoModel *videoModel = [tempDic objectForKey:@"content"];
	CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
    CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
    
	CGRect videoFrame = CGRectMake((self.bounds.size.width - width) /2, originY, width, height);
	VideoInContentView *videoItemView = (VideoInContentView *)[self CreatViewFromRecyleWithContentType:VideoContentType];
	if (!videoItemView)
	{
		videoItemView = [[VideoInContentView alloc] initWithFrame:videoFrame model:videoModel];
	}
	else {
		videoItemView.frame = videoFrame;
	}
    
    
	[self addSubview:videoItemView];
	NSDictionary *videoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",videoItemView,@"control",nil];
	[visibleArray addObject:videoDic];
	
	[videoItemView release];
	
}

- (void)layoutPhotoTextAtIndex:(NSInteger)index
{
	CGFloat viewWidth = self.bounds.size.width;
	//title
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
	CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
	NSString *tempString = [tempDic objectForKey:@"content"];
	
	CGRect tempFrame = CGRectMake((viewWidth-width)/2, originY, width, height);
	
	
	UILabel *contentLabel = (UILabel *)[self CreatViewFromRecyleWithContentType:PhotoTextContentType];
	if (!contentLabel) 
	{
		contentLabel = [[UILabel alloc] initWithFrame:tempFrame];
	}
	else
	{
		contentLabel.frame = tempFrame;
	}
	
	contentLabel.textAlignment = UITextAlignmentCenter;
	contentLabel.lineBreakMode = UILineBreakModeWordWrap;
	contentLabel.numberOfLines = 90000;
	[contentLabel setText:tempString];
	contentLabel.textColor = [mySetting imageFontColor];
	[contentLabel setFont:[UIFont fontWithName:CurrentAirticleFontName size:14]];
	[contentLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:contentLabel];
	
	NSDictionary *LalbelDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",contentLabel,@"control",nil];
	[visibleArray addObject:LalbelDic];
    
	[contentLabel release];
	//YPos += sizeOfContent.height + mySetting.sourceSpaceBetweenText;
}

- (void) showMainScrollView:(UITapGestureRecognizer *)tapGesture
{
	CustomScrollViewForContent *fromScrollView = (CustomScrollViewForContent *)(tapGesture.view);
	CGPoint location = [tapGesture locationInView:fromScrollView];
	CGFloat offset = fromScrollView.scrollView.contentOffset.x;
	
	CGFloat originX = location.x + offset - 10;
	CGFloat totoalWidth = 0;
	int i = 0;
	for (;i < ImageWidthArray.count;i++)
	{
		CGFloat imageWith = [[ImageWidthArray objectAtIndex:i] floatValue];
		totoalWidth += imageWith;
		if (originX > imageWith)
		{
			originX -= (imageWith + 10);
			
			continue;
		}
		else 
		{
			break;
		}
	}
	i = i >= ImageWidthArray.count ? ImageWidthArray.count - 1 : i;
    SImageModel* oneModel = [fromScrollView.images objectAtIndex:i];
    
    if ([imageDelegate respondsToSelector:@selector(view:imageClicked:)]) {
        [imageDelegate view:self imageClicked:oneModel.url];
    }
}

- (void)layoutPreImages:(NSInteger)index
{
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	NSArray *images = [tempDic objectForKey:@"content"];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	ImageWidthArray = [[NSMutableArray alloc] initWithCapacity:0];
    //	if (hasSTBLayout)
    //	{
    //		images = STBImages;
    //	
    //保留，为以后获取小点大原图作准备
    //		for (SImageModel *onePhoto in images)
    //		{
    //			NSMutableString *tempURL = [onePhoto.url mutableCopy];
    //			NSRange urlRange = [tempURL rangeOfString:@"_small_h"];
    //			if (urlRange.location != NSNotFound)
    //			{
    //				[tempURL deleteCharactersInRange:urlRange];
    //				onePhoto.url = tempURL;
    //			}
    //			[tempURL release];
    //		}
    //	
	//}
    //	else
    //	{
    //		images = ModelImage;
    //	}
	
	CGFloat viewWidth = self.bounds.size.width;
    NSInteger scrollHeight = [MyTool isRetina]?SCROLLVIEWHEIGHT/2:SCROLLVIEWHEIGHT;
	CGRect customFrame = CGRectMake((viewWidth - SCROLLVIEWWIDTH)/2, originY, SCROLLVIEWWIDTH, scrollHeight);
	
    
	CustomScrollViewForContent *customView = (CustomScrollViewForContent *)[self CreatViewFromRecyleWithContentType:ImagesContentType];
	
	if (!customView)
	{
        customView = [[CustomScrollViewForContent alloc] initWithFrame:customFrame];
	}
	else {
		customView.frame = customFrame;
		[customView.scrollView removeAllSubViews];
		if (customView.label)
		{
			[customView.label removeFromSuperview];
			customView.label = nil;
		}
	}
    
	
	CGRect scrollFrame = customView.scrollView.frame;
	UIScrollView *scrollView = customView.scrollView;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = YES;
	customView.images = images;
    //	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMainScrollView:)];
    //	[customView addGestureRecognizer:tapGesture];
    //	[tapGesture release];
//	CGFloat ___h = 0;
//    NSMutableArray *sourceImageArray = [NSMutableArray array];
    
	CGFloat orignX = 0;
	for (int i = 0; i < images.count; i++)
	{
		SImageModel *onePhoto = [images objectAtIndex:i];
        
//        
//        BOOL inDiskValue;
//        NSString *fullPath;
//        NSString *url;
//        CGFloat heightValue;
//        CGFloat widthValue;
//        NSString *title;
//        
//        TopNews *topnews1 = [[TopNews alloc] initWithTid:@""
//                                                    category:@""
//                                                        type:@""
//                                                    category:@""
//                                                       order:@""
//                                                       ptime:@""
//                                                       mtime:@""
//                                                         url:onePhoto.url
//                                                     comment:@""
//                                                       title:onePhoto.title
//                                                     content:@"sdf"
//                                                   hdcontent:@"sdfsfd"
//                                                       image:onePhoto.url] ;
//        
//        
//        [sourceImageArray addObject:topnews1];
//        [topnews1 release];

		
		CGFloat zoomRate = 1.0;
		
		CGRect tempFrame = CGRectMake(0, 0, 0, 0);
		CGFloat newWidth = 280;//onePhoto.widthValue;
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
//        tempFrame.origin.x = orignX+35;
//		tempFrame.size.width = newWidth;
//		tempFrame.size.height = newHeight;
//
        newWidth = 280;
        
		tempFrame.origin.x = orignX;
		tempFrame.size.width = newWidth;
		tempFrame.size.height = newHeight;
		CustomImageView *imageView = (CustomImageView *)[self CreatViewFromRecyleWithContentType:ImageContentType];
		if (!imageView)
		{
			imageView = [[CustomImageView alloc] init];
		}
		else {
            //			[[SDataCenter sharedCenter] removeCallBackDelegate:imageView];
			[imageView removeAllSubViews];
		}
        imageView.delegate = self;
		
		imageView.isNeedBorder = NO;
		imageView.border = 0;
		imageView.frame = tempFrame;
        
        
        if (onePhoto.widthValue>onePhoto.heightValue) {
            imageView.contentMode = UIViewContentModeScaleAspectFill;
        }else{
            imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        
		if (onePhoto.inDiskValue)
		{
            NSURL* url = [NSURL URLWithString:onePhoto.fullPath];
			[imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:placeholder_photo]];
            imageView.imageURL = onePhoto.fullPath;
		}
        else
        {
            NSURL* url = [NSURL URLWithString:onePhoto.url];
			[imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:placeholder_photo]];
            imageView.imageURL = onePhoto.url;
        }
		
		[scrollView addSubview:imageView];
		[imageView release];
		[ImageWidthArray addObject:[NSNumber numberWithFloat:newWidth]];
		orignX += newWidth;		
	}
	if (orignX < scrollFrame.size.width)
	{
		CGFloat gap = 0;//(scrollFrame.size.width - orignX) / 2;
		CGFloat firstWidth = [[ImageWidthArray objectAtIndex:0] floatValue];
		CGFloat lastWidth = [[ImageWidthArray lastObject] floatValue];
		[ImageWidthArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:(firstWidth + gap)]];
		[ImageWidthArray replaceObjectAtIndex:(ImageWidthArray.count -1) withObject:[NSNumber numberWithFloat:(lastWidth + gap)]];
		for (UIImageView *oneView in scrollView.subviews)
		{
			if ([oneView isKindOfClass:[UIImageView class]])
			{
				CGRect newFrame = oneView.frame;
//				newFrame.origin.x += gap;
				oneView.frame = newFrame;
			}
		}
	}
	else if ((orignX > scrollFrame.size.width + 100))
	{
		[customView addLabelView];
	}
    
  
    
	scrollView.contentSize = CGSizeMake(orignX, scrollFrame.size.height);
	[self addSubview:customView];
    
//    CGRect f= scrollFrame;
//    f.origin.y = scrollView.frame.origin.y;
//    
//    OPScrollView *s = [[OPScrollView alloc] initWithFrame:f andSource:sourceImageArray];
//    s.delegate = self;
    
//    	[self addSubview:s];
	NSDictionary *imagesDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",customView,@"control",nil];
	[visibleArray addObject:imagesDic];
	[customView release];
    
	
}

-(void)layoutExtraDataAtIndex:(NSInteger)index
{
    CGFloat viewWidth = self.bounds.size.width;
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
    CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
    CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
    UIView* contentView = [tempDic objectForKey:@"content"];
	
    
	CGRect tempFrame = CGRectMake((viewWidth-width)/2, originY, width, height);
	UIView *tempView = nil;
	for (int i = 0; i < recycleArray.count; i++)
	{
		UIView  *oneView = [recycleArray objectAtIndex:i];
		if ([oneView isKindOfClass:[contentView class]])
		{
			[oneView retain];
			tempView = oneView;
			[recycleArray removeObjectAtIndex:i];
			break;
		}
	}
    if (!tempView) {
        [contentView retain];
    }
	
	contentView.frame = tempFrame;
    BOOL needLoad = YES;
    if (bHtmlStyle&&!contentLoaded) {
        needLoad = NO;
    }
    if (needLoad) {
        [self addSubview:contentView];
    }
    
	NSDictionary *videoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",contentView,@"control",nil];
	[visibleArray addObject:videoDic];
	
	[contentView release];
}

-(void)layoutClickURLAtIndex:(NSInteger)index
{
    CGFloat viewWidth = self.bounds.size.width;
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
    CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
    CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
    NSString* content = [tempDic objectForKey:@"content"];
	
	CGRect tempFrame = CGRectMake(mySetting.contentSpaceBetweenEdge, originY, width, height);
	
	
	ClickURLBtn *clickURLBtn = (ClickURLBtn *)[self CreatViewFromRecyleWithContentType:ClickURLContentType];
	if (!clickURLBtn)
	{
		clickURLBtn = [[ClickURLBtn alloc] initWithFrame:tempFrame];
	}
	else {
		clickURLBtn.frame = tempFrame;
	}
    clickURLBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [clickURLBtn setTitle:content forState:UIControlStateNormal];
    [clickURLBtn setTitleColor:[UIColor colorWithRed:9/255.0 green:178/255.0 blue:249/255.0 alpha:1.0] forState:UIControlStateNormal];
    clickURLBtn.titleLabel.numberOfLines = 0;
    [clickURLBtn addTarget:self action:@selector(urlClicked:) forControlEvents:UIControlEventTouchUpInside];
    clickURLBtn.titleLabel.font = [UIFont fontWithName:mySetting.textFontName size:mySetting.textFontSize];
    clickURLBtn.data = content;
    
    BOOL needLoad = YES;
    if (bHtmlStyle&&!contentLoaded) {
        needLoad = NO;
    }
    if (needLoad) {
        [self addSubview:clickURLBtn];
    }
    
	[self addSubview:clickURLBtn];
	NSDictionary *videoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",clickURLBtn,@"control",nil];
	[visibleArray addObject:videoDic];
	
	[clickURLBtn release];
}

-(void)urlClicked:(ClickURLBtn*)sender
{
    NSString* content = sender.data;
    if ([imageDelegate respondsToSelector:@selector(view:urlClicked:)]) {
        [imageDelegate view:self urlClicked:content];
    }
}

-(void)layoutRelativeNewsContentAtIndex:(NSInteger)index
{
    CGFloat viewWidth = self.bounds.size.width;
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
    CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
    CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
    CGFloat margin = [[tempDic objectForKey:@"margin"] floatValue];
    NSArray* commentArray = [tempDic objectForKey:@"content"];
	
	CGRect tempFrame = CGRectMake(0, originY, width, height);
	
	
	RelativeNewsTableView *cTableView = (RelativeNewsTableView *)[self CreatViewFromRecyleWithContentType:RelativeNewsType];
	if (!cTableView)
	{
		cTableView = [[RelativeNewsTableView alloc] initWithFrame:tempFrame];
	}
	else {
		cTableView.frame = tempFrame;
	}
    cTableView.delegate = self;
    
    cTableView.dataArray = commentArray;
    cTableView.leftrightMargin = margin;
    [cTableView reloadData];
    
    BOOL needLoad = YES;
    if (bHtmlStyle&&!contentLoaded) {
        needLoad = NO;
    }
    if (needLoad) {
        [self addSubview:cTableView];
    }
	
	NSDictionary *videoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",cTableView,@"control",nil];
	[visibleArray addObject:videoDic];
	
	[cTableView release];
}

-(void)RelativeNewsTableView:(RelativeNewsTableView*)view relativeURLClicked:(NSString*)url
{
    if ([imageDelegate respondsToSelector:@selector(view:relativeURLClicked:)]) {
        [imageDelegate view:self relativeURLClicked:url];
    }
}

-(void)layoutCommentContentAtIndex:(NSInteger)index
{
    CGFloat viewWidth = self.bounds.size.width;
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
    CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
    CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
    CGFloat margin = [[tempDic objectForKey:@"margin"] floatValue];
    NSArray* commentArray = [tempDic objectForKey:@"content"];
	
	CGRect tempFrame = CGRectMake(0, originY, width, height);
	
	
	CommentTableView *cTableView = (CommentTableView *)[self CreatViewFromRecyleWithContentType:CommentContentType];
	if (!cTableView)
	{
		cTableView = [[CommentTableView alloc] initWithFrame:tempFrame];
	}
	else {
		cTableView.frame = tempFrame;
	}
    cTableView.delegate = self;

    cTableView.dataArray = commentArray;
    cTableView.leftrightMargin = margin;
    [cTableView reloadData];
    
    BOOL needLoad = YES;
    if (bHtmlStyle&&!contentLoaded) {
        needLoad = NO;
    }
    if (needLoad) {
        [self addSubview:cTableView];
    }

	NSDictionary *videoDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",cTableView,@"control",nil];
	[visibleArray addObject:videoDic];
	
	[cTableView release];
}

-(void)commentTableView:(CommentTableView*)view allContentClicked:(UIButton*)sender
{
    if ([imageDelegate respondsToSelector:@selector(view:allCommentClicked:)]) {
        [imageDelegate view:self allCommentClicked:sender];
    }
}

- (void)layoutCopyrightAtIndex:(NSInteger)index
{
	CGFloat viewWidth = self.bounds.size.width;
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	
	if (originY < (self.bounds.size.height - CONTENTCOPYRIGHTHEIGHT))
	{
		originY = self.bounds.size.height - CONTENTCOPYRIGHTHEIGHT;
	}
	
	CGRect tempFrame = CGRectMake(0, originY, viewWidth, CONTENTCOPYRIGHTHEIGHT);
	
	
	copyrightView = [[UIView alloc] initWithFrame:tempFrame];
    BOOL needLoad = YES;
    if (bHtmlStyle&&!contentLoaded) {
        needLoad = NO;
    }
    if (needLoad) {
        [self addSubview:copyrightView];
    }
    
	
	UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tempFrame.size.width, tempFrame.size.height)];
	bgImageView.image = [UIImage imageNamed:@"contentBottomButtonBG.png"];
	[copyrightView addSubview:bgImageView];
	[bgImageView release];
	
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	backButton.frame = CGRectMake(525, 13, 108, 32);	
	[backButton setBackgroundImage:[UIImage imageNamed:@"ArticleViewEndback.png"] forState:UIControlStateNormal];
	backButton.showsTouchWhenHighlighted = YES;
    //	[backButton setBackgroundImage:[UIImage imageNamed:@"ArticleViewEndback_on.png"] forState:UIControlStateHighlighted];
	[copyrightView addSubview:backButton];
	
	UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
	menuButton.frame = CGRectMake(639, 13, 108, 32);
	menuButton.showsTouchWhenHighlighted = YES;
	
	[menuButton setBackgroundImage:[UIImage imageNamed:@"ArticleViewEndhome.png"] forState:UIControlStateNormal];
    //	[menuButton setBackgroundImage:[UIImage imageNamed:@"ArticleViewEndhome_on.png"] forState:UIControlStateHighlighted];
	[copyrightView addSubview:menuButton];
    //	copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,48, viewWidth, 22)];
    //	
    //	copyrightLabel.textAlignment = UITextAlignmentCenter;
    //	copyrightLabel.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0];
    //	copyrightLabel.font = [UIFont fontWithName:CurrentAirticleFontName size:12];
    //	copyrightLabel.textColor = [UIColor colorWithRed:0.686 green:0.686 blue:0.686 alpha:1];
    //	copyrightLabel.text = @"Copyright © 1996-2011 SINA Corporation, All Rights Reserved";
    //	[copyrightView addSubview:copyrightLabel];
	
	NSDictionary *LalbelDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",copyrightView,@"control",nil];
	[visibleArray addObject:LalbelDic];
	[copyrightView release];
	
}

- (void)layoutSourceAtIndex:(NSInteger)index
{
	CGFloat viewWidth = self.bounds.size.width;
	//title
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
	CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
	NSString *tempString = [tempDic objectForKey:@"content"];
	
	CGRect tempFrame = CGRectMake((viewWidth-width)/2, originY, width, height);
	
	
	UILabel *sourceLabel = (UILabel *)[self CreatViewFromRecyleWithContentType:SourceContentType];
	if (!sourceLabel) 
	{
		sourceLabel = [[UILabel alloc] initWithFrame:tempFrame];
	}
	else
	{
		sourceLabel.frame = tempFrame;
	}
	
	sourceLabel.textAlignment = UITextAlignmentCenter;
	sourceLabel.lineBreakMode = UILineBreakModeWordWrap;
	sourceLabel.numberOfLines = 50;
	[sourceLabel setText:tempString];
	[sourceLabel setFont:[UIFont fontWithName:CurrentAirticleFontName size:sourceFontSize]];
	sourceLabel.textColor = [mySetting sourceFontColor];
	[sourceLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:sourceLabel];
	
	NSDictionary *LalbelDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",sourceLabel,@"control",nil];
	[visibleArray addObject:LalbelDic];
	[sourceLabel release];
	//YPos += sizeOfSource.height + 10;
}

- (void)layoutPageNumAtIndex:(NSInteger)index
{
	CGFloat viewWidth = self.bounds.size.width;
    
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	int currentNum = [[tempDic objectForKey:@"currentPage"] intValue];
	int totalNum = [[tempDic objectForKey:@"totalPage"] intValue];
	
	CGRect tempFrame = CGRectMake(12, originY, viewWidth - 2 * 12, CONTENTPAGENUMHEIGHT);
	
	UIView *tempView = [[UIView alloc] initWithFrame:tempFrame];
	tempView.backgroundColor = [UIColor clearColor];
    BOOL needLoad = YES;
    if (bHtmlStyle&&!contentLoaded) {
        needLoad = NO;
    }
    if (needLoad) {
        [self addSubview:tempView];
    }
	
	
	UILabel *pageNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tempFrame.size.width, 14)];
	
	pageNumLabel.textAlignment = UITextAlignmentCenter;
	pageNumLabel.backgroundColor = [UIColor clearColor];
	pageNumLabel.font = [UIFont fontWithName:CurrentAirticleFontName size:12];
	pageNumLabel.textColor = [UIColor colorWithRed:0.2588 green:0.2588 blue:0.2588 alpha:1];
	pageNumLabel.text = [NSString stringWithFormat:@"%i / %i",currentNum,totalNum];
	[tempView addSubview:pageNumLabel];
	[pageNumLabel release];
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"contentBrokenLine.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]];
	imageView.frame = CGRectMake(0, 20, tempFrame.size.width, 1);
	[tempView addSubview:imageView];
	[imageView release];
	
	NSDictionary *pageDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",tempView,@"control",nil];
	[visibleArray addObject:pageDic];
	[tempView release];
	
}

- (void)layoutSeprateLineAtIndex:(NSInteger)index
{
	CGFloat viewWidth = self.bounds.size.width;
	
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
	
	CGRect tempFrame = CGRectMake((viewWidth-width)/2, originY, width, 1);
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"contentHorizontalSeparateLine.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]];
	imageView.frame = tempFrame;
	[self addSubview:imageView];
	
	NSDictionary *pageDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",imageView,@"control",nil];
	[visibleArray addObject:pageDic];
	[imageView release];
}

- (void) loadNextPage:(id)sender
{
	UIButton *clickToNextButton = (UIButton *)sender;
	clickToNextButton.enabled = NO;
	NSInteger index = currentPage;
	NSString *url = nil;
	if (currentPage >= totalPages) return;
	
	NSSet *pages = myModel.posPage.pages.singlePageSet;
	for (SSinglePageModel *onePage in pages)
	{
		if (onePage.indexValue == index + 1)
		{
			url = onePage.news.url;
			break;
		}
	}
	
	CGRect centerFrame = clickToNextButton.frame;
	centerFrame.origin.x = 20;
	centerFrame.origin.y = 6;
	centerFrame.size.width = ACTIVEINDICATORWIDTH;
	centerFrame.size.height = centerFrame.size.height - 12;
    activeIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activeIndicator.frame = centerFrame;
	[activeIndicator startAnimating];
	[clickToNextButton addSubview:activeIndicator];
	[activeIndicator release];
	
}


- (void)layoutClickToNexePageButtonAtIndex:(NSInteger)index
{
	//CGFloat mainWidth = self.bounds.size.width;
	NSDictionary *tempDic = [allContentArray objectAtIndex:index];
	CGFloat originY = [[tempDic objectForKey:@"originY"] floatValue];
	
	UIButton *clickToNextButton = (UIButton *)[self CreatViewFromRecyleWithContentType:ButtonContentType];
	
	if(!clickToNextButton)
	{
		clickToNextButton = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width - 289) / 2, originY, 289, 50)];
		[clickToNextButton setBackgroundImage:[UIImage imageNamed:@"contentClickToNextNormal.png"] forState:UIControlStateNormal];
		[clickToNextButton setBackgroundImage:[UIImage imageNamed:@"contentClickToNextHighlighted.png"] forState:UIControlStateHighlighted];
	}
	
	clickToNextButton.enabled = YES;
	clickToNextButton.frame = CGRectMake((self.bounds.size.width - 289) / 2, originY, 289, 50);
	clickToNextButton.titleLabel.textColor = [UIColor grayColor];
	clickToNextButton.titleLabel.font = [UIFont systemFontOfSize:20];
	//	clickToNextButton.titleLabel.text = @"点击显示下一页";
	
	[clickToNextButton addTarget:self action:@selector(loadNextPage:) forControlEvents:UIControlEventTouchUpInside];
    BOOL needLoad = YES;
    if (bHtmlStyle&&!contentLoaded) {
        needLoad = NO;
    }
    if (needLoad) {
        [self addSubview:clickToNextButton];
    }
	
	[clickToNextButton release];
	
	NSDictionary *buttonDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",clickToNextButton,@"control",nil];
	[visibleArray addObject:buttonDic];
	
	//YPos += CLICKBUTTONHEIGHT + 10;
}

- (void)layoutTableAtIndex:(NSInteger)index
{
    CGFloat boundsWidth = self.bounds.size.width;
    NSDictionary *tempDic = [allContentArray objectAtIndex:index];
    CGFloat origiY = [[tempDic objectForKey:@"originY"] floatValue];
    CGFloat width = [[tempDic objectForKey:@"width"] floatValue];
    CGFloat height = [[tempDic objectForKey:@"height"] floatValue];
    UIImage *tableImg = [tempDic objectForKey:@"content"];
    
    CGRect tempRect = CGRectMake(boundsWidth/2 - width/2, origiY, width, height);
    CustomImageView *imageView = (CustomImageView *)[self CreatViewFromRecyleWithContentType:ImageContentType];
	if (!imageView)
	{
		imageView = [[CustomImageView alloc] init];
	}
    
    imageView.delegate = self;
    [imageView setContentImageWithFrame:tempRect image:tableImg];
    
    [self addSubview:imageView];
    
    NSDictionary *imageDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"index",imageView,@"control",nil];
	[visibleArray addObject:imageDic];
    [imageView release];
}

- (CGFloat)getTitleTextHeightWithText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)size
{
	CGFloat viewWidth = self.bounds.size.width;
	CGSize sizeOfString = [myModel.title sizeWithFont:[UIFont fontWithName:mySetting.titleFontName size:titleFontSize] 
                                    constrainedToSize:CGSizeMake (viewWidth - mySetting.titleSpaceBetweenEdge*2, 500)
                                        lineBreakMode:UILineBreakModeWordWrap];
    CGFloat maxWidth = viewWidth - mySetting.titleSpaceBetweenEdge*2;
    if (sizeOfString.height>=titleFontSize*2) {
        int stirngLen = [myModel.title length];
        NSString* tempString = [myModel.title substringWithRange:NSMakeRange(0, stirngLen/2)];
        CGSize tempSize = [tempString sizeWithFont:[UIFont fontWithName:mySetting.titleFontName size:titleFontSize]];
        if (tempSize.width>maxWidth) {
            tempSize.width = maxWidth-20;
        }
        sizeOfString = [myModel.title sizeWithFont:[UIFont fontWithName:mySetting.titleFontName size:titleFontSize] 
                                 constrainedToSize:CGSizeMake (tempSize.width+20, 500)
                                     lineBreakMode:UILineBreakModeWordWrap];
    }
	
	return sizeOfString.height;
}

- (CGFloat)getTextHeightWithText:(NSString *)text fontName:(NSString *)fontName fontSize:(CGFloat)size
{
    CGFloat viewWidth = self.bounds.size.width;
	CGSize sizeOfSource = [text sizeWithFont:[UIFont fontWithName:fontName size:size] 
                           constrainedToSize:CGSizeMake (viewWidth - mySetting.contentSpaceBetweenEdge*2, 900000)
                               lineBreakMode:UILineBreakModeWordWrap];
	
	return sizeOfSource.height;
}

- (void)updateVisibleArray
{
	for (int i = 0; i < visibleArray.count; i++)
	{
		NSDictionary *tempDic = [visibleArray objectAtIndex:i];
		int index = [[tempDic objectForKey:@"index"] intValue];
		NSDictionary *contentDic = [allContentArray objectAtIndex:index];
		ContentType type = [[contentDic objectForKey:@"type"] intValue];
		CGFloat orignY = [[contentDic objectForKey:@"originY"] floatValue];
        CGFloat orignX = [[contentDic objectForKey:@"originX"] floatValue];
		switch (type) {
            case TitleSymbolType:
			{
				UIView *symbolView = (UILabel *)[tempDic objectForKey:@"control"];
				CGFloat height = [[contentDic objectForKey:@"height"] floatValue];
                CGFloat width = [[contentDic objectForKey:@"width"] floatValue];
				CGRect tempFrame = symbolView.frame;
				tempFrame.origin.y = orignY;
				tempFrame.size.height = height;
                tempFrame.size.width = width;
                tempFrame.origin.x = orignX;
				symbolView.frame = tempFrame;
                [self addSubview:symbolView];
				break;
			}
			case TitleContentType:
			{
				ArticleTitleLabel *label = (ArticleTitleLabel *)[tempDic objectForKey:@"control"];
				CGFloat height = [[contentDic objectForKey:@"height"] floatValue];
                CGFloat width = [[contentDic objectForKey:@"width"] floatValue];
                NSString* firstline = [contentDic objectForKey:@"firstline"];
                CGFloat viewWidth = self.bounds.size.width;
				CGRect tempFrame = label.frame;
#if DEBUG
				NSLog(@"update title");
				NSLog(@"text = %@,beforeY = %f, beforeH = %f, currentY = %f, currentH = %f",label.text,tempFrame.origin.y,tempFrame.size.height,orignY,height);
#endif
				tempFrame.origin.y = orignY;
				tempFrame.size.height = height;
                tempFrame.size.width = width;
                tempFrame.origin.x = (viewWidth - width)/2;
				label.frame = tempFrame;
                label.firstLine = firstline;
				UIFont *font = [UIFont fontWithName:mySetting.titleFontName size:titleFontSize];
				[label setFont:font];
                [self addSubview:label];
				break;
			}
            case BottomDeclareType:
            case DeclareContentType:
			{
				DeclareView *label = (DeclareView *)[tempDic objectForKey:@"control"];	
				CGFloat height = [[contentDic objectForKey:@"height"] floatValue];
                CGFloat width = [[contentDic objectForKey:@"width"] floatValue];
                CGFloat margin = [[contentDic objectForKey:@"margin"] floatValue];
                BOOL center = [[contentDic objectForKey:@"center"] boolValue];
                NSString *tempString = [contentDic objectForKey:@"content"];
                CGFloat viewWidth = self.bounds.size.width;

                CGRect tempFrame = CGRectMake(0, orignY-4, viewWidth, height+8);
				label.frame = tempFrame;
				CGRect stringRect = CGRectMake((viewWidth-width)/2, 4, width, height);
                UIFont *font = [UIFont fontWithName:mySetting.sourceFontName size:sourceFontSize];
                UITextAlignment align = UITextAlignmentCenter;
                if (!center) {
                    align = UITextAlignmentLeft;
                }
                [label setString:tempString stringRect:stringRect margin:margin-10 font:font fontColor:[mySetting sourceFontColor] textAlignment:align];
                [self addSubview:label];
				break;
			}
                
                //			case AuthorContentType:
			case TextContentType:
			{
				UILabel *label = (UILabel *)[tempDic objectForKey:@"control"];
				
				CGFloat height = [[contentDic objectForKey:@"height"] floatValue];
				CGRect tempFrame = label.frame;
#if DEBUG
				NSLog(@"update content text");
				NSLog(@"text = %@,beforeY = %f, beforeH = %f, currentY = %f, currentH = %f",label.text, tempFrame.origin.y,tempFrame.size.height,orignY,height);
#endif
				tempFrame.origin.y = orignY;
				tempFrame.size.height = height;
				[label setFont:[UIFont fontWithName:mySetting.textFontName size:textFontSize]];
				label.frame = tempFrame;
				[self addSubview:label];
				break;
			}				
			case PhotoTextContentType:
			case SourceContentType:
			{
				UILabel *label = (UILabel *)[tempDic objectForKey:@"control"];
				
				CGFloat height = [[contentDic objectForKey:@"height"] floatValue];
				CGRect tempFrame = label.frame;
#if DEBUG
				NSLog(@"update content text");
				NSLog(@"text = %@,beforeY = %f, beforeH = %f, currentY = %f, currentH = %f",label.text, tempFrame.origin.y,tempFrame.size.height,orignY,height);
#endif
				tempFrame.origin.y = orignY;
				tempFrame.size.height = height;
				label.frame = tempFrame;
				[label setFont:[UIFont fontWithName:mySetting.sourceFontName size:sourceFontSize]];
                [self addSubview:label];
				break;
			}
			case ImageContentType:
			{
				CustomImageView * imageView = (CustomImageView *)[tempDic objectForKey:@"control"];
                CGFloat height = [[contentDic objectForKey:@"height"] floatValue];
                CGFloat width = [[contentDic objectForKey:@"width"] floatValue];
                CGFloat originX = [[contentDic objectForKey:@"originX"] floatValue];
                
				CGRect tempFrame = imageView.frame;
				tempFrame.origin.y = orignY;
                tempFrame.size.height = height;
                tempFrame.size.width = width;
                tempFrame.origin.x = originX;
                [imageView setContentImageWithFrame:tempFrame];
				imageView.frame = tempFrame;
                [self addSubview:imageView];
				break;
			}
			case SeprateLineType:
			{
				UIImageView *imageView = (UIImageView *)[tempDic objectForKey:@"control"];
				CGRect tempFrame = imageView.frame;
				tempFrame.origin.y = orignY;
				imageView.frame = tempFrame;
                [self addSubview:imageView];
				break;				
			}
			case ImagesContentType:
			{
				CustomScrollViewForContent * imageView = (CustomScrollViewForContent *)[tempDic objectForKey:@"control"];
				CGRect tempFrame = imageView.frame;
				tempFrame.origin.y = orignY;
				imageView.frame = tempFrame;
                [self addSubview:imageView];
				break;
			}
			case VideoContentType:
			{
				VideoInContentView * videoView = (VideoInContentView *)[tempDic objectForKey:@"control"];
                CGFloat height = [[contentDic objectForKey:@"height"] floatValue];
                CGFloat width = [[contentDic objectForKey:@"width"] floatValue];
				CGRect tempFrame = videoView.frame;
				tempFrame.origin.y = orignY;
                tempFrame.size.height = height;
                tempFrame.size.width = width;
				videoView.frame = tempFrame;
                [self addSubview:videoView];
				break;
			}
                
			case ButtonContentType:
			{
				UIButton * imageView = (UIButton *)[tempDic objectForKey:@"control"];
				CGRect tempFrame = imageView.frame;
				tempFrame.origin.y = orignY;
				imageView.frame = tempFrame;
                [self addSubview:imageView];
				break;
			}
			case CopyrightContentType:
			{
				UIImageView * cpLabel = (UIImageView *)[tempDic objectForKey:@"control"];
				CGRect tempFrame = cpLabel.frame;
				tempFrame.origin.y = orignY;
				cpLabel.frame = tempFrame;
                [self addSubview:cpLabel];
				break;
			}
            case ClickURLContentType:
			{
				UIButton * cpLabel = (UIButton *)[tempDic objectForKey:@"control"];
				CGRect tempFrame = cpLabel.frame;
				tempFrame.origin.y = orignY;
                CGFloat height = [[contentDic objectForKey:@"height"] floatValue];
				tempFrame.size.height = height;
				[cpLabel.titleLabel setFont:[UIFont fontWithName:mySetting.textFontName size:textFontSize]];
				cpLabel.frame = tempFrame;
                [self addSubview:cpLabel];
				break;
			}
            case ExtraDataContentType:
			{
				UIView * control = (UIButton *)[tempDic objectForKey:@"control"];
				CGRect tempFrame = control.frame;
				tempFrame.origin.y = orignY;
                CGFloat height = [[contentDic objectForKey:@"height"] floatValue];
				tempFrame.size.height = height;
				control.frame = tempFrame;
                [self addSubview:control];
				break;
			}
            case RelativeNewsType:
			{
				RelativeNewsTableView * cpLabel = (RelativeNewsTableView *)[tempDic objectForKey:@"control"];
				CGRect tempFrame = cpLabel.frame;
				tempFrame.origin.y = orignY;
                CGFloat height = [[contentDic objectForKey:@"height"] floatValue];
				tempFrame.size.height = height;
				cpLabel.frame = tempFrame;
                [self addSubview:cpLabel];
				break;
			}
            case CommentContentType:
			{
				CommentTableView * cpLabel = (CommentTableView *)[tempDic objectForKey:@"control"];
				CGRect tempFrame = cpLabel.frame;
				tempFrame.origin.y = orignY;
                CGFloat height = [[contentDic objectForKey:@"height"] floatValue];
				tempFrame.size.height = height;
				cpLabel.frame = tempFrame;
                [self addSubview:cpLabel];
				break;
			}
			case PageNumContentType:
			{
				UIView *tempView = (UIView *)[tempDic objectForKey:@"control"];
				CGRect tempFrame = tempView.frame;
				tempFrame.origin.y = orignY;
				tempView.frame = tempFrame;
                [self addSubview:tempView];
				break;
			}
            case TableContentType:
            {
                UIImageView *tempView = (UIImageView*)[tempDic objectForKey:@"control"];
                CGRect tempFrame = tempView.frame;
                tempFrame.origin.y = orignY;
                tempView.frame = tempFrame;
                [self addSubview:tempView];
                break;
            }
			default:
				break;
		}
		
	}	
}
//对应字体大小重新排版
- (void)setContentFont:(BOOL)isLargeFont
{
	
	if (isLargeFont)
	{
		if (textFontSize >= 20) return;
		textFontSize += FONTINCREMENT;
		titleFontSize += FONTINCREMENT;
		sourceFontSize += FONTINCREMENT;
		
	}
	else 
	{
		if (textFontSize <= 8) return;
		textFontSize -= FONTINCREMENT;
		titleFontSize -= FONTINCREMENT;
		sourceFontSize -= FONTINCREMENT;
	}
	[SingleContentViewSetting setTitleFontSize:titleFontSize textFontSize:textFontSize SourceFontSize:sourceFontSize];
    //	[[SShareSetting sharedSetting] getSingleContentSetting].textFontSize = textFontSize;
    //	[[SShareSetting sharedSetting] getSingleContentSetting].titleFontSize = titleFontSize;
    //	[[SShareSetting sharedSetting] getSingleContentSetting].sourceFontSize = sourceFontSize;
    contentLoaded = NO;
    webSize = CGSizeMake(0, 0);
    [self refreshContent];
}

-(void)refreshContent
{

    YPos = mySetting.titleSpaceBetweenTop;
	
    NSMutableDictionary* titleSymbolDict = nil;
	for (int i = 0; i < allContentArray.count; i++)
	{
		NSMutableDictionary *tempDic = [allContentArray objectAtIndex:i];
		ContentType type = [[tempDic objectForKey:@"type"] intValue];
		switch (type) {
            case TitleSymbolType:
			{
                titleSymbolDict = tempDic;
				break;
			}
			case TitleContentType:
			{
                CGFloat viewWidth = self.bounds.size.width;
                UIView* titleSymbol = nil;
                CGSize titleSymbbolSize = CGSizeZero;
                if ([imageDelegate respondsToSelector:@selector(view:titleSymbolWithData:margin:width:fontSize:)]) {
                    id titleData = self.myModel.titleSymbolData;
                    titleSymbol = [imageDelegate view:self titleSymbolWithData:titleData margin:mySetting.titleSpaceBetweenEdge width:viewWidth fontSize:titleFontSize];
                    if (titleSymbol) {
                        titleSymbbolSize = titleSymbol.bounds.size;
                    }
                }
                CGFloat margin = mySetting.titleSpaceBetweenEdge+titleSymbbolSize.width;
				NSString *text = [tempDic objectForKey:@"content"];
                CGSize sizeOfString = [myModel.title sizeWithFont:[UIFont fontWithName:mySetting.titleFontName size:titleFontSize] 
                                                constrainedToSize:CGSizeMake (viewWidth - margin*2, 500)
                                                    lineBreakMode:UILineBreakModeWordWrap];
                
                CGFloat maxWidth = viewWidth - margin*2;
                int extraLen = 0;
                NSString* firstline = @"";
                if (sizeOfString.height>=titleFontSize*2) {
                    while (extraLen==0||sizeOfString.height>=titleFontSize*3) {
                        CGSize oldSize = sizeOfString;
                        int stirngLen = [myModel.title length];
                        NSInteger subLen = stirngLen/2+extraLen;
                        if (subLen<=stirngLen)
                        {
                            NSString* tempString = [myModel.title substringWithRange:NSMakeRange(0, subLen)];
                            firstline = tempString;
                            CGSize tempSize = [tempString sizeWithFont:[UIFont fontWithName:mySetting.titleFontName size:titleFontSize]];
                            if (tempSize.width>maxWidth) {
                                tempSize.width = maxWidth;
                            }
                            sizeOfString = [myModel.title sizeWithFont:[UIFont fontWithName:mySetting.titleFontName size:titleFontSize]
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
                    [titleSymbolDict setObject:titleSymbol forKey:@"content"];
                    NSInteger symbolPos = YPos;
                    NSInteger symbolExtraPos = 0;
                    if (titleFontSize>titleSymbbolSize.height) {
                        symbolExtraPos = titleFontSize/2 - titleSymbbolSize.height/2;
                        symbolPos += symbolExtraPos;
                    }
                    [titleSymbolDict setObject:[NSNumber numberWithFloat:symbolPos] forKey:@"originY"];
                    float originX =  viewWidth/2 - sizeOfString.width/2 - titleSymbbolSize.width;
                    [titleSymbolDict setObject:[NSNumber numberWithFloat:originX] forKey:@"originX"];
                    [titleSymbolDict setObject:[NSNumber numberWithFloat:titleSymbbolSize.height] forKey:@"height"];
                    [titleSymbolDict setObject:[NSNumber numberWithFloat:titleSymbbolSize.width] forKey:@"width"];
                }
                
                [tempDic setObject:myModel.title forKey:@"content"];
                [tempDic setObject:firstline forKey:@"firstline"];
                [tempDic setObject:[NSNumber numberWithFloat:sizeOfString.height] forKey:@"height"];
                [tempDic setObject:[NSNumber numberWithFloat:sizeOfString.width] forKey:@"width"];
                NSInteger tempPos = YPos;
                NSInteger extraPos = 0;
                if (titleFontSize<titleSymbbolSize.height) {
                    extraPos = titleSymbbolSize.height/2 - titleFontSize/2;
                    tempPos += extraPos;
                }
                [tempDic setObject:[NSNumber numberWithFloat:tempPos] forKey:@"originY"];
                
                NSInteger newHeight = sizeOfString.height + extraPos;
                if (newHeight>titleSymbbolSize.height) {
                    YPos += newHeight;
                }
                else
                {
                    YPos += titleSymbbolSize.height;
                }
            
				break;
			}
            case DeclareContentType:
			{
                YPos += GAPBETWEENCONTENSEPRARATELINE;
                NSInteger margin = mySetting.titleSpaceBetweenEdge + 10;
				NSString *text = [tempDic objectForKey:@"content"];
                CGFloat viewWidth = self.bounds.size.width;
                CGSize sizeOfString = [text sizeWithFont:[UIFont fontWithName:mySetting.sourceFontName size:sourceFontSize] 
                                                constrainedToSize:CGSizeMake (viewWidth - margin*2, 500)
                                                    lineBreakMode:UILineBreakModeWordWrap];
                CGFloat maxWidth = viewWidth - margin*2;
                [tempDic setObject:[NSNumber numberWithFloat:sizeOfString.height] forKey:@"height"];
                [tempDic setObject:[NSNumber numberWithFloat:sizeOfString.width] forKey:@"width"];
                [tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
                
		        YPos += sizeOfString.height;
				break;
			}
            case BottomDeclareType:
			{
                YPos += GAPBETWEENCONTENSEPRARATELINE;
                NSInteger margin = mySetting.titleSpaceBetweenEdge + 10;
				NSString *text = [tempDic objectForKey:@"content"];
                CGFloat viewWidth = self.bounds.size.width;
                CGSize sizeOfString = [text sizeWithFont:[UIFont fontWithName:mySetting.sourceFontName size:sourceFontSize]
                                       constrainedToSize:CGSizeMake (viewWidth - margin*2, 500)
                                           lineBreakMode:UILineBreakModeWordWrap];
                [tempDic setObject:[NSNumber numberWithFloat:sizeOfString.height] forKey:@"height"];
                [tempDic setObject:[NSNumber numberWithFloat:sizeOfString.width] forKey:@"width"];
                [tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
                
		        YPos += sizeOfString.height +20;
				break;
			}
			case PhotoTextContentType:
			{
				YPos += GAPBETWEENCONTENTPHOTOTEXT;
				NSString *text = [tempDic objectForKey:@"content"];
				CGFloat height = [self getTextHeightWithText:text fontName:mySetting.sourceFontName fontSize:sourceFontSize];
				[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
				[tempDic setObject:[NSNumber numberWithFloat:height] forKey:@"height"];
				
		        YPos += height;
#if DEBUG
				NSLog(@"text = %@ ,index = %i, height = %f, ypos = %f",text,i,height,YPos);
#endif
				break;
			}
                //			case AuthorContentType:
			case TextContentType:
			{
				YPos += GAPBETWEENCONTENTITEM;
				NSString *text = [tempDic objectForKey:@"content"];
				CGFloat height = [self getTextHeightWithText:text fontName:mySetting.textFontName fontSize:textFontSize];
                if (bHtmlStyle&&webSize.height>0) {
                    height = webSize.height;
                }
				[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
				[tempDic setObject:[NSNumber numberWithFloat:height] forKey:@"height"];
                YPos += height;
                
#if DEBUG
				NSLog(@"text = %@ ,index = %i, height = %f, ypos = %f",text,i,height,YPos);
#endif
				break;
			}
			case SourceContentType:
			{
				YPos += GAPBETWEENCONTENSEPRARATELINE;
				NSString *text = [tempDic objectForKey:@"content"];
				CGFloat height = [self getTextHeightWithText:text fontName:mySetting.sourceFontName fontSize:sourceFontSize];
				[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
				[tempDic setObject:[NSNumber numberWithFloat:height] forKey:@"height"];
		        YPos += height;
#if DEBUG
				NSLog(@"text = %@ ,index = %i, height = %f, ypos = %f",text,i,height,YPos);
#endif
				break;
			}
		    case SeprateLineType:
			{
				YPos += GAPBETWEENCONTENSEPRARATELINE;
				[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
				YPos += 1;
				break;				
			}
                
			case ImageContentType:
			{
				YPos += GAPBETWEENCONTENTITEM;
				int imageindex = i;
				CGFloat height = 0;
				for (; imageindex < allContentArray.count; imageindex++)
				{
				    NSMutableDictionary *imageDic = [allContentArray objectAtIndex:imageindex];
					ContentType imageType = [[imageDic objectForKey:@"type"] intValue];
					if (imageType == ImageContentType)
					{
                        [imageDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
                        height = [[tempDic objectForKey:@"height"] floatValue];
					}
					else
					{
						break;
					}
                    
				}
				YPos += height;
				i = imageindex -1;
				break;
			}
		    case ImagesContentType:
			{
				YPos += GAPBETWEENCONTENTSCROLLVIEW;
				[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
                NSInteger scrollHeight = [MyTool isRetina]?SCROLLVIEWHEIGHT/2:SCROLLVIEWHEIGHT;
				YPos += scrollHeight;
				break;
			}
			case VideoContentType:
			{
				YPos += GAPBETWEENCONTENTVIDEO;
				[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
                NSInteger height = [[tempDic valueForKey:@"height"] floatValue];
				YPos += height;
				break;
			}
                
            case ClickURLContentType:
			{
				YPos += GAPBETWEENCLICKURL;
                NSString *text = [tempDic objectForKey:@"content"];
				CGFloat height = [self getTextHeightWithText:text fontName:mySetting.textFontName fontSize:textFontSize];
				[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
				YPos += height;
				break;
			}
            case ExtraDataContentType:
			{
				YPos += GAPBETWEENEXTRADATA;
				[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
                
                id extraData = myModel.extraData;
                CGFloat viewWidth = self.bounds.size.width;
                UIView* extraView = [imageDelegate view:self extraViewWithData:extraData margin:mySetting.contentSpaceBetweenEdge width:viewWidth fontSize:textFontSize];
                if (extraView) {
                    [tempDic setObject:extraView forKey:@"content"];
                    YPos += extraView.bounds.size.height;
                }
				break;
			}
            case RelativeNewsType:
			{
				YPos += GAPBETWEENCLICKURL;
                NSArray *commentSet = [tempDic objectForKey:@"content"];
                NSInteger margin = [[tempDic objectForKey:@"margin"] intValue];
				RelativeNewsTableView* ctableView = [[RelativeNewsTableView alloc] init];
                ctableView.dataArray = commentSet;
                ctableView.leftrightMargin = margin;
                NSInteger commentHeight = ctableView.fitHeight;
                [ctableView release];
				[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
				YPos += commentHeight;
				break;
			}
               
            case CommentContentType:
			{
				if (myModel.relativeNewsArray) {
                    YPos += GAPBETWEENRELATIVEANDCOMMENT;
                }
                else {
                    YPos += GAPBETWEENCLICKURL;
                }
                NSArray *commentSet = [tempDic objectForKey:@"content"];
                NSInteger margin = [[tempDic objectForKey:@"margin"] intValue];
				CommentTableView* ctableView = [[CommentTableView alloc] init];
                ctableView.dataArray = commentSet;
                ctableView.leftrightMargin = margin;
                NSInteger commentHeight = ctableView.fitHeight;
                [ctableView release];
				[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
				YPos += commentHeight;
				break;
			}
                
			case CopyrightContentType:
			{
				YPos += 50;
				if (YPos < (self.bounds.size.height - CONTENTCOPYRIGHTHEIGHT))
				{
					[tempDic setObject:[NSNumber numberWithFloat:(self.bounds.size.height - CONTENTCOPYRIGHTHEIGHT)] forKey:@"originY"];
				}
				else {
					[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
				}
                
				YPos += CONTENTCOPYRIGHTHEIGHT;
				break;
			}
			case PageNumContentType:
			{
				[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
                YPos += CONTENTPAGENUMHEIGHT;
				break;
			}
			case ButtonContentType:
			{
				YPos += GAPBETWEENCONTENTBUTTON;
				[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
				YPos += CLICKBUTTONHEIGHT ;
				break;
			}
            case TableContentType:
            {
				[tempDic setObject:[NSNumber numberWithFloat:YPos] forKey:@"originY"];
                UIImage *tableImg = (UIImage*)[tempDic objectForKey:@"content"];
                YPos += tableImg.size.height;
                break;
            }
			default:
				break;
		}
	}
	CGFloat viewWidth = self.bounds.size.width;
	self.contentSize = CGSizeMake(viewWidth, YPos);
	[self updateVisibleArray];
	[self LoadControls];
}

- (void)LoadNextPageContent:(SSingleNewsModel *)newsModel
{
	for (int i = 0; i < visibleArray.count; i++)
	{
		NSDictionary *tempDic = [visibleArray objectAtIndex:i];
		UIView *oneView = [tempDic objectForKey:@"control"];
		if ([oneView isKindOfClass:[UIButton class]])
		{
			if (recycleArray.count == 5)
			{
				[recycleArray removeLastObject];
			}
			
			[recycleArray addObject:oneView];
			[visibleArray removeObjectAtIndex:i];
			[activeIndicator removeFromSuperview];
			activeIndicator = nil;
			[oneView removeFromSuperview];
		}
	}
	[allContentArray removeLastObject];
	YPos -= (CLICKBUTTONHEIGHT  + GAPBETWEENCONTENTBUTTON);
	endDisplayIndex--;
	currentPage ++;
	
	self.myModel = newsModel;
    [self getSortedImageArray:newsModel];
	[self analyseContent:newsModel.content];
	[self analyseWholeContent];
	[self analyseEndOfArticle];
    
	CGFloat viewWidth = self.frame.size.width;
    
	[self LoadControls];
	
	self.contentSize = CGSizeMake(viewWidth, YPos);
}

#pragma mark ----
#pragma mark UIScrollViewDelegate method

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (!decelerate)
	{
		[self LoadControls];
	}
    //	CGFloat scrollHeight = scrollView.bounds.size.height;
    //	if ((scrollView.contentOffset.y + scrollHeight > (scrollView.contentSize.height + 100)) && (currentPage < totalPages))
    //	{
    //		[self loadNextPage];
    //	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self LoadControls];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat offsetY = scrollView.contentOffset.y;
	CGFloat dValue = offsetY - lastOffset;
	
	if (dValue > 0)
	{
		if (offsetY + 1000 > backwardHeight - 200)
		{
			[self LoadControls];
		}
	}
	else {
        
		if ((offsetY - 200 < forwardHeight) && (forwardHeight != 0)) {
			[self LoadControls];
		}
	}
	lastOffset = offsetY;
    
    //   if ((scrollView.contentOffset.y + 1000 > backwardHeight - 200) || (scrollView.contentOffset.y - 200 < forwardHeight ))
    //	{
    //		[self LoadControls];
    //	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([imageDelegate respondsToSelector:@selector(view:clickedMode:)]) {
        [imageDelegate view:self clickedMode:1];
    }
}

@end
