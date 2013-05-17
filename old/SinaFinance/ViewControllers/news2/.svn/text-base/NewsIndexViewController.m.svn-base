//
//  NewsViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OPScrollView.h"
#import "CommentDataList.h"
#import "NewsIndexViewController.h"
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

#import "NewsIndexFuncPuller.h"

#define Save_TitleSelectedIndexs @"Save_TitleSelectedIndexs"
#define Save_NavOffset @"Save_NavOffset"
#define NewsHasReadKey @"NewsHasReadKey"

@interface NewsIndexViewController ()
@property (nonatomic, retain) CommentDataList* dataList;
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



-(void)initNotification;
-(BOOL)checkRefreshByDate;
-(void)startRefreshTableWithForce;
-(void)startRefreshTable:(BOOL)bForce;
-(void)postFailedTip;
@end

@implementation NewsIndexViewController
{
    CommentDataList* mynewsList;
    AdjustOrderView* adjustOrderView;
    BOOL bOrderAdjusting;
    NSInteger curPage;
    NSInteger countPerPage;
}
@synthesize dataList;
@synthesize flowController;
@synthesize selectID;
@synthesize dataTableView,indexdataTableView;
@synthesize mynewsList;
@synthesize adjustOrderView;
@synthesize curMultiTabBar;
@synthesize titleBtn;
@synthesize refreshBtn;

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"新闻";
        self.tabBarItem.image = [UIImage imageNamed:@"news_icon.png"];
        dataList = [[CommentDataList alloc] initWithFileName:@"news.json"];
        mynewsList = [[CommentDataList alloc] initWithFileName:@"mynews1.json"];
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
    
}

- (void)initToolbar
{
  
    self.selectID = [NSArray arrayWithObjects:@"news",@"index", nil];
    int curY = 0;
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
}

-(void)titleDropBtnClicked:(TitleDropButton*)sender
{
    BOOL oldSelected = sender.selected;
    sender.selected = !oldSelected;
    FlowListViewController* newFlowController = [[FlowListViewController alloc] initWithSelectedIndex:0];
    newFlowController.delegate = self;
    newFlowController.selectedIndex = curTitleIndex;
    NSArray* nameArray = [self.dataList subCommentNamelistAtRowColumns:nil];
    NSArray* mynewsArray = [self.mynewsList subCommentNamelistAtRowColumns:nil];
    NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:0];
    [newArray addObjectsFromArray:nameArray];
    [newArray addObjectsFromArray:mynewsArray];
    newFlowController.listNames = newArray;
    [newArray release];
    self.flowController = newFlowController;
    [newFlowController show:CGPointMake(160, 43) boxSize:CGSizeMake(120, 250)];
    [newFlowController release];
}

