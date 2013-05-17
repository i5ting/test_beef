//
//  StockListViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StockListViewController2.h"
#import "DataListTableView.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "StockFuncPuller.h"
#import "DropDownTabBar.h"
#import "BCMultiTabBar.h"
#import "LKTipCenter.h"
#import "StockViewDefines.h"
#import "StockListCell.h"
#import "Util.h"
#import "SingleStockViewController.h"
#import "MyStockGroupView.h"
#import "ForeignCalculatorView.h"
#import "MyTabBarController.h"
#import "AppDelegate.h"
#import "ProjectLogUploader.h"
#import "MyTool.h"
#import "PushNewsViewController.h"
#define default_Stockitem_layout_headwidth 30
#define HasCellSeperator @"hasseperator"

@implementation TableHeaderColumnData
@synthesize width,headerString;

-(void)dealloc
{
    [headerString release];
    [super dealloc];
}

@end

@interface StockListViewController2 ()
@property(nonatomic,retain)NSArray* requestTypes;
@property(nonatomic,retain)NSArray* requestshowNames;
@property(nonatomic,retain)NSString* titleString;
@property(nonatomic,retain)NSArray* columnDatas;
@property(nonatomic,retain)NewsObject* configItem;
//@property(nonatomic,retain)NSMutableDictionary *orderColumnDict;//目前支持涨跌幅的。
@property(nonatomic,retain)NSArray* orderColumnArray;

@property(nonatomic,retain)DataListTableView* dataTableView;
@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)NSMutableArray* selectID;

@property(nonatomic,retain)DropDownTabBar* dropDownTabBar;
@property(nonatomic,retain)BCMultiTabBar* multiTabBar;
@property(nonatomic,retain)BCMultiTabBar* subMultiTabBar;
@property(nonatomic,retain)UIView* subBarBackView;
@property(nonatomic,retain)UIView* loadingView;
@property(nonatomic,retain)UIView* errorView;
@property(nonatomic,retain)NSMutableArray* curColumnWidths;
@property(nonatomic,retain)NSDate* lastDate;
@property(nonatomic,retain)CommentDataList* myGroupDict;
@property(nonatomic,retain)NSArray* myGroupSelectedID;
@property(nonatomic,retain)UIView* addStockView;
@property(nonatomic,retain)UIView* workingView;
@property(nonatomic,retain)UITextField* addStockField;
@property(nonatomic,retain)NSArray* suggestArray;
@property(nonatomic,retain)MyStockGroupView *suggestView;
@property(nonatomic,retain)NSMutableArray *deleteArray;
@property(nonatomic,retain)ForeignCalculatorView *calculatorView;
@property(nonatomic,retain)UIActivityIndicatorView *curIndicator;
@property(nonatomic,retain)UIButton *curRefreshBtn;
@property(nonatomic,retain)UIButton *addStockBtn;

- (void)createToolbar;
-(void)initUI;
-(void)initData;
-(void)initNotification;
-(void)initNonBar;
-(void)startRefreshTableForce;
-(void)startRefreshTable:(BOOL)bForce firstReload:(BOOL)bReload scrollTop:(BOOL)bScrollTop;
-(void)addSuggestView;
-(void)extraDealWithSuccessed;
-(NSArray*)layoutConfigArray;
-(void)loadColumWidths;
-(void)loadTableHeadView;
-(void)startRefreshDataTimer;
-(void)didSelectedTabBarWithIndex:(NSInteger)index;
-(void)finishEditStock;
-(NSString*)getSymbolCode;
@end

@implementation StockListViewController2
{
    DropDownTabBar* dropDownTabBar;
    BCMultiTabBar* multiTabBar;
    BCMultiTabBar* subMultiTabBar;
    UIView* subBarBackView;
    UIView* loadingView;
    NSInteger curIndex;
    NSMutableArray* curColumnWidths;
    NSInteger seperatorRow;
    NSDate* lastDate;
    NSTimeInterval pastedTimeInterval;
    BOOL curViewShowed;
    BOOL curExited;
    CommentDataList* myGroupDict;
    NSArray* myGroupSelectedID;
    NSInteger curSubIndex;
    UIView* addStockView;
    UITextField* addStockField;
    UIView* workingView;
    UIView* errorView;
    BOOL isEditing;
    NSArray* suggestArray;
    MyStockGroupView *suggestView;
    NSMutableArray *deleteArray;
    BOOL hasReorder;
    ForeignCalculatorView *calculatorView;
    BOOL bLoading;
    BOOL bLoadingLocal;
    NSInteger curRefreshMode;
    UIActivityIndicatorView *curIndicator;
    UIButton *curRefreshBtn;
    UIButton *addStockBtn;
    int clickTabbarCount;
    int _index;
}
@synthesize barType,subBarType;
@synthesize requestTypes,requestshowNames,titleString,columnDatas;
@synthesize dataTableView,dataList,selectID;
@synthesize dropDownTabBar,multiTabBar,subMultiTabBar,subBarBackView;
@synthesize loadingView;
@synthesize errorView;
@synthesize configItem;
@synthesize curColumnWidths;
@synthesize lastDate;
@synthesize myGroupDict;
@synthesize myGroupSelectedID;
@synthesize addStockView;
@synthesize workingView;
@synthesize addStockField;
@synthesize suggestArray;
@synthesize suggestView;
@synthesize deleteArray;
@synthesize calculatorView;
@synthesize curIndicator,curRefreshBtn;
@synthesize addStockBtn;
@synthesize statusDict;
@synthesize isMyStockType;
@synthesize isMystockDefaultView;
@synthesize orderColumnArray;


+ (StockListViewController2 *)sharedInstance {
    static StockListViewController2 *sharedAppDelegate = nil;
    
    static dispatch_once_t predicate; dispatch_once(&predicate, ^{
        sharedAppDelegate = [[self alloc] init];
    });
    
    return sharedAppDelegate;
}

-(id)init{
    CommentDataList *configDataList = [[ConfigFileManager getInstance] singleStockConfigDataList];
    NewsObject* oneObject = [configDataList oneObjectWithIndex:0 IDList:nil];
    
//    NSLog(@"--%@",[oneObject dataDict]);
//    [self initWithItem:oneObject];
    
    self = [super init];
    if (self) {
        seperatorRow = -1;
        countPerPage = 100;
        dataList = [[CommentDataList alloc] init];
        myGroupDict = [[CommentDataList alloc] init];
        selectID = [[NSMutableArray alloc] initWithObjects:@"stockcode",@"stockname", nil];
        self.configItem = [oneObject retain];
        clickTabbarCount = 0;
        [self initData];
    }
    return self;
    
    
}


- (id)initWithItem:(NewsObject*)oneItem
{
    self = [super init];
    if (self) {
        seperatorRow = -1;
        countPerPage = 100;
        dataList = [[CommentDataList alloc] init];
        myGroupDict = [[CommentDataList alloc] init];
        selectID = [[NSMutableArray alloc] initWithObjects:@"stockcode",@"stockname", nil];
        self.configItem = oneItem;
        clickTabbarCount = 0;
//        orderColumnDict = [NSMutableDictionary dictionary];
       
         
        
        [self initData];
    }
    return self;
    
}

-(void)dealloc
{
    [requestTypes release];
    [requestshowNames release];
    [orderColumnArray release];
    [titleString release];
    [columnDatas release];
    [dataTableView release];
    [dataList release];
    [selectID release];
    [dropDownTabBar release];
    [multiTabBar release];
    [loadingView release];
    [errorView release];
    [subMultiTabBar release];
    [subBarBackView release];
    [configItem release];
    [curColumnWidths release];
    [lastDate release];
    [myGroupDict release];
    [myGroupSelectedID release];
    [addStockView release];
    [workingView release];
    [addStockField release];
    [suggestArray release];
    [suggestView release];
    [deleteArray release];
    [calculatorView release];
    [curIndicator release];
    [curRefreshBtn release];
    [addStockBtn release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    curViewShowed = YES;
   
    
    if (iPhone5) {
        self.view.frame = CGRectMake(0, 0, 320, UI_MAX_HEIGHT-20);
        _tip.frame = CGRectMake(0, 70, 320, 30);
        _tip2.frame = CGRectMake(0, 70+15, 320, 30);
    }else{
        self.view.frame = CGRectMake(0, 0, 320, UI_MAX_HEIGHT-20);
        _tip.frame = CGRectMake(0, 70, 320, 30);
        _tip2.frame = CGRectMake(0, 70+15, 320, 30);
    }
    
    
    _tip.textColor = [UIColor whiteColor];
    _tip2.textColor = [UIColor whiteColor];
    _tip.text = @"";
    _tip2.text = @"";
    
    if (clickTabbarCount>0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleRefreshPressed) object:nil];
        [self performSelector:@selector(handleRefreshPressed) withObject:nil afterDelay:.5];
    }
    

    [self initView];
//    self.view.backgroundColor = [UIColor blackColor];
}

-(void)viewDidAppear:(BOOL)animated{

}

-(void)initView{
    if (isMyStockType) {
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:NO];
    }
    
    
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    if ([self is_my_group]) {
        if (!hasLogined) {
            self.isMystockDefaultView = YES;
            self.dataTableView.hidden = YES;
            //        self.subMultiTabBar.hidden = YES;
            [self createToolbar];
            
            [self.multiTabBar reloadData];
            
            _tip.hidden = YES;
        }else{
            self.isMystockDefaultView = NO;
            self.dataTableView.hidden = NO;
            self.subMultiTabBar.hidden = NO;
            [self createToolbar];
            _tip.hidden = NO;
        }
    }
    
    [[AppDelegate sharedAppDelegate] update_push_tixing_count_num];
    
    
    [self update_push_tixing_num];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    curViewShowed = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [ShareData sharedManager].kLineHided = YES;
    NSLog(@"%@",self.view.frame);
    self.navigationController.navigationBarHidden = YES;
    //仅供测试用,每次此视图取一次
    //获取节日信息
    [[StockFuncPuller getInstance] getHolidayData];
    
//    
//    CommentDataList *configDataList = [[ConfigFileManager getInstance] singleStockConfigDataList];
//    NewsObject* oneObject = [configDataList oneObjectWithIndex:0 IDList:nil];
//    
//    self.configItem = oneObject;
    
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    _comps = [[NSDateComponents alloc] init];
    
    
    _tip = [[UILabel alloc] init];
    _tip.backgroundColor = [UIColor clearColor];
    _tip.font = [UIFont systemFontOfSize:14.0];
    _tip.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tip.tag=12000;
    //tipLabel.text = content_tip;
    _tip.textColor = [UIColor colorWithRed:85/255.0 green:103/255.0 blue:135/255.0 alpha:1.0];
    _tip.textAlignment = UITextAlignmentCenter;
    _tip.adjustsFontSizeToFitWidth = YES;
    _tip.hidden = NO;
    _tip.frame = CGRectMake(0, 70, 320, 20);
    
    
    _tip2 = [[UILabel alloc] init];
    _tip2.backgroundColor = [UIColor clearColor];
    _tip2.font = [UIFont systemFontOfSize:14.0];
    _tip2.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _tip2.tag=12001;
    //tipLabel.text = content_tip;
    _tip2.textColor = [UIColor colorWithRed:85/255.0 green:103/255.0 blue:135/255.0 alpha:1.0];
    _tip2.textAlignment = UITextAlignmentCenter;
    _tip2.adjustsFontSizeToFitWidth = YES;
    _tip2.hidden = NO;
    _tip2.frame = CGRectMake(0, 70+20, 320, 20);
    
    
    [self.view addSubview:_tip];
    [self.view addSubview:_tip2];
    _tip2.text= @"dddd";
    
    
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:3.0/255 green:21.0/255 blue:59.0/255 alpha:1.0];
    [self createToolbar];
    [self initUI];
    if (!bInited) {
        bInited = YES;
        [self initNotification];
    }
    
    _tip.frame = CGRectMake(0, 70, 320, 30);
    _tip2.frame = CGRectMake(0, 70+15, 320, 30);
    
    if (iPhone5) {
        self.view.frame = CGRectMake(0, 0, 320, UI_MAX_HEIGHT-20);
        _tip.frame = CGRectMake(0, 70, 320, 30);
        _tip2.frame = CGRectMake(0, 70+15, 320, 30);
    }else{
        self.view.frame = CGRectMake(0, 0, 320, UI_MAX_HEIGHT-20);
        _tip.frame = CGRectMake(0, 70, 320, 30);
        _tip2.frame = CGRectMake(0, 70+15, 320, 30);
    }
    
    
    _tip.textColor = [UIColor whiteColor];
    _tip2.textColor = [UIColor whiteColor];
 
   
}

- (void)timerFunc{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init]autorelease];
    
    [formatter setDateFormat:@"MM/dd/YY HH:mm:ss"];
    
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    //    [timeLabel setText:timestamp];//时间在变化的语句
    NSLog(@"%@",timestamp);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
     
}
/*ios6*/
- (BOOL)shouldAutorotate{
    return YES;
}
/*ios6*/
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
/*ios6*/
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (void)createToolbar
{
    if (self.isMyStockType) {
        [self myStockToolbar]; 
    }else{
        [self otherToolbar];
    }
}

-(void)backToTopnewsPage:(UIButton *)sender{
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    
    if ([[AppDelegate sharedAppDelegate] getTabId] == 1 && !hasLogined) {
           [[AppDelegate sharedAppDelegate] gotoTabWithIndex:0];
    }
}


-(void)reloginNow:(UIButton *)sender{
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    
    if ([[AppDelegate sharedAppDelegate] getTabId] == 1 && !hasLogined) {
        
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        LoginViewController* userLoginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        userLoginController.delegate = self;
        userLoginController.loginMode = LoginMode_Stock;
        userLoginController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userLoginController animated:YES];
        [userLoginController release];
    }
}

-(void)weiboUserLoginFinished{
    [self createToolbar];
}

/**
 * 我的自选的toolbar
 */
