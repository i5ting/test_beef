//
//  StockContentViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StockContentViewController.h"
#import "StockFuncPuller.h"
#import "CommentDataList.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "LKTipCenter.h"
#import "LoadingView.h"
#import "LoadingErrorView.h"
#import "TextNewsContentView.h"
#import "NormalImageViewController.h"
#import "MyTool.h"
#import "NewsObject.h"

@interface StockContentViewController ()
@property(nonatomic,retain)NSString* stockAID;
@property(nonatomic,retain)NSString* stockSymbol;
@property(nonatomic,assign)NSInteger stockType;
@property(nonatomic,retain)NSMutableArray* selectID;
@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)UIView* titleView;
@property(nonatomic,retain)LoadingView2 *loadingView;
@property(nonatomic,retain)LoadingErrorView *errorView;
@property(nonatomic,retain)TextNewsContentView *contentNormalView;
@property(nonatomic,retain)NewsObject *dataDict;

@end

@implementation StockContentViewController
{
    NSString* stockAID;
    NSString* stockSymbol;
    NSInteger stockType;
    NSMutableArray* selectID;
    CommentDataList* dataList;
    UIView* titleView;
    BOOL bInited;
    LoadingView2 *loadingView;
    LoadingErrorView *errorView;
    TextNewsContentView *contentNormalView;
    NewsObject *dataDict;
}

@synthesize stockAID,stockType,stockSymbol;
@synthesize selectID,dataList;
@synthesize titleView;
@synthesize loadingView,errorView;
@synthesize contentNormalView;
@synthesize dataDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithsymbol:(NSString*)symbol aid:(NSString*)aid  type:(NSInteger)type
{
    self = [super init];
    if (self) {
        self.stockSymbol = symbol;
        self.stockAID = aid;
        self.stockType = type;
        dataList = [[CommentDataList alloc] init];
        selectID = [[NSMutableArray alloc] initWithCapacity:0];
        [selectID addObject:symbol];
        [selectID addObject:aid];
        if (type==StockContent_CNReport) {
            [[StockFuncPuller getInstance] startOneCnStockReportContentWithSender:self rptid:aid args:selectID dataList:dataList userInfo:nil];
        }
        else if(type==StockContent_CNNotice){
            [[StockFuncPuller getInstance] startOneCnStockNoticeContentWithSender:self symbol:symbol noticeID:aid args:selectID dataList:dataList userInfo:nil];
        }
        else if(type==StockContent_HKNotice){
            [[StockFuncPuller getInstance] startOneHKStockNoticeContentWithSender:self noticeID:aid args:selectID dataList:dataList userInfo:nil];
        }
    }
    return self;
}

-(void)dealloc
{
    [stockAID release];
    [stockSymbol release];
    [selectID release];
    [dataList release];
    [titleView release];
    [loadingView release];
    [errorView release];
    [contentNormalView release];
    [dataDict release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self createToolbar];
    if (!bInited) {
        bInited = YES;
        [self initNotification];
    }
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
}

-(void)initUI
{
    int curY = 44;
    if (!loadingView) {
        CGRect loadRect = CGRectMake(0, curY, 320, 460-curY);
        loadingView = [[LoadingView2 alloc] initWithFrame:loadRect];
        [self.view addSubview:loadingView];
    }
    if (!errorView) {
        CGRect loadRect = CGRectMake(0, curY, 320, 460-curY);
        errorView = [[LoadingErrorView alloc] initWithFrame:loadRect];
        [self.view addSubview:errorView];
    }
    self.loadingView.hidden = NO;
    self.errorView.hidden = YES;
}

-(void)initNormalView
{
    int curY = 44;
    if (!contentNormalView) {
        contentNormalView = [[TextNewsContentView alloc] initWithFrame:CGRectMake(0, curY, 320, (UI_MAX_HEIGHT - 20)-curY)];
        contentNormalView.delegate = self;
        [self.view addSubview:contentNormalView];
    }
    else
    {
        [contentNormalView clear];
    }

    if (stockType==StockContent_CNReport) 
    {
        contentNormalView.titleString = [self.dataDict valueForKey:StockFunc_CNReportContent_title];
        NSString* contentString = [self.dataDict valueForKey:StockFunc_CNReportContent_content];
        contentNormalView.contentString = contentString;
        contentNormalView.media = nil;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString* createDateStr = [self.dataDict valueForKey:StockFunc_CNReportContent_adddate];
        NSDate* newDate = [formatter dateFromString:createDateStr];
        contentNormalView.createDate = newDate;
        NSString* orgname = [self.dataDict valueForKey:StockFunc_CNReportContent_orgname];
        orgname = [NSString stringWithFormat:@"机构:%@",orgname];
        contentNormalView.info1String = orgname;
        NSString* author = [self.dataDict valueForKey:StockFunc_CNReportContent_author];
        author = [NSString stringWithFormat:@"研究员:%@",author];
        contentNormalView.info2String = author;
        [formatter release];
    }
    else if(stockType==StockContent_CNNotice)
    {
        contentNormalView.titleString = [self.dataDict valueForKey:StockFunc_CNNoticeContent_Title];
        contentNormalView.contentString = [self.dataDict valueForKey:StockFunc_CNNoticeContent_Content];
        contentNormalView.media = nil;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString* createDateStr = [self.dataDict valueForKey:StockFunc_CNNoticeContent_end_date];
        NSDate* newDate = [formatter dateFromString:createDateStr];
        contentNormalView.createDate = newDate;
        [formatter release];
    }
    else if(stockType==StockContent_HKNotice)
    {
        contentNormalView.titleString = [self.dataDict valueForKey:StockFunc_HKNoticeContent_title];
        contentNormalView.contentString = [self.dataDict valueForKey:StockFunc_HKNoticeContent_content];
        contentNormalView.media = nil;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString* createDateStr = [self.dataDict valueForKey:StockFunc_HKNoticeContent_entrydate];
        NSDate* newDate = [formatter dateFromString:createDateStr];
        contentNormalView.createDate = newDate;
        [formatter release];
    }

    [contentNormalView reloadData];
}

- (void)handleBackPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)view:(TextNewsContentView*)aView imageClicked:(NSString*)imageURL
{
    NormalImageViewController* controller = [[NormalImageViewController alloc] init];
    NSArray* array = [[NSArray alloc] initWithObjects:imageURL, nil];
    controller.imageObjectList = array;
    [array release];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark -
#pragma mark networkCallback
-(void)StockObjectAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_OneCnStockReportContent||[stageNumber intValue]==Stage_Request_OneCnStockNoticeContent||[stageNumber intValue]==Stage_Request_OneHkStockNoticeContent) {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSArray* array = [userInfo valueForKey:RequsetArray];
            self.dataDict = [userInfo valueForKey:RequsetExtra];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                self.loadingView.hidden = YES;
                self.errorView.hidden = YES;
                if ([array count]>0) {
                    self.dataDict = [array objectAtIndex:0];
                }
                else {
                    self.dataDict = nil;
                }
                
                [self initNormalView];
            }
        }
    }
}

-(void)StockObjectFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if([stageNumber intValue]==Stage_Request_OneCnStockReportContent|[stageNumber intValue]==Stage_Request_OneCnStockNoticeContent||[stageNumber intValue]==Stage_Request_OneHkStockNoticeContent)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID])
            {
                self.loadingView.hidden = YES;
                self.errorView.hidden = NO;
            }
        }
    }
}

@end
