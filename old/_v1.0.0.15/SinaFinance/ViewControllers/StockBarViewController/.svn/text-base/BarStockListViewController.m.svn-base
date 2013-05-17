//
//  BarStockListViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BarStockListViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "StockBarPuller.h"
#import "DataListTableView.h"
#import "LKTipCenter.h"
#import "BarStockTableCell.h"
#import "BarStockReplyViewController.h"
#import "EditBarSubjectViewController.h"

@interface BarStockListViewController()
@property(nonatomic,retain)DataListTableView* dataTableView;
@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)NSArray* selectID;
@property(nonatomic,retain)UIView* titleView;
- (void)createToolbar;
-(void)adjustTitleRect;
-(void)initUI;
-(void)initNotification;
-(void)startRefreshTable:(BOOL)bForce;
@end

@implementation BarStockListViewController
{
    UIView* titleView;
}
@synthesize stockName,stockNick,bid,titleView;
@synthesize dataTableView,dataList,selectID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        countPerPage = 20;
        dataList = [[CommentDataList alloc] init];
        selectID = [[NSMutableArray alloc] initWithObjects:@"onestocklist", nil];
    }
    return self;
}

-(void)dealloc
{
    [stockName release];
    [stockNick release];
    [titleView release];
    [dataTableView release];
    [dataList release];
    [selectID release];
    [bid release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createToolbar];
    [self initUI];
    if (!bInited) {
        bInited = YES;
        [self initNotification];
        [self startRefreshTable:YES];
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

- (void)createToolbar
{
    MyCustomToolbar* topToolBar = [[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    [topToolBar release];
    
    //topToolBar.title = self.navigationController.title;
    if (!self.titleView) {
        titleView = [[UIView alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
        UILabel* stockNameLabel = [[UILabel alloc] init];
        stockNameLabel.tag = 323231;
        stockNameLabel.backgroundColor = [UIColor clearColor];
        stockNameLabel.textColor = [UIColor whiteColor];
        [titleView addSubview:stockNameLabel];
        [stockNameLabel release];
        UILabel* stockNickLabel = [[UILabel alloc] init];
        stockNickLabel.textColor = [UIColor whiteColor];
        stockNickLabel.tag = 323232;
        stockNickLabel.backgroundColor = [UIColor clearColor];
        [titleView addSubview:stockNickLabel];
        [stockNickLabel release];
        UILabel* stockLabel = [[UILabel alloc] init];
        stockLabel.textColor = [UIColor whiteColor];
        stockLabel.tag = 323233;
        stockLabel.backgroundColor = [UIColor clearColor];
        stockLabel.text = @"-股吧";
        [titleView addSubview:stockLabel];
        [stockLabel release];
    }
    else {
        titleView.frame = CGRectMake(60, 0, 200, 44);
    }
    [topToolBar addSubview:titleView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:backBtn];
    
    UIButton *refreshBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(280, 10, 25, 23);
    [refreshBtn setImage:[UIImage imageNamed:@"refresh_btn.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(handleRefreshPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:refreshBtn];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(245, 10, 25, 23);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(handleAddPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:addBtn];
    
    UILabel* stockNameLabel = (UILabel*)[titleView viewWithTag:323231];
    UILabel* stockNickLabel = (UILabel*)[titleView viewWithTag:323232];
    UILabel* stockLabel = (UILabel*)[titleView viewWithTag:323233];
    if (stockName) {
        stockNameLabel.text = [NSString stringWithFormat:@"(%@)",stockName];
    }
    else {
        stockNameLabel.text = stockName;
    }
    if (stockNick) {
        stockNickLabel.text = stockNick;
    }
    else {
        stockNickLabel.text = @"";
    }
    [self adjustTitleRect];
}

-(void)adjustTitleRect
{
    UILabel* stockNameLabel = (UILabel*)[titleView viewWithTag:323231];
    UILabel* stockNickLabel = (UILabel*)[titleView viewWithTag:323232];
    UILabel* stockLabel = (UILabel*)[titleView viewWithTag:323233];
    
    CGRect titleViewBounds = titleView.bounds;
    [stockNameLabel sizeToFit];
    [stockNickLabel sizeToFit];
    [stockLabel sizeToFit];
    CGRect stockRect = stockLabel.bounds;
    CGRect nameRect = stockNameLabel.bounds;
    if (nameRect.size.width>140) {
        nameRect.size.width = 140;
    }
    CGRect nickRect = stockNickLabel.bounds;
    if (nickRect.size.width>140) {
        nickRect.size.width = 140;
    }
    NSInteger leftWidth = nameRect.size.width > nickRect.size.width ? nameRect.size.width : nickRect.size.width;
    NSInteger leftHeight = nameRect.size.height + nickRect.size.height;
    CGRect leftRect = CGRectMake(0, 0, leftWidth, leftHeight);
    CGRect rightRect = stockRect;
    leftRect.origin.x = titleViewBounds.size.width/2 - leftRect.size.width/2 - rightRect.size.width/2;
    leftRect.origin.y = titleViewBounds.size.height/2 - leftRect.size.height/2;
    rightRect.origin.x = leftRect.origin.x + leftRect.size.width;
    rightRect.origin.y = titleViewBounds.size.height/2 - rightRect.size.height/2;
    nickRect.origin.y = leftRect.origin.y;
    nickRect.origin.x = leftRect.origin.x + leftRect.size.width/2 - nickRect.size.width/2;
    nameRect.origin.y = nickRect.origin.y + nickRect.size.height;
    nameRect.origin.x = leftRect.origin.x + leftRect.size.width/2 - nameRect.size.width/2;
    stockRect.origin.x = rightRect.origin.x;
    stockRect.origin.y = rightRect.origin.y + rightRect.size.height/2 - stockRect.size.height/2;
    stockRect.origin.x -= 10;
    nameRect.origin.x -= 10;
    nickRect.origin.x -= 10;
    stockLabel.frame = stockRect;
    stockNameLabel.frame = nameRect;
    stockNickLabel.frame = nickRect;
}

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self 
           selector:@selector(StockBarObjectAdded:) 
               name:StockBarObjectAddedNotification 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(StockBarObjectFailed:) 
               name:StockBarObjectFailedNotification
             object:nil];
}

-(void)initUI
{
    int curY = 44;
    int maxHeight = self.view.bounds.size.height - curY;
    if (!self.dataTableView) {
        DataListTableView* dataView = [[DataListTableView alloc] initWithFrame:CGRectMake(0, curY, 320, maxHeight)];
        dataView.defaultSucBackString = @"";
        dataView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        dataView.delegate = self;
        dataView.tableView.backgroundColor = [UIColor colorWithRed:0/255.0 green:36/255.0 blue:58/255.0 alpha:1.0];
        dataView.selectID = selectID;
        dataView.backLabel.textColor = [UIColor whiteColor];
        dataView.dataList = dataList;
        self.dataTableView = dataView;
        [dataView release];
    }
    else
    {
        self.dataTableView.frame = CGRectMake(0, curY, 320, maxHeight);
    }
    [self.view addSubview:self.dataTableView];

}

-(void)startRefreshTable:(BOOL)bForce
{
    BOOL needRefresh = NO;
    if (bForce) {
        needRefresh = YES;
    }
    else
    {
        needRefresh = YES;
    }
    NSNumber* pageNumber = [self.dataList infoValueWithIDList:self.selectID ForKey:@"page"];
    if (pageNumber) {
        curPage = [pageNumber intValue];
    }
    else
    {
        curPage = 1;
    }
    [self.dataTableView scrollTop:NO];
    [self.dataTableView setPageMode:PageCellType_Normal];
    [self.dataTableView reloadData];
    
    if (needRefresh) {
        [self.dataTableView startLoadingUI];
        [[StockBarPuller getInstance] startOneStockBarListWithSender:self stockName:self.stockName bid:bid count:countPerPage page:1 args:self.selectID dataList:self.dataList];
    }
    else
    {
        [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
    }
}

#pragma mark -
#pragma mark BtnPressed
-(void)handleBackPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleRefreshPressed
{
    [self startRefreshTable:YES];
}

-(void)handleAddPressed
{
    EditBarSubjectViewController* editController = [[EditBarSubjectViewController alloc] initWithNibName:@"EditBarSubjectViewController" bundle:nil];
    editController.stockName = self.stockName;
    editController.stockNick = self.stockNick;
    editController.bid = self.bid;
    [self.navigationController pushViewController:editController animated:YES];
    [editController release];
}

#pragma mark -
#pragma mark networkCallback
-(void)StockBarObjectAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_OneStockBarList) {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSArray* array = [userInfo valueForKey:RequsetArray];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                curPage = [pageNumber intValue];
                if ([pageNumber intValue]<=1) {
                    [self.dataTableView scrollTop:NO];
                }
                if ([array count]>=countPerPage) {
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
                }
                else {
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:YES];
                }
            }
        }
    }
}

-(void)StockBarObjectFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if([stageNumber intValue]==Stage_Request_OneStockBarList)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID])
            {
                [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
            }
        }
    }
}

