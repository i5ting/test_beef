//
//  StockBarViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StockBarViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "DataListTableView.h"
#import "DropDownTabBar.h"
#import "gDefines.h"
#import "StockBarPuller.h"
#import "LKTipCenter.h"
#import "DataButton.h"
#import "BarStockListViewController.h"
#import "StockViewDefines.h"
#import "ConfigFileManager.h"
#import "CommentDataList.h"
#import "StockFuncPuller.h"
#import "LoginViewController.h"
#import "ProjectLogUploader.h"

@interface StockBarViewController ()
@property(nonatomic,retain)DataListTableView* dataTableView;
@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)NSMutableArray* selectID;
@property(nonatomic,retain)DropDownTabBar* tabBarView;
@property(nonatomic,retain)NewsObject* configItem;
-(void)handleBackPressed;
- (void)createToolbar;
-(void)initUI;
-(void)initNotification;
-(void)startRefreshTable:(BOOL)bForce;
-(BOOL)checkRefreshByDate;
@end

@implementation StockBarViewController
{
    NewsObject* configItem;
    NSInteger curIndex;
    NSInteger oldIndex;
}
@synthesize dataTableView,dataList,selectID;
@synthesize tabBarView;
@synthesize configItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        countPerPage = 100;
        dataList = [[CommentDataList alloc] init];
        
        CommentDataList* configdataList = [[ConfigFileManager getInstance] stockListConfigDataList];
        NSArray* dataArray = [configdataList contentsWithIDList:nil];
        for (NewsObject* oneObject in dataArray) {
            NSString* type = [oneObject valueForKey:Stockitem_type];
            if (type&&[type isEqualToString:Value_Stockitem_type_myGroup]) {
                self.configItem = oneObject; //自选股的配置信息
                break;
            }
        }
    }
    return self;
}