-(void)myStockToolbar{
    MyCustomToolbar* topToolBar = [[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    [topToolBar release];
    
    topToolBar.title = self.titleString;
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(5, 7, 50, 30);
//    int t = [[NSUserDefaults standardUserDefaults] integerForKey:PUSH_CUR_COUNT_TIXING];
//    NSString *titltStr = [NSString stringWithFormat:@" （%d）" ,t];
//    [backBtn setTitle:titltStr forState:UIControlStateNormal];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
//    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
//    [backBtn addTarget:self action:@selector(handleShowTixingBackPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [topToolBar addSubview:backBtn];
    
     BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    if (hasLogined) {
        isMystockDefaultView = NO;
    }
    if (isMystockDefaultView) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(5, 7, 50, 30);
        [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
        [backBtn addTarget:self action:@selector(backToTopnewsPage:) forControlEvents:UIControlEventTouchUpInside];
        [topToolBar addSubview:backBtn];
        
        
        //微博 发送
        UIImageView *sendImgView = [[UIImageView alloc] initWithFrame:CGRectMake(259, 5, 44+6, 34)];
        sendImgView.image = [UIImage imageNamed:@"login_btn.png"];
        [topToolBar addSubview:sendImgView];
        
        UIButton* tempBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn1.frame = CGRectMake(259, 0, 54, 40);//(285, 4, 44, 22);
        //    [tempBtn1 setBackgroundImage:[UIImage imageNamed:@"weibo_send_btn.png"] forState:UIControlStateNormal];
        [tempBtn1 addTarget:self action:@selector(reloginNow:) forControlEvents:UIControlEventTouchUpInside];
        //[self.navigationBar addSubview:tempBtn1];
        [topToolBar addSubview:tempBtn1];
    
        
    }else{
    
        UILabel *num_label = [[UILabel alloc] init];
        num_label.tag = 100001;
        int push_cur_count_news=[[NSUserDefaults standardUserDefaults] integerForKey:PUSH_CUR_COUNT_TIXING];
 

        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.tag = 100000;
       
        
        [self reset_frame:backBtn andLabel:num_label];
     
        
        backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
        [backBtn addTarget:self action:@selector(handleShowTixingBackPressed:) forControlEvents:UIControlEventTouchUpInside];
        [topToolBar addSubview:backBtn];
        
        
        NSString *lable_title = [NSString stringWithFormat:@"%d",push_cur_count_news];
        num_label.text = lable_title;
        num_label.font = [UIFont systemFontOfSize:12];
        num_label.textColor = [UIColor whiteColor];
        num_label.backgroundColor = [UIColor clearColor];
        [topToolBar addSubview:num_label];
        
        
        
        if (!self.curRefreshBtn) {
            UIButton *refreshBtn = [UIButton buttonWithType: UIButtonTypeCustom];
            refreshBtn.frame = CGRectMake(285, 10, 25, 23);
//            [refreshBtn setImage:[UIImage imageNamed:@"refresh_btn.png"] forState:UIControlStateNormal];
            refreshBtn.tag = REFRESH_BTN_TAG;
            [Util set_refresh_btn_bg_png:refreshBtn];
            [refreshBtn addTarget:self action:@selector(handleRefreshPressed) forControlEvents:UIControlEventTouchUpInside];
            self.curRefreshBtn = refreshBtn;
        }
        else {
            self.curRefreshBtn.frame = CGRectMake(285, 10, 25, 23);
        }
        [topToolBar addSubview:self.curRefreshBtn];
        if (!self.curIndicator) {
            curIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            CGRect indicatorRect = curIndicator.frame;
            indicatorRect.origin.x = 285 + 25/2 - indicatorRect.size.width/2;
            indicatorRect.origin.y = 10 + 23/2 - indicatorRect.size.height/2;
            curIndicator.frame = indicatorRect;
        }
        else {
            CGRect indicatorRect = curIndicator.frame;
            indicatorRect.origin.x = 285 + 25/2 - indicatorRect.size.width/2;
            indicatorRect.origin.y = 10 + 23/2 - indicatorRect.size.height/2;
            self.curIndicator.frame = indicatorRect;
        }
        [topToolBar addSubview:self.curIndicator];
        
        NSString* needGroup = [configItem valueForKey:Stockitem_layout_needmygroup];
        if (needGroup&&[needGroup intValue]>0) {
            UIButton *editBtn = [UIButton buttonWithType: UIButtonTypeCustom];
            editBtn.frame = CGRectMake(255, 11, 24, 21);
            [editBtn setImage:[UIImage imageNamed:@"stock_list_edit.png"] forState:UIControlStateNormal];
            [editBtn addTarget:self action:@selector(handleEditPressed:) forControlEvents:UIControlEventTouchUpInside];
            [topToolBar addSubview:editBtn];
        }
        NSString* hascalculator = [configItem valueForKey:Stockitem_hascalculator];
        if (hascalculator&&[hascalculator intValue]>0) {
            UIButton *calculatorBtn = [UIButton buttonWithType: UIButtonTypeCustom];
            calculatorBtn.frame = CGRectMake(258, 11, 16, 22);
            [calculatorBtn setImage:[UIImage imageNamed:@"stock_calculator.png"] forState:UIControlStateNormal];
            [calculatorBtn addTarget:self action:@selector(handleCalculatorPressed:) forControlEvents:UIControlEventTouchUpInside];
            [topToolBar addSubview:calculatorBtn];
        }
    }
}

-(void)handleShowTixingBackPressed:(UIButton *)sender{
    PushNewsViewController* stockBarController = [[PushNewsViewController alloc] init];
//    stockBarController.pushType = pushType_tixing;
//        stockBarController.pushType = pushType_xinwen;
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:YES];
    
    stockBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:stockBarController animated:YES];
    [stockBarController release];
}

/**
 * 除了我的自选外的其他用的toolbar
 */
-(void)otherToolbar{
    MyCustomToolbar* topToolBar = [[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    [topToolBar release];
    
    topToolBar.title = self.titleString;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:backBtn];
    
    if (!self.curRefreshBtn) {
        UIButton *refreshBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        refreshBtn.frame = CGRectMake(285, 10, 25, 23);
        refreshBtn.tag = REFRESH_BTN_TAG;
        [Util set_refresh_btn_bg_png:refreshBtn];
//        [refreshBtn setImage:[UIImage imageNamed:@"refresh_btn.png"] forState:UIControlStateNormal];
        [refreshBtn addTarget:self action:@selector(handleRefreshPressed) forControlEvents:UIControlEventTouchUpInside];
        self.curRefreshBtn = refreshBtn;
    }
    else {
        self.curRefreshBtn.frame = CGRectMake(285, 10, 25, 23);
    }
    [topToolBar addSubview:self.curRefreshBtn];
    if (!self.curIndicator) {
        curIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGRect indicatorRect = curIndicator.frame;
        indicatorRect.origin.x = 285 + 25/2 - indicatorRect.size.width/2;
        indicatorRect.origin.y = 10 + 23/2 - indicatorRect.size.height/2;
        curIndicator.frame = indicatorRect;
    }
    else {
        CGRect indicatorRect = curIndicator.frame;
        indicatorRect.origin.x = 285 + 25/2 - indicatorRect.size.width/2;
        indicatorRect.origin.y = 10 + 23/2 - indicatorRect.size.height/2;
        self.curIndicator.frame = indicatorRect;
    }
    [topToolBar addSubview:self.curIndicator];
    
    NSString* needGroup = [configItem valueForKey:Stockitem_layout_needmygroup];
    if (needGroup&&[needGroup intValue]>0) {
        UIButton *editBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        editBtn.frame = CGRectMake(255, 11, 24, 21);
        [editBtn setImage:[UIImage imageNamed:@"stock_list_edit.png"] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(handleEditPressed:) forControlEvents:UIControlEventTouchUpInside];
        [topToolBar addSubview:editBtn];
    }
    NSString* hascalculator = [configItem valueForKey:Stockitem_hascalculator];
    if (hascalculator&&[hascalculator intValue]>0) {
        UIButton *calculatorBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        calculatorBtn.frame = CGRectMake(258, 11, 16, 22);
        [calculatorBtn setImage:[UIImage imageNamed:@"stock_calculator.png"] forState:UIControlStateNormal];
        [calculatorBtn addTarget:self action:@selector(handleCalculatorPressed:) forControlEvents:UIControlEventTouchUpInside];
        [topToolBar addSubview:calculatorBtn];
    }

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
           selector:@selector(addStockFieldChanged:)
               name:UITextFieldTextDidChangeNotification
             object:nil];
    
    
//    mystock_cn_curStockStatusNotificationName
    
    [nc addObserver:self
           selector:@selector(cnStockStatusAdded:)
               name:mystock_cn_curStockStatusNotificationName
             object:nil];
    
    [nc addObserver:self
           selector:@selector(hkStockStatusAdded:)
               name:mystock_hk_curStockStatusNotificationName
             object:nil];
    
    [nc addObserver:self
           selector:@selector(usStockStatusAdded:)
               name:mystock_us_curStockStatusNotificationName
             object:nil];
    
    [nc addObserver:self
           selector:@selector(LoginSuccessed:)
               name:LoginSuccessedNotification
             object:nil];
    [nc addObserver:self
           selector:@selector(LogoutSuccessed:)
               name:LogoutSuccessedNotification
             object:nil];
    
    
}

-(void)LoginSuccessed:(NSNotification*)notify
{
    [self viewWillAppear:YES];
}


-(void)LogoutSuccessed:(NSNotification*)notify
{
    
}



-(void)initData
{
    NSArray* types = (NSArray*)[configItem valueForKey:Stockitem_request_type];
    self.requestTypes = types;
    NSArray* showNames = (NSArray*)[configItem valueForKey:Stockitem_request_showname];
    self.requestshowNames = showNames;
    self.titleString = [configItem valueForKey:Stockitem_name];
    NSString* barTypeString = [configItem valueForKey:Stockitem_tabbar_type];
    self.barType = [barTypeString intValue];
    NSString* subBarTypeString = [configItem valueForKey:Stockitem_subbar_type];
    self.subBarType = [subBarTypeString intValue];
    
}

-(void)initUI
{
    int curY = 44;
    CGRect addStockRect = CGRectMake(0, curY, 320, 48);
    if (!addStockView) {
        UIView* tempView = [[UIView alloc] initWithFrame:addStockRect];
        self.addStockView = tempView;
        tempView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tempView.backgroundColor = [UIColor clearColor];
        [tempView release];
        
        UIImage* fieldBack = [UIImage imageNamed:@"stock_list_input.png"];
        UIImageView* fieldBackView = [[UIImageView alloc] initWithImage:fieldBack];
        fieldBackView.frame = CGRectMake(10, 10, 205, 30);
        [tempView addSubview:fieldBackView];
        [fieldBackView release];
        UITextField* stockField = [[UITextField alloc] initWithFrame:CGRectMake(15, 14, 195, 26)];
        stockField.backgroundColor = [UIColor clearColor];
        stockField.placeholder = @"请输入股票名称或代码";
        stockField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        stockField.autocorrectionType = UITextAutocorrectionTypeNo;
        stockField.clearButtonMode = UITextFieldViewModeWhileEditing;
        stockField.font = [UIFont systemFontOfSize:14.0];
        stockField.clearButtonMode = UITextFieldViewModeWhileEditing;
        stockField.delegate = self;
        stockField.returnKeyType = UIReturnKeyDone;
        self.addStockField = stockField;
        [tempView addSubview:stockField];
        [stockField release];
        
        UIButton* tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBtn.frame = CGRectMake(220, 10, 80, 30);
        //        tempBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"stock_list_add.png"] forState:UIControlStateNormal];
        tempBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [tempBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tempBtn addTarget:self action:@selector(addStockClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tempBtn setTitle:@"添加个股" forState:UIControlStateNormal];
        self.addStockBtn = tempBtn;
        [tempView addSubview:tempBtn];
    }
    else {
        self.addStockView.frame = addStockRect;
    }
    [self.view addSubview:self.addStockView];
    
    if(!isEditing)
    {
        addStockRect.size.height = 0;
        self.addStockView.frame = addStockRect;
        self.addStockView.alpha = 0.0;
    }
    else {
        curY = curY + addStockRect.size.height;
        self.addStockView.alpha = 1.0;
    }
    
    CGRect workingRect = CGRectMake(0, curY, 320, self.view.bounds.size.height-curY);
    if (!workingView) {
        workingView = [[UIView alloc] initWithFrame:workingRect];
        workingView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    else {
        workingView.frame = workingRect;
    }
    [self.view addSubview:workingView];
    curY = 0;
    int barHeight = 0;
    if (requestTypes&&[requestTypes count]>1) {
        if (barType==BarType_Fixed) {
            barHeight = 30;
            if (!self.dropDownTabBar) {
                dropDownTabBar = [[DropDownTabBar alloc] initWithFrame:CGRectMake(0, curY, 320, barHeight)];
                dropDownTabBar.delegate = self;
                dropDownTabBar.hasDropDown = NO;
                dropDownTabBar.spacer = 0;
                dropDownTabBar.padding = 5.0;
            }
            else {
                self.dropDownTabBar.frame = CGRectMake(0, curY, 320, barHeight);
            }
            [self.multiTabBar removeFromSuperview];
            self.multiTabBar = nil;
            [self.workingView addSubview:self.dropDownTabBar];
        }
        else if (barType==BarType_Scroll) {
            barHeight = 30;
            if (!self.multiTabBar) {
                NSArray* multiBarHeightArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:barHeight], nil];
                CGRect multiRect = CGRectMake(0, curY, 320, barHeight);
                multiTabBar = [[BCMultiTabBar alloc] initWithFrame:multiRect heights:multiBarHeightArray];
                multiTabBar.delegate = self;
                multiTabBar.selectedMovement = MovementStyle_Free;
                for (int i=0; i<[multiTabBar.tabBarArray count]; i++) {
                    BCTabBar* oneTabBar = [multiTabBar.tabBarArray objectAtIndex:i];
                    if(i==0)
                    {
                        oneTabBar.selectedAlignment = AlignmentStyle_Center;
                        oneTabBar.showedMaxItem = 5;
                        oneTabBar.tabMargin = 0.0;
                        
                        UIImage* columnBack = [UIImage imageNamed:@"stock_list_bar_back.png"];
                        columnBack = [columnBack stretchableImageWithLeftCapWidth:2.0 topCapHeight:15.0];
                        oneTabBar.backgroundImage = columnBack;
                        oneTabBar.maxTabWidth = 100;
                        UIImage* arrowImage = [UIImage imageNamed:@"stock_list_bar_selected.png"];
                        oneTabBar.arrowImage = [arrowImage stretchableImageWithLeftCapWidth:20.0 topCapHeight:10.0];
                        oneTabBar.ArrowBackScrollAnimate = NO;
                        oneTabBar.arrowCoverScroll = YES;
                        oneTabBar.leftArrowImage = [UIImage imageNamed:@"stock_list_bar_arrow_left.png"];
                        oneTabBar.rightArrowImage = [UIImage imageNamed:@"stock_list_bar_arrow_right.png"];
                        oneTabBar.leftRightArrowWidth = 12;
                    }
                }
            }
            else {
                self.multiTabBar.frame = CGRectMake(0, curY, 320, barHeight);
            }
            [self.dropDownTabBar removeFromSuperview];
            self.dropDownTabBar = nil;
            [self.workingView addSubview:multiTabBar];
        }
    }
    
    curY = curY + barHeight;
    NSString* needGroup = [configItem valueForKey:Stockitem_layout_needmygroup];
    if (needGroup&&[needGroup intValue]>0) {
        barHeight = 30;
        if (!self.subBarBackView) {
            UIImage* columnBack = [UIImage imageNamed:@"stock_list_secondbar_back.png"];
            columnBack = [columnBack stretchableImageWithLeftCapWidth:2.0 topCapHeight:15.0];
            subBarBackView = [[UIImageView alloc] initWithImage:columnBack];
            subBarBackView.frame = CGRectMake(5, curY, 308, barHeight);
            subBarBackView.userInteractionEnabled = YES;
        }
        else {
            self.subBarBackView.frame = CGRectMake(5, curY, 308, barHeight);
        }
        [self.workingView addSubview:subBarBackView];
        if (!self.subMultiTabBar) {
            NSArray* multiBarHeightArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:barHeight], nil];
            CGRect multiRect = CGRectMake(3, 0, 302, barHeight);
            subMultiTabBar = [[BCMultiTabBar alloc] initWithFrame:multiRect heights:multiBarHeightArray];
            subMultiTabBar.delegate = self;
            subMultiTabBar.selectedMovement = MovementStyle_Free;
            for (int i=0; i<[subMultiTabBar.tabBarArray count]; i++) {
                BCTabBar* oneTabBar = [subMultiTabBar.tabBarArray objectAtIndex:i];
                if(i==0)
                {
                    oneTabBar.selectedAlignment = AlignmentStyle_Center;
                    oneTabBar.showedMaxItem = 5;
                    oneTabBar.tabMargin = 0.0;
                    oneTabBar.arrowCoverScroll = YES;
                    oneTabBar.backgroundImage = nil;
                    oneTabBar.maxTabWidth = 100;
                    UIImage* arrowImage = [UIImage imageNamed:@"stock_list_secondbar_selected.png"];
                    oneTabBar.arrowImage = [arrowImage stretchableImageWithLeftCapWidth:20.0 topCapHeight:10.0];
                    oneTabBar.ArrowBackScrollAnimate = NO;
                    
                }
            }
        }
        else {
            self.subMultiTabBar.frame = CGRectMake(5, 0, 298, barHeight);
        }
        [self.subBarBackView addSubview:subMultiTabBar];
        if (!loadingView) {
            loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, curY, 320, barHeight)];
            loadingView.backgroundColor = [UIColor clearColor];
            UILabel* oneLabel = [[UILabel alloc] initWithFrame:loadingView.bounds];
            oneLabel.text = @"加载中...";
            oneLabel.textAlignment = UITextAlignmentCenter;
            oneLabel.backgroundColor = [UIColor clearColor];
            oneLabel.textColor = [UIColor colorWithRed:0/255.0 green:61/255.0 blue:110/255.0 alpha:1.0];
            [loadingView addSubview:oneLabel];
            [oneLabel release];
            loadingView.hidden = YES;
        }
        else {
            self.loadingView.frame = CGRectMake(0, curY, 320, barHeight);
        }
        [self.workingView addSubview:loadingView];
        if (!errorView) {
            errorView = [[UIView alloc] initWithFrame:CGRectMake(0, curY, 320, barHeight)];
            errorView.backgroundColor = [UIColor clearColor];
            UILabel* oneLabel = [[UILabel alloc] initWithFrame:errorView.bounds];
            oneLabel.textAlignment = UITextAlignmentCenter;
            oneLabel.tag = 23311;
//            NSLog(@"%@",errorView);
            oneLabel.text = @"网络错误";
            if (![[WeiboLoginManager getInstance] hasLogined]&&[self is_my_group]) {
                oneLabel.text = @"登录后可进行自选股操作";
            }
            oneLabel.backgroundColor = [UIColor clearColor];
            oneLabel.textColor = [UIColor colorWithRed:0/255.0 green:61/255.0 blue:110/255.0 alpha:1.0];
            [errorView addSubview:oneLabel];
            [oneLabel release];
            errorView.hidden = YES;
        }
        else {
            self.errorView.frame = CGRectMake(0, curY, 320, barHeight);
        }
        [self.workingView addSubview:errorView];
        curY = curY + barHeight;
    }

