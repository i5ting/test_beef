//
//  BarStockReplyViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BarStockReplyViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "StockBarPuller.h"
#import "DataListTableView.h"
#import "LKTipCenter.h"
#import "BarStockTableCell.h"
#import "BarStockReplyCell.h"
#import "EditBarSubjectViewController.h"
#import "MyTool.h"

#define StockBar_SupportKey @"StockBar_SupportKey"
#define StockBar_AgainstKey @"StockBar_AgainstKey"

@interface BarStockReplyViewController()
@property(nonatomic,retain)DataListTableView* dataTableView;
@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)NSArray* selectID;
@property(nonatomic,retain)UIView* titleView;
@property(nonatomic,retain)UIView* bottomView;
- (void)createToolbar;
-(void)adjustTitleRect;
-(void)initUI;
-(void)initNotification;
-(void)startRefreshTable:(BOOL)bForce;
@end

@implementation BarStockReplyViewController
{
    UIView* titleView;
    UIView* bottomView;
}
@synthesize stockName,stockNick,bid,tid,titleView;
@synthesize dataTableView,dataList,selectID;
@synthesize bottomView;

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
    [tid release];
    [bottomView release];
    
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
    if (nameRect.size.width>180) {
        nameRect.size.width = 180;
    }
    CGRect nickRect = stockNickLabel.bounds;
    if (nickRect.size.width>180) {
        nickRect.size.width = 180;
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
    stockRect.origin.x +=10;
    nameRect.origin.x +=10;
    nickRect.origin.x +=10;
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
    int bottomHeight = 51;
    int maxHeight = self.view.bounds.size.height - curY - bottomHeight;
    if (!self.dataTableView) {
        DataListTableView* dataView = [[DataListTableView alloc] initWithFrame:CGRectMake(0, curY, 320, maxHeight)];
        dataView.defaultSucBackString = @"";
        dataView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        dataView.delegate = self;
        dataView.backLabel.textColor = [UIColor whiteColor];
        dataView.tableView.backgroundColor = [UIColor colorWithRed:0/255.0 green:36/255.0 blue:58/255.0 alpha:1.0];
        dataView.selectID = selectID;
        dataView.dataList = dataList;
        self.dataTableView = dataView;
        [dataView release];
    }
    else
    {
        self.dataTableView.frame = CGRectMake(0, curY, 320, maxHeight);
    }
    [self.view addSubview:self.dataTableView];
    
    if (!self.bottomView) {
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - bottomHeight, 320, bottomHeight)];
        bottomView.backgroundColor = [UIColor clearColor];
        
        UIImage* bottomImage = [UIImage imageNamed:@"stockbar_content_bottom_back.png"];
        UIImageView* bottomImageView = [[UIImageView alloc] initWithImage:bottomImage];
        bottomImageView.frame = bottomView.bounds;
        bottomImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [bottomView addSubview:bottomImageView];
        [bottomImageView release];
        
        UIImage* btnImage = nil;
        UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect btnRect1 = CGRectMake(27, 5, 30, 40);
        btn1.frame = btnRect1;
        btnImage = [UIImage imageNamed:@"stockbar_content_bottom_support.png"];
        btn1.tag = 33331;
        [btn1 setImage:btnImage forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(supportClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:btn1];
        
        UIActivityIndicatorView* indicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator1.tag = 33332;
        CGRect indicatorRect1 = indicator1.bounds;
        indicatorRect1.origin.x = btnRect1.origin.x + btnRect1.size.width/2 - indicatorRect1.size.width/2;
        indicatorRect1.origin.y = btnRect1.origin.y + btnRect1.size.height/2 - indicatorRect1.size.height/2;
        indicator1.frame = indicatorRect1;
        indicator1.hidden = YES;
        [bottomView addSubview:indicator1];
        [indicator1 release];
        
        UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect btnRect2 = CGRectMake(107, 5, 30, 40);
        btn2.frame = btnRect2;
        btn2.tag = 33333;
        btnImage = [UIImage imageNamed:@"stockbar_content_bottom_oppose.png"];
        [btn2 setImage:btnImage forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(againstClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:btn2];
        
        UIActivityIndicatorView* indicator2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator2.tag = 33334;
        CGRect indicatorRect2 = indicator2.bounds;
        indicatorRect2.origin.x = btnRect2.origin.x + btnRect2.size.width/2 - indicatorRect2.size.width/2;
        indicatorRect2.origin.y = btnRect2.origin.y + btnRect2.size.height/2 - indicatorRect2.size.height/2;
        indicator2.frame = indicatorRect2;
        indicator2.hidden = YES;
        [bottomView addSubview:indicator2];
        [indicator2 release];
        
        UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame = CGRectMake(187, 5, 30, 40);
        btnImage = [UIImage imageNamed:@"stockbar_content_bottom_reply.png"];
        [btn3 setImage:btnImage forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(replyClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:btn3];
        
        UIButton* btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn4.frame = CGRectMake(267, 5, 30, 40);
        btnImage = [UIImage imageNamed:@"stockbar_content_bottom_newcreate.png"];
        [btn4 setImage:btnImage forState:UIControlStateNormal];
        [btn4 addTarget:self action:@selector(newClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:btn4];
    }
    else
    {
        self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height - bottomHeight, 320, bottomHeight);
    }
    [self.view addSubview:bottomView];
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
        [[StockBarPuller getInstance] startOneStockBarReplyListWithSender:self stockName:stockName bid:bid tid:tid count:countPerPage page:1 args:self.selectID dataList:self.dataList];
    }
    else
    {
        NSInteger state = [self.dataList loadedStateInfoWithIDList:self.selectID];
        [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO state:state];
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

-(void)supportClicked:(UIButton*)sender
{
    UIButton* Btn1 = (UIButton*)[bottomView viewWithTag:33331];
    UIActivityIndicatorView* Activator1 = (UIActivityIndicatorView*)[bottomView viewWithTag:33332];
    Btn1.hidden = YES;
    [Activator1 startAnimating];
    
    [[StockBarPuller getInstance] startSendStockSubjectWithSender:self stockName:stockName bid:bid tid:tid quotePid:nil title:nil content:@"回复一楼:\n我支持" args:nil userInfo:StockBar_SupportKey];
}

-(void)againstClicked:(UIButton*)sender
{
    UIButton* Btn2 = (UIButton*)[bottomView viewWithTag:33333];
    UIActivityIndicatorView* Activator2 = (UIActivityIndicatorView*)[bottomView viewWithTag:33334];
    Btn2.hidden = YES;
    [Activator2 startAnimating];
    [[StockBarPuller getInstance] startSendStockSubjectWithSender:self stockName:stockName bid:bid tid:tid quotePid:nil title:nil content:@"回复一楼:\n我反对" args:nil userInfo:StockBar_AgainstKey];
}

-(void)replyClicked:(UIButton*)sender
{
    EditBarSubjectViewController* editController = [[EditBarSubjectViewController alloc] initWithNibName:@"EditBarSubjectViewController" bundle:nil];
    editController.stockName = self.stockName;
    editController.stockNick = self.stockNick;
    editController.bid = self.bid;
    editController.tid = self.tid;
    [self.navigationController pushViewController:editController animated:YES];
    [editController release];
}

-(void)newClicked:(UIButton*)sender
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
        if ([stageNumber intValue]==Stage_Request_OneStockBarReplyList) {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSArray* array = [userInfo valueForKey:RequsetArray];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                curPage = [pageNumber intValue];
                if ([pageNumber intValue]<=1) {
                    [self.dataTableView scrollTop:NO];
                }
                if ([array count]>=countPerPage) {
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO state:LoadedState_Suc];
                }
                else {
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:YES state:LoadedState_Suc];
                }
            }
        }
        else if ([stageNumber intValue]==Stage_Request_SendStockSubject)
        {
            NSString* apiKey = (NSString*)[userInfo valueForKey:RequsetInfo];
            if (apiKey&&[apiKey isEqualToString:StockBar_SupportKey]) {
                UIButton* Btn1 = (UIButton*)[bottomView viewWithTag:33331];
                UIActivityIndicatorView* Activator1 = (UIActivityIndicatorView*)[bottomView viewWithTag:33332];
                Btn1.hidden = NO;
                [Activator1 stopAnimating];
            }
            else if(apiKey&&[apiKey isEqualToString:StockBar_AgainstKey])
            {
                UIButton* Btn2 = (UIButton*)[bottomView viewWithTag:33333];
                UIActivityIndicatorView* Activator2 = (UIActivityIndicatorView*)[bottomView viewWithTag:33334];
                Btn2.hidden = NO;
                [Activator2 stopAnimating];
            }
            [self startRefreshTable:YES];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"发布成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
}

