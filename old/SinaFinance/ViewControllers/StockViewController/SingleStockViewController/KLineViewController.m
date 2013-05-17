//
//  KLineViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KLineViewController.h"
#import "MyTool.h"
#import "StockFuncPuller.h"
#import "StockViewDefines.h"
#import "DataButton.h"
#import "ShareData.h"
#import "WDKlineView.h"
#import "CommentDataList.h"
#import "gDefines.h"
#import "StockInfoView.h"
#import "SingleStockViewController.h"
#import "DropDownTabBar.h"
#import "LoadingErrorView.h"
#import "LoadingView.h"
#import "ProjectLogUploader.h"
#import "Util.h"
#import "AppDelegate.h"

@interface KLineViewController ()
@property(nonatomic,retain)UIView* backView;
@property(nonatomic,retain)UIView* btnView;
@property(nonatomic,retain)UIView* titleView;
@property(nonatomic,retain)NSString* curUrlString;
@property(nonatomic,retain)NSString* curChartSvg;
@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)NSArray* selectID;
@property(nonatomic,assign)BOOL hasShadow;
@property(nonatomic,retain)WDKlineView* klineView;
@property(nonatomic,retain)NSDictionary* netValueSymbolDict;
@property(nonatomic,retain)StockInfoView* titleItemView;
@property(nonatomic,retain)NSMutableArray* buttons;
@property(nonatomic,retain)LoadingErrorView* curErrorView;
@property(nonatomic,retain)LoadingView* curLoadingView;
@property(nonatomic,retain)NSDate* lastDate;
@property(nonatomic,retain)UITextView* debugLogView;
@property(nonatomic,retain)UILabel* touchTipLabel;
@property(nonatomic,retain)UIButton* backBtn;
@property(nonatomic,retain)NSString* curTitleItemKey;
@property(nonatomic,retain)NSString* curTitleItemWidthKey;

-(void)initData;
-(void)initUI;
-(void)initTopBarStatus;
-(void)initNotification;
-(void)modeClicked:(DataButton*)sender;
-(void)refreshChartWithIndex:(NSNumber*)index;
-(void)addStockBigChartViewData;
-(BOOL)checkRefreshByDate;
@end

@implementation KLineViewController
{
    CommentDataList* dataList;
    NSArray* selectID;
    UIView* backView;
    UIView* btnView;
    NSString* curUrlString;
    NSString* curChartSvg;
    BOOL bInited;
    BOOL hasShadow;
    WDKlineView* klineView;
    UIView* titleView;
    NSDictionary* netValueSymbolDict;
    StockInfoView* titleItemView;
    NSMutableArray* buttons;
    NSInteger curIndex;
    LoadingErrorView* curErrorView;
    LoadingView* curLoadingView;
    BOOL curExited;
    NSDate* lastDate;
    NSTimeInterval pastedTimeInterval;
    BOOL curViewShowed;
    UITextView* debugLogView;
    UILabel* touchTipLabel;
    UIButton* backBtn;
    NSString* curTitleItemKey;
    NSString* curTitleItemWidthKey;
}
@synthesize backView;
@synthesize btnView;
@synthesize titleView;
@synthesize subConfigDict,stockType,stockSymbol,stockName,subType;
@synthesize curUrlString,curChartSvg;
@synthesize dataList,selectID;
@synthesize hasShadow;
@synthesize klineView;
@synthesize netValueSymbolDict;
@synthesize titleItemView;
@synthesize singleStockData;
@synthesize buttons;
@synthesize curErrorView;
@synthesize curLoadingView;
@synthesize lastDate;
@synthesize curStatus;
@synthesize debugLogView;
@synthesize touchTipLabel;
@synthesize backBtn;
@synthesize delegate;
@synthesize curTitleItemKey;
@synthesize curTitleItemWidthKey;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataList = [[CommentDataList alloc] init];
        
    }
    return self;
}

