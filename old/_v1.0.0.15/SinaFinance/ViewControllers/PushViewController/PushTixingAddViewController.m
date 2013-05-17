//
//  PushViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PushTixingAddViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "DropDownTabBar.h"
#import "DataListTableView.h"
#import "StockFuncPuller.h"
#import "MyStockGroupView.h"
#import "AddStockRemindViewController.h"
#import "CommentDataList.h"
#import "DataButton.h"
#import "RegValueSaver.h"
#import "gDefines.h"
#import "AppDelegate.h"
#import "RemindViewCell.h"
#import "SingleStockViewController.h"
#import "LKTipCenter.h"
#import "MyTabBarController.h"
#import "AppDelegate.h"
#import "gDefines.h"
#import "LoginViewController.h"
#import "ProjectLogUploader.h"
#import "RegValueSaver.h"
#import "NewsContentViewController2.h"


#define StockRemindSettingKey @"StockRemindSettingKey"
#define StockRemindHistoryKey @"StockRemindHistoryKey"
#define NewsRemindHistoryKey @"NewsRemindHistoryKey"

@interface PushTixingAddViewController ()
@property(nonatomic,retain)DropDownTabBar* tabBarView;
@property(nonatomic,retain)UIView* stockView;
@property(nonatomic,retain)UIView* newsView;
@property(nonatomic,retain)DataListTableView* dataTableView;
@property(nonatomic,retain)DataListTableView* newsTableView;
@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)NSMutableArray* selectID;
@property(nonatomic,retain)UIView* addStockView;
@property(nonatomic,retain)UITextField* addStockField;
@property(nonatomic,retain)NSArray* suggestArray;
@property(nonatomic,retain)MyStockGroupView *suggestView;
@property(nonatomic,retain)AddStockRemindViewController* addController;
@property(nonatomic,retain)NSDate* lastDate;
@property(nonatomic,retain)NSString* PushAddStage;
@end

@implementation PushTixingAddViewController
{
    DropDownTabBar* tabBarView;
    UIView* stockView;
    UIView* newsView;
    DataListTableView* dataTableView;
    DataListTableView* newsTableView;
    CommentDataList* dataList;
    NSMutableArray* selectID;
    UIView* addStockView;
    UITextField* addStockField;
    NSArray* suggestArray;
    MyStockGroupView *suggestView;
    NSInteger curIndex;
    BOOL bInited;
    AddStockRemindViewController* addController;
    BOOL curExited;
    NSDate* lastDate;
    NSTimeInterval pastedTimeInterval;
    BOOL curViewShowed;
    BOOL needReloadNews;
    BOOL needReloadStockHistory;
    BOOL _isInit;
    BOOL _isEdit;
}
@synthesize tabBarView;
@synthesize stockView,newsView;
@synthesize dataList,dataTableView,selectID,newsTableView;
@synthesize addStockView,addStockField;
@synthesize suggestArray,suggestView;
@synthesize addController;
@synthesize needTab;
@synthesize lastDate;
@synthesize pushReceved;
@synthesize singleSymbol;
@synthesize pushSymbol;
@synthesize PushAddStage;
@synthesize delegate;

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
        
        [tabBarController setTabBarHiden:YES];
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
        self.title = @"行情";
        self.PushAddStage = [NSString stringWithFormat:@"push+%d",(int)self];
        self.tabBarItem.image = [UIImage imageNamed:@"stock_icon.png"];
        needTab = YES;
        _isInit= YES;
        _isEdit= YES;
    }
    return self;
}

-(void)dealloc
{
    [tabBarView release];
    [stockView release];
    [newsView release];
    [dataList release];
    [DataListTableView release];
    [selectID release];
    [addStockView release];
    [addStockField release];
    [suggestArray release];
    [suggestView release];
    [addController release];
    [newsTableView release];
    [lastDate release];
    [singleSymbol release];
    [pushSymbol release];
    
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (needTab) {
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
    }
    curViewShowed = YES;
    if (pushSymbol) {
        [self startEnterSingleFromPush:pushSymbol];
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startEnterSingleFromPush:) object:nil];
//        [self performSelector:@selector(startEnterSingleFromPush:) withObject:pushSymbol afterDelay:0.01];
        self.pushSymbol = nil;
    }
    
//    if ([[NSUserDefaults standardUserDefaults]  boolForKey:@"isnotBackground"]) {
//        [self showNewContent];
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isnotBackground"];
//    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    curViewShowed = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.selectID replaceObjectAtIndex:1 withObject:StockRemindSettingKey];
    
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
//    [self createToolbar];
    [self initUI];
    if (!bInited) {
        bInited = YES;
        [self initNotification];
    }
    [self initData];
    if (pushReceved) {
        pushReceved = NO;
        [self realPushArrived:nil];
    }
    [self addFromSingleStock];
    
   
 
