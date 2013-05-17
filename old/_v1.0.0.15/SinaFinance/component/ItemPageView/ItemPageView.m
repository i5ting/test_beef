//
//  ItemPageViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ItemPageView.h"

@implementation PageItemCell

@synthesize curIndex;
@synthesize title;

-(void)dealloc
{
    [title release];
    [super dealloc];
}

@end

@interface ItemPageView ()
@property(nonatomic,retain)UIScrollView* scrollView;
@property(nonatomic,retain)UIPageControl* pageControl;
@property(nonatomic,retain)UIView* preView;
@property(nonatomic,retain)UIView* curView;
@property(nonatomic,retain)UIView* nextView;
@property(nonatomic,retain)NSValue* sourceRectValue;
@property(nonatomic,retain)NSValue* destRectValue;

-(void)initUI:(CGRect)bounds;
-(void)calculateArgumentFactors;
-(CGSize)adjustPaddingSize;
-(void)realPageChanged:(NSInteger)oldPage withNewPage:(NSInteger)newPage;
-(void)reusePage:(NSInteger)oldPage withNewPage:(NSInteger)newPage;
-(void)newCreatePage:(NSInteger)newPage;
@end

@implementation ItemPageView
{
    CGFloat spacerWidth;
    CGFloat spacerHeight;
    CGFloat extraWidthSpacer;
    CGFloat extraHeightSpacer;
    CGFloat prefixWidth;
    CGFloat prefixHeight;
    NSInteger countPage;
    NSInteger itemCount;
    NSInteger realCountPerPage;
    CGSize realFitSize;
    UIScrollView* scrollView;
    UIPageControl* pageControl;
    BOOL pageControlUsed;
    UIView* preView;
    UIView* curView;
    UIView* nextView;
    NSValue* sourceRectValue;
    NSValue* destRectValue;
}
@synthesize countPerPage,sizePerItem,paddingSize;
@synthesize scrollView;
@synthesize curPage;
@synthesize hasPageControll;
@synthesize pageControl;
@synthesize preView,curView,nextView;
@synthesize backImageView;
@synthesize delegate;
@synthesize sameSapcer;
@synthesize sourceRectValue,destRectValue;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initUI:CGRectZero];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self initUI:bounds];
    }
    return self;
}

-(void)dealloc
{
    [scrollView release];
    [pageControl release];
    [preView release];
    [curView release];
    [nextView release];
    [backImageView release];
    [sourceRectValue release];
    [destRectValue release];
    
    [super dealloc];
}

