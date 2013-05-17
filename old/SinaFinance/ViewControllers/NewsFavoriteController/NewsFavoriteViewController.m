//
//  NewsFavoriteViewController.m
//  SinaNews
//
//  Created by  on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsFavoriteViewController.h"
#import "NewsFavoriteTableViewCell.h"
#import "PageTableViewCell.h"
#import "EGORefreshTableHeaderView.h"
#import "NewsContentViewController2.h"
#import "LKTipCenter.h"
#import "MyTool.h"
#import "ASIHTTPRequest.h"
#import "LoginViewController.h"
#import "NewsObject.h"
#import "NewsFavoritePuller.h"
#import "NewsContentViewController2.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"

#define FavoriteCellHeight @"FavoriteCellHeight"

#define NEWSFAVORITE_CONTENT @"content"
#define NEWSFAVORITE_NEWSTITLE @"title"
#define NEWSFAVORITE_NEWSURL @"url"
#define NEWSFAVORITE_NEWSID @"id"
@interface NewsFavoriteViewController ()

@property(nonatomic,retain)UITableView* table;
@property(nonatomic,retain)NSMutableArray* NewsArray;
@property(nonatomic,retain)EGORefreshTableHeaderView *refreshHeaderView;

@property(nonatomic,retain)NSArray* dateBtnArray;
@property(nonatomic,assign)NSInteger curPage;
@property(nonatomic,retain)NSArray* dataID;
@property(nonatomic,retain)CommentDataList* dataList;


-(void)initNotification;
-(void)initUI;
-(void)initData;
-(void)addNavigationBtn;
- (void)doneLoadingTableViewData:(EGORefreshTableHeaderView*)view reloadTable:(BOOL)needReload;
-(void)reloadTableData;
-(void)startRefreshTable;
- (void)reloadTableViewDataSource:(EGORefreshTableHeaderView*)view downLoad:(BOOL)needDown;
-(void)postFailedTip;

@end

@implementation NewsFavoriteViewController
@synthesize table=mTable;
@synthesize NewsArray;

@synthesize refreshHeaderView=mRefreshHeaderView;


@synthesize curPage=mCurPage;
@synthesize dateBtnArray;
@synthesize dataID;
@synthesize dataList;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataID = [[NSArray alloc] initWithObjects:@"newsfavorite", nil];
        dataList = [[CommentDataList alloc] init];
        bInited = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    [mRefreshHeaderView release];
    [mTable release];
    [dateBtnArray release];
    [dataID release];
    [dataList release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (!bInited) {
        bInited = YES;
//        self.navigationBarHiden = YES;
        self.title = @"新闻收藏";
        [self addNavigationBtn];
        [self initNotification];

        [self initData];
        [self initUI];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self 
           selector:@selector(NavObjectsAdded:) 
               name:NewsFavoriteObjectAddedNotification 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(NavObjectsFailed:) 
               name:NewsFavoriteObjectFailedNotification 
             object:nil];
}
-(void)initData
{
    [[NewsFavoritePuller getInstance] startFavariteListNews:1 args:self.dataID dataList:self.dataList bInback:NO];
}