-(void)dealloc
{
    [backView release];
    [btnView release];
    [subConfigDict release];
    [stockType release];
    [stockSymbol release];
    [stockName release];
    [subType release];
    [curStatus release];
    [curUrlString release];
    [curChartSvg release];
    [dataList release];
    [selectID release];
    klineView.aniview.delegate = nil;
    [klineView release];
    [netValueSymbolDict release];
    [titleView release];
    [titleItemView release];
    [singleStockData release];
    [buttons release];
    [curErrorView release];
    [curLoadingView release];
    [lastDate release];
    [debugLogView release];
    [touchTipLabel release];
    [backBtn release];
    [curTitleItemKey release];
    [curTitleItemWidthKey release];
    
    [super dealloc];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    if (!bInited) {
        bInited = YES;
        [self initNotification];
    }
    [self initUI];
    [self initData];
//    [self initTopBarStatus];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (BOOL)shouldAutorotate{
    return YES;
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

#define top_bar_status_fony_size 14
-(void)initTopBarStatus{
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 80, 30)];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 80, 30)];
    UILabel *diffLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 80, 30)];
    UILabel *chgLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 0, 80, 30)];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(360, 0, 180, 30)];
    nameLabel.tag = 10001;
    priceLabel.tag = 10002;
    diffLabel.tag = 10003;
    chgLabel.tag = 10004;
    dateLabel.tag = 10005;
    
    nameLabel.font = [UIFont systemFontOfSize:top_bar_status_fony_size];
    priceLabel.font = [UIFont systemFontOfSize:top_bar_status_fony_size];
    diffLabel.font = [UIFont systemFontOfSize:top_bar_status_fony_size];
    chgLabel.font = [UIFont systemFontOfSize:top_bar_status_fony_size];
    dateLabel.font = [UIFont systemFontOfSize:top_bar_status_fony_size];
    
    
    nameLabel.backgroundColor = [UIColor clearColor];
    priceLabel.backgroundColor = [UIColor clearColor];
    diffLabel.backgroundColor = [UIColor clearColor];
    chgLabel.backgroundColor = [UIColor clearColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    
    nameLabel.textColor = [UIColor whiteColor];
    priceLabel.textColor = [UIColor redColor];
    diffLabel.textColor = [UIColor redColor];
    chgLabel.textColor = [UIColor redColor];
    dateLabel.textColor = [UIColor redColor];
    
    
    nameLabel.text = [[singleStockData dataDict] valueForKey:@"cn_name"];
    priceLabel.text =[[singleStockData dataDict] valueForKey:@"price"];
    diffLabel.text =[[singleStockData dataDict] valueForKey:@"diff"];
    chgLabel.text = [[singleStockData dataDict] valueForKey:@"chg"];
    
    
//G: 公元时代，例如AD公元
//yy: 年的后2位
//yyyy: 完整年
//MM: 月，显示为1-12
//MMM: 月，显示为英文月份简写,如 Jan
//MMMM: 月，显示为英文月份全称，如 Janualy
//dd: 日，2位数表示，如02
//d: 日，1-2位显示，如 2
//EEE: 简写星期几，如Sun
//EEEE: 全写星期几，如Sunday
//aa: 上下午，AM/PM
//H: 时，24小时制，0-23
//    K：时，12小时制，0-11
//m: 分，1-2位
//mm: 分，2位
//s: 秒，1-2位
//ss: 秒，2位
//S: 毫秒
    
//    MMM dd  K:m  aa G
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM dd K:m aa"];
	NSDate *date = [NSDate date];
	NSString *description = [dateFormatter stringFromDate:date];
	[dateFormatter release];
    
    
    
    dateLabel.text = description;//[[singleStockData dataDict] valueForKey:@"hq_day"];
    
    [self.view addSubview:nameLabel];
    [self.view addSubview:priceLabel];
    [self.view addSubview:diffLabel];
    [self.view addSubview:chgLabel];
    [self.view addSubview:dateLabel];
}