-(void)initUI:(CGRect)bounds
{
    countPerPage = 9;
    sizePerItem = CGSizeZero;
    paddingSize = CGSizeMake(20.0, 20.0);
    curPage = 0;
    hasPageControll = YES;
    sameSapcer = YES;
    
    self.backgroundColor = [UIColor clearColor];
    backImageView = [[UIImageView alloc] initWithFrame:bounds];
    [self addSubview:backImageView];
    backImageView.backgroundColor = [UIColor clearColor];
    CGRect scrollRect = bounds;
    scrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
    [self addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    CGRect pageRect = bounds;
    pageRect.size.height = 20;
    pageRect.origin.x = bounds.origin.x + bounds.size.width/2 - pageRect.size.width/2;
    pageRect.origin.y = bounds.origin.y + bounds.size.height - 20;
    pageControl = [[UIPageControl alloc] initWithFrame:pageRect];
    [self addSubview:pageControl];
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    pageControl.currentPage = curPage;
    
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
//    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.001];
}

-(void)setHasPageControll:(BOOL)bPageControll
{
    hasPageControll = bPageControll;
    self.pageControl.hidden = !bPageControll;
}

-(void)setCurPage:(NSInteger)acurPage
{
    if (acurPage>=countPage) {
        acurPage = countPage - 1;
    }
    NSInteger oldPage = curPage;
    curPage = acurPage;
    self.pageControl.currentPage = acurPage;
    [self realPageChanged:oldPage withNewPage:acurPage];
}

-(void)calculateArgumentFactors
{
    if (countPerPage>0&&itemCount>0) {
        CGRect bounds = self.scrollView.bounds;
        CGRect realBounds = CGRectMake(paddingSize.width, paddingSize.height, bounds.size.width - paddingSize.width*2, bounds.size.height - paddingSize.height*2);
        if (realBounds.size.width>0&&realBounds.size.height>0&&sizePerItem.width>0&&sizePerItem.height>0) {
            NSInteger widthCount = realBounds.size.width/sizePerItem.width;
            NSInteger heightCount = realBounds.size.height/sizePerItem.height;
            if (widthCount*heightCount<=countPerPage) {
                spacerWidth = 0.0;
                spacerHeight = 0.0;
                extraWidthSpacer = 0.0;
                extraHeightSpacer = 0.0;
                prefixHeight = 0.0;
                prefixWidth = 0.0;
                realFitSize = CGSizeMake(widthCount, heightCount);
                realCountPerPage = widthCount*heightCount;
                countPage = itemCount/realCountPerPage + (itemCount%realCountPerPage>0?1:0);
            }
            else
            {
                BOOL hasFound = NO;
                CGSize fitSize = CGSizeZero;
                if (widthCount>heightCount) {
                    NSInteger oldRemoveInt = 0;
                    for (int i=1; i<=widthCount-heightCount; i++) {
                        NSInteger adjustedCount = (widthCount - i)*heightCount;
                        if (adjustedCount>=countPerPage) {
                            oldRemoveInt = i;
                        }
                        else
                        {
                            hasFound = YES;
                            break;
                        }
                    }
                    fitSize = CGSizeMake(widthCount - oldRemoveInt, heightCount);
                }
                else
                {
                    NSInteger oldRemoveInt = 0;
                    for (int i=1; i<=heightCount-widthCount; i++) {
                        NSInteger adjustedCount = (heightCount - i)*widthCount;
                        if (adjustedCount>=countPerPage) {
                            oldRemoveInt = i;
                        }
                        else
                        {
                            hasFound = YES;
                            break;
                        }
                    }
                    fitSize = CGSizeMake(widthCount, heightCount - oldRemoveInt);
                }
                if(!hasFound)
                {
                    NSInteger maxWidth = fitSize.width;
                    NSInteger oldRemoveInt = 0;
                    NSInteger fitWidth = maxWidth;
                    NSInteger fitHeight = maxWidth;
                    for (int i=1; i<maxWidth; i++) {
                        NSInteger adjustedCount = (maxWidth - i)*(maxWidth -i +1);
                        if (adjustedCount>=countPerPage) {
                            oldRemoveInt = i;
                            fitWidth = maxWidth - i;
                        }
                        else
                        {
                            hasFound = YES;
                            break;
                        }
                        adjustedCount = (maxWidth - i)*(maxWidth -i);
                        if (adjustedCount>=countPerPage) {
                            oldRemoveInt = i;
                            fitHeight = maxWidth - i;
                        }
                        else
                        {
                            hasFound = YES;
                            break;
                        }
                    }
                    fitSize = CGSizeMake(fitWidth, fitHeight);
                }
                realFitSize = fitSize;
                realCountPerPage = ((int)fitSize.width)*((int)fitSize.height);
                countPage = itemCount/realCountPerPage + (itemCount%realCountPerPage>0?1:0);
                int totalspacerX = realBounds.size.width - ((int)fitSize.width)*sizePerItem.width;
                int totalspacerY = realBounds.size.height - ((int)fitSize.height)*sizePerItem.height;
                if ((int)fitSize.width>1&&fitSize.height>1) {
                    int spacerX = totalspacerX/((int)fitSize.width-1);
                    int spacerY = totalspacerY/((int)fitSize.height-1);
                    prefixHeight = 0.0;
                    prefixWidth = 0.0;
                    if(sameSapcer)
                    {
                        if (spacerX>spacerY) {
                            spacerWidth = spacerY;
                            spacerHeight = spacerY;
                            extraWidthSpacer = ((int)fitSize.width-1);
                            extraHeightSpacer = totalspacerY%((int)fitSize.height-1);
                        }
                        else
                        {
                            spacerWidth = spacerX;
                            spacerHeight = spacerX;
                            extraHeightSpacer = ((int)fitSize.height-1);
                            extraWidthSpacer = totalspacerX%((int)fitSize.width-1);
                        }
                    }
                    else
                    {
                        spacerWidth = spacerX;
                        spacerHeight = spacerY;
                        extraWidthSpacer = totalspacerX%((int)fitSize.width);
                        extraHeightSpacer = totalspacerY%((int)fitSize.height);
                    }
                }
                else
                {
                    if ((int)fitSize.width<=1) {
                        prefixWidth = totalspacerX/2;
                        spacerWidth = 0.0;
                        extraWidthSpacer = 0.0;
                    }
                    else
                    {
                        prefixWidth = 0.0;
                        int spacerX = totalspacerX/((int)fitSize.width-1);
                        spacerWidth = spacerX;
                        extraWidthSpacer = totalspacerX%((int)fitSize.width-1);
                    }
                    if ((int)fitSize.height<=1) {
                        prefixHeight = totalspacerY/2;
                        spacerHeight = 0.0;
                        extraHeightSpacer = 0.0;
                    }
                    else
                    {
                        prefixHeight = 0.0;
                        int spacerY = totalspacerY/((int)fitSize.height-1);
                        spacerHeight = spacerY;
                        extraHeightSpacer = totalspacerY%((int)fitSize.height-1);
                    }
                }
            }
        }
        else
        {
            realFitSize = CGSizeMake(1, 1);
            realCountPerPage = 1;
            spacerWidth = 0.0;
            spacerHeight = 0.0;
            extraWidthSpacer = 0.0;
            extraHeightSpacer = 0.0;
            prefixHeight = 0.0;
            prefixWidth = 0.0;
            countPage = itemCount;
        }
    }
    else
    {
        spacerWidth = 0.0;
        spacerHeight = 0.0;
        extraWidthSpacer = 0.0;
        extraHeightSpacer = 0.0;
        prefixHeight = 0.0;
        prefixWidth = 0.0;
        realFitSize = CGSizeMake(0, 0);
        realCountPerPage = 0;
        countPage = 0;
    }
}

-(CGSize)adjustPaddingSize
{
    CGSize rtval = paddingSize;
    if (sameSapcer) {
        NSInteger totalWidth = realFitSize.width*sizePerItem.width + (realFitSize.width-1)*spacerWidth + 2*prefixWidth + extraWidthSpacer;
        NSInteger totalHeight = realFitSize.height*sizePerItem.height + (realFitSize.height-1)*spacerHeight + 2*prefixHeight + extraHeightSpacer;
        CGRect scrollBounds = self.scrollView.bounds;
        rtval.width = scrollBounds.size.width/2 - totalWidth/2;
        rtval.height = scrollBounds.size.height/2 - totalHeight/2;
    }
    return rtval;
}

-(UIView*)redrawViewWithPage:(NSInteger)page
{
    if (page>=0) {
        UIView* newView = [[[UIView alloc] initWithFrame:self.scrollView.bounds] autorelease];
        newView.backgroundColor = [UIColor clearColor];
        int preCount = page*realCountPerPage;
        int preMovedX = 0;
        int preMovedY = 0;
        int leftExtraWidthSpacer = 0;
        int leftExtraHeightSpacer = 0;
        CGSize realPaddingSize = [self adjustPaddingSize];
        for (int i=0; i<realCountPerPage&&preCount+i<itemCount; i++) {
            PageItemCell* cell = [delegate pageView:self cellWithIndex:preCount+i];
            cell.curIndex = preCount+i;
            [cell addTarget:self action:@selector(cellClicked:) forControlEvents:UIControlEventTouchUpInside];
            CGRect cellRect = CGRectZero;
            if (i%((int)realFitSize.width)==0) {
                preMovedX = realPaddingSize.width + prefixWidth;
                leftExtraWidthSpacer = extraWidthSpacer;
                if (i<((int)realFitSize.width)) {
                    preMovedY = realPaddingSize.height + prefixHeight;
                    leftExtraHeightSpacer = extraHeightSpacer;
                }
                else
                {
                    preMovedY += sizePerItem.height + spacerHeight + (leftExtraHeightSpacer>0?1:0);
                    leftExtraHeightSpacer--;
                }
            }
            else
            {
                preMovedX += sizePerItem.width + spacerWidth + (leftExtraWidthSpacer>0?1:0);
                leftExtraWidthSpacer--;
            }
            cellRect.origin.x = preMovedX;
            cellRect.origin.y = preMovedY;
            cellRect.size = sizePerItem;
            cell.frame = cellRect;
            [newView addSubview:cell];
        }
        return newView;
    }
    else
    {
        return nil;
    }
}

-(void)reloadData
{
    itemCount = 0;
    if ([delegate respondsToSelector:@selector(numberOfCellsInPageView:)]) {
        itemCount = [delegate numberOfCellsInPageView:self];
    }
    if (countPerPage>0&&itemCount>0&&!CGSizeEqualToSize(sizePerItem, CGSizeZero)) {
        [self calculateArgumentFactors];
        if (curPage>=countPage) {
            curPage = countPage - 1;
        }
        pageControl.numberOfPages = countPage;
        pageControl.currentPage = curPage;
        if (countPage==1||!hasPageControll) {
            pageControl.hidden = YES;
        }
        else
        {
            pageControl.hidden = NO;
        }
        [self newCreatePage:curPage];
    }
    else
    {
        [self.preView removeFromSuperview];
        self.preView = nil;
        [self.curView removeFromSuperview];
        self.curView = nil;
        [self.nextView removeFromSuperview];
        self.nextView = nil;
        self.scrollView.contentSize = CGSizeZero;
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
}

-(void)setFrame:(CGRect)frame
{
    CGRect sourceRect = self.frame;
    [super setFrame:frame];
    
    NSValue* sourceValue = [NSValue valueWithCGRect:sourceRect];
    NSValue* destValue = [NSValue valueWithCGRect:frame];
    if (!sourceRectValue) {
        self.sourceRectValue = sourceValue;
    }
    self.destRectValue = destValue;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(frameChanged) object:nil];
    [self performSelector:@selector(frameChanged) withObject:nil afterDelay:0.001];
}

-(void)frameChanged
{
    if (self.destRectValue&&self.sourceRectValue) {
        CGRect frame = [self.destRectValue CGRectValue];
        CGRect sourceRect = [self.sourceRectValue CGRectValue];
        if (!CGRectEqualToRect(frame, CGRectZero)&&!CGRectEqualToRect(frame, sourceRect))
        {
            self.scrollView.hidden = YES;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadFromFrameChanged) object:nil];
            [self performSelector:@selector(reloadFromFrameChanged) withObject:nil afterDelay:0.01];
            self.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            self.backImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
            CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
            CGRect pageRect = bounds;
            pageRect.size.height = 20;
            pageRect.origin.x = bounds.origin.x + bounds.size.width/2 - pageRect.size.width/2;
            pageRect.origin.y = bounds.origin.y + bounds.size.height - 20;
            self.pageControl.frame = pageRect;
        }
    }
    self.sourceRectValue = nil;
    self.destRectValue = nil;
}