//    [self tabBar:self.tabBarView clickedWithIndex:1 byBtn:YES];
//    [self startRefreshTable:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)createToolbar
{
    self.navigationController.navigationBarHidden = YES;
    MyCustomToolbar* topToolBar = [[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    [topToolBar release];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:backBtn];
    
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.tag = 10000;
    editBtn.frame = CGRectMake(260, 0, 54, 40);
    [editBtn setTitle:@" " forState:UIControlStateNormal];
//    [editBtn setBackgroundImage:[UIImage imageNamed:@"stock_list_edit"] forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"push_noti_setting"] forState:UIControlStateNormal];
    [editBtn setImage:[UIImage imageNamed:@"push_noti_setting_hight"] forState:UIControlStateHighlighted];
    //    editBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [editBtn addTarget:self action:@selector(historyClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:editBtn];
    
    
    
    if (needTab) {
//        UIImageView *logo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sina_logo.png"]] autorelease];
//        logo.frame = CGRectMake(15, 8, 38, 27);
//        logo.contentMode = UIViewContentModeScaleToFill;
//        [topToolBar addSubview:logo];//composeClicked:
//        
        
    }
    else {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(5, 7, 50, 30);
        [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
        [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
        [topToolBar addSubview:backBtn];
    }
    
    topToolBar.title = @"股价提醒";
    
}

-(void)initUI
{
    CGRect bounds = self.view.bounds;
    NSInteger tabBarheight = 29;
    if (!tabBarView) {
        tabBarView = [[DropDownTabBar alloc] initWithFrame:CGRectMake(0, 0, 320, tabBarheight)];
        tabBarView.delegate = self;
        tabBarView.hasDropDown = NO;
        tabBarView.spacer = 0;
        tabBarView.padding = 25.0;
        tabBarView.curIndex=0;
        
//        [tabBarView setSelected:1];
//                [tabBarView setSelected:2];
    }
    else
    {
        tabBarView.frame = CGRectMake(0, 56, 320, tabBarheight);
    }
    [self.view addSubview:tabBarView];
    tabBarView.hidden = YES;
    
    int curY = 16 + tabBarheight;
    
    NSInteger stockheight = bounds.size.height - curY;
    if (!needTab) {
        stockheight = bounds.size.height - curY;
    }
    if (!stockView) {
        
        stockView = [[UIView alloc] initWithFrame:CGRectMake(0, curY, 320, stockheight+15)];
        stockView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        stockView.backgroundColor = [UIColor clearColor];
        
    }
    else {
        stockView.frame = CGRectMake(0, curY, 320, stockheight);
    }
//    [self.view addSubview:stockView];
    
    NSInteger newsheight = bounds.size.height - curY;
    if (!needTab) {
        newsheight = bounds.size.height - curY;
    }
    if (!newsView) {
        
        newsView = [[UIView alloc] initWithFrame:CGRectMake(0, curY, 320, newsheight)];
        newsView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        newsView.backgroundColor = [UIColor clearColor];
    }
    else {
        newsView.frame = CGRectMake(0, curY, 320, newsheight);
    }
//    [self.view addSubview:newsView];
    
//    if ([self.singleSymbol length]>2) {
        CGRect f = stockView.frame;
        f.size.height +=55;
        stockView.frame = f;
//    }
    [self startRefreshDataTimer];
}

-(void)initTables
{
    CGRect addStockRect = CGRectMake(0, 0, 320, 40);
    if (!addStockView) {
        addStockView = [[UIView alloc] initWithFrame:addStockRect];
        addStockView.backgroundColor = [UIColor clearColor];
        UIImage* fieldImage = [UIImage imageNamed:@"push_text_back.png"];
        UIImageView* fieldImageView = [[UIImageView alloc] initWithImage:fieldImage];
        fieldImageView.frame = CGRectMake(18, 9, 215, 30);
        [addStockView addSubview:fieldImageView];
        [fieldImageView release];
        UITextField* stockField = [[UITextField alloc] initWithFrame:CGRectMake(28, 12, 130, 26)];
        stockField.backgroundColor = [UIColor clearColor];
        stockField.placeholder = @"代码/名称";
        stockField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        stockField.autocorrectionType = UITextAutocorrectionTypeNo;
        stockField.clearButtonMode = UITextFieldViewModeWhileEditing;
        stockField.returnKeyType = UIReturnKeyDone;
        stockField.delegate = self;
        self.addStockField = stockField;
        [addStockView addSubview:stockField];
        [stockField release];
        
        UIButton* tempBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        tempBtn.frame = CGRectMake(245, 9, 60, 30);
        [tempBtn addTarget:self action:@selector(addStockClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIImage* btnImage = [UIImage imageNamed:@"push_bg_button.png"];
        [tempBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        [tempBtn setTitle:@"+添加" forState:UIControlStateNormal];
        [tempBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:88/255.0 blue:162/255.0 alpha:1.0] forState:UIControlStateNormal];
        [addStockView addSubview:tempBtn];
        
//        UIButton* historyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        historyBtn.tag = 11133;
//        historyBtn.frame = CGRectMake(235, 9, 60, 30);
//        [historyBtn addTarget:self action:@selector(historyClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [historyBtn setTitle:@"历史" forState:UIControlStateNormal];
//        [historyBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
//        [historyBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:88/255.0 blue:162/255.0 alpha:1.0] forState:UIControlStateNormal];
//        [addStockView addSubview:historyBtn];
    }
    else {
        addStockView.frame = addStockRect;
    }
    [self.stockView addSubview:addStockView];
    NSInteger stockY = addStockRect.size.height+addStockRect.origin.y;
    
    int maxHeight = self.stockView.frame.size.height - stockY - 30;
    if (!self.dataTableView) {
        DataListTableView* dataView = [[DataListTableView alloc] initWithFrame:CGRectMake(0, stockY, 320, maxHeight)];
        dataView.defaultSucBackString = @"";
        dataView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        dataView.delegate = self;
        dataView.tableView.backgroundColor = [UIColor clearColor];
        dataView.selectID = selectID;
        dataView.dataList = dataList;
        dataView.hasPageMode = NO;
        dataView.hasHeaderMode = YES;
        self.dataTableView = dataView;
        [dataView release];
        UILabel* tempLabel = [[UILabel alloc] init];
        tempLabel.backgroundColor = [UIColor clearColor];
        tempLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
        tempLabel.textAlignment = UITextAlignmentCenter;
        tempLabel.frame = CGRectMake(0, self.stockView.bounds.size.height-30, 320, 30);
        tempLabel.font = [UIFont systemFontOfSize:15.0];
        tempLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        tempLabel.text = @"提示:A股自选已开通涨跌停自动提醒功能";
        [stockView addSubview:tempLabel];
        [tempLabel release];
    }
    else
    {
     
//        
    }

    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
    
    //更多私有{@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"};
    transition.subtype = kCATransitionFromLeft;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
    
    transition.delegate = self;

 
    
    if (_isEdit) {
        self.addStockView.hidden=YES;
        [self.selectID replaceObjectAtIndex:1 withObject:StockRemindHistoryKey];
    }else{
        self.addStockView.hidden=NO;
        [self.selectID replaceObjectAtIndex:1 withObject:StockRemindSettingKey];
    }
    

    if (!_isEdit) {
        self.dataTableView.frame = CGRectMake(0, stockY, 320, maxHeight);
    }else{
        self.dataTableView.frame = CGRectMake(0, stockY-38, 320, maxHeight);
    }
    
    [self.addStockView.layer addAnimation:transition forKey:nil];
    
    
    if (_isEdit) {
        
        transition.type = @"rippleEffect";//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
        UIButton *editbtn = (UIButton *)[self.view viewWithTag:10000];
        [editbtn.layer addAnimation:transition forKey:nil];
    }
 
 
  
    [self.stockView addSubview:self.dataTableView];
    
    NSInteger newsY = 0;
    int maxNewsHeight = self.stockView.frame.size.height - newsY;
    if (!self.newsTableView) {
        DataListTableView* dataView = [[DataListTableView alloc] initWithFrame:CGRectMake(0, newsY, 320, maxNewsHeight)];
        dataView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        dataView.delegate = self;
        dataView.tableView.backgroundColor = [UIColor clearColor];
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        dataView.dataList = app.remindIDList;
        dataView.hasPageMode = NO;
        dataView.hasHeaderMode = NO;
        self.newsTableView = dataView;
        [dataView release];
    }
    else
    {
        self.newsTableView.frame = CGRectMake(0, newsY, 320, maxNewsHeight);
    }
    [self.newsView addSubview:self.newsTableView];
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
        if (refreshInterval<=pastedTimeInterval&&refreshInterval>0.0&&curViewShowed) {
            pastedTimeInterval = 0.0;
            [self startRefresh];
        }
    }
}

-(void)exit
{
    curExited = YES;
}

-(void)startRefresh
{
    [self startRefreshTable:YES];
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
           selector:@selector(LoginSuccessed:) 
               name:LoginSuccessedNotification 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(LogoutSuccessed:) 
               name:LogoutSuccessedNotification
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(addStockFieldChanged:) 
               name:UITextFieldTextDidChangeNotification
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(NewsPushArrived:) 
               name:NewsPushArrivedNotification
             object:nil];
    
    [nc addObserver:self 
		   selector:@selector(PushStartupFailed:) 
			   name:PushStartupFailedNotification 
			 object:nil];
}

-(void)initData
{
//    [self performSelector:@selector(setTabbarWithDefaultIndex) withObject:nil afterDelay:.5];
}

-(void)setTabbarWithDefaultIndex{
    [tabBarView setCurIndex:0];
    [self tabBar:tabBarView clickedWithIndex:0 byBtn:YES];
}

-(void)handleBackPressed
{
    if (!_isEdit) {
         _isEdit = !_isEdit;
        [self.view viewWithTag:10000].hidden = NO;
        [self startRefreshTable:NO];
    }else{
        curExited = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark DropDownTabBarDelegate
-(NSArray*)tabsWithTabBar:(DropDownTabBar*)tabBar
{
    NSArray* titleArray = [NSArray arrayWithObjects:@"我的提醒",@"历史消息", nil];
    NSMutableArray* rtval = nil;
    for (int i=0; i<[titleArray count]; i++) {
        if (!rtval) {
            rtval = [NSMutableArray arrayWithCapacity:0];
        }
        DropDownTab* onetab = [[DropDownTab alloc] init];
        UIImage *image = nil;
        UIImage *selectedImage = nil;
        if (i==0) {
            image = [UIImage imageNamed:@"push_btn_left.png"];
            selectedImage = [UIImage imageNamed:@"push_btn_left_selected.png"];
            [onetab setBackgroundImage:image forState:UIControlStateNormal];
            [onetab setBackgroundImage:selectedImage forState:UIControlStateSelected];
        }
        else {
            image = [UIImage imageNamed:@"push_btn_right.png"];
            selectedImage = [UIImage imageNamed:@"push_btn_right_selected.png"];
            [onetab setBackgroundImage:image forState:UIControlStateNormal];
            [onetab setBackgroundImage:selectedImage forState:UIControlStateSelected];
        }
        onetab.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        [onetab setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [onetab setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [onetab setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [onetab setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        onetab.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [rtval addObject:onetab];
        [onetab release];
    }
    
    return rtval;
}

-(void)tabBar:(DropDownTabBar*)tabBar clickedWithIndex:(NSInteger)index byBtn:(BOOL)byBtn
{
    [self.addStockField resignFirstResponder];
    
    if (byBtn) {
        if (index==0) {
            [[ProjectLogUploader getInstance] writeDataString:@"stock_remaind"];
            BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
            if (hasLogined) {
         
            }
            else {
                MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
                [tabBarController setTabBarHiden:YES];
                LoginViewController* userLoginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                userLoginController.delegate = self;
                userLoginController.loginMode = LoginMode_Stock;
                [self.navigationController pushViewController:userLoginController animated:YES];
                [userLoginController release];
            }
            
        }
        else {
            [[ProjectLogUploader getInstance] writeDataString:@"top_news"];
        }
    }
    
    curIndex = index;
    NSString* addMode = StockRemindSettingKey;
    if ([self.selectID count]>1) {
        NSString* mode = [self.selectID objectAtIndex:1];
        addMode = mode;
    }
    NSMutableArray* curSelectID = [[NSMutableArray alloc] initWithCapacity:0];
    NSString* titleString = [tabBar titleForIndex:index];
    [curSelectID addObject:titleString];
    if (curIndex==0) {
        [curSelectID addObject:addMode];
        NSString* loginID = [[WeiboLoginManager getInstance] loginedID];
        if (!loginID) {
            loginID = @"0";
        }
        [curSelectID addObject:loginID];
        
        if (self.selectID&&[self.selectID count]>0) {
            [self.selectID removeAllObjects];
            [self.selectID addObjectsFromArray:curSelectID];
        }
        else {
            self.selectID = curSelectID;
        }
    }
    
    [curSelectID release];
    if (curIndex==0) {
        [self.addStockField resignFirstResponder];
        self.newsView.hidden = YES;
        self.stockView.hidden = NO;
        [self.selectID replaceObjectAtIndex:1 withObject:StockRemindSettingKey];
        
        [self startRefreshTable:NO];
        
        
    }
    else {
//        self.newsView.hidden = NO;
//        self.stockView.hidden = YES;
        [self initTables];
//        needReloadNews = YES;
//        //不管如何都重载此tab，就没有问题了
//        if (needReloadNews) {
//            needReloadNews = NO;
//            [self.newsTableView doneLoadingWithReloadTable:YES pageEnd:YES];
//        }
//        else {
//            [self.newsTableView doneLoadingWithReloadTable:YES pageEnd:YES];
//        }
        
//        [sender setTitle:@"设置" forState:UIControlStateNormal];
        [self.selectID replaceObjectAtIndex:1 withObject:StockRemindHistoryKey];
    
        [self startRefreshTable:NO];
    }
}

#pragma mark -
#pragma mark history
-(void)historyClicked:(UIButton*)sender
{
    [self.addStockField resignFirstResponder];
    
    [[ProjectLogUploader getInstance] writeDataString:@"stock_remind_history"];
    
    _isEdit = !_isEdit;
    
    sender.hidden = YES;
//下面的逻辑都移到inittable里，根据isEdit判断    
//    NSString* secondKey = [self.selectID objectAtIndex:1];
//    if ([secondKey isEqualToString:StockRemindHistoryKey]) {
//        
//  
////        [sender setTitle:@"历史" forState:UIControlStateNormal];
//        [self.selectID replaceObjectAtIndex:1 withObject:StockRemindSettingKey];
//    }
//    else {
////        
////        self.addStockView.hidden=YES;
//        
////        [sender setTitle:@"设置" forState:UIControlStateNormal];
//        [self.selectID replaceObjectAtIndex:1 withObject:StockRemindHistoryKey];
//    }
    [self startRefreshTable:NO];
}

#pragma mark -
#pragma mark addstock
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self addStockClicked:nil];
}

-(void)addStockClicked:(UIButton*)sender
{
    [self.addStockField resignFirstResponder];
    self.suggestView.superview.hidden = YES;
    
    [[ProjectLogUploader getInstance] writeDataString:@"stock_remind_add"];
    
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    if (hasLogined) {
        NSString* text = self.addStockField.text;
        if (text&&[text length]>0) {
            [[StockFuncPuller getInstance] startOneStockLookupWithSender:self name:text forLeast:YES args:nil dataList:nil seperateRequst:YES userInfo:nil];
        }
        else {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
    else {
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        LoginViewController* userLoginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        userLoginController.delegate = self;
        userLoginController.loginMode = LoginMode_Stock;
        [self.navigationController pushViewController:userLoginController animated:YES];
        [userLoginController release];
    }
}

-(void)addFromSingleStock
{
    if (singleSymbol) {
        [[StockFuncPuller getInstance] startOneStockLookupWithSender:self name:singleSymbol forLeast:YES args:nil dataList:nil seperateRequst:YES userInfo:nil];
        self.singleSymbol = nil;
    }
}

-(void)addStockFieldChanged:(NSNotification*)notify
{
    UITextField* object = notify.object;
    if (object==self.addStockField) {
        NSString* text = object.text;
        if (text&&![text isEqualToString:@""]) {
            [self initSuggestView];
            self.suggestView.superview.hidden = NO;
            [self.suggestView setData:nil];
            [[StockFuncPuller getInstance] startStockSuggestWithSender:self name:text type:1 subtype:nil count:10 page:0 args:nil dataList:nil seperateRequst:YES userInfo:nil];
        }
        else {
            self.suggestView.superview.hidden = YES;
        }
    }
}

-(void)initSuggestView
{
    CGRect addStockRect = self.addStockField.frame;
    addStockRect = [self.view convertRect:addStockRect fromView:self.addStockView];
    CGRect suggestRect = addStockRect;
    suggestRect.origin.y = addStockRect.origin.y + addStockRect.size.height+1;
    suggestRect.size.height = 90;
    if(suggestView == nil){
        suggestView = [[MyStockGroupView alloc] initWithFrame:suggestRect data:nil];
        suggestView.delegate = self;
        MyStockGroupBackView* backView = [[MyStockGroupBackView alloc] initWithFrame:self.view.bounds noclickFrame:addStockRect];
        backView.delegate = self;
        [backView addSubview:suggestView];
        [self.view addSubview:backView];
        [backView release];
    }
    else {
        suggestView.frame = suggestRect;
    }
}

- (void)myStockGroupBackViewDidClicked:(MyStockGroupBackView*)backView
{
    backView.hidden = YES;
}

-(void)addSuggestView
{
    [self initSuggestView];
    suggestView.superview.hidden = NO;
    [suggestView setData:self.suggestArray];
    suggestView.loadState = GroupViewState_Finish;
}

- (void)myStockGroupView:(MyStockGroupView*)groupView didSelectGroup:(NSDictionary*)dict
{
    NSString* symbol = [dict valueForKey:StockFunc_Suggest_full_symbol];
    if ([symbol rangeOfString:@" "].location!=NSNotFound) {
        symbol = [dict valueForKey:StockFunc_Suggest_full_symbol];
    }
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    self.addStockField.text = symbol;
    [nc addObserver:self 
           selector:@selector(addStockFieldChanged:) 
               name:UITextFieldTextDidChangeNotification
             object:nil];
    
    [self addStockClicked:nil];
}

-(void)startRefreshTable:(BOOL)bForce
{
    [self initTables];
    NSString* secondKey = [self.selectID objectAtIndex:1];
    if (!dataList) {
        dataList = [[CommentDataList alloc] init];
    }
    dataList.dataTableName = [Util get_push_tixing_table_name];
    self.dataTableView.dataList = self.dataList;
    self.dataTableView.selectID = self.selectID;
    
    BOOL needRefresh = NO;
    if (bForce) {
        needRefresh = YES;
    }
    else
    {
        needRefresh = [self.dataTableView checkRefreshByDate:HttpRequstRefreshTime];
    }
    
    if([secondKey isEqualToString:StockRemindHistoryKey])
    {
        if (needReloadStockHistory) {
            needReloadStockHistory = NO;
            needRefresh = YES;
        }
    }
    
    [self.dataTableView scrollTop:NO];
    [self.dataTableView reloadData];
    [self.dataTableView setPageMode:PageCellType_Normal];
    if (needRefresh) {
        [self.dataTableView startLoadingUI];
        if ([secondKey isEqualToString:StockRemindSettingKey]) {
            [[StockFuncPuller getInstance] startStockRemindListWithSender:self args:self.selectID dataList:dataList seperateRequst:NO userInfo:nil];
        }
        else if([secondKey isEqualToString:StockRemindHistoryKey])
        {
            NSString* device = [[RegValueSaver getInstance] readSystemInfoForKey:PushDeviceTokenKey];
            [[StockFuncPuller getInstance] startStockRemindHistoryListWithSender:self device:device args:self.selectID dataList:self.dataList userInfo:nil];
        }
    }
    else
    {
        [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
    }
}

#pragma mark -
#pragma mark networkCallback
-(void)StockObjectAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(NSInteger)PushAddStage) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if([stageNumber intValue]==Stage_Request_StockRemindList)
        {
            NSDictionary* stockinfo = [userInfo valueForKey:RequsetInfo];
            NSArray* listArray = [userInfo valueForKey:RequsetArray];
            NSString* symbol = [stockinfo valueForKey:StockFunc_RemindStockInfo_fullsymbol];
            NewsObject* foundObject = nil;
            for (NewsObject* oneObject in listArray) {
                
                //NSString* oneSymbol = [oneObject valueForKey:StockFunc_RemindStockList_fullsymbol];
                NSString* oneSymbol = [oneObject valueForKey:StockFunc_RemindStockList_symbol];
                if (oneSymbol&&[oneSymbol isEqualToString:[symbol lowercaseString]]) {
                    foundObject = oneObject;
                    break;
                }
            }
            [self objectClicked:foundObject oldInfo:stockinfo];
        }
    }
    else if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if([stageNumber intValue]==Stage_Request_AddStockSuggest)
        {
            self.suggestArray = [userInfo valueForKey:RequsetExtra];
            if (curIndex==0) {
                [self addSuggestView];
            }
        }
        else if([stageNumber intValue]==Stage_Request_StockLookup)
        {

            NSArray* sourceArray = [userInfo valueForKey:RequsetSourceArray];
            if ([sourceArray count]>=1) {
                NSDictionary* stockinfo = [sourceArray objectAtIndex:0];
                NSString* county = [stockinfo valueForKey:StockFunc_RemindStockInfo_type];
                if (!(county&&[county isEqualToString:@"fund"])) {
                    [[StockFuncPuller getInstance] startStockRemindListWithSender:PushAddStage args:nil dataList:nil seperateRequst:NO userInfo:stockinfo];
                }
                else {
                    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"添加股票失败,无法添加基金" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
                    [alert show];
                }
            }
            else if(!sourceArray||[sourceArray count]==0){
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"添加股票失败,请求超时或没有此股票" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
                [alert show];
                if ([delegate respondsToSelector:@selector(disappearPushTixingAddView)]) {
                    [delegate disappearPushTixingAddView];
                }
            }
            else {
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"添加股票失败,多个股票匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
                [alert show];
            }
            [self performSelector:@selector(onDismissPushTixingViewAddCall) withObject:onDismissPushTixingViewAdd afterDelay:1];
            
        }
        else if([stageNumber intValue]==Stage_Request_OneStockLookup)
        {
            
            NSArray* sourceArray = [userInfo valueForKey:RequsetSourceArray];
            if ([sourceArray count]>=1) {
                NSDictionary* stockinfo = [sourceArray objectAtIndex:0];
                NSString* county = [stockinfo valueForKey:StockFunc_RemindStockInfo_type];
                if (!(county&&[county isEqualToString:@"fund"])) {
                    [[StockFuncPuller getInstance] startStockRemindListWithSender:PushAddStage args:nil dataList:nil seperateRequst:NO userInfo:stockinfo];
                }
                else {
                    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"添加股票失败,无法添加基金" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
                    [alert show];
                }
            }
            else if(!sourceArray||[sourceArray count]==0){
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"添加股票失败,请求超时或没有此股票" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
                [alert show];
                if ([delegate respondsToSelector:@selector(disappearPushTixingAddView)]) {
                    [delegate disappearPushTixingAddView];
                }
            }
            else {
                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"添加股票失败,多个股票匹配" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
                [alert show];
            }
            [self performSelector:@selector(onDismissPushTixingViewAddCall) withObject:onDismissPushTixingViewAdd afterDelay:1];
            
        }


        else if([stageNumber intValue]==Stage_Request_StockRemindAddInfo||[stageNumber intValue]==Stage_Request_StockRemindUpdateInfo||[stageNumber intValue]==Stage_Request_StockRemindRemoveInfo)
        {
            NSString* modeString = [self.selectID objectAtIndex:1];
            if ([modeString isEqualToString:StockRemindSettingKey]) {
                [self startRefreshTable:YES];
            }
            if ([stageNumber intValue]==Stage_Request_StockRemindAddInfo) {
                self.addStockField.text = @"";
                NSNumber* pushNumber = [[RegValueSaver getInstance] readSystemInfoForKey:PushEnabledKey];
                if (pushNumber&&[pushNumber boolValue]) {
                    
                    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"添加股价提醒成功!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
                    alert.tag = 1111;
                    [alert show];
                    
                }
                else {
                    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"添加股价提醒成功,是否开启推送功能?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil] autorelease];
                    alert.tag = 1112;
                    alert.delegate = self;
                    [alert show];
                }
            }
        }
        else if([stageNumber intValue]==Stage_Request_StockRemindList||[stageNumber intValue]==Stage_Request_StockRemindHistoryList)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:YES];
            }
        }
        
    }
}

-(void)onDismissPushTixingViewAddCall{
    [[NSNotificationCenter defaultCenter] postNotificationName:onDismissPushTixingViewAdd object:nil];
}

-(void)StockObjectFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(NSInteger)PushAddStage) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if([stageNumber intValue]==Stage_Request_StockRemindList)
        {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"添加股票失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
    else if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if([stageNumber intValue]==Stage_Request_AddStockSuggest)
        {
            if (curIndex==0) {
                self.suggestArray = nil;
                [suggestView setData:nil];
                suggestView.loadState = GroupViewState_Error;
            }
        }
        else if([stageNumber intValue]==Stage_Request_OneStockLookup)
        {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"请求超时，操作失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
            
            if ([delegate respondsToSelector:@selector(disappearPushTixingAddView)]) {
                [delegate disappearPushTixingAddView];
            }
        }
        else if([stageNumber intValue]==Stage_Request_StockLookup)
        {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"添加股票失败!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
            
            if ([delegate respondsToSelector:@selector(disappearPushTixingAddView)]) {
                [delegate disappearPushTixingAddView];
            }
        }
        else if([stageNumber intValue]==Stage_Request_StockRemindAddInfo)
        {
            NSDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
            NSString* errorString = [extraDict valueForKey:@"msg"];
            NSString* symbol = [extraDict valueForKey:@"symbol"];
            errorString = [NSString stringWithFormat:@"添加股票[%@]失败,%@",symbol,errorString];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
        else if([stageNumber intValue]==Stage_Request_StockRemindRemoveInfo)
        {
            NSDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
            NSString* errorString = [extraDict valueForKey:@"msg"];
            if (!errorString) {
                errorString = @"未知错误";
            }
            NSString* symbol = [extraDict valueForKey:@"symbol"];
            errorString = [NSString stringWithFormat:@"删除股票[%@]失败,%@",symbol,errorString];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
        else if([stageNumber intValue]==Stage_Request_StockRemindUpdateInfo)
        {
            NSDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
            NSString* errorString = [extraDict valueForKey:@"msg"];
            if (!errorString) {
                errorString = @"未知错误";
            }
            NSString* symbol = [extraDict valueForKey:@"symbol"];
            errorString = [NSString stringWithFormat:@"修改失败,%@",errorString];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
        else if([stageNumber intValue]==Stage_Request_StockRemindList||[stageNumber intValue]==Stage_Request_StockRemindHistoryList)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:YES];
            }
        }
    }
//    
//    if ([delegate respondsToSelector:@selector(disappearPushTixingAddView)]) {
//        [delegate disappearPushTixingAddView];
//    }
    [self onDismissPushTixingViewAddCall];
}

-(void)LoginSuccessed:(NSNotification*)notify
{
    [self performSelector:@selector(reloadCurTable) withObject:nil afterDelay:0.02];
}

-(void)LogoutSuccessed:(NSNotification*)notify
{
    [self performSelector:@selector(reloadCurTable) withObject:nil afterDelay:0.02];
}

-(void)reloadCurTable
{
    if(curIndex==0)
    {
        [self tabBar:self.tabBarView clickedWithIndex:curIndex byBtn:NO];
    }
}

-(void)NewsPushArrived:(NSNotification*)notify
{
    NSDictionary* userInfo = [notify userInfo];
    [self realPushArrived:userInfo];
    NSString* symbol = [userInfo valueForKey:@"symbol"];
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    UINavigationController* selectedViewController = (UINavigationController*)tabBarController.bcselectedViewController;
    NSArray* viewControllers = tabBarController.bcviewControllers;
    BOOL curTabSelected = NO;
    if ([viewControllers count]>4) {
        UIViewController* tempController = [viewControllers objectAtIndex:4];
        if (tempController==selectedViewController) {
            curTabSelected = YES;
        }
    }
    if (curTabSelected) {
        [self startEnterSingleFromPush:symbol];
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startEnterSingleFromPush:) object:nil];
//        [self performSelector:@selector(startEnterSingleFromPush:) withObject:symbol afterDelay:0.01];
    }
    else {
        self.pushSymbol = symbol;
    }
}