-(void)initUI{
    
    CGRect bounds = self.view.bounds;
    CGRect backRect = bounds;
    NSInteger curY = 0;
    NSInteger titleHeight = 30;
    CGRect titleRect = CGRectMake(0, curY, bounds.size.width - bounds.origin.x*2, titleHeight);
    if (!self.titleView) {
        titleView = [[UIView alloc] initWithFrame:titleRect];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIImage* backImage = [UIImage imageNamed:@"kline_bg_nav_header.png"];
        UIImageView* backImageView = [[UIImageView alloc] initWithImage:backImage];
        backImageView.frame = titleView.bounds;
        backImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.titleView addSubview:backImageView];
        [backImageView release];
    }
    else {
        titleView.frame = titleRect;
    }
    [self.view addSubview:titleView];
    curY += titleHeight;
    int CurTitleBottom = curY;
    
    curY += 20;
    
    //兼容ios6，如果是ios6则剧中显示
    backRect.origin.x = (bounds.size.height - 480)/2;
    
    backRect.origin.y = curY;
    backRect.size.width = backRect.size.width - backRect.origin.x*2;
    backRect.size.height = backRect.size.height - backRect.origin.y - 30;
    if (!self.backView) {
        backView = [[UIView alloc] initWithFrame:backRect];
        backView.backgroundColor = [UIColor clearColor];
        backView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        LoadingErrorView* errorView = [[LoadingErrorView alloc] initWithFrame:backView.bounds];
        errorView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [backView addSubview:errorView];
        self.curErrorView = errorView;
        errorView.hidden = YES;
        [errorView release];
        
        LoadingView* loadingView = [[LoadingView alloc] initWithFrame:backView.bounds];
        loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [backView addSubview:loadingView];
        self.curLoadingView = loadingView;
        loadingView.hidden = YES;
        [loadingView release];
        
    }
    else {
        backView.frame = backRect;
    }
    [self.view addSubview:backView];
    
    CGRect touchTipRect = CGRectMake(10,CurTitleBottom+5, bounds.size.width - bounds.origin.x*2-20, 20);
    if (!touchTipLabel) {
        touchTipLabel = [[UILabel alloc] initWithFrame:touchTipRect];
        touchTipLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        touchTipLabel.backgroundColor = [UIColor clearColor];
        touchTipLabel.textColor = [UIColor whiteColor];
        touchTipLabel.font = [UIFont systemFontOfSize:13.0];
        touchTipLabel.adjustsFontSizeToFitWidth = YES;
    }
    else {
        touchTipLabel.frame = touchTipRect;
    }
    [self.view addSubview:touchTipLabel];
    
#ifdef DEBUG_test
    CGRect logRect = CGRectMake(5, self.view.bounds.size.height-30-25, bounds.size.width - bounds.origin.x*2-10, 30);
    if (!debugLogView) {
        debugLogView = [[UITextView alloc] initWithFrame:logRect];
        debugLogView.backgroundColor = [UIColor clearColor];
        debugLogView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        debugLogView.editable = NO;
        debugLogView.textColor = [UIColor whiteColor];
        debugLogView.font = [UIFont systemFontOfSize:15.0];
    }
    else
    {
        debugLogView.frame = logRect;
    }
    [self.view addSubview:debugLogView];
#endif
    
    CGRect btnRect = self.view.bounds;
    if ([MyTool deviceOrientation]==UIDeviceOrientationPortrait) {
        btnRect.size = CGSizeMake(self.view.bounds.size.width, 30);
        btnRect.origin.y = self.view.bounds.size.height - btnRect.size.height;
    }
    else {
        btnRect.size = CGSizeMake(self.view.bounds.size.width,20);
        btnRect.origin.y = self.view.bounds.size.height - btnRect.size.height - 10;
    }
    
    if (!btnView) {
        btnView = [[UIView alloc] initWithFrame:btnRect];
        btnView.backgroundColor = [UIColor clearColor];
        btnView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        
        NSArray* bigchart = [subConfigDict valueForKey:Stockitem_singleStock_chart_bigchart];
        int btnCount = [bigchart count];
        int btnWidth = 50;
        int btnMargin = 5;
        int totalBtnWidth = btnWidth*btnCount;
        if (btnCount>1) {
            totalBtnWidth += btnMargin*(btnCount - 1);
        }
        BOOL useSizeFit = NO;
        if (totalBtnWidth>480) {
            useSizeFit = YES;
        }
        
        NSMutableArray* btnArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0;i<[bigchart count];i++) {
            NSDictionary* bigChartDict = [bigchart objectAtIndex:i];
            NSString* name = [bigChartDict valueForKey:Stockitem_singleStock_chart_name];
            NSString* urlString = [bigChartDict valueForKey:Stockitem_singleStock_chart_url];
            DataButton* tempBtn = [[DataButton alloc] init];
            UIImage* highlyImage = [UIImage imageNamed:@"kline_bg_button_blue.png"];
            UIImage* normalImage = [UIImage imageNamed:@"kline_bg_button_gray.png"];
            [tempBtn setBackgroundImage:normalImage forState:UIControlStateNormal];
            [tempBtn setBackgroundImage:highlyImage forState:UIControlStateHighlighted];
            [tempBtn setBackgroundImage:highlyImage forState:UIControlStateSelected];
            tempBtn.data = urlString;
            [tempBtn addTarget:self action:@selector(modeClicked:) forControlEvents:UIControlEventTouchUpInside];
            [tempBtn setTitle:name forState:UIControlStateNormal];
            tempBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
            tempBtn.tag = 11000 + i;
            if (useSizeFit) {
                CGSize nameSize = [name sizeWithFont:[UIFont fontWithName:APP_FONT_NAME size:14]];
                tempBtn.frame = CGRectMake(0, 0, nameSize.width+10, 10);
            }
            else {
                CGSize nameSize = [name sizeWithFont:[UIFont fontWithName:APP_FONT_NAME size:14]];
                if (nameSize.width+10>btnWidth) {
                    tempBtn.frame = CGRectMake(0, 0, nameSize.width+10, 10);
                }
                else {
                    tempBtn.frame = CGRectMake(0, 0, btnWidth, 10);
                }
            }
            [btnView addSubview:tempBtn];
            [btnArray addObject:tempBtn];
            [tempBtn release];
        }
        totalBtnWidth = 0;
        btnWidth = 0;
        for (int i=0;i<[btnArray count];i++) {
            DataButton* oneBtn = [btnArray objectAtIndex:i];
            CGRect oneBtnRect = oneBtn.frame;
            btnWidth = oneBtnRect.size.width;
            totalBtnWidth += btnWidth;
            if (i!=0) {
                totalBtnWidth += btnMargin;
            }
        }
        
        int SourceX = btnView.bounds.origin.x + 480/2 - totalBtnWidth/2;
        for (int i=0;i<[btnArray count];i++) {
            DataButton* oneBtn = [btnArray objectAtIndex:i];
            CGRect oneBtnRect = oneBtn.frame;
            btnWidth = oneBtnRect.size.width;
            oneBtnRect.origin.x = SourceX;
            oneBtnRect.origin.y = 0;
            oneBtnRect.size.height = btnView.frame.size.height;
            oneBtn.frame = oneBtnRect;
            SourceX += btnWidth + btnMargin;
        }
        self.buttons = btnArray;
        [btnArray release];
    }
    else {
        btnView.frame = btnRect;
    }
    [self.view addSubview:btnView];
    [self startRefreshDataTimer];
    [self formatTitleItem];
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