#pragma mark -
#pragma mark DataListTableView
-(UITableViewCell*)dataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    int rowNum = path.row;
    BarStockTableCell* rtval = nil;
    NSString* userIdentifier = @"Identifier";
    rtval = (BarStockTableCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[BarStockTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
    }
    NSString* isTop = [object valueForKey:StockBar_OneStockList_isTop];
    NSString* titleString = [object valueForKey:StockBar_OneStockList_title];
    if (isTop&&[isTop intValue]>0) {
        titleString = [NSString stringWithFormat:@"[置顶]%@",titleString];
    }
    rtval.titleLabel.text = titleString;
    rtval.clickNumLabel.text = [object valueForKey:StockBar_OneStockList_views];
    rtval.replayNumLabel.text = [object valueForKey:StockBar_OneStockList_reply];
    NSString* dateString = [object valueForKey:StockBar_OneStockList_lastctime];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* newFormatDate = [formatter dateFromString:dateString];
    formatter.dateFormat = @"MM-dd HH:mm";
    dateString = [formatter stringFromDate:newFormatDate];
    [formatter release];
    rtval.dateLabel.text = dateString;
    
    return rtval;
}

-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    BarStockTableCell* rtval = nil;
    NSString* userIdentifier = @"Identifier";
    rtval = (BarStockTableCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[BarStockTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
    }
    return [rtval sizeThatFits:CGSizeZero].height;
}