-(void)showTixingPush:(NSDictionary*)userInfo{
    [self realPushArrived:userInfo];
    NSString* symbol = [userInfo valueForKey:@"symbol"];
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    UINavigationController* selectedViewController = (UINavigationController*)tabBarController.bcselectedViewController;
    NSArray* viewControllers = tabBarController.bcviewControllers;
    BOOL curTabSelected = NO;
    if ([viewControllers count]>4) {
        UIViewController* tempController = [viewControllers objectAtIndex:4];
        if (tempController==selectedViewController) {
            curTabSelected = YES;
        }
    }
    if (curTabSelected) {
        [self startEnterSingleFromPush:symbol];
        //        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startEnterSingleFromPush:) object:nil];
        //        [self performSelector:@selector(startEnterSingleFromPush:) withObject:symbol afterDelay:0.01];
    }
    else {
        self.pushSymbol = symbol;
    }

}

-(void)startEnterSingleFromPush:(NSString*)symbol
{
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
        
//        [tabBarController setTabBarHiden:NO];
//        [tabBarController tabBar:self.tabBarController  didSelectTabAtIndex:4 byBtn:YES];
//        [tabBarView setCurIndex:0];
//        
        
        
        UINavigationController* selectedViewController = (UINavigationController*)tabBarController.bcselectedViewController;
        NSArray* viewControllers = tabBarController.bcviewControllers;
        BOOL curTabSelected = NO;
        if ([viewControllers count]>4) {
            UIViewController* tempController = [viewControllers objectAtIndex:4];
            if (tempController==selectedViewController) {
                curTabSelected = YES;
            }
        }
        
        UIViewController* lastController = [self.navigationController.viewControllers lastObject];
        if (lastController==self) {
            if (curTabSelected) {
                [tabBarController setTabBarHiden:YES];
            }
            SingleStockViewController* singleViewController = [[SingleStockViewController alloc] init];
            singleViewController.stockSymbol = stockSymbol;
            singleViewController.stockType = stockType;
            if (curTabSelected) {
                singleViewController.hidesBottomBarWhenPushed = YES;
            }
            
            [self.navigationController popToViewController:self animated:NO];
            [self.navigationController pushViewController:singleViewController animated:NO];
            [singleViewController release];
        }
    }
}

