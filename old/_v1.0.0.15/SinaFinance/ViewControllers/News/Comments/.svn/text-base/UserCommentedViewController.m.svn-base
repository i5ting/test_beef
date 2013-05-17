//
//  UserCommentedViewController.m
//  SinaNews
//
//  Created by shieh exbice on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserCommentedViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "NewsObject.h"
#import "DataListTableView.h"
#import "CommentDataList.h"
#import "LKTipCenter.h"
#import "CommentContentCell.h"
#import "CommentContentList.h"
#import "NewsFuncPuller.h"
#import "inputShowController.h"
#import "LoginViewController.h"
#import "WeiboFuncPuller.h"
#import "LKWebViewController.h"


@interface UserCommentedViewController()
@property(nonatomic,retain)NSMutableArray* expandedIndexPath;
@property(nonatomic,retain)DataListTableView* dataTableView;
@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)NSArray* selectID;
@property(nonatomic,retain)CommentContentList* commentContentList;
@property(nonatomic,retain)UIView* bottomView;
@property (nonatomic, retain)inputShowController* inputController;
@property(nonatomic,retain)NSDate* lastDate;

- (void)addToolbar;
-(void)initNotification;
-(void)initUI;
-(void)initData;
-(void)postFailedTip;
-(void)startRefreshTable;
@end

@implementation UserCommentedViewController
{
    BOOL bInited;
    NSDate* lastDate;
    NSTimeInterval pastedTimeInterval;
    BOOL curViewShowed;
    BOOL curExited;
}

@synthesize commentContentList=mCommentContentList;
@synthesize dataTableView,dataList,selectID;
@synthesize expandedIndexPath;
@synthesize newsObject=mNewsObject;
@synthesize commentID;
@synthesize bottomView;
@synthesize inputController;
@synthesize lastDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mCommentContentList = [[CommentContentList alloc] init];
        countPerPage = 20;
        selectID = [[NSArray alloc] initWithObjects:@"newscomment", nil];
        dataList = [[CommentDataList alloc] init];
    }
    return self;
}

- (id)initWithCommentID:(NSString*)comID
{
    if((self = [super init])){
        commentID = [[NSString alloc] initWithFormat:@"%@", comID];
        countPerPage = 20;
    }
    return self;
}

-(void)dealloc
{
    [mCommentContentList release];
    [expandedIndexPath release];
    [mNewsObject release];
    [commentID release];
    [dataTableView release];
    [dataList release];
    [selectID release];
    [bottomView release];
    [inputController release];
    [lastDate release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    curViewShowed = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    curViewShowed = NO;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithRed:3/255.0 green:30/255.0 blue:54/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:237.0/255];
  
    if (!bInited) {
        bInited = YES;
        [self initNotification];
    }
    [self addToolbar];
    [self initUI];
    [self initData];
}

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self 
           selector:@selector(CommentContentAdded:) 
               name:CommonNewsSucceedNotification 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(CommentContentFailed:) 
               name:CommonNewsFailedNotification
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(CommentContentAdded:) 
               name:CommonWeiboSucceedNotification 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(CommentContentFailed:) 
               name:CommonWeiboFailedNotification
             object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(CommentContentAdded:) 
                                                 name:@"NewsCommentPublishSucceed"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(CommentContentFailed:) 
                                                 name:@"NewsCommentPublishFailed"
                                               object:nil];
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

