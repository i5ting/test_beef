//
//  WeiboCommentViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WeiboCommentViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "NewsObject.h"
#import "WeiboLoginManager.h"
#import "ComposeWeiboViewController.h"
#import "WeiboFuncPuller.h"
#import "LoginViewController.h"
#import "DataListTableView.h"
#import "CommentDataList.h"
#import "LKTipCenter.h"
#import "WeiboCommentCell.h"

@interface WeiboCommentViewController ()
@property(nonatomic,retain)DataListTableView* dataTableView;
@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)NSArray* selectID;
- (void)addToolbar;
-(void)initNotification;
-(void)initUI;
-(void)initData;
-(void)postFailedTip;
-(void)startRefreshTable;
@end

@implementation WeiboCommentViewController
@synthesize weiboObject;
@synthesize dataTableView,dataList,selectID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataList = [[CommentDataList alloc] init];
        selectID = [[NSArray alloc] initWithObjects:@"comment", nil];
        countPerPage = 20;
    }
    return self;
}

-(void)dealloc
{
    [weiboObject release];
    [dataTableView release];
    [dataList release];
    [selectID release];
    
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
    
    [self initNotification];
    [self addToolbar];
    [self initUI];
    [self initData];
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
           selector:@selector(CommonWeiboSucceed:) 
               name:CommonWeiboSucceedNotification 
             object:nil];
    [nc addObserver:self 
           selector:@selector(CommonWeiboFailed:) 
               name:CommonWeiboFailedNotification
             object:nil];
}

-(void)initUI
{
    if (!self.dataTableView) {
        int curY = 44;
        int maxHeight = self.view.bounds.size.height - curY;
        DataListTableView* dataView = [[DataListTableView alloc] initWithFrame:CGRectMake(0, curY, 320, maxHeight)];
        dataView.defaultSucBackString = @"";
        dataView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        dataView.delegate = self;
        dataView.tableView.backgroundColor = [UIColor whiteColor];
        dataView.selectID = selectID;
        dataView.dataList = dataList;
        [self.view addSubview:dataView];
        self.dataTableView = dataView;
        [dataView release];
    }
}

- (void)addToolbar
{
    MyCustomToolbar *topToolbar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    topToolbar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolbar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(98, 0, 125, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    titleLabel.text = @"评论微博";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolbar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 5, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:backBtn];
    
    UIButton* tempBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(245, 7, 60, 30)];
    [tempBtn1 setTitle:@"发表评论" forState:UIControlStateNormal];
    UIImage* btnImage = [UIImage imageNamed:@"toolbar_btn_bg.png"];
    [tempBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    tempBtn1.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [tempBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tempBtn1 addTarget:self action:@selector(commnetClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:tempBtn1];
    [tempBtn1 release];
}

-(void)initData
{
    [self startRefreshTable];
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
    NSString* idstr = [self.weiboObject valueForKey:WeiboObject_idstr];
    [[WeiboFuncPuller getInstance] startCommentListV2WeiboWithSender:self ID:idstr count:countPerPage page:1 max_id:nil args:self.selectID dataList:self.dataList];
}

-(void)cancel:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)commnetClicked:(UIButton*)sender
{
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    if (hasLogined) 
    {
        ComposeWeiboViewController* composeController = [[ComposeWeiboViewController alloc] initWithNibName:@"ComposeWeiboViewController" bundle:nil];
        composeController.type = ComposeType_comment;
        composeController.isSnap = NO;
        NSString* mid = [self.weiboObject valueForKey:WeiboObject_mid];
        composeController.mid = mid;
        
        [self.navigationController pushViewController:composeController animated:YES];
        [composeController release];
    }
    else
    {
        LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        
        [self.navigationController pushViewController:loginController animated:YES];
        [loginController release];
    }
}

#pragma mark -
#pragma mark networkCallback
-(void)CommonWeiboSucceed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
        NSArray* array = [userInfo valueForKey:RequsetArray];
        curPage = [pageNumber intValue];
        if ([pageNumber intValue]<=1) {
            [self.dataTableView scrollTop:NO];
        }
        if ([array count]<countPerPage) {
            [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:YES];
        }
        else
        {
            [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
        }
    }
    
}

-(void)CommonWeiboFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        [self postFailedTip];
        [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
    }
    
}

-(void)postFailedTip
{
    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
}

#pragma mark -
#pragma mark DataListTableView
-(UITableViewCell*)dataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    int rowNum = path.row;
    WeiboCommentCell* rtval = nil;
    NSString* userIdentifier = @"CommentContentIdentifier";
    rtval = (WeiboCommentCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[WeiboCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
    }
    NewsObject* oneObject = [self.dataList oneObjectWithIndex:rowNum IDList:self.selectID];
    NSString* contentStr = [oneObject valueForKey:WeiboCommentObject_text];
    NSDictionary* oneUser = (NSDictionary*)[oneObject valueForKey:WeiboCommentObject_user];
    NSString* userName = [oneUser objectForKey:WeiboUserObject_screen_name];
    rtval.titleString = userName;
    rtval.contentString = contentStr;
    
    NSString* createDateStr = (NSString*)[oneObject valueForKey:WeiboCommentObject_created_at];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss z yyyy";
    NSDate* newFormatDate = [formatter dateFromString:createDateStr];
    rtval.createDate = newFormatDate;
    
    [rtval reloadData];
    if (rowNum%2==0) {
        rtval.contentView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    }
    else
    {
        rtval.contentView.backgroundColor = [UIColor whiteColor];
    }
    return rtval;
}

-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    int rowNum = path.row;
    WeiboCommentCell* rtval = nil;
    NSString* userIdentifier = @"CommentContentIdentifier";
    rtval = (WeiboCommentCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[WeiboCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
    }
    NewsObject* oneObject = [self.dataList oneObjectWithIndex:rowNum IDList:self.selectID];
    NSString* contentStr = [oneObject valueForKey:WeiboCommentObject_text];
    NSDictionary* oneUser = (NSDictionary*)[oneObject valueForKey:WeiboCommentObject_user];
    NSString* userName = [oneUser objectForKey:WeiboUserObject_screen_name];
    rtval.titleString = userName;
    rtval.contentString = contentStr;
    
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
    NSString* idstr = [self.weiboObject valueForKey:WeiboObject_idstr];
    NewsObject* oneObject = [self.dataList lastObjectWithIDList:self.selectID];
    NSString* weiboID = [oneObject valueForKey:WeiboCommentObject_idstr];
    [[WeiboFuncPuller getInstance] startCommentListV2WeiboWithSender:self ID:idstr count:countPerPage page:curPage+1 max_id:weiboID args:self.selectID dataList:self.dataList];
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

@end