-(void)selectTabByIndex:(int)i{
    [tabBarView setCurIndex:i];
}

-(void)realPushArrived:(NSDictionary*)userInfo
{
    if (userInfo) {
        NSString* typeString = [userInfo valueForKey:@"type"];
        if (!(typeString&&[typeString intValue]==2)) {
            needReloadNews = YES;
            [self.tabBarView reloadDataWithIndex:[NSNumber numberWithInt:1]];
        }
        else {
            needReloadStockHistory = YES;
            [self.tabBarView reloadDataWithIndex:[NSNumber numberWithInt:0]];
            NSString* secondKey = [self.selectID objectAtIndex:1];
            if ([secondKey isEqualToString:StockRemindSettingKey])
            {
                [self.addStockField resignFirstResponder];
                UIButton* sender = (UIButton*)[self.addStockView viewWithTag:11133];
                NSString* secondKey = [self.selectID objectAtIndex:1];
                if ([secondKey isEqualToString:StockRemindHistoryKey]) {
                    [sender setTitle:@"历史" forState:UIControlStateNormal];
                    [self.selectID replaceObjectAtIndex:1 withObject:StockRemindSettingKey];
                }
                else {
                    [sender setTitle:@"设置" forState:UIControlStateNormal];
                    [self.selectID replaceObjectAtIndex:1 withObject:StockRemindHistoryKey];
                }
            }
            [self startRefreshTable:YES];
        }
    }
    else {
        ;
    }
    
}