-(void)dealloc
{
    [dataTableView release];
    [dataList release];
    [selectID release];
    [tabBarView release];
    [configItem release];
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
    
    [self createToolbar];
    [self initUI];
    if (!bInited) {
        bInited = YES;
        [self initNotification];
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

- (void)createToolbar
{
    MyCustomToolbar* topToolBar = [[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    [topToolBar release];
    
    topToolBar.title = @"股吧";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:backBtn];
    
    UIButton *refreshBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(280, 10, 25, 23);
    [refreshBtn setImage:[UIImage imageNamed:@"refresh_btn.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(handleRefreshPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:refreshBtn];
}

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self 
           selector:@selector(StockBarObjectAdded:) 
               name:StockBarObjectAddedNotification 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(StockBarObjectFailed:) 
               name:StockBarObjectFailedNotification
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(StockBarObjectAdded:) 
               name:StockObjectAddedNotification 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(StockBarObjectFailed:) 
               name:StockObjectFailedNotification
             object:nil];
    
    
}

-(void)initUI
{
    NSInteger tabBarheight = 30;
    if (!tabBarView) {
        tabBarView = [[DropDownTabBar alloc] initWithFrame:CGRectMake(0, 44, 320, tabBarheight)];
        tabBarView.delegate = self;
        tabBarView.backgroundColor = [UIColor colorWithRed:1/255.0 green:20/255.0 blue:61/255.0 alpha:1.0];
        tabBarView.hasDropDown = NO;
        tabBarView.spacer = 0;
        tabBarView.padding = 0.0;
    }
    else
    {
        tabBarView.frame = CGRectMake(0, 44, 320, tabBarheight);
    }
    [self.view addSubview:tabBarView];
    
    int curY = 44 + tabBarheight;
    int maxHeight = self.view.bounds.size.height - curY;
    if (!self.dataTableView) {
        DataListTableView* dataView = [[DataListTableView alloc] initWithFrame:CGRectMake(0, curY, 320, maxHeight)];
        dataView.defaultSucBackString = @"";
        dataView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        dataView.delegate = self;
        dataView.tableView.backgroundColor = [UIColor colorWithRed:0/255.0 green:36/255.0 blue:58/255.0 alpha:1.0];
        dataView.selectID = selectID;
        dataView.dataList = dataList;
        dataView.backLabel.textColor = [UIColor whiteColor];
        dataView.hasPageMode = NO;
        self.dataTableView = dataView;
        [dataView release];
    }
    else
    {
        self.dataTableView.frame = CGRectMake(0, curY, 320, maxHeight);
    }
    [self.view addSubview:self.dataTableView];
    
    UIView* oldShadowView = [self.view viewWithTag:133289];
    [oldShadowView removeFromSuperview];
    UIImage* tabShadowImage = [UIImage imageNamed:@"news_stockbar_list_bar_shadow.png"];
    UIImageView* tabShadowImageView = [[UIImageView alloc] initWithImage:tabShadowImage];
    tabShadowImageView.frame = CGRectMake(0, curY, 320, 13);
    tabShadowImageView.tag = 133289;
    [self.view addSubview:tabShadowImageView];
    [tabShadowImageView release];
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
    
    if (needRefresh&&[self.selectID count]>0) {
        [self.dataTableView startLoadingUI];
        
        NSString* curIndexString = [self.selectID objectAtIndex:0];
        NSString* firstTitle = [self.tabBarView titleForIndex:0];
        if ([curIndexString isEqualToString:firstTitle]) {
            [[StockBarPuller getInstance] startHotBarListWithSender:self count:countPerPage page:1 args:self.selectID dataList:self.dataList];
        }
        else {
            NSArray* groupRequstTypes = (NSArray*)[self.configItem valueForKey:Stockitem_grouprequst_type];
            NSString* service = nil;
            if (0<[groupRequstTypes count]) {
                service = [groupRequstTypes objectAtIndex:0];
            }
            NSDictionary* commandDict = (NSDictionary*)[self.configItem valueForKey:Stockitem_layout_request_command];
            NSString* command = [commandDict valueForKey:Stockitem_layout_request_command_list];
            [[StockFuncPuller getInstance] startMyGroupListWithSender:self service:service command:command args:self.selectID dataList:nil seperateRequst:NO userInfo:nil];
        }
    }
    else
    {
        [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
    }
}

#pragma mark -
#pragma mark BtnPressed
-(void)handleBackPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handleRefreshPressed
{
    [self startRefreshTable:YES];
}

-(void)cellBtnClicked:(DataButton*)sender
{
    if (sender.data) {
        NewsObject* oneObject = (NewsObject*)sender.data;
        BarStockListViewController* stockController = [[BarStockListViewController alloc] init];
        NSString* nameString = [oneObject valueForKey:StockBar_HotBarList_name];
        stockController.stockName = nameString;
        NSString* nickString = [oneObject valueForKey:StockBar_HotBarList_nick];
        stockController.stockNick = nickString;
        NSString* bid = [oneObject valueForKey:StockBar_HotBarList_bid];
        stockController.bid = bid;
        [self.navigationController pushViewController:stockController animated:YES];
        [stockController release];
    }
}

#pragma mark -
#pragma mark networkCallback
-(void)StockBarObjectAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_HotBarList) {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSArray* array = [userInfo valueForKey:RequsetArray];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                curPage = [pageNumber intValue];
                if ([pageNumber intValue]<=1) {
                    [self.dataTableView scrollTop:NO];
                }
                if ([array count]>=countPerPage) {
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
                }
                else {
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:YES];
                }
            }
        }
        else if([stageNumber intValue]==Stage_Request_ObtainMyGroupList)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID])
            {
                NSArray* array = [userInfo valueForKey:RequsetArray];
                NSMutableArray* symbolArray = [NSMutableArray arrayWithCapacity:0];
                for (int i=0; i<[array count]; i++) {
                    NewsObject* oldObject = [array objectAtIndex:i];
                    NSArray* oldSymbolArray = (NSArray*)[oldObject valueForKey:StockFunc_GroupInfo_symbols];
                    for (NSString* oneSymbol in oldSymbolArray){
                        if (![symbolArray containsObject:oneSymbol]) {
                            [symbolArray addObject:oneSymbol];
                        }
                    }
                    
                }
                NSString* symbols = [symbolArray componentsJoinedByString:@","];
                [[StockFuncPuller getInstance] startMultiStockInfoWithSender:self symbol:symbols args:args dataList:nil userInfo:nil];
            }
        }
        else if([stageNumber intValue]==Stage_Request_MultiStockInfo)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID])
            {
                NSArray* array = [userInfo valueForKey:RequsetArray];
                
                NSMutableArray* newArray = [NSMutableArray arrayWithCapacity:0];
                for (NewsObject* oneObject in array) {
                    NSString* oneSymbolStr = [oneObject valueForKey:StockFunc_OneStock_symbol];
                    NSString* oneNick = [oneObject valueForKey:StockFunc_OneStock_name];
                    NewsObject* newObject = [[NewsObject alloc] init];
                    NSMutableDictionary* mutableDict = [newObject mutableNewsData];
                    [mutableDict setValue:oneSymbolStr forKey:StockBar_HotBarList_name];
                    [mutableDict setValue:oneNick forKey:StockBar_HotBarList_nick];
                    [newArray addObject:newObject];
                    [newObject release];
                }
                [self.dataList refreshCommnetContents:newArray IDList:args];
                
                [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:YES];
            }
            
        }
    }
}