//    curY += 10;
    int maxHeight = workingRect.size.height - curY;
    if (!self.dataTableView) {
        DataListTableView* dataView = [[DataListTableView alloc] initWithFrame:CGRectMake(0, curY, 320, maxHeight)];
        dataView.defaultSucBackString = @"";
        dataView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        dataView.delegate = self;
        dataView.backLabel.textColor = [UIColor whiteColor];
        dataView.tableView.backgroundColor = [UIColor colorWithRed:0/255.0 green:36/255.0 blue:58/255.0 alpha:1.0];
        dataView.selectID = selectID;
        dataView.dataList = dataList;
        dataView.hasPageMode = NO;
        dataView.refreshView.hidden=YES;
        self.dataTableView = dataView;
        [dataView release];
    }
    else
    {
        self.dataTableView.frame = CGRectMake(0, curY, 320, maxHeight);
    }
    [self.workingView addSubview:self.dataTableView];
    
    UIView* oldShadowView = [self.view viewWithTag:133289];
    [oldShadowView removeFromSuperview];
    UIImage* tabShadowImage = [UIImage imageNamed:@"news_stockbar_list_bar_shadow.png"];
    UIImageView* tabShadowImageView = [[UIImageView alloc] initWithImage:tabShadowImage];
    tabShadowImageView.frame = CGRectMake(0, curY, 320, 13);
    tabShadowImageView.tag = 133289;
    [self.workingView addSubview:tabShadowImageView];
    [tabShadowImageView release];
    
    
    if (barType==BarType_None) {
        [self initNonBar];
    }
    [self startRefreshDataTimer];
    
    if (self.isMyStockType) {
        CGRect f = self.dataTableView.frame;
        f.size.height -= 44;
        self.dataTableView.frame = f;
        UIView *bottemBgView = [[UIView alloc] initWithFrame:CGRectMake(0, f.size.height + f.origin.y+44 , 320, 50)];
        bottemBgView.backgroundColor =[UIColor blackColor];
        [self.view addSubview:bottemBgView];
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
        
        if (refreshInterval<=pastedTimeInterval&&refreshInterval>0.0&&curViewShowed&&!isEditing&&!bLoading) {
            pastedTimeInterval = 0.0;
            //            [self initView];
            [self startAutoRefresh];
        }
        
    }
}

-(void)startAutoRefresh
{
    if (!isEditing&&!bLoading) {
        bLoading = YES;
        [self.curIndicator startAnimating];
        self.curRefreshBtn.hidden = YES;
        NSString* needGroup = [configItem valueForKey:Stockitem_layout_needmygroup];
        if (needGroup&&[needGroup intValue]>0) {
            [self refreshWithSubMultiBar:2];
        }
        else {
            [self startRefreshTable:YES firstReload:NO scrollTop:NO];
        }
    }
}

#pragma mark -
#pragma mark multiTabBar
-(NSArray*)multiTabBar:(BCMultiTabBar*)aMultiTabBar tabsForIndex:(NSIndexPath *)index
{
    NSMutableArray* rtval = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    if (aMultiTabBar==self.multiTabBar) {
        NSMutableArray* columnArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSString* oneRequstString in requestshowNames) {
            [columnArray addObject:oneRequstString];
        }
        if (index.row==0) {
            if (columnArray) {
                for(int i=0;i<[columnArray count];i++) {
                    BCTab* oneTab = [[BCTab alloc] init];
                    if ([self is_my_group]) {
                        oneTab.nameLabel.text = [[WeiboLoginManager getInstance] hasLogined]?[columnArray objectAtIndex:i]:@"登录后可进行自选股操作";
                    }else{
                        oneTab.nameLabel.text = [columnArray objectAtIndex:i];
                    }
//                    oneTab.nameLabel.text = [[WeiboLoginManager getInstance] hasLogined]&&[self is_my_group]?[columnArray objectAtIndex:i]:@"登录后可进行自选股操作";
                    oneTab.nameLabel.font = [UIFont systemFontOfSize:15.0];
                    oneTab.nameLabel.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
                    oneTab.nameLabel.highlightedTextColor = [UIColor colorWithRed:253/255.0 green:253/255.0 blue:253/255.0 alpha:1.0];
                    [rtval addObject:oneTab];
                    [oneTab release];
                }
            }
        }
        [columnArray release];
    }
    else {
        NSMutableArray* columnArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:1];
        [newArray addObject:[self.selectID objectAtIndex:0]];
        self.myGroupSelectedID = newArray;
        [newArray release];
        [self.myGroupDict reloadShowedDataWithIDList:self.myGroupSelectedID];
        NSArray* subGroupArray = [self.myGroupDict contentsWithIDList:self.myGroupSelectedID];
        for (NSDictionary* oneSubGroup in subGroupArray) {
            NSString* oneName = [oneSubGroup valueForKey:StockFunc_GroupInfo_name];
            [columnArray addObject:oneName];
        }
        if (index.row==0) {
            if (columnArray) {
                for(int i=0;i<[columnArray count];i++) {
                    BCTab* oneTab = [[BCTab alloc] init];
//                    oneTab.nameLabel.text = [columnArray objectAtIndex:i];
                    for (UIView *v in aMultiTabBar.subviews) {
                        if ([v isKindOfClass:[UILabel class]]) {
                            [v removeFromSuperview];
                        }
                    }
                  
                    if (![[WeiboLoginManager getInstance] hasLogined]) {
                        UILabel* oneLabel = [[UILabel alloc] initWithFrame:errorView.bounds];
                        oneLabel.textAlignment = UITextAlignmentCenter;
                        oneLabel.tag = 23311;
                        //            NSLog(@"%@",errorView);
                        oneLabel.text = @"网络错误";
                        if (![[WeiboLoginManager getInstance] hasLogined]&&[self is_my_group]) {
                            oneLabel.text = @"登录后可进行自选股操作";
                        }
                        oneLabel.backgroundColor = [UIColor clearColor];
                        oneLabel.textColor = [UIColor colorWithRed:0/255.0 green:61/255.0 blue:110/255.0 alpha:1.0];
                        [aMultiTabBar addSubview:oneLabel];
                    }else{
                        
                        oneTab.nameLabel.text = [[WeiboLoginManager getInstance] hasLogined]?[columnArray objectAtIndex:i]:@"登录后可进行自选股操作";
                          NSLog(@"%@",oneTab.nameLabel.text );
                        oneTab.nameLabel.font = [UIFont systemFontOfSize:14.0];
                        oneTab.nameLabel.textColor = [UIColor colorWithRed:0/255.0 green:61/255.0 blue:110/255.0 alpha:1.0];
                        oneTab.nameLabel.highlightedTextColor = [UIColor whiteColor];
                        [rtval addObject:oneTab];
                        [oneTab release];
                    }
                }
            }
        }
        [columnArray release];
    }
    
    return rtval;
}

- (void)multiTabBar:(BCMultiTabBar *)aMultiTabBar didSelectTabAtIndex:(NSIndexPath*)index byBtn:(BOOL)byBtn
{
    
    BCTabBar* tabBar = [aMultiTabBar.tabBarArray objectAtIndex:0];
    NSNumber* barIndexNum =  [NSNumber numberWithInt:[tabBar selectedColumn]];
    if (aMultiTabBar==self.multiTabBar) {
        [self didSelectedTabBarWithIndex:[barIndexNum intValue]];
    }
    else {
        NewsObject* oneGroupObject = [self.myGroupDict oneObjectWithIndex:[barIndexNum intValue] IDList:self.myGroupSelectedID];
        NSString* onePid = [oneGroupObject valueForKey:StockFunc_GroupInfo_pid];
        if ([self.selectID count]>=2&&onePid) {
            [self.selectID replaceObjectAtIndex:1 withObject:onePid];
        }
        curSubIndex = [barIndexNum intValue];
        if (!bLoadingLocal) {
            [self.curIndicator startAnimating];
            bLoading = YES;
            self.curRefreshBtn.hidden = YES;
            if (curRefreshMode==0) {
                BCTabBar* oneTabBar = [aMultiTabBar.tabBarArray objectAtIndex:0];
                NSArray* tabs = oneTabBar.tabs;
                if ([tabs count]>index.row) {
                    NSTimer* timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(startRefreshTableForce) userInfo:nil repeats:NO];
                    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                }
                else {
                    NSTimer* timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(startRefreshTableNOForce) userInfo:nil repeats:NO];
                    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                }
            }
            else {
                NSTimer* timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(startRefreshTableForceNOTop) userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            }
        }
        else {
            NSTimer* timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(startRefreshTableNOForce) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }
}