-(void)addStockRemindComfirm:(AddStockRemindViewController*)remindController
{
    NSString* symbol = [remindController.stockSymbolInfo valueForKey:StockFunc_RemindStockInfo_marketsymbol];
    NewsObject* oneObject = remindController.data;
    NSInteger mode = remindController.mode;
    
    NSString* rizeText = self.addController.stockSetting1L.text;
    NSString* fallText = self.addController.stockSetting2L.text;
    NSString* incpercentText = self.addController.stockSetting3L.text;
    NSString* decpercentText = self.addController.stockSetting4L.text;
    if (oneObject&&mode>0) {
        NSString* setID = [oneObject valueForKey:StockFunc_RemindStockList_set_id];
        [[StockFuncPuller getInstance] startStockRemindUpdateInfoWithSender:self setID:setID risePrice:rizeText fallPrice:fallText incpercent:incpercentText decpercent:decpercentText userInfo:nil];
    }
    else
    {
        [[StockFuncPuller getInstance]startStockRemindAddInfoWithSender:self symbol:symbol risePrice:rizeText fallPrice:fallText incpercent:incpercentText decpercent:decpercentText userInfo:nil];
    }
    
    if ([delegate respondsToSelector:@selector(disappearPushTixingAddView)]) {
        [delegate disappearPushTixingAddView];
    }
    
}
-(void)addStockRemindCancel:(AddStockRemindViewController*)remindController{
    if ([delegate respondsToSelector:@selector(disappearPushTixingAddView)]) {
        [delegate disappearPushTixingAddView];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1112) {
        if (buttonIndex == 1){
            NSNumber* pushEnabledNumber = [NSNumber numberWithBool:YES];
            [[RegValueSaver getInstance] saveSystemInfoValue:pushEnabledNumber forKey:PushEnabledKey encryptString:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:PushValueChangedNotification object:pushEnabledNumber];
            
            if ([delegate respondsToSelector:@selector(showPushTixingAddView)]) {
                [delegate showPushTixingAddView];
            }
        }
    }
}

- (void)PushStartupFailed: (NSNotification*)note
{
	
}

#pragma mark -
#pragma mark DataListTableView
-(UITableViewCell*)dataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    if (view==self.newsTableView) {
        return [self newsHistoryCellWithView:view cellForIndexPath:path object:object];
    }
    else {
        NSString* remindKey = [self.selectID objectAtIndex:1];
        if ([remindKey isEqualToString:StockRemindSettingKey]) {
            return [self stockSettingCellWithView:view cellForIndexPath:path object:object];
        }
        else if([remindKey isEqualToString:StockRemindHistoryKey])
        {
            return [self stockHistoryCellWithView:view cellForIndexPath:path object:object];
        }
    }
}

-(UITableViewCell*)newsHistoryCellWithView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    int rowNum = [path row];
    
    UITableViewCell* cell = nil;
    
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    CommentDataList* remindList = app.remindIDList;
    int Count = [remindList contentsCountWithIDList:nil];
    NewsObject* oneObject = [remindList oneObjectWithIndex:Count -rowNum-1 IDList:nil];
//    NewsObject* oneObject = [remindList oneObjectWithIndex:(rowNum) IDList:nil];
    RemindViewCell* rtval = nil;
    NSString* userIdentifier = @"WeatherIdentifier";
    rtval = (RemindViewCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[RemindViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
        rtval.delegate = self;
        
        CGRect rtvalRect = rtval.contentView.bounds;
        UIImage* seperatorImage = [UIImage imageNamed:@"tablelist_seperator.png"];
        CGSize seperatorSize = seperatorImage.size;
        UIImageView* seperatorImageView = [[UIImageView alloc] initWithImage:seperatorImage];
        seperatorImageView.frame = CGRectMake(0, rtvalRect.size.height-seperatorSize.height, rtvalRect.size.width, seperatorSize.height);
        seperatorImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [rtval.contentView addSubview:seperatorImageView];
        [seperatorImageView release];
        
    }
    rtval.data = path;
    NSNumber* intervalNumber = (NSNumber*)[oneObject valueForKey:@"interval"];
    NSDate* createDate = [NSDate dateWithTimeIntervalSince1970:[intervalNumber doubleValue]];
    NSDictionary* alertDict = (NSDictionary*)[oneObject valueForKey:@"alert"];
    if ([alertDict isKindOfClass:[NSString class]]) {
        rtval.nameString = (NSString*)alertDict;
    }
    else
    {
        rtval.nameString = [alertDict valueForKey:@"body"];
    }
    rtval.createDate = createDate;
    [rtval reloadData];
    
    return rtval;
}

