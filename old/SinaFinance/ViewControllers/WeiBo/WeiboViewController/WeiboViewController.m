//
//  WeiboViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WeiboViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "BCMultiTabBar.h"
#import "DataListTableView.h"
#import "gDefines.h"
#import "WeiboTableViewCell.h"
#import "WeiboKeyDefine.h"
#import "UrlParserController.h"
#import "LKWebViewController.h"
#import "NormalImageViewController.h"
#import "WeiboLoginManager.h"
#import "WeiboCommentViewController.h"
#import "LoginViewController.h"
#import "ComposeWeiboViewController.h"
#import "WeiboFuncPuller.h"
#import "JSONKit.h"
#import "WeiboConfigViewController.h"
#import "LKTipCenter.h"
#import "ProjectLogUploader.h"
#import "AppDelegate.h"
#import "MyTabBarController.h"
#import "NewsContentViewController2.h"

#define DefaultGroupKey @"DefaultGroupKey"
#define CustomGroupKey @"CustomGroupKey"
#define ReplacedIDKey @"ReplacedIDKey"

enum SelectedIDIndex
{
    SelectedIDIndex_Mode = 0,
    SelectedIDIndex_GroupIDStr,
    SelectedIDIndex_GroupName
};

@interface WeiboViewController ()
@property(nonatomic,retain)BCMultiTabBar* curMultiTabBar;
@property(nonatomic,retain)DataListTableView* dataTableView;
@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)NSMutableArray* selectID;
@property(nonatomic,retain)CommentDataList* groupList;
@property(nonatomic,retain)NSArray* groupID;
@property(nonatomic,retain)CommentDataList* customGroupList;
@property(nonatomic,retain)NSArray* customGroupID;
@property(nonatomic,retain)NSArray* UrlArray;
@property(nonatomic,retain)UIView* errorView;
@property(nonatomic,retain)NSDate* lastDate;

-(void)initNavBar;
-(void)initBarData;
-(void)initUI;
//-(NSArray*)loadCustomGroup;
-(void)initNotification;
-(BOOL)checkRefreshByDate;
-(void)startRefreshTableNoForce;
-(void)startRefreshTableWithForce;
-(void)startRefreshTable:(BOOL)bForce;
-(void)pushComposeViewController:(NSInteger)type object:(NewsObject*)object;
-(void)checkWeiboUrl:(NSString*)urlString;
-(NSString*)curGroupValueWithKey:(NSString*)oneKey;
-(NSArray*)defaultWeiboGroupNameArray;
@end

@implementation WeiboViewController
{
    NSInteger curIndex;
    NSDate* lastDate;
    NSTimeInterval pastedTimeInterval;
    BOOL curViewShowed;
    BOOL curExited;
}
@synthesize curMultiTabBar,dataTableView,dataList,selectID;
@synthesize UrlArray;
@synthesize groupID,groupList;
@synthesize customGroupList,customGroupID;
@synthesize errorView;
@synthesize lastDate;

-(void)showNewContent{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"push_url"]) {
        return;
    }
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:YES];
    
    //    #http://t.cn/zlQgn8h
    NSString *urlStr = [NSString stringWithFormat:@"http://t.cn/%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"push_url"]];
    //    NSString* urlStr = @"http://finance.sina.com.cn/stock/quanshang/zyzg/20121018/144813408682.shtml";
    NSString* comentCount = nil;
    NewsContentViewController2 *newsContent = [[NewsContentViewController2 alloc] initWithNewsURL3:urlStr];
    newsContent.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsContent animated:YES];
    [newsContent release];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"push_url"];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"is_push_back"];
}


-(void)showTixingContent:(NSString *)symbol{
    if (symbol) {
        NSString* stockType = nil;
        NSString* stockSymbol = nil;
        if ([symbol hasPrefix:@"hk"]) {
            stockType = @"hk";
            stockSymbol = [symbol substringFromIndex:2];
        }
        else if([symbol hasPrefix:@"us"])
        {
            stockType = @"us";
            stockSymbol = [symbol substringFromIndex:2];
        }
        else if([symbol hasPrefix:@"sz"]||[symbol hasPrefix:@"sh"])
        {
            stockType = @"cn";
            stockSymbol = symbol;
        }
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        
        [tabBarController setTabBarHiden:NO];
        //        [tabBarController tabBar:self.tabBarController  didSelectTabAtIndex:4 byBtn:YES];
        //        [tabBarView setCurIndex:0];
        //
        
        BOOL curTabSelected = YES;
        if (curTabSelected) {
            [tabBarController setTabBarHiden:YES];
        }
        SingleStockViewController* singleViewController = [[SingleStockViewController alloc] init];
        singleViewController.stockSymbol = stockSymbol;
        singleViewController.stockType = stockType;
        if (curTabSelected) {
            singleViewController.hidesBottomBarWhenPushed = YES;
        }
        
        [self.navigationController pushViewController:singleViewController animated:NO];
        [singleViewController release];
        
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"微博";
        self.tabBarItem.image = [UIImage imageNamed:@"weibo_icon.png"];
        dataList = [[CommentDataList alloc] init];
        dataList.dataTableName = @"WeiboList";
        groupList = [[CommentDataList alloc] init];
        groupList.dataTableName = @"WeiboGroupList";
        groupID = [[NSArray alloc] initWithObjects:@"group", nil];
        customGroupList = [[CommentDataList alloc] initWithFileName:@"customweibo.json"];
        customGroupID = [[NSArray alloc] initWithObjects:@"customweibo", nil];
        oldGroupColumn = -1;
        countPerPage = 20;
    }
    return self;
}