#pragma mark -
#pragma mark DropDownTabBarDelegate
-(NSArray*)tabsWithTabBar:(DropDownTabBar*)tabBar
{
    
    NSMutableArray* columnArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
     NSMutableArray* order_columnArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    for (NSString* oneRequstString in requestshowNames) {
        [columnArray addObject:oneRequstString];
//        [order_columnArray addObject:@"0"];
//        if ([oneRequstString isEqualToString:@"跌幅榜"]) {
//            [order_columnArray addObject:@"1"];
//        }else{
            //现在没有涨幅榜和跌幅榜
            [order_columnArray addObject:@"0"];
//        }
        
    }
    self.orderColumnArray = order_columnArray;
    NSLog(@"%@",  self.orderColumnArray );
    NSArray* titleArray = columnArray;
    
    NSMutableArray* rtval = nil;
    if ([titleArray count]<=2) {
        for (int i=0; i<[titleArray count]; i++) {
            if (!rtval) {
                rtval = [NSMutableArray arrayWithCapacity:0];
            }
            DropDownTab* onetab = [[DropDownTab alloc] init];
            UIImage *image = nil;
            UIImage *selectedImage = nil;
            if (i==0) {
                image = [UIImage imageNamed:@"news_stockbar_list_bar_left.png"];
                selectedImage = [UIImage imageNamed:@"news_stockbar_list_bar_left_selected.png"];
                [onetab setBackgroundImage:image forState:UIControlStateNormal];
                [onetab setBackgroundImage:selectedImage forState:UIControlStateSelected];
            }
            
            if (i==1) {
                image = [UIImage imageNamed:@"news_stockbar_list_bar_right.png"];
                selectedImage = [UIImage imageNamed:@"news_stockbar_list_bar_right_selected.png"];
                [onetab setBackgroundImage:image forState:UIControlStateNormal];
                [onetab setBackgroundImage:selectedImage forState:UIControlStateSelected];
            }
            [onetab setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [onetab setTitleColor:[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0] forState:UIControlStateNormal];
            [onetab setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [onetab setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [rtval addObject:onetab];
            [onetab release];
        }
    }
    else
    {
        for (int i=0; i<[titleArray count]; i++) {
            if (!rtval) {
                rtval = [NSMutableArray arrayWithCapacity:0];
            }
            DropDownTab* onetab = [[DropDownTab alloc] init];
            UIImage *image = nil;
            UIImage *selectedImage = nil;
            if (i==0) {
                image = [UIImage imageNamed:@"stock_list_bar_left.png"];
                selectedImage = [UIImage imageNamed:@"stock_list_bar_left_selected.png"];
                [onetab setBackgroundImage:image forState:UIControlStateNormal];
                [onetab setBackgroundImage:selectedImage forState:UIControlStateSelected];
            }
            else if (i<[titleArray count]-1) {
                image = [UIImage imageNamed:@"stock_list_bar_middle.png"];
                selectedImage = [UIImage imageNamed:@"stock_list_bar_middle_selected.png"];
                [onetab setBackgroundImage:image forState:UIControlStateNormal];
                [onetab setBackgroundImage:selectedImage forState:UIControlStateSelected];
            }
            else {
                image = [UIImage imageNamed:@"stock_list_bar_right.png"];
                selectedImage = [UIImage imageNamed:@"stock_list_bar_right_selected.png"];
                [onetab setBackgroundImage:image forState:UIControlStateNormal];
                [onetab setBackgroundImage:selectedImage forState:UIControlStateSelected];
            }
            
            [onetab setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [onetab setTitleColor:[UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0] forState:UIControlStateNormal];
            [onetab setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [onetab setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [rtval addObject:onetab];
            [onetab release];
        }
    }
    return rtval;
}

-(void)tabBar:(DropDownTabBar*)tabBar clickedWithIndex:(NSInteger)index byBtn:(BOOL)byBtn
{
    _tip.text = @"";
    _tip2.text = @"";
    _index = index;
    
    if ([self is_my_group]) {
        //自选股中如果未登录，只有第一个tab可以被点击，目前是为了显示【登录后可进行自选股操作】
        BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
        if (hasLogined || index==0) {
            [self didSelectedTabBarWithIndex:index];
        }else{
        
        }
    }else{
        [self didSelectedTabBarWithIndex:index];
    }
}

#pragma mark -
#pragma mark nonbar
-(void)initNonBar
{
    [self didSelectedTabBarWithIndex:0];
}

-(void)didSelectedTabBarWithIndex:(NSInteger)index
{
    //获得multi_bar_cur_index
    _tip.hidden = YES;
    clickTabbarCount ++;
    multi_bar_cur_index = index;
    
    self.errorView.hidden = YES;
    self.loadingView.hidden = YES;
    self.multiTabBar.hidden = NO;
    curIndex = index;
    if ([self.requestTypes count]>curIndex) {
        NSString* requestTypeString = [self.requestTypes objectAtIndex:curIndex];
        NSString* barIndexString = [NSString stringWithFormat:@"%d",curIndex];
        if ([self.requestshowNames count]>curIndex) {
            barIndexString = [self.requestshowNames objectAtIndex:curIndex];
        }
        NSMutableArray* selectedIndexList = [[NSMutableArray alloc] initWithObjects:requestTypeString,barIndexString, nil];
        self.selectID = selectedIndexList;
        [selectedIndexList release];
        NSMutableArray* groupIndexList = [[NSMutableArray alloc] initWithObjects:requestTypeString, nil];
        self.myGroupSelectedID = groupIndexList;
        [groupIndexList release];
        
    }
    else {
        self.selectID = nil;
        self.myGroupSelectedID = nil;
    }

    [self startShowSubBar];
}

-(void)startShowSubBar
{
    bLoading = YES;
    [self.curIndicator startAnimating];
    self.curRefreshBtn.hidden = YES;
    NSString* needGroup = [configItem valueForKey:Stockitem_layout_needmygroup];
    if (needGroup&&[needGroup intValue]>0) {
        NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:1];
        [newArray addObject:[self.selectID objectAtIndex:0]];
        [self.myGroupDict reloadShowedDataWithIDList:self.myGroupSelectedID];
        NSArray* subGroupArray = [self.myGroupDict contentsWithIDList:newArray];
        [newArray release];
        if (!subGroupArray) {
            self.subMultiTabBar.hidden = NO;
            self.loadingView.hidden = NO;
            self.errorView.hidden = YES;
        }
        
        [self refreshWithSubMultiBar:0];
    }
    else {
        NSTimer* timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(startRefreshTableForce) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(void)refreshWithSubMultiBar:(NSInteger)modeIndex
{
    curRefreshMode = modeIndex;
    if (modeIndex==0) {
        bLoadingLocal = YES;
        [self.subMultiTabBar reloadData];
        bLoadingLocal = NO;
        [self.dataTableView startLoadingUI];
    }
    NSArray* groupRequstTypes = (NSArray*)[self.configItem valueForKey:Stockitem_grouprequst_type];
    NSString* service = nil;
    if (curIndex<[groupRequstTypes count]) {
        service = [groupRequstTypes objectAtIndex:curIndex];
    }
    NSDictionary* commandDict = (NSDictionary*)[self.configItem valueForKey:Stockitem_layout_request_command];
    NSString* command = [commandDict valueForKey:Stockitem_layout_request_command_list];
    [[StockFuncPuller getInstance] startMyGroupListWithSender:self service:service command:command args:self.myGroupSelectedID dataList:self.myGroupDict seperateRequst:NO userInfo:[NSNumber numberWithInt:modeIndex]];
}

#pragma mark -
#pragma mark BtnPressed
-(void)handleBackPressed
{
    
    curExited = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleRefreshPressed
{
    bLoading = YES;
    [self.curIndicator startAnimating];
    self.curRefreshBtn.hidden = YES;
    NSString* needGroup = [configItem valueForKey:Stockitem_layout_needmygroup];
    NSLog(@"%@-%@",[configItem dataDict],needGroup);
    if (needGroup&&[needGroup intValue]>0) {
        //之前是1，有居右的问题
        [self refreshWithSubMultiBar:0];
    }
    else {
        [self startRefreshTable:YES firstReload:NO scrollTop:NO];
    }
}

#pragma mark -
#pragma mark calculator

-(void)handleCalculatorPressed:(UIButton*)sender
{
    [[ProjectLogUploader getInstance] writeDataString:@"calculator"];
    
    CGRect addStockRect = sender.frame;
    addStockRect = [self.view convertRect:addStockRect fromView:sender.superview];
    CGRect suggestRect = addStockRect;
    suggestRect.origin.y = addStockRect.origin.y + addStockRect.size.height+5;
    suggestRect.origin.x = 320 - 10 - 280;
    if (!calculatorView) {
        MyStockGroupBackView* calculatorBackView = [[MyStockGroupBackView alloc] initWithFrame:self.view.bounds];
        calculatorBackView.delegate = self;
        calculatorBackView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:calculatorBackView];
        
        CGRect calculatorRect = CGRectMake(5, suggestRect.origin.y, 310, 150);
        ForeignCalculatorView* calculator = [[ForeignCalculatorView alloc] initWithFrame:calculatorRect];
        self.calculatorView = calculator;
        [calculatorBackView addSubview:calculator];
        [calculator release];
        
        UIImage* calculatorArrowImage = [UIImage imageNamed:@"calculator_arrow.png"];
        UIImageView* calculatorArrowView = [[UIImageView alloc] initWithImage:calculatorArrowImage];
        NSInteger arrowX = addStockRect.origin.x + addStockRect.size.width/2;
        NSInteger arrowY = suggestRect.origin.y+4;
        calculatorArrowView.frame = CGRectMake(arrowX, arrowY, 8, 4);
        [calculatorBackView addSubview:calculatorArrowView];
        [calculatorArrowView release];
    }
    else {
        self.calculatorView.superview.hidden = NO;
    }
}

#pragma mark -
#pragma mark addstock

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self addStockClicked:nil];
}

-(void)handleEditPressed:(UIButton*)sender
{
    [[ProjectLogUploader getInstance] writeDataString:@"manage_my_finance_stock"];
    if (isEditing) {
        isEditing = NO;
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
    }
    else {
        isEditing = YES;
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        _tip.text = @"";

    }
    
    [UIView beginAnimations:nil context:NULL];
    CGRect addStockRect = self.addStockView.frame;
    if (isEditing) {
        addStockRect.size.height = 48;
        self.addStockView.alpha = 1.0;
        self.addStockView.frame = addStockRect;
        self.dataTableView.tableView.editing = YES;
    }
    else {
        addStockRect.size.height = 0;
        self.addStockView.alpha = 0.0;
        self.addStockView.frame = addStockRect;
        [self.addStockField resignFirstResponder];
        self.suggestView.superview.hidden = YES;
        self.dataTableView.tableView.editing = NO;
    }
    
    CGRect workingRect = self.workingView.frame;
    NSInteger oldOriginY = workingRect.origin.y;
    workingRect.origin.y = addStockRect.origin.y + addStockRect.size.height;
    int changedHeight = workingRect.origin.y - oldOriginY;
    workingRect.size.height = workingRect.size.height - changedHeight;
    self.workingView.frame = workingRect;
    [UIView commitAnimations];
    if (!isEditing) {
        [self finishEditStock];
    }
}

-(void)addStockClicked:(UIButton*)sender
{
    [self.addStockField resignFirstResponder];
    [self hideSuggestView];
    NSString* text = self.addStockField.text;
    
    [[ProjectLogUploader getInstance] writeDataString:@"manage_add"];
    
    NSArray* groupRequstTypes = (NSArray*)[self.configItem valueForKey:Stockitem_grouprequst_type];
    NSString* service = nil;
    if (curIndex<[groupRequstTypes count]) {
        service = [groupRequstTypes objectAtIndex:curIndex];
    }
    self.suggestView.superview.hidden = YES;
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text&&[text length]>0) {
        NSMutableArray* stockArray = [NSMutableArray arrayWithObject:text];
        NewsObject* oneGroupObject = [self.myGroupDict oneObjectWithIndex:curSubIndex IDList:self.myGroupSelectedID];
        NSString* pid = [oneGroupObject valueForKey:StockFunc_GroupInfo_pid];
        NSDictionary* taskDict = (NSDictionary*)[self.configItem valueForKey:Stockitem_layout_request_command];
        NSString* commandAdd = [taskDict valueForKey:Stockitem_layout_request_command_add];
        
        [[StockFuncPuller getInstance] startMyGroupAddStockWithSender:self service:service stock:stockArray command:commandAdd groupPID:pid args:nil dataList:nil userInfo:nil];
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
            NSArray* groupRequstTypes = (NSArray*)[self.configItem valueForKey:Stockitem_grouprequst_type];
            NSString* service = nil;
            if (curIndex<[groupRequstTypes count]) {
                service = [groupRequstTypes objectAtIndex:curIndex];
            }
            if (service) {
                if ([service isEqualToString:@"PortfoliosService"]) {
                    service = @"cn";
                }
                else if ([service isEqualToString:@"HKstockService"])
                {
                    service = @"hk";
                }
                else if ([service isEqualToString:@"USstockService"])
                {
                    service = @"us";
                }
                else if ([service isEqualToString:@"FundService"])
                {
                    service = @"fund";
                }
            }
            
            [[StockFuncPuller getInstance] startStockSuggestWithSender:self name:text type:0 subtype:service count:10 page:0 args:nil dataList:nil seperateRequst:YES userInfo:nil];
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
    suggestRect.size.height = 120;
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
    if (backView==self.calculatorView.superview) {
        [self.calculatorView finish];
    }
}

-(void)hideSuggestView
{
    suggestView.superview.hidden = YES;
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
    
    [self addStockClicked:self.addStockBtn];
}

#pragma mark -
#pragma mark RefreshTable

-(void)startRefreshTableForceNOTop
{
    [self startRefreshTable:YES firstReload:YES scrollTop:NO];
}

-(void)startRefreshTableForce
{
    [self startRefreshTable:YES firstReload:YES scrollTop:YES];
}

-(void)startRefreshTableNOForce
{
    [self startRefreshTable:NO firstReload:YES scrollTop:NO doneLoading:NO];
}

-(void)startRefreshTable:(BOOL)bForce firstReload:(BOOL)bReload scrollTop:(BOOL)bScrollTop
{
    [self startRefreshTable:bForce firstReload:bReload scrollTop:bScrollTop doneLoading:YES];
}

-(void)startRefreshTable:(BOOL)bForce firstReload:(BOOL)bReload scrollTop:(BOOL)bScrollTop doneLoading:(BOOL)doneLoading
{
    pastedTimeInterval = 0.0;
    seperatorRow = -1;
    BOOL needRefresh = NO;
    if (bForce) {
        needRefresh = YES;
    }
    else
    {
        needRefresh = NO;
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
        [self loadColumWidths];
        [self loadTableHeadView];
        self.dataTableView.selectID = self.selectID;
        if (bScrollTop) {
            [self.dataTableView scrollTop:NO];
        }
        [self.dataTableView setPageMode:PageCellType_Normal];
        [self.dataTableView reloadData];
    }
    
    if (self.selectID&&[self.selectID count]>0) {
        if (needRefresh) {
            if (bScrollTop) {
                [self.dataTableView startLoadingUI];
            }
            NSNumber* bScrollTopNumber = [NSNumber numberWithBool:bScrollTop];
            if ([self.requestTypes count]>curIndex) {
                NSString* requestTypeString = [self.requestTypes objectAtIndex:curIndex];
                if ([[requestTypeString lowercaseString] hasPrefix:@"http://"]) {
                    [[StockFuncPuller getInstance] startListWithSender:self count:countPerPage page:1 withAPICode:[NSArray arrayWithObject:requestTypeString] args:self.selectID dataList:self.dataList userInfo:bScrollTopNumber bInback:NO];
                }
                else {
                    NSString* symbol = nil;
                    if (self.myGroupSelectedID) {
                        NewsObject* oneObject = [self.myGroupDict oneObjectWithIndex:curSubIndex IDList:self.myGroupSelectedID];
                        if (oneObject) {
                            NSArray* symbols = (NSArray*)[oneObject valueForKey:StockFunc_GroupInfo_symbols];
                            symbol = [symbols componentsJoinedByString:@","];
                        }
                    }
                    //如果没有symbol就不显示。2013-1-18日 by 小匀
                    if ([symbol isEqualToString:@""]) {
                        [curIndicator stopAnimating];
                        self.curRefreshBtn.hidden = NO;
                        [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];

                        int i = [[AppDelegate sharedAppDelegate] getTabId];
                        if (i==1) {
                            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"消息提示" message:@"该组合下暂无自选股数据！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
                            [alert show];
                        }
                        
                        return;
                    }
                    NSString* needGroup = [configItem valueForKey:Stockitem_layout_needmygroup];
                    if (needGroup&&[needGroup intValue]>0) {
                        if (symbol) {
                            NewsObject* oneObject = [self.myGroupDict oneObjectWithIndex:curSubIndex IDList:self.myGroupSelectedID];
                            NSString* hqType = [oneObject valueForKey:StockFunc_GroupInfo_hqtype];
                            [[StockFuncPuller getInstance] startMyStockListWithSender:self type:requestTypeString subtype:hqType symbol:symbol count:countPerPage page:1 args:self.selectID dataList:self.dataList userInfo:bScrollTopNumber];
                        }
                        else {
                            if (doneLoading) {
                                bLoading = NO;
                                [self.curIndicator stopAnimating];
                                self.curRefreshBtn.hidden = NO;
                                [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
                            }
                        }
                    }
                    else {                      
                            NSString *mytype =[[self.configItem dataDict] valueForKey:Stockitem_type];
                            
                            //美股需要增加排序功能，特殊处理
                            if ([mytype isEqualToString:@"usstock"]&&_index>=0) {
                                //                        {
                                //                            chg = "2.46%";
                                //                            diff = "0.10";
                                //                            price = "4.17";
                                //                            symbol = AERL;
                                //                        }
                                NSString *orderBoolValue = [orderColumnArray objectAtIndex:_index];
                                NSArray *order = [NSArray arrayWithObjects:@"chg",@"desc", nil];
                                if ([orderBoolValue isEqualToString:@"1"]) {
                                    order = [NSArray arrayWithObjects:@"chg",@"desc", nil];
                                }
                                
                                if ([orderBoolValue isEqualToString:@"2"]) {
                                    order = [NSArray arrayWithObjects:@"chg",@"asc", nil];
                                }
                                
                                if ([orderBoolValue isEqualToString:@"0"]) {
                                    order = [NSArray arrayWithObjects:@"chg",@"null", nil];
                                }
                                
 
                                
                                [[StockFuncPuller getInstance] startStockListWithSender:self
                                                                                   type:requestTypeString
                                                                                 symbol:symbol
                                                                                  count:countPerPage
                                                                                   page:1 args:self.selectID
                                                                               dataList:self.dataList
                                                                               userInfo:bScrollTopNumber
                                                                              orderInfo:order];
                            
                            }else{
                                [[StockFuncPuller getInstance] startStockListWithSender:self
                                                                                   type:requestTypeString
                                                                                 symbol:symbol
                                                                                  count:countPerPage
                                                                                   page:1 args:self.selectID
                                                                               dataList:self.dataList
                                                                               userInfo:bScrollTopNumber];
                            }

                       
                        
                        
                        
                          
                    }
                    
                }
            }
        }
        else
        {
            if (doneLoading) {
                bLoading = NO;
                [self.curIndicator stopAnimating];
                self.curRefreshBtn.hidden = NO;
                [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
            }
        }
    }
    else {
        [self.dataList refreshCommnetContents:nil IDList:self.selectID];
        [self.dataList reloadShowedDataWithIDList:self.selectID];
        if (doneLoading) {
            bLoading = NO;
            [self.curIndicator stopAnimating];
            self.curRefreshBtn.hidden = NO;
            [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
        }
    }
}

#pragma mark -
#pragma mark networkCallback

-(void)cnStockStatusAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    [self updateTipText:userInfo];
}


-(void)hkStockStatusAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    [self updateTipText:userInfo];
}


-(void)usStockStatusAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    [self updateTipText:userInfo];
}

-(void)updateTipText:(NSDictionary *)statDict{
    if (isEditing) {
        //编辑的时候是无论如何不许显示tip的。
        return;
    }
    if ([statDict objectForKey:@"status"]) {
        
        [self.view bringSubviewToFront:_tip];
        [self.view bringSubviewToFront:_tip2];
        
        _tip.hidden = NO;
        int statusValue = [[statDict objectForKey:@"status"] intValue];
        NSString *msg = [statDict objectForKey:@"msg"];
        NSString *hq_time = [statDict objectForKey:@"hq_time"];
      
        //return @"股市休市";
        NSString *mytype =[[self.configItem dataDict] valueForKey:Stockitem_type];
        
        //我的自选股，特殊处理
        if ([mytype isEqualToString:@"mygroup"]) {
            //有子bar+info                  
            CGRect f = _tip.frame;
            f.origin.y = 100;
            _tip.frame = f;
            
            NSLog(@"------%f ",f.origin.y );
            
            CGRect f2 = _tip2.frame;
            f2.origin.y = f.origin.y + 15;
            _tip2.frame = f2;
            
        }else{
            CGRect f = _tip.frame;
            f.origin.y = 70;
            _tip.frame = f;
            
            NSLog(@"------%f ",f.origin.y );
            
            CGRect f2 = _tip2.frame;
            f2.origin.y = f.origin.y + 15;
            _tip2.frame = f2;
        }
        _tip2.hidden = NO;
        //用于测试假日
        //statusValue = 3;
        switch (statusValue) {
            case 1:
                _tip.text = [NSString stringWithFormat:@"%@ 最后更新：%@",msg,hq_time ];
                _tip2.text = @"";
                //我的自选股，特殊处理
                if ([mytype isEqualToString:@"mygroup"]) {
                    //有子bar+info
                    CGRect f = _tip.frame;
                    f.origin.y = 110;
                    _tip.frame = f;
                }else{
                    CGRect f = _tip.frame;
                    f.origin.y = 80;
                    _tip.frame = f;
                }
    
                break;
                
            case 2:
                //我的自选股，特殊处理
                if ([mytype isEqualToString:@"mygroup"]) {
                    //有子bar+info
                    CGRect f = _tip.frame;
                    f.origin.y = 110;
                    _tip.frame = f;
                }else{
                    CGRect f = _tip.frame;
                    f.origin.y = 80;
                    _tip.frame = f;
                }
                _tip.text = [NSString stringWithFormat:@"%@ 最后更新：%@",msg,hq_time ];
                _tip2.text = @"";
                break;
            case 3:
                //我的自选股，特殊处理
                if ([mytype isEqualToString:@"mygroup"]) {
                    //有子bar+info
                    CGRect f = _tip.frame;
                    f.origin.y = 100;
                    _tip.frame = f;
                }else{
                    CGRect f = _tip.frame;
                    f.origin.y = 70;
                    _tip.frame = f;
                }
                
                _tip.text = [NSString stringWithFormat:@"%@",msg ];
                _tip2.text = [NSString stringWithFormat:@"最后更新：%@",hq_time ];
                break;
                
            default:
                break;
        }
    }else{
        //去掉无用显示，避免占主线程。
        if (![[[self.configItem dataDict] objectForKey:@"id"] isEqualToString:@"globalstock"]) {
            if (statDict) {
              [self getStockOnlineTip];
            }
//            [self getStockOnlineTip];
        }
    }
    
    
    
    
//    NSLog(@"userInfo %@",statDict);
}

-(void)StockObjectAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_StockList||[stageNumber intValue]==Stage_Request_MyStockList||[stageNumber intValue]==Stage_Request_APIList) {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSArray* array = [userInfo valueForKey:RequsetArray];
            //
            //    为了保证各平台都可正常使用，请大家以以下文案结构为主：
            //    
            //    1、状态对应信息+最后更新+行情时间
            //    如：
            //    已收盘 最后更新：2012-11-09 15:05:47
            //    周六日休市 最后更新：2012-11-09 15:05:47
            //    
            //    2、当状态为1、2时，即1交易日2周六日，文案一行显示
            //    
            //    3、当状态为3时，文案两行显示
            //    如：国庆节+中秋节休市
            //    最后更新：2012-11-09 15:05:47
            //
            //    4、均为居中显示。
            //            <hq_info>
            //            <hq_time>2012-11-14 10:39:52</hq_time>
            //            <now_time>2012-11-14 10:40:03</now_time>
            //            <status>1</status>
            //            <msg>交易中</msg>
            //            </hq_info>
            //            
            
//            NSLog(@"args= %@",args);
//            NSLog(@"array= %@",array);
//            for (NewsObject *o  in array) {
//               NSLog(@"dataDict= %@",[o dataDict]);
//            }

            
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                NSNumber* bScrollTop = [userInfo valueForKey:RequsetInfo];
                curPage = [pageNumber intValue];
                if ([pageNumber intValue]<=1) {
                    if (bScrollTop&&[bScrollTop boolValue]==NO) {
                        ;
                    }
                    else {
                        [self.dataTableView scrollTop:NO];
                    }
                }
                [self extraDealWithSuccessed];
                
                if ([array count]>=countPerPage) {
                    bLoading = NO;
                    [self.curIndicator stopAnimating];
                    self.curRefreshBtn.hidden = NO;
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
                }
                else {
                    bLoading = NO;
                    [self.curIndicator stopAnimating];
                    self.curRefreshBtn.hidden = NO;
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:YES];
                }
            }
            
            NSDictionary *statDict= [NSDictionary dictionaryWithDictionary:[[userInfo objectForKey:@"RequsetExtra"] objectForKey:@"hq_info"]];
            
            //只有第一次点击的时候才延时调用。这个变态需求是由于展现要单行和双行切换导致的。
            if (clickTabbarCount ==1) {
                if (statDict) {
                    [self performSelector:@selector(updateTipText:) withObject:statDict afterDelay:1];
                }
            
            }else{
                 if (statDict) {
                     [self updateTipText:statDict];
                 }
            }
            
            
//            NSLog(@"userInfo %@",statDict);
            
            
        }
        else if([stageNumber intValue]==Stage_Request_ObtainMyGroupList)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.myGroupSelectedID])
            {
                self.subMultiTabBar.hidden = NO;
                self.loadingView.hidden = YES;
                self.errorView.hidden = YES;
                NSNumber* requsetInfo = [userInfo valueForKey:RequsetInfo];
                [self.myGroupDict reloadShowedDataWithIDList:args];
                NSArray* contents = [self.myGroupDict contentsWithIDList:args];
                NSString* oldPid = nil;
                if ([self.selectID count]>=2) {
                    oldPid = [self.selectID objectAtIndex:1];
                }
                if (oldPid&&contents) {
                    for (int i=0;i<[contents count];i++) {
                        NewsObject* oneGroupObject = [contents objectAtIndex:i];
                        NSString* pid = [oneGroupObject valueForKey:StockFunc_GroupInfo_pid];
                        if ([oldPid isEqualToString:pid]) {
                            NSArray* tabbars = self.subMultiTabBar.tabBarArray;
                            if ([tabbars count]>0) {
                                BCTabBar* oneTabBar = [tabbars objectAtIndex:0];
                                TabBarPreLoadData* preData = [[TabBarPreLoadData alloc] init];
                                preData.selectedIndex = i;
                                oneTabBar.preData = preData;
                                [preData release];
                            }
                            break;
                        }
                    }
                }
                
                [self.subMultiTabBar reloadData];
            }
        }
        else if([stageNumber intValue]==Stage_Request_AddStockSuggest)
        {
            self.suggestArray = [userInfo valueForKey:RequsetExtra];
            if (isEditing) {
                [self addSuggestView];
            }
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
            NSString* oldStock = self.addStockField.text;
            if ([stock containsObject:oldStock]) {
                self.addStockField.text = @"";
            }
            [self handleRefreshPressed];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
        else if([stageNumber intValue]==Stage_Request_RemoveMyGroup)
        {
            [self startAutoRefresh];
            NSDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
            NSArray* stock = [extraDict valueForKey:@"stock"];
            NSString* msg = nil;
            if ([stock count]<4) {
                msg = [NSString stringWithFormat:@"删除股票[%@]成功!",[stock componentsJoinedByString:@","]];
            }
            else {
                msg = [NSString stringWithString:@"删除股票成功!"];
            }
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
        else if([stageNumber intValue]==Stage_Request_ReorderMyGroup)
        {
            [self startAutoRefresh];
            NSString* msg = [NSString stringWithString:@"调整股票顺序成功!"];
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
        if([stageNumber intValue]==Stage_Request_StockList||[stageNumber intValue]==Stage_Request_MyStockList||[stageNumber intValue]==Stage_Request_APIList)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID])
            {
                if (!isMystockDefaultView) {
                    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                }
                
                bLoading = NO;
                [self.curIndicator stopAnimating];
                self.curRefreshBtn.hidden = NO;
                [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
            }
        }
        else if([stageNumber intValue]==Stage_Request_ObtainMyGroupList)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.myGroupSelectedID])
            {
                NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:1];
                [newArray addObject:[self.selectID objectAtIndex:0]];
                [self.myGroupDict reloadShowedDataWithIDList:self.myGroupSelectedID];
                NSArray* subGroupArray = [self.myGroupDict contentsWithIDList:newArray];
                [newArray release];
                if (!subGroupArray) {
                    self.subMultiTabBar.hidden = NO;
                    self.loadingView.hidden = YES;
                    self.errorView.hidden = NO;
                }
                [self.curIndicator stopAnimating];
                bLoading = NO;
                self.curRefreshBtn.hidden = NO;
                [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
                if (curRefreshMode!=2) {
                    if (!isMystockDefaultView) {
                        [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                    }
                }
            }
            
        }
        else if([stageNumber intValue]==Stage_Request_AddStockSuggest)
        {
            self.suggestArray = [userInfo valueForKey:RequsetExtra];
            if (isEditing) {
                [self.suggestView setData:nil];
                self.suggestView.loadState = GroupViewState_Error;
            }
        }
        else if([stageNumber intValue]==Stage_Request_AddMyGroup)
        {
            NSDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
            NSString* oldMsg = [extraDict valueForKey:@"msg"];
            if (!oldMsg) {
                oldMsg = @"请检查网络后重试";
            }
            NSString* msg = [NSString stringWithFormat:@"添加股票失败,%@",oldMsg];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
        else if([stageNumber intValue]==Stage_Request_RemoveMyGroup)
        {
            [self startAutoRefresh];
            NSDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
            NSString* oldMsg = [extraDict valueForKey:@"msg"];
            if (!oldMsg) {
                oldMsg = @"请检查网络后重试";
            }
            NSString* msg = [NSString stringWithFormat:@"删除股票失败,%@",oldMsg];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
        else if([stageNumber intValue]==Stage_Request_ReorderMyGroup)
        {
            [self startAutoRefresh];
            NSDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
            NSString* oldMsg = [extraDict valueForKey:@"msg"];
            if (!oldMsg) {
                oldMsg = @"请检查网络后重试";
            }
            NSString* msg = [NSString stringWithFormat:@"调整股票顺序失败,%@",oldMsg];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
}

-(void)extraDealWithSuccessed
{
    NSString* keepTopItemName = [self.configItem valueForKey:Stockitem_keeptop_itemname];
    if ([keepTopItemName isKindOfClass:[NSArray class]]) {
        NSArray* itemNames = (NSArray*)keepTopItemName;
        if ([itemNames count]>curIndex) {
            keepTopItemName = [itemNames objectAtIndex:curIndex];
        }
        else {
            keepTopItemName = nil;
        }
    }
    if (keepTopItemName&&[keepTopItemName length]>0) {
        [self.dataList reloadShowedDataWithIDList:self.selectID];
        NSArray* allObjects = [self.dataList contentsWithIDList:self.selectID];
        NSMutableArray* newArray = [[NSMutableArray alloc] initWithArray:allObjects];
        NewsObject* huilvObject = nil;
        if ([[self.selectID objectAtIndex:0] isEqualToString:StockListType_ForiegnExchangeBasic])
        {
            NewsObject* dollarRmbObject = nil;
            for (NewsObject* oneObject in newArray) {
                NSString* name = [oneObject valueForKey:StockFunc_OneStock_name];
                if ([name isEqualToString:@"美元人民币"]) {
                    dollarRmbObject = oneObject;
                    break;
                }
            }
            if (dollarRmbObject) {
                [dollarRmbObject retain];
                [newArray removeObject:dollarRmbObject];
                [newArray insertObject:dollarRmbObject atIndex:0];
                [dollarRmbObject release];
            }
        }
        
        for (NewsObject* oneObject in newArray) {
            NSString* name = [oneObject valueForKey:StockFunc_OneStock_name];
            if ([name isEqualToString:keepTopItemName]) {
                huilvObject = oneObject;
                break;
            }
        }
        [huilvObject setUserInfoValue:[NSNumber numberWithBool:YES] forKey:HasCellSeperator];
        if (huilvObject) {
            [huilvObject retain];
            [newArray removeObject:huilvObject];
            [newArray insertObject:huilvObject atIndex:0];
            [huilvObject release];
        }
        [self.dataList refreshCommnetContents:newArray IDList:self.selectID];
        [newArray release];
    }
}

#pragma mark -
#pragma mark DataListTableView
-(UITableViewCell*)dataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    if (_timer ) {
        [_timer  invalidate];
        _timer = nil;
    }
//    if (![[[self.configItem dataDict] objectForKey:@"id"] isEqualToString:@"globalstock"]) {
//        //全球股指--莫名会崩溃，待查
//        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(getStockOnlineTip) userInfo:nil repeats:YES];
//    }
    
    

    
    int row = path.row;
    static NSString *CellIdentifier = @"StockDataCell";
    
    StockListCell *cell = (StockListCell*)[view.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[[StockListCell alloc] initWithCellType:StockListCell_SingleName reuseIdentifier:CellIdentifier] autorelease];
        cell.leftMargin = 10;
    }
    
    NSString* bRedSize = [configItem valueForKey:Stockitem_layout_redrise];
    if ([bRedSize isKindOfClass:[NSArray class]]) {
        if (curIndex<[(NSArray*)bRedSize count]) {
            bRedSize = [(NSArray*)bRedSize objectAtIndex:curIndex];
        }
        else {
            bRedSize = nil;
        }
    }
    
    NSInteger colorType = 0;
    if ([bRedSize intValue]>0) {
        colorType = kSHZhangDie;
    }
    cell.columnWidths =self.curColumnWidths;
    
    UILabel* firstLabel = [cell labelWithIndex:0];
    if (firstLabel) {
        firstLabel.numberOfLines = 2;
    }
    
    NSString* stockName = nil;
    NSArray* configArray = [self layoutConfigArray];
    UIColor* decideColor = nil;
    NSString* ReplacedZeroNull = nil;
    NSMutableArray* decideColorArray = nil;
    NSMutableArray* decideNullArray = nil;
    
    for (int i=0;i<[configArray count];i++) {
        NSDictionary* configDict = [configArray objectAtIndex:i];
        NSString* codevalue = [configDict valueForKey:Stockitem_layout_codevalue];
        NSString* stringStyle =  [configDict valueForKey:Stockitem_layout_stringstyle];
        NSString* bDecideColor =  [configDict valueForKey:Stockitem_layout_decidecolor];
        NSString* bDecidenull =  [configDict valueForKey:Stockitem_layout_decidenull];
        NSString* bJustname =  [configDict valueForKey:Stockitem_layout_justname];
        NSString* value = [object valueForKey:codevalue];
        if (i==0) {
            //NSLog(@"symbol--%@,%@",[object valueForKey:@"symbol"],value);
            stockName =value;
        }
        
        
        
        UILabel* oneLabel = [cell labelWithIndex:i];
        if (!(bJustname&&[bJustname intValue]>0)) {
            if (bDecidenull&&[bDecidenull isKindOfClass:[NSString class]]&&[bDecidenull intValue]>0) {
                if([value isKindOfClass:[NSNull class]]||[value floatValue]==0.0)
                {
                    ReplacedZeroNull = @"--";
                }
            }
            else if(bDecidenull&&[bDecidenull isKindOfClass:[NSArray class]])
            {
                if([value isKindOfClass:[NSNull class]]||[value floatValue]==0.0)
                {
                    ReplacedZeroNull = @"--";
                    if (!decideNullArray) {
                        decideNullArray = [NSMutableArray arrayWithCapacity:0];
                        for (int j=0; j<[configArray count]; j++) {
                            [decideNullArray addObject:[NSNull null]];
                        }
                    }
                    for (NSString* oneRow in (NSArray*)bDecidenull) {
                        if ([oneRow intValue]<[decideNullArray count]) {
                            [decideNullArray replaceObjectAtIndex:[oneRow intValue] withObject:ReplacedZeroNull];
                        }
                    }
                }
                
            }
            
            if ([value isKindOfClass:[NSString class]]) {
                NSString* formatValue = [StockListViewController2 formatFloatString:value style:stringStyle];
                oneLabel.text = formatValue;
            }
            else {
                oneLabel.text = @"--";
            }
            
            if (bDecideColor&&[bDecideColor isKindOfClass:[NSString class]]&&[bDecideColor intValue]>0) {
                decideColor = [[ShareData sharedManager] textColorWithValue:[value floatValue] marketType:colorType];
            }
            else if(bDecideColor&&[bDecideColor isKindOfClass:[NSArray class]])
            {
                decideColor = [[ShareData sharedManager] textColorWithValue:[value floatValue] marketType:colorType];
                if (!decideColorArray) {
                    decideColorArray = [NSMutableArray arrayWithCapacity:0];
                    for (int j=0; j<[configArray count]; j++) {
                        [decideColorArray addObject:[NSNull null]];
                    }
                }
                
                for (NSString* oneRow in (NSArray*)bDecideColor) {
                    if ([oneRow intValue]<[decideColorArray count]) {
                        [decideColorArray replaceObjectAtIndex:[oneRow intValue] withObject:decideColor];
                    }
                }
            }
            
        }
        else {
            if ([value isKindOfClass:[NSString class]]) {
                oneLabel.text = [value isEqualToString:@""]?[object valueForKey:@"symbol"] :value;
            }
            else {
                oneLabel.text = @"--";
            }
        }
        if (!decideColor&&i==[configArray count]-1) {
            decideColor = [[ShareData sharedManager] textColorWithValue:[value floatValue] marketType:colorType];
        }
    }
    
    for (int i=0;i<[configArray count];i++)
    {
        NSDictionary* configDict = [configArray objectAtIndex:i];
        NSString* bJustname =  [configDict valueForKey:Stockitem_layout_justname];
        UILabel* oneLabel = [cell labelWithIndex:i];
        if (!(bJustname&&[bJustname intValue]>0))
        {
            if (decideColor) {
                if (decideColorArray&&[decideColorArray count]>0) {
                    UIColor* oneColor = [decideColorArray objectAtIndex:i];
                    if (![oneColor isKindOfClass:[NSNull class]]) {
                        oneLabel.textColor = oneColor;
                    }
                    else {
                        oneLabel.textColor = [UIColor whiteColor];
                    }
                }
                else
                {
                    oneLabel.textColor = decideColor;
                }
            }
            else {
                oneLabel.textColor = [UIColor whiteColor];
            }
            if (ReplacedZeroNull) {
                if (decideNullArray&&[decideNullArray count]>0) {
                    NSString* oneString = [decideNullArray objectAtIndex:i];
                    if (![oneString isKindOfClass:[NSNull class]]) {
                        oneLabel.text = oneString;
                    }
                }
                else
                {
                    oneLabel.text =ReplacedZeroNull;
                }
            }
        }
    }
    
    NSArray* realTimeStocks = (NSArray*)[configItem valueForKey:Stockitem_realtime_stocks];
    if (realTimeStocks&&stockName&&[realTimeStocks containsObject:stockName]) {
        cell.bRealtime = YES;
    }
    else {
        cell.bRealtime = NO;
    }
    
    if ([self.titleString isEqualToString:@"热门美股"]) {
        if (stockName&&[stockName isEqualToString:@"纳斯达克"]) {
            cell.bDelaytime = YES;
        }else{
            cell.bDelaytime = NO;
        }
    }
    
    
    if (seperatorRow>=0&&row>seperatorRow) {
        row = row - 1;
    }
    if(row % 2 == 0){
        cell.contentView.backgroundColor = [UIColor colorWithRed:3.0/255 green:21.0/255 blue:59.0/255 alpha:1.0];
    }
    else{
        cell.contentView.backgroundColor = [UIColor colorWithRed:16.0/255 green:42.0/255 blue:89.0/255 alpha:1.0];
    }
    NSNumber* hasSeperator = [object userInfoValueForKey:HasCellSeperator];
    if (hasSeperator&&[hasSeperator boolValue]==YES) {
        cell.hasSeperatorLine = YES;
        seperatorRow = row;
        
    }
    else {
        cell.hasSeperatorLine = NO;
    }
    return cell;
}