-(void)StockBarObjectFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if([stageNumber intValue]==Stage_Request_HotBarList)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID])
            {
                [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
            }
        }
        else if([stageNumber intValue]==Stage_Request_ObtainMyGroupList)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID])
            {
                [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
            }
        }
        else if([stageNumber intValue]==Stage_Request_MultiStockInfo)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID])
            {
                [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
            }
            
        }
    }
}

#pragma mark -
#pragma mark DropDownTabBarDelegate
-(NSArray*)tabsWithTabBar:(DropDownTabBar*)tabBar
{
    NSArray* titleArray =[NSArray arrayWithObjects:@"今日热门股吧",@"我的自选股吧", nil];
    NSMutableArray* rtval = nil;
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
    return rtval;
}

-(void)refreshCurTabBar
{
    [self tabBar:self.tabBarView clickedWithIndex:curIndex byBtn:NO];
}

-(void)tabBar:(DropDownTabBar*)tabBar clickedWithIndex:(NSInteger)index byBtn:(BOOL)byBtn
{
    curIndex = index;
    if(index>0)
    {
        if (byBtn) {
            [[ProjectLogUploader getInstance] writeDataString:@"my_shares"];
        }
        
        BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
        if (hasLogined) {
            if (oldIndex!=index) {
                oldIndex = index;
                NSMutableArray* curSelectID = [[NSMutableArray alloc] initWithCapacity:0];
                NSString* titleString = [tabBar titleForIndex:index];
                [curSelectID addObject:titleString];
                BOOL bSameSelectedID = [CommentDataList checkNumberArrayEqualWithFirstArray:self.selectID secondArray:curSelectID];
                self.selectID = curSelectID;
                [curSelectID release];
                if (byBtn&&bSameSelectedID) {
                    [self startRefreshTable:YES];
                }
                else {
                    [self startRefreshTable:NO];
                }
            }
        }
        else
        {
            LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginController.delegate = self;
            loginController.succeedSelector = @selector(refreshCurTabBar);
            loginController.returnSelector = @selector(loginReturned);
            [self.navigationController pushViewController:loginController animated:YES];
            [loginController release];
        }
    }
    else {
        oldIndex = index;
        NSMutableArray* curSelectID = [[NSMutableArray alloc] initWithCapacity:0];
        NSString* titleString = [tabBar titleForIndex:index];
        [curSelectID addObject:titleString];
        BOOL bSameSelectedID = [CommentDataList checkNumberArrayEqualWithFirstArray:self.selectID secondArray:curSelectID];
        self.selectID = curSelectID;
        [curSelectID release];
        if (byBtn&&bSameSelectedID) {
            [self startRefreshTable:YES];
        }
        else {
            [self startRefreshTable:NO];
        }
    }
    
}

-(void)loginReturned
{
    [self.tabBarView setCurIndex:oldIndex];
}

