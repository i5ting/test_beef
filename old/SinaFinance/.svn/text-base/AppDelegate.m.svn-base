
//
//  AppDelegate.m
//  SinaFinance
//
//  Created by Du Dan on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsViewController.h"
#import "NewsIndexViewController.h"
#import "SettingsViewController.h"
#import "SearchViewController.h"
#import "MoreViewController.h"
#import "WeiboViewController.h"
#import "BCViewController.h"
#import "ShareData.h"
#import "SaveData.h"
#import "Reachability.h"
#import "WeiboLoginManager.h"
#import "MyTabBarController.h"
#import "UpdateModule.h"
#import "StockViewController.h"
#import "ASIFormDataRequest.h"
#import "RegValueSaver.h"
#import "StockFuncPuller.h"
#import "PushViewController.h"
#import "MyTool.h"
#import "StockFuncPuller.h"
#import "ProjectLogUploader.h"
#import "NewHandScroll.h"
#import "LKTipCenter.h"
#import "JSONConfigDownloader.h"
#import "NewsContentViewController2.h"
#import "MobClick.h"
#import "StockListViewController2.h"


#define UMENG_KEY @"50c6dd3852701546820000e1"

NSString* PushEnabledKey = @"PushEnabledKey";
NSString* PushDeviceTokenKey = @"PushDeviceTokenKey";
NSString *PushStartupFailedNotification = @"PushStartupFailedNotification";
NSString* PushValueChangedNotification = @"PushValueChangedNotification";
NSString* NewsPushArrivedNotification = @"NewsPushArrivedNotification";
NSString* NewHandKey = @"NewHandKey";
NSString* ReachabilityChangedNotification = @"ReachabilityChangedNotification";

@interface AppDelegate ()
@property (nonatomic, retain) NSArray* savedOrderArray;
@property (nonatomic, retain) NSArray* sourceTabArray;
@property (nonatomic, retain) NSArray* sourceControllerArray;
@property (nonatomic, retain) NewHandScroll* handScroll;
@end

@implementation AppDelegate
{
    BOOL hasStartPush;
    BOOL bInitedWithRemind;
    BOOL normalViewShowed;
    BOOL needHideNewHandView;
    BOOL bWillForceground;
    NewHandScroll* handScroll;
    NSTimer *_timer;
    PushViewController *_pushController;
    HQViewController *_hqViewController;
}

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize pushDict;
@synthesize savedOrderArray,sourceTabArray,sourceControllerArray;
@synthesize remindIDList;//news
@synthesize tixingIDList;//tixing
@synthesize handScroll;

//
//
//static AppDelegate *_appDelegate;
//+ (AppDelegate*)sharedAppDelegate
//{
//    return _appDelegate;
//}

+ (AppDelegate *)sharedAppDelegate {
    static AppDelegate *sharedAppDelegate = nil;
    
    static dispatch_once_t predicate; dispatch_once(&predicate, ^{
        sharedAppDelegate = [[self alloc] init];
    });
    
    return sharedAppDelegate;
}

+(void)initialize
{
	NSNumber* pushEnabledNumber = [[RegValueSaver getInstance] readSystemInfoForKey:PushEnabledKey];
	if (pushEnabledNumber==nil) {
		pushEnabledNumber = [NSNumber numberWithBool:YES];
        [[RegValueSaver getInstance] saveSystemInfoValue:pushEnabledNumber forKey:PushEnabledKey encryptString:NO];
	}
    NSNumber* colordata = (NSNumber*)[SaveData getDataForKey:SETTINGS_COLOR_KEY];
    if (!colordata) {
        //如果没有颜色配置文件的话，默认为NO
        [SaveData saveDataForKey:SETTINGS_COLOR_KEY data:[NSNumber numberWithBool:NO]];
    }
}

-(id)init
{
    self = [super init];
    if (self) {
        [self initNotification];
        remindIDList = [[CommentDataList alloc] init];
        remindIDList.dataTableName = @"remindnews";
        
        
    }
    return self;
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [pushDict release];
    [savedOrderArray release];
    [sourceTabArray release];
    [sourceControllerArray release];
    [remindIDList release];
    [handScroll release];
    [_pushController release];
    
    [super dealloc];
}

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self 
		   selector:@selector(PushValueChangedSuccess:) 
			   name:PushValueChangedNotification 
			 object:nil];
    
    [nc addObserver:self 
		   selector:@selector(StockLoginSuccessed:) 
			   name:LoginSuccessedNotification 
			 object:nil];
    
    [nc addObserver:self 
		   selector:@selector(StockLogoutSuccessed:) 
			   name:LogoutSuccessedNotification 
			 object:nil];
    
    [nc addObserver:self 
		   selector:@selector(TopTipStarted:) 
			   name:TopTipStartNotification 
			 object:nil];
    
    [nc addObserver:self 
		   selector:@selector(TopTipEnded:) 
			   name:TopTipEndNotification 
			 object:nil];
    
    [nc addObserver:self 
		   selector:@selector(UIWindowDidBecomeVisible:) 
			   name:UIWindowDidBecomeVisibleNotification 
			 object:nil];
    
    [nc addObserver:self
		   selector:@selector(UIWindowDidBecomeVisible:) 
			   name:UIWindowDidBecomeKeyNotification 
			 object:nil];
    
    [nc addObserver:self
		   selector:@selector(initTabToPushController:)
			   name:@"initTabToPushController"
			 object:nil];
    
    
}

-(void)StockLoginSuccessed:(NSNotification*)notify
{
    NSString* deviceToken = [[RegValueSaver getInstance] readSystemInfoForKey:PushDeviceTokenKey];
    [self realStartPushRequst:YES withToken:deviceToken];
}

-(void)StockLogoutSuccessed:(NSNotification*)notify
{
    NSString* deviceToken = [[RegValueSaver getInstance] readSystemInfoForKey:PushDeviceTokenKey];
    [self realStartPushRequst:NO withToken:deviceToken];
}

-(void)TopTipStarted:(NSNotification*)notify
{
    [self adjustTabBarFrame];
}

-(void)TopTipEnded:(NSNotification*)notify
{
    [self adjustTabBarFrame];
}

-(void)UIWindowDidBecomeVisible:(NSNotification*)notify
{
    [self performSelector:@selector(adjustTabBarFrame) withObject:nil afterDelay:0.01];
}

-(void)adjustTabBarFrame
{
    CGRect appRect = [[UIScreen mainScreen] bounds];
    appRect.origin.y = 20.1; //只能这么写，写20.0会被系统判断掉，造成顶部遮挡
    appRect.size.height -= appRect.origin.y;
    self.tabBarController.view.frame = appRect;
    self.tabBarController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

#pragma mark
#pragma mark CHECK NETWORK METHODS
- (BOOL)checkNetworkAvailable
{
    //if(internetReach == nil)
    {
        internetReach = [[Reachability reachabilityForInternetConnection] retain];
        //    [internetReach startNotifier];
        //    [[NSNotificationCenter defaultCenter] addObserver: self 
        //                                             selector: @selector(reachabilityChanged:) 
        //                                                 name: kReachabilityChangedNotification 
        //                                               object: nil];
    }
    [internetReach startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(reachabilityChanged:) 
                                                 name: kReachabilityChangedNotification 
                                               object: nil];
    NetworkStatus remoteHostStatus = [internetReach currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable){
        NSLog(@"NotReachable");
        return NO;
    }
    NSLog(@"Reachable");
    return YES;
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            [ShareData sharedManager].isNetworkAvailable = YES;
            break;
        }
        case ReachableViaWiFi:
        {
            [ShareData sharedManager].isNetworkAvailable = YES;
            break;
        }
        case NotReachable:
        {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time. Some functionality will be limited until a connection is made." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            //            [alert show];
            //            [alert release];
            [ShareData sharedManager].isNetworkAvailable = NO;
            break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:ReachabilityChangedNotification object:nil];
}