-(void)handleBackPressed
{
    [self exit];
    if ([delegate respondsToSelector:@selector(controllerBackClicked:)]) {
        [delegate controllerBackClicked:self];
    }
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app performSelector:@selector(adjustTabBarFrame) withObject:nil afterDelay:0.1];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController popViewControllerAnimated:NO];
    //横屏的时候，强制转到竖屏
    UINavigationController* nav = self.navigationController;
    UIViewController *controller = [[UIViewController alloc] init];
    UINavigationController *parentController = [[UINavigationController alloc] initWithRootViewController:controller];
    [nav presentModalViewController:parentController animated:NO];
    [controller dismissModalViewControllerAnimated:NO];
    [parentController release];
    [controller release];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
}

-(void)formatTitleItem
{
    NSString* titleItemKey = self.curTitleItemKey;
    NSString* titleItemWidthKey = self.curTitleItemWidthKey;
    CGRect bounds = self.titleView.bounds;
    
    CGRect backRect = CGRectMake(5, bounds.size.height/2 - 24/2, 50, 24);
    if (!backBtn) {
        backBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        backBtn.frame = backRect;
        [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"kline_tabbar_backbtn.png"] forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
        [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        backBtn.frame = backRect;
    }
    [self.titleView addSubview:backBtn];
    
    NSDictionary* curConfigDict = self.subConfigDict;
    NSArray* columnArray = [curConfigDict valueForKey:Stockitem_singleStock_bigchart_titleitem];
    if (columnArray&&[columnArray count]>0) {
        NSString* bRedSize = [curConfigDict valueForKey:Stockitem_singleStock_redrise];
        NSInteger colorType = 0;
        if ([bRedSize intValue]>0) {
            colorType = kSHZhangDie;
        }
        CGRect titleRect = bounds;
        titleRect.origin.x = 55;
        titleRect.origin.y = 5;
        titleRect.size.height = titleRect.size.height - titleRect.origin.y;
        if (!titleItemView) {
            titleItemView = [[StockInfoView alloc] initWithFrame:titleRect];
            titleItemView.backgroundColor = [UIColor clearColor];
            titleItemView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            titleItemView.viewType = ViewType_titleItem0;
            titleItemView.leftMargin = 5;
            titleItemView.titleFont = [UIFont systemFontOfSize:12.0];
        }
        else {
            titleItemView.frame = titleRect;
        }
        [self.titleView addSubview:titleItemView];
        
        NSMutableArray* infoViewDataArray = [[NSMutableArray alloc] initWithCapacity:0];
        StockInfoCellData* cellData = [[[StockInfoCellData alloc] init] autorelease];
        
        NSArray* columnArray = [curConfigDict valueForKey:Stockitem_singleStock_bigchart_titleitem];
        if (titleItemKey) {
            columnArray = [curConfigDict valueForKey:titleItemKey];
        }
        
        NSArray* widths = [curConfigDict valueForKey:Stockitem_singleStock_bigchart_titleitemwidths];
        if (titleItemWidthKey) {
            widths = [curConfigDict valueForKey:titleItemWidthKey];
        }
        self.titleItemView.widthArray = widths;
        NSMutableArray* allColumns = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* decideColorArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* decideNullArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray* dateArray = [[NSMutableArray alloc] initWithCapacity:0];
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
                NSString* dateString = [oneColumn valueForKey:Stockitem_singleStock_column_datestring];
                if (dateString&&[dateString intValue]>0) {
                    [dateArray addObject:[NSNumber numberWithBool:YES]];
                }
                else {
                    [dateArray addObject:[NSNumber numberWithBool:NO]];
                }
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
        if ([dateArray count]>0) {
            NSMutableArray* fontSizeArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i=0;i<[dateArray count];i++) {
                NSNumber* dateNumber = [dateArray objectAtIndex:i];
                if ([dateNumber boolValue]) {
                    [fontSizeArray addObject:[NSNumber numberWithFloat:10.0]];
                }
                else {
                    [fontSizeArray addObject:[NSNumber numberWithFloat:13.0]];
                }
            }
            self.titleItemView.fontSizeArray = fontSizeArray;
            [fontSizeArray release];
        }
        [decideNullArray release];
        [decideColorArray release];
        [dateArray release];
        [allColumns release];
        self.titleItemView.dataArray = infoViewDataArray;
        [infoViewDataArray release];
        [self.titleItemView reloadData];
    }
    [self dealStockStatusShow];
}