-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    return 40;
}

-(void)dataListView:(DataListTableView*)view didSelectedAtIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    [view.tableView deselectRowAtIndexPath:path animated:YES];
    ;
    self.suggestView.superview.hidden = YES;
    NSString* curSymbolString = [self getSymbolCode];
    NSString* curSymbolIndex = @"0";
    NSArray* symbolArray = (NSArray*)[configItem valueForKey:Stockitem_layout_symbolname_index];
    if ([symbolArray isKindOfClass:[NSString class]]) {
        curSymbolIndex = (NSString*)symbolArray;
    }
    else if([symbolArray isKindOfClass:[NSArray class]])
    {
        if (curIndex<[symbolArray count]) {
            curSymbolIndex = [symbolArray objectAtIndex:curIndex];
        }
    }
    
    if (curSymbolString&&![curSymbolString isEqualToString:@""]) {
        NSString* symbolcode = curSymbolString;
        NSString* symbol = [object valueForKey:symbolcode];
        NSString* name = nil;
        NSArray* configArray = [self layoutConfigArray];
        if ([configArray count]>0) {
            NSDictionary* configDict = [configArray objectAtIndex:[curSymbolIndex intValue]];
            NSString* codevalue = [configDict valueForKey:Stockitem_layout_codevalue];
            
            name = [object valueForKey:codevalue];
        }
        
        BOOL canClicked = NO;
        NSArray* clickenableStocks = (NSArray*)[configItem valueForKey:Stockitem_layout_clickenable];
        if (clickenableStocks) {
            if ([clickenableStocks isKindOfClass:[NSString class]]) {
                if ([(NSString*)clickenableStocks isEqualToString:@"all"]) {
                    canClicked = YES;
                }
                else {
                    clickenableStocks = [NSArray arrayWithObject:clickenableStocks];
                }
            }
            if (!canClicked) {
                if ([clickenableStocks containsObject:name]) {
                    canClicked = YES;
                }
                else {
                    canClicked = NO;
                }
            }
        }
        else {
            canClicked = NO;
        }
        if (canClicked) {
            NSString* stockType = [configItem valueForKey:Stockitem_layout_typeitem];
            if ([stockType isKindOfClass:[NSDictionary class]]) {
                stockType = [(NSDictionary*)stockType valueForKey:name];
            }
            if ([stockType isKindOfClass:[NSArray class]]) {
                stockType = [(NSArray*)stockType objectAtIndex:curIndex];
            }
            
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

- (CGFloat)dataListView:(DataListTableView*)view heightForHeaderInSection:(NSInteger)section
{
    NSString* content_tip = [configItem valueForKey:Stockitem_content_tip];
    if ([content_tip isKindOfClass:[NSArray class]]) {
        NSArray* itemNames = (NSArray*)content_tip;
        if ([itemNames count]>curIndex) {
            content_tip = [itemNames objectAtIndex:curIndex];
        }
        else {
            content_tip = nil;
        }
    }
    NSString* hasTableHeader = [configItem valueForKey:Stockitem_tableheader];
    BOOL hasContentTip = (content_tip&&[content_tip length]>0);
    BOOL hasTabHeader = (hasTableHeader&&[hasTableHeader intValue]>0);
    CGFloat maxHeight = 0.0;
    if (hasContentTip||hasTabHeader) {
        if (hasContentTip) {
            maxHeight += 30.0;
        }
        if (hasTabHeader) {
            maxHeight += 30.0;
        }
    }
    return maxHeight;
}

- (UIView *)dataListView:(DataListTableView*)view viewForHeaderInSection:(NSInteger)section
{
    
    _tip.hidden = YES;
    NSString* content_id = [configItem valueForKey:Stockitem_type];
    NSString* content_tip = [configItem valueForKey:Stockitem_content_tip];
    

    if ([content_tip isKindOfClass:[NSArray class]]) {
        NSArray* itemNames = (NSArray*)content_tip;
        if ([itemNames count]>curIndex) {
            content_tip = [itemNames objectAtIndex:curIndex];
        }
        else {
            content_tip = nil;
        }
    }
    NSString* hasTableHeader = [configItem valueForKey:Stockitem_tableheader];
    BOOL hasContentTip = (content_tip&&[content_tip length]>0);
    BOOL hasTabHeader = (hasTableHeader&&[hasTableHeader intValue]>0);
    if (hasContentTip||hasTabHeader) {
        UIView* headerBackView = [[[UIView alloc] init] autorelease];
        int maxHeight = 0;
        if (hasContentTip) {
            maxHeight += 30;
        }
        if (hasTabHeader) {
            maxHeight += 30;
        }
        CGRect backRecty = CGRectMake(0, 0, 320, maxHeight);
        headerBackView.frame = backRecty;
        headerBackView.backgroundColor = [UIColor colorWithRed:1/255.0 green:25/255.0 blue:69/255.0 alpha:1.0];
        NSInteger curY = 0;
        if (hasContentTip) {
            //沪深排行显示—tip
            if ([content_id isEqualToString:@"shstock"]  || [content_id isEqualToString:@"usstock"] ||[content_id isEqualToString:@"hkstock"]   ) {
                _tip.hidden = NO;
            }else if ([content_id isEqualToString:@"mygroup"] && multi_bar_cur_index != 3) {
                //我的自选中除了基金 都 显示-tip
                _tip.hidden = NO;
            }
            else{
                UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, curY, 320, 30)];
                tipLabel.backgroundColor = [UIColor clearColor];
                tipLabel.font = [UIFont systemFontOfSize:14.0];
                tipLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                tipLabel.tag=12000;
                tipLabel.text = content_tip;
                tipLabel.textColor = [UIColor colorWithRed:85/255.0 green:103/255.0 blue:135/255.0 alpha:1.0];
                tipLabel.textAlignment = UITextAlignmentCenter;
                tipLabel.adjustsFontSizeToFitWidth = YES;
                [headerBackView addSubview:tipLabel];
                _tip2.text = @"";
            }
            
            curY += 30;
        }
        if (hasTabHeader) {
            StockListCell* cell = [[[StockListCell alloc] initWithCellType:StockListCell_SingleName reuseIdentifier:@"cell"] autorelease];
            cell.columnWidths = self.curColumnWidths;
            cell.leftMargin = 10;
            NSArray* cofigArray = [self layoutConfigArray];
            for (UIView *v in cell.subviews) {
                if ([v isKindOfClass:[UIButton class]]) {
                    [v removeFromSuperview];
                }
            }
            for (int i=0; i<[cofigArray count]; i++) {
                NSDictionary* cofigDict = [cofigArray objectAtIndex:i];
                NSNumber* widthNumber = [cofigDict valueForKey:Stockitem_layout_headwidth];
                NSString* headName = [cofigDict valueForKey:Stockitem_layout_headname];
                if (!widthNumber) {
                    widthNumber = [NSNumber numberWithInt:default_Stockitem_layout_headwidth];
                }
                else if([widthNumber isKindOfClass:[NSString class]])
                {
                    widthNumber = [NSNumber numberWithInt:[(NSString*)widthNumber intValue]];
                }
                UILabel* oneLabel = [cell labelWithIndex:i];
                oneLabel.text = headName;
                oneLabel.textColor = [UIColor colorWithRed:120/255.0 green:129/255.0 blue:148/255.0 alpha:1.0];
                //for enable_order start
                NSString* enable_order = [cofigDict valueForKey:Stockitem_layout_enable_order];
                NSLog(@"--%@",enable_order);
                if (!enable_order) {
                    enable_order = @"n";
                }
                
                
#define order_image_left 64
                #define order_image_top 7
#define order_image_width 17
                if ([enable_order isEqualToString:@"y"]) {
                    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    orderBtn.tag = 4000+_index;
                    
                    CGRect f = oneLabel.frame;
                    //f.size.height -= 10;
                    orderBtn.frame = f;
                    NSString *orderBoolValue = [orderColumnArray objectAtIndex:_index];
                    if ([orderBoolValue isEqualToString:@"1"]) {
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_desc"]];
                        imageView.frame = CGRectMake(order_image_left, order_image_top, order_image_width, order_image_width);
                        [orderBtn addSubview:imageView];
                        [imageView release];
                    }else if ([orderBoolValue isEqualToString:@"0"]) {
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_null"]];
                        imageView.frame = CGRectMake(order_image_left,order_image_top, order_image_width, order_image_width);
                        [orderBtn addSubview:imageView];
                        [imageView release];
                    }
                    else{
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"order_asc"]];
                        imageView.frame = CGRectMake(order_image_left, order_image_top, order_image_width, order_image_width);
                        [orderBtn addSubview:imageView];
                        [imageView release];
                    }
                    
                    [orderBtn addTarget:self action:@selector(sortBtnHandleEvent:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:orderBtn];
                }
                //end enable_order
            }
            cell.frame = CGRectMake(0, curY, 320, 30);
            cell.contentView.frame = CGRectMake(0, curY, 320, 30);
            cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [headerBackView addSubview:cell.contentView];
            curY += 30;
        }
        return headerBackView;
    }
    else {
        return nil;
    }
}

