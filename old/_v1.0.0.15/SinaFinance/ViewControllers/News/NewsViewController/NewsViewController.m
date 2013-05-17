//
//  NewsViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OPScrollView.h"
#import "CommentDataList.h"
#import "NewsViewController.h"
#import "MyCustomToolbar.h"
#import "BCMultiTabBar.h"
#import "FlowListViewController.h"
#import "ShareData.h"
#import "TitleDropButton.h"
#import "RegValueSaver.h"
#import "NewsListFuncPuller.h"
#import "DataListTableView.h"
#import "NewsTableViewCell.h"
#import "LKTipCenter.h"
#import "NewsFuncPuller.h"
#import "NewsContentViewController2.h"
#import "gDefines.h"
#import "AdjustOrderView.h"
#import "ProjectLogUploader.h"
#import "AppDelegate.h"
#import "MyTabBarController.h"

#define Save_TitleSelectedIndexs @"Save_TitleSelectedIndexs"
#define Save_NavOffset @"Save_NavOffset"

@interface NewsViewController ()
@property (nonatomic, retain) CommentDataList* dataList;
@property (nonatomic, retain) CommentDataList* indexdataList;
@property (nonatomic, retain) CommentDataList* worldeyedataList;
@property (nonatomic, retain) CommentDataList* mynewsList;
@property (nonatomic, retain) FlowListViewController* flowController;
@property (nonatomic, retain) NSArray* selectID;
@property (nonatomic, retain) DataListTableView* dataTableView;
@property (nonatomic, retain) AdjustOrderView* adjustOrderView;
@property (nonatomic, retain) BCMultiTabBar* curMultiTabBar;
@property (nonatomic, retain) TitleDropButton *titleBtn;
@property (nonatomic, retain) UIButton *refreshBtn;
//
@property (nonatomic, retain) DataListTableView* indexdataTableView;


@property (nonatomic, retain) NSMutableArray *indexnewsArray;
@property (nonatomic, retain) NSMutableArray *worldeyeArray;

-(void)initNotification;
-(BOOL)checkRefreshByDate;
-(void)startRefreshTableWithForce;
-(void)startRefreshTable:(BOOL)bForce;
-(void)postFailedTip;
@end

@implementation NewsViewController
{
    CommentDataList* mynewsList;
    AdjustOrderView* adjustOrderView;
    BOOL bOrderAdjusting;
    NSInteger curPage;
    NSInteger countPerPage;
    OPScrollView *s;
    WorldEyeScrollView *worldEyeScrollView;
    BOOL _isIndexFlag;
    BOOL _isWorldEyeFlag;
    NSString *worldeyeLastId;
    
    int _index_news_count;
    NSInteger _index_curPage;
}
@synthesize dataList,indexdataList,worldeyedataList;
@synthesize flowController;
@synthesize selectID;
@synthesize dataTableView,indexdataTableView;
@synthesize mynewsList;
@synthesize adjustOrderView;
@synthesize curMultiTabBar;
@synthesize titleBtn;
@synthesize refreshBtn;
@synthesize worldeyeArray,indexnewsArray;

+ (NewsViewController *)sharedInstance {
    static NewsViewController *sharedInstance = nil;
    
    static dispatch_once_t predicate; dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}



- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"新闻";
        self.tabBarItem.image = [UIImage imageNamed:@"news_icon.png"];
        dataList = [[CommentDataList alloc] initWithFileName:@"news.json"];
        mynewsList = [[CommentDataList alloc] initWithFileName:@"mynews1.json"];
        indexdataList = [[CommentDataList alloc] init];
        indexdataList.dataTableName = [NSString stringWithFormat:@"%@",@"indexdatatable"];
       
        worldeyedataList = [[CommentDataList alloc] init];
        worldeyedataList.dataTableName = [NSString stringWithFormat:@"%@",@"worldeyedatatable"];
        
        self.worldeyeArray =  [NSMutableArray array];
        self.indexnewsArray=  [NSMutableArray array];
        worldeyeLastId = @"";
        countPerPage = 20;
    }
    return self;
}

-(void)dealloc
{
    [dataList release];
    [flowController release];
    [selectID release];
    [dataTableView release];
    [mynewsList release];
    [adjustOrderView release];
    [curMultiTabBar release];
    [titleBtn release];
    [refreshBtn release];
    if (worldeyeLastId) {
        [worldeyeLastId release];
    }
    
    
    [super dealloc];
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
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:NO];
    
    [[AppDelegate sharedAppDelegate] update_push_xinwen_count_num];
    [self update_push_xinwen_num];
    
  
//    [backBtn setTitle:btnTitle forState:UIControlStateNormal];
}

-(void)update_push_xinwen_num{
//    
    UILabel *l = (UILabel *)[self.view viewWithTag:10001];
    int push_cur_count_news=[[NSUserDefaults standardUserDefaults] integerForKey:PUSH_CUR_COUNT_XINWEN];
    
//    push_cur_count_news= 100;
    NSString *btnTitle = [NSString stringWithFormat:@"%d",push_cur_count_news];
    l.text = btnTitle;
    
    
     UIButton *backBtn = (UIButton *)[self.view viewWithTag:10000];
    

    [self reset_frame:backBtn andLabel:l];
    
    [self.view bringSubviewToFront:l];
    [self.view bringSubviewToFront:backBtn];
    
    NSLog(@"---- %@",btnTitle);
}


-(void)reset_frame:(UIButton *)backBtn andLabel:(UILabel* )l{
    int push_cur_count_news=[[NSUserDefaults standardUserDefaults] integerForKey:PUSH_CUR_COUNT_XINWEN];
    
    int num_lable_x = 0;
    int num_lable_w = 20;
    int num_label_y = 8;
    //    测试数据
    //    push_cur_count_news = 200;
    if (push_cur_count_news<10) {
        num_lable_x= 49;
    }
    //    测试数据
    //    push_cur_count_news+=20;
    
    if (push_cur_count_news>=10 && push_cur_count_news<100) {
        num_lable_x= 45;
    }
    
    if (push_cur_count_news>=100) {
        num_lable_x= 40;
        num_lable_w = 30;
        num_label_y = 9;
    }
    
    l.frame = CGRectMake(num_lable_x, num_label_y, num_lable_w, 10);
    backBtn.frame = CGRectMake(7, -3, 55, 48);//88*100
    
    if (push_cur_count_news == 0) {
        [backBtn setBackgroundImage:[UIImage imageNamed:@"push_tixing_1"] forState:UIControlStateNormal];
        l.hidden = YES;
    }else if (push_cur_count_news <100) {
        l.hidden  = NO;
        [backBtn setBackgroundImage:[UIImage imageNamed:@"push_tixing_2"] forState:UIControlStateNormal];
    }else{
        l.hidden  = NO;
        [backBtn setBackgroundImage:[UIImage imageNamed:@"push_tixing_3"] forState:UIControlStateNormal];
    }
    
}