- (void)saveAppData
{
//    NSLog(@"MyStockUserName: %@", [ShareData sharedManager].myStockUserName);
    [SaveData saveDataForKey:MYSTOCK_CNGROUP_KEY data:[ShareData sharedManager].myStockAGroup];
    [SaveData saveDataForKey:MYSTOCK_USGROUP_KEY data:[ShareData sharedManager].myStockUSGroup];
    [SaveData saveDataForKey:MYSTOCK_HKGROUP_KEY data:[ShareData sharedManager].myStockHKGroup];
    [SaveData saveDataForKey:MYSTOCK_FUNDGROUP_KEY data:[ShareData sharedManager].myFundGroup];
    [SaveData saveDataForKey:SETTINGS_COLOR_KEY data:[NSNumber numberWithBool:[ShareData sharedManager].isColorSetted]];
    [SaveData saveDataForKey:SETTINGS_INTERVAL_KEY data:[NSNumber numberWithInt:[ShareData sharedManager].refreshInterval]];
//    [SaveData saveDataForKey:SETTINGS_WEIBOEMAIL_KEY data:[ShareData sharedManager].weiboEmail];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     [self clear_news_to_already_read_array_when_app_exit];
    [PushUtils push_application:application didFinishLaunchingWithOptions:launchOptions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushArrive:) name:@"ReceiPushArrivedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offlineReceiPushArrivedNotification:) name:@"offlineReceiPushArrivedNotification" object:nil];
    
    [ShareData sharedManager].isNetworkAvailable = [self checkNetworkAvailable];
//    NSLog(@"[ShareData sharedManager].isNetworkAvailable: %d",[ShareData sharedManager].isNetworkAvailable);
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    NSDictionary *remoteNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
//    remoteNotif = [MyTool dictFromDocumentFolder:@"remote" fileName:@"push"];
    bInitedWithRemind = [self verifyPushInfo:remoteNotif];
#ifdef DEBUG
    if (bInitedWithRemind) {
        NSMutableDictionary* newRemoteNotif = [[NSMutableDictionary alloc] initWithDictionary:remoteNotif];
        NSString* intervalString = [remoteNotif valueForKey:@"time"];
        if (intervalString) {
            intervalString = [[NSNumber numberWithInt:[intervalString intValue] + 100] stringValue];
            [newRemoteNotif setValue:intervalString forKey:@"time"];
        }

        [MyTool writeToDocument:newRemoteNotif folder:@"remote" fileName:@"push"];
        [newRemoteNotif release];
    }
#endif
    [self showNormalView];
    if (bInitedWithRemind) {
        [self addPushInfo:remoteNotif];
         [self performSelector:@selector(showNewContent) withObject:nil afterDelay:2.0];
    }
    BOOL needShowNewHand = [self showNewHandView];
    if (needShowNewHand) {
        self.tabBarController.view.alpha = 0.0;
    }
    
    // Override point for customization after application launch;
    
    [self checkPushNotification];
    
    //获取节日信息
    [[StockFuncPuller getInstance] getAllHolidayData];
    
    [[WeiboLoginManager getInstance ] setAppKey:@"809359998"];
    [[WeiboLoginManager getInstance ] setAppSecret:@"16eb6b6412f503c2bb90803fe256a57b"];
    [[WeiboLoginManager getInstance] startLogin:nil force:YES];
    [[UpdateModule getInstance]setUpdateDomain:@"http://m.sina.com.cn/js/5/20120119/7.json"];
    [[UpdateModule getInstance] startup];
    [[ProjectLogUploader getInstance] setAppKey:@"3346933778"];
    [[ProjectLogUploader getInstance] startup];
    [[JSONConfigDownloader getInstance] startup];
#ifdef DEBUG
    [[JSONConfigDownloader getInstance] setTestMode:YES];
#endif
    
    
    
    if (_timer ) {
        [_timer  invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(getStockStatus) userInfo:nil repeats:YES];
    
  //  [MobClick startWithAppkey:UMENG_KEY]
//#ifdef DEBUG
    [MobClick startWithAppkey:UMENG_KEY reportPolicy:REALTIME channelId:nil];
    [MobClick updateOnlineConfig];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
//#endif
    
    [self setNewspushedCount];
    
    
//    open_umeng_flag 
//    debug_detail_show
   
   NSString *p2 = [MobClick getConfigParams:@"debug_detail_show"];
//    NSLog(@"umeng param :{open_umeng_flag = %@ - debug_detail_show = %@}",p1,p2);
    [self update_push_xinwen_count_num];
    [self update_push_tixing_count_num];
    
    [self dump];
    
    return YES;
}


- (void)onlineConfigCallBack:(NSNotification *)notification {
    NSLog(@"online config has fininshed and params = %@", notification.userInfo);
}



-(void)getStockStatus{
//     [[StockFuncPuller getInstance] startStockListWithSender:self type:requestTypeString symbol:symbol count:countPerPage page:1 args:self.selectID dataList:self.dataList userInfo:bScrollTopNumber];
    //获取节日信息
    [[StockFuncPuller getInstance] getStockStatusData];
    
}


-(void)setNewspushedCount{
    //for 要闻数据设置
    [self update_push_xinwen_count_num];
    
    //for 提醒数据设置
    [self update_push_tixing_count_num];
    //[[[PushNewsViewController alloc] init] autorelease];
}

-(void)pushArrive:(NSNotification*)notify{

    NSDictionary* userInfo = [notify userInfo];
    //收到的push消息，userInfo：push里服务器传递的相关信息，这个信息是由公司服务器自己设定的。可以在这里处理一些逻辑
    
    //    if (bWillForceground) {
    //        [self initTabController:ret remindData:nil needInit:NO];
    //        [self performSelector:@selector(adjustTabBarFrame) withObject:nil afterDelay:0.01];
    //    }
    //    [self addPushInfo:userInfo];
    //
    
    NSString* typeString = [userInfo valueForKey:@"type"];
    NSString* symbol = [userInfo valueForKey:@"symbol"];

    if ([typeString intValue]==2) {
        
    }
    else {
//        [[AppDelegate sharedAppDelegate] initPushTab];
        
        NSString* urlStr = [userInfo objectForKey:@"hash"];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:urlStr forKey:@"push_url"];
        
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isnotBackground"]) {
            [[LKTipCenter defaultCenter] postTopTipWithMessage:@"有新的头条新闻到达!" time:2.0 color:nil];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"消息提示" message:@"当前有未读头条新闻，是否立即查看？" delegate:self cancelButtonTitle:@"否" otherButtonTitles: @"是", nil] autorelease];
            alert.tag = 10001;
            [alert show];
        }else{
            
            //        [self showNewContent];
        }

    }
       
    //
}