-(void)dealloc
{
    [curMultiTabBar release];
    [dataTableView release];
    [dataList release];
    [UrlArray release];
    [groupList release];
    [groupID release];
    [customGroupList release];
    [customGroupID release];
    [errorView release];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:NO];
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self initNavBar];
    [self initBarData];
    [self initNotification];
    NSInteger groupCount = [self.groupList contentsCountWithIDList:self.groupID];
    if (groupCount>0) {
        [self initUI];
    }
}

-(void)initNotification
{
    if (!bInitedNotify) {
        bInitedNotify = YES;
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self 
               selector:@selector(CommonWeiboSucceed:) 
                   name:CommonWeiboSucceedNotification 
                 object:nil];
        [nc addObserver:self 
               selector:@selector(CommonWeiboFailed:) 
                   name:CommonWeiboFailedNotification
                 object:nil];
        [nc addObserver:self 
               selector:@selector(LogoutSuccessed:) 
                   name:LogoutSuccessedNotification
                 object:nil];
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

//-(NSArray*)loadCustomGroup
//{
//    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
//    bundlePath = [bundlePath stringByAppendingPathComponent:@"customweibo.json"];
//    NSString* customJson = [NSString stringWithContentsOfFile:bundlePath encoding:NSUTF8StringEncoding error:nil];
//    NSArray* customArray = [customJson objectFromJSONString];
//    NSMutableArray* rtval = nil;
//    for (NSDictionary* dict in customArray) {
//        if (!rtval) {
//            rtval = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
//        }
//        NewsObject* oneObject = [[NewsObject alloc] initWithJsonDictionary:dict];
//        [rtval addObject:oneObject];
//        [oneObject release];
//    }
//    return rtval;
//}

-(void)initNavBar
{
    MyCustomToolbar *topToolBar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    [self.view addSubview:topToolBar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(98, 0, 125, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    titleLabel.text = @"财经微博速递";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolBar addSubview:titleLabel];
    
    UIImageView *logo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sina_logo.png"]] autorelease];
    logo.frame = CGRectMake(15, 8, 38, 27);
    logo.contentMode = UIViewContentModeScaleToFill;
    [topToolBar addSubview:logo];//composeClicked:
    
    UIButton *writeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    writeBtn.frame = CGRectMake(280, 0, 30, 44);
    [writeBtn setImage:[UIImage imageNamed:@"weibo_writing_btn.png"] forState:UIControlStateNormal];
    [writeBtn addTarget:self action:@selector(composeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:writeBtn];
    
    UIButton* tempBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 30, 44)];
    UIImage* btnImage = [UIImage imageNamed:@"weibo_config_btn.png"];
    [tempBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [tempBtn1 addTarget:self action:@selector(configClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:tempBtn1];
    [tempBtn1 release];
}

-(void)initBarData
{
    NSInteger groupCount = [self.groupList contentsCountWithIDList:self.groupID];
    if (groupCount==0) {
        [[WeiboFuncPuller getInstance] startDefaultV2GroupListWithSender:self args:self.groupID dataList:self.groupList];
    }
}

-(void)initUI
{
    CGRect multiRect = CGRectZero;
    float multiBarHeight = 40.0;
    CGRect mainRect = self.view.bounds;
    multiRect = CGRectMake(0, 44, mainRect.size.width, multiBarHeight);
    self.errorView.hidden = YES;
    if (!initedUI) {
        initedUI = YES;
        if (!self.curMultiTabBar) {
            NSArray* multiBarHeightArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:multiBarHeight], nil];
            BCMultiTabBar* newMultiTabBar = [[BCMultiTabBar alloc] initWithFrame:multiRect heights:multiBarHeightArray];
            newMultiTabBar.delegate = self;
            newMultiTabBar.selectedMovement = MovementStyle_Free;
            for (int i=0; i<[newMultiTabBar.tabBarArray count]; i++) {
                BCTabBar* oneTabBar = [newMultiTabBar.tabBarArray objectAtIndex:i];
                if (i==0) {
                    oneTabBar.selectedAlignment = AlignmentStyle_Center;
                    oneTabBar.showedMaxItem = 7;
                    oneTabBar.arrowImage = [UIImage imageNamed:@"weibo_tab_btn_selected.png"];
                    UIImage* columnBack = [UIImage imageNamed:@"weibo_tab_back.png"];
                    columnBack = [columnBack stretchableImageWithLeftCapWidth:1.0 topCapHeight:15.0];
                    oneTabBar.backgroundImage = columnBack;
                    oneTabBar.maxTabWidth = 40;
                    oneTabBar.arrowCoverScroll = NO;
                    oneTabBar.ArrowBackScrollAnimate = NO;
                    oneTabBar.leftArrowImage = [UIImage imageNamed:@"weibo_tab_left.png"];
                    oneTabBar.rightArrowImage = [UIImage imageNamed:@"weibo_tab_right.png"];
                    oneTabBar.leftRightArrowWidth = 7;
                }
            }
            self.curMultiTabBar = newMultiTabBar;
            [newMultiTabBar release];
        }
        else
        {
            multiRect = self.curMultiTabBar.frame;
        }
        [self.view addSubview:self.curMultiTabBar];
        
        if (!self.dataTableView) {
            int curY = multiRect.origin.y + multiRect.size.height;
            int maxHeight = self.view.bounds.size.height - curY;
            DataListTableView* dataView = [[DataListTableView alloc] initWithFrame:CGRectMake(0, curY, 320, maxHeight)];
            dataView.defaultSucBackString = @"";
            dataView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            dataView.delegate = self;
            dataView.tableView.backgroundColor = [UIColor clearColor];
            self.dataTableView = dataView;
            [dataView release];
        }
        [self.view addSubview:self.dataTableView];
    }
    else
    {
        [self.view addSubview:self.curMultiTabBar];
        int curY = multiRect.origin.y + multiRect.size.height;
        int maxHeight = self.view.bounds.size.height - curY;
        self.dataTableView.frame = CGRectMake(0, curY, 320, maxHeight);
        [self.view addSubview:self.dataTableView];
    }
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
    for (FullWeiboTableViewCell* cell in array) {
        if ([cell isKindOfClass:[FullWeiboTableViewCell class]]) {
            [cell reloadTimeString];
        }
    }
}

-(void)addLoadingFailedView
{
    CGRect mainRect = self.view.bounds;
    mainRect.origin.y = 44;
    mainRect.size.height -= 44 + 50;
    if (!errorView) {
        errorView = [[UIView alloc] initWithFrame:mainRect];
        errorView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        errorView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:errorView];
        UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text = @"您的网络异常,请检查网络后重试!";
        [tipLabel sizeToFit];
        [errorView addSubview:tipLabel];
        
        UIButton* retryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        retryBtn.tag = 13330;
        [retryBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        UIImage* btnImage = [UIImage imageNamed:@"toolbar_btn_bg.png"];
        [retryBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        retryBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
        [retryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [retryBtn addTarget:self action:@selector(reloadUIClicked:) forControlEvents:UIControlEventTouchUpInside];
        [errorView addSubview:retryBtn];
        
        UIActivityIndicatorView* retryIndicatior = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        retryIndicatior.tag = 13331;
        [errorView addSubview:retryIndicatior];
        
        CGRect tipRect = tipLabel.frame;
        tipRect.origin.x = mainRect.origin.x + mainRect.size.width/2 - tipRect.size.width/2;
        tipRect.origin.y = 150;
        tipLabel.frame = tipRect;
        
        CGRect retryRect = retryBtn.frame;
        retryRect.origin.x = mainRect.origin.x + mainRect.size.width/2 - retryRect.size.width/2;
        retryRect.origin.y = tipRect.origin.y + tipRect.size.height + 15;
        retryBtn.frame = retryRect;
        
        CGRect indicataorRect = retryIndicatior.frame;
        indicataorRect.origin.x = mainRect.origin.x + mainRect.size.width/2 - indicataorRect.size.width/2;
        indicataorRect.origin.y = tipRect.origin.y + tipRect.size.height + 10;
        retryIndicatior.frame = indicataorRect;
        
        [retryBtn release];
        
        [tipLabel release];
        [retryIndicatior release];
    }
    else
    {
        errorView.hidden = NO;
    }
}

-(void)reloadUIClicked:(UIButton*)sender
{
    sender.hidden = YES;
    UIActivityIndicatorView* retryIndicator = (UIActivityIndicatorView*)[self.errorView viewWithTag:13331];
    [retryIndicator startAnimating];
    [self initBarData];
}

-(void)restoreErrorView
{
    [self addLoadingFailedView];
    UIActivityIndicatorView* retryIndicator = (UIActivityIndicatorView*)[self.errorView viewWithTag:13331];
    [retryIndicator stopAnimating];
    UIButton* retryBtn = (UIButton*)[self.errorView viewWithTag:13330];
    retryBtn.hidden = NO;
}

-(void)exit
{
    curExited = YES;
}

#pragma mark -
#pragma mark networkCallback
-(void)CommonWeiboSucceed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_DefalutV2_GroupListWeibo) {
            [self.groupList reloadShowedDataWithIDList:self.groupID];
            [self initUI];
        }
        else if([stageNumber intValue]==Stage_Request_DefalutV2_ContentListWeibo)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSArray* array = [userInfo valueForKey:RequsetArray];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
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
        else if([stageNumber intValue]==Stage_RequestV2_ObtainGroupListWeibo)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID])
            {
                NSArray* array = [userInfo valueForKey:RequsetArray];
                NSString* oneName = [self.selectID objectAtIndex:SelectedIDIndex_GroupName];
                BOOL hasFound = NO;
                for (NewsObject* oneObject in array) {
                    NSString* groupidstr = [oneObject valueForKey:WeiboGroup_idstr];
                    NSString* groupname = [oneObject valueForKey:WeiboGroup_name];
                    if ([groupname isEqualToString:oneName]) {
                        [self.selectID replaceObjectAtIndex:SelectedIDIndex_GroupIDStr withObject:groupidstr];
                        hasFound = YES;
                        NSArray* oldCustomGroups = [self.customGroupList contentsWithIDList:self.customGroupID];
                        NSMutableArray* newCustomGroups = [[NSMutableArray alloc] initWithCapacity:0];
                        BOOL hasAdded = NO;
                        for (NewsObject* oldObject in oldCustomGroups) {
                            NSString* oldgroupidstr = [oldObject valueForKey:WeiboGroup_idstr];
                            NSString* oldgroupname = [oldObject valueForKey:WeiboGroup_name];
                            if ([oldgroupname isEqualToString:groupname]) {
                                [newCustomGroups addObject:oneObject];
                                hasAdded = YES;
                            }
                            else
                            {
                                [newCustomGroups addObject:oldObject];
                            }
                        }
                        if (!hasAdded) {
                            [newCustomGroups addObject:oneObject];
                        }
                        [self.customGroupList refreshCommnetContents:newCustomGroups IDList:self.customGroupID];
                        [newCustomGroups release];
                        
                        break;
                    }
                }
                NSString* gID = [self.selectID objectAtIndex:SelectedIDIndex_GroupIDStr];
                if ([gID isEqualToString:ReplacedIDKey]) {
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
                }
                else
                {
                    [[WeiboFuncPuller getInstance] startV2ObtainWithSender:self groupID:gID count:countPerPage page:1 max_id:nil lastID:nil args:self.selectID weiboList:self.dataList];
                }
                
            }
        }
        else if([stageNumber intValue]==Stage_Request_V2ObtainWeibo)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSArray* array = [userInfo valueForKey:RequsetArray];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
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
        else if([stageNumber intValue]==Stage_Request_V2UserInfoWeibo)
        {
            NSString* weiboID = [userInfo valueForKey:RequsetInfo];
            [[WeiboFuncPuller getInstance] startFavariteWeiboV2WithID:weiboID];
        }
    }
    
}