-(void)sortBtnHandleEvent:(UIButton *)sender{
//    orderBoolValue = !orderBoolValue;
//    
//    NSLog(@"sss %d",orderBoolValue);
    
    int i = sender.tag - 4000;
    NSString *s = [self.orderColumnArray objectAtIndex:i];

    NSMutableArray* order_columnArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    int f = 0;
    for (NSString* curOrderStatus in self.orderColumnArray) {
        if (f == i) {
            if ([s isEqualToString:@"0"]) {
                [order_columnArray addObject:@"1"];
            }else if ([s isEqualToString:@"1"]) {
                [order_columnArray addObject:@"2"];
            }else if ([s isEqualToString:@"2"]){
                [order_columnArray addObject:@"0"];
            }
            
        }else{
            [order_columnArray addObject:curOrderStatus];
        }
        f++;
    }
    self.orderColumnArray = nil;
    self.orderColumnArray = order_columnArray;
    NSLog(@"%@",  self.orderColumnArray );

    [self startRefreshTableForce];
    
}

-(void)dataListViewDidMoreClicked:(DataListTableView*)view
{
    if ([self.requestTypes count]>curIndex) {
        NSString* requestTypeString = [self.requestTypes objectAtIndex:curIndex];
        
    }
}
-(void)dataListViewDidRefreshTriggered:(DataListTableView*)view
{
    [self handleRefreshPressed];
}