-(void)dealStockStatusShow
{
    NSString* status = self.curStatus;
    if (status&&[status intValue]!=1) {
        if (![[self.stockType lowercaseString] isEqualToString:@"fund"]) {
            NSArray* infoViewDataArray = self.titleItemView.dataArray;
            NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:0];
            if ([infoViewDataArray count]>0) {
                StockInfoCellData* cellData = [infoViewDataArray objectAtIndex:0];
                NSArray* columnDataArray = cellData.columnData;
                for (int j=0; j<[columnDataArray count]; j++) {
                    StockInfoOneColumnData* oneColumnData = [columnDataArray objectAtIndex:j];
                    if (j==1) {
                        if ([status intValue]==0) {
                            oneColumnData.name = @"未上市";
                        }
                        else if ([status intValue]==2) {
                            oneColumnData.name = @"停牌";
                        }
                        else if ([status intValue]==3) {
                            oneColumnData.name = @"退市";
                        }
                        oneColumnData.preName = @"";
                        oneColumnData.justName = YES;
                        oneColumnData.fontColor = [UIColor whiteColor];
                    }
                    else {
                        if (!oneColumnData.justName) {
                            oneColumnData.name = @"";
                            oneColumnData.preName = @"";
                            oneColumnData.justName = YES;
                            oneColumnData.fontColor = [UIColor whiteColor];
                        }
                    }
                }
                [newArray addObject:cellData];
            }
            self.titleItemView.dataArray = newArray;
            [newArray release];
            [self.titleItemView reloadData];
        }
    }
}

-(void)initData
{
    [self modeClickedWithIndex:curIndex];
}

-(void)modeClickedWithIndex:(NSInteger)index
{
    for (DataButton* oneBtn in buttons) {
        if (oneBtn.tag==index+11000) {
            oneBtn.selected = YES;
        }
        else {
            oneBtn.selected = NO;
        }
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshChartWithIndex:) object:nil];
    [self performSelector:@selector(refreshChartWithIndex:) withObject:[NSNumber numberWithInt:index] afterDelay:0.005 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    
}
             