-(void)CommonWeiboFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_DefalutV2_GroupListWeibo) {
            [self.groupList reloadShowedDataWithIDList:self.groupID];
            NSArray* contents = [self.groupList contentsWithIDList:self.groupID];
            if (contents) {
                [self initUI];
            }
            else
            {
                [self restoreErrorView];
            }
        }
        else if([stageNumber intValue]==Stage_Request_DefalutV2_ContentListWeibo)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID])
            {
                [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
            }
        }
        else if([stageNumber intValue]==Stage_RequestV2_ObtainGroupListWeibo)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID])
            {
                NSNumber* errorNumber = [userInfo objectForKey:RequsetError];
                if ([errorNumber intValue]==RequestError_Account_Not_Open)
                {
                    [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
                }
                else {
                    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                    [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
                }
            }
        }
        else if([stageNumber intValue]==Stage_Request_V2ObtainWeibo)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID])
            {
                [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
            }
        }
        else if([stageNumber intValue]==Stage_Request_V2UserInfoWeibo)
        {
            NSString* weiboID = [userInfo valueForKey:RequsetInfo];
            NSNumber* errorCode = [userInfo valueForKey:RequsetError];
            NSString* topString = @"收藏失败了";
            [[LKTipCenter defaultCenter] postTopTipWithMessage:topString time:2.0 color:nil];
            if ([errorCode intValue]==RequestError_User_Not_Exists) {
                [self startOpenMindedWeibo];
            }
        }
    }
}

