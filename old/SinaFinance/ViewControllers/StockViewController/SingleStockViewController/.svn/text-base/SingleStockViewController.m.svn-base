//
//  StockInfoViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SingleStockViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "StockInfoView.h"
#import "StockInfoView2.h"
#import "StockFuncPuller.h"
#import "CommentDataList.h"
#import "JSONKit.h"
#import "StockViewDefines.h"
#import "Util.h"
#import "WDKlineView.h"
#import "KLineViewController.h"
#import "ConfigFileManager.h"
#import "DataListTableView.h"
#import "NewsTableViewCell.h"
#import "NewsContentViewController2.h"
#import "BarStockListViewController.h"
#import "StockContentViewController.h"
#import "gDefines.h"
#import "MyStockGroupView.h"
#import "LoginViewController.h"
#import "PushTixingAddViewController.h"
#import "LoadingView.h"
#import "LoadingErrorView.h"
#import "LKTipCenter.h"
#import "ProjectLogUploader.h"
#import "Util.h"
#import "MyTool.h"
#import "AppDelegate.h"
#import "MyTabBarController.h"

#define StockRelateNewsKey @"StockRelateNews"
#define StockReportKey @"StockReportKey"
#define StockNoticeKey @"StockNoticeKey"

#define NewsHasReadKey @"NewsHasReadKey"

#define KLineTipKey @"KLineTipKey"

@interface SingleStockViewController ()
@property(nonatomic,retain)MyCustomToolbar* topToolBar;
@property(nonatomic,retain)CommentDataList* configDataList;
@property(nonatomic,retain)StockInfoView2* infoView;
@property(nonatomic,retain)NSArray* newsData;
@property(nonatomic,retain)NewsObject* singleStockData;
@property(nonatomic,retain)UIView* backScrollView;
@property(nonatomic,retain)DataListTableView* backTableView;
@property(nonatomic,retain)NSString* subType;
@property(nonatomic,retain)UIView* subTypeNameView;
@property(nonatomic,retain)UIView* titleView;
@property(nonatomic,retain)StockInfoView* titleItemView;
@property(nonatomic,retain)NSString* smallChartURL;
@property(nonatomic,retain)UIView* smallChartView;
@property(nonatomic,retain)NSString* smallChartSvg;
@property(nonatomic,retain)UIView* newsHeaderView;
@property(nonatomic,retain)UIView* infoTabHeaderView;
@property(nonatomic,retain)WDKlineView* klineView;
@property(nonatomic,retain)KLineViewController* klineController;
@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)NSMutableArray* selectID;
@property(nonatomic,retain)MyStockGroupView *mygroupView;
@property(nonatomic,retain)NSArray* mygroupArray;
@property(nonatomic,retain)UIButton* curRefreshBtn;
@property(nonatomic,retain)UIButton* curAddBtn;
@property(nonatomic,retain)UIActivityIndicatorView* curIndictator;
@property(nonatomic,retain)LoadingView2* curLoadingView;
@property(nonatomic,retain)LoadingErrorView* curErrorView;
@property(nonatomic,retain)LoadingView* curSvgLoadingView;
@property(nonatomic,retain)LoadingErrorView* curSvgErrorView;
@property(nonatomic,retain)NSDate* lastDate;
@property(nonatomic,retain)UIButton *tipBtn;
@property(nonatomic,retain)NSString* curStatus;
@property(nonatomic,retain)NSDictionary* netValueSymbolDict;
@property(nonatomic,retain)UITextView* debugLogView;
@property(nonatomic,retain)UIView* mainItemView;

- (void)createToolbar;
-(void)adjustTitleRect;
-(void)initNotification;
-(void)initUI;
-(void)initData;
-(void)refreshSmallChartUrl;
-(void)startRefreshTable;
-(void)reloadUIWithReload:(BOOL)bReload;
-(void)formatTitleItem;
-(void)formatSubTypeName;
-(void)formatStockSmallChartViewDataWithReload:(BOOL)reload;
-(void)formatStockInfoViewData;
-(void)formatNewsHeaderData;
-(void)formatInfoTabHeaderData;
-(void)initConfigData;
-(NSDictionary*)getCurSubTypeConfigDict;

@end

@implementation SingleStockViewController
{
    BOOL bInited;
    MyCustomToolbar* topToolBar;
    NSArray* newsData;
    NewsObject* singleStockData;
    UIView* backScrollView;
    DataListTableView* backTableView;
    CommentDataList* configDataList;
    NSString* subType;
    UIView* subTypeNameView;
    UIView* titleView;
    StockInfoView* titleItemView;
    NSInteger curContentHeight;
    NSString* smallChartURL;
    UIView* smallChartView;
    NSString* smallChartSvg;
    UIView* newsHeaderView;
    UIView* infoTabHeaderView;
    KLineViewController* klineController;
    CommentDataList* dataList;
    NSMutableArray* selectID;
    NSInteger curPage;
    NSInteger curIndex;
    NSInteger countPerPage;
    MyStockGroupView *mygroupView;
    NSArray* mygroupArray;
    BOOL canScrollBack;
    UIButton* curRefreshBtn;
    UIButton* curAddBtn;
    UIActivityIndicatorView* curIndictator;
    LoadingView2* curLoadingView;
    LoadingErrorView* curErrorView;
    LoadingView* curSvgLoadingView;
    LoadingErrorView* curSvgErrorView;
    WDKlineView* klineView;
    BOOL bViewLoaded;
    BOOL bLoading;
    BOOL bAutoLoading;
    NSDate* lastDate;
    BOOL curExited;
    NSTimeInterval pastedTimeInterval;
    BOOL curViewShowed;
    UIButton *tipBtn;
    NSDictionary* netValueSymbolDict;
    UITextView* debugLogView;
    UIView* mainItemView;
    int _tab_index;
    int _tab_view_origin_y;
    BOOL _hasPushTixingAddView;
}
@synthesize singleConfigDict;
@synthesize listConfigDict;
@synthesize infoView;
@synthesize stockType,stockSymbol,stockName;
@synthesize configDataList;
@synthesize newsData,singleStockData;
@synthesize backScrollView;
@synthesize subType;
@synthesize subTypeNameView;
@synthesize curStatus;
@synthesize titleView;
@synthesize titleItemView;
@synthesize smallChartURL;
@synthesize smallChartView;
@synthesize smallChartSvg;
@synthesize klineController;
@synthesize topToolBar;
@synthesize backTableView;
@synthesize newsHeaderView;
@synthesize infoTabHeaderView;
@synthesize dataList;
@synthesize selectID;
@synthesize mygroupView;
@synthesize mygroupArray;
@synthesize curRefreshBtn,curIndictator;
@synthesize curErrorView,curLoadingView;
@synthesize curSvgErrorView,curSvgLoadingView;
@synthesize curAddBtn;
@synthesize lastDate;
@synthesize tipBtn;
@synthesize netValueSymbolDict;
@synthesize debugLogView;
@synthesize klineView;
@synthesize mainItemView;
@synthesize pushController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        countPerPage = 20;
        dataList = [[CommentDataList alloc] init];
        selectID = [[NSMutableArray alloc] initWithCapacity:0];
        [ShareData sharedManager].viewIsLoading = YES;
        [self initConfigData];
    }
    return self;
}

-(void)dealloc
{
    [topToolBar release];
    [singleConfigDict release];
    [listConfigDict release];
    [infoView release];
    [stockType release];
    [stockSymbol release];
    [stockName release];
    [configDataList release];
    [newsData release];
    [singleStockData release];
    [backScrollView release];
    [subType release];
    [subTypeNameView release];
    [curStatus release];
    [titleView release];
    [titleItemView release];
    [smallChartURL release];
    [smallChartView release];
    [smallChartSvg release];
    klineView.aniview.delegate = nil;
    [klineView release];
    [klineController exit];
    klineController.delegate = nil;
    [klineController release];
    [backTableView release];
    [newsHeaderView release];
    [infoTabHeaderView release];
    [dataList release];
    [selectID release];
    [mygroupView release];
    [mygroupArray release];
    [curRefreshBtn release];
    [curAddBtn release];
    [curIndictator release];
    [curErrorView release];
    [curLoadingView release];
    [curSvgErrorView release];
    [curSvgLoadingView release];
    [lastDate release];
    [tipBtn release];
    [netValueSymbolDict release];
    [debugLogView release];
    [mainItemView release];
    [pushController release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    curViewShowed = YES;
    [ShareData sharedManager].isStockItemView = YES;
    if (!bLoading) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [ShareData sharedManager].isStockItemView = NO;
    curViewShowed = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:3.0/255 green:21.0/255 blue:59.0/255 alpha:1.0];
//    UIImage* backImage = [UIImage imageNamed:@"stock_content_back.png"];
//    UIImageView* backImageView = [[UIImageView alloc] initWithImage:backImage];
//    backImageView.frame = CGRectMake(0, 43, 320, self.view.bounds.size.height-44);
//    backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    //[self.view addSubview:backImageView];
//    [backImageView release];
    
    
    if ([stockType isEqualToString:@"fund"]) {
        self.stockSymbol = [self.stockSymbol stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    }
    
    if (!singleConfigDict) {
        NSArray* configArray = [self.configDataList contentsWithIDList:nil];
        for (NSDictionary* oneDict in configArray) {
            NSString* tempType = [oneDict valueForKey:Stockitem_singleStock_typeitem];
            if (tempType&&[tempType isEqualToString:stockType]) {
                self.singleConfigDict = oneDict;
                break;
            }
        }
    }
    [self refreshSmallChartUrl];
    
    [self createToolbar];
    [self initUI];
    if (!bInited) {
        bInited = YES;
        [self initNotification];
        [self initData];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([ShareData sharedManager].isStockItemView && [ShareData sharedManager].viewIsLoading == NO){
        if (interfaceOrientation!=UIInterfaceOrientationPortraitUpsideDown) {
            return YES;
        }
        else {
            return NO;
        }
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)shouldAutorotate{
     return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation==UIInterfaceOrientationPortrait&&bViewLoaded) {
        if(klineController)
        {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
            self.klineController.view.hidden = YES;
            [self.klineController viewWillDisappear:NO];
            self.singleStockData = self.klineController.singleStockData;
        }
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:duration];
        self.topToolBar.hidden = NO;
        self.backTableView.hidden = NO;
        [UIView commitAnimations];
        [self reloadUIWithReload:NO];
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [app performSelector:@selector(adjustTabBarFrame) withObject:nil afterDelay:0.1];
        [self reloadTabData];
        [self stopedtip];
    }
    else {
        if (self.pushController.view) {
            [self.pushController.view removeFromSuperview];
            _hasPushTixingAddView = NO;
        }
        UIButton* btn2 = (UIButton*)[self.newsHeaderView viewWithTag:100014];
        btn2.enabled = YES;
        
        if (!klineController) {
            klineController = [[KLineViewController alloc] init];
            klineController.delegate = self;
            klineController.stockName = self.stockName;
            klineController.stockSymbol = self.stockSymbol;
            klineController.stockType = self.stockType;
            klineController.subType = self.subType;
            klineController.curStatus = self.curStatus;
            klineController.subConfigDict = [self getCurSubTypeConfigDict];
            klineController.singleStockData = self.singleStockData;
            CGRect klineRect = self.view.bounds;
            klineController.view.frame = klineRect;
            klineController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        }
        klineController.singleStockData = self.singleStockData;
        [klineController reloadData];
        [self stopedtip];
        self.backTableView.hidden = YES;
        self.topToolBar.hidden = YES;
        self.klineController.view.hidden = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        [self.view addSubview:klineController.view];
        [self.klineController viewWillAppear:NO];
    }
    
}

-(void)controllerBackClicked:(KLineViewController*)controller
{
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:YES];
    [self handleBackPressed];
}

- (void)createToolbar
{
    MyCustomToolbar* newToolBar = [[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    newToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:newToolBar];
    self.topToolBar = newToolBar;
    [newToolBar release];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:backBtn];
    
    UIButton *refreshBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(280, 10, 25, 23);
//    [refreshBtn setImage:[UIImage imageNamed:@"refresh_btn.png"] forState:UIControlStateNormal];
    refreshBtn.tag = REFRESH_BTN_TAG;
    [Util set_refresh_btn_bg_png:refreshBtn];
    [refreshBtn addTarget:self action:@selector(handleRefreshPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:refreshBtn];
    self.curRefreshBtn = refreshBtn;
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    CGRect indicatorRect = indicator.frame;
    indicatorRect.origin.x = 280 + 25/2 - indicatorRect.size.width/2;
    indicatorRect.origin.y = 44/2 - indicatorRect.size.height/2;
    indicator.frame = indicatorRect;
    [topToolBar addSubview:indicator];
    self.curIndictator = indicator;
    [indicator release];
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(245, 10, 25, 23);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(handleAddPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:addBtn];
    if (!bViewLoaded) {
        addBtn.enabled = NO;
    }
    self.curAddBtn = addBtn;
    
    NSDictionary* subTypeNames = [self.singleConfigDict valueForKey:Stockitem_singleStock_subtypename];
    
    if (subTypeNames&&[subTypeNames count]>0) {
        UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
        titleLabel.frame = CGRectMake(55, 0, 190, 44);
        titleLabel.numberOfLines = 2;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:18];
        titleLabel.text = stockName;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        [topToolBar addSubview:titleLabel];
    }
    else {
        if (!self.titleView) {
            titleView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, 200, 44)];
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
            stockLabel.text = @"";
            [titleView addSubview:stockLabel];
            [stockLabel release];
        }
        else {
            titleView.frame = CGRectMake(60, 0, 190, 44);
        }
        [topToolBar addSubview:titleView];
        
        [self adjustTitleRect];
    }
}