- (void)initToolbar
{
    MyCustomToolbar *topToolBar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    
    UILabel *num_label = [[UILabel alloc] init];
    num_label.tag = 10001;
     
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         backBtn.tag = 10000;
    
    
    [self reset_frame:backBtn andLabel:num_label];
 
    
    
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(handleShowNewsBackPressed:) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:backBtn];
    
    
    int push_cur_count_news=[[NSUserDefaults standardUserDefaults] integerForKey:PUSH_CUR_COUNT_XINWEN];
    NSString *lable_title = [NSString stringWithFormat:@"%d",push_cur_count_news];
    num_label.text = lable_title;
    num_label.font = [UIFont systemFontOfSize:12];
    num_label.textColor = [UIColor whiteColor];
    num_label.backgroundColor = [UIColor clearColor];
    [topToolBar addSubview:num_label];
    
    
    TitleDropButton* oneTitleBtn = [[TitleDropButton alloc] initWithFrame:CGRectMake(80, 0, 160, 44)];
    self.titleBtn = oneTitleBtn;
    titleBtn.delegate = self;
    titleBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    titleBtn.titleLabel.textColor = [UIColor whiteColor];
    titleBtn.hasImage = NO;
    [topToolBar addSubview:titleBtn];
    [oneTitleBtn release];
    
    titleBtn.titleString = @"新浪财经";
    
    
    UIButton* oneRefreshBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    self.refreshBtn = oneRefreshBtn;
    refreshBtn.frame = CGRectMake(280, 10, 25, 23);
    [refreshBtn setImage:[UIImage imageNamed:@"refresh_btn.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(startRefreshTableWithForce) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:refreshBtn];
    
    float multiBarHeight = 32;
    NSArray* multiBarHeightArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:32], nil];
    CGRect multiRect = CGRectMake(0, 44, 320, multiBarHeight);
    BCMultiTabBar* multiTabBar = [[BCMultiTabBar alloc] initWithFrame:multiRect heights:multiBarHeightArray];
    multiTabBar.delegate = self;
    multiTabBar.selectedMovement = MovementStyle_Free;
    
     NSLog(@"SSSS width----%@",multiTabBar.tabBarArray);
    
     
    
    
    for (int i=0; i<[multiTabBar.tabBarArray count]; i++) {
        NSLog(@"SSSS width----%d",i);
        
        
        BCTabBar* oneTabBar = [multiTabBar.tabBarArray objectAtIndex:i];
        if(i==0)
        {
            oneTabBar.selectedAlignment = AlignmentStyle_Center;
            oneTabBar.showedMaxItem = 5;
//            oneTabBar.arrowImage = [[UIImage imageNamed:@"bg_selected"] stretchableImageWithLeftCapWidth:2.5f topCapHeight:4];
//            oneTabBar.arrowView.frame = CGRectMake(30, 10, 50, 10);
//            oneTabBar.ArrowBackScrollAnimate = YES;

            
            UIImage* columnBack = [UIImage imageNamed:@"weibo_tab_back.png"];
            columnBack = [columnBack stretchableImageWithLeftCapWidth:1.0 topCapHeight:15.0];
            oneTabBar.backgroundImage = columnBack;
            oneTabBar.maxTabWidth = 100;
            oneTabBar.arrowCoverScroll = NO;
            oneTabBar.ArrowBackScrollAnimate = NO;
            oneTabBar.leftArrowImage = [UIImage imageNamed:@"weibo_tab_left.png"];
            oneTabBar.rightArrowImage = [UIImage imageNamed:@"weibo_tab_right.png"];
            oneTabBar.leftRightArrowWidth = 7;
        }
    }
    [self.view addSubview:multiTabBar];
    curMultiTabBar = multiTabBar;
    [multiTabBar release];
    
    int curY = multiRect.origin.y + multiRect.size.height;
    int maxHeight = self.view.bounds.size.height - curY;
    DataListTableView* dataView = [[DataListTableView alloc] initWithFrame:CGRectMake(0, curY, 320, maxHeight)];
    dataView.defaultSucBackString = @"";
    dataView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    dataView.delegate = self;
    dataView.tableView.backgroundColor = [UIColor clearColor];
    dataView.hasPageMode = YES;
    [self.view addSubview:dataView];
    self.dataTableView = dataView;
    [dataView release];
    
    AdjustOrderView* adjustView = [[AdjustOrderView alloc] initWithFrame:CGRectMake(0, curY, 320, maxHeight)];
    adjustView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    adjustView.delegate = self;
    adjustView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:adjustView];
    self.adjustOrderView = adjustView;
    self.adjustOrderView.hidden = YES;
    [adjustView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    //    self.view.backgroundColor = [UIColor colorWithRed:3/255.0 green:30/255.0 blue:54/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initToolbar];
    [self initNotification];
    
    int titleSelectedIndex = 0;
    int navSelectedIndex = 0;
    CGPoint posPint = CGPointZero;
    NSArray* savedIndexs = [[RegValueSaver getInstance] readSystemInfoForKey:Save_TitleSelectedIndexs];
    NSString* posString = [[RegValueSaver getInstance] readSystemInfoForKey:Save_NavOffset];
    if (savedIndexs) {
        titleSelectedIndex = [(NSNumber*)[savedIndexs objectAtIndex:0] intValue];
        navSelectedIndex = [(NSNumber*)[savedIndexs objectAtIndex:1] intValue];
    }
    if (posString) {
        posPint = CGPointFromString(posString);
    }
    BCTabBar* tabBar = [curMultiTabBar.tabBarArray objectAtIndex:0];
    TabBarPreLoadData* preData = [[TabBarPreLoadData alloc] init];
    preData.selectedIndex = navSelectedIndex;
    preData.contentOffset = posPint;
    tabBar.preData = preData;
    [preData release];
    [self controller:nil didSelectIndex:titleSelectedIndex byBtn:NO];
    
    
    _curStockStatusView = [[CurStockStatusView alloc] initWithFrame:CGRectMake(0, UI_MAX_HEIGHT - 90, 430, 20)];
    _curStockStatusView.hidden = YES;
    [self.view addSubview:_curStockStatusView];
    
}

-(void)showNewContent{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"push_url"]) {
        return;
    }
    [self update_push_xinwen_num];
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