-(UITableViewCell*)stockSettingCellWithView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    UITableViewCell* rtval = nil;
    NSString* userIdentifier = @"stocksettingIdentifier";
    rtval = (UITableViewCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
        rtval.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImage* forceImage = [UIImage imageNamed:@"push_cell_force.png"];
        forceImage = [forceImage stretchableImageWithLeftCapWidth:70.0 topCapHeight:30.0];
        
        DataButton* leftBtn = [[DataButton alloc] init];
        [leftBtn setBackgroundImage:forceImage forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(stockSetttingLeftClicked:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.frame = CGRectMake(5, 2, 68, 38);
        leftBtn.tag = 33310;
        [rtval.contentView addSubview:leftBtn];
        [leftBtn release];
        
        DataButton* rightBtn = [[DataButton alloc] init];
        [rightBtn setBackgroundImage:forceImage forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(stockSetttingRightClicked:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.tag = 33311;
        rightBtn.frame = CGRectMake(74, 2, 320-5-74, 38);
        [rtval.contentView addSubview:rightBtn];
        [rightBtn release];
        
//        UIView* backImageView1 = [[UIView alloc] init];
//        backImageView1.backgroundColor = [UIColor colorWithRed:165/255.0 green:165/255.0 blue:167/255.0 alpha:1.0];
//        backImageView1.frame = CGRectMake(0, 39, 320, 1);
//        [rtval.contentView addSubview:backImageView1];
//        [backImageView1 release];
//        
//        UIView* backImageView2 = [[UIView alloc] init];
//        backImageView2.backgroundColor = [UIColor whiteColor];
//        backImageView2.frame = CGRectMake(0, 40, 320, 1);
//        [rtval.contentView addSubview:backImageView2];
//        [backImageView2 release];
        
        UILabel* nameL = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 70, 18)];
        nameL.backgroundColor = [UIColor clearColor];
        nameL.font = [UIFont systemFontOfSize:12.0];
        nameL.textColor = [UIColor colorWithRed:0/255.0 green:60/255.0 blue:118/255.0 alpha:1.0];
        nameL.tag = 9001;
        nameL.textAlignment = UITextAlignmentCenter;
        [rtval.contentView addSubview:nameL];
        [nameL release];
        
        UILabel* symbolL = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 70, 18)];
        symbolL.backgroundColor = [UIColor clearColor];
        symbolL.font = [UIFont systemFontOfSize:12.0];
        symbolL.textColor = [UIColor colorWithRed:0/255.0 green:60/255.0 blue:118/255.0 alpha:1.0];
        symbolL.tag = 9002;
        symbolL.textAlignment = UITextAlignmentCenter;
        [rtval.contentView addSubview:symbolL];
        [symbolL release];
        
        UILabel* curPriceL = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 60, 20)];
        curPriceL.backgroundColor = [UIColor clearColor];
        curPriceL.tag = 2001;
        curPriceL.font = [UIFont systemFontOfSize:12.0];
        curPriceL.textColor = [UIColor colorWithRed:0/255.0 green:60/255.0 blue:118/255.0 alpha:1.0];
        curPriceL.textAlignment = UITextAlignmentRight;
        [rtval.contentView addSubview:curPriceL];
        [curPriceL release];
        
        UILabel* info1L = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 50, 20)];
        info1L.backgroundColor = [UIColor clearColor];
        info1L.tag = 1001;
        info1L.font = [UIFont systemFontOfSize:12.0];
        info1L.textColor = [UIColor colorWithRed:0/255.0 green:60/255.0 blue:118/255.0 alpha:1.0];
        info1L.textAlignment = UITextAlignmentRight;
        [rtval.contentView addSubview:info1L];
        [info1L release];
        
        UILabel* info2L = [[UILabel alloc] initWithFrame:CGRectMake(190, 10, 50, 20)];
        info2L.backgroundColor = [UIColor clearColor];
        info2L.tag = 1002;
        info2L.font = [UIFont systemFontOfSize:12.0];
        info2L.textColor = [UIColor colorWithRed:0/255.0 green:60/255.0 blue:118/255.0 alpha:1.0];
        info2L.textAlignment = UITextAlignmentRight;
        [rtval.contentView addSubview:info2L];
        [info2L release];
        
        UILabel* info3L = [[UILabel alloc] initWithFrame:CGRectMake(240, 10, 35, 20)];
        info3L.backgroundColor = [UIColor clearColor];
        info3L.tag = 1003;
        info3L.font = [UIFont systemFontOfSize:12.0];
        info3L.textColor = [UIColor colorWithRed:0/255.0 green:60/255.0 blue:118/255.0 alpha:1.0];
        info3L.textAlignment = UITextAlignmentRight;
        [rtval.contentView addSubview:info3L];
        [info3L release];
        
        UILabel* info4L = [[UILabel alloc] initWithFrame:CGRectMake(275, 10, 35, 20)];
        info4L.backgroundColor = [UIColor clearColor];
        info4L.tag = 1004;
        info4L.font = [UIFont systemFontOfSize:12.0];
        info4L.textColor = [UIColor colorWithRed:0/255.0 green:60/255.0 blue:118/255.0 alpha:1.0];
        info4L.textAlignment = UITextAlignmentRight;
        [rtval.contentView addSubview:info4L];
        [info4L release];
    }
    NSString* nameStr = [object valueForKey:StockFunc_RemindStockList_name];
    UILabel* nameL = (UILabel*)[rtval.contentView viewWithTag:9001];
    nameL.text = nameStr;
    
    NSString* symbolStr = [object valueForKey:StockFunc_RemindStockList_symbol];
    UILabel* symbolL = (UILabel*)[rtval.contentView viewWithTag:9002];
    symbolStr = [NSString stringWithFormat:@"(%@)",symbolStr];
    symbolL.text = symbolStr;
    
    DataButton* tempBtn = (DataButton*)[rtval.contentView viewWithTag:9003];
    tempBtn.data = object;
    
    DataButton* leftBtn = (DataButton*)[rtval.contentView viewWithTag:33310];
    leftBtn.data = object;
    
    DataButton* rightBtn = (DataButton*)[rtval.contentView viewWithTag:33311];
    rightBtn.data = object;
    
    NSString* price = [object valueForKey:StockFunc_RemindStockList_price];
    UILabel* curPriceL = (UILabel*)[rtval.contentView viewWithTag:2001];
    if ([price isKindOfClass:[NSString class]]) {
        curPriceL.text = price;
    }
    else {
        curPriceL.text = @"--";
    }
    
    NSString* rizePrice = [object valueForKey:StockFunc_RemindStockList_rise_price];
    UILabel* info1L = (UILabel*)[rtval.contentView viewWithTag:1001];
    rizePrice = [SingleStockViewController formatFloatString:rizePrice style:@".3"];
    if ([rizePrice floatValue]<0.001) {
        info1L.text = @"--";
    }
    else {
        info1L.text = rizePrice;
    }
    
    NSString* fallPrice = [object valueForKey:StockFunc_RemindStockList_fall_price];
    UILabel* info2L = (UILabel*)[rtval.contentView viewWithTag:1002];
    fallPrice = [SingleStockViewController formatFloatString:fallPrice style:@".3"];
    if ([fallPrice floatValue]<0.001) {
        info2L.text = @"--";
    }
    else {
        info2L.text = fallPrice;
    }
    
    NSString* incpercent = [object valueForKey:StockFunc_RemindStockList_incpercent];
    UILabel* info3L = (UILabel*)[rtval.contentView viewWithTag:1003];
    info3L.text = incpercent;
    if ([incpercent floatValue]<0.001) {
        info3L.text = @"--";
    }
    else {
        info3L.text = incpercent;
    }
    
    NSString* decpercent = [object valueForKey:StockFunc_RemindStockList_decpercent];
    if ([decpercent hasPrefix:@"-"]) {
        decpercent = [decpercent substringFromIndex:1];
    }
    UILabel* info4L = (UILabel*)[rtval.contentView viewWithTag:1004];
    info4L.text = decpercent;
    if ([decpercent floatValue]<0.001) {
        info4L.text = @"--";
    }
    else {
        info4L.text = decpercent;
    }
    return rtval;
}

-(UITableViewCell*)stockHistoryCellWithView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    RemindViewCell* rtval = nil;
    NSString* userIdentifier = @"stockhistoryidentifier";
    rtval = (RemindViewCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[RemindViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
        rtval.delegate = self;
        
        CGRect rtvalRect = rtval.contentView.bounds;
        UIImage* seperatorImage = [UIImage imageNamed:@"tablelist_seperator.png"];
        CGSize seperatorSize = seperatorImage.size;
        UIImageView* seperatorImageView = [[UIImageView alloc] initWithImage:seperatorImage];
        seperatorImageView.frame = CGRectMake(0, rtvalRect.size.height-seperatorSize.height, rtvalRect.size.width, seperatorSize.height);
        seperatorImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [rtval.contentView addSubview:seperatorImageView];
        [seperatorImageView release];
    }
    NSString* time = [object valueForKey:StockFunc_RemindHistoryList_sendtime];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* createDate = [formatter dateFromString:time];
    rtval.createDate = createDate;
    [formatter release];
    NSString* content = [object valueForKey:StockFunc_RemindHistoryList_send_content];
    rtval.nameString = content;
    rtval.hideRemove = YES;
    
    [rtval reloadData];
    
    return rtval;
}