-(void)adjustTitleRect
{
    UILabel* stockNameLabel = (UILabel*)[titleView viewWithTag:323231];
    UILabel* stockNickLabel = (UILabel*)[titleView viewWithTag:323232];
    UILabel* stockLabel = (UILabel*)[titleView viewWithTag:323233];
    if (stockSymbol) {
        stockNameLabel.text = [NSString stringWithFormat:@"(%@)",stockSymbol];
    }
    else {
        stockNameLabel.text = stockSymbol;
    }
    if (stockName) {
        stockNickLabel.text = stockName;
    }
    else {
        stockNickLabel.text = @"正在获取...";
    }
    
    
    CGRect titleViewBounds = titleView.bounds;
    [stockNameLabel sizeToFit];
    [stockNickLabel sizeToFit];
    [stockLabel sizeToFit];
    CGRect stockRect = stockLabel.bounds;
    CGRect nameRect = stockNameLabel.bounds;
    if (nameRect.size.width>190) {
        nameRect.size.width = 190;
    }
    CGRect nickRect = stockNickLabel.bounds;
    if (nickRect.size.width>190) {
        nickRect.size.width = 190;
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
    stockLabel.frame = stockRect;
    stockNameLabel.frame = nameRect;
    stockNickLabel.frame = nickRect;
}

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self 
           selector:@selector(StockObjectAdded:) 
               name:StockObjectAddedNotification 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(StockObjectFailed:)
               name:StockObjectFailedNotification
             object:nil];
    
    [nc addObserver:self
           selector:@selector(onChangedOrientation:) 
               name:UIDeviceOrientationDidChangeNotification
             object:nil];
    
    [nc addObserver:self
           selector:@selector(onDismissPushTixingViewAddCall:)
               name:onDismissPushTixingViewAdd
             object:nil];
}


-(void)onDismissPushTixingViewAddCall:(NSNotification*)notify{
    [SVProgressHUD dismiss];
}


-(void)initUI
{
    CGRect bounds = self.view.bounds;
    NSInteger curY = 44;
    if (!curLoadingView) {
        CGRect loadingRect = bounds;
        loadingRect.origin.y = curY;
        loadingRect.size.height = loadingRect.size.height-loadingRect.origin.y;
        curLoadingView = [[LoadingView2 alloc] initWithFrame:loadingRect];
        curLoadingView.hidden = NO;
        curLoadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:curLoadingView];
    }
    if (!curErrorView) {
        CGRect loadingRect = bounds;
        loadingRect.origin.y = curY;
        loadingRect.size.height = loadingRect.size.height-loadingRect.origin.y;
        curErrorView = [[LoadingErrorView alloc] initWithFrame:loadingRect];
        curErrorView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        curErrorView.hidden = YES;
        [self.view addSubview:curErrorView];
    }
    
    [self startRefreshDataTimer];
}

-(void)initConfigData
{
    if (!self.configDataList) {
        self.configDataList = [[ConfigFileManager getInstance] singleStockConfigDataList];
    }
    if (!self.listConfigDict) {
        CommentDataList* listConfigDataList = [[ConfigFileManager getInstance] stockListConfigDataList];
        NSArray* configArray = [listConfigDataList contentsWithIDList:nil];
        for (NewsObject* oneObject in configArray) {
            NSString* type = [oneObject valueForKey:Stockitem_type];
            if (type&&[type isEqualToString:Value_Stockitem_type_myGroup]) {
                self.listConfigDict = oneObject.newsData; //自选股的配置信息
                break;
            }
        }
    }
}

-(void)initData
{
    bLoading = YES;
    if(!bViewLoaded)
    {
        self.curLoadingView.hidden = NO;
    }
    self.curErrorView.hidden = YES;
    [self.curIndictator startAnimating];
    self.curRefreshBtn.hidden = YES;
    if (!self.subType&&[stockType isEqualToString:@"fund"]) {
        
        [[StockFuncPuller getInstance] startOneFundTypeWithSender:self symbol:stockSymbol args:nil dataList:nil userInfo:nil];
    }
    else {
        [self startRefreshTable];
    }
    
}

- (void)onChangedOrientation:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if ((orientation == UIDeviceOrientationLandscapeLeft
         || orientation == UIDeviceOrientationLandscapeRight)) {
        // ex:layoutForLandscape
    }
    else if (orientation == UIDeviceOrientationPortrait) {
        //  ex:layoutForPortrait
    }
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
        NSTimeInterval refreshInterval = [[ShareData sharedManager] refreshInterval];
        
        UIButton *refreshBtn = (UIButton *)[self.view viewWithTag:REFRESH_BTN_TAG];
        [Util set_refresh_btn_bg_png:refreshBtn];
        
        if (refreshInterval<=pastedTimeInterval&&refreshInterval>0.0&&curViewShowed) {
            pastedTimeInterval = 0.0;
            
            [self handleAutoRefresh];
        }
    }
}

#pragma mark -
#pragma mark BtnPressed
-(void)handleBackPressed
{
    curExited = YES;
    [ShareData sharedManager].viewIsLoading = NO;
    [ShareData sharedManager].isStockItemView = NO;
    [ShareData sharedManager].kLineHided = NO;
    curViewShowed = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleRefreshPressed
{
    bAutoLoading = NO;
    [self initData];
}

-(void)handleAutoRefresh
{
    bAutoLoading = YES;
    [self initData];
}

-(void)handleAddPressed:(UIButton*)sender
{
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    if (hasLogined) {
        BOOL hasMyGroupView = mygroupView?YES:NO;
        [self initMyGroupView:sender];
        BOOL needRequest = NO;
        if (hasMyGroupView) {
            if (self.mygroupView.superview.hidden) {
                self.mygroupView.superview.hidden = NO;
                needRequest = YES;
            }
            else {
                self.mygroupView.superview.hidden = YES;
            }
        }
        else {
            needRequest = YES;
        }
        if (needRequest) {
            NSArray* requstTypes = (NSArray*)[self.listConfigDict valueForKey:Stockitem_request_type];
            NSInteger curRequstIndex = 0;
            for (int i=0; i<[requstTypes count]; i++) {
                NSString* oneType = [requstTypes objectAtIndex:i];
                if ([oneType isEqualToString:self.stockType]) {
                    curRequstIndex = i;
                    break;
                }
            }
            NSArray* groupRequstTypes = (NSArray*)[self.listConfigDict valueForKey:Stockitem_grouprequst_type];
            NSString* service = nil;
            if (curRequstIndex<[groupRequstTypes count]) {
                service = [groupRequstTypes objectAtIndex:curRequstIndex];
            }
            NSDictionary* commandDict = (NSDictionary*)[self.listConfigDict valueForKey:Stockitem_layout_request_command];
            NSString* command = [commandDict valueForKey:Stockitem_layout_request_command_list];
            [[StockFuncPuller getInstance] startMyGroupListWithSender:self service:service command:command args:nil dataList:nil seperateRequst:YES userInfo:nil];
        }
    }
    else {
        [self stopedtip];
        LoginViewController* userLoginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        userLoginController.delegate = self;
        userLoginController.loginMode = LoginMode_Stock;
        [self.navigationController pushViewController:userLoginController animated:YES];
        [userLoginController release];
    }
}

-(void)groupViewBackClicked:(UIButton*)sender
{
    self.mygroupView.superview.hidden = YES;
}


-(void)initMyGroupView:(UIButton*)sender
{
    CGRect addStockRect = sender.frame;
    addStockRect = [self.view convertRect:addStockRect fromView:sender.superview];
    CGRect suggestRect = addStockRect;
    suggestRect.origin.y = addStockRect.origin.y + addStockRect.size.height+3;
    suggestRect.size.width = 120; 
    suggestRect.origin.x = 320 - 10 - 120;
    suggestRect.size.height = 100;
    if(mygroupView == nil){
        UIButton* btn = [[UIButton alloc] initWithFrame:self.view.bounds];
        btn.tag = 1112224;
        [btn addTarget:self action:@selector(groupViewBackClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn release];
        
        mygroupView = [[MyStockGroupView alloc] initWithFrame:suggestRect data:nil];
        [btn addSubview:mygroupView];
        mygroupView.delegate = self;
    }
    else {
        [mygroupView setData:nil];
        mygroupView.frame = suggestRect;
    }
    UIView* btnView = [self.view viewWithTag:1112224];
    [self.view bringSubviewToFront:btnView];
}

-(void)addMygroupView:(NSArray*)groupArray
{
    self.mygroupArray = groupArray;
    mygroupView.hidden = NO;
    [mygroupView setData:self.mygroupArray];
    mygroupView.loadState = GroupViewState_Finish;
}

-(void)addMygroupViewError
{
    self.mygroupArray = nil;
    [mygroupView setData:nil];
    mygroupView.loadState = GroupViewState_Error;
}

- (void)myStockGroupView:(MyStockGroupView*)groupView didSelectGroup:(NSDictionary*)dict
{
    self.mygroupView.superview.hidden = YES;
    NSArray* requstTypes = (NSArray*)[self.listConfigDict valueForKey:Stockitem_request_type];
    NSInteger curRequstIndex = 0;
    for (int i=0; i<[requstTypes count]; i++) {
        NSString* oneType = [requstTypes objectAtIndex:i];
        if ([oneType isEqualToString:self.stockType]) {
            curRequstIndex = i;
            break;
        }
    }
    NSArray* groupRequstTypes = (NSArray*)[self.listConfigDict valueForKey:Stockitem_grouprequst_type];
    NSString* service = nil;
    if (curRequstIndex<[groupRequstTypes count]) {
        service = [groupRequstTypes objectAtIndex:curRequstIndex];
    }
    NSDictionary* commandDict = (NSDictionary*)[self.listConfigDict valueForKey:Stockitem_layout_request_command];
    NSString* command = [commandDict valueForKey:Stockitem_layout_request_command_add];
    
    NSString* pid = [dict valueForKey:StockFunc_GroupInfo_pid];
    [[StockFuncPuller getInstance] startMyGroupAddStockWithSender:self service:service stock:[NSArray arrayWithObject:self.stockSymbol] command:command groupPID:pid args:nil dataList:nil userInfo:nil];
}

#pragma mark -
#pragma mark networkCallback
-(void)StockObjectAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_StockLookup) {
            NSLog(@"%@",@"ss");
        }
        else if ([stageNumber intValue]==Stage_Request_OneStockInfo)
        {
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSArray* array = [userInfo valueForKey:RequsetArray];
            NewsObject* oneObject = [array lastObject];
            if (!self.subType&&[stockType isEqualToString:@"fund"])
            {
                self.stockName = [oneObject valueForKey:StockFunc_SingleStockInfo_fundname];
            }
            else {
                self.stockName = [oneObject valueForKey:StockFunc_SingleStockInfo_name];
            }
            [self adjustTitleRect];
            self.singleStockData = oneObject;
            self.curStatus = [self.singleStockData valueForKey:StockFunc_SingleStockInfo_status];
            [self reloadUIWithReload:YES];
        }
        else if ([stageNumber intValue]==Stage_Request_OneFundType) {
            NSDictionary* retDict = [userInfo valueForKey:RequsetExtra];
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSArray* array = [userInfo valueForKey:RequsetArray];
            
            NewsObject* typeObject = [array lastObject];
            self.subType = [typeObject valueForKey:StockFunc_SingleStockInfo_fundtype];
            NSDictionary* curConfigDict = [self getCurSubTypeConfigDict];
            NSDictionary* smallChart = [curConfigDict valueForKey:Stockitem_singleStock_chart_smallchart];
            NSString* oneURL = [smallChart valueForKey:Stockitem_singleStock_chart_url];
            if ([oneURL rangeOfString:@"${style}"].location==NSNotFound) {
                [self refreshSmallChartUrl];
                [self startRefreshTable];
            }
            else {
                if (!netValueSymbolDict) {
                    [[StockFuncPuller getInstance] startOneFundNetValueWithSender:self symbol:self.stockSymbol args:nil dataList:nil userInfo:nil];
                }
                else {
                    [self refreshSmallChartUrl];
                    [self startRefreshTable];
                }
            }
        }
        else if ([stageNumber intValue]==Stage_Request_OneFundNetValue) {
            NSDictionary* retDict = [userInfo valueForKey:RequsetExtra];
            self.netValueSymbolDict = retDict;
            [self refreshSmallChartUrl];
            [self startRefreshTable];
        }
        else if ([stageNumber intValue]==Stage_Request_StockChart) {
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSString* requestFileName = [userInfo valueForKey:RequsetExtra];
            NSString* requsetURL = [userInfo valueForKey:RequsetInfo];
            if ([requsetURL isEqualToString:smallChartURL]) {
                if (requestFileName) {
                    self.curSvgLoadingView.hidden = YES;
                    self.curSvgErrorView.hidden = YES;
                    self.smallChartSvg = requestFileName;
                    [self addStockSmallChartViewData];
                }
            }
        }
        else if ([stageNumber intValue]==Stage_Request_OneStockNews||[stageNumber intValue]==Stage_Request_OneCnStockReport||[stageNumber intValue]==Stage_Request_OneCnStockNotice||[stageNumber intValue]==Stage_Request_OneHkStockNotice) {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            NSArray* array = [userInfo valueForKey:RequsetArray];
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                curPage = [pageNumber intValue];
                if ([pageNumber intValue]<=1) {
                    [self.backTableView scrollTop:NO];
                }
                if ([array count]>=countPerPage) {
                    [self.backTableView doneLoadingWithReloadTable:YES pageEnd:NO];
                }
                else {
                    [self.backTableView doneLoadingWithReloadTable:YES pageEnd:YES];
                }
            }
        }
        else if([stageNumber intValue]==Stage_Request_ObtainMyGroupList)
        {
            NSArray* array = [userInfo valueForKey:RequsetSourceArray];
            if ([self.stockType isEqualToString:@"fund"]) {
                NSDictionary* foundDict = nil;
                for (NSDictionary* oneGroup in array) {
                    NSString* hqType = [oneGroup valueForKey:StockFunc_GroupInfo_hqtype];
                    if (hqType&&self.subType) {
                        if ([self.subType isEqualToString:@"lof"]) {
                            if ([self.subType isEqualToString:hqType]) {
                                foundDict = oneGroup;
                                break;
                            }
                        }
                        else if([self.subType isEqualToString:@"etf"])
                        {
                            if ([self.subType isEqualToString:hqType]) {
                                foundDict = oneGroup;
                                break;
                            }
                        }
                        else if ([self.subType rangeOfString:hqType].location!=NSNotFound) {
                            foundDict = oneGroup;
                            break;
                        }
                    }
                }
                if (foundDict) {
                    array = [NSArray arrayWithObject:foundDict];
                }
            }
            [self addMygroupView:array];
        }
        else if([stageNumber intValue]==Stage_Request_AddMyGroup)
        {
            NSDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
            NSArray* stock = [extraDict valueForKey:@"stock"];
            NSString* msg = nil;
            if ([stock count]<4) {
                msg = [NSString stringWithFormat:@"添加股票[%@]成功!",[stock componentsJoinedByString:@","]];
            }
            else {
                msg = [NSString stringWithString:@"添加股票成功!"];
            }
            
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
}