-(void)initUI
{
    int curY = 44;
    int bottomHeight = 39;
    int maxHeight = self.view.bounds.size.height - curY - bottomHeight;
    if (!self.dataTableView) {
        DataListTableView* dataView = [[DataListTableView alloc] initWithFrame:CGRectMake(0, curY, 320, maxHeight)];
        dataView.defaultSucBackString = @"";
        dataView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        dataView.delegate = self;
        dataView.tableView.backgroundColor = [UIColor whiteColor];
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
    curY += maxHeight;
    
    CGRect bottomRect = CGRectMake(0, curY, 320, bottomHeight);
    if (!self.bottomView) {
        bottomView = [[UIView alloc] initWithFrame:bottomRect];
        bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        UIImage* backImage = [UIImage imageNamed:@"news_content_comment_bottom_back.png"];
        UIImageView* backImageView = [[UIImageView alloc] initWithImage:backImage];
        backImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        backImageView.frame = bottomView.bounds;
        [self.bottomView addSubview:backImageView];
        [backImageView release];
        
        UIImage* inputImage = [UIImage imageNamed:@"news_content_comment_bottom_input.png"];
        UIButton* inputBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [inputBtn setImage:inputImage forState:UIControlStateNormal];
        [inputBtn addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
        inputBtn.frame = CGRectMake(10, bottomHeight/2 - 31/2, 230, 31);
        [self.bottomView addSubview:inputBtn];
        
        UIImage* sendImage = [UIImage imageNamed:@"news_content_comment_bottom_btn.png"];
        UIButton* sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setImage:sendImage forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(bottomClicked:) forControlEvents:UIControlEventTouchUpInside];
        sendBtn.frame = CGRectMake(250, bottomHeight/2 - 33/2, 61, 33);
        [self.bottomView addSubview:sendBtn];
    }
    else {
        bottomView.frame = bottomRect;
    }
    [self.view addSubview:self.bottomView];
    [self startRefreshDataTimer];
}

-(void)startRefreshDataTimer
{
    self.lastDate = [NSDate date];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshDataTimer) object:nil];
    [self performSelector:@selector(refreshDataTimer) withObject:nil afterDelay:1.0];
}

-(void)refreshDataTimer
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshDataTimer) object:nil];
    if (!curExited) {
        [self performSelector:@selector(refreshDataTimer) withObject:nil afterDelay:1.0];
        NSTimeInterval timelen = [[NSDate date] timeIntervalSinceDate:self.lastDate];
        if (timelen>1.0) {
            pastedTimeInterval += timelen;
        }
        else {
            pastedTimeInterval += 1.0;
        }
        self.lastDate = [NSDate date];
        NSTimeInterval refreshInterval = 5.0;
        if (refreshInterval<=pastedTimeInterval&&refreshInterval>0.0&&curViewShowed) {
            pastedTimeInterval = 0.0;
            
            [self startAutoRefresh];
        }
    }
}

-(void)startAutoRefresh
{
    NSArray* array = [self.dataTableView.tableView visibleCells];
    for (CommentContentCell* cell in array) {
        if ([cell isKindOfClass:[CommentContentCell class]]) {
            [cell reloadTimeString];
        }
    }
}