-(void)dataListView:(DataListTableView*)view didSelectedAtIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    [view.tableView deselectRowAtIndexPath:path animated:YES];
    BarStockReplyViewController* replyViewController = [[BarStockReplyViewController alloc] init];
    replyViewController.stockName = self.stockName;
    replyViewController.stockNick = self.stockNick;
    replyViewController.bid = [object valueForKey:StockBar_OneStockList_bid];
    replyViewController.tid = [object valueForKey:StockBar_OneStockList_tid];
    replyViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:replyViewController animated:YES];
    [replyViewController release];
    
}

-(void)dataListViewDidMoreClicked:(DataListTableView*)view
{
    [[StockBarPuller getInstance] startOneStockBarListWithSender:self stockName:self.stockName bid:bid count:countPerPage page:curPage+1 args:self.selectID dataList:self.dataList];
}
-(void)dataListViewDidRefreshTriggered:(DataListTableView*)view
{
    [self startRefreshTable:YES];
}

-(PageTableViewCell*)dataListView:(DataListTableView*)view PageCellStyleIdentifier:(NSString*)identifier
{
    PageTableViewCell* rtval = [[[PageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    [rtval setTipString:@"更多..." forType:PageCellType_Normal];
    [rtval setTipColor:[UIColor whiteColor] forType:PageCellType_Normal];
    [rtval setTipColor:[UIColor whiteColor] forType:PageCellType_Ending];
    return rtval;
}

@end