-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(CommonListSucceed:)
               name:CommonListSucceedNotification
             object:nil];
    [nc addObserver:self
           selector:@selector(CommonListFailed:)
               name:CommonListFailedNotification
             object:nil];
    
    [nc addObserver:self
           selector:@selector(curStockStatusNotificationName:)
               name:@"curStockStatusNotificationName"
             object:nil];
    
    [nc addObserver:self
           selector:@selector(update_push_xinwen_count_num_no:)
               name:@"update_push_xinwen_count_num_no"
             object:nil];
    
}

/**
 * 更新界面上的未读新闻个数
 *
 */
-(void)update_push_xinwen_count_num_no:(NSNotification*)notify
{
    [self update_push_xinwen_num];
}



-(void)titleDropBtnClicked:(TitleDropButton*)sender
{
//    [sender.titleBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    BOOL oldSelected = sender.selected;
//    sender.selected = !oldSelected;
//    FlowListViewController* newFlowController = [[FlowListViewController alloc] initWithSelectedIndex:0];
//    newFlowController.delegate = self;
//    newFlowController.selectedIndex = curTitleIndex;
//    NSArray* nameArray = [self.dataList subCommentNamelistAtRowColumns:nil];
//    NSArray* mynewsArray = [self.mynewsList subCommentNamelistAtRowColumns:nil];
//    NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:0];
//    [newArray addObjectsFromArray:nameArray];
//    [newArray addObjectsFromArray:mynewsArray];
//    newFlowController.listNames = newArray;
//    [newArray release];
//    self.flowController = newFlowController;
//    [newFlowController show:CGPointMake(160, 43) boxSize:CGSizeMake(120, 250)];
//    [newFlowController release];
}


-(void)curStockStatusNotificationName:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    //    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    
    NSMutableArray *re  = [NSMutableArray arrayWithCapacity:2];
    for (NSDictionary *s in userInfo) {
//        if ([[s objectForKey:@"symbol"] isEqualToString:@"sh000001"]) {
//            [re addObject:s];
//        }
//        if ([[s objectForKey:@"symbol"] isEqualToString:@"sz399001"]) {
            [re addObject:s];
//        }
        
        
    }
    _curStockStatusView.hidden = NO;
    [_curStockStatusView updateInfo:re];
}

-(void)CommonListSucceed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSArray* args = [userInfo valueForKey:RequsetArgs];
        NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
        NSArray* array = [userInfo valueForKey:RequsetArray];
        
        NewsObject *s = [self.indexdataList oneObjectWithIndex:0 IDList:self.selectID];
        if ([CommentDataList  checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
            
            NSMutableArray *topArray = [NSMutableArray array];
            NSMutableArray *newArray = [NSMutableArray array];
            for (NewsObject* obj in array) {
                
                NSDictionary *topDict = [obj newsData];
                if ([topDict objectForKey:@"top"] ) {
                    //                    [topArray addObject:topDict];
                    //                    TopNews *t = [[TopNews alloc] initWithDict:topDict];
                    [topArray addObject:obj];
                }else{
                    [newArray addObject:obj];
                }
            }
            
            if (_isIndexFlag) {
                
                _index_curPage = [[userInfo objectForKey:RequsetPage] intValue];
                if (_index_curPage == 1) {
                    //如果是第一个次或者点右上角的刷新按钮，需要移除之前的记录
                    [self.indexnewsArray  removeAllObjects];
                }
                [self.indexnewsArray addObjectsFromArray:newArray];
                [self.indexdataList refreshCommnetContents:self.indexnewsArray IDList:self.selectID];
              //  [self.indexdataList addCommnetContents:newArray IDList:self.selectID];
                self.dataTableView.dataList = self.indexdataList;
                self.dataTableView.selectID = self.selectID;
            }
            
            if (_isWorldEyeFlag) {
                if ([newArray count]>0) {
//                    [newArray removeObjectAtIndex:0];
//                    [newArray removeObjectAtIndex:1];
                    [self.worldeyeArray addObjectsFromArray:newArray];
                }
                
                
                [self.worldeyedataList refreshCommnetContents:self.worldeyeArray IDList:self.selectID];
                
                self.dataTableView.dataList = self.worldeyedataList;
                self.dataTableView.selectID = self.selectID;
                
                if (array && [array count]>0) {
                    NewsObject* obj = [array objectAtIndex:[array count]-1];
                    //                NSLog(@"%@",[obj dataDict]);
                    worldeyeLastId = [[obj dataDict] objectForKey:@"id"];
                }
               
            }
            
            
            if ([pageNumber intValue]<=1) {
                [self.dataTableView scrollTop:NO];
            }
            BOOL pageEnd = [self.dataList pageEndInfoWithIDList:self.selectID];
         
            
            if (_isIndexFlag) {
                if ( [newArray count]>5) {
                     pageEnd = NO;
                }else{
                    pageEnd = YES;
                    
                }
                // [self.indexdataList pageEndInfoWithIDList:self.selectID];
            }
            
            if (_isWorldEyeFlag) {
                pageEnd = NO;//[self.worldeyedataList pageEndInfoWithIDList:self.selectID];
            }
            
            if(pageEnd) {
                [self.dataTableView setPageMode:PageCellType_Ending];
            }
            else {
                [self.dataTableView setPageMode:PageCellType_Normal];
            }
            
        
            if (!pageEnd) {
                [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
            }
            else {
                [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:YES];
            }
            
        _index_news_count = [newArray count];
        
        }
    }
}

-(void)CommonListFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSArray* args = [userInfo valueForKey:RequsetArgs];
        NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
        if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
            [self postFailedTip];
            [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:YES];
        }
    }
}

-(void)postFailedTip
{
    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
}

#pragma mark -
#pragma mark FlowListViewController
-(void)controller:(FlowListViewController*)controller didSelectIndex:(NSInteger)index byBtn:(BOOL)byBtn
{
    curTitleIndex = index;
    curTitleIndex = 4;//这样就可以选中【我的财经】
    NSArray* nameArray = [self.dataList subCommentNamelistAtRowColumns:nil];
    NSArray* myNewsArray = [self.mynewsList subCommentNamelistAtRowColumns:nil];
    NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:0];
    [newArray addObjectsFromArray:nameArray];
    [newArray addObjectsFromArray:myNewsArray];
    titleBtn.titleString = [newArray objectAtIndex:index];
    titleBtn.titleString = @"新浪财经";


    [newArray release];
    [curMultiTabBar reloadData];
    if (byBtn) {
        if (index==0) {
            [[ProjectLogUploader getInstance] writeDataString:@"news_comment"];
        }
        else if(index==1) {
            [[ProjectLogUploader getInstance] writeDataString:@"stock_fund"];
        }
        else if(index==2)
        {
            [[ProjectLogUploader getInstance] writeDataString:@"finance_invest"];
        }
        else if(index==3)
        {
            [[ProjectLogUploader getInstance] writeDataString:@"technology_life"];
        }
        else if(index==4)
        {
            [[ProjectLogUploader getInstance] writeDataString:@"My finance_news"];
        }
    }
}