- (void)addToolbar
{
    MyCustomToolbar *topToolbar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    [self.view addSubview:topToolbar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(60, 0, 200, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"财经评论";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolbar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:backBtn];
}

-(void)initData
{
    [self startRefreshTable];
}

-(void)cancel:(UIButton*)sender
{
    curExited = YES;
    if(inputController.isStarted){
        [inputController stopInput];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)startRefreshTable
{
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
    
    [self.dataTableView startLoadingUI];
    
    NSString* totalString = commentID;//[self.newsObject valueForKey:NEWSCONTENT_commentid];
    NSArray* totalList = [totalString componentsSeparatedByString:@":"];
    if ([totalList count]==2) {
        NSString* channel = [totalList objectAtIndex:0];
        NSString* newsID = [totalList objectAtIndex:1];
        [[NewsFuncPuller getInstance]startCommentContentWithSender:self page:1 count:countPerPage withChannel:channel newsID:newsID args:self.selectID dataList:nil bInback:NO];
    }
    else
    {
        [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
    }
}

-(void)CommentContentAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* object = [userInfo valueForKey:RequsetSender];
    if ([object isKindOfClass:[NSNumber class]]&&[object intValue]==(int)self)
    {
        NSArray* indexArray = [userInfo objectForKey:RequsetArgs];
        NSArray* objectArray = [userInfo objectForKey:RequsetArray];
        NSNumber* page = [userInfo objectForKey:RequsetPage];
        NSNumber* stageNumber = [userInfo objectForKey:RequsetStage];
        
        if ([stageNumber intValue]==Stage_Request_CommentContent) {
            CommentContentList* commentList = (CommentContentList*)[userInfo objectForKey:RequsetExtra];
            curPage = [page intValue];
            if (commentList) {
                if ([page intValue]<=1) {
                    [self.commentContentList refreshFromAnotherCommentContentList:commentList];
                    [self.dataList refreshCommnetContents:objectArray IDList:self.selectID];
                }
                else
                {
                    [self.commentContentList addFromAnotherCommentContentList:commentList];
                    [self.dataList addCommnetContents:objectArray IDList:self.selectID];
                }
                if ([objectArray count]==countPerPage) {
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
                }
                else
                {
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:YES];
                }
            }
            else
            {
                [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
            }
        }
        else if ([stageNumber intValue]==Stage_Request_CommentNews){
            [self startRefreshTable];
        }
        else if ([stageNumber intValue]==Stage_Request_V2UserInfoWeibo){
            NSString* content = [userInfo valueForKey:RequsetInfo];
            NSArray* totalList = [commentID componentsSeparatedByString:@":"];
            if ([totalList count]==2) {
                NSString* channel = [totalList objectAtIndex:0];
                NSString* newsID = [totalList objectAtIndex:1];
                [[NewsFuncPuller getInstance] startCommentNewsWithSender:self channelid:channel newsid:newsID content:content];
            }
        }
        
    }
}

-(void)CommentContentFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber isKindOfClass:[NSNumber class]]&&[senderNumber intValue]==(int)self)
    {
        NSNumber* stageNumber = [userInfo objectForKey:RequsetStage];
        
        if ([stageNumber intValue]==Stage_Request_CommentContent)
        {
            [self postFailedTip];
            [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
        }
        else if ([stageNumber intValue]==Stage_Request_CommentNews){
            ;
        }
        else if ([stageNumber intValue]==Stage_Request_V2UserInfoWeibo){
            NSString* topString = @"发表评论失败了";
            [[LKTipCenter defaultCenter] postTopTipWithMessage:topString time:2.0 color:nil];
            NSNumber* errorCode = [userInfo valueForKey:RequsetError];
            if ([errorCode intValue]==RequestError_User_Not_Exists) {
                [self startOpenMindedWeibo];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {  
    if(alertView.tag==111878)
    {
        if (buttonIndex==1) {
            [self realOpenMindedWeibo];
        }
    }
}  

-(void)startOpenMindedWeibo
{
    UIAlertView* anAlert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"您的帐号未开通微博功能,是否现在开通?", nil)
                                                      message: @"\n" 
                                                     delegate: self
                                            cancelButtonTitle: NSLocalizedString(@"否",nil)
                                            otherButtonTitles: NSLocalizedString(@"是",nil), nil];
    anAlert.tag = 111878;
    [anAlert show];
    [anAlert release];
}

-(void)realOpenMindedWeibo
{
    NSURL* url = [NSURL URLWithString:@"http://weibo.com/signup/full_info.php?nonick=1&lang=zh-cn"];
    LKWebViewController *webVC = [[LKWebViewController alloc] initWithNibName:@"LKWebViewController" bundle:nil url:url];
    webVC.titleString = @"开通微博";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    [webVC release];
}

-(void)postFailedTip
{
    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
}

-(void)bottomClicked:(UIButton*)sender
{
    if([[WeiboLoginManager getInstance] hasLogined]){
        if(inputController == nil){
            inputController = [[inputShowController alloc] init];
            inputController.parentView = self.view;
            inputController.delegate = self;
        }
        
        [inputController startInput];
    }
    else{
        LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginController animated:YES];
    }
}

-(void)backgroundBtnClicked:(UIButton*)sender
{
    [self.inputController stopInput];
}

-(void)controller:(inputShowController*)controller text:(NSString*)content
{
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    if (!hasLogined) {
        LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        
        [self.navigationController pushViewController:loginController animated:YES];
        [loginController release];
    }
    else
    {
        NSString* userId = [[WeiboLoginManager getInstance] loginedID];
        [[WeiboFuncPuller getInstance] startUserInfoWeiboWithSender:self uid:userId username:nil info:content];
    }
}

-(void)expandClickedWithCell:(CommentContentCell*)cell
{
    if (!expandedIndexPath) {
        expandedIndexPath = [[NSMutableArray alloc] initWithCapacity:0];
    }
    NSIndexPath* indexPath = [self.dataTableView.tableView indexPathForCell:cell];
    [expandedIndexPath addObject:indexPath];
    NSArray* indexPathArray = [NSArray arrayWithObject:indexPath];
    [self.dataTableView.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -
#pragma mark DataListTableView
-(UITableViewCell*)dataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    int rowNum = path.row;
    CommentContentCell* rtval = nil;
    NSString* userIdentifier = @"CommentContentIdentifier";
    rtval = (CommentContentCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[CommentContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
        rtval.delegate = self;
    }
    rtval.expandLevel = NO;
    rtval.data = object;
    if (expandedIndexPath&&[expandedIndexPath count]>0) {
        for (NSIndexPath* expandedPath in expandedIndexPath) {
            int expandedRow = expandedPath.row;
            if (expandedRow==rowNum) {
                rtval.expandLevel = YES;
                break;
            }
        }
    }
    rtval.commentLevels = [self.commentContentList contentObjectsWithIndex:rowNum];
    [rtval reloadData];
    return rtval;
}

-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    int rowNum = path.row;
    CommentContentCell* rtval = nil;
    NSString* userIdentifier = @"CommentContentIdentifier";
    rtval = (CommentContentCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[CommentContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
    }
    rtval.expandLevel = NO;
    if (expandedIndexPath&&[expandedIndexPath count]>0) {
        for (NSIndexPath* expandedPath in expandedIndexPath) {
            int expandedRow = expandedPath.row;
            if (expandedRow==rowNum) {
                rtval.expandLevel = YES;
                break;
            }
        }
    }
    rtval.commentLevels = [self.commentContentList contentObjectsWithIndex:rowNum];
    [rtval reloadData];
    CGSize size = [rtval sizeThatFits:CGSizeZero];
    
    return size.height;
}

-(void)dataListView:(DataListTableView*)view didSelectedAtIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    //    [view.tableView deselectRowAtIndexPath:path animated:YES];
    
}

-(void)dataListViewDidMoreClicked:(DataListTableView*)view
{
    NSString* totalString = commentID;//[self.newsObject valueForKey:NEWSCONTENT_commentid];
    NSArray* totalList = [totalString componentsSeparatedByString:@":"];
    if ([totalList count]==2) {
        NSString* channel = [totalList objectAtIndex:0];
        NSString* newsID = [totalList objectAtIndex:1];
        [[NewsFuncPuller getInstance]startCommentContentWithSender:self page:curPage+1 count:countPerPage withChannel:channel newsID:newsID args:self.selectID dataList:nil bInback:NO];
    }
    else
    {
        [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
    }
}
-(void)dataListViewDidRefreshTriggered:(DataListTableView*)view
{
    [self startRefreshTable];
}

-(PageTableViewCell*)dataListView:(DataListTableView*)view PageCellStyleIdentifier:(NSString*)identifier
{
    PageTableViewCell* rtval = [[[PageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    [rtval setTipString:@"更多..." forType:PageCellType_Normal];
    [rtval setTipColor:[UIColor blackColor] forType:PageCellType_Normal];
    [rtval setTipColor:[UIColor blackColor] forType:PageCellType_Ending];
    return rtval;
}

-(void)dataListViewWillBeginDragging:(DataListTableView*)view
{
    [self.inputController stopInput];
}

@end