-(void)offlineReceiPushArrivedNotification:(NSNotification*)notify{
    
    NSDictionary* userInfo = [notify userInfo];
    //收到的push消息，userInfo：push里服务器传递的相关信息，这个信息是由公司服务器自己设定的。可以在这里处理一些逻辑
    
    //    if (bWillForceground) {
    //        [self initTabController:ret remindData:nil needInit:NO];
    //        [self performSelector:@selector(adjustTabBarFrame) withObject:nil afterDelay:0.01];
    //    }
    //    [self addPushInfo:userInfo];
    //
    
    [[AppDelegate sharedAppDelegate] initPushTab];
    
//    NSString* urlStr = @"http://finance.sina.com.cn/stock/quanshang/zyzg/20121018/144813408682.shtml";
    
    NSString* typeString = [userInfo valueForKey:@"type"];
    NSString* symbol = [userInfo valueForKey:@"symbol"];
    
    if ([typeString intValue]==2) {
        
    }
    else {
            
        NSString* urlStr = [userInfo objectForKey:@"hash"];
        [[NSUserDefaults standardUserDefaults] setObject:urlStr forKey:@"push_url"];
        
        
      
        [self performSelector:@selector(showNewContent) withObject:nil afterDelay:2.0];

    }
}




-(BOOL)showNewHandView
{
    BOOL rtval = NO;
    NSNumber* newHandNumber = [[RegValueSaver getInstance] readSystemInfoForKey:NewHandKey];
    if (!newHandNumber||![newHandNumber boolValue]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        CGRect ScreenBounds = [[UIScreen mainScreen] bounds];
        NewHandScroll* scroll = [[NewHandScroll alloc] initWithFrame:ScreenBounds];
        self.handScroll = scroll;
        scroll.delegate = self;
        [self.window addSubview:scroll];
        [self.window makeKeyAndVisible];
        [scroll release];
        rtval = YES;
    }
    
    return rtval;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x>scrollView.frame.size.width*3 + 40) {
        needHideNewHandView = YES;
        
        //[self performSelector:@selector(showNormalView) withObject:nil afterDelay:0.001];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    static BOOL hasDealedHide = NO;
    if (needHideNewHandView&&!hasDealedHide) {
        hasDealedHide = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(newHandOver)];
        scrollView.userInteractionEnabled = NO;
        scrollView.alpha = 0.0;
        self.tabBarController.view.alpha = 1.0;
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    static BOOL hasDealedHide = NO;
    if (needHideNewHandView&&!hasDealedHide) {
        hasDealedHide = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(newHandOver)];
        scrollView.userInteractionEnabled = NO;
        scrollView.alpha = 0.0;
        self.tabBarController.view.alpha = 1.0;
        [UIView commitAnimations];
    }
}

-(void)newHandOver
{
    [self.handScroll removeFromSuperview];
    self.handScroll.delegate = nil;
    self.handScroll = nil;
    [[RegValueSaver getInstance] saveSystemInfoValue:[NSNumber numberWithInt:YES] forKey:NewHandKey encryptString:NO];
}

-(void)showNormalView
{
    if (!normalViewShowed) {
        normalViewShowed = YES;
        [self initTabController:bInitedWithRemind remindData:nil needInit:YES];
        self.window.rootViewController = self.tabBarController;
        [self.window makeKeyAndVisible];
        
        //NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
        //[dict setObject:@"mobile_news_1014@sina.com" forKey:Key_Login_Username];
        //[dict setObject:@"MOBILEnews!)!$@" forKey:Key_Login_Password];
        
    }
    
}


-(NSArray*)tabOrderArray
{
    if (!savedOrderArray) {
        NSArray* orderArray = [[RegValueSaver getInstance] readSystemInfoForKey:@"taborder"];
        if (!orderArray) {
            NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:0];
            AdjustOrderData* adjustData = [[AdjustOrderData alloc] init];
            adjustData.key = NSStringFromClass([NewsViewController class]);
            adjustData.value = @"新闻";
            [newArray addObject:adjustData];
            [adjustData release];
            
            adjustData = [[AdjustOrderData alloc] init];
            adjustData.key = NSStringFromClass([HQViewController class]);
            adjustData.value = @"自选";
            [newArray addObject:adjustData];
            [adjustData release];
            
            
            adjustData = [[AdjustOrderData alloc] init];
            adjustData.key = NSStringFromClass([StockViewController class]);
            adjustData.value = @"行情";
            [newArray addObject:adjustData];
            [adjustData release];
            
            
            adjustData = [[AdjustOrderData alloc] init];
            adjustData.key = NSStringFromClass([SearchViewController class]);
            adjustData.value = @"搜索";
            [newArray addObject:adjustData];
            [adjustData release];
            
            adjustData = [[AdjustOrderData alloc] init];
            adjustData.key = NSStringFromClass([WeiboViewController class]);
            adjustData.value = @"微博";
            [newArray addObject:adjustData];
            [adjustData release];
      
            
            adjustData = [[AdjustOrderData alloc] init];
            adjustData.key = NSStringFromClass([SettingsViewController class]);
            adjustData.value = @"设置";
            [newArray addObject:adjustData];
            [adjustData release];
            
            orderArray = newArray;
        }
        else
        {
            NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:0];
            for (NSData* oneData in orderArray) {
                [newArray addObject:[AdjustOrderData dataWithData:oneData]];
            }
            orderArray = newArray;
            
        }
        self.savedOrderArray = orderArray;
    }
    
    return savedOrderArray;
}

-(void)setTabOrderArray:(NSArray *)tabOrderArray
{
    NSMutableArray* arrayForSave = [[NSMutableArray alloc] initWithCapacity:0];
    for (AdjustOrderData* oneData in tabOrderArray) {
        [arrayForSave addObject:oneData.savableData];
    }
    [[RegValueSaver getInstance] saveSystemInfoValue:arrayForSave forKey:@"taborder" encryptString:NO];
    [arrayForSave release];
    self.savedOrderArray = tabOrderArray;
    [self initTabController:NO remindData:nil needInit:YES];
    
}

