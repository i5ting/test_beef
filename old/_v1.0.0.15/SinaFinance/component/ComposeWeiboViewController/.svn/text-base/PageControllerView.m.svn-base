//
//  PageControllerView.m
//  SinaNews
//
//  Created by shieh exbice on 12-1-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "JSONKit.h"
#import "PageControllerView.h"

@interface PageControllerView()

@property(nonatomic,retain)UIScrollView* scrollView;
@property(nonatomic,retain)UIPageControl* pageControl;
@property(nonatomic,retain)UIImageView* backImageView;

-(void)initUI;

@end

@implementation PageControllerView
@synthesize scrollView;
@synthesize pageControl;
@synthesize backImageView;
@synthesize emotionArray;
@synthesize delegate;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.backgroundColor = [UIColor blackColor];
    CGRect frame = CGRectZero;
    backImageView = [[UIImageView alloc] initWithFrame:frame];
    [self addSubview:backImageView];
    backImageView.backgroundColor = [UIColor colorWithRed:30/255.0 green:20/255.0 blue:10/255.0 alpha:1.0];
    CGRect scrollRect = frame;
    scrollRect.size.height = frame.size.height - 20;
    scrollRect.origin.x = scrollRect.origin.x + 5;
    scrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
    [self addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    CGRect pageRect = frame;
    pageRect.size.height = 20;
    pageRect.origin.x = frame.origin.x + frame.size.width/2 - pageRect.size.width/2;
    pageRect.origin.y = frame.origin.y + frame.size.height - 20;
    pageControl = [[UIPageControl alloc] initWithFrame:pageRect];
    [self addSubview:pageControl];
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    pageControl.currentPage = 0;
    
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    
    countEmotinPerPage = 0;
    countPage = 0;
    emotionSize = CGSizeMake(40, 40);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.001];
}

-(void)dealloc
{
    [scrollView release];
    [pageControl release];
    [backImageView release];
    [emotionArray release];
    
    [super dealloc];
}

-(void)reloadData
{
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    if (!emotionArray) {
        NSString* emotionFile = [bundlePath stringByAppendingPathComponent:@"emotions.json"];
        NSError* error;
        NSString* commentStr = [NSString stringWithContentsOfFile:emotionFile encoding:NSUTF8StringEncoding error:&error];
        if (!commentStr) {
            commentStr = [NSString stringWithContentsOfFile:emotionFile encoding:NSUnicodeStringEncoding error:&error];
        }
        self.emotionArray = [commentStr objectFromJSONString];
    }
    int emotionCount = [self.emotionArray count];
    if (countEmotinPerPage>0&&emotionCount>0) {
        countPage = emotionCount/countEmotinPerPage + (emotionCount%countEmotinPerPage>0?1:0);
        pageControl.numberOfPages = countPage;
        pageControl.currentPage = 0;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*countPage, scrollView.frame.size.height);
        
        int marginX = scrollView.frame.size.width/2 -  sizePerPage.width*emotionSize.width/2;
        int marginY = scrollView.frame.size.height/2 -  sizePerPage.height*emotionSize.height/2;
        
        for (int i=0; i<emotionCount; i++) {
            NSDictionary* emotionDict = [self.emotionArray objectAtIndex:i];
            NSString* localString = [emotionDict objectForKey:@"local"];
            NSString* localFile = [bundlePath stringByAppendingPathComponent:localString];
            UIImage* emotionImage = [[UIImage alloc] initWithContentsOfFile:localFile];
            CGRect emotionRect = CGRectMake(0, 0, 24,24);
            UIButton* emotionBtn = [[UIButton alloc] initWithFrame:emotionRect];
            emotionBtn.tag = i;
            [emotionBtn setImage:emotionImage forState:UIControlStateNormal];
            [emotionBtn addTarget:self action:@selector(emotionClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            int curPage = i/countEmotinPerPage;
            int curPageEmotionIndex = i%countEmotinPerPage;
            int curRow = curPageEmotionIndex/(int)sizePerPage.width;
            int curColumn = curPageEmotionIndex%(int)sizePerPage.width;
            
            CGRect curBackRect = CGRectZero;
            curBackRect.origin.x = curPage*scrollView.frame.size.width + curColumn*emotionSize.width + marginX;
            curBackRect.origin.y = curRow*emotionSize.height + marginY;
            curBackRect.size = emotionSize;
            
            emotionRect.origin.x = curBackRect.origin.x + curBackRect.size.width/2 - emotionRect.size.width/2;
            emotionRect.origin.y = curBackRect.origin.y + curBackRect.size.height/2 - emotionRect.size.height/2;
            emotionBtn.frame = emotionRect;
            [scrollView addSubview:emotionBtn];
            [emotionBtn release];
            [emotionImage release];
        }
    }
}

-(void)setFrame:(CGRect)frame
{
    CGRect sourceRect = self.frame;
    [super setFrame:frame];
    
    if (!CGSizeEqualToSize(emotionSize, CGSizeZero)) {
        if (!CGRectEqualToRect(frame, CGRectZero)&&!CGRectEqualToRect(frame, sourceRect)) {
            CGRect scrollRect = self.bounds;
            scrollRect.origin.x = scrollRect.origin.x + 5;
            scrollRect.size.height = scrollRect.size.height - 20;
            scrollView.frame = scrollRect;
            backImageView.frame = self.bounds;
            CGRect pageRect = self.bounds;
            pageRect.size.height = 20;
            pageRect.origin.x = self.bounds.origin.x + self.bounds.size.width/2 - pageRect.size.width/2;
            pageRect.origin.y = self.bounds.origin.y + self.bounds.size.height - 20;
            pageControl.frame = pageRect;
            
            int widthCount = scrollRect.size.width/emotionSize.width;
            int heightCount = scrollRect.size.height/emotionSize.height;
            countEmotinPerPage = widthCount*heightCount;
            sizePerPage = CGSizeMake(widthCount, heightCount);
            
//            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
//            [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.001];
        }
    }
}

-(void)emotionClicked:(UIButton*)sender
{
    int index = sender.tag;
    NSDictionary* emotionDict = [self.emotionArray objectAtIndex:index];
    NSString* emotion = [emotionDict valueForKey:@"value"];
    if ([delegate respondsToSelector:@selector(view:emotionString:)]) {
        [delegate view:self emotionString:emotion];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;

}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