-(void)StockObjectFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_OneStockNews||[stageNumber intValue]==Stage_Request_OneCnStockReport||[stageNumber intValue]==Stage_Request_OneCnStockNotice||[stageNumber intValue]==Stage_Request_OneHkStockNotice) {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                [self.backTableView doneLoadingWithReloadTable:NO pageEnd:NO];
            }
            
        }
        else if([stageNumber intValue]==Stage_Request_ObtainMyGroupList)
        {
            [self addMygroupViewError];
        }
        else if([stageNumber intValue]==Stage_Request_AddMyGroup)
        {
            NSDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
            NSString* oldMsg = [extraDict valueForKey:@"msg"];
            NSString* msg = [NSString stringWithFormat:@"添加股票失败,%@",oldMsg];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
//            [self showPushTixingAddView];
        }
        else if ([stageNumber intValue]==Stage_Request_OneFundType) {
            [self.curIndictator stopAnimating];       
            self.curRefreshBtn.hidden = NO;
            if (!bViewLoaded) {
                self.curLoadingView.hidden = YES;
                self.curErrorView.hidden = NO;
            }
            else {
                self.curLoadingView.hidden = YES;
                self.curErrorView.hidden = YES;
                if (!bAutoLoading) {
                    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"刷新出错了" time:1.0 ignoreAddition:NO pView:self.backTableView];
                }
            }
            bLoading = NO;
        }
        else if([stageNumber intValue]==Stage_Request_OneFundNetValue){
            [self refreshSmallChartUrl];
            [self startRefreshTable];
        }
        else if ([stageNumber intValue]==Stage_Request_OneStockInfo) 
        {
            [self.curIndictator stopAnimating];
            self.curRefreshBtn.hidden = NO;
            if (!bViewLoaded) {
                self.curLoadingView.hidden = YES;
                self.curErrorView.hidden = NO;
            }
            else {
                self.curLoadingView.hidden = YES;
                self.curErrorView.hidden = YES;
                if (!bAutoLoading) {
                    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"刷新出错了" time:1.0 ignoreAddition:NO pView:self.backTableView];
                }
            }
            bLoading = NO;
        }
        else if ([stageNumber intValue]==Stage_Request_StockChart) {
            NSString* requsetURL = [userInfo valueForKey:RequsetInfo];
            if ([requsetURL isEqualToString:smallChartURL]) {
                if (!self.klineView) {
                    [self changeErrorTipByStatus];
                    self.curSvgErrorView.hidden = NO;
                    self.curSvgLoadingView.hidden = YES;
                }
                [self.curIndictator stopAnimating];
                self.curRefreshBtn.hidden = NO;
                if (!bViewLoaded) {
                    self.curLoadingView.hidden = YES;
                    self.curErrorView.hidden = NO;
                }
                else {
                    self.curLoadingView.hidden = YES;
                    self.curErrorView.hidden = YES;
                    if (!bAutoLoading&&curStatus&&[curStatus intValue]==1) {
                        [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"刷新出错了" time:1.0 ignoreAddition:NO pView:self.backTableView];
                    }
                }
                bLoading = NO;
            }
        }
    }
    
    if (pushController.view) {
//        [pushController.view removeFromSuperview];
    }
}

-(void)changeErrorTipByStatus
{
    self.curSvgErrorView.customTipString = nil;
    NSString* ssStatus = [netValueSymbolDict valueForKey:StockFunc_Chart_ssStatus];
    if ([ssStatus isEqualToString:@"WSS"]) {
        self.curSvgErrorView.customTipString = @"此基金还在申购期";
    }
    NSString* status = self.curStatus;
    if (status&&[status intValue]!=1) {
        NSString* errortip = nil;
        if ([status intValue]==0) {
            errortip = @"未上市";
        }
        else if ([status intValue]==2) {
            errortip = @"已停牌";
        }
        else if ([status intValue]==3) {
            errortip = @"已退市";
        }
        if (errortip) {
//            self.curSvgErrorView.hidden = NO;
            self.curSvgErrorView.customTipString = errortip;
        }
        
    }
}

#pragma mark -
#pragma mark reload

-(void)refreshSmallChartUrl
{
    if (!smallChartURL) {
        NSDictionary* curConfigDict = [self getCurSubTypeConfigDict];
        NSDictionary* smallChart = [curConfigDict valueForKey:Stockitem_singleStock_chart_smallchart];
        NSString* oneURL = [smallChart valueForKey:Stockitem_singleStock_chart_url];
        NSString* symbol = self.stockSymbol;
        oneURL = [oneURL stringByReplacingOccurrencesOfString:@"${symbol}" withString:symbol];
        NSString* exchange = [self.netValueSymbolDict valueForKey:StockFunc_Chart_exchange];
        if (exchange) {
            oneURL = [oneURL stringByReplacingOccurrencesOfString:@"${style}" withString:exchange];
        }
        if (![symbol isEqualToString:@"HSI"]) {
            oneURL = [oneURL lowercaseString];
        }
        self.smallChartURL = oneURL;
    }
}

-(void)startRefreshTable
{
    if(!_hasPushTixingAddView){
        [[StockFuncPuller getInstance] startOneStockInfoWithSender:self type:stockType symbol:stockSymbol args:nil dataList:nil userInfo:nil];
    }
}

-(void)reloadUIWithReload:(BOOL)bReload
{
    NSInteger curY = 44;
    CGRect tableRect = CGRectMake(0, curY, self.view.bounds.size.width, self.view.bounds.size.height-curY);
    
    if (!backTableView) {
        backTableView = [[DataListTableView alloc] initWithFrame:tableRect];
        backTableView.defaultSucBackString = @"";
        backTableView.backLabel.textColor = [UIColor whiteColor];
        backTableView.backgroundColor = [UIColor clearColor];
        backTableView.tableView.backgroundColor = [UIColor clearColor];
        backTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        backTableView.delegate = self;
        backTableView.hasHeaderMode = NO;
        self.backTableView.dataList = self.dataList;
        self.backTableView.selectID = self.selectID;
    }
    else {
        backTableView.frame = tableRect;
    }
    [self.view addSubview:backTableView];
    
    if (!backScrollView) {
        backScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.backTableView.bounds.size.width, self.backTableView.bounds.size.height)];
        backScrollView.backgroundColor = [UIColor clearColor];
    }
    else {
        self.backScrollView.frame = CGRectMake(0, 0, self.backTableView.bounds.size.width, self.backTableView.bounds.size.height);
    }
    self.backTableView.tableView.tableHeaderView = backScrollView;
#ifdef DEBUG_test
    curContentHeight = 5;
    [self formatDebugLog];
#else
    curContentHeight = 5;
#endif
    [self formatSubTypeName];
    [self formatMainItem];
    [self formatTitleItem];
    [self formatStockSmallChartViewDataWithReload:bReload];
    [self formatStockInfoViewData];
    [self formatNewsHeaderData];
    CGRect backScrollRect = backScrollView.frame;
    backScrollRect.size.height = curContentHeight;
    backScrollView.frame = backScrollRect;
    self.backTableView.tableView.tableHeaderView = backScrollView;
    if ([self hasnewsheader]) {
        canScrollBack = YES;
        backTableView.tableView.scrollEnabled = YES;
        if (!self.selectID||[self.selectID count]<1) {
            [self startInitWithindex:curIndex];
        }
    }
    else {
        canScrollBack = NO;
        backTableView.tableView.scrollEnabled = NO;
    }
    [self.curIndictator stopAnimating];
    self.curRefreshBtn.hidden = NO;
    self.curErrorView.hidden = YES;
    self.curLoadingView.hidden = YES;
    [ShareData sharedManager].viewIsLoading = NO;
    bViewLoaded = YES;
    bLoading = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:UIDeviceOrientationDidChangeNotification object:nil];
    self.curAddBtn.enabled = YES;
    UIView* btnView = [self.view viewWithTag:1112224];
    [self.view bringSubviewToFront:btnView];
}

-(NSDictionary*)getCurNewsHeaderDict
{
    NSDictionary* curConfigDict = [self getCurSubTypeConfigDict];
    
    NSDictionary* newsheaderDict = nil;
    NSDictionary* special_newstable = [curConfigDict valueForKey:Stockitem_singleStock_special_newstable];
    if (special_newstable) {
        NSString* tableKey = [special_newstable valueForKey:self.stockSymbol];
        if (tableKey) {
            newsheaderDict = [curConfigDict valueForKey:tableKey];
        }
        else {
            newsheaderDict = [curConfigDict valueForKey:Stockitem_singleStock_newstable];
        }
    }
    else {
        newsheaderDict = [curConfigDict valueForKey:Stockitem_singleStock_newstable];
    }
    return newsheaderDict;
}

-(BOOL)hasnewsheader
{
    BOOL rtval = NO;
    NSDictionary* newsheaderDict = [self getCurNewsHeaderDict];
    
    if (newsheaderDict) {
        NSArray* headerKeys = newsheaderDict.allKeys;
        for (NSString* onekey in headerKeys) {
            NSString* oneValue = [newsheaderDict valueForKey:onekey];
            if (oneValue&&[oneValue intValue]>0) {
                rtval = YES;
                break;
            }
        }
    }
    return rtval;
}

-(void)formatDebugLog
{
    int curY = curContentHeight;
    CGRect logRect = CGRectMake(5, curY, 310, 50);
    if (!debugLogView) {
        debugLogView = [[UITextView alloc] initWithFrame:logRect];
        debugLogView.backgroundColor = [UIColor clearColor];
        debugLogView.textColor = [UIColor whiteColor];
        debugLogView.font = [UIFont systemFontOfSize:15.0];
        debugLogView.editable = NO;
    }
    else
    {
        debugLogView.frame = logRect;
    }
    [self.backScrollView addSubview:debugLogView];
    curContentHeight += logRect.size.height;
}

-(void)formatSubTypeName
{
    int curY = curContentHeight;
    NSDictionary* subTypeNames = [self.singleConfigDict valueForKey:Stockitem_singleStock_subtypename];
    
    if (subTypeNames&&[subTypeNames count]>0) {
        NSString* subTypeName = [subTypeNames valueForKey:self.subType];
        if (subTypeName) {
            CGRect titleRect = CGRectMake(0, curY, 320, 30);
            if (!self.subTypeNameView) {
                subTypeNameView = [[UIView alloc] initWithFrame:titleRect];
                UILabel* subTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, titleRect.size.width - 10, titleRect.size.height)];
                subTypeLabel.textColor = [UIColor whiteColor];
                subTypeLabel.backgroundColor = [UIColor clearColor];
                subTypeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                subTypeLabel.tag = 111133;
                [subTypeNameView addSubview:subTypeLabel];
                [subTypeLabel release];
            }
            else {
                subTypeNameView.frame = titleRect;
            }
            [self.backScrollView addSubview:subTypeNameView];
            curContentHeight = titleRect.origin.y + titleRect.size.height;
            UILabel* subTypeLabel = (UILabel*)[self.subTypeNameView viewWithTag:111133];
            subTypeLabel.text = [NSString stringWithFormat:@"%@: %@",subTypeName,stockSymbol];
        }
    }
}