-(void)showNewContent{
    [self startRefreshTable:YES];
//    [tabBarView setCurIndex:1];
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:YES];
//    [tabBarController tabBar:self.tabBarController
//         didSelectTabAtIndex:4 byBtn:YES];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"push_url"]) {
        return;
    }
//    #http://t.cn/zlQgn8h
    NSString *urlStr = [NSString stringWithFormat:@"http://t.cn/%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"push_url"]];
//    NSString* urlStr = @"http://finance.sina.com.cn/stock/quanshang/zyzg/20121018/144813408682.shtml";
    NSString* comentCount = nil;
    NewsContentViewController2 *newsContent = [[NewsContentViewController2 alloc] initWithNewsURL3:urlStr];
    newsContent.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsContent animated:YES];
    [newsContent release];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"push_url"];
}


-(void)showNewContentWith:(NSString *)url{
    [self startRefreshTable:YES];
    [tabBarView setCurIndex:1];
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:YES];
    [tabBarController tabBar:self.tabBarController
         didSelectTabAtIndex:4 byBtn:YES];
    //    #http://t.cn/zlQgn8h
    NSString *urlStr = [NSString stringWithFormat:@"http://t.cn/%@",url];
    //    NSString* urlStr = @"http://finance.sina.com.cn/stock/quanshang/zyzg/20121018/144813408682.shtml";
    NSString* comentCount = nil;
    NewsContentViewController2 *newsContent = [[NewsContentViewController2 alloc] initWithNewsURL3:urlStr];
    newsContent.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsContent animated:YES];
    [newsContent release]; 
}

-(void)dataListView:(DataListTableView*)view didSelectedAtIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    [view.tableView deselectRowAtIndexPath:path animated:YES];
    if (view==self.newsTableView)
    {
        //恶心的事情
        //cell的时候要反取，点击的时候也要反取
        int rowNum = [path row];
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        CommentDataList* remindList = app.remindIDList;
        int Count = [remindList contentsCountWithIDList:nil];
        NewsObject* oneObject = [remindList oneObjectWithIndex:Count -rowNum-1 IDList:nil];
        
        
        NSString *url = [[oneObject dataDict] objectForKey:@"hash"];
        //TODO:
        if ([url length]>0) {
                [self showNewContentWith:url];
        }
    
       
    }
    else {
        NSString* remindKey = [self.selectID objectAtIndex:1];
        if ([remindKey isEqualToString:StockRemindSettingKey]) {
            ;//[self objectClicked:object];
        }
        else if([remindKey isEqualToString:StockRemindHistoryKey])
        {
            NSString* symbol = [object valueForKey:StockFunc_RemindHistoryList_symbol];
            NSString* market = [object valueForKey:StockFunc_RemindHistoryList_market];
            NSString* stockType = nil;
            if ([[market lowercaseString] isEqualToString:@"sz"]||[[market lowercaseString] isEqualToString:@"sh"]) {
                stockType = @"cn";
            }
            else {
                stockType = market;
            }
            NSString* name = [object valueForKey:StockFunc_RemindHistoryList_name];
            MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
            [tabBarController setTabBarHiden:YES];
            SingleStockViewController* singleViewController = [[SingleStockViewController alloc] init];
            singleViewController.stockSymbol = symbol;
            singleViewController.stockType = stockType;
            singleViewController.stockName = name;
            singleViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:singleViewController animated:YES];
            [singleViewController release];
        }
        
    }
    
}


-(void)dataListViewDidRefreshTriggered:(DataListTableView*)view
{
    if (view==self.newsTableView)
    {
        
    }
    else {
        NSString* remindKey = [view.selectID objectAtIndex:1];
        if ([remindKey isEqualToString:StockRemindSettingKey]) {
            [[StockFuncPuller getInstance] startStockRemindListWithSender:self args:view.selectID dataList:view.dataList seperateRequst:NO userInfo:nil];
        }
        else if([remindKey isEqualToString:StockRemindHistoryKey])
        {
            NSString* device = [[RegValueSaver getInstance] readSystemInfoForKey:PushDeviceTokenKey];
            [[StockFuncPuller getInstance] startStockRemindHistoryListWithSender:self device:device args:view.selectID dataList:view.dataList userInfo:nil];
        }
    }
}