-(void)CommonListSucceed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSArray* args = [userInfo valueForKey:RequsetArgs];
        NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
        NSArray* array = [userInfo valueForKey:RequsetArray];
        if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
            CommentDataList* tempList = [[CommentDataList alloc] init];
            [tempList refreshCommnetContents:array IDList:self.selectID];
            self.dataTableView.dataList = tempList;
            self.dataTableView.selectID = self.selectID;
            if ([pageNumber intValue]<=1) {
                [self.dataTableView scrollTop:NO];
            }
            BOOL pageEnd = [self.dataList pageEndInfoWithIDList:self.selectID];
            
            if (!pageEnd) {
                [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
            }
            else {
                [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:YES];
            }
            
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
    NSArray* nameArray = [self.dataList subCommentNamelistAtRowColumns:nil];
    NSArray* myNewsArray = [self.mynewsList subCommentNamelistAtRowColumns:nil];
    NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:0];
    [newArray addObjectsFromArray:nameArray];
    [newArray addObjectsFromArray:myNewsArray];
    titleBtn.titleString = [newArray objectAtIndex:index];
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
        [newArray addObject:@"+添加栏目"];
        tempArray = newArray;
        bUseMyList = YES;
        [columns release];
    }
    
    if (index.row==0) {
        if (tempArray) {
            for(int i=0;i<[tempArray count];i++) {
                BCTab* oneTab = [[BCTab alloc] init];
                oneTab.nameLabel.text = [tempArray objectAtIndex:i];
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
    if (!bOrderAdjusting) {
        NSArray* constArray = [self.dataList subCommentNamelistAtRowColumns:nil];
        int realIndex = 0;
        BOOL bUseMyList = NO;
        CommentDataList* usedDataList = nil;
        if ([constArray count]>curTitleIndex) {
            realIndex = curTitleIndex;
            usedDataList = dataList;
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

-(void)addProjectLog
{
    NSString* key = [self.selectID objectAtIndex:1];
    if ([key isEqualToString:@"index"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"news"];
    }
    else if ([key isEqualToString:@"review"]) {
        [[ProjectLogUploader getInstance] writeDataString:@"comment"];
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
    [self.dataTableView scrollTop:NO];
    BOOL pageEnd = [self.dataList pageEndInfoWithIDList:self.selectID];
    if(pageEnd) {
        [self.dataTableView setPageMode:PageCellType_Ending];
    }
    else {
        [self.dataTableView setPageMode:PageCellType_Normal];
    }
    [self.dataTableView reloadData];
    
    if (needRefresh) {
        [self.dataTableView startLoadingUI];
        NSArray* curIndexs = [dataList IDListWithNameKeys:self.selectID];
//        NSArray* curAPIs = [dataList curCommentAPICodeAtRowColumns:curIndexs];
//        http://platform.sina.com.cn/clien/list?app_key=2872801998&partid=1&page=1
        
        NSArray* curAPIs = [NSArray arrayWithObjects:@"http://platform.sina.com.cn/clien/list?app_key=2872801998&partid=1&page=1", nil];
        [[NewsIndexFuncPuller getInstance] startListWithSender:self page:1 endTime:0 count:countPerPage withAPICode:curAPIs args:self.selectID dataList:self.dataList bInback:NO];
    }
    else
    {
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
            
            
           OPScrollView *s = [[OPScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, NEWS_OPSCROLL_VIEW_HIGHT) andSource:topNewsArray1];
            s.delegate = self;
            
            [cell.contentView addSubview:s];
            [s release];
            return cell;
            
            
        }
        
        return cell;
    }
    
    NSString *NewsCellIdentifier = [NSString stringWithFormat:@"indexCellIdentifier2"];
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
    
    //    NSString* code = [view.selectID objectAtIndex:1];
    //    UIImageView* keepTopImageView = (UIImageView*)[cell viewWithTag:1111878];
    //    [keepTopImageView removeFromSuperview];
    //    if ([topString intValue]>0) {
    //        title = [NSString stringWithFormat:@"           %@",title];
    //        UIImage* keepTopImage = [UIImage imageNamed:@"news_list_cell_keeptop.png"];
    //        UIImageView* keepTopImageView = [[UIImageView alloc] initWithImage:keepTopImage];
    //        CGRect prefixRect = CGRectMake(15, 2, 42, 22);
    //        keepTopImageView.frame = prefixRect;
    //        keepTopImageView.tag = 1111878;
    //        [cell addSubview:keepTopImageView];
    //        [keepTopImageView release];
    //
    //        UILabel* tempLabel = [[UILabel alloc] initWithFrame:keepTopImageView.bounds];
    //        tempLabel.backgroundColor = [UIColor clearColor];
    //        tempLabel.textColor = [UIColor whiteColor];
    //        tempLabel.font = [UIFont systemFontOfSize:13.0];
    //        tempLabel.textAlignment = UITextAlignmentCenter;
    //        [keepTopImageView addSubview:tempLabel];
    //        NSString* keepTopStr = [self keepTopPrefixStringWithCode:code index:path.row];
    //        tempLabel.text = keepTopStr;
    //        [keepTopStr release];
    //    }
    //
    if(title){
        cell.titleLabel.text = title;
    }
    else {
        cell.titleLabel.text = @"";
    }
    
    //    NSNumber* hasRead = [object userInfoValueForKey:NewsHasReadKey];
    //    BOOL bTopColumn = NO;
    //    if ([view.selectID count]>=2) {
    //        if ([code isEqualToString:@"top"]) {
    //            bTopColumn = YES;
    //        }
    //    }
    
    UIView* imageView = [cell viewWithTag:333899];
    [imageView removeFromSuperview];
    UIView* labelView = [cell viewWithTag:599988];
    [labelView removeFromSuperview];
    //    if (!bTopColumn) {
    //        cell.leftrightMargin = 5.0;
    //        if(!hasRead||![hasRead boolValue]){
    //            cell.readIcon.hidden = YES;
    //        }
    //        else{
    //            cell.readIcon.hidden = YES;
    //        }
    //    }
    //    else {
    //        cell.leftrightMargin = 25.0;
    ////        cell.readIcon.hidden = YES;
    ////        UIImageView* imageView1 = [[UIImageView alloc] init];
    ////        imageView1.tag = 333899;
    ////        imageView1.frame = CGRectMake(5, 4, 25, 16);
    ////        [cell addSubview:imageView1];
    ////        [imageView1 release];
    ////        if (path.row<3) {
    ////            UIImage* imageblue = [UIImage imageNamed:@"news_stockbar_list_cellavator_blue.png"];
    ////            imageView1.image = imageblue;
    ////        }
    ////        else {
    ////            UIImage* imagegray = [UIImage imageNamed:@"news_stockbar_list_cellavator_gray.png"];
    ////            imageView1.image = imagegray;
    ////        }
    //
    //        UILabel* avatorLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, 25, 16)];
    //        avatorLabel1.textColor = [UIColor whiteColor];
    //        avatorLabel1.tag = 599988;
    //        avatorLabel1.backgroundColor = [UIColor clearColor];
    //        avatorLabel1.textAlignment = UITextAlignmentCenter;
    //        [cell addSubview:avatorLabel1];
    //        [avatorLabel1 release];
    //        avatorLabel1.text = [NSString stringWithFormat:@"%d",path.row+1];
    //    }
    
    cell.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:88/255.0 blue:162/255.0 alpha:1.0];
    cell.detailLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    cell.sourceLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    
    //    if(!hasRead||![hasRead boolValue]) {
    //        if ([topString intValue]>0) {
    ////            cell.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:61/255.0 blue:113/255.0 alpha:1.0];
    ////            cell.detailLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    ////            cell.sourceLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    //        }
    //        else {
    //
    //        }
    //    }
    //    else {
    ////        cell.titleLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    ////        cell.detailLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    ////        cell.sourceLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    //    }
    NSString *dateString = [object valueForKey:NewsIndexList_content];
    //    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    //	[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
    //    [formatter setDateFormat:[NSString stringWithString:@"EEE, dd MMM yyyy HH:mm:ss z"]];
    //    NSDate* formatDate = [formatter dateFromString:dateString];
    //    [formatter setLocale:[NSLocale currentLocale]];
    //    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSString* formatnDateString = [formatter stringFromDate:formatDate];
    
    cell.detailLabel.text = dateString;
    
    //    if ([view.selectID count]>=2) {
    //        if ([[code lowercaseString] isEqualToString:@"deep"]) {
    //            NSString* media = [object valueForKey:NewsList_media];
    //            cell.detailLabel.text = media;
    //        }
    //    }
    
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

-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    if (path.row == 0) {
        return NEWS_OPSCROLL_VIEW_HIGHT;
    }else{
        return 67.0;
    }
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

-(void)dataListViewDidMoreClicked:(DataListTableView*)view
{
    NewsObject* oneObject = [self.dataList lastObjectWithIDList:self.selectID];
    NSString* timeStamp = [oneObject valueForKey:NewsList_timestamp];
    NSArray* curIndexs = [dataList IDListWithNameKeys:self.selectID];
    NSArray* curAPIs = [dataList curCommentAPICodeAtRowColumns:curIndexs];
    NSTimeInterval interval = [timeStamp doubleValue];
    [[NewsListFuncPuller getInstance] startListWithSender:self page:curPage+1 endTime:interval count:countPerPage withAPICode:curAPIs args:self.selectID dataList:self.dataList bInback:NO];
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

@end