-(void)formatMainItem
{
    NSDictionary* curConfigDict = [self getCurSubTypeConfigDict];
    NSArray* columnArray = [curConfigDict valueForKey:Stockitem_singleStock_maintitem];
    if (columnArray&&[columnArray count]>0) {
        if (!mainItemView) {
            UIView* newView = [[UIView alloc] init];
            newView.frame  =CGRectMake(0, curContentHeight, 320, 45);
            UILabel* priceLabel = [[UILabel alloc] init];
            priceLabel.tag = 11000;
            priceLabel.textAlignment = UITextAlignmentCenter;
            priceLabel.font = [UIFont fontWithName:APP_FONT_NAME size:30.0];
            priceLabel.frame = CGRectMake(10, 10, 130, 30);
            priceLabel.backgroundColor = [UIColor clearColor];
            priceLabel.adjustsFontSizeToFitWidth = YES;
            [newView addSubview:priceLabel];
            [priceLabel release];
            
            UILabel* Label1 = [[UILabel alloc] init];
            Label1.tag = 11001;
            Label1.font = [UIFont fontWithName:APP_FONT_NAME size:14.0];
            Label1.frame = CGRectMake(145, 5, 75, 15);
            Label1.backgroundColor = [UIColor clearColor];
            Label1.adjustsFontSizeToFitWidth = YES;
            [newView addSubview:Label1];
            [Label1 release];
            
            UILabel* Label2 = [[UILabel alloc] init];
            Label2.tag = 11002;
            Label2.font = [UIFont fontWithName:APP_FONT_NAME size:14.0];
            Label2.frame = CGRectMake(145, 25, 75, 15);
            Label2.backgroundColor = [UIColor clearColor];
            Label2.adjustsFontSizeToFitWidth = YES;
            [newView addSubview:Label2];
            [Label2 release];
            
            UILabel* Label3 = [[UILabel alloc] init];
            Label3.tag = 11003;
            Label3.font = [UIFont fontWithName:APP_FONT_NAME size:12.0];
            Label3.backgroundColor = [UIColor clearColor];
            Label3.frame = CGRectMake(220, 25, 95, 15);
            Label3.adjustsFontSizeToFitWidth = YES;
            [newView addSubview:Label3];
            [Label3 release];
            
            UILabel* Label4 = [[UILabel alloc] init];
            Label4.tag = 11004;
            Label4.font = [UIFont fontWithName:APP_FONT_NAME size:12.0];
            Label4.backgroundColor = [UIColor clearColor];
            Label4.adjustsFontSizeToFitWidth = YES;
            Label4.frame = CGRectMake(220, 5, 95, 15);
            [newView addSubview:Label4];
            [Label4 release];
            
            self.mainItemView = newView;
            [newView release];
        }
        else
        {
            mainItemView.frame  =CGRectMake(0, curContentHeight, 320, 45);
        }
        [backScrollView addSubview:mainItemView];
        curContentHeight = mainItemView.frame.origin.y + mainItemView.frame.size.height;
        
        NSString* bRedSize = [curConfigDict valueForKey:Stockitem_singleStock_redrise];
        NSInteger colorType = 0;
        if ([bRedSize intValue]>0) {
            colorType = kSHZhangDie;
        }
        NSMutableArray* infoViewDataArray = [[NSMutableArray alloc] initWithCapacity:0];
        StockInfoCellData* cellData = [[[StockInfoCellData alloc] init] autorelease];
        
        NSMutableArray* allColumns = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* decideColorArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* decideNullArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSString* decideNullEnable = nil;
        UIColor* decideColorEnable = nil;
        for (NSDictionary* oneColumn in columnArray) {
            NSString* code = [oneColumn valueForKey:Stockitem_singleStock_column_code];
            NSString* name = [oneColumn valueForKey:Stockitem_singleStock_column_name];
            if (code&&![code isEqualToString:@""]) {
                name = [singleStockData valueForKey:code];
                NSString* decidecolor = [oneColumn valueForKey:Stockitem_singleStock_column_decidecolor];
                NSString* decidenull = [oneColumn valueForKey:Stockitem_singleStock_column_decidenull];
                NSString* justname = [oneColumn valueForKey:Stockitem_singleStock_column_justname];
                NSString* stringStyle = [oneColumn valueForKey:Stockitem_singleStock_column_stringstyle];
                StockInfoOneColumnData* columnData = [[StockInfoOneColumnData alloc] init];
                NSString* columnName = nil;
                if (name&&![name isKindOfClass:[NSNull class]]) {
                    if (decidecolor) {
                        if ([decidecolor isKindOfClass:[NSArray class]])
                        {
                            decideColorEnable = [[ShareData sharedManager] textColorWithValue:[name floatValue] marketType:colorType];
                            for (int i=0;i<[columnArray count];i++) 
                            {
                                NSString* curIndexString = [NSString stringWithFormat:@"%d",i];
                                BOOL contains = [(NSArray*)decidecolor containsObject:curIndexString];
                                id replaceObject = [NSNull null];
                                if (contains) 
                                {
                                    replaceObject = decideColorEnable;
                                }
                                if(i>=[decideColorArray count])
                                {
                                    [decideColorArray addObject:replaceObject];
                                }
                                else {
                                    if (![replaceObject isKindOfClass:[NSNull class]]) {
                                        [decideColorArray replaceObjectAtIndex:i withObject:replaceObject];
                                    }
                                }
                            }
                        }
                        else if([decidecolor intValue]>0)
                        {
                            decideColorEnable = [[ShareData sharedManager] textColorWithValue:[name floatValue] marketType:colorType];
                        }
                    }
                    if (decidenull&&[name floatValue]==0.0) {
                        columnName = @"--";
                        if ([decidenull isKindOfClass:[NSArray class]]) {
                            for (int i=0;i<[columnArray count];i++) {
                                NSString* curIndexString = [NSString stringWithFormat:@"%d",i];
                                BOOL contains = [(NSArray*)decidenull containsObject:curIndexString];
                                id replaceObject = [NSNull null];
                                if (contains) 
                                {
                                    replaceObject = @"--";
                                }
                                if(i>=[decideNullArray count])
                                {
                                    [decideNullArray addObject:replaceObject];
                                }
                                else {
                                    if (![replaceObject isKindOfClass:[NSNull class]]) {
                                        [decideNullArray replaceObjectAtIndex:i withObject:replaceObject];
                                    }
                                    
                                }
                            }
                        }
                        else if([decidenull intValue]>0){
                            decideNullEnable = @"--";
                        }
                    }
                    else {
                        columnName = [SingleStockViewController formatFloatString:name style:stringStyle];
                    }
                }
                else {
                    columnName = @"--";
                }
                NSString* prename = [oneColumn valueForKey:Stockitem_singleStock_column_prename];
                if (prename) {
                    columnData.preName = prename;
                }
                columnData.name = columnName;
                if (justname&&[justname intValue]>0) {
                    columnData.justName = YES;
                }
                
                [cellData.columnData addObject:columnData];
                [allColumns addObject:columnData];
                [columnData release];
                NSString* endline = [oneColumn valueForKey:Stockitem_singleStock_column_endline];
                if (endline&&[endline intValue]>0) {
                    [infoViewDataArray addObject:cellData];
                    cellData = [[[StockInfoCellData alloc] init] autorelease];
                }
            }
            else {
                StockInfoOneColumnData* columnData = [[StockInfoOneColumnData alloc] init];
                columnData.name = name;
                columnData.justName = YES;
                [cellData.columnData addObject:columnData];
                [allColumns addObject:columnData];
                [columnData release];
                NSString* endline = [oneColumn valueForKey:Stockitem_singleStock_column_endline];
                if (endline&&[endline intValue]>0) {
                    [infoViewDataArray addObject:cellData];
                    cellData = [[[StockInfoCellData alloc] init] autorelease];
                }
            }
        }
        if ([cellData.columnData count]>0) {
            [infoViewDataArray addObject:cellData];
        }
        if([decideNullArray count]>0)
        {
            for (int i=0;i<[decideNullArray count];i++) {
                NSString* replaceString = [decideNullArray objectAtIndex:i];
                if (![replaceString isKindOfClass:[NSNull class]]) {
                    StockInfoOneColumnData* columnData = [allColumns objectAtIndex:i];
                    columnData.name = replaceString;
                }
            }
        }
        else if (decideNullEnable) {
            for (StockInfoOneColumnData* columnData in allColumns) {
                if (!columnData.justName) {
                    columnData.name = decideNullEnable;
                }
            }
        }
        if([decideColorArray count]>0)
        {
            for (int i=0;i<[decideColorArray count];i++) {
                UIColor* replaceColor = [decideColorArray objectAtIndex:i];
                if (![replaceColor isKindOfClass:[NSNull class]]) {
                    StockInfoOneColumnData* columnData = [allColumns objectAtIndex:i];
                    columnData.fontColor = replaceColor;
                }
            }
        }
        else if (decideColorEnable) {
            for (StockInfoOneColumnData* columnData in allColumns) {
                if (!columnData.justName) {
                    columnData.fontColor = decideColorEnable;
                }
            }
        }
        [decideNullArray release];
        [decideColorArray release];
        [allColumns release];
    
        if ([infoViewDataArray count]>0) {
            StockInfoCellData* cellData = [infoViewDataArray objectAtIndex:0];
            NSMutableArray* columnArray = cellData.columnData;
            if (columnArray&&[columnArray count]>0) {
                int columnCount = [columnArray count];
                for (int j=0;j<columnCount;j++) {
                    StockInfoOneColumnData* oneCell = [columnArray objectAtIndex:j];
                    UILabel* tempLabel = (UILabel*)[self.mainItemView viewWithTag:11000+j];

                    if (oneCell.fontColor) {
                        tempLabel.textColor = oneCell.fontColor;
                    }
                    else {
                        tempLabel.textColor = [UIColor colorWithRed:95/255.0 green:106/255.0 blue:130/255.0 alpha:1.0];
                    }
                    
                    tempLabel.text = oneCell.name;
                }
                
            }
        }
        [self dealStockStatusShow];
    }
}

-(void)formatTitleItem
{
    NSDictionary* curConfigDict = [self getCurSubTypeConfigDict];
    NSString* titleItemType = [curConfigDict valueForKey:Stockitem_singleStock_titleitemtype];
    NSArray* columnArray = [curConfigDict valueForKey:Stockitem_singleStock_titleitem];
    if (columnArray&&[columnArray count]>0) {
        if (titleItemType) {
            NSString* bRedSize = [curConfigDict valueForKey:Stockitem_singleStock_redrise];
            NSInteger colorType = 0;
            if ([bRedSize intValue]>0) {
                colorType = kSHZhangDie;
            }
            CGRect titleRect = CGRectMake(0, curContentHeight, 320, 20);
            if (!titleItemView) {
                titleItemView = [[StockInfoView alloc] initWithFrame:titleRect];
                titleItemView.backgroundColor = [UIColor clearColor];
                titleItemView.leftMargin = 15;
                if ([titleItemType intValue]==1) {
                    titleItemView.viewType = ViewType_titleItem1;
                }
                else if ([titleItemType intValue]==0) {
                    titleItemView.viewType = ViewType_titleItem0;
                }
            }
            else {
                titleItemView.frame = titleRect;
            }
            [self.backScrollView addSubview:titleItemView];
            curContentHeight = titleRect.origin.y + titleRect.size.height;
            
            NSMutableArray* infoViewDataArray = [[NSMutableArray alloc] initWithCapacity:0];
            StockInfoCellData* cellData = [[[StockInfoCellData alloc] init] autorelease];
            
            NSArray* widths = [curConfigDict valueForKey:Stockitem_singleStock_titleitemwidths];
            self.titleItemView.widthArray = widths;
            NSMutableArray* allColumns = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray* decideColorArray = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray* decideNullArray = [[NSMutableArray alloc] initWithCapacity:0];
            NSString* decideNullEnable = nil;
            UIColor* decideColorEnable = nil;
            for (NSDictionary* oneColumn in columnArray) {
                NSString* code = [oneColumn valueForKey:Stockitem_singleStock_column_code];
                NSString* name = [oneColumn valueForKey:Stockitem_singleStock_column_name];
                if (code&&![code isEqualToString:@""]) {
                    name = [singleStockData valueForKey:code];
                    NSString* decidecolor = [oneColumn valueForKey:Stockitem_singleStock_column_decidecolor];
                    NSString* decidenull = [oneColumn valueForKey:Stockitem_singleStock_column_decidenull];
                    NSString* justname = [oneColumn valueForKey:Stockitem_singleStock_column_justname];
                    NSString* stringStyle = [oneColumn valueForKey:Stockitem_singleStock_column_stringstyle];
                    StockInfoOneColumnData* columnData = [[StockInfoOneColumnData alloc] init];
                    NSString* columnName = nil;
                    if (name&&![name isKindOfClass:[NSNull class]]) {
                        if (decidecolor) {
                            if ([decidecolor isKindOfClass:[NSArray class]])
                            {
                                decideColorEnable = [[ShareData sharedManager] textColorWithValue:[name floatValue] marketType:colorType];
                                for (int i=0;i<[columnArray count];i++) 
                                {
                                    NSString* curIndexString = [NSString stringWithFormat:@"%d",i];
                                    BOOL contains = [(NSArray*)decidecolor containsObject:curIndexString];
                                    id replaceObject = [NSNull null];
                                    if (contains) 
                                    {
                                        replaceObject = decideColorEnable;
                                    }
                                    if(i>=[decideColorArray count])
                                    {
                                        [decideColorArray addObject:replaceObject];
                                    }
                                    else {
                                        if (![replaceObject isKindOfClass:[NSNull class]]) {
                                            [decideColorArray replaceObjectAtIndex:i withObject:replaceObject];
                                        }
                                    }
                                }
                            }
                            else if([decidecolor intValue]>0)
                            {
                                decideColorEnable = [[ShareData sharedManager] textColorWithValue:[name floatValue] marketType:colorType];
                            }
                        }
                        if (decidenull&&[name floatValue]==0.0) {
                            columnName = @"--";
                            if ([decidenull isKindOfClass:[NSArray class]]) {
                                for (int i=0;i<[columnArray count];i++) {
                                    NSString* curIndexString = [NSString stringWithFormat:@"%d",i];
                                    BOOL contains = [(NSArray*)decidenull containsObject:curIndexString];
                                    id replaceObject = [NSNull null];
                                    if (contains) 
                                    {
                                        replaceObject = @"--";
                                    }
                                    if(i>=[decideNullArray count])
                                    {
                                        [decideNullArray addObject:replaceObject];
                                    }
                                    else {
                                        if (![replaceObject isKindOfClass:[NSNull class]]) {
                                            [decideNullArray replaceObjectAtIndex:i withObject:replaceObject];
                                        }
                                        
                                    }
                                }
                            }
                            else if([decidenull intValue]>0){
                                decideNullEnable = @"--";
                            }
                        }
                        else {
                            columnName = [SingleStockViewController formatFloatString:name style:stringStyle];
                        }
                    }
                    else {
                        columnName = @"--";
                    }
                    NSString* prename = [oneColumn valueForKey:Stockitem_singleStock_column_prename];
                    if (prename) {
                        columnData.preName = prename;
                    }
                    columnData.name = columnName;
                    if (justname&&[justname intValue]>0) {
                        columnData.justName = YES;
                    }
                    
                    [cellData.columnData addObject:columnData];
                    [allColumns addObject:columnData];
                    [columnData release];
                    NSString* endline = [oneColumn valueForKey:Stockitem_singleStock_column_endline];
                    if (endline&&[endline intValue]>0) {
                        [infoViewDataArray addObject:cellData];
                        cellData = [[[StockInfoCellData alloc] init] autorelease];
                    }
                }
                else {
                    StockInfoOneColumnData* columnData = [[StockInfoOneColumnData alloc] init];
                    columnData.name = name;
                    columnData.justName = YES;
                    [cellData.columnData addObject:columnData];
                    [allColumns addObject:columnData];
                    [columnData release];
                    NSString* endline = [oneColumn valueForKey:Stockitem_singleStock_column_endline];
                    if (endline&&[endline intValue]>0) {
                        [infoViewDataArray addObject:cellData];
                        cellData = [[[StockInfoCellData alloc] init] autorelease];
                    }
                }
            }
            if ([cellData.columnData count]>0) {
                [infoViewDataArray addObject:cellData];
            }
            if([decideNullArray count]>0)
            {
                for (int i=0;i<[decideNullArray count];i++) {
                    NSString* replaceString = [decideNullArray objectAtIndex:i];
                    if (![replaceString isKindOfClass:[NSNull class]]) {
                        StockInfoOneColumnData* columnData = [allColumns objectAtIndex:i];
                        columnData.name = replaceString;
                    }
                }
            }
            else if (decideNullEnable) {
                for (StockInfoOneColumnData* columnData in allColumns) {
                    if (!columnData.justName) {
                        columnData.name = decideNullEnable;
                    }
                }
            }
            if([decideColorArray count]>0)
            {
                for (int i=0;i<[decideColorArray count];i++) {
                    UIColor* replaceColor = [decideColorArray objectAtIndex:i];
                    if (![replaceColor isKindOfClass:[NSNull class]]) {
                        StockInfoOneColumnData* columnData = [allColumns objectAtIndex:i];
                        columnData.fontColor = replaceColor;
                    }
                }
            }
            else if (decideColorEnable) {
                for (StockInfoOneColumnData* columnData in allColumns) {
                    if (!columnData.justName) {
                        columnData.fontColor = decideColorEnable;
                    }
                }
            }
            [decideNullArray release];
            [decideColorArray release];
            [allColumns release];
            self.titleItemView.dataArray = infoViewDataArray;
            [infoViewDataArray release];
            [self.titleItemView reloadData];
            curContentHeight = self.titleItemView.frame.size.height + self.titleItemView.frame.origin.y;
        }
    }
    
    [self dealUSStockSecondTitleShow];
}