-(void)modeClicked:(DataButton*)sender
{
    sender.selected = YES;
    for (DataButton* oneBtn in buttons) {
        if (oneBtn!=sender) {
            oneBtn.selected = NO;
        }
    }
    
    NSInteger tag = sender.tag;
    NSInteger index = tag - 11000;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshChartByBtnWithIndex:) object:nil];
    [self performSelector:@selector(refreshChartByBtnWithIndex:) withObject:[NSNumber numberWithInt:index] afterDelay:0.005 inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

-(BOOL)checkRefreshByDate
{
    BOOL rtval = NO;
    NSDate* oldDate = [dataList dateInfoWithIDList:self.selectID];
    if (oldDate) {
        NSTimeInterval length = [oldDate timeIntervalSinceDate:[NSDate date]];
        length = abs(length);
        NSTimeInterval refreshInterval = [[ShareData sharedManager] refreshInterval];
        if (length>=(int)refreshInterval) {
            rtval = YES;
        }
    }
    else
        rtval = YES;
    return rtval;
}

-(void)refreshChartByBtnWithIndex:(NSNumber*)indexNumber
{
    [self refreshChartWithIndex:indexNumber byBtn:YES];
}

-(void)refreshChartWithIndex:(NSNumber*)indexNumber
{
    [self refreshChartWithIndex:indexNumber byBtn:NO];
}

-(void)refreshChartWithIndex:(NSNumber*)indexNumber byBtn:(BOOL)byBtn
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSInteger index = [indexNumber intValue];
    self.curErrorView.hidden = YES;
    self.klineView.hidden = NO;
    self.curLoadingView.hidden = YES;
    NSInteger oldIndex = curIndex;
    BOOL justRefresh = NO;
    if (index==oldIndex) {
        justRefresh = YES;
    }
    curIndex = index;
    NSArray* bigchart = [subConfigDict valueForKey:Stockitem_singleStock_chart_bigchart];
    if (index<[bigchart count]) {
        NSDictionary* bigChartDict = [bigchart objectAtIndex:index];
        NSString* decide_titleitem = [bigChartDict valueForKey:Stockitem_singleStock_chart_decide_titleitem];
        NSString* decide_titleitemWidth = [bigChartDict valueForKey:Stockitem_singleStock_chart_decide_titleitemwidth];
        self.curTitleItemKey = decide_titleitem;
        self.curTitleItemWidthKey = decide_titleitemWidth;
        [self formatTitleItem];
        NSString* name = [bigChartDict valueForKey:Stockitem_singleStock_chart_name];
        if (byBtn&&name) {
            [self addProjectLogWithName:name stockType:self.stockType];
        }
        NSString* urlString = [bigChartDict valueForKey:Stockitem_singleStock_chart_url];
        NSString* hasShadowString = [bigChartDict valueForKey:Stockitem_singleStock_chart_shadow];
        if (hasShadowString&&[hasShadowString intValue]>0) {
            hasShadow = YES;
        }
        else {
            hasShadow = NO;
        }
        urlString = [urlString stringByReplacingOccurrencesOfString:@"${symbol}" withString:self.stockSymbol];
        if (![self.stockSymbol isEqualToString:@"HSI"]) {
            urlString = [urlString lowercaseString];
        }
        self.selectID = [NSArray arrayWithObject:urlString];
        [self.dataList reloadShowedDataWithIDList:self.selectID];
        NewsObject* oneObject = [self.dataList lastObjectWithIDList:self.selectID];
        if (!justRefresh) {
            self.curChartSvg = [oneObject valueForKey:StockFunc_SingleStockInfo_localsvg];
            if (self.curChartSvg) {
                [self.klineView clear];
                self.klineView.hidden = NO;
                self.curLoadingView.hidden = YES;
                [self addStockBigChartViewData];
            }
            else {
                [self.klineView clear];
                self.klineView.hidden = YES;
                self.curLoadingView.hidden = NO;
            }
        }
        else 
        {
            if(!self.curChartSvg)
            {
                [self.klineView clear];
                self.klineView.hidden = YES;
                self.curLoadingView.hidden = NO;
            }
            else {
                self.klineView.hidden = NO;
                self.curLoadingView.hidden = YES;
            }
        }
        //urlString = [urlString lowercaseString];
        self.curUrlString = urlString;
        BOOL needRefresh = [self checkRefreshByDate];
        if (justRefresh) {
            needRefresh = YES;
        }
        if (needRefresh) {
            if ([urlString rangeOfString:@"${style}"].location==NSNotFound) {
#ifdef DEBUG
                NSLog(@"test stockChart url=%@",urlString);
                self.debugLogView.text = urlString;
#endif
                [[StockFuncPuller getInstance] startStockChartWithSender:self url:urlString args:self.selectID dataList:self.dataList userInfo:self.curUrlString];
            }
            else {
                if (!netValueSymbolDict) {
                    [[StockFuncPuller getInstance] startOneFundNetValueWithSender:self symbol:self.stockSymbol args:self.selectID dataList:nil userInfo:nil];
                }
                else {
                    NSString* urlString = self.curUrlString;
                    NSString* exchange = [netValueSymbolDict valueForKey:StockFunc_Chart_exchange];
                    if (exchange) {
                        urlString = [urlString stringByReplacingOccurrencesOfString:@"${style}" withString:exchange];
                    }
#ifdef DEBUG
                    NSLog(@"test stockChart url=%@",urlString);
                    self.debugLogView.text = urlString;
#endif
                    [[StockFuncPuller getInstance] startStockChartWithSender:self url:urlString args:self.selectID dataList:self.dataList userInfo:self.curUrlString];
                }
            }
        }
    }
    else {
        self.curErrorView.hidden = YES;
        self.klineView.hidden = YES;
        self.curLoadingView.hidden = YES;
    }
    [pool release];
}