-(void)reloadFromFrameChanged
{
    self.scrollView.hidden = NO;
    [self reloadData];
}

-(void)cellClicked:(PageItemCell*)sender
{
    if ([delegate respondsToSelector:@selector(pageView:cellClickedWithCell:byBtn:)]) {
        [delegate pageView:self cellClickedWithCell:sender byBtn:YES];
    }
}

-(void)realPageChanged:(NSInteger)oldPage withNewPage:(NSInteger)newPage
{
    if (oldPage!=newPage) {
        if (abs(newPage-oldPage)<3) {
            [self reusePage:oldPage withNewPage:newPage];
        }
        else
        {
            [self newCreatePage:newPage];
        }
    }
}

-(void)reusePage:(NSInteger)oldPage withNewPage:(NSInteger)newPage
{
    CGRect scrollBounds = scrollView.bounds;
    CGRect viewRect = CGRectMake(0, 0, scrollBounds.size.width, scrollBounds.size.height);
    int skipedPage = newPage-oldPage;
    if (skipedPage>0) {
        int tempPage = oldPage;
        for (int i=0; i<skipedPage; i++) {
            [self.preView removeFromSuperview];
            self.preView = self.curView;
            self.curView = self.nextView;
            self.nextView = [self redrawViewWithPage:tempPage+2];
            if (self.nextView) {
                int curPageXPos = scrollBounds.size.width*(tempPage+2);
                viewRect.origin.x = curPageXPos;
                self.nextView.frame = viewRect;
                [self.scrollView addSubview:self.nextView];
            }
            tempPage++;
        }
    }
    else
    {
        int tempPage = oldPage;
        skipedPage = -skipedPage;
        for (int i=0; i<skipedPage; i++) {
            [self.nextView removeFromSuperview];
            self.nextView = self.curView;
            self.curView = self.preView;
            self.preView = [self redrawViewWithPage:tempPage-2];
            if (self.preView) {
                int curPageXPos = scrollBounds.size.width*(tempPage-2);
                viewRect.origin.x = curPageXPos;
                self.preView.frame = viewRect;
                [self.scrollView addSubview:self.preView];
            }
            tempPage--;
        }
    }
}