-(void)dealStockStatusShow
{
    NSString* status = self.curStatus;
    if (status&&[status intValue]!=1) {
        if (![[self.stockType lowercaseString] isEqualToString:@"fund"]) {
            for (int i=0; i<3; i++) {
                UILabel* tempLabel = (UILabel*)[self.mainItemView viewWithTag:11000+i];
                if (i==0) {
                    if ([status intValue]==0) {
                        tempLabel.text = @"未上市";
                    }
                    else if ([status intValue]==2) {
                        tempLabel.text = @"停牌";
                    }
                    else if ([status intValue]==3) {
                        tempLabel.text = @"退市";
                    }
                }
                else {
                    tempLabel.text = @"--";
                }
                tempLabel.textColor = [UIColor whiteColor];
            }
            
        }
    }
}

-(void)dealUSStockSecondTitleShow
{
    if ([[self.stockType lowercaseString] isEqualToString:@"us"]) {
        NSArray* infoViewDataArray = self.titleItemView.dataArray;
        if ([infoViewDataArray count]>=1) {
            StockInfoCellData* cellData = [infoViewDataArray lastObject];
            NSArray* columnDataArray = cellData.columnData;
            if ([columnDataArray count]>=2) {
                NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (int j=0; j<[infoViewDataArray count]; j++) {
                    StockInfoCellData* oneCellData = [infoViewDataArray objectAtIndex:j];
                    if (oneCellData!=cellData) {
                        [newArray addObject:oneCellData];
                    }
                }
                BOOL hasData = NO;
                for (int j=0; j<[columnDataArray count]; j++) {
                    StockInfoOneColumnData* oneColumnData = [columnDataArray objectAtIndex:j];
                    if (!oneColumnData.justName) {
                        if (![oneColumnData.name isEqualToString:@"--"]) {
                            hasData = YES;
                            break;
                        }
                    }
                }
                if (hasData) 
                {
                    StockInfoOneColumnData* lastColumnData = [columnDataArray lastObject];
                    StockInfoOneColumnData* firstColumnData = [columnDataArray objectAtIndex:0];
                    if ([firstColumnData.name isEqualToString:@"盘后"]||[firstColumnData.name isEqualToString:@"盘前"]) {
                        if ([[lastColumnData.name uppercaseString] rangeOfString:@"PM"].location!=NSNotFound) {
                            firstColumnData.name = @"盘后";
                        }
                        else if([[lastColumnData.name uppercaseString] rangeOfString:@"AM"].location!=NSNotFound){
                            firstColumnData.name = @"盘前";
                        }
                    }
                    [newArray addObject:cellData];
                }
                if (YES)
                {
                    StockInfoCellData* firstCellData = [infoViewDataArray objectAtIndex:0];
                    NSMutableArray* columnDataArray = firstCellData.columnData;
                    if ([columnDataArray count]>1) {
                        StockInfoOneColumnData* oneColumnData = [columnDataArray objectAtIndex:0];
                        if ([oneColumnData.name isEqualToString:@""]) {
                            NSArray* widthArray = self.titleItemView.widthArray;
                            NSMutableArray* newWidthArray = [[NSMutableArray alloc] initWithCapacity:0];
                            NSInteger firstNumber = 0;
                            NSInteger addlenth = 0;
                            for (int k=0; k<[widthArray count]; k++) {
                                NSNumber* oneWidth = [widthArray objectAtIndex:k];
                                if (k==0) {
                                    firstNumber = [oneWidth intValue];
                                    [newWidthArray addObject:[NSNumber numberWithInt:0]];
                                }
                                else if(k<[widthArray count]-1){
                                    if (k==[widthArray count]-2) {
                                        [newWidthArray addObject:[NSNumber numberWithInt:firstNumber-addlenth+[oneWidth intValue]]];
                                    }
                                    else {
                                        [newWidthArray addObject:[NSNumber numberWithInt:firstNumber/3+[oneWidth intValue]]];
                                        addlenth += firstNumber/3;
                                    }
                                }
                                else {
                                    [newWidthArray addObject:oneWidth];
                                }
                            }
                            NSDictionary* widthDict = [NSDictionary dictionaryWithObject:newWidthArray forKey:@"0"];
                            self.titleItemView.widthArrayForRows = widthDict;
                            [newWidthArray release];
                        }
                    }
                }
                
                self.titleItemView.dataArray = newArray;
                [newArray release];
                [self.titleItemView reloadData];
                curContentHeight = self.titleItemView.frame.size.height + self.titleItemView.frame.origin.y;
            }
        }
    }
}

-(void)formatStockSmallChartViewDataWithReload:(BOOL)bReload
{
    if (!smallChartView) {
        smallChartView = [[UIView alloc] initWithFrame:CGRectMake(0, curContentHeight, 320, 130)];
        self.smallChartView.backgroundColor = [UIColor clearColor];
        LoadingErrorView* errorView = [[LoadingErrorView alloc] initWithFrame:smallChartView.bounds];
        errorView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        errorView.backgroundColor = [UIColor clearColor];
        [smallChartView addSubview:errorView];
        self.curSvgErrorView = errorView;
        errorView.hidden = YES;
        [errorView release];
        
        LoadingView* loadingView = [[LoadingView alloc] initWithFrame:smallChartView.bounds];
        loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        loadingView.backgroundColor = [UIColor clearColor];
        [smallChartView addSubview:loadingView];
        self.curSvgLoadingView = loadingView;
        loadingView.hidden = YES;
        [loadingView release];
    }
    else 
    {
        smallChartView.frame = CGRectMake(0, curContentHeight, 320, 130);
    }
    [self.backScrollView addSubview:smallChartView];
    curContentHeight = self.smallChartView.frame.size.height + self.smallChartView.frame.origin.y;
    
    if (!self.klineView) {
        if (bReload) {
            self.curSvgLoadingView.hidden = NO;
            self.curSvgErrorView.hidden = YES;
        }
        else {
            self.curSvgLoadingView.hidden = YES;
            self.curSvgErrorView.hidden = NO;
        }
    }
    
    [self changeErrorTipByStatus];
    
    if (bReload) {
#ifdef DEBUG
        NSLog(@"test stockChart url=%@",self.smallChartURL);
        self.debugLogView.text = self.smallChartURL;
#endif
        [[StockFuncPuller getInstance] startStockChartWithSender:self url:self.smallChartURL args:nil dataList:nil userInfo:self.smallChartURL];
    }
}


-(void)addStockSmallChartViewData
{
    [self stopedtip];
    self.klineView.aniview.delegate = nil;
    [self.klineView removeFromSuperview];
    self.klineView = nil;
    if (!self.klineView) {
        WDKlineView *klview = [[WDKlineView alloc] initWithSVG:self.smallChartSvg drawShadow:YES];
        klview.aniview.delegate = self;
        klview.tag = 1111;
        self.klineView = klview;
        [self.smallChartView addSubview:klview];
        [self.smallChartView sendSubviewToBack:klview];
        [klview release];
    }
    else {
        [klineView clear];
        [klineView loadSVG:self.smallChartSvg drawShadow:YES];
    }
    
    NSNumber* hasTiped = [[NSUserDefaults standardUserDefaults] valueForKey:KLineTipKey];
    if (hasTiped&&[hasTiped boolValue]) {
        ;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:KLineTipKey];
        UIButton* tipView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
        [self performSelector:@selector(tipClicked:) withObject:nil afterDelay:15.0];
        self.tipBtn = tipView;
        [tipView addTarget:self action:@selector(tipClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.smallChartView addSubview:tipView];
        [tipView release];
        
        
        UIImageView* timeLineBtn = [[UIImageView alloc] initWithFrame:CGRectMake(150, 20, 150, 110)];
        NSString* imagePath = [[NSBundle mainBundle] bundlePath];
        imagePath = [imagePath stringByAppendingPathComponent:@"timelinetip.png"];
        UIImage* tipImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
        timeLineBtn.image = tipImage;
        [tipView addSubview:timeLineBtn];
        [tipImage release];
        [timeLineBtn release];
    }
}

//
//
//-(void)addStockSmallChartViewData
//{
//    BOOL stockstatus_stop = NO;//[[self.singleStockData valueForKey:StockFunc_SingleStockInfo_status] isEqualToString:[NSString stringWithFormat:@"%@",@"2"]]?YES:NO;
//    
////    if (stockstatus_stop) {
////        [self changeErrorTipByStatus];
////        return;
////    }else{
//    
//    [self stopedtip];
//    self.klineView.aniview.delegate = nil;
//    [self.klineView removeFromSuperview];
//    self.klineView = nil;
//    
//    if (!stockstatus_stop) {
//        if (!self.klineView) {
//            WDKlineView *klview = [[WDKlineView alloc] initWithSVG:self.smallChartSvg drawShadow:YES];
//            klview.aniview.delegate = self;
//            klview.tag = 1111;
//            self.klineView = klview;
//            [self.smallChartView addSubview:klview];
//            [self.smallChartView sendSubviewToBack:klview];
//            [klview release];
//        }
//        else {
//            [klineView clear];
//            [klineView loadSVG:self.smallChartSvg drawShadow:YES];
//        }
//    }else{
//        [self changeErrorTipByStatus];
//    }
//    
//    NSNumber* hasTiped = [[NSUserDefaults standardUserDefaults] valueForKey:KLineTipKey];
//    if (hasTiped&&[hasTiped boolValue]) {
//        ;
//    }
//    else
//    {
//        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:KLineTipKey];
//        UIButton* tipView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
//        [self performSelector:@selector(tipClicked:) withObject:nil afterDelay:15.0];
//        self.tipBtn = tipView;
//        [tipView addTarget:self action:@selector(tipClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [self.smallChartView addSubview:tipView];
//        [tipView release];
//        
//        
//        UIImageView* timeLineBtn = [[UIImageView alloc] initWithFrame:CGRectMake(150, 20, 150, 110)];
//        NSString* imagePath = [[NSBundle mainBundle] bundlePath];
//        imagePath = [imagePath stringByAppendingPathComponent:@"timelinetip.png"];
//        UIImage* tipImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
//        timeLineBtn.image = tipImage;
//        [tipView addSubview:timeLineBtn];
//        [tipImage release];
//        [timeLineBtn release];
//    }
//}

-(void)tipClicked:(UIButton*)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(stopedtip)];
    [UIView setAnimationDuration:1.5];
    self.tipBtn.alpha = 0.0;
    [UIView commitAnimations];
}

-(void)stopedtip
{
    [self.tipBtn removeFromSuperview];
    self.tipBtn = nil;
}

- (void)klineAnimationTouchBegin:(WDKlineAnimation *)klineAnimation
{
    WDKlineView* klview = (WDKlineView*)[self.smallChartView viewWithTag:1111];
    if (klview.aniview==klineAnimation) {
        if (canScrollBack) {
            self.backTableView.tableView.scrollEnabled = NO;
        }
    }
}
- (void)klineAnimationTouchEnd:(WDKlineAnimation *)klineAnimation
{
    WDKlineView* klview = (WDKlineView*)[self.smallChartView viewWithTag:1111];
    if (klview.aniview==klineAnimation) {
        if (canScrollBack) {
            self.backTableView.tableView.scrollEnabled = YES;
        }
    }
}

- (NSString*)stringForklineAnimationTouchedWithDateString:(NSString*)dateString KeyData:(NSArray*)keyData valueData:(NSArray*)valueData
{
    NSString* rtval = @"";
    if (keyData&&valueData) {
        rtval = [rtval stringByAppendingString:dateString];
        for (int i=0; i<[keyData count]; i++) {
            NSString* oneKey = [keyData objectAtIndex:i];
            NSString* oneValue = [valueData objectAtIndex:i];
            if ([oneKey isEqualToString:@"量"]||[oneKey isEqualToString:@"成交量"]) {
                BOOL isDigtal = [MyTool isDigtal:oneValue];
                NSString* suffixStr = nil;
                if (!isDigtal) {
                    suffixStr = [oneValue substringFromIndex:[oneValue length]-1];
                }
                oneValue = [Util formatBigNumber:oneValue];
                if (suffixStr) {
                    if (![oneValue hasSuffix:suffixStr]) {
                        oneValue = [oneValue stringByAppendingString:suffixStr];
                    }
                }
                if ([self verifyAmountZeroToNull]&&[oneKey isEqualToString:@"成交量"]) {
                    NSString* newValue = oneValue;
                    if (suffixStr) {
                        if ([oneValue hasSuffix:suffixStr]) {
                            newValue = [oneValue substringToIndex:[oneValue length]-1];
                        }
                    }
                    
                    if ([newValue isEqualToString:@"0"]) {
                        oneValue = @"--";
                    }
                }
            }
            rtval = [rtval stringByAppendingFormat:@"  %@:%@",oneKey,oneValue];
        }
    }
    return rtval;
}

-(BOOL)verifyAmountZeroToNull
{
    BOOL rtval = NO;
    if ([self.stockSymbol isEqualToString:@".dji"]) {
        rtval = YES;
    }
    else if ([self.stockSymbol isEqualToString:@".ixic"]) {
        rtval = YES;
    }
    else if ([self.stockSymbol isEqualToString:@".inx"]) {
        rtval = YES;
    }
    return rtval;
}

-(void)formatStockInfoViewData
{
    [self formatInfoTabHeaderData];
    if (!infoView) {
        StockInfoView2* newView = [[StockInfoView2 alloc] init];
        newView.frame  =CGRectMake(0, curContentHeight, 320, 100);
        newView.leftMargin = 15;
        self.infoView = newView;
        [newView release];
    }
    else
    {
        infoView.frame  =CGRectMake(0, curContentHeight, 320, 100);
    }
    [backScrollView addSubview:infoView];
    CGRect infoRect = self.infoView.frame;
    curContentHeight = infoRect.origin.y + infoRect.size.height;
    [self reloadTabContent];
}

-(void)reloadTabContent{
    [self reloadTabData];
   
    CGRect infoRect = self.infoView.frame;
    curContentHeight = infoRect.origin.y + infoRect.size.height;
}