-(void)initTabController:(BOOL)fromRemind remindData:(id)data needInit:(BOOL)needInit
{
    
    if (self.tabBarController==nil) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *controllerArray = [[NSMutableArray alloc] initWithCapacity:0];
        _tabBarController = [[MyTabBarController alloc] init];
        
        
        //self.tabBarController.tabBar.rightArrowImage = [UIImage imageNamed:@"arr_bottom.png"];
        
        //self.tabBarController.tabBar.backgroundColor = [UIColor colorWithRed:0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7];
        self.tabBarController.tabBarHeight = 50.0;
        UIImage* bottomImage = [UIImage imageNamed:@"tabbar_bg.png"];
        self.tabBarController.bctabBar.backgroundImage = bottomImage;
        
        self.tabBarController.bctabBar.rightArrowImage = [UIImage imageNamed:@"arr_header.png"];
        self.tabBarController.bctabBar.leftArrowImage = [UIImage imageNamed:@"arr_header_left.png"];
        self.tabBarController.bctabBar.selectedAlignment = AlignmentStyle_Bottom;
        self.tabBarController.bctabBar.tabMargin = 0;
        self.tabBarController.bctabBar.arrowCoverScroll = YES;
        self.tabBarController.showFullZone = YES;
        self.tabBarController.bctabBar.showedMaxItem = 6;
        self.tabBarController.delegate = self;
        
        BCNavigationController *tmpController = nil;
        NewsViewController *newsController = [[NewsViewController alloc] init];
        tmpController = [[BCNavigationController alloc] initWithRootViewController:newsController];
        [newsController release];
        tmpController.tabBarImage = [UIImage imageNamed:@"tabbar_news.png"];;
        tmpController.tabBarHighlyImage = [UIImage imageNamed:@"tabbar_news_selected.png"];
        //tmpController.tabBarTitle = @"新闻";
        [array addObject:tmpController];
        [controllerArray addObject:newsController];
        [tmpController release];
        
    
        HQViewController *stockController = [[HQViewController alloc] init];
        stockController.hidesBottomBarWhenPushed = YES;
        tmpController = [[BCNavigationController alloc] initWithRootViewController:stockController];
        [stockController release];
        tmpController.tabBarImage = [UIImage imageNamed:@"tabbar_mystock.png"];;
        tmpController.tabBarHighlyImage = [UIImage imageNamed:@"tabbar_mystock_selected.png"];
        _hqViewController = stockController;
        //tmpController.tabBarTitle = @"新闻";
        [array addObject:tmpController];
        [controllerArray addObject:stockController];
        [tmpController release];
        
        
        
        StockViewController *pushController = [[StockViewController alloc] init];
        tmpController = [[BCNavigationController alloc] initWithRootViewController:pushController];
        [pushController release];
        tmpController.tabBarImage = [UIImage imageNamed:@"tabbar_stock.png"];;
        tmpController.tabBarHighlyImage = [UIImage imageNamed:@"tabbar_stock_selected.png"];
        //tmpController.tabBarTitle = @"新闻";
        [array addObject:tmpController];
        [controllerArray addObject:pushController];
        
        _pushController = pushController;
        [tmpController release];
        
        SearchViewController *searchController = [[SearchViewController alloc] init];
        tmpController = [[BCNavigationController alloc] initWithRootViewController:searchController];
        [searchController release];
        tmpController.tabBarImage = [UIImage imageNamed:@"tabbar_search.png"];;
        tmpController.tabBarHighlyImage = [UIImage imageNamed:@"tabbar_search_selected.png"];
        //tmpController.tabBarTitle = @"新闻";
        [array addObject:tmpController];
        [controllerArray addObject:searchController];
        [tmpController release];
        
        WeiboViewController *weiboController = [[WeiboViewController alloc] init];
        tmpController = [[BCNavigationController alloc] initWithRootViewController:weiboController];
        [weiboController release];
        tmpController.tabBarImage = [UIImage imageNamed:@"tabbar_weibo.png"];;
        tmpController.tabBarHighlyImage = [UIImage imageNamed:@"tabbar_weibo_selected.png"];
        //tmpController.tabBarTitle = @"新闻";
        [array addObject:tmpController];
        [controllerArray addObject:weiboController];
        [tmpController release];
      
        
        SettingsViewController *settitngController = [[SettingsViewController alloc] init];
        tmpController = [[BCNavigationController alloc] initWithRootViewController:settitngController];
        [settitngController release];
        tmpController.tabBarImage = [UIImage imageNamed:@"tabbar_setting.png"];;
        tmpController.tabBarHighlyImage = [UIImage imageNamed:@"tabbar_setting_selected.png"];
        //tmpController.tabBarTitle = @"新闻";
        [array addObject:tmpController];
        [controllerArray addObject:settitngController];
        [tmpController release];
        
        self.sourceTabArray = array;
        self.sourceControllerArray = controllerArray;
        [array release];
        [controllerArray release];
    }
    [self adjustOrderTabController:fromRemind remindData:data needInit:needInit];
}

-(void)adjustOrderTabController:(BOOL)fromRemind remindData:(id)data needInit:(BOOL)needInit
{   
    NSArray *array = self.sourceTabArray;
    NSArray *controllerArray = self.sourceControllerArray;
    NSMutableArray* destTabArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray* orderArray = self.tabOrderArray;
    if (orderArray) {
        for (int i=0;i<[orderArray count];i++) {
            AdjustOrderData* data = [orderArray objectAtIndex:i];
            if (data.type==AdjustOrderType_abled) {
                if (array) {
                    for (int j=0;j<[array count];j++) {
                        UIViewController* controller = [array objectAtIndex:j];
                        UIViewController* topController = [controllerArray objectAtIndex:j];
                        NSString* classString = NSStringFromClass([topController class]);
                        if ([classString isEqualToString:data.key]) {
                            [destTabArray addObject:controller];
                            break;
                        }
                    }
                }
            }
        }
        
        UIViewController* newSelectedController = nil;
        if (!fromRemind) {
            UIViewController* selectedController = self.tabBarController.bcselectedViewController;
            if (selectedController) {
                UIViewController* topController = selectedController;
                if ([selectedController isKindOfClass:[BCNavigationController class]]) {
                    NSInteger index = [array indexOfObject:selectedController];
                    topController = [controllerArray objectAtIndex:index];
                } 
                NSString* selectedString = NSStringFromClass([topController class]);
                for (UIViewController* controller in destTabArray) {
                    topController = controller;
                    if ([controller isKindOfClass:[BCNavigationController class]]) {
                        NSInteger index = [array indexOfObject:controller];
                        topController = [controllerArray objectAtIndex:index];
                    } 
                    NSString* classString = NSStringFromClass([topController class]);
                    if ([classString isEqualToString:selectedString]) {
                        newSelectedController = controller;
                        break;
                    }
                }
            }
        }
        else
        {
            BCNavigationController* bcController = (BCNavigationController*)[self.tabBarController rotatebcselectedViewController];
            [bcController popToRootViewControllerAnimated:NO];
            UIViewController* topController = nil;
            for (UIViewController* controller in destTabArray) {
                topController = controller;
                if ([controller isKindOfClass:[BCNavigationController class]]) {
                    NSInteger index = [array indexOfObject:controller];
                    topController = [controllerArray objectAtIndex:index];
                } 
                if ([topController isKindOfClass:[PushViewController class]]) {
                    newSelectedController = controller;
                    break;
                }
            }
        }
        if (needInit) {
            [self.tabBarController setViewControllers:destTabArray selectedController:newSelectedController];
        }
        else
        {
            [self.tabBarController setSelectedViewController:newSelectedController];
        }
        
        [destTabArray release];
    }
}

-(void)controller:(BCTabBarController*)controller index:(NSInteger)index clickedByBtn:(BOOL)byBtn
{
    if (byBtn) {
        if (index==0) {
            [[ProjectLogUploader getInstance] writeDataString:@"navigation_news"];
        }
        else if(index==1)
        {
            [[ProjectLogUploader getInstance] writeDataString:@"navigation_quotation"];
        }
        else if(index==2)
        {
            [[ProjectLogUploader getInstance] writeDataString:@"navigation_search"];
        }
        else if(index==3)
        {
            [[ProjectLogUploader getInstance] writeDataString:@"navigation_weibo"];
        }
        else if(index==4)
        {
            [[ProjectLogUploader getInstance] writeDataString:@"navigation_remind"];
        }
    }
}

-(UIViewController*)findControllerOfClass:(NSString*)classString
{
    UIViewController* rtval = nil;
    NSArray *array = self.sourceTabArray;
    for (UIViewController* controller in array)
    {
        UIViewController* topController = controller;
        if ([controller isKindOfClass:[BCNavigationController class]]) {
            topController = [[(BCNavigationController*)controller viewControllers] objectAtIndex:0];
        }
        NSString* oldClassString = NSStringFromClass([topController class]);
        if ([oldClassString isEqualToString:classString]) {
            rtval = topController;
            break;
        }
    }
    return rtval;
}