-(void)controllerHidenWithController:(FlowListViewController*)controller
{
    titleBtn.selected = NO;
}

#pragma mark -
#pragma mark multiTabBar
-(NSArray*)multiTabBar:(BCMultiTabBar*)multiTabBar tabsForIndex:(NSIndexPath *)index
{
    NSMutableArray* rtval = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    NSArray* tempArray = nil;
    NSArray* constArray = [dataList subCommentNamelistAtRowColumns:nil];
    BOOL bUseMyList = NO;
    if ([constArray count]>curTitleIndex) {
        NSMutableArray* columns = [[NSMutableArray alloc] initWithCapacity:0];
        int realIndex = curTitleIndex;
        [columns addObject:[NSNumber numberWithInt:realIndex]];
        tempArray = [dataList subCommentNamelistAtRowColumns:columns];
        [columns release];
    }
    else {
        NSMutableArray* columns = [[NSMutableArray alloc] initWithCapacity:0];
        int realIndex = curTitleIndex - [constArray count];
        [columns addObject:[NSNumber numberWithInt:realIndex]];
        tempArray = [mynewsList subCommentNamelistAtRowColumns:columns];
        NSMutableArray* newArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        [newArray addObjectsFromArray:tempArray];
        [newArray addObject:@"+栏目"];
        tempArray = newArray;
        bUseMyList = YES;
        [columns release];
    }
    
    if (index.row==0) {
        if (tempArray) {
            for(int i=0;i<[tempArray count];i++) {
                BCTab* oneTab = [[BCTab alloc] init];
                NSLog(@"%@",oneTab.nameLabel.frame);
                oneTab.nameLabel.text = [tempArray objectAtIndex:i];
                oneTab.nameLabel.font = [UIFont systemFontOfSize:16.0];
               
                oneTab.hasbgEdageImageView = YES;
                oneTab.backgroundImageView.image = [UIImage imageNamed:@"bg_clear"];
//                oneTab.backgroundImageView.highlightedImage = [UIImage imageNamed:@"edsfs.png"];
                
                oneTab.nameLabel.textColor = [UIColor colorWithRed:50/255.0 green:110/255.0 blue:186/255.0 alpha:1.0];
                oneTab.nameLabel.highlightedTextColor =  [UIColor whiteColor];//[UIColor colorWithRed:0/255.0 green:56/255.0 blue:128/255.0 alpha:1.0];
                [rtval addObject:oneTab];
                [oneTab release];
            }
        }
    }
    
    return rtval;
}

- (void)multiTabBar:(BCMultiTabBar *)multiTabBar didSelectTabAtIndex:(NSIndexPath*)index byBtn:(BOOL)byBtn
{
    if (!bOrderAdjusting) {
        NSArray* constArray = [self.dataList subCommentNamelistAtRowColumns:nil];
        int realIndex = 0;
        BOOL bUseMyList = NO;
        CommentDataList* usedDataList = nil;
        if ([constArray count]>curTitleIndex) {
            realIndex = curTitleIndex;
            usedDataList = dataList;
            
//            if (_isIndexFlag) {
//                usedDataList = indexdataList;
//            }
//            
//            if (_isWorldEyeFlag) {
//                usedDataList = worldeyedataList;
//            }
        }
        else {
            realIndex = curTitleIndex - [constArray count];
            usedDataList = mynewsList;
            bUseMyList = YES;
        }
        
        BOOL clickedAdjust = NO;
        BCTabBar* tabBar = [curMultiTabBar.tabBarArray objectAtIndex:0];
        NSInteger barIndex = [tabBar selectedColumn];
        if (bUseMyList) {
            NSMutableArray* columns = [[NSMutableArray alloc] initWithCapacity:0];
            [columns addObject:[NSNumber numberWithInt:realIndex]];
            NSArray* subConstArray = [self.mynewsList subCommentNamelistAtRowColumns:columns];
            if ([subConstArray count]<=barIndex) {
                clickedAdjust = YES;
            }
        }
        
        if (!clickedAdjust) {
            NSNumber* realTitleIndexNum = [NSNumber numberWithInt:realIndex];
            NSNumber* barIndexNum =  [NSNumber numberWithInt:barIndex];
            NSMutableArray* realSelectedIndexList = [[NSMutableArray alloc] initWithObjects:realTitleIndexNum,barIndexNum, nil];
            NSArray* newSelectID = [usedDataList nameKeysWithIDList:realSelectedIndexList];
            if (bUseMyList) {
                newSelectID = [self realSelectIDFromSourceSelectID:newSelectID];
            }
            
            
           
            
            [self customer:[barIndexNum intValue]];
            
            
            if (![CommentDataList checkNumberArrayEqualWithFirstArray:newSelectID secondArray:self.selectID])
            {
                self.selectID = newSelectID;
                NSString* key = [self.selectID objectAtIndex:1];
                if ([[key lowercaseString] isEqualToString:@"top"]) {
                    self.dataTableView.hasPageMode = NO;
                }
                else {
                    self.dataTableView.hasPageMode = YES;
                }
                if (byBtn) {
                    [self addProjectLog];
                }
                NSNumber* titleIndexNum = [NSNumber numberWithInt:curTitleIndex];
                NSMutableArray* selectedIndexList = [[NSMutableArray alloc] initWithObjects:titleIndexNum,barIndexNum, nil];
                [[RegValueSaver getInstance] saveSystemInfoValue:selectedIndexList forKey:Save_TitleSelectedIndexs encryptString:NO];
                [selectedIndexList release];
                [realSelectedIndexList release];
                NSString* posString = NSStringFromCGPoint(tabBar.scrollPos);
                [[RegValueSaver getInstance] saveSystemInfoValue:posString forKey:Save_NavOffset encryptString:NO];
                
                self.dataTableView.dataList = self.dataList;
                
                if (_isIndexFlag) {
                    self.dataTableView.dataList = self.indexdataList;
                }
                
                if (_isWorldEyeFlag) {
                    self.dataTableView.dataList = self.worldeyedataList;
                }

                
                self.dataTableView.selectID = self.selectID;
                NSTimer* timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(startRefreshTableNoForce) userInfo:nil repeats:NO];
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            }
        }
        else {
            self.selectID = nil;
            NSTimer* timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(startAdjustColumns) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }
}