-(void)initChartView
{
    
    [self.klineView removeFromSuperview];
    self.klineView.aniview.delegate = nil;
    self.klineView = nil;
    WDKlineView *klview = [[WDKlineView alloc] init];
    klview.tag = 33333;
    klview.aniview.delegate = self;
    klview.aniview.dataLabelFont = [UIFont systemFontOfSize:11.0];
    [self.backView addSubview:klview];
    self.klineView = klview;
    [klview release];
}

-(void)addStockBigChartViewData
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [self initChartView];
    if (self.curChartSvg) {
        self.klineView.hidden = NO;
        self.curLoadingView.hidden = YES;
        self.curErrorView.hidden = YES;
        [self.klineView loadSVG:self.curChartSvg drawShadow:hasShadow];
    }
    else {
        self.klineView.hidden = YES;
        self.curErrorView.hidden = NO;
        self.curLoadingView.hidden = YES;
    }
    [pool release];
}

//-(void)addStockBigChartViewData
//{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    [self initChartView];
//    BOOL stockstatus_stop = NO;//[[self.singleStockData valueForKey:StockFunc_SingleStockInfo_status] isEqualToString:[NSString stringWithFormat:@"%@",@"2"]]?YES:NO;
//    if (curIndex ==0) {
//        if (!stockstatus_stop) {
//            if (self.curChartSvg) {
//                self.klineView.hidden = NO;
//                self.curLoadingView.hidden = YES;
//                self.curErrorView.hidden = YES;
//                [self.klineView loadSVG:self.curChartSvg drawShadow:hasShadow];
//            }
//            else {
//                self.klineView.hidden = YES;
//                self.curErrorView.hidden = NO;
//                self.curLoadingView.hidden = YES;
//            }
//        }else{
//            self.curLoadingView.hidden = YES;
//            [self changeErrorTipByStatus];
//        }
//    }else{
//        if (self.curChartSvg) {
//            self.klineView.hidden = NO;
//            self.curLoadingView.hidden = YES;
//            self.curErrorView.hidden = YES;
//            [self.klineView loadSVG:self.curChartSvg drawShadow:hasShadow];
//        }
//        else {
//            self.klineView.hidden = YES;
//            self.curErrorView.hidden = NO;
//            self.curLoadingView.hidden = YES;
//        }
//
//    }
//   
//    [pool release];
//}

- (void)klineAnimationTouchedWithDateString:(NSString*)dateString KeyData:(NSArray*)keyData valueData:(NSArray*)valueData
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
    self.touchTipLabel.text = rtval;
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

