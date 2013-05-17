//
//  PicNewsContentView.m
//  SinaNews
//
//  Created by shieh exbice on 11-11-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PicNewsContentView.h"
#import "MyScrollView.h"
#import "UIImageView+WebCache.h"
#import "NewsObject.h"

@interface PicNewsContentView ()

@property(nonatomic,retain)NSMutableArray* picScrollArray;

-(void)mylayout;
-(void)loadImageWithIndex:(NSInteger)index;

@end

@implementation PicNewsContentView

@synthesize scrView,picURLArray,picScrollArray,delegate,lastPage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        scrView = [[UIScrollView alloc] initWithFrame:frame];
        scrView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        scrView.showsHorizontalScrollIndicator = NO;
        scrView.delegate = self;
        scrView.pagingEnabled = YES;
        [self addSubview:scrView];
        lastPage = 0;
    }

    return self;
}

-(void)dealloc
{
    [scrView release];
    [picURLArray release];
    [picScrollArray release];
    [super dealloc];
}


-(void)setPicURLArray:(NSArray *)aPicURLArray
{
    if (picURLArray!=aPicURLArray) {
        [picURLArray release];
        picURLArray = aPicURLArray;
        [picURLArray retain];
    }
    
    if (picScrollArray==nil) {
        picScrollArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else
    {
        for (UIView* oneView in picScrollArray) {
            [oneView removeFromSuperview];
        }
    }
    [picScrollArray removeAllObjects];
    for (int i=0; i<[picURLArray count]; i++)
	{
		MyScrollView *ascrView = [[MyScrollView alloc] init];
        ascrView.customDelegate = self;
        
		ascrView.tag = 100+i;
		[scrView addSubview:ascrView];
        [picScrollArray addObject:ascrView];
		[ascrView release];
	}
    lastPage = 0;
    if ([picScrollArray count]>0) {
        [self loadImageWithIndex:lastPage];
    }
    [self mylayout];
}

-(void)mylayout
{
    CGRect mainRect = self.bounds;
    int totalWidth = 0;
    for (int i=0; i<[picScrollArray count]; i++)
	{
		MyScrollView *ascrView = [picScrollArray objectAtIndex:i];
        ascrView.frame = CGRectMake((mainRect.size.width)*i, 0, mainRect.size.width, mainRect.size.height);

        if (i==0) {
            totalWidth += mainRect.size.width;
        }
		else
        {
            totalWidth += mainRect.size.width;
        }
	}
    CGSize oldSize = scrView.contentSize;
    CGPoint oldPoint = scrView.contentOffset;
    CGSize newSize = CGSizeMake(totalWidth+1, mainRect.size.height);
    CGPoint newPoint = CGPointZero;
    if (oldPoint.x!=0.0) {
        newPoint.x = oldPoint.x*newSize.width*1.0/oldSize.width;
    }
    if (oldPoint.y!=0.0) {
        newPoint.y = oldPoint.y*newSize.height*1.0/oldSize.height;
    }
	[scrView setContentSize:newSize];
    scrView.contentOffset = newPoint;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self mylayout];
}

-(void)setPage:(NSInteger)index animate:(BOOL)bAnimate
{
    CGFloat pageWidth = scrView.frame.size.width;
    float offsetX = floor((index)*pageWidth);
    if (offsetX>scrView.contentSize.width-pageWidth) {
        offsetX = scrView.contentSize.width-pageWidth;
    }
    CGPoint offset = CGPointMake(offsetX, scrView.contentOffset.y);
    [scrView setContentOffset:offset animated:bAnimate];
    
}

-(void)setNextPageWithAnimate:(BOOL)bAnimate
{
    [self setPage:lastPage+1 animate:bAnimate];
}

#pragma mark -
#pragma mark === UIScrollView Delegate ===
#pragma mark -
//ScrollView 划动的动画结束后调用.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGFloat pageWidth = scrollView.frame.size.width;
	NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
	if (lastPage != page) 
	{
		MyScrollView *aView = (MyScrollView *)[scrView viewWithTag:100+lastPage];
		aView.zoomScale = 1.0;
		
		lastPage = page;
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
	NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
	if (lastPage != page) 
	{
		MyScrollView *aView = (MyScrollView *)[scrView viewWithTag:100+lastPage];
		aView.zoomScale = 1.0;
		
		lastPage = page;
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
	NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (lastPage != page)
    {
       [self loadImageWithIndex:page]; 
    }
}

-(void)viewClicked:(MyScrollView*)view
{
    NSInteger index = [picScrollArray indexOfObject:view];
    if ([delegate respondsToSelector:@selector(view:clickedWithIndex:)]) {
        [delegate view:self clickedWithIndex:index];
    }
}

-(void)loadImageWithIndex:(NSInteger)index
{
    if (index<[picScrollArray count]) {
        MyScrollView* scroll = [picScrollArray objectAtIndex:index];
        if (scroll.imageView.image==nil) {
            NSString* imageUrl = [picURLArray objectAtIndex:index];
            UIImage* placeImage = [UIImage imageNamed:@"loading_big.png"];
            NSURL* url = [NSURL URLWithString:imageUrl];
            //ascrView.image = placeImage;
            if (url&&![imageUrl hasPrefix:@"/var/"]) {
                [scroll.imageView setImageWithURL:url placeholderImage:placeImage];
            }
            else
            {
                UIImage* oneImage = [[UIImage alloc] initWithContentsOfFile:imageUrl];
                scroll.imageView.image = oneImage;
                [oneImage release];
            }
            
        }
        if ([delegate respondsToSelector:@selector(view:changedIndex:)]) {
            [delegate view:self changedIndex:index];
        }
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

@end