-(void)StockBarObjectFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if([stageNumber intValue]==Stage_Request_OneStockBarReplyList)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID])
            {
                NSString* errorString = [userInfo valueForKey:RequsetErrorString];
                self.dataTableView.defaultErrBackString = errorString;
                if (errorString) {
                    
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO state:LoadedState_Err];
                }
                else {
                    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                    [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO state:LoadedState_Err];
                }
            }
        }
        else if ([stageNumber intValue]==Stage_Request_SendStockSubject)
        {
            NSString* apiKey = (NSString*)[userInfo valueForKey:RequsetInfo];
            if (apiKey&&[apiKey isEqualToString:StockBar_SupportKey]) {
                UIButton* Btn1 = (UIButton*)[bottomView viewWithTag:33331];
                UIActivityIndicatorView* Activator1 = (UIActivityIndicatorView*)[bottomView viewWithTag:33332];
                Btn1.hidden = NO;
                [Activator1 stopAnimating];
            }
            else if(apiKey&&[apiKey isEqualToString:StockBar_AgainstKey])
            {
                UIButton* Btn2 = (UIButton*)[bottomView viewWithTag:33333];
                UIActivityIndicatorView* Activator2 = (UIActivityIndicatorView*)[bottomView viewWithTag:33334];
                Btn2.hidden = NO;
                [Activator2 stopAnimating];
            }
            [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"发布出错了!" time:1.0 ignoreAddition:NO pView:self.dataTableView];
        }
    }
}