#pragma mark -
#pragma mark DataListTableView
-(UITableViewCell*)dataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    int rowNum = path.row;
    UITableViewCell* rtval = nil;
    NSString* userIdentifier = @"Identifier";
    rtval = (UITableViewCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!rtval) {
        rtval = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
        rtval.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView* backView1 = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)] autorelease];
        backView1.tag = 10000;
        [rtval addSubview:backView1];
        
        UIView* backView2 = [[[UIView alloc] initWithFrame:CGRectMake(160, 0, 160, 40)] autorelease];
        backView2.tag = 10001;
        [rtval addSubview:backView2];
        
        
        UIImageView* imageView1 = [[UIImageView alloc] init];
        imageView1.frame = CGRectMake(10, 12, 31, 16);
        imageView1.tag = 333898;
        [backView1 addSubview:imageView1];
        [imageView1 release];
        
        UIImageView* imageView2 = [[UIImageView alloc] init];
        imageView2.tag = 333899;
        imageView2.frame = CGRectMake(10, 12, 31, 16);
        [backView2 addSubview:imageView2];
        [imageView2 release];
        
        UILabel* avatorLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 31, 16)];
        avatorLabel1.textColor = [UIColor whiteColor];
        avatorLabel1.tag = 599988;
        avatorLabel1.backgroundColor = [UIColor clearColor];
        avatorLabel1.textAlignment = UITextAlignmentCenter;
        [backView1 addSubview:avatorLabel1];
        [avatorLabel1 release];
        
        UILabel* avatorLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 31, 16)];
        avatorLabel2.textColor = [UIColor whiteColor];
        avatorLabel2.tag = 599989;
        avatorLabel2.backgroundColor = [UIColor clearColor];
        avatorLabel2.textAlignment = UITextAlignmentCenter;
        [backView2 addSubview:avatorLabel2];
        [avatorLabel2 release];
        
        UILabel* label1 = [[UILabel alloc] init];
        label1.backgroundColor = [UIColor clearColor];
        label1.tag = 11111;
        label1.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
        label1.frame = CGRectMake(46, 0, 114, 40);
        [backView1 addSubview:label1];
        [label1 release];
        
        UILabel* label2 = [[UILabel alloc] init];
        label2.backgroundColor = [UIColor clearColor];
        label2.tag = 11112;
        label2.textColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1.0];
        label2.frame = CGRectMake(46, 0, 114, 40);
        [backView2 addSubview:label2];
        [label2 release];
        
        DataButton* dataBtn1 = [[DataButton alloc] init];
        dataBtn1.backgroundColor = [UIColor clearColor];
        dataBtn1.frame = CGRectMake(0, 0, 160, 40);
        dataBtn1.tag = 222211;
        [dataBtn1 addTarget:self action:@selector(cellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backView1 addSubview:dataBtn1];
        [dataBtn1 release];
        
        DataButton* dataBtn2 = [[DataButton alloc] init];
        dataBtn2.backgroundColor = [UIColor clearColor];
        dataBtn2.frame = CGRectMake(0, 0, 160, 40);
        dataBtn2.tag = 222212;
        [dataBtn2 addTarget:self action:@selector(cellBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [backView2 addSubview:dataBtn2];
        [dataBtn2 release];
    }
    UIView* backView1 =  (UILabel*)[rtval viewWithTag:10000];
    UIView* backView2 =  (UILabel*)[rtval viewWithTag:10001];
    UILabel* label1 =  (UILabel*)[backView1 viewWithTag:11111];
    UILabel* label2 =  (UILabel*)[backView2 viewWithTag:11112];
    DataButton* dataBtn1 =  (DataButton*)[backView1 viewWithTag:222211];
    DataButton* dataBtn2 =  (DataButton*)[backView2 viewWithTag:222212];
    UIImageView* imageView1 = (UIImageView*)[backView1 viewWithTag:333898];
    UIImageView* imageView2 = (UIImageView*)[backView2 viewWithTag:333899];
    UILabel* avatorLabel1 = (UILabel*)[backView1 viewWithTag:599988];
    UILabel* avatorLabel2 = (UILabel*)[backView2 viewWithTag:599989];
    
    NSInteger rowInt = path.row;
    if (rowInt<5) {
        UIImage* imageblue = [UIImage imageNamed:@"news_stockbar_list_cellavator_blue.png"];
        imageView1.image = imageblue;
        imageView2.image = imageblue;
    }
    else {
        UIImage* imagegray = [UIImage imageNamed:@"news_stockbar_list_cellavator_gray.png"];
        imageView1.image = imagegray;
        imageView2.image = imagegray;
    }
    
    NSString* avatorStr1 = [NSString stringWithFormat:@"%d",rowInt*2+1];
    avatorLabel1.text = avatorStr1;
    NSString* avatorStr2 = [NSString stringWithFormat:@"%d",rowInt*2+1+1];
    avatorLabel2.text = avatorStr2;
    
    NewsObject* object1 = [view.dataList oneObjectWithIndex:rowInt*2 IDList:view.selectID];
    dataBtn1.data = object1;
    NewsObject* object2 = [view.dataList oneObjectWithIndex:(rowInt*2 +1) IDList:view.selectID];
    dataBtn2.data = object2;
    label1.text = [object1 valueForKey:StockBar_HotBarList_nick];
    label2.text = [object2 valueForKey:StockBar_HotBarList_nick];
    if (object1) {
        backView1.hidden = NO;
    }
    else {
        backView1.hidden = YES;
    }
    if (object2) {
        backView2.hidden = NO;
    }
    else {
        backView2.hidden = YES;
    }
    
    if (rowNum%2==0) {
        rtval.contentView.backgroundColor = [UIColor colorWithRed:2/255.0 green:29/255.0 blue:81/255.0 alpha:1.0];
    }
    else {
        rtval.contentView.backgroundColor = [UIColor colorWithRed:16/255.0 green:53/255.0 blue:111/255.0 alpha:1.0];
    }
    return rtval;
}

-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    return 40;
}

-(NSInteger)dataListView:(DataListTableView*)view numberOfRowsInSection:(NSInteger)section
{
    NSArray* objects = [view.dataList contentsWithIDList:view.selectID];
    int countA = [objects count]/2;
    int countB = [objects count]%2;
    int count = countA + (countB>0?1:0);
    return count;
}

-(void)dataListView:(DataListTableView*)view didSelectedAtIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    //    [view.tableView deselectRowAtIndexPath:path animated:YES];
    
}

-(void)dataListViewDidMoreClicked:(DataListTableView*)view
{
    [[StockBarPuller getInstance] startHotBarListWithSender:self count:countPerPage page:curPage+1 args:self.selectID dataList:self.dataList];
}
-(void)dataListViewDidRefreshTriggered:(DataListTableView*)view
{
    [self startRefreshTable:YES];
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