-(BOOL)verifyPushInfo:(NSDictionary*)userInfo
{
    BOOL rtval = NO;
    if (userInfo) {
        NSDictionary* apsDict = [userInfo valueForKey:@"aps"];
        if (apsDict) {
            rtval = YES;
        }
    }
    return rtval;
}

-(BOOL)addPushInfo:(NSDictionary*)userInfo
{
    [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"hash"] forKey:@"push_url"];
#ifdef DEBUG
    NSDictionary* tempInfo = [MyTool dictFromDocumentFolder:@"remote" fileName:@"pushstock"];
    if (tempInfo) {
        userInfo = tempInfo;
    }
#endif
    [MyTool writeToDocument:userInfo folder:@"test" fileName:@"test111.txt"];
    for (UIViewController* controller in self.sourceControllerArray) {
        if ([controller isKindOfClass:[PushViewController class]]) {
            PushViewController* push = (PushViewController*)controller;
            push.view.alpha = 1.0;//用来推送之前初始化推送窗口
        }
    }
    BOOL rtval = NO;
    if (userInfo) {
        NSLog(@"test dict=%@",userInfo);
        NSMutableDictionary* apsDict =[NSMutableDictionary dictionaryWithDictionary:[userInfo valueForKey:@"aps"]];

        [apsDict setValue:[userInfo objectForKey:@"hash"] forKey:@"hash"];
        
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isnotBackground"]) {
            [self showNewContent];
        }
        
        
        if (apsDict) {
            self.pushDict = userInfo;
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [dict addEntriesFromDictionary:apsDict];
            NSString* typeString = [userInfo valueForKey:@"type"];
            NSString* symbol = [userInfo valueForKey:@"symbol"];
            NSString* intervalString = [userInfo valueForKey:@"time"];
            if (!intervalString) {
                intervalString = @"0";
            }
            NSString* alert = [dict valueForKey:@"alert"];
            double intervaldouble = [intervalString doubleValue];
            if (intervalString) {
                [dict setValue:[NSNumber numberWithInt:intervaldouble] forKey:@"interval"];
            }
            NewsObject* oneObject = [[NewsObject alloc] initWithJsonDictionary:dict];
            [dict release];
            BOOL bSkip = NO;
            if ([typeString intValue]==2) {
                [self save_push_tixing_count_num:oneObject andIntervalDouble:intervaldouble andBSkip:bSkip andAlertString:alert];
            }
            else {
                [self save_push_news_count_num:oneObject andIntervalDouble:intervaldouble andBSkip:bSkip andAlertString:alert];
//                [remindIDList reloadShowedDataWithIDList:nil];
//                NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:0];
//                NSArray* dataArray = [remindIDList contentsWithIDList:nil];
//                if ([dataArray count] > 0) {
//                    BOOL hasAdded = NO;
//                    for (int i=0; i<[dataArray count]; i++) {
//                        NewsObject* oldObject = [dataArray objectAtIndex:i];
//                        NSString* oldAlert = [oldObject valueForKey:@"alert"];
//                        NSString* timeString = [oldObject valueForKey:@"interval"];
//                        if (!timeString) {
//                            timeString = @"0";
//                        }
//                        double oldIntervalDouble = [timeString doubleValue];
//                        if (oldIntervalDouble>intervaldouble&&!hasAdded) {
//                            [newArray addObject:oneObject];
//                            [newArray addObject:oldObject];
//                            hasAdded = YES;
//                        }
//                        else {
//                            [newArray addObject:oldObject];
//                            if (oldIntervalDouble==intervaldouble) {
//                                if ((!oldAlert&&!alert)||([oldAlert isEqualToString:alert])) {
//                                    bSkip = YES;
//                                }
//                            }
//                        }
//                        if (!bSkip) {
//                            if (i==[dataArray count]-1&&!hasAdded) {
//                                [newArray addObject:oneObject];
//                            }
//                        }
//                    }
//                }
//                else {
//                    [newArray addObject:oneObject];
//                }
//                
//                [remindIDList refreshCommnetContents:newArray IDList:nil];
//                [newArray release];
//                
                
            }
            [oneObject release];
            
            NSMutableDictionary* typeDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            if (typeString) {
                [typeDict setValue:typeString forKey:@"type"];
            }
            [typeDict setValue:symbol forKey:@"symbol"];
            
            if (!bSkip) {
                if ([typeString intValue]==2) {
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isnotBackground"]) {
                        [[LKTipCenter defaultCenter] postTopTipWithMessage:@"有新的股价提醒到达!" time:2.0 color:nil];
                        UIAlertView *alert2 = [[[UIAlertView alloc] initWithTitle:@"消息提示" message:@"新的股价提醒，是否立即查看？" delegate:self cancelButtonTitle:@"否" otherButtonTitles: @"是", nil] autorelease];
                        alert2.tag = 10002;
                        [alert2 show];
                    }else{
                        [self showTixingPush:typeDict];
                    }
                    
                }
                else {
                    [[LKTipCenter defaultCenter] postTopTipWithMessage:@"有新的头条新闻到达!" time:2.0 color:nil];
                }
            } 
          
//            [[NSNotificationCenter defaultCenter] postNotificationName:NewsPushArrivedNotification object:nil userInfo:typeDict];
            
            
           
            [[NSUserDefaults standardUserDefaults] setObject:typeDict forKey:@"tixing_push_dict"];
            [[AppDelegate sharedAppDelegate] update_push_tixing_count_num];
            
            [typeDict release];
            rtval = YES;
        }
        //开始清除系统中的推送通知
//        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//        NSString* sysVersion = [[UIDevice currentDevice] systemVersion];
//        if ([sysVersion floatValue]>=4.0) {
//            [[UIApplication sharedApplication] cancelAllLocalNotifications];
//        }
        //结束清除系统中的推送通知
    }
    
    return rtval;
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
     BOOL ret = [self verifyPushInfo:userInfo];
    
    [PushUtils push_application:application didReceiveRemoteNotification:userInfo];
     [self addPushInfo:userInfo];
//    [self initPushTab];
    [[ProjectLogUploader getInstance] writeDataString:@"push_open_app"];
}


-(void)initTabToPushController:(NSNotification*)notify
{
    [self initTabController:YES remindData:nil needInit:YES];
    [self.tabBarController tabBar:self.tabBarController didSelectTabAtIndex:4 byBtn:YES];
}

-(void)showTixingPush:(NSDictionary *)userInfo{
    [self update_push_tixing_count_num];
    if ([userInfo count]>0) {
        NSLog(@"initPushTab=%@",@"initPushTab");
//        [self initTabController:YES remindData:nil needInit:YES];
//        [remindIDList reloadShowedDataWithIDList:nil];
//        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
//        [tabBarController setTabBarHiden:YES];
//        [tabBarController tabBar:self.tabBarController.bctabBar
//             didSelectTabAtIndex:4 byBtn:YES];
//        
//        for (UIViewController* controller in self.sourceControllerArray) {
//            if ([controller isKindOfClass:[PushViewController class]]) {
//                PushViewController* push = (PushViewController*)controller;
//                push.view.alpha = 1.0;//用来推送之前初始化推送窗口
//            }
//        }
//        [_pushController showTixingPush:userInfo] ;
        
      
        int i = self.tabBarController.selectedIndex;
        UIViewController* controller = [self.sourceControllerArray objectAtIndex:i];
        
        NSString *symbol = [userInfo objectForKey:@"symbol"];
        [controller showTixingContent:symbol];
        //
        if ([controller isKindOfClass:[PushViewController class]]) {
            [controller selectTabByIndex:0];
        }
        
    }
  
}