-(PageTableViewCell*)dataListView:(DataListTableView*)view PageCellStyleIdentifier:(NSString*)identifier
{
    PageTableViewCell* rtval = [[[PageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    [rtval setTipString:@"更多..." forType:PageCellType_Normal];
    [rtval setTipColor:[UIColor whiteColor] forType:PageCellType_Normal];
    [rtval setTipColor:[UIColor whiteColor] forType:PageCellType_Ending];
    return rtval;
}

-(void)dataListViewWillBeginDragging:(DataListTableView*)view
{
    if (isEditing) {
        [self.addStockField resignFirstResponder];
    }
}

- (BOOL)dataListView:(DataListTableView *)view canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* needGroup = [configItem valueForKey:Stockitem_layout_needmygroup];
    if (needGroup&&[needGroup intValue]>0) {
        return YES;
    }
    else {
        return NO;
    }
}

- (UITableViewCellEditingStyle)dataListView:(DataListTableView *)view editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)dataListView:(DataListTableView *)view commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        if (!deleteArray) {
            deleteArray = [[NSMutableArray alloc] initWithCapacity:0];
        }
        int rowInt = indexPath.row;
        NewsObject* oneObject = [self.dataList oneObjectWithIndex:rowInt IDList:self.selectID];
        NSString* symbolCode = [self getSymbolCode];
        NSString* symbol = [oneObject valueForKey:symbolCode];
        [deleteArray addObject:symbol];
        NSMutableArray* array = (NSMutableArray*)[self.dataList contentsWithIDList:self.selectID];
        [array removeObjectAtIndex:rowInt];
        [view.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        if (!isEditing) {
            [self finishEditStock];
        }
    }
}

- (BOOL)dataListView:(DataListTableView *)view canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)dataListView:(DataListTableView *)view moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if (fromIndexPath.row!=toIndexPath.row) {
        hasReorder = YES;
        NSMutableArray* array = (NSMutableArray*)[self.dataList contentsWithIDList:self.selectID];
        [array exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    }
}

-(void)finishEditStock
{
    if (self.deleteArray&&[self.deleteArray count]>0) {
        NSArray* groupRequstTypes = (NSArray*)[self.configItem valueForKey:Stockitem_grouprequst_type];
        NSString* service = nil;
        if (curIndex<[groupRequstTypes count]) {
            service = [groupRequstTypes objectAtIndex:curIndex];
        }
        NSDictionary* commandDict = (NSDictionary*)[self.configItem valueForKey:Stockitem_layout_request_command];
        NSString* command = [commandDict valueForKey:Stockitem_layout_request_command_remove];
        NewsObject* oneGroupObject = [self.myGroupDict oneObjectWithIndex:curSubIndex IDList:self.myGroupSelectedID];
        NSString* pid = [oneGroupObject valueForKey:StockFunc_GroupInfo_pid];
        [[StockFuncPuller getInstance] startMyGroupRemoveStockWithSender:self service:service stock:self.deleteArray command:command groupPID:pid args:nil dataList:nil userInfo:nil];
        self.deleteArray = nil;
    }
    if (hasReorder) {
        hasReorder = NO;
        NSArray* groupRequstTypes = (NSArray*)[self.configItem valueForKey:Stockitem_grouprequst_type];
        NSString* service = nil;
        if (curIndex<[groupRequstTypes count]) {
            service = [groupRequstTypes objectAtIndex:curIndex];
        }
        NSDictionary* commandDict = (NSDictionary*)[self.configItem valueForKey:Stockitem_layout_request_command];
        NSString* command = [commandDict valueForKey:Stockitem_layout_request_command_order];
        NewsObject* oneGroupObject = [self.myGroupDict oneObjectWithIndex:curSubIndex IDList:self.myGroupSelectedID];
        NSString* pid = [oneGroupObject valueForKey:StockFunc_GroupInfo_pid];
        NSArray* stockArray = [self.dataList contentsWithIDList:self.selectID];
        NSMutableArray* symbolArray = [NSMutableArray arrayWithCapacity:0];
        NSString* symbolCode = [self getSymbolCode];
        for (NewsObject* oneStock in stockArray) {
            NSString* symbol = [oneStock valueForKey:symbolCode];
            [symbolArray addObject:symbol];
        }
        [[StockFuncPuller getInstance] startMyGroupReorderStockWithSender:self service:service stock:symbolArray command:command groupPID:pid args:nil dataList:nil userInfo:nil];
    }
    [self performSelector:@selector(getStockOnlineTip) withObject:nil afterDelay:0.5];
}

-(NSString*)getSymbolCode
{
    NSString* curSymbolString = nil;
    NSArray* symbolArray = (NSArray*)[configItem valueForKey:Stockitem_stocksymbol_keys];
    if ([symbolArray isKindOfClass:[NSString class]]) {
        curSymbolString = (NSString*)symbolArray;
    }
    else {
        if (curIndex<[symbolArray count]) {
            curSymbolString = [symbolArray objectAtIndex:curIndex];
        }
    }
    return curSymbolString;
}