-(void)customer:(int)sid{
//    NSMutableArray* columns = [[NSMutableArray alloc] initWithCapacity:0];
//    int realIndex = curTitleIndex - [constArray count];
//    [columns addObject:[NSNumber numberWithInt:realIndex]];
//    tempArray = [mynewsList subCommentNamelistAtRowColumns:columns];
//    NSMutableArray* newArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
//    [newArray addObjectsFromArray:tempArray];
//    [newArray addObject:@"+栏目"];
//    tempArray = newArray;
//    bUseMyList = YES;
//    [columns release];
    
    
    NSArray* tempArray = nil;
    NSArray* constArray = [dataList subCommentNamelistAtRowColumns:nil];
    BOOL bUseMyList = NO; 
    
    NSMutableArray* columns = [[NSMutableArray alloc] initWithCapacity:0];
    int realIndex = curTitleIndex - [constArray count];
    [columns addObject:[NSNumber numberWithInt:realIndex]];
    tempArray = [mynewsList subCommentNamelistAtRowColumns:columns];
 
    NSString *cTabName = [tempArray objectAtIndex:sid];
    
    _isIndexFlag = NO;
    if ([cTabName isEqualToString:@"要闻"]) {
         _isIndexFlag = YES;
        _index_news_count = 0;
    }
    
    _isWorldEyeFlag = NO;
    if ([cTabName isEqualToString:@"新闻眼"]) {
        _isWorldEyeFlag = YES;
    }

    
    
}

-(void)addProjectLog
{
    NSString* key = [self.selectID objectAtIndex:1];
    if ([key isEqualToString:@"index"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"news"];
    }
    else if ([key isEqualToString:@"review"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"comment"];
    }
    else if ([key isEqualToString:@"worldeye"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"news_globaleye"];
    }
    else if ([key isEqualToString:@"chanjing"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"industry"];
    }
    else if ([key isEqualToString:@"deep"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"depth"];
    }
    else if ([key isEqualToString:@"top"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"ranking"];
    }
    else if ([key isEqualToString:@"roll"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"rolling"];
    }
    else if ([key isEqualToString:@"stock"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"Anews"];
    }
    else if ([key isEqualToString:@"hkstock"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"Hknews"];
    }
    else if ([key isEqualToString:@"usstock"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"USnews"];
    }
    else if ([key isEqualToString:@"fund"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"fund"];
    }
    else if ([key isEqualToString:@"money"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"finance"];
    }
    else if ([key isEqualToString:@"bank"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"bank"];
    }
    else if ([key isEqualToString:@"insurance"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"insurance"];
    }
    else if ([key isEqualToString:@"futuremarket"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"futures"];
    }
    else if ([key isEqualToString:@"forex"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"foreign_exchange"];
    }
    else if ([key isEqualToString:@"it"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"IT"];
    }
    else if ([key isEqualToString:@"consume"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"consume"];
    }
    else if ([key isEqualToString:@"internet"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"web"];
    }
    else if ([key isEqualToString:@"tele"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"communication"];
    }
}

-(NSArray*)realSelectIDFromSourceSelectID:(NSArray*)sourceSelectID
{
    NSArray* rtval = sourceSelectID;
    NSString* realCode = [sourceSelectID lastObject];
    NSArray* constArray = [self.dataList subCommentNamelistAtRowColumns:nil];
    for (int i=0; i<[constArray count]; i++) {
        NSNumber* iNumber = [NSNumber numberWithInt:i];
        NSArray* columnsArray = [NSArray arrayWithObject:iNumber];
        NSArray* subConstArray = [self.dataList subCommentNamelistAtRowColumns:columnsArray];
        for (int j=0; j<[subConstArray count]; j++) {
            NSNumber* jNumber = [NSNumber numberWithInt:j];
            NSMutableArray* selectedIndexList = [[NSMutableArray alloc] initWithObjects:iNumber,jNumber, nil];
            NSArray* oneCodeArray = [self.dataList nameKeysWithIDList:selectedIndexList];
            [selectedIndexList release];
            NSString* oneCode = [oneCodeArray lastObject];
            if ([oneCode isEqualToString:realCode]) {
                rtval = oneCodeArray;
                break;
            }
        }
    }
    
    return rtval;
}

-(void)startAdjustColumns
{
    self.dataTableView.hidden = YES;
    self.adjustOrderView.hidden = NO;
    NSArray* orrderArray = [mynewsList orderArrayOfIndex:0];
    [self.adjustOrderView setDataArray:orrderArray];
}

-(void)startRefreshTableNoForce
{
    self.adjustOrderView.hidden = YES;
    self.dataTableView.hidden = NO;
    [self startRefreshTable:NO];
}

-(void)startRefreshTableWithForce
{
    [self startRefreshTable:YES];
}