-(void)LogoutSuccessed:(NSNotification*)notify
{
    if (self.selectID&&[self.selectID count]>0) {
        NSString* mode = [self.selectID objectAtIndex:SelectedIDIndex_Mode];
        if ([mode isEqualToString:CustomGroupKey]) {
            [self.curMultiTabBar reloadData];
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

#pragma mark -
#pragma mark function
-(NSString*)curGroupValueWithKey:(NSString*)oneKey
{
    BCTabBar* onetabBar = [self.curMultiTabBar.tabBarArray objectAtIndex:0];
    NSInteger selected = [onetabBar selectedColumn];
    NewsObject* oneObject = [self.groupList oneObjectWithIndex:selected IDList:self.groupID];
    return [oneObject valueForKey:oneKey];
}

-(NSArray*)defaultWeiboGroupNameArray
{
    NSMutableArray* rtval = nil;
    NSArray* subNames = [self.customGroupList subCommentNamelistAtRowColumns:nil];
    int subCount = [subNames count];
    for (int i=0; i<subCount; i++) {
        NSArray* codeArray = [self.customGroupList curCommentAPICodeAtRowColumns:[NSArray arrayWithObject:[NSNumber numberWithInt:i]]];
        if (!rtval) {
            rtval = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        }
        [rtval addObject:[codeArray objectAtIndex:4]];
    }
    return rtval;
}

#pragma mark -
#pragma mark multiTabBar
-(NSArray*)multiTabBar:(BCMultiTabBar*)multiTabBar tabsForIndex:(NSIndexPath *)index
{
    NSMutableArray* rtval = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    NSArray* tempArray = [self.groupList contentsWithIDList:self.groupID];
    NSArray* customArray = [self.customGroupList subCommentNamelistAtRowColumns:nil];
    if (index.row==0) {
        if (tempArray) {
            int tempCount = [tempArray count];
            int customCount = [customArray count];
            for(int i=0;i<tempCount+customCount;i++) {
                BCTab* oneTab = [[BCTab alloc] init];
                
                if (i<[tempArray count]) {
                    NewsObject* oneObject = nil;
                    oneObject = [tempArray objectAtIndex:i];
                    NSString* name = [oneObject valueForKey:WeiboDefaultV2Group_name];
                    oneTab.nameLabel.text = name;
                }
                else
                {
                    NSString* name = [customArray objectAtIndex:i-tempCount];
                    oneTab.nameLabel.text = name;
                }
                
                oneTab.nameLabel.font = [UIFont systemFontOfSize:14.0];
                oneTab.nameLabel.textColor = [UIColor colorWithRed:50/255.0 green:110/255.0 blue:186/255.0 alpha:1.0];
                oneTab.nameLabel.highlightedTextColor = [UIColor colorWithRed:0/255.0 green:56/255.0 blue:128/255.0 alpha:1.0];
                [rtval addObject:oneTab];
                [oneTab release];
            }
        }
    }
    return rtval;
}

- (void)multiTabBar:(BCMultiTabBar *)multiTabBar didSelectTabAtIndex:(NSIndexPath*)index byBtn:(BOOL)byBtn
{
    
    if (byBtn) {
        NSTimer* timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(barclickedByBtn) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    else {
        NSTimer* timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(barclickedNOBtn) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(void)addProjectLog
{
    if (self.selectID&&[self.selectID count]>=2) {
        BCTabBar* tabBar = [curMultiTabBar.tabBarArray objectAtIndex:0];
        BCTab* oneTab = [[tabBar tabs] objectAtIndex:curIndex];
        NSString* keyName = [oneTab titleName];
        if ([keyName isEqualToString:@"宏观"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"Macro_weibo"];
        }
        else if([keyName isEqualToString:@"产经"])
        {
            [[ProjectLogUploader getInstance] writeDataString:@"industry_weibo"];
        }
        else if([keyName isEqualToString:@"沪深"])
        {
            [[ProjectLogUploader getInstance] writeDataString:@"Aweibo"];
        }
        else if([keyName isEqualToString:@"港股"])
        {
            [[ProjectLogUploader getInstance] writeDataString:@"Hkweibo"];
        }
        else if([keyName isEqualToString:@"美股"])
        {
            [[ProjectLogUploader getInstance] writeDataString:@"Usweibo"];
        }
        else if([keyName isEqualToString:@"IT"])
        {
            [[ProjectLogUploader getInstance] writeDataString:@"Itweibo"];
        }
        else if([keyName isEqualToString:@"理财"])
        {
            [[ProjectLogUploader getInstance] writeDataString:@"finance_weibo"];
        }
        else if([keyName isEqualToString:@"楼市"])
        {
            [[ProjectLogUploader getInstance] writeDataString:@"real_estate_weibo"];
        }
        else if([keyName isEqualToString:@"车市"])
        {
            [[ProjectLogUploader getInstance] writeDataString:@"Car_Market_weibo"];
        }
        else if([keyName isEqualToString:@"自定义1"])
        {
            [[ProjectLogUploader getInstance] writeDataString:@"1_weibo"];
        }
        else if([keyName isEqualToString:@"自定义2"])
        {
            [[ProjectLogUploader getInstance] writeDataString:@"2_weibo"];
        }
    }
}

-(void)barclickedByBtn
{
    [self checkUserGroup];
    [self addProjectLog];
}

-(void)barclickedNOBtn
{
    [self checkUserGroup];
}

-(void)checkUserGroup 
{
    BCTabBar* tabBar = [curMultiTabBar.tabBarArray objectAtIndex:0];
    int selectedNum = [tabBar selectedColumn];
    curIndex = selectedNum;
    int contentCount = [groupList contentsCountWithIDList:self.groupID];
    if (contentCount>selectedNum) {
        if (oldGroupColumn!=selectedNum) {
            oldGroupColumn = selectedNum;
            NewsObject* oneObject = [self.groupList oneObjectWithIndex:selectedNum IDList:self.groupID];
            NSString* groupStr = [oneObject valueForKey:WeiboDefaultV2Group_idstr];
            NSMutableArray* tempArray = [[NSMutableArray alloc] initWithCapacity:0];
            [tempArray addObject:DefaultGroupKey];
            [tempArray addObject:groupStr];
            [tempArray addObject:@"weibogroup"];
            self.selectID = tempArray;
            [tempArray release];
            [self startRefreshTableNoForce];
        }
    }
    else
    {
        BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
        if (hasLogined) {
            if (oldGroupColumn!=selectedNum) {
                oldGroupColumn = selectedNum;
                int customNum = selectedNum - contentCount;
                [self.customGroupList reloadShowedDataWithIDList:self.customGroupID];
                NSArray* groups = [self.customGroupList contentsWithIDList:self.customGroupID];
                NewsObject* oneObject = nil;
                NSArray* subNames = [self defaultWeiboGroupNameArray];
                NSString* curWeiboName = [subNames objectAtIndex:customNum];
                for (NewsObject* object in groups) {
                    NSString* newName = [object valueForKey:WeiboGroup_name];
                    if ([curWeiboName isEqualToString:newName]) {
                        oneObject = object;
                        break;
                    }
                }
                NSString* groupStr = [oneObject valueForKey:WeiboGroup_idstr];
                NSMutableArray* tempArray = [[NSMutableArray alloc] initWithCapacity:0];
                [tempArray addObject:CustomGroupKey];
                if (groupStr) {
                    [tempArray addObject:groupStr];
                }
                else
                {
                    [tempArray addObject:ReplacedIDKey];
                }
                NSArray* customWeiboNames = [self defaultWeiboGroupNameArray];
                NSString* oneCustomName = [customWeiboNames objectAtIndex:customNum];
                [tempArray addObject:oneCustomName];
                NSString* userID = [[WeiboLoginManager getInstance] loginedID];
                [tempArray addObject:userID];
                self.selectID = tempArray;
                [tempArray release];
                [self startRefreshTableNoForce];
            }
        }
        else
        {
            MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
            [tabBarController setTabBarHiden:YES];
            LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginController.delegate = self;
            loginController.succeedSelector = @selector(checkUserGroup);
            loginController.returnSelector = @selector(loginReturned);
            loginController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginController animated:YES];
            [loginController release];
        }
    }
}

-(void)loginReturned
{
    BCTabBar* tabBar = [curMultiTabBar.tabBarArray objectAtIndex:0];
    [tabBar setSelectedColumn:oldGroupColumn];
    [self checkUserGroup];
}

-(void)startRefreshTableNoForce
{
    [self startRefreshTable:NO];
}

-(void)startRefreshTableWithForce
{
    [self startRefreshTable:YES];
}

-(void)startRefreshTable:(BOOL)bForce
{
    self.dataTableView.dataList = self.dataList;
    self.dataTableView.selectID = self.selectID;
    BOOL needRefresh = NO;
    if (bForce) {
        needRefresh = YES;
    }
    else
    {
        needRefresh = [self checkRefreshByDate];
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
    
    NSString* mode = [self.selectID objectAtIndex:SelectedIDIndex_Mode];
    NSString* gID = [self.selectID objectAtIndex:SelectedIDIndex_GroupIDStr];
    if ([mode isEqualToString:CustomGroupKey]) {
        if ([gID isEqualToString:ReplacedIDKey]) {
            needRefresh = YES;
        }
    }
    
    if (needRefresh) {
        [self.dataTableView startLoadingUI];
        
        if ([mode isEqualToString:CustomGroupKey]) {
            [[WeiboFuncPuller getInstance] startV2ObtainGroupListWithSender:self args:self.selectID];
        }
        else
        {
            [[WeiboFuncPuller getInstance] startContentListDefault2WeiboWithSender:self groupID:gID count:countPerPage page:1 max_id:nil lastID:nil args:self.selectID weiboList:self.dataList];
        }
    }
    else
    {
        [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
    }
}

-(BOOL)checkRefreshByDate
{
    BOOL rtval = NO;
    NSDate* oldDate = [dataList dateInfoWithIDList:self.selectID];
    if (oldDate) {
        NSTimeInterval length = [oldDate timeIntervalSinceDate:[NSDate date]];
        length = abs(length);
        if (length>HttpRequstRefreshTime) {
            rtval = YES;
        }
    }
    else
        rtval = YES;
    return rtval;
}

#pragma mark -
#pragma mark DataListTableView
-(UITableViewCell*)dataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    NSString *userIdentifier = [NSString stringWithFormat:@"CellIdentifier"];
    FullWeiboTableViewCell *rtval = (FullWeiboTableViewCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[FullWeiboTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
        rtval.delegate = self;
    }
    NewsObject* oneWeibo = object;
    NSDictionary* dataDict = [oneWeibo dataDict];
    NSDictionary* parentDict = (NSDictionary*)[dataDict valueForKey:WeiboUserObject_retweeted_status];
    if (parentDict) {
        dataDict = parentDict;
        rtval.repostedFeed = YES;
    }
    else
    {
        rtval.repostedFeed = NO;
    }
    NSDictionary* oneUserDict = (NSDictionary*)[dataDict valueForKey:WeiboObject_user];
    NewsObject* oneUser = [[NewsObject alloc] initWithJsonDictionary:oneUserDict];
    rtval.nameString = [oneUser valueForKey:WeiboUserObject_name];
    NSString* createDateStr = (NSString*)[dataDict valueForKey:WeiboObject_CreateDate];
    createDateStr = [createDateStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss z yyyy";
    NSDate* newFormatDate = [formatter dateFromString:createDateStr];
    [formatter release];
    rtval.createDate = newFormatDate;
    rtval.contentString= (NSString*)[dataDict valueForKey:WeiboObject_text];
    NSString* avatarStr = [oneUser valueForKey:WeiboUserObject_avatar_large];
    rtval.avatar = avatarStr;
    rtval.urlString = [dataDict valueForKey:WeiboObject_thumbnail_pic];
    NSNumber* repostCountNumber = (NSNumber*)[dataDict valueForKey:WeiboObject_reposts_count];
    rtval.repostCount = [repostCountNumber intValue];
    NSNumber* commentCountNumber = (NSNumber*)[dataDict valueForKey:WeiboObject_comments_count];
    rtval.commentCont = [commentCountNumber intValue];
    NSNumber* validateNumber = (NSNumber*)[oneUser valueForKey:WeiboUserObject_verified];
    rtval.hasValidate = [validateNumber boolValue];
    NSNumber* validatetypeNumber = (NSNumber*)[oneUser valueForKey:WeiboUserObject_verifiedtype];
    rtval.validateType = [validatetypeNumber boolValue];
    NSString* source =  (NSString*)[dataDict valueForKey:WeiboObject_source];
    source = [source stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    NSArray* sourceArray = [source componentsSeparatedByString:@">"];
    rtval.sourceDevice = [sourceArray lastObject];
    rtval.data = oneWeibo;
    [rtval reloadData];
    [oneUser release];
    
    return rtval;
}

-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    FullWeiboTableViewCell* rtval = nil;
    NSString* userIdentifier = @"fullIdentifier";
    rtval = (FullWeiboTableViewCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[FullWeiboTableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    }
    NewsObject* oneWeibo = object;
    NSDictionary* dataDict = [oneWeibo dataDict];
    NSDictionary* parentDict = (NSDictionary*)[dataDict valueForKey:WeiboUserObject_retweeted_status];
    if (parentDict) {
        dataDict = parentDict;
    }
    NSDictionary* oneUserDict = (NSDictionary*)[dataDict valueForKey:WeiboObject_user];
    NewsObject* oneUser = [[NewsObject alloc] initWithJsonDictionary:oneUserDict];
    rtval.nameString = [oneUser valueForKey:WeiboUserObject_name];
    rtval.contentString= (NSString*)[dataDict valueForKey:WeiboObject_text];
    NSString* avatarStr = [oneUser valueForKey:WeiboUserObject_avatar_large];
    rtval.avatar = avatarStr;
    rtval.urlString = [dataDict valueForKey:WeiboObject_thumbnail_pic];
    NSNumber* repostCountNumber = (NSNumber*)[dataDict valueForKey:WeiboObject_reposts_count];
    rtval.repostCount = [repostCountNumber intValue];
    NSNumber* commentCountNumber = (NSNumber*)[dataDict valueForKey:WeiboObject_comments_count];
    rtval.commentCont = [commentCountNumber intValue];
    NSString* source =  (NSString*)[dataDict valueForKey:WeiboObject_source];
    source = [source stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    NSArray* sourceArray = [source componentsSeparatedByString:@">"];
    rtval.sourceDevice = [sourceArray lastObject];
    [oneUser release];
    CGSize fitSize = [rtval sizeThatFits:CGSizeZero];
    return fitSize.height;
}

-(void)dataListView:(DataListTableView*)view didSelectedAtIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
//    [view.tableView deselectRowAtIndexPath:path animated:YES];

}

-(void)dataListViewDidMoreClicked:(DataListTableView*)view
{
    NSString* gID = [self.selectID objectAtIndex:SelectedIDIndex_GroupIDStr];
    NSString* mode = [self.selectID objectAtIndex:SelectedIDIndex_Mode];
    NewsObject* lastObject = [self.dataList lastObjectWithIDList:self.selectID];
    NSString* mid = [lastObject valueForKey:WeiboObject_idstr];
    NSString* createDateStr = [lastObject valueForKey:WeiboObject_CreateDate];
    
    if ([mode isEqualToString:DefaultGroupKey]) {
        [[WeiboFuncPuller getInstance] startContentListDefault2WeiboWithSender:self groupID:gID count:countPerPage page:curPage+1 max_id:mid lastID:createDateStr args:self.selectID weiboList:self.dataList];
    }
    else
    {
        [[WeiboFuncPuller getInstance] startV2ObtainWithSender:self groupID:gID count:countPerPage page:curPage+1 max_id:mid lastID:createDateStr args:self.selectID weiboList:self.dataList];
    }
}
-(void)dataListViewDidRefreshTriggered:(DataListTableView*)view
{
    [self startRefreshTableWithForce];
}

-(PageTableViewCell*)dataListView:(DataListTableView*)view PageCellStyleIdentifier:(NSString*)identifier
{
    PageTableViewCell* rtval = [[[PageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    [rtval setTipString:@"更多..." forType:PageCellType_Normal];
    [rtval setTipColor:[UIColor blackColor] forType:PageCellType_Normal];
    [rtval setTipColor:[UIColor blackColor] forType:PageCellType_Ending];
    return rtval;
}

#pragma mark
#pragma mark weibocellinternal

-(void)UrlParser:(UrlParserController*)controller urlString:(NSString*)urlString
{
    NSURL* url = [NSURL URLWithString:urlString];
    LKWebViewController *webVC = [[LKWebViewController alloc] initWithNibName:@"LKWebViewController" bundle:nil url:url];
    webVC.titleString = @"查看图片";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    [webVC release];
}

-(void)composeClicked:(UIButton*)sender
{
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:YES];
    ComposeWeiboViewController* composeController = [[ComposeWeiboViewController alloc] initWithNibName:@"ComposeWeiboViewController" bundle:nil];
    composeController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:composeController animated:YES];
    [composeController release];
}

-(void)configClicked:(UIButton*)sender
{
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    if (hasLogined) {
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        WeiboConfigViewController* configController = [[WeiboConfigViewController alloc] init];
        configController.hidesBottomBarWhenPushed = YES;
        configController.groupList = self.customGroupList;
        [self.navigationController pushViewController:configController animated:YES];
        [configController release];
    }
    else
    {
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginController animated:YES];
        [loginController release];
    }
}

-(void)cell:(UITableViewCell*)cell imageClicked:(NSString*)imageUrl
{
    NSIndexPath* indexPath = [self.dataTableView.tableView indexPathForCell:cell];
    int rowNum = indexPath.row;
    NewsObject* oneWeibo = [dataList oneObjectWithIndex:rowNum IDList:self.selectID];
    NSDictionary* dataDict = [oneWeibo dataDict];
    NSDictionary* parentDict = (NSDictionary*)[dataDict valueForKey:WeiboUserObject_retweeted_status];
    if (parentDict) {
        dataDict = parentDict;
    }
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:YES];
    NormalImageViewController* controller = [[NormalImageViewController alloc] init];
    NSString* originImage = [dataDict valueForKey:WeiboObject_original_pic];
    NSArray* array = [[NSArray alloc] initWithObjects:originImage, nil];
    controller.imageObjectList = array;
    [array release];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)cell:(UITableViewCell*)cell commentClicked:(UIButton*)sender
{
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    if (hasLogined) 
    {
        NSIndexPath* indexPath = [self.dataTableView.tableView indexPathForCell:cell];
        int rowNum = indexPath.row;
        NewsObject* oneWeibo = [dataList oneObjectWithIndex:rowNum IDList:self.selectID];
        NSDictionary* dataDict = [oneWeibo dataDict];
        NSDictionary* parentDict = (NSDictionary*)[dataDict valueForKey:WeiboUserObject_retweeted_status];
        if (parentDict) {
            dataDict = parentDict;
        }
        
        NewsObject* newWeibo = [[NewsObject alloc] initWithJsonDictionary:dataDict];
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        WeiboCommentViewController* commentController = [[WeiboCommentViewController alloc] init];
        commentController.weiboObject = newWeibo;
        [newWeibo release];
        commentController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:commentController animated:YES];
        [commentController release];
    }
    else
    {
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginController animated:YES];
        [loginController release];
    }
}

-(void)cell:(UITableViewCell*)cell repostClicked:(UIButton*)sender
{
    NSIndexPath* indexPath = [self.dataTableView.tableView indexPathForCell:cell];
    int rowNum = indexPath.row;
    NewsObject* oneWeibo = [dataList oneObjectWithIndex:rowNum IDList:self.selectID];
    NSDictionary* dataDict = [oneWeibo dataDict];
    NSDictionary* parentDict = (NSDictionary*)[dataDict valueForKey:WeiboUserObject_retweeted_status];
    if (parentDict) {
        dataDict = parentDict;
    }
    NewsObject* newWeibo = [[NewsObject alloc] initWithJsonDictionary:dataDict];
    
    [self pushComposeViewController:ComposeType_repost object:newWeibo];
    [newWeibo release];
}

-(void)cell:(UITableViewCell*)cell favoriteClicked:(UIButton*)sender
{
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    if (hasLogined) 
    {
        NSIndexPath* indexPath = [self.dataTableView.tableView indexPathForCell:cell];
        int rowNum = indexPath.row;
        NewsObject* oneWeibo = [dataList oneObjectWithIndex:rowNum IDList:self.selectID];
        NSDictionary* dataDict = [oneWeibo dataDict];
        NSDictionary* parentDict = (NSDictionary*)[dataDict valueForKey:WeiboUserObject_retweeted_status];
        if (parentDict) {
            dataDict = parentDict;
        }
        NSString* weiboID = [dataDict valueForKey:WeiboObject_mid];
        
        NSString* userID = [[WeiboLoginManager getInstance] loginedID];
        [[WeiboFuncPuller getInstance] startUserInfoWeiboWithSender:self uid:userID username:nil info:weiboID];
    }
    else
    {
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginController animated:YES];
        [loginController release];
    }
    
}

-(void)cell:(UITableViewCell*)cell contentClicked:(UIButton*)sender
{
    NSIndexPath* indexPath = [self.dataTableView.tableView indexPathForCell:cell];
    int rowNum = indexPath.row;
    NewsObject* oneWeibo = [dataList oneObjectWithIndex:rowNum IDList:self.selectID];
    NSDictionary* dataDict = [oneWeibo dataDict];
    NSDictionary* parentDict = (NSDictionary*)[dataDict valueForKey:WeiboUserObject_retweeted_status];
    if (parentDict) {
        dataDict = parentDict;
    }
    NSString* contentString= (NSString*)[dataDict valueForKey:WeiboObject_text];
    
    [self checkWeiboUrl:contentString];
}

-(void)pushComposeViewController:(NSInteger)type object:(NewsObject*)object
{
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:YES];
    ComposeWeiboViewController* composeController = [[ComposeWeiboViewController alloc] initWithNibName:@"ComposeWeiboViewController" bundle:nil];
    composeController.type = type;
    composeController.isSnap = NO;
    NSString* mid = [object valueForKey:WeiboObject_mid];
    composeController.mid = mid;
    composeController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:composeController animated:YES];
    [composeController release];
}

-(void)checkWeiboUrl:(NSString*)urlString
{
    NSArray* urlStrings = [UrlParserController componetBySearchNetworkString:urlString];
    if (urlStrings&&[urlStrings count]>0) {
        self.UrlArray = urlStrings;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] 
                                      initWithTitle:@"链接地址"
                                      delegate:self 
                                      cancelButtonTitle:nil 
                                      destructiveButtonTitle:nil 
                                      otherButtonTitles:nil, nil];
        for (NSString* oneUrlString in urlStrings) {
            [actionSheet addButtonWithTitle:oneUrlString];
        }
        [actionSheet addButtonWithTitle:@"取消"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons-1; 
        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
        [actionSheet release];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%i", buttonIndex);
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    if (buttonIndex>=0&&buttonIndex<[self.UrlArray count]) {
        NSString* urlString = [self.UrlArray objectAtIndex:buttonIndex];
        [self UrlParser:nil urlString:urlString];
    }
}

@end