-(void)newCreatePage:(NSInteger)newPage
{
    CGRect scrollBounds = scrollView.bounds;
    scrollView.contentSize = CGSizeMake(scrollBounds.size.width*countPage, scrollBounds.size.height);
    CGRect viewRect = CGRectMake(0, 0, scrollBounds.size.width, scrollBounds.size.height);
    int curPageXPos = scrollBounds.size.width*curPage;
    if (curPage>0) {
        [self.preView removeFromSuperview];
        self.preView = [self redrawViewWithPage:curPage-1];
        viewRect.origin.x = curPageXPos - scrollBounds.size.width;
        self.preView.frame = viewRect;
        [self.scrollView addSubview:self.preView];
    }
    else
    {
        [self.preView removeFromSuperview];
        self.preView = nil;
    }
    [self.curView removeFromSuperview];
    self.curView = [self redrawViewWithPage:curPage];
    viewRect.origin.x = curPageXPos;
    self.curView.frame = viewRect;
    [self.scrollView addSubview:self.curView];
    if (curPage+1<countPage)
    {
        [self.nextView removeFromSuperview];
        self.nextView = [self redrawViewWithPage:curPage+1];
        viewRect.origin.x = curPageXPos + scrollBounds.size.width;
        self.nextView.frame = viewRect;
        [self.scrollView addSubview:self.nextView];
    }
    else
    {
        [self.nextView removeFromSuperview];
        self.nextView = nil;
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
    NSInteger oldPage = curPage;
    pageControl.currentPage = page;
    curPage = page;
    [self realPageChanged:oldPage withNewPage:page];
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
    NSInteger oldPage = curPage;
    curPage = page;
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
    [self realPageChanged:oldPage withNewPage:page];
}

@end