-(void)startRefreshTable:(BOOL)bForce
{
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
    
    
    NSNumber* indexpageNumber = [self.indexdataList infoValueWithIDList:self.selectID ForKey:@"page"];
    if (indexpageNumber) {
        _index_curPage = [indexpageNumber intValue];
    }
    else
    {
        _index_curPage = 1;
    }
    
    
    [self.dataTableView scrollTop:NO];
    BOOL pageEnd = [self.dataList pageEndInfoWithIDList:self.selectID];
    
    if (_isIndexFlag) {
        pageEnd = [self.indexdataList pageEndInfoWithIDList:self.selectID];
//        pageEnd = NO;//
    }
    
    if (_isWorldEyeFlag) {
        pageEnd = NO;//[self.worldeyedataList pageEndInfoWithIDList:self.selectID];
    }
    
    if(pageEnd) {
        [self.dataTableView setPageMode:PageCellType_Ending];
    }
    else {
        [self.dataTableView setPageMode:PageCellType_Normal];
    }
    
    
    
    [self.dataTableView reloadData];
    
    if (needRefresh) {
        if (_isIndexFlag) {
            [self.dataTableView startLoadingUI];
            NSArray* curIndexs = [dataList IDListWithNameKeys:self.selectID];
            NSArray* curAPIs = [NSArray arrayWithObjects:@"http://platform.sina.com.cn/client/list?app_key=3346933778&partid=1&len=20&page=1", nil];
            [[NewsIndexFuncPuller getInstance] startListWithSender:self page:1 endTime:0 count:countPerPage withAPICode:curAPIs args:self.selectID dataList:self.indexdataList bInback:NO];
        }else if(_isWorldEyeFlag){
            [self.worldeyeArray removeAllObjects];
            [self.dataTableView startLoadingUI];
            NSArray* curIndexs = [dataList IDListWithNameKeys:self.selectID];
            NSArray* curAPIs = [NSArray arrayWithObjects:@"http://platform.sina.com.cn/global_eye/wap_api?app_key=3346933778&size=20", nil];
            [[NewsIndexFuncPuller getInstance] startListWithSender:self page:1 endTime:0 count:countPerPage withAPICode:curAPIs args:self.selectID dataList:self.worldeyedataList bInback:NO];
        }else{
            [self.dataTableView startLoadingUI];
            NSArray* curIndexs = [dataList IDListWithNameKeys:self.selectID];
            NSArray* curAPIs = [dataList curCommentAPICodeAtRowColumns:curIndexs];
            [[NewsListFuncPuller getInstance] startListWithSender:self page:1 endTime:0 count:countPerPage withAPICode:curAPIs args:self.selectID dataList:self.dataList bInback:NO];
        }
    }
    else
    {
        self.dataTableView.dataList = dataList;
        
        if (_isIndexFlag) {
            self.dataTableView.dataList = indexdataList;
        }
        
        if (_isWorldEyeFlag) {
            self.dataTableView.dataList = worldeyedataList;
        }
        
        if(pageEnd) {
            [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:YES];
        }
        else {
            [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
        }
        
    }
}

-(BOOL)checkRefreshByDate
{
    BOOL rtval = NO;
    NSDate* oldDate = [dataList dateInfoWithIDList:self.selectID];
 
    if (_isIndexFlag) {
        oldDate = [indexdataList dateInfoWithIDList:self.selectID];
    }
    
    if (_isWorldEyeFlag) {
        oldDate = [worldeyedataList dateInfoWithIDList:self.selectID];
    }
    
    
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

-(UITableViewCell*)newsCellWithDataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object{
    
    NSString *NewsCellIdentifier = [NSString stringWithFormat:@"NewsCellIdentifier"];
    NewsTableViewCell *cell = (NewsTableViewCell*)[view.tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
    if(cell == nil){
        cell = [[[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSString* topString = [object valueForKey:NewsList_top];
    NSString *title = [object valueForKey:NewsList_shorttitle];
    if (!title||[title length]==0) {
        title = [object valueForKey:NewsList_title];
    }
    
    NSString* code = [view.selectID objectAtIndex:1];
    UIImageView* keepTopImageView = (UIImageView*)[cell viewWithTag:1111878];
    [keepTopImageView removeFromSuperview];
    if ([topString intValue]>0) {
        title = [NSString stringWithFormat:@"           %@",title];
        UIImage* keepTopImage = [UIImage imageNamed:@"news_list_cell_keeptop.png"];
        UIImageView* keepTopImageView = [[UIImageView alloc] initWithImage:keepTopImage];
        CGRect prefixRect = CGRectMake(15, 2, 42, 22);
        keepTopImageView.frame = prefixRect;
        keepTopImageView.tag = 1111878;
        [cell addSubview:keepTopImageView];
        [keepTopImageView release];
        
        UILabel* tempLabel = [[UILabel alloc] initWithFrame:keepTopImageView.bounds];
        tempLabel.backgroundColor = [UIColor clearColor];
        tempLabel.textColor = [UIColor whiteColor];
        tempLabel.font = [UIFont systemFontOfSize:13.0];
        tempLabel.textAlignment = UITextAlignmentCenter;
        [keepTopImageView addSubview:tempLabel];
        NSString* keepTopStr = [self keepTopPrefixStringWithCode:code index:path.row];
        tempLabel.text = keepTopStr;
        [keepTopStr release];
    }
    
    if(title){
        cell.titleLabel.text = title;
    }
    else {
        cell.titleLabel.text = @"";
    }
    

    BOOL hasRead = [self is_news_has_read:object];
    
    BOOL bTopColumn = NO;
    if ([view.selectID count]>=2) {
        if ([code isEqualToString:@"top"]) {
            bTopColumn = YES;
        }
    }
    
    UIView* imageView = [cell viewWithTag:333899];
    [imageView removeFromSuperview];
    UIView* labelView = [cell viewWithTag:599988];
    [labelView removeFromSuperview];
    if (!bTopColumn) {
        cell.leftrightMargin = 5.0;
        if(!hasRead){
            cell.readIcon.hidden = NO;
        }
        else{
            cell.readIcon.hidden = YES;
        }
    }
    else {
        cell.leftrightMargin = 25.0;
        cell.readIcon.hidden = YES;
        UIImageView* imageView1 = [[UIImageView alloc] init];
        imageView1.tag = 333899;
        imageView1.frame = CGRectMake(5, 4, 25, 16);
        [cell addSubview:imageView1];
        [imageView1 release];
        if (path.row<3) {
            UIImage* imageblue = [UIImage imageNamed:@"news_stockbar_list_cellavator_blue.png"];
            imageView1.image = imageblue;
        }
        else {
            UIImage* imagegray = [UIImage imageNamed:@"news_stockbar_list_cellavator_gray.png"];
            imageView1.image = imagegray;
        }
        
        UILabel* avatorLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, 25, 16)];
        avatorLabel1.textColor = [UIColor whiteColor];
        avatorLabel1.tag = 599988;
        avatorLabel1.backgroundColor = [UIColor clearColor];
        avatorLabel1.textAlignment = UITextAlignmentCenter;
        [cell addSubview:avatorLabel1];
        [avatorLabel1 release];
        avatorLabel1.text = [NSString stringWithFormat:@"%d",path.row+1];
    }
    
    
    if(!hasRead) {
        if ([topString intValue]>0) {
            cell.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:61/255.0 blue:113/255.0 alpha:1.0];
            cell.dateLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
            cell.sourceLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        }
        else {
            cell.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:88/255.0 blue:162/255.0 alpha:1.0];
            cell.dateLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
            cell.sourceLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        }
    }
    else {
        cell.titleLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        cell.dateLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        cell.sourceLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    }
    NSString *dateString = [object valueForKey:NewsList_date];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
    [formatter setDateFormat:[NSString stringWithString:@"EEE, dd MMM yyyy HH:mm:ss z"]];
    NSDate* formatDate = [formatter dateFromString:dateString];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* formatnDateString = [formatter stringFromDate:formatDate];
    cell.dateLabel.text = formatnDateString;
    
    if ([view.selectID count]>=2) {
        if ([[code lowercaseString] isEqualToString:@"deep"]) {
            NSString* media = [object valueForKey:NewsList_media];
            cell.dateLabel.text = media;
        }
    }
    
    NSString* commentsCount = [object valueForKey:NewsList_showcomments];
    NSString* conmentsStr = [NSString stringWithFormat:@"评论(%@)",commentsCount];
    cell.sourceLabel.text = conmentsStr;
    [cell.sourceLabel sizeToFit];
    CGRect sourceRect = cell.sourceLabel.bounds;
    sourceRect.origin.x = view.tableView.bounds.size.width - sourceRect.size.width - 10;
    sourceRect.origin.y = 29;
    cell.sourceLabel.frame = sourceRect;
    return cell;
}


- (int)countWord:(NSString*)s

{
    
    int i,n=[s length],l=0,a=0,b=0;
    
    unichar c;
    
    for(i=0;i<n;i++){
        
        c=[s characterAtIndex:i];
        
        if(isblank(c)){
            
            b++;
            
        }else if(isascii(c)){
            
            a++;
            
        }else{
            
            l++;
            
        }
        
    }
    
    if(a==0 && l==0) return 0;
    
    return l+(int)ceilf((float)(a+b)/2.0);
    
}


-(UITableViewCell*)indexCellWithDataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object{
    
    
    if (path.row == 0) {
        NSString *NewsCellIdentifier = [NSString stringWithFormat:@"indexCellIdentifier"];
        IndexTableViewCell *cell = (IndexTableViewCell*)[view.tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
        if(cell == nil){
            cell = [[[IndexTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //        s=[[OPScrollTestView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
        NSArray *topNewsArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"topNewsArray111"] retain];
        NSMutableArray *topNewsArray1 = [NSMutableArray array];
        if (topNewsArray && [topNewsArray count] > 0) {
            for (NSDictionary *d in topNewsArray) {
                TopNews *t = [[TopNews alloc] initWithDict:d];
                [topNewsArray1 addObject:t];
            }
            
            
            s = [[OPScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, NEWS_OPSCROLL_VIEW_HIGHT) andSource:topNewsArray1];
            s.delegate = self;
            
            [cell.contentView addSubview:s];
            [s release];
            return cell;
            
            
        }
        
        return cell;
    }
    
    NSString *NewsCellIdentifier = [NSString stringWithFormat:@"indexCellIdentifier111"];
    IndexTableViewCell *cell = (IndexTableViewCell*)[view.tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
    if(cell == nil){
        cell = [[[IndexTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    NSString* topString = [object valueForKey:NewsList_top];
    NSString *title = [object valueForKey:NewsList_shorttitle];
    if (!title||[title length]==0) {
        title = [object valueForKey:NewsList_title];
    }
    
 
    if(title){
        
        cell.titleLabel.text = title;
    }
    else {
        cell.titleLabel.text = @"";
    }
    
 
    UIView* imageView = [cell viewWithTag:333899];
    [imageView removeFromSuperview];
    UIView* labelView = [cell viewWithTag:599988];
    [labelView removeFromSuperview];
 
 
    BOOL hasRead = [self is_news_has_read:object];
    
    if(!hasRead) {
        cell.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:88/255.0 blue:162/255.0 alpha:1.0];
        cell.detailLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        cell.sourceLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    }
    else {
        cell.titleLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        cell.detailLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        cell.sourceLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    }
    
    
  
    
 
    NSString *dateString = [object valueForKey:NewsIndexList_content];
 
    
    int wordcount = [self countWord:dateString];
    NSMutableString *detailstr = [NSMutableString string];
 
    
    cell.detailLabel.text = dateString;
    
 
    
    NSString* commentsCount = [object valueForKey:NewsList_showcomments];
    NSString* conmentsStr = [NSString stringWithFormat:@"评论(%@)",commentsCount];
    cell.sourceLabel.text = conmentsStr;
    [cell.sourceLabel sizeToFit];
    CGRect sourceRect = cell.sourceLabel.bounds;
    sourceRect.origin.x = view.tableView.bounds.size.width - sourceRect.size.width - 10;
    sourceRect.origin.y = 49;
    cell.sourceLabel.frame = sourceRect;
    return cell;
}


-(UITableViewCell*)worldEyeCellWithDataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object{
    
   
    if (path.row == 0) {
        NSString *NewsCellIdentifier = [NSString stringWithFormat:@"worldEyeCellIdentifier"];
        IndexTableViewCell *cell = (IndexTableViewCell*)[view.tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
        if(cell == nil){
            cell = [[[IndexTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //        s=[[OPScrollTestView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
        NSArray *topNewsArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"worldEyeArray111"] retain];
        NSMutableArray *topNewsArray1 = [NSMutableArray array];
        if (topNewsArray && [topNewsArray count] > 0) {
            for (NSDictionary *d in topNewsArray) {
                TopNews *t = [[TopNews alloc] initWithDict:d];
                [topNewsArray1 addObject:t];
            }
            
            
            worldEyeScrollView = [[WorldEyeScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, NEWS_OPSCROLL_VIEW_HIGHT) andSource:topNewsArray1];
            worldEyeScrollView.delegate = self;
            
            [cell.contentView addSubview:worldEyeScrollView];
            [worldEyeScrollView release];
            return cell;
            
            
        }
        
        return cell;
    }
    
    NSString *NewsCellIdentifier = [NSString stringWithFormat:@"worldeyeCellIdentifier111"];
    WorldEyeTableViewCell *cell = (WorldEyeTableViewCell*)[view.tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
    if(cell == nil){
        cell = [[[WorldEyeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    NSString* topString = [object valueForKey:NewsList_top];
    NSString *title = [object valueForKey:NewsList_shorttitle];
    if (!title||[title length]==0) {
        title = [object valueForKey:NewsList_title];
    }
    
 
    if(title){
       
        cell.titleLabel.text = title;
    }
    else {
        cell.titleLabel.text = @"";
    }
     
    UIView* imageView = [cell viewWithTag:333899];
    [imageView removeFromSuperview];
    UIView* labelView = [cell viewWithTag:599988];
    [labelView removeFromSuperview];
    
    BOOL hasRead = [self is_news_has_read:object];
    
    if(!hasRead) {
        cell.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:88/255.0 blue:162/255.0 alpha:1.0];
        cell.detailLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        cell.sourceLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    }
    else {
        cell.titleLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        cell.detailLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        cell.sourceLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    }
    
     
    NSString *dateString = [object valueForKey:NewsIndexList_content];
 
    int wordcount = [self countWord:dateString];
    NSMutableString *detailstr = [NSMutableString string];
     cell.detailLabel.text = [dateString stringByAppendingString:@"..."];
    
   
    NSString* commentsCount = [[object dataDict] objectForKey:@"comment"];
    NSString* conmentsStr = [NSString stringWithFormat:@"评论(%@)",commentsCount];
    cell.sourceLabel.text = conmentsStr;
    [cell.sourceLabel sizeToFit];
    CGRect sourceRect = cell.sourceLabel.bounds;
    sourceRect.origin.x = view.tableView.bounds.size.width - sourceRect.size.width - 10;
    sourceRect.origin.y = 49;
    cell.sourceLabel.frame = sourceRect;
    return cell;
}


#pragma mark -
#pragma mark DataListTableView
-(UITableViewCell*)dataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    if (_isIndexFlag) {
        return [self indexCellWithDataListView:view cellForIndexPath:path object:object];
    }else if (_isWorldEyeFlag) {
        //TODO
        return [self worldEyeCellWithDataListView:view cellForIndexPath:path object:object];
    }
    else {
        return [self newsCellWithDataListView:view cellForIndexPath:path object:object];
    }
}
-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    
    if (_isIndexFlag) {
        if (path.row == 0) {
            return NEWS_OPSCROLL_VIEW_HIGHT;
        }else{
            return 67.0;
        }
    }else if (_isWorldEyeFlag) {
        if (path.row == 0) {
            return NEWS_OPSCROLL_VIEW_HIGHT;
        }else{
            return 67.0;
        }
    }else{
        return 46.0;
    }
    
}

-(void)dataListView:(DataListTableView*)view didSelectedAtIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    NSString *url = [object valueForKey:NewsList_url];
    [[AppDelegate sharedAppDelegate] add_news_to_already_read_array:url];
    [view.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    
    
//    [[AppDelegate sharedAppDelegate].newsReadedDict setValue:@"1" forKey:url];
//    [Util dumpDictionary:[AppDelegate sharedAppDelegate].newsReadedDict];

    
    if (!_isIndexFlag) {
       
        [view.tableView deselectRowAtIndexPath:path animated:YES];
        
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        NSString* urlstring = [object valueForKey:NewsList_url];
        NewsContentViewController2* contentController = [[NewsContentViewController2 alloc] initWithNewsURL2:urlstring];
        NSString* commentsCount = [object valueForKey:NewsList_showcomments];
        contentController.commentCount = commentsCount;
        contentController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contentController animated:YES];
        [contentController release];
    }else  if (!_isWorldEyeFlag) {
        
        [view.tableView deselectRowAtIndexPath:path animated:YES];
        
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        NSString* urlstring = [object valueForKey:NewsList_url];
        NewsContentViewController2* contentController = [[NewsContentViewController2 alloc] initWithNewsURL2:urlstring];
        NSString* commentsCount = [object valueForKey:NewsList_showcomments];
        contentController.commentCount = commentsCount;
        contentController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contentController animated:YES];
        [contentController release];
    }else{
        [view.tableView deselectRowAtIndexPath:path animated:YES];
        
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        NSString* urlstring = [object valueForKey:NewsList_url];
        NewsContentViewController2* contentController = [[NewsContentViewController2 alloc] initWithNewsURL2:urlstring];
        NSString* commentsCount = [object valueForKey:NewsList_showcomments];
        contentController.commentCount = commentsCount;
        contentController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contentController animated:YES];
        [contentController release];
        
    }
}



-(void)dataListViewDidMoreClicked:(DataListTableView*)view
{
    NewsObject* oneObject = [self.dataList lastObjectWithIDList:self.selectID];
    NSString* timeStamp = [oneObject valueForKey:NewsList_timestamp];
    NSArray* curIndexs = [dataList IDListWithNameKeys:self.selectID];
    
    NSTimeInterval interval = [timeStamp doubleValue];
    if (_isIndexFlag) {
//        NSArray* curAPIs = [NSArray arrayWithObjects:@"http://platform.sina.com.cn/client/list?app_key=2872801998&partid=1", nil];
       // http://platform.sina.com.cn/client/list?app_key=3346933778&partid=1&len=2&page=3
        
        NSString *url = [NSString stringWithFormat:news_index_request_url,2,_index_curPage+1];

        NSArray* curAPIs = [NSArray arrayWithObjects:@"http://platform.sina.com.cn/client/list?app_key=3346933778&partid=1", nil];
        [[NewsIndexFuncPuller getInstance] startListWithSender:self page:_index_curPage+1 endTime:interval count:countPerPage withAPICode:curAPIs args:self.selectID dataList:self.indexdataList bInback:NO];
        
    }else if (_isWorldEyeFlag) {
        //        NSArray* curAPIs = [NSArray arrayWithObjects:@"http://platform.sina.com.cn/client/list?app_key=2872801998&partid=1", nil];
//        &lastid=190
        

        NSString *url = [NSString stringWithFormat:news_worldeye_request_url,worldeyeLastId];
        NSLog(@"全球新闻眼 = %@",url);
        NSArray* curAPIs = [NSArray arrayWithObjects:url, nil];
        [[NewsIndexFuncPuller getInstance] startListWithSender:self page:curPage+1 endTime:interval count:countPerPage withAPICode:curAPIs args:self.selectID dataList:self.worldeyedataList bInback:NO];
        
    }else{
        NSArray* curAPIs = [dataList curCommentAPICodeAtRowColumns:curIndexs];
        [[NewsListFuncPuller getInstance] startListWithSender:self page:curPage+1 endTime:interval count:countPerPage withAPICode:curAPIs args:self.selectID dataList:self.dataList bInback:NO];
        
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

-(NSString*)keepTopPrefixStringWithCode:(NSString*)code index:(NSInteger)index
{
    NSString* rtval = @"头条";
    return rtval;
}

#pragma mark -
#pragma mark AdjustOrderView
-(void)view:(AdjustOrderView*)view adjustFinished:(NSArray*)dataArray
{
    [self.mynewsList setOrderArray:dataArray atIndex:0];
    bOrderAdjusting = YES;
    [self.curMultiTabBar reloadData];
    BCTabBar* oneBar = [[self.curMultiTabBar tabBarArray] lastObject];
    [oneBar setSelectedColumn:[oneBar.tabs count] - 1];
    bOrderAdjusting = NO;
}

#pragma mark -OPScrollViewDelegate
-(void)clickWithIndex:(int)curIndex topNews:(TopNews *)topnews  tapCount:(int)tapcount{
    
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:YES];
    NSString* urlstring =  topnews.url;
    NewsContentViewController2* contentController = [[NewsContentViewController2 alloc] initWithNewsURL2:urlstring];
    NSString* commentsCount = topnews.comment;
    contentController.commentCount = commentsCount;
    contentController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:contentController animated:YES];
    [contentController release];
    
}

-(void)handleShowNewsBackPressed:(UIButton *)sender{
    PushViewController* stockBarController = [[PushViewController alloc] init];
    stockBarController.pushType = pushType_xinwen;
    stockBarController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:stockBarController animated:YES];
    [stockBarController release];
}

#pragma mark - Private methods implemetions
/**
 * 判断当前新闻已读，如果已读返回YES。
 */
-(BOOL)is_news_has_read:(NewsObject *)object{
    NSString *url = [object valueForKey:NewsList_url];
    return [[AppDelegate sharedAppDelegate] is_news_has_readed:url];
}

@end