-(void)addProjectLogWithName:(NSString*)name stockType:(NSString*)aStockType
{
    if ([[aStockType lowercaseString] isEqualToString:@"cn"]) {
        if ([name isEqualToString:@"分时"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"time_sharing_chart_A"];
        }
        else if ([name isEqualToString:@"30分钟"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"30minutes_chart_A"];
        }
        else if ([name isEqualToString:@"日K线"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"dayK_A"];
        }
        else if ([name isEqualToString:@"周K线"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"weekK_A"];
        }
        else if ([name isEqualToString:@"月K线"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"monthK_A"];
        }
        else if ([name isEqualToString:@"历史K"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"historyK_A"];
        }
    }
    else if ([[aStockType lowercaseString] isEqualToString:@"hk"])
    {
        if ([name isEqualToString:@"分时"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"time_sharing_chart_HK"];
        }
        else if ([name isEqualToString:@"日K线"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"dayK_HK"];
        }
        else if ([name isEqualToString:@"周K线"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"weekK_HK"];
        }
        else if ([name isEqualToString:@"月K线"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"monthK_HK"];
        }
    }
    else if ([[aStockType lowercaseString] isEqualToString:@"us"])
    {
        if ([name isEqualToString:@"分时"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"time_sharing_chart_US"];
        }
        else if ([name isEqualToString:@"日K线"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"dayK_US"];
        }
        else if ([name isEqualToString:@"周K线"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"weekK_US"];
        }
        else if ([name isEqualToString:@"月K线"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"monthK_US"];
        }
        else if ([name isEqualToString:@"1月"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"1month_US"];
        }
        else if ([name isEqualToString:@"6月"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"6month_US"];
        }
        else if ([name isEqualToString:@"1年"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"1year_US"];
        }
        else if ([name isEqualToString:@"5年"]) {
            [[ProjectLogUploader getInstance] writeDataString:@"5year_US"];
        }
    }
}

-(void)reloadData
{
    [self formatTitleItem];
}

#pragma mark -
#pragma mark networkCallback
-(void)StockObjectAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_StockChart) {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                [self.dataList reloadShowedDataWithIDList:self.selectID];
                NewsObject* oneObject = [self.dataList lastObjectWithIDList:self.selectID];
                self.curChartSvg = [oneObject valueForKey:StockFunc_SingleStockInfo_localsvg];
                [self addStockBigChartViewData];
            }
        }
        else if([stageNumber intValue]==Stage_Request_OneFundNetValue)
        {
            NSDictionary* retDict = [userInfo valueForKey:RequsetExtra];
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                self.netValueSymbolDict = retDict;
                NSString* ssStatus = [netValueSymbolDict valueForKey:StockFunc_Chart_ssStatus];
                if ([ssStatus isEqualToString:@"WSS"]) {
                    self.curErrorView.customTipString = @"此基金还在申购期";
                }
                NSString* urlString = self.curUrlString;
                NSString* exchange = [retDict valueForKey:StockFunc_Chart_exchange];
                if (exchange) {
                    urlString = [urlString stringByReplacingOccurrencesOfString:@"${style}" withString:exchange];
                }
                
#ifdef DEBUG
                NSLog(@"test stockChart url=%@",urlString);
                self.debugLogView.text = urlString;
#endif
                [[StockFuncPuller getInstance] startStockChartWithSender:self url:urlString args:self.selectID dataList:self.dataList userInfo:self.curUrlString];
            }
        }
        else if ([stageNumber intValue]==Stage_Request_OneStockInfo) 
        {
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSArray* array = [userInfo valueForKey:RequsetArray];
            NewsObject* oneObject = [array lastObject];
            self.singleStockData = oneObject;
            self.curStatus = [self.singleStockData valueForKey:StockFunc_SingleStockInfo_status];
            [self reloadUI];
        }
    }
}

-(void)StockObjectFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_StockChart) {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                if (!self.curChartSvg) {
                    [self changeErrorTipByStatus];
                    self.klineView.hidden = YES;
                    self.curErrorView.hidden = NO;
                    self.curLoadingView.hidden = YES;
                }
            }
        }
        else if([stageNumber intValue]==Stage_Request_OneFundNetValue)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                if (!self.curChartSvg) {
                    self.klineView.hidden = YES;
                    self.curErrorView.hidden = NO;
                    self.curLoadingView.hidden = YES;
                }
            }
        }
        else if ([stageNumber intValue]==Stage_Request_OneStockInfo) 
        {
            ;
        }
    }
}

-(void)changeErrorTipByStatus
{
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
//            self.curErrorView.hidden=NO;
            self.curErrorView.customTipString = errortip;
        }
        
    }
}

#pragma mark -
#pragma mark reloadData
-(void)startRefresh
{
    [[StockFuncPuller getInstance] startOneStockInfoWithSender:self type:stockType symbol:stockSymbol args:nil dataList:nil userInfo:nil];
    [self refreshChartWithIndex:[NSNumber numberWithInt:curIndex]];
}

-(void)reloadUI
{
    [self formatTitleItem];
}

@end