-(void)initUI
{
    MyCustomToolbar *topToolBar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    
    CGRect tableRect = self.view.bounds;
    tableRect.origin.y = 44;
    tableRect.size.height -= 44;
    UITableView* aTable = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    aTable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    aTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:aTable];
    aTable.delegate = self;
    aTable.dataSource = self;
    self.table =aTable;
    [aTable release];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(110, 0, 100, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    titleLabel.text = @"收藏";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:backBtn];
    
    UIButton* tempBtn1 = [[UIButton alloc] init];
    tempBtn1.frame = CGRectMake(235, 8, 70, 30);
    [tempBtn1 setTitle:@"编辑" forState:UIControlStateNormal];
    UIImage* btnImage = [UIImage imageNamed:@"btn_bg.png"];
    btnImage = [btnImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:5.0];
    [tempBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    tempBtn1.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [tempBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tempBtn1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [tempBtn1 addTarget:self action:@selector(editClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:tempBtn1];
    [tempBtn1 release];
}

-(void)addNavigationBtn
{ 
    
}

-(void)editClicked:(UIButton*)sender
{
    BOOL edited = self.table.editing;
    edited = !edited;
    [self.table setEditing:edited];
    if (edited) {
        [sender setTitle:@"关闭" forState:UIControlStateNormal];
    }
    else
    {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
}

- (void)handleBackPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)NavObjectsAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = [notify userInfo];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    if([stageNumber intValue]==Stage_Request_FavoriteNewsList)
    {
        curPageType = PageCellType_Ending;
        NSNumber* page = [userInfo objectForKey:@"page"];
        self.curPage = [page intValue];
        [self doneLoadingTableViewData:self.refreshHeaderView reloadTable:YES];
    }
    else if([stageNumber intValue]==Stage_Request_RemoveFavoriteNews||[stageNumber intValue]==Stage_Request_FavoriteNews)
    {
        [[NewsFavoritePuller getInstance] startFavariteListNews:1 args:self.dataID dataList:self.dataList bInback:NO];
    }
    
}

-(void)NavObjectsFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = [notify userInfo];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    if([stageNumber intValue]==Stage_Request_FavoriteNewsList)
    {
        [self postFailedTip];
    }
}


-(void)postFailedTip
{
    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.view];
}

-(void)startRefreshTable
{
    [self reloadTableViewDataSource:self.refreshHeaderView downLoad:NO];
}