#pragma mark -
#pragma mark commonconfig
+(NSString*)formatFloatString:(NSString*)sourceString style:(NSString*)style
{
    if (style&&!([MyTool isDigtal:style]&&[style intValue]==0)) {
        NSString* testString = sourceString;
        testString = [MyTool digtalStringFromPrefixSufixDigtalString:testString];
        if ([testString length]>0&&[testString floatValue]==0.0) {
            sourceString = @"0.0";
        }
    }
    
    if ([style isEqualToString:@"%"]) {
        return [NSString stringWithFormat:@"%@",sourceString];
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

-(NSArray*)layoutConfigArray
{
    NSArray* rtval = nil;
    NSArray* layoutKeys = (NSArray*)[configItem valueForKey:Stockitem_request_layoutkey];
    if (curIndex<[layoutKeys count]) {
        NSString* layoutKey = [layoutKeys objectAtIndex:curIndex];
        rtval = (NSArray*)[configItem valueForKey:layoutKey];
    }
    return rtval;
}

-(void)loadColumWidths
{
    [curColumnWidths removeAllObjects];
    NSArray* cofigArray = [self layoutConfigArray];
    for (int i=0; i<[cofigArray count]; i++) {
        NSDictionary* cofigDict = [cofigArray objectAtIndex:i];
        NSNumber* widthNumber = [cofigDict valueForKey:Stockitem_layout_headwidth];
        if (!widthNumber) {
            widthNumber = [NSNumber numberWithInt:default_Stockitem_layout_headwidth];
        }
        else if([widthNumber isKindOfClass:[NSString class]])
        {
            widthNumber = [NSNumber numberWithInt:[(NSString*)widthNumber intValue]];
        }
        if (!curColumnWidths)
        {
            curColumnWidths = [[NSMutableArray alloc] initWithCapacity:0];
        }
        [curColumnWidths addObject:widthNumber];
    }
}

-(void)loadTableHeadView
{
    
}


/**
 *
 行情说明文字:
 开盘中:19日09:30:00,请及时刷新以下实时数据
 已收盘:19日11:30:00,请点击股票查看盘中走势
 已收盘:19日15:00:00,请点击股票查看盘中走势
 
 开盘时间:周一至周五
 9:30-11:30
 13:00-15:00
 节假日除外
 *
 */
-(void)getStockOnlineTip{
  
    if (isEditing) {
        _tip.text = @"";
        _tip2.text = @"";
        return;
    }
//    NSLog(@"%@---",[self getStockOnlineTipString]);
    [self.view bringSubviewToFront:_tip];
 

    //return @"股市休市";
    NSString *mytype =[[self.configItem dataDict] valueForKey:Stockitem_type];
    
    //我的自选股，特殊处理
    if ([mytype isEqualToString:@"mygroup"]) {
          if (multi_bar_cur_index == 0) {
              //[self processTipWithCounty:@"cn"];
              [[StockFuncPuller getInstance] getStockStatusData_cn];
          }
        if (multi_bar_cur_index == 1) {
            //[self processTipWithCounty:@"hk"];
            [[StockFuncPuller getInstance] getStockStatusData_hk];
        }
        
        if (multi_bar_cur_index == 2) {
            //[self processTipWithCounty:@"us"];
            [[StockFuncPuller getInstance] getStockStatusData_us];
        }
        
        return;
    }
    //沪深，美股，港股 --显示tip    
    if ([mytype isEqualToString:@"shstock"]||[mytype isEqualToString:@"usstock"]||[mytype isEqualToString:@"hkstock"]) {
        NSString *county = [[self.configItem dataDict] valueForKey:Stockitem_layout_typeitem];
        
        if ([county isEqualToString:@""]) {
            return;
        }
        if ([county isEqualToString:@"cn"]||[county isEqualToString:@"hk"]||[county isEqualToString:@"us"]) {
            [self processTipWithCounty:county];
        }else{
            return;
        }
        
    }else{
        return;
    }
}

-(void)processTipWithCounty:(NSString *)county{
    NSString *s =  [[StockFuncPuller getInstance] getHolidayNameByCounty:county];
    
    
    
    if ([s length]>0) {
//        NSString *lastTimeStr;
//        if ([county isEqualToString:@"cn"]) {
//            lastTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"cn_lasttime"];
//        }
//        if ([county isEqualToString:@"hk"]) {
//            lastTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"hk_lasttime"];
//        }
//        if ([county isEqualToString:@"us"]) {
//            lastTimeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"us_lasttime"];
//        }
        
        [_tip setText:[NSString  stringWithFormat:@"%@,休市",s]];
    }else{
        
        
        //节假日除外
        if ([self isDateWeekly]) {
            [_tip setText:@"周末,休市"];
        }else{
            
            if ([county isEqualToString:@"cn"]) {
//                [_tip setText:[self getStockOnlineTipString_cn]];
                [[StockFuncPuller getInstance] getStockStatusData_cn];
            }
            
            if ([county isEqualToString:@"hk"]) {
//                [_tip setText:[self getStockOnlineTipString_hk]];
                [[StockFuncPuller getInstance] getStockStatusData_hk];
            }
            
            if ([county isEqualToString:@"us"]) {
//                [_tip setText:[self getStockOnlineTipString_us]];
                [[StockFuncPuller getInstance] getStockStatusData_us];
            }
            
        }
    }

}

-(NSString *)getStockOnlineTipString_cn{
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    _now=[NSDate date];
    _comps = [_calendar components:unitFlags fromDate:_now];
    
    int year = [_comps year];
    int mon = [_comps month];
    int day = [_comps day];
    int hour = [_comps hour];
    int min = [_comps minute];
    int second = [_comps second];
    
    NSString *_s = [NSString  stringWithFormat:@"%d",second];
    if (second<10) {
        _s = [NSString  stringWithFormat:@"0%d",second];
    }
    NSString *_mon = [NSString  stringWithFormat:@"%d",mon];
    if (mon < 10) {
        _mon = [NSString  stringWithFormat:@"0%d",mon];
    }
    
    NSString *_day = [NSString  stringWithFormat:@"%d",day];
    if (day < 10) {
        _day = [NSString  stringWithFormat:@"0%d",day];
    }
    
    NSString *_min = [NSString  stringWithFormat:@"%d",min];
    if (min < 10) {
        _min = [NSString  stringWithFormat:@"0%d",min];
    }
    
    NSString *_h = [NSString  stringWithFormat:@"%d",hour];
    if (hour < 10) {
        _h = [NSString  stringWithFormat:@"0%d",hour];
    }
    
    NSString *str = [NSString stringWithFormat:@"%d-%@-%@ %@:%@:%@",year,_mon,_day,_h,_min,_s];
    NSString *lastTimeStr =@"";// [[NSUserDefaults standardUserDefaults] objectForKey:@"cn_lasttime"];
    //9:30-11:30
    if (hour >8 && hour <12) {
        if (hour == 9 && min < 30) {
            if ([lastTimeStr length]>0) {
                return [NSString stringWithFormat:@" 已收盘,最后更新时间%@",lastTimeStr];
            }else{
                return [NSString stringWithFormat:@" 已收盘,请点击股票查看盘中走势"];
            }
        
        }
        
        if (hour == 11 && min > 29) {
            if ([lastTimeStr length]>0) {
                return [NSString stringWithFormat:@" 已收盘,最后更新时间%@",lastTimeStr];
            }else{
                return [NSString stringWithFormat:@" 已收盘,请点击股票查看盘中走势"];
            }
        }
        
        
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"cn_lasttime"];
        
        return [NSString stringWithFormat:@" 交易中:%@-%@ %@:%@:%@,请及时刷新以下实时数据",_mon,_day,_h,_min,_s];
    }else{
        //13:00-15:00
        if (hour>=13 && hour<15) {
             [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"cn_lasttime"];
            
            return [NSString stringWithFormat:@" 交易中:%@-%@ %@:%@:%@,请及时刷新以下实时数据",_mon,_day,_h,_min,_s];
        }
        
        
        //default, 不再9:30-11:30 || 13:00-15:00
//        return [NSString stringWithFormat:@" 已收盘,请点击股票查看盘中走势"];
        if ([lastTimeStr length]>0) {
            return [NSString stringWithFormat:@" 已收盘,最后更新时间%@",lastTimeStr];
        }else{
            return [NSString stringWithFormat:@" 已收盘,请点击股票查看盘中走势"];
        }
    }
}

//港股交易时间：9:30~12:00，下午13:00~16:00
-(NSString *)getStockOnlineTipString_hk{
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    _now=[NSDate date];
    _comps = [_calendar components:unitFlags fromDate:_now];
    int mon = [_comps month];
    int day = [_comps day];
    int hour = [_comps hour];
    int min = [_comps minute];
    int second = [_comps second];
    int year = [_comps year];
    
    NSString *_s = [NSString  stringWithFormat:@"%d",second];
    if (second<10) {
        _s = [NSString  stringWithFormat:@"0%d",second];
    }
    NSString *_mon = [NSString  stringWithFormat:@"%d",mon];
    if (mon < 10) {
        _mon = [NSString  stringWithFormat:@"0%d",mon];
    }
    
    NSString *_day = [NSString  stringWithFormat:@"%d",day];
    if (day < 10) {
        _day = [NSString  stringWithFormat:@"0%d",day];
    }
    
    NSString *_min = [NSString  stringWithFormat:@"%d",min];
    if (min < 10) {
        _min = [NSString  stringWithFormat:@"0%d",min];
    }
    
    NSString *_h = [NSString  stringWithFormat:@"%d",hour];
    if (hour < 10) {
        _h = [NSString  stringWithFormat:@"0%d",hour];
    }
    
    //港股交易时间：9:30~12:00，下午13:00~16:00
    NSString *str = [NSString stringWithFormat:@"%d-%@-%@ %@:%@:%@",year,_mon,_day,_h,_min,_s];
    NSString *lastTimeStr =@"";// [[NSUserDefaults standardUserDefaults] objectForKey:@"hk_lasttime"];

    //9:30-11:30
    if (hour >8 && hour <12) {
        if (hour == 9 && min < 30) {
            if ([lastTimeStr length]>0) {
                return [NSString stringWithFormat:@" 已收盘,最后更新时间%@",lastTimeStr];
            }else{
                return [NSString stringWithFormat:@" 已收盘,请点击股票查看盘中走势"];
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"hk_lasttime"];
        return [NSString stringWithFormat:@" 交易中:%@-%@ %@:%@:%@,请及时刷新以下实时数据",_mon,_day,_h,_min,_s];
    }else{
        //13:00-15:00
        if (hour>=13 && hour<16) {
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"hk_lasttime"];
            return [NSString stringWithFormat:@" 交易中:%@-%@ %@:%@:%@,请及时刷新以下实时数据",_mon,_day,_h,_min,_s];
        }
        //default, 不再9:30-11:30 || 13:00-15:00
        if ([lastTimeStr length]>0) {
            return [NSString stringWithFormat:@" 已收盘,最后更新时间%@",lastTimeStr];
        }else{
            return [NSString stringWithFormat:@" 已收盘,请点击股票查看盘中走势"];
        }

    }

}

//美股开盘时间22:30-05:00 
-(NSString *)getStockOnlineTipString_us{
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    _now=[NSDate date];
    _comps = [_calendar components:unitFlags fromDate:_now];
    int mon = [_comps month];
    int day = [_comps day];
    int hour = [_comps hour];
    int min = [_comps minute];
    int second = [_comps second];
    
    NSString *_s = [NSString  stringWithFormat:@"%d",second];
    if (second<10) {
        _s = [NSString  stringWithFormat:@"0%d",second];
    }
    NSString *_mon = [NSString  stringWithFormat:@"%d",mon];
    if (mon < 10) {
        _mon = [NSString  stringWithFormat:@"0%d",mon];
    }
    
    NSString *_day = [NSString  stringWithFormat:@"%d",day];
    if (day < 10) {
        _day = [NSString  stringWithFormat:@"0%d",day];
    }
    
    NSString *_min = [NSString  stringWithFormat:@"%d",min];
    if (min < 10) {
        _min = [NSString  stringWithFormat:@"0%d",min];
    }
    
    NSString *_h = [NSString  stringWithFormat:@"%d",hour];
    if (hour < 10) {
        _h = [NSString  stringWithFormat:@"0%d",hour];
    }
    
    
//    美国股市大陆开盘时间
//    美国从每年4月到11月初采用夏令时，这段时间其交易时间为北京时间晚22：30－次日凌晨4：00 而在11月初到4月初，采用冬令时，则交易时间为北京时间晚22：30－次日凌晨5：00
    
    //9:30-11:30
    if (hour >=22 || hour <5) {
        if (hour == 22 && min < 30) {
            return [NSString stringWithFormat:@" 已收盘,请点击股票查看盘中走势"];
        }
        return [NSString stringWithFormat:@" 交易中:%@-%@ %@:%@:%@,请及时刷新以下实时数据",_mon,_day,_h,_min,_s];
    }else{

        return [NSString stringWithFormat:@" 已收盘,请点击股票查看盘中走势"];
    }
}

-(BOOL)isDateHoloday{
    return [[NSUserDefaults standardUserDefaults] boolForKey:is_current_date_holiday_key];
}

-(BOOL)isDateWeekly{
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    _now=[NSDate date];
    _comps = [_calendar components:unitFlags fromDate:_now];
    //Week: 在这一步耽误了不少时间!
    //    1 －－星期天
    //    2－－星期一
    //    3－－星期二
    //    4－－星期三
    //    5－－星期四
    //    6－－星期五
    //    7－－星期六
    int week = [_comps weekday];

    if (week == 1 || week ==7) {
        return YES;
    }
    return NO;
}

/**
 * 判断是否是我的自选股
 *
 */
-(BOOL)is_my_group{
    NSString *mytype =[[self.configItem dataDict] valueForKey:Stockitem_type];

    //我的自选股，特殊处理
    if ([mytype isEqualToString:@"mygroup"]) {
        return YES;
    }
    return NO;
}

#pragma mark push
-(void)update_push_tixing_num{
    //
    UILabel *l = (UILabel *)[self.view viewWithTag:100001];
    int push_cur_count_news=[[NSUserDefaults standardUserDefaults] integerForKey:PUSH_CUR_COUNT_TIXING];
    
    //    push_cur_count_news= 100;
    NSString *btnTitle = [NSString stringWithFormat:@"%d",push_cur_count_news];
    l.text = btnTitle;
    
    
    UIButton *backBtn = (UIButton *)[self.view viewWithTag:100000];
    
    
    [self reset_frame:backBtn andLabel:l];
    
    [self.view bringSubviewToFront:l];
    [self.view bringSubviewToFront:backBtn];
    
    NSLog(@"---- %@",btnTitle);

}

-(void)reset_frame:(UIButton *)backBtn andLabel:(UILabel* )num_label{
    int push_cur_count_news=[[NSUserDefaults standardUserDefaults] integerForKey:PUSH_CUR_COUNT_TIXING];

    float num_btn_x = 8;
    int num_btn_y = -5;

    //
    num_label.tag = 100001;
    
    int num_lable_x = 0;
    int num_lable_w = 20;
    int num_label_y = 8;
    //    测试数据
    //        push_cur_count_news = 200;
    if (push_cur_count_news<10) {
        num_lable_x= 49;
    }
    //    测试数据
    //    push_cur_count_news+=20;
    
    if (push_cur_count_news>=10 && push_cur_count_news<100) {
        num_lable_x= 45;
        num_btn_x = 7;
    }
    
    if (push_cur_count_news>=100) {
        num_lable_x= 40;
        num_lable_w = 30;
        num_label_y = 9;
        
        num_btn_x = 3;
    }
    
    num_label.frame = CGRectMake(num_lable_x, num_label_y, num_lable_w, 10);
    backBtn.frame = CGRectMake(num_btn_x,num_btn_y, 62, 51);//88*100
    
    
    if (push_cur_count_news == 0) {
        [backBtn setBackgroundImage:[UIImage imageNamed:@"push_news_1"] forState:UIControlStateNormal];
        num_label.hidden = YES;
    }else if (push_cur_count_news <100) {
        num_label.hidden  = NO;
        [backBtn setBackgroundImage:[UIImage imageNamed:@"push_news_2"] forState:UIControlStateNormal];
    }else{
        num_label.hidden  = NO;
        [backBtn setBackgroundImage:[UIImage imageNamed:@"push_news_3"] forState:UIControlStateNormal];
    }
    
}

@end
