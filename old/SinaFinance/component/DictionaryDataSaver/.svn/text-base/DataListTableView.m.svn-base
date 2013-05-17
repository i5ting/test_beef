//
//  DataListTableView.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataListTableView.h"

#define DataListSucBackString @"无内容"
#define DataListErrBackString @"网络错误"
#define DataListLoadingBackString @"载入中..."

@interface DataListTableView ()
@property(nonatomic,retain)NSMutableArray* cellCountList;
-(void)realInit:(CGRect)frame;
-(PageTableViewCell*)findPageCell;
-(void)adjusetBackLabel:(CGRect)frame;
@end

@implementation DataListTableView
{
    BOOL canTrigNextPage;
    BOOL useSpecilDelegate;
    NSMutableArray* cellCountList;
    BOOL curLoadedState;
    NSInteger curSectionCount;
}
@synthesize dataList,selectID,delegate;
@synthesize tableView;
@synthesize refreshView;
@synthesize hasPageMode,pageMode;
@synthesize autoNextPage;
@synthesize hasHeaderMode;
@synthesize backLabel;
@synthesize defaultSucBackString,defaultErrBackString,defaultLoadingBackString;
@synthesize cellCountList;
@dynamic objects;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        hasHeaderMode = YES;
        hasPageMode = YES;
        canTrigNextPage = YES;
        useSpecilDelegate = NO;
        curLoadedState = LoadedState_Suc;
        [self realInit:CGRectZero];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame pageMode:(BOOL)hasPage headerMode:(BOOL)hasHeader
{
    self = [super initWithFrame:frame];
    {
        hasHeaderMode = hasHeader;
        hasPageMode = hasPage;
        canTrigNextPage = YES;
        useSpecilDelegate = NO;
        curLoadedState = LoadedState_Suc;
        [self realInit:frame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        hasHeaderMode = YES;
        hasPageMode = YES;
        canTrigNextPage = YES;
        useSpecilDelegate = NO;
        curLoadedState = LoadedState_Suc;
        [self realInit:frame];
        
    }
    return self;
}

-(void)realInit:(CGRect)frame
{
    autoNextPage = YES;
    self.backgroundColor = [UIColor clearColor];
    CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    tableView = [[UITableView alloc] initWithFrame:bounds style:UITableViewStylePlain];
    tableView.scrollsToTop = YES;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:tableView];
    
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - bounds.size.height, bounds.size.width, bounds.size.height)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    view.delegate = self;
    [tableView addSubview:view];
    self.refreshView = view;
    view.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:0.8];
    [view release];
    
    self.defaultSucBackString  = DataListSucBackString;
    self.defaultErrBackString = DataListErrBackString;
    self.defaultLoadingBackString = DataListLoadingBackString;
    backLabel = [[UILabel alloc] init];
    backLabel.backgroundColor = [UIColor clearColor];
    backLabel.text = defaultSucBackString;
    backLabel.font = [UIFont systemFontOfSize:20.0];
    backLabel.hidden = YES;
    [self adjusetBackLabel:frame];
}

-(void)dealloc
{
    [dataList release];
    [selectID release];
    [tableView release];
    [refreshView release];
    [backLabel release];
    [defaultSucBackString release];
    [defaultErrBackString release];
    [defaultLoadingBackString release];
    [cellCountList release];
    
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect bounds = self.bounds;
    tableView.frame = bounds;
    self.refreshView.frame = CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    [self adjusetBackLabel:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setBackLabel:(UILabel *)aBackLabel
{
    if (backLabel!=aBackLabel) {
        UILabel* oldLabel = backLabel;
        backLabel = [aBackLabel retain];
        [oldLabel release];
    }
    CGRect frame = self.bounds;
    [self adjusetBackLabel:frame];
}

-(void)adjusetBackLabel:(CGRect)frame
{
    [backLabel sizeToFit];
    CGRect backRect = backLabel.frame;
    NSInteger headerHeight = 0;
    if (self.tableView.tableHeaderView) {
        headerHeight = self.tableView.tableHeaderView.frame.size.height;
    }
    backRect.origin.x = frame.size.width/2 - backRect.size.width/2;
    backRect.origin.y = frame.size.height/2 - (backRect.size.height-headerHeight)/2;
    backLabel.frame = backRect;
    [self.tableView addSubview:backLabel];
    [self.tableView bringSubviewToFront:backLabel];
}

-(void)setPageMode:(NSInteger)aPageMode
{
    pageMode = aPageMode;
    PageTableViewCell* pageCell = [self findPageCell];
    if (pageCell) {
        if (pageMode==PageState_Normal) {
            [pageCell setType:PageCellType_Normal];
        }
        else if (pageMode==PageState_End) {
            [pageCell setType:PageCellType_Ending];
        }
        else if (pageMode==PageState_Loading) {
            [pageCell setType:PageCellType_Loading];
        }
        if (self.refreshView.reloading) {
            pageCell.clickable = NO;
        }
        else
        {
            pageCell.clickable = YES;
        }
        [pageCell reloadData];
    }
}

-(void)reloadData
{
    [self.dataList reloadShowedDataWithIDList:self.selectID];
    [tableView reloadData];
    [self reloadBackLabel];
}

-(void)reloadBackLabel
{
    int count = [self.dataList contentsCountWithIDList:self.selectID];
    if (count>0) {
        backLabel.hidden = YES;
    }
    else
    {
        if (curLoadedState==LoadedState_Suc) {
            if (defaultSucBackString) {
                backLabel.text = self.defaultSucBackString;
            }
            else {
                backLabel.text = DataListSucBackString;
            }
        }
        else {
            if (defaultErrBackString) {
                backLabel.text = self.defaultErrBackString;
            }
            else {
                backLabel.text = DataListErrBackString;
            }
        }
        backLabel.hidden = NO;
        [self adjusetBackLabel:self.bounds];
    }
}

- (void)doneLoading
{
    self.refreshView.reloading = NO;
    if (hasHeaderMode) {
        [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading];
    }
    int count = [self.dataList contentsCountWithIDList:self.selectID];
    if (count>0) {
        backLabel.hidden = YES;
    }
    else
    {
        backLabel.hidden = NO;
        [self adjusetBackLabel:self.bounds];
    }
}

-(void)scrollTop:(BOOL)animate
{
    if (!self.refreshView.reloading) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:animate];
    }
}