-(void)showNewContent{
    [self update_push_xinwen_count_num];
//    [self initPushTab];
//    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
//    [tabBarController setTabBarHiden:YES];
//    [tabBarController tabBar:self.tabBarController
//         didSelectTabAtIndex:4 byBtn:YES];
//    [_pushController showNewContent] ;
    
    int i = self.tabBarController.selectedIndex;
    UIViewController* controller = [self.sourceControllerArray objectAtIndex:i];
    
    
    [controller showNewContent];
//    
    if ([controller isKindOfClass:[PushViewController class]]) {
        [controller selectTabByIndex:1];
    }
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==10001) {
        if (buttonIndex == 1) {
            [self showNewContent];
            //点击阅读的时候，更新已读记录列表
            [self update_latest_push_xinwen_count_num_already_readed];
        }else{
            //不查看推送的头条新闻
        }
    }
    
    
    if (alertView.tag==10002) {
        
        if (buttonIndex == 1) {
            NSDictionary *typeDict = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"tixing_push_dict"];
            [self showTixingPush:typeDict];
            [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"tixing_push_dict"];
        }else{
            //不查看推送的头条新闻
        }
         
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isnotBackground"];
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[ShareData sharedManager] networkStopNotifier];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [self saveAppData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
//    [ShareData sharedManager].isNetworkAvailable = [[ShareData sharedManager] checkNetworkAvailable];
    bWillForceground = YES;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isnotBackground"];
    
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [ShareData sharedManager].isNetworkAvailable = [self checkNetworkAvailable];
    NSLog(@"[ShareData sharedManager].isNetworkAvailable:%d",[ShareData sharedManager].isNetworkAvailable);
    [[ProjectLogUploader getInstance] refreshSID];
    bWillForceground = NO;
    
//    NSDictionary* remoteNotif = [MyTool dictFromDocumentFolder:@"remote" fileName:@"push"];
//    BOOL ret = [self addPushInfo:remoteNotif];
//    [self initTabController:ret needInit:NO];
//    [self performSelector:@selector(adjustTabBarFrame) withObject:nil afterDelay:0.01];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   
//    [[ShareData sharedManager] networkStopNotifier];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isnotBackground"];
    [self saveAppData];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

-(void)checkPushNotification
{
	NSNumber* pushEnabledNumber = [[RegValueSaver getInstance] readSystemInfoForKey:PushEnabledKey];
	BOOL pushEnabled = [pushEnabledNumber boolValue];
	[self startupPushService:pushEnabled];
}

-(void)launchFromNotification:(NSNotification*)note
{
	;
}

-(void)PushValueChangedSuccess:(NSNotification*)note
{
	NSNumber* pushEnabledNumber = [note object];
	BOOL pushEnabled = [pushEnabledNumber boolValue];
	[self startupPushService:pushEnabled];
}

-(void)startupPushService:(BOOL)pushEnabled
{
	UIRemoteNotificationType rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
	if (pushEnabled) {
		if (rntypes==0) {
			UIRemoteNotificationType which = (UIRemoteNotificationType)(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound);
			[[UIApplication sharedApplication] registerForRemoteNotificationTypes:which];
            BOOL isSimulator = [MyTool isSimulator];
            if (isSimulator) {
                [self realStartPushRequst:YES withToken:@"f1d1fca1008fd0d46df32b0fdf11ecdf9d52e2d32e1db0c0cb677e6ae7835623"];
            }
		}
        else
        {
            UIRemoteNotificationType which = (UIRemoteNotificationType)(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound);
			[[UIApplication sharedApplication] registerForRemoteNotificationTypes:which];
            BOOL isSimulator = [MyTool isSimulator];
            if (isSimulator) {
                [self realStartPushRequst:YES withToken:@"f1d1fca1008fd0d46df32b0fdf11ecdf9d52e2d32e1db0c0cb677e6ae7835623"];
            }
        }
	}
	else {
		if (rntypes!=0) {
			[[UIApplication sharedApplication] unregisterForRemoteNotifications];
		}
        NSString* deviceToken = [[RegValueSaver getInstance] readSystemInfoForKey:PushDeviceTokenKey];
        [self realStartPushRequst:NO withToken:deviceToken];
        hasStartPush = NO;
	}
}

// Retrieve the device token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    NSString *deviceToken = [[[[devToken description] 
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""] 
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
    [[RegValueSaver getInstance] saveSystemInfoValue:deviceToken forKey:PushDeviceTokenKey encryptString:YES];
    [self realStartPushRequst:YES withToken:deviceToken];
    NSLog(@"test shit:%@",[MyTool encryptPwd:deviceToken]);
#ifdef DEBUG
    NSLog(@"test shit2:%@",deviceToken);
#endif
    hasStartPush = YES;
}

-(void)realStartPushRequst:(BOOL)start withToken:(NSString*)deviceToken
{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
	// Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
	NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
	
	// Set the defaults to disabled unless we find otherwise...
	NSString *pushBadge = (rntypes & UIRemoteNotificationTypeBadge) ? @"enabled" : @"disabled";
	NSString *pushAlert = (rntypes & UIRemoteNotificationTypeAlert) ? @"enabled" : @"disabled";
	NSString *pushSound = (rntypes & UIRemoteNotificationTypeSound) ? @"enabled" : @"disabled";	
    BOOL isSimulator = [MyTool isSimulator];
    if (isSimulator) {
        pushBadge = @"enabled";
        pushAlert = @"enabled";
        pushSound = @"enabled";
    }
	
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
	UIDevice *dev = [UIDevice currentDevice];
    
	NSString *deviceName = dev.name;
	NSString *deviceModel = dev.model;
	NSString *deviceSystemVersion = dev.systemVersion;
	
	// Prepare the Device Token for Registration (remove spaces and < >)
	
    NSURL* url = [NSURL URLWithString:@"http://api.sina.com.cn/client.php?s=apns&a=register"];
    ASIFormDataRequest* request = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    
    [request addPostValue:@"fed68838-071c-ef1f-8adc-d8fa-3ea476e2" forKey:@"auth_value"];
    
    [request addPostValue:@"json" forKey:@"format"];
    [request addPostValue:@"utf-8" forKey:@"ie"];
    [request addPostValue:deviceToken forKey:@"devicetoken"];
    [request addPostValue:deviceName forKey:@"devicename"];
    [request addPostValue:deviceModel forKey:@"devicemodel"];
    [request addPostValue:deviceSystemVersion forKey:@"deviceversion"];
    [request addPostValue:pushBadge forKey:@"pushbadge"];
    [request addPostValue:pushAlert forKey:@"pushalert"];
    [request addPostValue:pushSound forKey:@"pushsound"];
    [request addPostValue:appVersion forKey:@"appversion"];
    NSString* uid = [[WeiboLoginManager getInstance] loginedID];
    if (uid&&[uid length]>0) {
        [request addPostValue:uid forKey:@"appuid"];
    }
    else {
        [request addPostValue:@"0" forKey:@"appuid"];
    }
    
    [request startAsynchronous];
    if ([[WeiboLoginManager getInstance] hasLogined]) {
        NSString* device = [[RegValueSaver getInstance] readSystemInfoForKey:PushDeviceTokenKey];
        [[StockFuncPuller getInstance] startStockRemindStartupWithSender:self device:device bOn:start userInfo:nil];
    }
} 

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString* ret = request.responseString;
    NSLog(@"ret=%@",ret);
}