-(void)reloadTabData{
    NSMutableArray* infoViewDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    StockInfoCellData* cellData = [[[StockInfoCellData alloc] init] autorelease];
    NSDictionary* curConfigDict = [self getCurSubTypeConfigDict];
    NSArray* columnArray;
    NSArray* widths = [curConfigDict valueForKey:Stockitem_singleStock_infowidths];
    NSArray* widths2 = [curConfigDict valueForKey:Stockitem_singleStock_tabcellwidths];
    BOOL stockstatus_stop = NO;//[[self.singleStockData valueForKey:StockFunc_SingleStockInfo_status] isEqualToString:[NSString stringWithFormat:@"%@",@"2"]]?YES:NO;
    float last_close = [[self.singleStockData valueForKey:StockFunc_SingleStockInfo_last_close] floatValue];
    //NSLog(@"_tab_index = %d,%@,%@",_tab_index,widths,widths2);
    //NSLog(@"curConfigDict = %@",curConfigDict);
    //盘中信息
    if (_tab_index==0) {
        self.infoView.widthArray = widths;
        columnArray = [curConfigDict valueForKey:Stockitem_singleStock_infoitem];
        for (NSDictionary* oneColumn in columnArray) {
            NSString* code = [oneColumn valueForKey:Stockitem_singleStock_column_code];
            NSString* name = [oneColumn valueForKey:Stockitem_singleStock_column_name];
            if (code&&![code isEqualToString:@""]) {
                name = [singleStockData valueForKey:code];
                
                NSString* decidenull = [oneColumn valueForKey:Stockitem_singleStock_column_decidenull];
                NSString* stringStyle = [oneColumn valueForKey:Stockitem_singleStock_column_stringstyle];
                StockInfoOneColumnData* columnData = [[StockInfoOneColumnData alloc] init];
                if (name&&![name isKindOfClass:[NSNull class]]) {
                    if (decidenull&&[decidenull intValue]>0&&[name floatValue]==0.0) {
                        columnData.name = @"--";
                    }
                    else {
                        name = [self specilValueForCode:code sourceValue:name];
                        columnData.name = [SingleStockViewController formatFloatString:name style:stringStyle];
                    }
                }
                else {
                    columnData.name = @"--";
                }
                [cellData.columnData addObject:columnData];
                [columnData release];
                NSString* endline = [oneColumn valueForKey:Stockitem_singleStock_column_endline];
                if (endline&&[endline intValue]>0) {
                    [infoViewDataArray addObject:cellData];
                    cellData = [[[StockInfoCellData alloc] init] autorelease];
                }
            }
            else {
                StockInfoOneColumnData* columnData = [[StockInfoOneColumnData alloc] init];
                columnData.name = name;
                [cellData.columnData addObject:columnData];
                [columnData release];
                NSString* endline = [oneColumn valueForKey:Stockitem_singleStock_column_endline];
                if (endline&&[endline intValue]>0) {
                    [infoViewDataArray addObject:cellData];
                    cellData = [[[StockInfoCellData alloc] init] autorelease];
                }
            }
        }
        if ([cellData.columnData count]>0) {
            [infoViewDataArray addObject:cellData];
        }
        self.infoView.dataArray = infoViewDataArray;
        self.infoView.cellType = 1;
        [infoViewDataArray release];
        [self.infoView reloadData];
    }else if (_tab_index ==1){
        self.infoView.widthArray = widths2;
        NSLog(@"---------------------------------------------------------------------------");
        
        NSRange subRange = [[self.singleStockData dataString] rangeOfString: @"five"];
        
        if (subRange.location == NSNotFound) {
            NSLog(@"五档盘口字符串没有找到");
        } else {
            NSLog (@"找到的五档盘口字符串索引 %i 长度是 %i",
                   subRange.location, subRange.length);
        }
        
        NSArray *_fivesellDataArray = [[self.singleStockData  dataDict] objectForKey:StockFunc_SingleStockInfo_five_sell];
        NSArray *_fivebuyDataArray = [[self.singleStockData  dataDict] objectForKey:StockFunc_SingleStockInfo_five_buy];
//        [self.singleStockData valueForKey:StockFunc_SingleStockInfo_five_buy];
        NSArray *_columnArray = [curConfigDict valueForKey:Stockitem_singleStock_fivebubitem];
        NSLog(@"curConfigDict=%@=====%@",curConfigDict,_fivesellDataArray);
//     
//        
        int flag = 0;
//        
//        NSArray *_fivesellDataArray = [self.singleStockData valueForKey:StockFunc_SingleStockInfo_five_sell];
//        NSArray *_fivebuyDataArray = [self.singleStockData valueForKey:StockFunc_SingleStockInfo_five_buy];
//        
//        
//        
//        NSLog(@"_fivebuyDataArray= %@",_fivebuyDataArray);
// NSLog(@"%@-- ",columnArray);
        //五档盘口
        for (NSDictionary* oneColumn in _columnArray) {
            
            
            NSString* type = [oneColumn objectForKey:@"type"];
        
            if(![type isEqualToString:@"1"]) {
                //NSString* code = [oneColumn objectForKey:Stockitem_singleStock_column_code];
                
                NSString* key = [oneColumn objectForKey:@"key1"];
                
                //            NSLog(@"1111_fivesellDataArray =%@",_fivesellDataArray);
//                
                
                StockInfoOneColumnData* columnData = [[StockInfoOneColumnData alloc] init];
                NSString *_name= @"";
                int i=0;//数组索引
                if(flag%3==2 || flag%3==1){
                    i=flag/6;
                }
                
                int p = (flag - i*6)/3;
                
                //pre
                if (p==0) {
                    
                    NSDictionary *a = [_fivesellDataArray objectAtIndex:i];
                    
                    
                    if ([key isEqualToString:@"p"]) {
                        _name = [a objectForKey:key];
                        
                        if ([[a objectForKey:key] floatValue]== 0.00) {
                            columnData.fontColor = [UIColor whiteColor];
                        }else{
                            
                            if ([[a objectForKey:key] floatValue]>=last_close) {
                                columnData.fontColor = [UIColor redColor];
                            }else{
                                columnData.fontColor = [UIColor greenColor];
                            }
                        }
                        
                    }
                    
                    if ([key isEqualToString:@"v"]) {
                        _name =[NSString stringWithFormat:@"%d",(int)round([[a objectForKey:key] doubleValue]/100.0)];
//                        _name = [NSString stringWithFormat:@"%d",[[a objectForKey:key] intValue]/100];
                    }
                    
                    if (stockstatus_stop) {
                        _name = [NSString stringWithFormat:@"%@",@"--"];
                    }else{
                        
                        
                    }
                    
//                    NSLog(@"pre头3个label flag=%d   y=%d  v%@=%@",flag,i,key,_name);
                }
                
                
                //next
                if (p==1) {
                    NSDictionary *a = [_fivebuyDataArray objectAtIndex:i];
                    
                    if ([key isEqualToString:@"p"]) {
                        _name =[a objectForKey:key]  ;// [NSString stringWithFormat:@"%d",[[a objectForKey:key] intValue]/100];
//                        NSLog(@"next后3个label flag=%d   y=%d  v%@=%@",flag,i,key,_name);
                        if ([[a objectForKey:key] floatValue]== 0.00) {
                            columnData.fontColor = [UIColor whiteColor];
                        }else{
                            
                            if ([[a objectForKey:key] floatValue]>=last_close) {
                                columnData.fontColor = [UIColor redColor];
                            }else{
                                columnData.fontColor = [UIColor greenColor];
                            }
                        }
                        
                        
                    }
                    
                    if ([key isEqualToString:@"v"]) {
                        _name =[NSString stringWithFormat:@"%d",(int)round([[a objectForKey:key] doubleValue]/100.0)];
                        NSLog(@"next后3个label flag=%d   y=%d  v%@=%@",flag,i,key,_name);
                        
                    }
                    
                    if (stockstatus_stop) {
                        _name = [NSString stringWithFormat:@"%@",@"--"];
                    }else{
                    
                    
                    }
                }
//
                
                columnData.name = _name;
                
                [cellData.columnData addObject:columnData];
                [columnData release];
                if ([type isEqualToString:@"3"]) {
                    NSString* endline = [oneColumn objectForKey:Stockitem_singleStock_column_endline];
                    if (endline&&[endline intValue]>0) {
                        [infoViewDataArray addObject:cellData];
                        cellData = [[[StockInfoCellData alloc] init] autorelease];
                    }
                }
               
            }else{
                
                StockInfoOneColumnData* columnData = [[StockInfoOneColumnData alloc] init];
                 NSString* name = [oneColumn valueForKey:Stockitem_singleStock_column_name];
                columnData.name = name;
                
                
                [cellData.columnData addObject:columnData];
                [columnData release];
               
            }
            
            
            flag++;
        }
        if ([cellData.columnData count]>0) {
            [infoViewDataArray addObject:cellData];
        }
        self.infoView.dataArray = infoViewDataArray;
        self.infoView.cellType = 2
        ;
        [infoViewDataArray release];
        [self.infoView reloadData];
        
    }

}