-(void)scrollEnd:(BOOL)animate
{
    CGSize tableContentSize = self.tableView.contentSize;
    [self.tableView scrollRectToVisible:CGRectMake(0, tableContentSize.height-1, 1, 1) animated:animate];
}

-(void)setHasHeaderMode:(BOOL)bHeaderMode
{
    hasHeaderMode = bHeaderMode;
    if (hasHeaderMode) {
        self.refreshView.hidden = NO;
    }
    else
    {
        self.refreshView.reloading = NO;
        [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading];
        self.refreshView.hidden = YES;
    }
}

-(NSArray*)objects
{
    return [dataList contentsWithIDList:self.selectID];
}

#pragma mark
#pragma mark UITableView Delegate
- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([delegate respondsToSelector:@selector(dataListView:canMoveRowAtIndexPath:)]) {
        return [delegate dataListView:self canMoveRowAtIndexPath:indexPath];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if ([delegate respondsToSelector:@selector(dataListView:moveRowAtIndexPath:toIndexPath:)]) {
        [delegate dataListView:self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([delegate respondsToSelector:@selector(dataListView:canEditRowAtIndexPath:)]) {
        return [delegate dataListView:self canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([delegate respondsToSelector:@selector(dataListView:editingStyleForRowAtIndexPath:)]) {
        return [delegate dataListView:self editingStyleForRowAtIndexPath:indexPath];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([delegate respondsToSelector:@selector(dataListView:commitEditingStyle:forRowAtIndexPath:)]) {
        [delegate dataListView:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([delegate respondsToSelector:@selector(dataListView:heightForHeaderInSection:)]) {
        return [delegate dataListView:self heightForHeaderInSection:section];
    }
    return 0.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;   
{
    if ([delegate respondsToSelector:@selector(dataListView:titleForHeaderInSection:)]) {
        return [delegate dataListView:self titleForHeaderInSection:section];
    }
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([delegate respondsToSelector:@selector(dataListView:viewForHeaderInSection:)]) {
        return [delegate dataListView:self viewForHeaderInSection:section];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowInt = indexPath.row;
    int section = indexPath.section;
    NSInteger cellCount = [[cellCountList objectAtIndex:section] intValue];
    NSInteger realCellCount = cellCount;
    if (hasPageMode) {
        if (curSectionCount>1) {
            if (section==curSectionCount-1) {
                realCellCount = cellCount-1;
            }
            else {
                realCellCount = cellCount;
            }
        }
        else {
            realCellCount = cellCount-1;
        }
    }
    if (rowInt<realCellCount) {
        NewsObject* object = [dataList oneObjectWithIndex:rowInt IDList:self.selectID];
        int height = [delegate dataListView:self heightForIndexPath:indexPath object:object];
        return height;
    }
    else
    {
        PageTableViewCell* rtval = nil;
        NSString* userIdentifier = @"pageIdentifier";
        rtval = (PageTableViewCell*)[aTableView dequeueReusableCellWithIdentifier:userIdentifier];
        if (!rtval) {
            rtval = [[[PageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
        }
        CGSize heigtSize = [rtval sizeThatFits:self.bounds.size];
        return heigtSize.height;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger rtval = 0;
    if ([delegate respondsToSelector:@selector(dataListView:numberOfSectionsForObjects:)]) {
        NSArray* contents = [dataList contentsWithIDList:self.selectID];
        rtval = [delegate dataListView:self numberOfSectionsForObjects:contents];
    }
    else {
        NSArray* contents = [dataList contentsWithIDList:self.selectID];
        if (contents>0) {
            rtval = 1;
        }
        else {
            rtval = 0;
        }
    }
    curSectionCount = rtval;
    if (rtval>0||(rtval==0&&cellCountList&&[cellCountList count]>0)) {
        self.cellCountList = [NSMutableArray arrayWithCapacity:0];
    }
    for (int i=0; i<rtval; i++) {
        [cellCountList addObject:[NSNull null]];
    }
    return rtval;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int countNum = 0;
    if ([delegate respondsToSelector:@selector(dataListView:numberOfRowsInSection:)]) {
        useSpecilDelegate = YES;
        countNum = [delegate dataListView:self numberOfRowsInSection:section];
    }
    else
    {
        countNum = [dataList contentsCountWithIDList:self.selectID];
        
    }
    if (hasPageMode) {
        if (countNum>0) {
            if (section>0) {
                countNum++;
            }
            else if(curSectionCount==1)
            {
                countNum++;
            }
        }
    }
    [cellCountList replaceObjectAtIndex:section withObject:[NSNumber numberWithInt:countNum]];
    return countNum;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowInt = indexPath.row;
    int section = indexPath.section;
    NSInteger cellCount = [[cellCountList objectAtIndex:section] intValue];
    NSInteger realCellCount = cellCount;
    if (hasPageMode) {
        if (curSectionCount>1) {
            if (section==curSectionCount-1) {
                realCellCount = cellCount-1;
            }
            else {
                realCellCount = cellCount;
            }
        }
        else {
            realCellCount = cellCount-1;
        }
    }
    if (rowInt<realCellCount) {
        NewsObject* object = [dataList oneObjectWithIndex:rowInt IDList:self.selectID];
        UITableViewCell* rtval = [delegate dataListView:self cellForIndexPath:indexPath object:object];
        return rtval;
    }
    else
    {
        PageTableViewCell* rtval = nil;
        NSString* userIdentifier = @"pageIdentifier";
        rtval = (PageTableViewCell*)[aTableView dequeueReusableCellWithIdentifier:userIdentifier];
        if (!rtval) {
            if (![delegate respondsToSelector:@selector(dataListView:PageCellStyleIdentifier:)]) {
                rtval = [[[PageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
            }
            else
            {
                rtval = [delegate dataListView:self PageCellStyleIdentifier:userIdentifier];
            }
            rtval.delegate = self;
        }
        rtval.type = pageMode;
        if (self.refreshView.reloading) {
            rtval.clickable = NO;
        }
        else
        {
            rtval.clickable = YES;
        }
        [rtval reloadData];
        return rtval;
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowInt = indexPath.row;
    int section = indexPath.section;
    NSInteger cellCount = [[cellCountList objectAtIndex:section] intValue];
    NSInteger realCellCount = cellCount;
    if (hasPageMode) {
        if (curSectionCount>1) {
            if (section==curSectionCount-1) {
                realCellCount = cellCount-1;
            }
            else {
                realCellCount = cellCount;
            }
        }
        else {
            realCellCount = cellCount-1;
        }
    }
    if (rowInt<realCellCount) {
        NewsObject* object = [dataList oneObjectWithIndex:rowInt IDList:self.selectID];
        if ([delegate respondsToSelector:@selector(dataListView:didSelectedAtIndexPath:object:)]) {
            [delegate dataListView:self didSelectedAtIndexPath:indexPath object:object];
        }
    }
}

-(void)cell:(PageTableViewCell*)cell didclicked:(UIButton*)sender
{
    pageMode = PageState_Loading;
    cell.type = PageCellType_Loading;
    [cell reloadData];
    if ([delegate respondsToSelector:@selector(dataListViewDidMoreClicked:)]) {
        [delegate dataListViewDidMoreClicked:self];
    }
}

-(PageTableViewCell*)findPageCell
{
    PageTableViewCell* rtval = nil;
    NSArray* cells = [tableView visibleCells];
    for (UITableViewCell* cell in cells) {
        if ([cell isKindOfClass:[PageTableViewCell class]]) {
            rtval = (PageTableViewCell*)cell;
            break;
        }
    }
    return rtval;
}

- (void)doneLoadingWithReloadTable:(BOOL)needReload pageEnd:(BOOL)bEnd
{
    [self doneLoadingWithReloadTable:needReload pageEnd:bEnd state:LoadedState_Unkown];
}

- (void)doneLoadingWithReloadTable:(BOOL)needReload pageEnd:(BOOL)bEnd state:(NSInteger)state
{
    if (state!=LoadedState_Unkown) {
        curLoadedState = state;
    }
	//  model should call this when its done loading
    self.refreshView.reloading = NO;
    if (hasHeaderMode) {
        [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading];
    }
    if (bEnd) {
        self.pageMode = PageState_End;
    }
    else
    {
        self.pageMode = PageState_Normal;
    }
    if (needReload) {
        [self reloadData];
    }
    else {
        [self reloadBackLabel];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
    if (hasHeaderMode) {
        [self.refreshView egoRefreshScrollViewDidScroll];
    }
    if (hasPageMode&&!self.refreshView.reloading&&canTrigNextPage) {
        int contentHeight = scrollView.contentSize.height;
        contentHeight = contentHeight>=scrollView.bounds.size.height?contentHeight:scrollView.bounds.size.height;
        int extraHeight = contentHeight - scrollView.bounds.size.height;
        if (scrollView.contentOffset.y>extraHeight + 45) {
            if (hasPageMode&&pageMode==PageState_Normal) {
                pageMode = PageState_Loading;
                PageTableViewCell* pageCell = [self findPageCell];
                if (pageCell) {
                    pageCell.type = PageCellType_Loading;
                    [pageCell reloadData];
                }
                canTrigNextPage = NO;

                if ([delegate respondsToSelector:@selector(dataListViewDidMoreClicked:)]) {
                    [delegate dataListViewDidMoreClicked:self];
                }
            }
        }
    }
    if([delegate respondsToSelector:@selector(dataListViewDidScroll:)])
    {
        [delegate dataListViewDidScroll:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (hasHeaderMode) {
        [self.refreshView egoRefreshScrollViewDidEndDragging];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if([delegate respondsToSelector:@selector(dataListViewWillBeginDragging:)])
    {
        [delegate dataListViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    canTrigNextPage = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    canTrigNextPage = YES;
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

-(void)startLoadingUI
{
    [self startLoadingUIWithShowHeader:YES];
}

-(void)startLoadingUIWithShowHeader:(BOOL)bShowHeader
{
    if (hasHeaderMode&&bShowHeader) {
        [self.refreshView startLoadingUI];
    }
    self.refreshView.reloading = YES;
    if (hasPageMode) {
        PageTableViewCell* pageCell = [self findPageCell];
        pageCell.clickable = NO;
    }
    int count = [self.dataList contentsCountWithIDList:self.selectID];
    if (count>0) {
        self.backLabel.hidden = YES;
    }
    else {
        if (hasHeaderMode) {
            self.backLabel.hidden = YES;
        }
        else {
            self.backLabel.hidden = NO;
            if (defaultLoadingBackString) {
                self.backLabel.text = defaultLoadingBackString;
            }
            else {
                self.backLabel.text = DataListLoadingBackString;
            }
            [self adjusetBackLabel:self.bounds];
        }
    }
    
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(TableHeaderDidTriggerRefresh) object:nil];
    [self performSelector:@selector(TableHeaderDidTriggerRefresh) withObject:nil afterDelay:0.001 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
	
}

-(void)TableHeaderDidTriggerRefresh
{
    if (hasHeaderMode&&[delegate respondsToSelector:@selector(dataListViewDidRefreshTriggered:)]) {
        self.refreshView.reloading = YES;
        [self startLoadingUI];
        BOOL pageToNormal = NO;
        if ([self.delegate respondsToSelector:@selector(dataListViewCancelDidMore:)]) {
            BOOL canceled = [self.delegate dataListViewCancelDidMore:self];
            if (canceled) {
                pageToNormal = YES;
            }
        }
        if (self.pageMode==PageState_Normal) {
            self.pageMode = PageState_Normal;
        }
        else if(self.pageMode==PageState_Loading)
        {
            if (pageToNormal) {
                self.pageMode = PageState_Normal;
            }
            else
            {
                self.pageMode = PageState_Loading;
            }
        }
        else
        {
            self.pageMode = PageState_End;
        }
        [delegate dataListViewDidRefreshTriggered:self];
    }
    else
    {
        [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return view.reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [dataList dateInfoWithIDList:self.selectID];
}

-(BOOL)checkRefreshByDate:(NSTimeInterval)timeInterval
{
    BOOL rtval = NO;
    NSDate* oldDate = [self.dataList dateInfoWithIDList:self.selectID];
    if (oldDate) {
        NSTimeInterval length = [oldDate timeIntervalSinceDate:[NSDate date]];
        length = abs(length);
        if (length>60*60) {
            rtval = YES;
        }
    }
    else
        rtval = YES;
    return rtval;
}

@end