- (void)requestFailed:(ASIHTTPRequest*)request
{
    NSString* ret = request.responseString;
    NSLog(@"ret=%@",ret);
}

// Provide a user explanation for when the registration fails
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error 
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError=%@",error.description);
    
    hasStartPush = NO;
    NSNumber* pushEnabledNumber = [NSNumber numberWithBool:NO];
    [[RegValueSaver getInstance] saveSystemInfoValue:pushEnabledNumber forKey:PushEnabledKey encryptString:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PushStartupFailedNotification object:nil];
    
    NSString* tip = [NSString stringWithString:@"无法启动推送，请检查网络后重试。"];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" 
												  message:tip 
												 delegate:nil
										cancelButtonTitle:@"确定"  
										otherButtonTitles:nil];
	[alert show];
	[alert release];
    
    /*
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	
	// Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
	
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
	UIDevice *dev = [UIDevice currentDevice];
    
	NSString *deviceName = dev.name;
	NSString *deviceModel = dev.model;
	NSString *deviceSystemVersion = dev.systemVersion;
    NSURL* url = [NSURL URLWithString:@"http://roll.news.sina.com.cn/api/apns/"];
    ASIFormDataRequest* request = [[[ASIFormDataRequest alloc] initWithURL:url] autorelease];
    request.delegate = self;
    [request setRequestMethod:@"POST"];
    
    [request addPostValue:@"uuid" forKey:@"auth_type"];
    [request addPostValue:@"fed68838-071c-ef1f-8adc-d8fa-3ea476e2" forKey:@"auth_value"];
    [request addPostValue:@"json" forKey:@"format"];
    [request addPostValue:@"utf-8" forKey:@"ie"];
    [request addPostValue:@"register" forKey:@"task"];
    [request addPostValue:appName forKey:@"appname"];
    [request addPostValue:appVersion forKey:@"appversion"];
    [request addPostValue:deviceName forKey:@"devicename"];
    [request addPostValue:deviceModel forKey:@"devicemodel"];
    [request addPostValue:deviceSystemVersion forKey:@"deviceversion"];
    [request addPostValue:@"0" forKey:@"appuid"];
    [request addPostValue:@"disabled" forKey:@"status"];
#ifdef DEBUG
    [request addPostValue:@"sandbox" forKey:@"development"];
#else
    [request addPostValue:@"production" forKey:@"development"];
#endif
    [request startAsynchronous];
     */
}


-(int)getTabId{
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    return tabBarController.selectedIndex;
}

-(void)gotoTabWithIndex:(int)i{
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];

    [tabBarController setTabBarHiden:NO];
    [tabBarController tabBar:self.tabBarController.bctabBar
         didSelectTabAtIndex:i byBtn:YES];
}

-(void)reInitTab{
     [self initTabController:NO remindData:nil needInit:YES];
}

-(void)resetHQviewController{
//    [_hqViewController reload];
}


-(void)update_push_tixing_count_num{

    
    
    int count = 0;
    NSArray* is_read_data_array = (NSArray*)[SaveData getDataForKey:[Util get_tixing_has_readed_file_name] ];
    if (!is_read_data_array) {
        count = 0;
    }else{
        int i = 0;
        for (NSString *str in is_read_data_array) {
            if ([str isEqualToString:@"n"]) {//n代表未读
                count ++;
            }
            i++;
        }
    }
    int real_count = count>0 ? count : 0;
     
    
    
    CommentDataList *datalist = [[CommentDataList alloc] init];
    datalist.dataTableName = [Util get_tixing_has_readed_file_name];
    
    NSMutableArray* curSelectID = [[NSMutableArray alloc] initWithCapacity:0];
    //        我的提醒,
    //        StockRemindHistoryKey,
    //        1171794780
    [curSelectID addObject:@"我的提醒"];
    [curSelectID addObject:@"StockRemindHistoryKey"];
    NSString* loginID = [[WeiboLoginManager getInstance] loginedID];
    
    if (!loginID) {
        loginID = @"0";
    }
    [curSelectID addObject:loginID];
    
    
    [datalist reloadShowedDataWithIDList:curSelectID];
    NSArray *a2 = [datalist contentsWithIDList:curSelectID];
    //    NSLog(@"--%@",a2);
    NSLog(@"INFO:当前未读股价提醒有 ：%d 条！",real_count);
    [[NSUserDefaults standardUserDefaults] setInteger:real_count forKey:PUSH_CUR_COUNT_TIXING];
    
    
     
    
//    TODO:  modify and implement in PushNewsViewController
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_push_tixing_count_num_no" object:nil];
    
    
}



-(void)save_push_tixing_count_num:(NewsObject *)oneObject andIntervalDouble:(double)intervaldouble andBSkip:(BOOL)bSkip andAlertString:(NSString *)alert{
    
    CommentDataList *datalist = [[CommentDataList alloc] init];
    datalist.dataTableName = [Util get_tixing_has_readed_file_name];
    
    NSMutableArray* curSelectID = [[NSMutableArray alloc] initWithCapacity:0];
    //        我的提醒,
    //        StockRemindHistoryKey,
    //        1171794780
    [curSelectID addObject:@"我的提醒"];
    [curSelectID addObject:@"StockRemindHistoryKey"];
    NSString* loginID = [[WeiboLoginManager getInstance] loginedID];
    
    if (!loginID) {
        loginID = @"0";
    }
    [curSelectID addObject:loginID];
    
    
    [ datalist reloadShowedDataWithIDList:curSelectID];
    NSArray *dataArray = [datalist contentsWithIDList:curSelectID];
 
    NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:0];

 
    
    if ([dataArray count] > 0) {
        BOOL hasAdded = NO;
        for (int i=0; i<[dataArray count]; i++) {
            NewsObject* oldObject = [dataArray objectAtIndex:i];
            NSString* oldAlert = [oldObject valueForKey:@"alert"];
            NSString* timeString = [oldObject valueForKey:@"interval"];
            if (!timeString) {
                timeString = @"0";
            }
            double oldIntervalDouble = [timeString doubleValue];
            if (oldIntervalDouble>intervaldouble&&!hasAdded) {
                [newArray addObject:oneObject];
                [newArray addObject:oldObject];
                hasAdded = YES;
            }
            else {
                [newArray addObject:oldObject];
                if (oldIntervalDouble==intervaldouble) {
                    if ((!oldAlert&&!alert)||([oldAlert isEqualToString:alert])) {
                        bSkip = YES;
                    }
                }
            }
            if (!bSkip) {
                if (i==[dataArray count]-1&&!hasAdded) {
                    [newArray addObject:oneObject];
                }
            }
        }
    }
    else {
        [newArray addObject:oneObject];
    }
    
    [datalist refreshCommnetContents:newArray IDList:nil];
    [newArray release];
    
    [datalist reloadShowedDataWithIDList:nil];
    NSArray *dddataArray = [datalist contentsWithIDList:nil];
    NSLog(@"%@",dddataArray);
    
    
    int last_index = [newArray count] - 1;
    
    //don't forget update news_history info
    [[PushNewsViewController sharedInstance] update_tixing_table_with_index:last_index new_value:@"n"];
    
    [self update_push_tixing_count_num];
    
 
    
}