-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    if (view==self.newsTableView) {
        int rowNum = [path row];
        RemindViewCell* rtval = nil;
        AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        CommentDataList* remindList = app.remindIDList;
        int Count = [remindList contentsCountWithIDList:nil];
        NewsObject* oneObject = [remindList oneObjectWithIndex:Count -rowNum-1 IDList:nil];
        NSString* userIdentifier = @"WeatherIdentifier";
        rtval = (RemindViewCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
        if (!rtval) {
            rtval = [[[RemindViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
        }
        NSDictionary* alertDict = (NSDictionary*)[oneObject valueForKey:@"alert"];
        if ([alertDict isKindOfClass:[NSString class]]) {
            rtval.nameString = (NSString*)alertDict;
        }
        else
        {
            rtval.nameString = [alertDict valueForKey:@"body"];
        }
        CGSize heigtSize = [rtval sizeThatFits:CGSizeZero];
        return 80;
    }
    else {
        NSString* remindKey = [self.selectID objectAtIndex:1];
        if ([remindKey isEqualToString:StockRemindSettingKey]) 
        {
            return 40.0;
        }
        else if([remindKey isEqualToString:StockRemindHistoryKey])
        {
            int rowNum = [path row];
            RemindViewCell* rtval = nil;
            NSString* userIdentifier = @"stockhistoryidentifier";
            rtval = (RemindViewCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
            if (!rtval) {
                rtval = [[[RemindViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
            }
            NSString* content = [object valueForKey:StockFunc_RemindHistoryList_send_content];
            rtval.nameString = content;
            rtval.hideRemove = YES;
            CGSize heigtSize = [rtval sizeThatFits:CGSizeZero];
            return heigtSize.height;
        }
        else {
            return 40.0;
        }
    }
}

- (CGFloat)dataListView:(DataListTableView*)view heightForHeaderInSection:(NSInteger)section
{
    if (view==self.newsTableView)
    {
        return 0.0;
    }
    else {
        NSString* remindKey = [self.selectID objectAtIndex:1];
        if ([remindKey isEqualToString:StockRemindSettingKey]) {
            return 30.0;
        }
        else if([remindKey isEqualToString:StockRemindHistoryKey])
        {
            return 0.0;
        }
        
    }
    
}

- (UIView *)dataListView:(DataListTableView*)view viewForHeaderInSection:(NSInteger)section
{
    if (view==self.newsTableView)
    {
        return nil;
    }
    else {
        NSString* remindKey = [self.selectID objectAtIndex:1];
        if ([remindKey isEqualToString:StockRemindSettingKey]) {
            UIView* tempView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
//            tempView.backgroundColor=[UIColor cl];
            
//            UIImage* cellImage = [UIImage imageNamed:@"push_add_back.png"];
//            cellImage = [cellImage stretchableImageWithLeftCapWidth:2.0 topCapHeight:0.0];
//            UIImageView* backImageView = [[UIImageView alloc] initWithImage:cellImage];
//            backImageView.frame = CGRectMake(0, 0, 320, 30);
////            [tempView addSubview:backImageView];
//            [backImageView release];
            
            CGRect rtvalRect = tempView.bounds;
            UIImage* seperatorImage = [UIImage imageNamed:@"tablelist_seperator.png"];
            CGSize seperatorSize = seperatorImage.size;
            UIImageView* seperatorImageView = [[UIImageView alloc] initWithImage:seperatorImage];
            seperatorImageView.frame = CGRectMake(0, rtvalRect.size.height-seperatorSize.height, rtvalRect.size.width, seperatorSize.height);
            seperatorImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
            [tempView addSubview:seperatorImageView];
            [seperatorImageView release];
            
            UILabel* nameL = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 70, 20)];
            nameL.backgroundColor = [UIColor clearColor];
            nameL.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            nameL.text = @"股票名称";
            nameL.font = [UIFont systemFontOfSize:12.0];
            nameL.textAlignment = UITextAlignmentCenter;
            [tempView addSubview:nameL];
            [nameL release];
            
            UILabel* curPriceL = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 60, 20)];
            curPriceL.backgroundColor = [UIColor clearColor];
            curPriceL.text = @"当前价";
            curPriceL.textAlignment = UITextAlignmentRight;
            curPriceL.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            curPriceL.font = [UIFont systemFontOfSize:12.0];
            [tempView addSubview:curPriceL];
            [curPriceL release];
            
            UILabel* info1L = [[UILabel alloc] initWithFrame:CGRectMake(140, 5, 50, 20)];
            info1L.backgroundColor = [UIColor clearColor];
            info1L.text = @"上限";
            info1L.textAlignment = UITextAlignmentRight;
            info1L.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            info1L.font = [UIFont systemFontOfSize:12.0];
            [tempView addSubview:info1L];
            [info1L release];
            
            UILabel* info2L = [[UILabel alloc] initWithFrame:CGRectMake(190, 5, 50, 20)];
            info2L.backgroundColor = [UIColor clearColor];
            info2L.text = @"下限";
            info2L.textAlignment = UITextAlignmentRight;
            info2L.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            info2L.font = [UIFont systemFontOfSize:12.0];
            [tempView addSubview:info2L];
            [info2L release];
            
            UILabel* info3L = [[UILabel alloc] initWithFrame:CGRectMake(240, 5, 35, 20)];
            info3L.backgroundColor = [UIColor clearColor];
            info3L.text = @"涨幅";
            info3L.textAlignment = UITextAlignmentRight;
            info3L.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            info3L.font = [UIFont systemFontOfSize:12.0];
            [tempView addSubview:info3L];
            [info3L release];
            
            UILabel* info4L = [[UILabel alloc] initWithFrame:CGRectMake(275, 5, 35, 20)];
            info4L.backgroundColor = [UIColor clearColor];
            info4L.text = @"跌幅";
            info4L.textAlignment = UITextAlignmentRight;
            info4L.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
            info4L.font = [UIFont systemFontOfSize:12.0];
            [tempView addSubview:info4L];
            [info4L release];
            
            return tempView;
        }
        else if([remindKey isEqualToString:StockRemindHistoryKey])
        {
            return nil;
        }
        
    }
}

-(void)dataListViewWillBeginDragging:(DataListTableView*)view
{
    [self.addStockField resignFirstResponder];
}

- (BOOL)dataListView:(DataListTableView *)view canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (view==self.newsTableView)
    {
        return NO;
    }
    else {
        NSString* remindKey = [self.selectID objectAtIndex:1];
        if ([remindKey isEqualToString:StockRemindSettingKey]) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

- (UITableViewCellEditingStyle)dataListView:(DataListTableView *)view editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)dataListView:(DataListTableView *)view commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        int rowInt = indexPath.row;
        NewsObject* oneObject = [self.dataList oneObjectWithIndex:rowInt IDList:self.selectID];
        NSString* setID = [oneObject valueForKey:StockFunc_RemindStockList_set_id];
        [[StockFuncPuller getInstance] startStockRemindRemoveInfoWithSender:self setID:setID userInfo:nil];
        [self.dataList removeOfIndex:rowInt IDList:self.selectID];
        [self.dataList reloadShowedDataWithIDList:self.selectID];
        [view.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

-(void)cellEdit:(DataButton*)sender
{
    NewsObject* oneObject = sender.data;
    [self objectClicked:oneObject oldInfo:nil];
}
-(void)objectClicked:(NewsObject*)oneObject oldInfo:(NSDictionary*)stockInfo
{
    
    NSLog(@"objectClicked %@",[oneObject dataDict]);
    
    
    [self.addStockField resignFirstResponder];
    NSMutableDictionary* newDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString* name = [oneObject valueForKey:StockFunc_OneStock_name];
    [newDict setValue:name forKey:StockFunc_RemindStockInfo_name];
    NSString* fullsymbol = [oneObject valueForKey:StockFunc_RemindStockList_fullsymbol];
    [newDict setValue:fullsymbol forKey:StockFunc_RemindStockInfo_fullsymbol];
    NSString* symbol = [oneObject valueForKey:StockFunc_RemindStockList_alert_code];
    [newDict setValue:symbol forKey:StockFunc_RemindStockInfo_symbol];
    NSString* market = [oneObject valueForKey:StockFunc_RemindStockList_market];
    if ([market isEqualToString:@"sz"]) {
        market = @"cn";
        [newDict setValue:fullsymbol forKey:StockFunc_RemindStockInfo_symbol];
    }
    else if([market isEqualToString:@"sh"])
    {
        market = @"cn";
        [newDict setValue:fullsymbol forKey:StockFunc_RemindStockInfo_symbol];
    }
    [newDict setValue:market forKey:StockFunc_RemindStockInfo_type];
    if (stockInfo) {
        [newDict addEntriesFromDictionary:stockInfo];
    }
    
    AddStockRemindViewController* tempController = [[AddStockRemindViewController alloc] initWithNibName:@"AddStockRemindViewController" bundle:nil];
    tempController.delegate = self;
    tempController.mode = 1;
    tempController.stockSymbolInfo = newDict;
    NSString* setting1 = [oneObject valueForKey:StockFunc_RemindStockList_rise_price];
    if (setting1) {
        setting1 = [SingleStockViewController formatFloatString:setting1 style:@".3"];
        if ([setting1 floatValue]<0.001) {
            setting1 = @"";
        }
        tempController.preSettting1 = setting1;
    }
    NSString* setting2 = [oneObject valueForKey:StockFunc_RemindStockList_fall_price];
    if (setting2) {
        setting2 = [SingleStockViewController formatFloatString:setting2 style:@".3"];
        if ([setting2 floatValue]<0.001) {
            setting2 = @"";
        }
        tempController.preSettting2 = setting2;
    }
    NSString* setting3 = [oneObject valueForKey:StockFunc_RemindStockList_incpercent];
    if ([setting3 floatValue]<0.001) {
        setting3 = @"";
    }
    tempController.preSettting3 = setting3;
    NSString* setting4 = [oneObject valueForKey:StockFunc_RemindStockList_decpercent];
    if ([setting4 hasPrefix:@"-"]) {
        setting4 = [setting4 substringFromIndex:1];
    }
    if ([setting4 floatValue]<0.001) {
        setting4 = @"";
    }
    tempController.preSettting4 = setting4;
    tempController.data = oneObject;
    [newDict release];
    tempController.view.frame = self.view.bounds;
    CGRect f=  tempController.view.frame;
    f.origin.y = -20.0f;
    tempController.view.frame = f;
    [self.view addSubview:tempController.view];
    if (addController) {
        [addController.view removeFromSuperview];
        self.addController = nil;
    }
    self.addController = tempController;
    [tempController release];
}

-(void)openSigleStockInSetting:(NewsObject*)object
{
    NSString* symbol = [object valueForKey:StockFunc_RemindStockList_symbol];
    NSString* market = [object valueForKey:StockFunc_RemindStockList_market];
    NSString* name = [object valueForKey:StockFunc_RemindStockList_name];
    NSString* stockType = nil;
    if ([[market lowercaseString] isEqualToString:@"sz"]||[[market lowercaseString] isEqualToString:@"sh"]) {
        stockType = @"cn";
    }
    else {
        stockType = market;
    }
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:YES];
    SingleStockViewController* singleViewController = [[SingleStockViewController alloc] init];
    singleViewController.stockSymbol = symbol;
    singleViewController.stockType = stockType;
    singleViewController.stockName = name;
    singleViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:singleViewController animated:YES];
    [singleViewController release];
}

-(void)cell:(RemindViewCell*)cell closeClicked:(id)data
{
    NSIndexPath* indexPath = (NSIndexPath*)data;
    int rowNum = [indexPath row];
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    CommentDataList* remindList = app.remindIDList;
    int Count = [remindList contentsCountWithIDList:nil];
    
    [remindList removeOfIndex:Count - indexPath.row -1 IDList:nil];
    [remindList reloadShowedDataWithIDList:nil];
    [self.newsTableView.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    NSArray* cellArray = [self.newsTableView.tableView visibleCells];
    for (RemindViewCell* oneCell in cellArray) {
        oneCell.data = [self.newsTableView.tableView indexPathForCell:oneCell];
    }
}

-(void)stockSetttingLeftClicked:(DataButton*)sender
{
    NewsObject* newsObject = sender.data;
    [self openSigleStockInSetting:newsObject];
}

-(void)stockSetttingRightClicked:(DataButton*)sender
{
    NewsObject* newsObject = sender.data;
    [self objectClicked:newsObject oldInfo:nil];
   
}

@end