#pragma mark -
#pragma mark DataListTableView
-(UITableViewCell*)dataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    int rowNum = path.row;
    BarStockReplyCell* rtval = nil;
    NSString* userIdentifier = @"Identifier";
    rtval = (BarStockReplyCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[BarStockReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
    }
    NSString* contentStr = [object valueForKey:StockBar_OneReplyList_content];
    if (!contentStr) {
        contentStr = @"";
    }
    rtval.contentLabel.text = contentStr;
    NSString* dateString = [object valueForKey:StockBar_OneReplyList_time];
    if (!dateString) {
        dateString = @"";
    }
    rtval.dateLabel.text = dateString;
    NSString* userString = [object valueForKey:StockBar_OneReplyList_ip];
    userString = [MyTool IPStringWtihLastComponetHiden:userString];
    if (!userString) {
        userString = @"";
    }
    rtval.userLabel.text = userString;
    NSString* pidStr = [object valueForKey:StockBar_OneReplyList_pid];
    
    NSString* formatLevel = [NSString stringWithFormat:@"%@楼",pidStr];
    NSString* levelString = [pidStr intValue]==1?@"顶楼":formatLevel;
    if (!levelString) {
        levelString = @"--";
    }
    rtval.levelLabel.text = levelString;
    [rtval reloadData];

    return rtval;
}

-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    BarStockReplyCell* rtval = nil;
    NSString* userIdentifier = @"Identifier";
    rtval = (BarStockReplyCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[BarStockReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
    }
    rtval.contentLabel.text = [object valueForKey:StockBar_OneReplyList_content];
    
    return [rtval sizeThatFits:CGSizeZero].height;
}

-(void)dataListView:(DataListTableView*)view didSelectedAtIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    //    [view.tableView deselectRowAtIndexPath:path animated:YES];
    
}

-(void)dataListViewDidMoreClicked:(DataListTableView*)view
{
    [[StockBarPuller getInstance] startOneStockBarReplyListWithSender:self stockName:stockName bid:bid tid:tid count:countPerPage page:curPage+1 args:self.selectID dataList:self.dataList];;
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