-(void)save_push_news_count_num:(NewsObject *)oneObject andIntervalDouble:(double)intervaldouble andBSkip:(BOOL)bSkip andAlertString:(NSString *)alert{
//    
    [remindIDList reloadShowedDataWithIDList:nil];
    NSArray *dataArray = [remindIDList contentsWithIDList:nil];
    
    NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    if ([dataArray count] > 0) {
        BOOL hasAdded = NO;
        for (int i=0; i<[dataArray count]; i++) {
            NewsObject* oldObject = [dataArray objectAtIndex:i];
            NSString* oldAlert = [oldObject valueForKey:@"alert"];
            NSString* timeString = [oldObject valueForKey:@"interval"];
            if (!timeString) {
                timeString = @"0";
            }
            double oldIntervalDouble = [timeString doubleValue];
            if (oldIntervalDouble>intervaldouble&&!hasAdded) {
                [newArray addObject:oneObject];
                [newArray addObject:oldObject];
                hasAdded = YES;
            }
            else {
                [newArray addObject:oldObject];
                if (oldIntervalDouble==intervaldouble) {
                    if ((!oldAlert&&!alert)||([oldAlert isEqualToString:alert])) {
                        bSkip = YES;
                    }
                }
            }
            if (!bSkip) {
                if (i==[dataArray count]-1&&!hasAdded) {
                    [newArray addObject:oneObject];
                }
            }
        }
    }
    else {
        [newArray addObject:oneObject];
    }
    
    [remindIDList refreshCommnetContents:newArray IDList:nil];
    [newArray release];
    
    [remindIDList reloadShowedDataWithIDList:nil];
    NSArray *dddataArray = [remindIDList contentsWithIDList:nil];
    NSLog(@"%@",dddataArray);
    
    
    int last_index = [newArray count] - 1;
    //don't forget update news_history info
    [[PushViewController sharedAppDelegate] update_news_table_with_index:last_index new_value:@"n"];
    
    [self update_push_xinwen_count_num];

}


-(void)update_push_xinwen_count_num{
    int count = 0;
    NSArray* is_read_data_array = (NSArray*)[SaveData getDataForKey:[Util get_push_has_readed_file_name] ];
    if (!is_read_data_array) {
        count = 0;
    }else{
        int i = 0;
        for (NSString *str in is_read_data_array) {
            if ([str isEqualToString:@"n"]) {//n代表未读
                count ++;
            }
            i++;
        }
    }
    
    
    
    CommentDataList *datalist  = [[CommentDataList alloc] init];
    datalist.dataTableName = @"remindnews";
    
    
    [ datalist reloadShowedDataWithIDList:nil];
    NSArray *dataArray = [datalist contentsWithIDList:nil];
    
    
    
    
    if (!is_read_data_array) {
        count = [dataArray count];
    }
    int real_count = count>0 ? count : 0;
    
    
    NSLog(@"INFO:当前未读推送新闻有 ：%d 条！",real_count);
    [[NSUserDefaults standardUserDefaults] setInteger:real_count forKey:PUSH_CUR_COUNT_XINWEN];
    
//    
//    if ([dataArray count] == 0 || [dataArray count] == 2) {
//        real_count = 0;
//        NSLog(@"INFO:当前未读推送新闻有 ：%d 条！",real_count);
//        [[NSUserDefaults standardUserDefaults] setInteger:real_count forKey:PUSH_CUR_COUNT_XINWEN];
//    }
//    
//    
  
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_push_xinwen_count_num_no" object:nil];
}

/**
 点击弹出，确认已读。
 */
-(void)update_latest_push_xinwen_count_num_already_readed{
    int count = 0;
    NSArray* is_read_data_array = (NSArray*)[SaveData getDataForKey:[Util get_push_has_readed_file_name] ];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:is_read_data_array];
    [tempArray addObject:@"y"];
    [SaveData saveDataForKey:[Util get_push_has_readed_file_name
                              ] data:tempArray];
    int real_count = [tempArray count];
    NSLog(@"INFO:当前未读推送新闻有 ：%d 条！",real_count);
    [[NSUserDefaults standardUserDefaults] setInteger:real_count forKey:PUSH_CUR_COUNT_XINWEN];
}


#pragma mark -test
-(void)dump{
    return;
    
    [self dump_xinwen];
    
}

-(void)dump_tixing{
    NSLog(@"++++++++++++++++++++++++++++++start++++++++++++++++++++++++++++++++\n");
    CommentDataList *datalist = [[CommentDataList alloc] init];
    datalist.dataTableName = [Util get_push_tixing_table_name];
    
    NSMutableArray* curSelectID = [[NSMutableArray alloc] initWithCapacity:0];
    //        我的提醒,
    //        StockRemindHistoryKey,
    //        1171794780
    [curSelectID addObject:@"我的提醒"];
    [curSelectID addObject:@"StockRemindHistoryKey"];
    NSString* loginID = [[WeiboLoginManager getInstance] loginedID];
    
    if (!loginID) {
        loginID = @"0";
    }
    [curSelectID addObject:loginID];
    
    
    [ datalist reloadShowedDataWithIDList:curSelectID];
    NSArray *dataArray = [datalist contentsWithIDList:curSelectID];
    
    for (NewsObject *obj in dataArray) {
        NSLog(@"------------------------------------------------------------\n");
        NSLog(@"%@",[obj dataDict]);
    }
    
    NSLog(@"+++++++++++++++++++++++++++++end+++++++++++++++++++++++++++++++++\n");
}

-(void)dump_xinwen{
    NSLog(@"++++++++++++++++++++++++++++++start++++++++++++++++++++++++++++++++\n");
    CommentDataList *datalist  = [[CommentDataList alloc] init];
    datalist.dataTableName = @"remindnews";
 
    
    [ datalist reloadShowedDataWithIDList:nil];
    NSArray *dataArray = [datalist contentsWithIDList:nil];
    
    for (NewsObject *obj in dataArray) {
        NSLog(@"------------------------------------------------------------\n");
        NSLog(@"%@",[obj dataDict]);
    }
    NSLog(@"+++++++++++++++++++++++++++++end+++++++++++++++++++++++++++++++++\n");
}


#pragma mark - about news readed history dict

#define news_to_already_read_array_file_name @"news_to_already_read_array_file"
/**
 * 每次程序启动，先清空阅读历史记录
 *
 */
-(void)clear_news_to_already_read_array_when_app_exit{
    [SaveData saveDataForKey:news_to_already_read_array_file_name data:nil];
}
/**
 * 把当前新闻url增加到已读数组中
 *
 */
-(void)add_news_to_already_read_array:(NSString *)news_url{
    NSArray* is_read_data_array = (NSArray*)[SaveData getDataForKey:news_to_already_read_array_file_name];
    NSMutableArray *s = [NSMutableArray arrayWithArray:is_read_data_array];
    [s addObject:news_url];
    [SaveData saveDataForKey:news_to_already_read_array_file_name data:s];
}
/**
 * 判断当前新闻的url是否已经读过，默认值为NO
 *
 */
-(BOOL)is_news_has_readed:(NSString *)news_url{
    NSArray* is_read_data_array = (NSArray*)[SaveData getDataForKey:news_to_already_read_array_file_name];
    for (NSString *s in is_read_data_array) {
        if ([s isEqualToString:news_url]) {
            return YES;
        }
    }
    
    return NO;
}



@end