#pragma mark -
#pragma mark table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowNum = indexPath.row;
    BOOL bBottom = rowNum>=[dataList contentsCountWithIDList:self.dataID];
    
    if (!bBottom) 
    {
        NewsObject* oneData = [dataList oneObjectWithIndex:rowNum IDList:self.dataID];
        NSNumber* cellNumber = [oneData userInfoValueForKey:FavoriteCellHeight];
        if (cellNumber) {
            return [cellNumber floatValue];
        }
        else
        {
            NewsObject* oneNews = oneData;
            NSString* heightKey = FavoriteCellHeight;
            
            NSNumber* heightNumber = [oneNews userInfoValueForKey:heightKey];
            if (heightNumber) {
                return [heightNumber intValue];
            }
            else
            {
                UITableViewCell* tableCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                CGSize cellSize = [tableCell sizeThatFits:CGSizeZero];
                [oneNews setUserInfoValue:[NSNumber numberWithInt:cellSize.height] forKey:heightKey];
                //[oneNews refreshToDataBase];
                return cellSize.height;
            }
        } 
    }
    else
    {
        PageTableViewCell* rtval = nil;
        NSString* userIdentifier = @"pageIdentifier";
        rtval = (PageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:userIdentifier];
        if (!rtval) {
            rtval = [[[PageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
        }
        CGSize heigtSize = [rtval sizeThatFits:CGSizeZero];
        return heigtSize.height;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [dataList contentsCountWithIDList:self.dataID];
    if (count>0) {
        count++;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int rowNum = [indexPath row];
    UITableViewCell* cell = nil;
    BOOL bBottom = rowNum>=[dataList contentsCountWithIDList:self.dataID];
    if (!bBottom) {
        NSString *userIdentifier = [NSString stringWithFormat:@"scroll"];
        NewsFavoriteTableViewCell *rtval = (NewsFavoriteTableViewCell*)[tableView dequeueReusableCellWithIdentifier:userIdentifier];
        if (rtval==nil) {  
            rtval = [[[NewsFavoriteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
            rtval.backgroundColor = [UIColor clearColor];
            rtval.contentView.backgroundColor = [UIColor clearColor];
            CGRect rtvalRect = rtval.contentView.bounds;
            UIImage* favoriteBackImage = [UIImage imageNamed:@"favoritecell_back.png"];
            favoriteBackImage = [favoriteBackImage stretchableImageWithLeftCapWidth:20.0 topCapHeight:21.0];
            UIImageView* favoriteBackView = [[UIImageView alloc] initWithImage:favoriteBackImage];
            favoriteBackView.frame = rtvalRect;
            favoriteBackView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            [rtval addSubview:favoriteBackView];
            [favoriteBackView release];
            
            UIImage* seperatorImage = [UIImage imageNamed:@"tablelist_seperator.png"];
            CGSize seperatorSize = seperatorImage.size;
            UIImageView* seperatorImageView = [[UIImageView alloc] initWithImage:seperatorImage];
            seperatorImageView.frame = CGRectMake(0, rtvalRect.size.height-seperatorSize.height, rtvalRect.size.width, seperatorSize.height);
            seperatorImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
            [rtval addSubview:seperatorImageView];
            [seperatorImageView release];
            
            [rtval sendSubviewToBack:seperatorImageView];
            [rtval sendSubviewToBack:favoriteBackView];
        }
        NewsObject* oneNews = [dataList oneObjectWithIndex:rowNum IDList:self.dataID];
        
        //NSDictionary* contentDict = [oneNews valueForKey:NEWSFAVORITE_CONTENT];
        NSString* tempStr = oneNews.dataString;
        NSString* nameStr = [oneNews valueForKey:NEWSFAVORITE_NEWSTITLE];
        rtval.nameString = nameStr;
        //rtval.url = [contentDict valueForKey:NEWSFAVORITE_NEWSURL];
        [rtval reloadData];
        
        cell = rtval;
    }
    else
    {
        PageTableViewCell* rtval = nil;
        NSString* userIdentifier = @"pageIdentifier";
        rtval = (PageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:userIdentifier];
        if (!rtval) {
            rtval = [[[PageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
            rtval.delegate = self;
        }
        rtval.type = curPageType;
        [rtval reloadData];
        cell = rtval;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  
{
    int rowNum = indexPath.row;
    BOOL bBottom = rowNum>=[dataList contentsCountWithIDList:self.dataID];
    if (!bBottom) {
        NewsObject* oneNews = [dataList oneObjectWithIndex:rowNum IDList:self.dataID];
        if (oneNews) {
            NSString* urlStr = [oneNews valueForKey:NEWSFAVORITE_NEWSURL];
            NSString* comentCount = nil;
            NewsContentViewController2 *newsContent = [[NewsContentViewController2 alloc] initWithNewsURL2:urlStr];
            newsContent.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newsContent animated:YES];
            
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [newsContent release];
        }
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    int rowNum = indexPath.row;
    BOOL bBottom = rowNum>=[dataList contentsCountWithIDList:self.dataID];
    if (!bBottom) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    int rowNum = indexPath.row;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        // [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        NewsObject* oneNews = [dataList oneObjectWithIndex:rowNum IDList:self.dataID];
		[[NewsFavoritePuller getInstance] startRemoveFavoriteNewsWithSender:self idstr:[oneNews valueForKey:NEWSFAVORITE_NEWSID] inBack:NO];
	}   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)cell:(PageTableViewCell*)cell didclicked:(UIButton*)sender
{
    curPageType = PageCellType_Loading;
    cell.type = PageCellType_Loading;
    [cell reloadData];
    [[NewsFavoritePuller getInstance] startFavariteListNews:self.curPage + 1 args:self.dataID dataList:self.dataList bInback:NO];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource:(EGORefreshTableHeaderView*)view downLoad:(BOOL)needDown
{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    if (view==mRefreshHeaderView) {
        BOOL doneLoading = NO;
        [[NewsFavoritePuller getInstance] startFavariteListNews:self.curPage + 1 args:self.dataID dataList:self.dataList bInback:NO];
        

        [self.refreshHeaderView startLoadingUI];
        view.reloading = YES;
    }
	
}

- (void)doneLoadingTableViewData:(EGORefreshTableHeaderView*)view reloadTable:(BOOL)needReload
{
	
	//  model should call this when its done loading
	view.reloading = NO;
    if (view==mRefreshHeaderView) {
        [view egoRefreshScrollViewDataSourceDidFinishedLoading];
    }
    if (needReload) {
        [self reloadTableData];
    }
}

-(void)reloadTableData
{
    [dataList reloadShowedDataWithIDList:self.dataID];
    [mTable reloadData];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[mRefreshHeaderView egoRefreshScrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[mRefreshHeaderView egoRefreshScrollViewDidEndDragging];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource:view downLoad:YES];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return view.reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	if(view==mRefreshHeaderView)
    {
        NSDate* date = [dataList dateInfoWithIDList: self.dataID];
        return date;
    }
    else
        return nil;
}

@end