-(void)formatInfoTabHeaderData{
//    NSDictionary* newsheaderDict = [self getCurNewsHeaderDict];
    NSDictionary* curConfigDict = [self getCurSubTypeConfigDict];
    
    NSArray* columnArray = [curConfigDict valueForKey:Stockitem_singleStock_infoTabName];
    NSArray* columnWidthArray = [curConfigDict valueForKey:Stockitem_singleStock_infoTabNameWidth];
    
//    NSLog(@"@@@@columnArray=%@",columnArray);
    if ([columnArray count]>0) {//如果有tab才加上tabheader视图
        if (!infoTabHeaderView) {
            infoTabHeaderView = [[UIView alloc] init];
            infoTabHeaderView.backgroundColor = [UIColor clearColor];
            infoTabHeaderView.frame  = CGRectMake(0, curContentHeight, 320, 30);
            infoTabHeaderView.backgroundColor = [UIColor colorWithRed:16.0/255 green:42.0/255 blue:89.0/255 alpha:1.0];
            
            UIImage* btnImage = [UIImage imageNamed:@"stock_tab_bg.png"];
            btnImage = [btnImage stretchableImageWithLeftCapWidth:20.0 topCapHeight:5.0];
            UIImage* btnImage1 = [UIImage imageNamed:@"stock_tab_bg_highlight.png"];
            btnImage1 = [btnImage1 stretchableImageWithLeftCapWidth:20.0 topCapHeight:5.0];
            
            NSInteger curleftOffset = 0;
        
            for (int i=0; i < [columnArray count]; i++) {
                NSString* tabName = [columnArray objectAtIndex:i];
                if (tabName) {
                    UIButton* btn2 = [[UIButton alloc] init];
                    btn2.frame = CGRectMake(curleftOffset+5
                                            , 2, [[columnWidthArray objectAtIndex:i] intValue], 26);
                    btn2.titleLabel.font = [UIFont systemFontOfSize:14.0];
                    [btn2 setTitle:tabName forState:UIControlStateNormal];
                    [btn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
                    [btn2 setBackgroundImage:btnImage1 forState:UIControlStateSelected];
                    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    btn2.tag = 20000+i;
                    [btn2 addTarget:self action:@selector(infoTabClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [infoTabHeaderView addSubview:btn2];
                    curleftOffset = btn2.frame.origin.x + btn2.frame.size.width;
                    [btn2 release];
                }
            }
            [backScrollView addSubview:infoTabHeaderView];
        }
        else
        {
            infoTabHeaderView.frame  = CGRectMake(0, curContentHeight, 320, 30);
        }
        
        curContentHeight = infoTabHeaderView.frame.origin.y + infoTabHeaderView.frame.size.height;
        
        if (stockSymbol) {
            if ([stockSymbol isEqualToString:@"sh000001"]||[stockSymbol isEqualToString:@"sz399001"]) {
                ((UIButton *)[self.view viewWithTag:20001]).hidden = YES;
            }
        }
        
        
        if(_tab_index ==0 ){
            ((UIButton *)[self.view viewWithTag:20000]).selected = YES;
            ((UIButton *)[self.view viewWithTag:20001]).selected = NO;
        }else if (_tab_index == 1){
            ((UIButton *)[self.view viewWithTag:20001]).selected = YES;
            ((UIButton *)[self.view viewWithTag:20000]).selected = NO;
            
        }
//
        [self initUI];
    }
}


-(void)infoTabClicked:(UIButton*)sender
{
    
    _tab_index = sender.tag - 20000;
 
    
    if (_tab_index == 1) {
        UIButton *d =( UIButton *)[self.view viewWithTag:20002];
        d.selected = NO;
    }
    
    switch (sender.tag ) {
        case 20000:
            ((UIButton *)[self.view viewWithTag:20001]).selected = NO;
        
        case 20001:
            ((UIButton *)[self.view viewWithTag:20000]).selected = NO;
            
            break;
            
        default:
            break;
    }
    
    sender.selected = YES;
    [self reloadTabContent];
}

-(NSString*)specilValueForCode:(NSString*)code sourceValue:(NSString*)sourceValue
{
    NSString* rtval = sourceValue;
    if ([self.stockType isEqualToString:@"us"]) {
        if ([code isEqualToString:@"volume"]) {
            rtval = [sourceValue stringByAppendingString:@"股"];
        }
    }
    else if ([self.stockType isEqualToString:@"hk"]) {
        if ([code isEqualToString:@"volume"]) {
            rtval = [sourceValue stringByAppendingString:@"股"];
        }
    }
    else if ([self.stockType isEqualToString:@"cn"]) {
        if ([code isEqualToString:@"volume"]) {
            rtval = [sourceValue stringByAppendingString:@"手"];
        }
    }
    else if ([self.stockType isEqualToString:@"fund"]) {
        if ([code isEqualToString:@"amount"]) {
            rtval = [sourceValue stringByAppendingString:@"手"];
        }
    }
    
    
    return rtval;
}

-(void)formatNewsHeaderData
{
    NSDictionary* newsheaderDict = [self getCurNewsHeaderDict];
    if ([self hasnewsheader]) {
        if (!newsHeaderView) {
            newsHeaderView = [[UIView alloc] init];
            newsHeaderView.backgroundColor = [UIColor clearColor];
            newsHeaderView.frame  = CGRectMake(0, curContentHeight, 320, 45);
            UIImage* newsHeaderImage = [UIImage imageNamed:@"stocknews_cell1_bg.png"];
            UIImageView* newsHeaderImageView = [[UIImageView alloc] initWithImage:newsHeaderImage];
            newsHeaderImageView.userInteractionEnabled = YES;
            newsHeaderImageView.frame = CGRectMake(5, 5, 310, 40);
            [newsHeaderView addSubview:newsHeaderImageView];
            [newsHeaderImageView release];
            
            UIImage* btnImage = [UIImage imageNamed:@"stock_single_btn.png"];
            btnImage = [btnImage stretchableImageWithLeftCapWidth:20.0 topCapHeight:5.0];
            UIImage* btnImage1 = [UIImage imageNamed:@"stock_content_bottom_leftbtn.png"];
            btnImage1 = [btnImage1 stretchableImageWithLeftCapWidth:20.0 topCapHeight:5.0];
            NSInteger curleftOffset = 0;
            NSString* hasnews = [newsheaderDict valueForKey:Stockitem_singleStock_hasnews];
            if (hasnews&&[hasnews intValue]>0) {
                UIButton* btn1 = [[UIButton alloc] init];
                btn1.frame = CGRectMake(curleftOffset+5+5, 5+10, 60, 25);
                btn1.titleLabel.font = [UIFont systemFontOfSize:14.0];
                [btn1 setTitle:@"相关新闻" forState:UIControlStateNormal];
                [btn1 setBackgroundImage:btnImage1 forState:UIControlStateSelected];
                [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn1.tag = 100011;
                [btn1 addTarget:self action:@selector(newsclicked:) forControlEvents:UIControlEventTouchUpInside];
                [newsHeaderView addSubview:btn1];
                curleftOffset = btn1.frame.origin.x + btn1.frame.size.width;
                [btn1 release];
            }
            
            NSString* hasreport = [newsheaderDict valueForKey:Stockitem_singleStock_hasreport];
            if (hasreport&&[hasreport intValue]>0) {
                UIButton* btn2 = [[UIButton alloc] init];
                btn2.frame = CGRectMake(curleftOffset+5+5, 5+10, 40, 25);
                btn2.titleLabel.font = [UIFont systemFontOfSize:14.0];
                [btn2 setTitle:@"研报" forState:UIControlStateNormal];
                [btn2 setBackgroundImage:btnImage1 forState:UIControlStateSelected];
                [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn2.tag = 100012;
                [btn2 addTarget:self action:@selector(newsclicked:) forControlEvents:UIControlEventTouchUpInside];
                [newsHeaderView addSubview:btn2];
                curleftOffset = btn2.frame.origin.x + btn2.frame.size.width;
                [btn2 release];
            }
            
            NSString* hasnotice = [newsheaderDict valueForKey:Stockitem_singleStock_hasnotice];
            if (hasnotice&&[hasnotice intValue]>0) {
                UIButton* btn3 = [[UIButton alloc] init];
                btn3.frame = CGRectMake(curleftOffset+5+5, 5+10, 40, 25);
                [btn3 setTitle:@"公告" forState:UIControlStateNormal];
                btn3.titleLabel.font = [UIFont systemFontOfSize:14.0];
                [btn3 setBackgroundImage:btnImage1 forState:UIControlStateSelected];
                [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btnImage = [btnImage stretchableImageWithLeftCapWidth:20.0 topCapHeight:20.0];
                btn3.tag = 100013;
                [btn3 addTarget:self action:@selector(newsclicked:) forControlEvents:UIControlEventTouchUpInside];
                [newsHeaderView addSubview:btn3];
                curleftOffset = btn3.frame.origin.x + btn3.frame.size.width;
                [btn3 release];
            }
            
            NSInteger currightOffset = newsHeaderImageView.frame.size.width;
            
            NSString* hasbar = [newsheaderDict valueForKey:Stockitem_singleStock_hasbar];
            if (hasbar&&[hasbar intValue]>0) {
                UIButton* btn5 = [[UIButton alloc] init];
                btn5.frame = CGRectMake(currightOffset - 5 - 40, 5+10, 40, 22);
                btn5.titleLabel.font = [UIFont systemFontOfSize:14.0];
                [btn5 setTitle:@"股吧" forState:UIControlStateNormal];
                [btn5 setTitleColor:[UIColor colorWithRed:84/255.0 green:99/255.0 blue:118/255.0 alpha:1.0] forState:UIControlStateNormal];
                [btn5 setBackgroundImage:btnImage forState:UIControlStateNormal];
                btn5.tag = 100015;
                [btn5 addTarget:self action:@selector(newsclicked:) forControlEvents:UIControlEventTouchUpInside];
                [newsHeaderView addSubview:btn5];
                currightOffset = btn5.frame.origin.x;
                [btn5 release];
            }
            
            NSString* hasremind = [newsheaderDict valueForKey:Stockitem_singleStock_hasremind];
            if (hasremind&&[hasremind intValue]>0) {
                UIButton* btn4 = [[UIButton alloc] init];
                btn4.frame = CGRectMake(currightOffset - 5 - 60, 5+10, 60, 22);
                btn4.titleLabel.font = [UIFont systemFontOfSize:14.0];
                [btn4 setTitle:@"股价提醒" forState:UIControlStateNormal];
                [btn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
                [btn4 setTitleColor:[UIColor colorWithRed:84/255.0 green:99/255.0 blue:118/255.0 alpha:1.0] forState:UIControlStateNormal];
                btn4.tag = 100014;
                [btn4 addTarget:self action:@selector(newsclicked:) forControlEvents:UIControlEventTouchUpInside];
                [newsHeaderView addSubview:btn4];
                currightOffset = btn4.frame.origin.x;
                [btn4 release];
            }
            
        }
        else
        {
            newsHeaderView.frame  = CGRectMake(0, curContentHeight, 320, 45);
        }
        [backScrollView addSubview:newsHeaderView];
        curContentHeight = newsHeaderView.frame.origin.y + newsHeaderView.frame.size.height;
    }
}

-(NSDictionary*)getCurSubTypeConfigDict
{
    NSDictionary* subTypeMatch = [self.singleConfigDict valueForKey:Stockitem_singleStock_subtypematch];
    NSMutableDictionary* curConfigDict = nil;
    if (subTypeMatch) {
        NSString* subTypeKey = [subTypeMatch valueForKey:self.subType];
        if (subTypeKey) {
            NSArray* subTypeItems = [self.singleConfigDict valueForKey:Stockitem_singleStock_subtypeitem];
            for (NSDictionary* subItem in subTypeItems) {
                NSString* typeItem = [subItem valueForKey:Stockitem_singleStock_typeitem];
                if (typeItem&&[typeItem isEqualToString:subTypeKey]) {
                    if (!curConfigDict) {
                        curConfigDict = [NSMutableDictionary dictionaryWithCapacity:0];
                    }
                    [curConfigDict addEntriesFromDictionary:subItem];
                    break;
                }
            }
        }
        if (curConfigDict) {
            NSArray* keyArray = [self.singleConfigDict allKeys];
            for (NSString* oneKey in keyArray) {
                if (![oneKey hasPrefix:@"subtype"]) {
                    [curConfigDict setValue:[self.singleConfigDict valueForKey:oneKey] forKey:oneKey];
                }
            }
        }
        return curConfigDict;
    }
    else {
        return self.singleConfigDict;
    }
}

+(NSString*)formatFloatString:(NSString*)sourceString style:(NSString*)style
{
    if ([style isEqualToString:@"%"]) {
        return [NSString stringWithFormat:@"%@%",sourceString];
    }
    else if ([style hasPrefix:@"."]) {
        style = [style substringFromIndex:1];
        NSString* suffixString = [style substringFromIndex:1];
        NSString* numString = [style substringToIndex:1];
        NSString* retString = nil;
        if ([numString intValue]==1) {
           retString = [NSString stringWithFormat:@"%.01f",[sourceString floatValue]];
        }
        else if ([numString intValue]==2){
            retString = [NSString stringWithFormat:@"%.02f",[sourceString floatValue]];
        }
        else if ([numString intValue]==3){
            retString = [NSString stringWithFormat:@"%.03f",[sourceString floatValue]];
        }
        else if ([numString intValue]==4){
            retString = [NSString stringWithFormat:@"%.04f",[sourceString floatValue]];
        }
        else if ([numString intValue]==5){
            retString = [NSString stringWithFormat:@"%.05f",[sourceString floatValue]];
        }
        else if ([numString intValue]==6){
            retString = [NSString stringWithFormat:@"%.06f",[sourceString floatValue]];
        }
        retString = [retString stringByAppendingString:suffixString];
        return retString;
    }
    else if([style hasPrefix:@"+."]){
        style = [style substringFromIndex:2];
        NSString* suffixString = [style substringFromIndex:1];
        NSString* numString = [style substringToIndex:1];
        NSString* retString = nil;
        if ([numString intValue]==1) {
            if ([sourceString floatValue]>0.0) {
                retString = [NSString stringWithFormat:@"+%.01f",[sourceString floatValue]];
            }
            else {
                retString = [NSString stringWithFormat:@"%.01f",[sourceString floatValue]];
            }
        }
        else if ([numString intValue]==2){
            if ([sourceString floatValue]>0.0)
            {
                retString = [NSString stringWithFormat:@"+%.02f",[sourceString floatValue]];
            }
            else {
                retString = [NSString stringWithFormat:@"%.02f",[sourceString floatValue]];
            }
        }
        else if ([numString intValue]==3){
            if ([sourceString floatValue]>0.0)
            {
                retString = [NSString stringWithFormat:@"+%.03f",[sourceString floatValue]];
            }
            else {
                retString = [NSString stringWithFormat:@"%.03f",[sourceString floatValue]];
            }
        }
        else if ([numString intValue]==4){
            if ([sourceString floatValue]>0.0)
            {
                retString = [NSString stringWithFormat:@"+%.04f",[sourceString floatValue]];
            }
            else {
                retString = [NSString stringWithFormat:@"%.04f",[sourceString floatValue]];
            }
        }
        else if ([numString intValue]==5){
            if ([sourceString floatValue]>0.0)
            {
                retString = [NSString stringWithFormat:@"+%.05f",[sourceString floatValue]];
            }
            else {
                retString = [NSString stringWithFormat:@"%.05f",[sourceString floatValue]];
            }
        }
        else if ([numString intValue]==6){
            if ([sourceString floatValue]>0.0)
            {
                retString = [NSString stringWithFormat:@"+%.06f",[sourceString floatValue]];
            }
            else {
                retString = [NSString stringWithFormat:@"%.06f",[sourceString floatValue]];
            }
        }
        retString = [retString stringByAppendingString:suffixString];
        return retString;
    }
    else if ([style intValue]==0) {
        return sourceString;
    }
    else if([style intValue]==1)
    {
        return [Util formatBigNumber:sourceString];
    }
}

#pragma mark -
#pragma mark RefreshTable
-(void)newsclicked:(UIButton*)sender
{
    
    NSInteger tag = sender.tag;
    NSInteger index = 0;
    if (tag==100011) {
        index = 0;
        if ([[self.stockType lowercaseString] isEqualToString:@"cn"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"relevant_news_A"];
        }
        else if ([[self.stockType lowercaseString] isEqualToString:@"us"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"relevant_news_US"];
        }
        else if ([[self.stockType lowercaseString] isEqualToString:@"hk"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"relevant_news_HK"];
        }
        
    }
    else if(tag==100012)
    {
        index = 1;
        if ([[self.stockType lowercaseString] isEqualToString:@"cn"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"research_report_A"];
        }
    }
    else if(tag==100013)
    {
        index = 2;
        if ([[self.stockType lowercaseString] isEqualToString:@"cn"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"public_notice_A"];
        }
        else if ([[self.stockType lowercaseString] isEqualToString:@"hk"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"public_notice_HK"];
        }
    }
    else if(tag==100014)
    {
        index = 3;
        if ([[self.stockType lowercaseString] isEqualToString:@"cn"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"stock_remind_A"];
        }
        else if ([[self.stockType lowercaseString] isEqualToString:@"us"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"stock_remind_US"];
        }
        else if ([[self.stockType lowercaseString] isEqualToString:@"hk"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"stock_remind_HK"];
        }
    }
    else if(tag==100015)
    {
        index = 4;
        if ([[self.stockType lowercaseString] isEqualToString:@"cn"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"shares_A"];
        }
    }
    [self startInitWithindex:index];

}

-(void)startInitWithindex:(NSInteger)index
{
    curIndex = index;
    if (curIndex==0) {
        UIButton* btn0 = (UIButton*)[self.newsHeaderView viewWithTag:100011];
        btn0.selected = YES;
        UIButton* btn1 = (UIButton*)[self.newsHeaderView viewWithTag:100012];
        btn1.selected = NO;
        UIButton* btn2 = (UIButton*)[self.newsHeaderView viewWithTag:100013];
        btn2.selected = NO;
        NSString* keyString = StockRelateNewsKey;
        [selectID removeAllObjects];
        [selectID addObject:keyString];
        [self startRefreshNewsTable:NO firstReload:YES scrollTop:NO];
    }
    else if(curIndex==1)
    {
        UIButton* btn0 = (UIButton*)[self.newsHeaderView viewWithTag:100011];
        btn0.selected = NO;
        UIButton* btn1 = (UIButton*)[self.newsHeaderView viewWithTag:100012];
        btn1.selected = YES;
        UIButton* btn2 = (UIButton*)[self.newsHeaderView viewWithTag:100013];
        btn2.selected = NO;
        NSString* keyString = StockReportKey;
        [selectID removeAllObjects];
        [selectID addObject:keyString];
        [self startRefreshNewsTable:NO firstReload:YES scrollTop:NO];
    }
    else if(curIndex==2)
    {
        UIButton* btn0 = (UIButton*)[self.newsHeaderView viewWithTag:100011];
        btn0.selected = NO;
        UIButton* btn1 = (UIButton*)[self.newsHeaderView viewWithTag:100012];
        btn1.selected = NO;
        UIButton* btn2 = (UIButton*)[self.newsHeaderView viewWithTag:100013];
        btn2.selected = YES;
        NSString* keyString = StockNoticeKey;
        [selectID removeAllObjects];
        [selectID addObject:keyString];
        [self startRefreshNewsTable:NO firstReload:YES scrollTop:NO];
    }
    else if(curIndex==3)
    {
        [self stopedtip];
         
        [self showPushTixingAddView];
        
        UIButton* btn2 = (UIButton*)[self.newsHeaderView viewWithTag:100014];
        btn2.enabled = NO;
 
//        [[AppDelegate sharedApplication].keyWindow addSubview:pushController.view];
//        [self.navigationController pushViewController:pushController animated:YES];
        [pushController release];
    }
    else if(curIndex==4)
    {
        [self stopedtip];
        BarStockListViewController* stockController = [[BarStockListViewController alloc] init];
        
        stockController.stockName = self.stockSymbol;
        stockController.stockNick = self.stockName;
        NSString* bid = [singleStockData valueForKey:@"bid"];
        stockController.bid = bid;
        [self.navigationController pushViewController:stockController animated:YES];
        [stockController release];
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

-(void)startRefreshNewsTable:(BOOL)bForce firstReload:(BOOL)bReload scrollTop:(BOOL)bScrollTop
{
    BOOL needRefresh = NO;
    if (bForce) {
        needRefresh = YES;
    }
    else
    {
        needRefresh = [self checkRefreshByDate];
    }
    if (bReload) {
        NSNumber* pageNumber = [self.dataList infoValueWithIDList:self.selectID ForKey:@"page"];
        if (pageNumber) {
            curPage = [pageNumber intValue];
        }
        else
        {
            curPage = 1;
        }
        self.backTableView.selectID = self.selectID;
        if (bScrollTop) {
            [self.backTableView scrollTop:NO];
        }
        [self.backTableView setPageMode:PageCellType_Normal];
        [self.backTableView reloadData];
    }
    
    if (self.selectID&&[self.selectID count]>0) {
        if (needRefresh) {
            if (bScrollTop) {
                [self.backTableView startLoadingUI];
            }
            NSNumber* bScrollTopNumber = [NSNumber numberWithBool:bScrollTop];
            NSString* modeKey = [selectID objectAtIndex:0];
            if ([modeKey isEqualToString:StockRelateNewsKey]) {
                [[StockFuncPuller getInstance] startOneStockNewsWithSender:self count:countPerPage page:1 type:self.stockType symbol:self.stockSymbol args:self.selectID dataList:self.dataList userInfo:bScrollTopNumber];
            }
            else if([modeKey isEqualToString:StockReportKey])
            {
                if ([[self.stockType lowercaseString] isEqualToString:@"cn"]) {
                    [[StockFuncPuller getInstance] startOneCnStockReportWithSender:self count:countPerPage page:1 symbol:self.stockSymbol args:self.selectID dataList:self.dataList userInfo:bScrollTopNumber];
                }
            }
            else if([modeKey isEqualToString:StockNoticeKey])
            {
                if ([[self.stockType lowercaseString] isEqualToString:@"cn"]) {
                    [[StockFuncPuller getInstance] startOneCnStockNoticeWithSender:self count:countPerPage page:1 symbol:self.stockSymbol args:self.selectID dataList:self.dataList userInfo:bScrollTopNumber];
                }
                else if ([[self.stockType lowercaseString] isEqualToString:@"hk"]) {
                    [[StockFuncPuller getInstance] startOneHKStockNoticeWithSender:self count:countPerPage page:1 symbol:self.stockSymbol args:self.selectID dataList:self.dataList userInfo:bScrollTopNumber];
                }
            }
        }
    }
}

#pragma mark -
#pragma mark DataListTableView
-(UITableViewCell*)dataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    NSString *NewsCellIdentifier = [NSString stringWithFormat:@"NewsCellIdentifier"];
    NewsTableViewCell *cell = (NewsTableViewCell*)[view.tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
    if(cell == nil){
        cell = [[[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.line.hidden = YES;
        cell.leftrightMargin = 8;
        UIImage* backImage = [UIImage imageNamed:@"stocknews_cell2_bg.png"];
        UIImageView* backImageView = [[UIImageView alloc] initWithImage:backImage];
        CGRect backImageRect = CGRectMake(5, 0, 310, 46);
        backImageView.frame = backImageRect;
        [cell.contentView addSubview:backImageView];
        [cell.contentView sendSubviewToBack:backImageView];
        [backImageView release];
    }
    NSNumber* hasRead = [object userInfoValueForKey:NewsHasReadKey];
    if(!hasRead||![hasRead boolValue]){
        cell.readIcon.hidden = NO;
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.dateLabel.textColor = [UIColor colorWithRed:154.0/255 green:154.0/255 blue:154.0/255 alpha:1.0];
        cell.sourceLabel.textColor = [UIColor colorWithRed:154.0/255 green:154.0/255 blue:154.0/255 alpha:1.0];
    }
    else{
        cell.readIcon.hidden = YES;
        cell.titleLabel.textColor = [UIColor colorWithRed:135.0/255 green:135.0/255 blue:135.0/255 alpha:1.0];
        cell.dateLabel.textColor = [UIColor colorWithRed:120.0/255 green:120.0/255 blue:120.0/255 alpha:1.0];
        cell.sourceLabel.textColor = [UIColor colorWithRed:120.0/255 green:120.0/255 blue:120.0/255 alpha:1.0];
    }
    
    NSArray* oldID = view.selectID;
    NSString* modeKey = [oldID objectAtIndex:0];
    if ([modeKey isEqualToString:StockRelateNewsKey]) {
        NSString *title = [object valueForKey:StockFunc_News_short_title];
        if (!title||[title length]==0) {
            title = [object valueForKey:StockFunc_News_title];
        }
        if(title){
            cell.titleLabel.text = title;
        }
        else {
            cell.titleLabel.text = @"";
        }
        NSString *dateString = [object valueForKey:StockFunc_News_createDate];
        NSString* timeString = [object valueForKey:StockFunc_News_createTime];
        
        NSString* temString = [timeString substringToIndex:5];
        
        dateString = [dateString stringByAppendingFormat:@" %@",temString];
        if (dateString) {
            NSString* conmentsStr = dateString;
            cell.sourceLabel.text = conmentsStr;
            [cell.sourceLabel sizeToFit];
            CGRect sourceRect = cell.sourceLabel.bounds;
            sourceRect.origin.x = view.tableView.bounds.size.width - sourceRect.size.width - 10;
            sourceRect.origin.y = 28;
            cell.sourceLabel.frame = sourceRect;
        }
        else {
            cell.sourceLabel.text = @"";
        }
        NSString* commentsCount = [object valueForKey:StockFunc_News_media_source];
        if (commentsCount) {
            cell.dateLabel.text = @"";//commentsCount;
        }
        else {
            cell.dateLabel.text = @"";
        }
        
        CGRect f = cell.sourceLabel.frame;
        f.origin.x = 18;
        cell.sourceLabel.frame = f;
    }
    else if([modeKey isEqualToString:StockReportKey])
    {
        cell.titleLabel.text = [object valueForKey:StockFunc_CNReport_title];
        NSString* dateString = [object valueForKey:StockFunc_CNReport_createDate];
        if (dateString) {
            NSString* conmentsStr = dateString;
            cell.sourceLabel.text = conmentsStr;
            [cell.sourceLabel sizeToFit];
            CGRect sourceRect = cell.sourceLabel.bounds;
            sourceRect.origin.x = view.tableView.bounds.size.width - sourceRect.size.width - 10;
            sourceRect.origin.y = 28;
            cell.sourceLabel.frame = sourceRect;
        }
        else {
            cell.sourceLabel.text = @"";
        }
        NSString* commentsCount = [object valueForKey:StockFunc_CNReport_author];
        if (commentsCount) {
            cell.dateLabel.text = commentsCount;
        }
        else {
            cell.dateLabel.text = @"";
        }
        
    }
    else if([modeKey isEqualToString:StockNoticeKey])
    {
        if ([[self.stockType lowercaseString] isEqualToString:@"hk"]) {
            cell.titleLabel.text = [object valueForKey:StockFunc_HKNotice_title];
            NSString* dateString = [object valueForKey:StockFunc_HKNotice_publishdate];
            NSString* temString = [dateString substringToIndex:16];
            
            if (dateString) {
                NSString* conmentsStr = temString;
                cell.sourceLabel.text = conmentsStr;
                [cell.sourceLabel sizeToFit];
                CGRect sourceRect = cell.sourceLabel.bounds;
                sourceRect.origin.x = view.tableView.bounds.size.width - sourceRect.size.width - 10;
                sourceRect.origin.y = 28;
                cell.sourceLabel.frame = sourceRect;
            }
            else {
                cell.sourceLabel.text = @"";
            }
            NSString* commentsCount = [object valueForKey:StockFunc_CNNotice_origin];
            if (commentsCount) {
                cell.dateLabel.text = commentsCount;
            }
            else {
                cell.dateLabel.text = @"";
            }
            
            CGRect f = cell.sourceLabel.frame;
            f.origin.x = 18;
            cell.sourceLabel.frame = f;
            
            CGRect f1 = cell.dateLabel.frame;
            f.origin.x = 18;
            cell.dateLabel.frame = f1;
            
        }
        else {
            NSLog(@"%@:%@",stockName,stockSymbol);
            NSString *title = [NSString stringWithFormat:@"%@:%@",stockName,[object valueForKey:StockFunc_CNNotice_stitle]];
            cell.titleLabel.text = title;
            NSString* dateString = [object valueForKey:StockFunc_CNNotice_createDate];
            NSString* temString = [dateString substringToIndex:16];
            if (dateString) {
                NSString* conmentsStr = temString;
                cell.sourceLabel.text = conmentsStr;
                [cell.sourceLabel sizeToFit];
                CGRect sourceRect = cell.sourceLabel.bounds;
                sourceRect.origin.x = view.tableView.bounds.size.width - sourceRect.size.width - 10;
                sourceRect.origin.y = 25;
                cell.sourceLabel.frame = sourceRect;
            }
            else {
                cell.sourceLabel.text = @"";
            }
            NSString* commentsCount = [object valueForKey:StockFunc_CNNotice_origin];
            if (commentsCount) {
                cell.dateLabel.text = @"";//commentsCount;
            }
            else {
                cell.dateLabel.text = @"";
            }
            
            CGRect f = cell.sourceLabel.frame;
            f.origin.x = 18;
            cell.sourceLabel.frame = f;
            
            CGRect f1 = cell.dateLabel.frame;
            f.origin.x = 18;
            cell.dateLabel.frame = f1;
        }
    }
    
    return cell; 
}

-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    return 46.0;
}

-(void)dataListView:(DataListTableView*)view didSelectedAtIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    NSNumber* hasRead = [object userInfoValueForKey:NewsHasReadKey];
    if (!hasRead) {
        [object setUserInfoValue:[NSNumber numberWithBool:YES] forKey:NewsHasReadKey];
        [object refreshToDataBase];
        [view.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    }
    [view.tableView deselectRowAtIndexPath:path animated:YES];
    
    NSArray* oldID = view.selectID;
    NSString* modeKey = [oldID objectAtIndex:0];
    if ([modeKey isEqualToString:StockRelateNewsKey]) {
        [self stopedtip];
        NSString* urlstring = [object valueForKey:StockFunc_News_url];
        NewsContentViewController2* contentController = [[NewsContentViewController2 alloc] initWithNewsURL2:urlstring];
        contentController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contentController animated:YES];
        [contentController release];
    }
    else if([modeKey isEqualToString:StockReportKey])
    {
        [self stopedtip];
        NSString* aid = [object valueForKey:StockFunc_CNReport_aid];
        StockContentViewController* controller = [[StockContentViewController alloc] initWithsymbol:self.stockSymbol aid:aid type:StockContent_CNReport];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else if([modeKey isEqualToString:StockNoticeKey])
    {
        [self stopedtip];
        if ([[self.stockType lowercaseString] isEqualToString:@"cn"]) {
            NSString* aid = [object valueForKey:StockFunc_CNNotice_aid];
            StockContentViewController* controller = [[StockContentViewController alloc] initWithsymbol:self.stockSymbol aid:aid type:StockContent_CNNotice];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
        else if([[self.stockType lowercaseString] isEqualToString:@"hk"])
        {
            NSString* aid = [object valueForKey:StockFunc_HKNotice_aid];
            StockContentViewController* controller = [[StockContentViewController alloc] initWithsymbol:self.stockSymbol aid:aid type:StockContent_HKNotice];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
    }
}

-(void)dataListViewDidMoreClicked:(DataListTableView*)view
{
    NSNumber* bScrollTopNumber = [NSNumber numberWithBool:NO];
    if ([view.selectID count]>0) {
        NSString* modeKey = [view.selectID objectAtIndex:0];
        if ([modeKey isEqualToString:StockRelateNewsKey]) {
            [[StockFuncPuller getInstance] startOneStockNewsWithSender:self count:countPerPage page:curPage+1 type:self.stockType symbol:self.stockSymbol args:self.selectID dataList:self.dataList userInfo:bScrollTopNumber];
        }
        else if([modeKey isEqualToString:StockReportKey])
        {
            if ([[self.stockType lowercaseString] isEqualToString:@"cn"]) {
                [[StockFuncPuller getInstance] startOneCnStockReportWithSender:self count:countPerPage page:curPage+1 symbol:self.stockSymbol args:self.selectID dataList:self.dataList userInfo:bScrollTopNumber];
            }
        }
        else if([modeKey isEqualToString:StockNoticeKey])
        {
            if ([[self.stockType lowercaseString] isEqualToString:@"cn"]) {
                [[StockFuncPuller getInstance] startOneCnStockNoticeWithSender:self count:countPerPage page:curPage+1 symbol:self.stockSymbol args:self.selectID dataList:self.dataList userInfo:bScrollTopNumber];
            }
            else if ([[self.stockType lowercaseString] isEqualToString:@"hk"]) {
                [[StockFuncPuller getInstance] startOneHKStockNoticeWithSender:self count:countPerPage page:curPage+1 symbol:self.stockSymbol args:self.selectID dataList:self.dataList userInfo:bScrollTopNumber];
            }
        }
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
    [rtval setTipColor:[UIColor whiteColor] forType:PageCellType_Normal];
    [rtval setTipColor:[UIColor whiteColor] forType:PageCellType_Ending];
    return rtval;
}

-(void)disappearPushTixingAddView{
    [self.pushController.view setHidden:YES];
    _hasPushTixingAddView = NO;
    [self startRefreshTable];
    UIButton* btn2 = (UIButton*)[self.newsHeaderView viewWithTag:100014];
    btn2.enabled = YES;
}

-(void)showPushTixingAddView{
    
    [SVProgressHUD showInView:self.view status:@"正在加载股价提醒信息..."];
    
    self.pushController = [[PushTixingAddViewController alloc] init];
    pushController.delegate = self;
    pushController.needTab = NO;
    pushController.singleSymbol = self.stockSymbol;
    pushController.view.tag = 100012;
    _hasPushTixingAddView = YES;
    
    [[[UIApplication sharedApplication].delegate window] addSubview:pushController.view];
//    [self.view addSubview:pushController.view];
}



@end
