//
//  HQViewController.m
//  SinaFinance
//
//  Created by sang on 12/18/12.
//
// 

#import "HQViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "ItemPageView.h"
#import "CommentDataList.h"
#import "LoginViewController.h"
#import "StockListViewController2.h"
#import "StockBarViewController.h"
#import "JSONKit.h"
#import "StockViewDefines.h"
#import "ConfigFileManager.h"
#import "MyStockGroupView.h"
#import "MyTabBarController.h"
#import "AppDelegate.h"
#import "StockFuncPuller.h"
#import "DataListTableView.h"
#import "LKTipCenter.h"
#import "SingleStockViewController.h"
#import "ProjectLogUploader.h"
#import "RegValueSaver.h"
#import "gDefines.h"
#import "OPCustomKeyboard.h"
#import "NewsContentViewController2.h"

@interface HQViewController ()
@property(nonatomic,retain)DataListTableView* dataTableView;
@property(nonatomic,retain)NSMutableArray* selectID;
@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)UISearchBar* curSearchBar;
@property(nonatomic,retain)UIView* hotView;
@property(nonatomic,retain)ItemPageView* itemPageView;
@property(nonatomic,retain)UITextField* addStockField;
@property(nonatomic,retain)NSArray* suggestArray;
@property(nonatomic,retain)MyStockGroupView *suggestView;
@property(nonatomic,retain)CommentDataList* configDataList;
/**
 * 增加到我的自选
 * 2012-09-20 sang
 */
@property(nonatomic,retain)MyStockGroupView *mygroupView;
/**
 * 读取配置信息
 * 2012-09-20 sang
 */
@property(nonatomic,retain)NSDictionary *listConfigDict;
/**
 * 获取我的组
 * 2012-09-20 sang
 */
@property(nonatomic,retain)NSArray* mygroupArray;
/**
 * 是newsObject的属性
 * 2012-09-20 sang
 */
@property(nonatomic,retain)NSString *subType,*stockType,*stockSymbol;

-(void)initNavBar;
-(void)initData;
@end

@implementation HQViewController
{
    DataListTableView* dataTableView;
    NSMutableArray* selectID;
    CommentDataList* dataList;
    UISearchBar* curSearchBar;
    UIView* hotView;
    NSInteger bInited;
    NSInteger curIndex;
    NSInteger curViewIndex;
    NSInteger curPage;
    NSInteger countPerPage;
    ItemPageView* itemPageView;
    UITextField* addStockField;
    NSArray* suggestArray;
    MyStockGroupView *suggestView,*mygroupView;
    NSDictionary *listConfigDict;
    NSArray* mygroupArray;
    NSString *subType,*stockType,*stockSymbol;
    /**
     * 由于此视图有2个groupview，此阀值用于区分是哪个
     * 2012-09-20 sang
     */
    SearchViewControllerGroupViewType _groupViewType;
}
@synthesize dataTableView;
@synthesize selectID,dataList;
@synthesize curSearchBar;
@synthesize hotView;
@synthesize itemPageView;
@synthesize addStockField;
@synthesize suggestArray;
@synthesize suggestView;
@synthesize configDataList;
@synthesize mygroupView;
@synthesize listConfigDict;
@synthesize mygroupArray;
@synthesize subType,stockType,stockSymbol;

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


- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"行情";
        self.tabBarItem.image = [UIImage imageNamed:@"stock_icon.png"];
        itemPageView = [[ItemPageView alloc] init];
        self.itemPageView.delegate = self;
        self.itemPageView.countPerPage = 9;
        self.itemPageView.sizePerItem = CGSizeMake(58, 80);
        self.itemPageView.sameSapcer = NO;
        self.itemPageView.hasPageControll = YES;
        self.itemPageView.paddingSize = CGSizeMake(30, 30);
        self.itemPageView.backImageView.backgroundColor = [UIColor whiteColor];
        [self initData];
        selectID = [[NSMutableArray alloc] initWithCapacity:0];
        dataList = [[CommentDataList alloc] init];
        countPerPage = 20;
        _groupViewType = GroupViewType_Search;
        
               
        
    }
    return self;
}

-(void)show{
    
    //        CommentDataList *configDataList = [[ConfigFileManager getInstance] singleStockConfigDataList];
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
    
    NewsObject* oneObject = [self.configDataList oneObjectWithIndex:0 IDList:nil];
    
    
    NSString* needLoginString = [oneObject valueForKey:Stockitem_needlogin];
    BOOL needLogin = NO;
    BOOL hasLogin = [[WeiboLoginManager getInstance] hasLogined];
    if (needLoginString&&[needLoginString intValue]>0) {
        if (!hasLogin) {
            needLogin = YES;
        }
    }
    
    if (needLogin) {
        
        
        StockListViewController2* stockController = [[StockListViewController2 alloc] initWithItem:oneObject];
        
        stockController.isMystockDefaultView = YES;
        stockController.isMyStockType = YES;
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationTransitionNone];
        [UIView setAnimationDuration:0.0000075];
        [self.navigationController pushViewController:stockController animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
        
        
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        LoginViewController* userLoginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        userLoginController.delegate = self;
        userLoginController.loginMode = LoginMode_Stock;
        userLoginController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userLoginController animated:YES];
        [userLoginController release];
    }
    else {
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:NO];
        NSString* specialClass = [oneObject valueForKey:Stockitem_specilclass];
        if (specialClass&&[specialClass intValue]>0) {
            StockBarViewController* stockBarController = [[StockBarViewController alloc] init];
            stockBarController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:stockBarController animated:NO];
            [stockBarController release];
        }
        else {
            
         
            
            
                StockListViewController2* stockController = [[StockListViewController2 alloc] initWithItem:oneObject];
                
                 
                [UIView  beginAnimations:nil context:NULL];
                [UIView setAnimationCurve:UIViewAnimationTransitionNone];
                [UIView setAnimationDuration:0.0000075];
                [self.navigationController pushViewController:stockController animated:NO];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                [UIView commitAnimations];
    //            [nextView release];
    //            
                
                stockController.hidesBottomBarWhenPushed = YES;
                stockController.isMyStockType = YES;
    //            [self.navigationController pushViewController:stockController animated:NO];
                [stockController release];
                    
               
        }
    }

}

-(void)dealloc
{
    [dataTableView release];
    [selectID release];
    [dataList release];
    [curSearchBar release];
    [hotView release];
    [itemPageView release];
    [addStockField release];
    [suggestArray release];
    [suggestView release];
    [configDataList release];
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

-(void)reload{
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:NO];
    
    [self show];
    
    [super viewDidLoad];
    [self initConfigData];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:NO];
    [self show];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initConfigData];
    self.navigationController.navigationBarHidden = YES;
//    
//    [self createToolbar];
//    [self initData];
////    [self initUI];
//    if (!bInited) {
//        bInited = YES;
//        [self initNotification];
//    }
//    
//    [self show];
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

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate{
    //     if([ShareData sharedManager].isStockItemView && [ShareData sharedManager].viewIsLoading == NO){
    //         return YES;
    //     }else{
    return YES;
    //     }
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

-(void)createToolbar
{
    MyCustomToolbar *topToolBar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    [self.view addSubview:topToolBar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(110, 0, 100, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    titleLabel.text = @"行情";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolBar addSubview:titleLabel];
    
    UIImageView *logo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sina_logo.png"]] autorelease];
    logo.frame = CGRectMake(15, 8, 38, 27);
    logo.contentMode = UIViewContentModeScaleToFill;
    [topToolBar addSubview:logo];
    
}

-(void)initData
{
    if (!self.configDataList) {
        self.configDataList = [[ConfigFileManager getInstance] stockListConfigDataList];
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
}

-(void)initUI
{
    NSInteger curY = 44;
    if(!curSearchBar)
    {
        curSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, curY, 320, 44)];
        curSearchBar.delegate = self;
        curSearchBar.autocapitalizationType = NO;
        curSearchBar.autocorrectionType = NO;
        if ([curSearchBar respondsToSelector:@selector(setSpellCheckingType:)]) {
            curSearchBar.spellCheckingType = UITextSpellCheckingTypeNo;
        }
        curSearchBar.placeholder = @"股票名称/代码";
        for (UITextField* textFiled in curSearchBar.subviews) {
            if ([textFiled isKindOfClass:[UITextField class]]) {
                self.addStockField = textFiled;
                self.addStockField.delegate = self;
                break;
            }
        }
    }
    else {
        curSearchBar.frame = CGRectMake(0, curY, 320, 44);
    }
    [self.view addSubview:curSearchBar];
    
    curY += 44;
    
    int maxHeight = self.view.bounds.size.height - curY;
    if (!self.dataTableView) {
        DataListTableView* dataView = [[DataListTableView alloc] initWithFrame:CGRectMake(0, curY, 320, maxHeight)];
        dataView.defaultSucBackString = @"";
        dataView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        dataView.backLabel.textColor = [UIColor blackColor];
        dataView.delegate = self;
        dataView.tableView.backgroundColor = [UIColor whiteColor];
        dataView.selectID = selectID;
        dataView.dataList = dataList;
        dataView.hasHeaderMode = NO;
        dataView.hasPageMode = NO;
        dataView.defaultSucBackString = @"";
        self.dataTableView = dataView;
        [dataView release];
    }
    else
    {
        self.dataTableView.frame = CGRectMake(0, curY, 320, maxHeight);
    }
    [self.view addSubview:self.dataTableView];
    
    if (!hotView) {
        hotView = [[UIView alloc] initWithFrame:CGRectMake(0, curY, 320, maxHeight)];
        hotView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        hotView.userInteractionEnabled = YES;
        UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 290, 30)];
        tipLabel.text = @"热点股票";
        tipLabel.textColor = [UIColor colorWithRed:0/255.0 green:178/255.0 blue:249/255.0 alpha:1.0];
        [self.hotView addSubview:tipLabel];
        [tipLabel release];
        
        self.itemPageView.frame = CGRectMake(0, 0, 320, hotView.bounds.size.height);
        itemPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.hotView addSubview:itemPageView];
        
    }
    else {
        hotView.frame = CGRectMake(0, curY, 320, maxHeight);
    }
    [self.view addSubview:self.hotView];
    
    [self adjustContentView];
}

-(void)adjustContentView
{
    if (curViewIndex==0) {
        self.hotView.hidden = NO;
        self.dataTableView.hidden = YES;
        curSearchBar.showsCancelButton = NO;
        [self.selectID removeAllObjects];
        NSString* curIndexString = [[NSNumber numberWithInt:curIndex] stringValue];
        [self.selectID addObject:curIndexString];
        [self.selectID addObject:@""];
        [self startRefreshTable:NO neverhttp:YES firstReload:YES scrollTop:YES];
    }
    else
    {
        self.hotView.hidden = YES;
        self.dataTableView.hidden = NO;
        curSearchBar.showsCancelButton = YES;
    }
}

-(void)showHistorySearchList
{
    NSString* textString = self.curSearchBar.text;
    BOOL bFirstResponse = [self.curSearchBar isFirstResponder];
    if ([textString length]==0&&bFirstResponse) {
        if (curIndex==0)
        {
            NSArray* searchArray = [[RegValueSaver getInstance] readSystemInfoForKey:StockSearchHistoryKey];
            self.suggestArray = searchArray;
        }
        else {
            NSArray* searchArray = [[RegValueSaver getInstance] readSystemInfoForKey:NewsSearchHistoryKey];
            self.suggestArray = searchArray;
        }
        if(self.suggestArray&&[self.suggestArray count]>0)
        {
            [self addSuggestView];
        }
        else {
            suggestView.superview.hidden = YES;
        }
    }
    
}

-(void)addHistorySearchList:(NSString*)searchText index:(NSInteger)index
{
    NSArray* oldList = nil;
    if (index==0) {
        oldList = [[RegValueSaver getInstance] readSystemInfoForKey:StockSearchHistoryKey];
    }
    else
    {
        oldList = [[RegValueSaver getInstance] readSystemInfoForKey:NewsSearchHistoryKey];
    }
    NSMutableArray* newArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary* newDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [newDict setValue:searchText forKey:@"name"];
    [newDict setValue:searchText forKey:StockFunc_Suggest_nasdac];
    [newArray addObject:newDict];
    [newDict release];
    if (oldList) {
        for (int i=0; i<[oldList count]; i++) {
            if ([oldList count]<18) {
                NSDictionary* oldDict = [oldList objectAtIndex:i];
                NSString* name = [oldDict valueForKey:@"name"];
                if ([[name lowercaseString] isEqualToString:[searchText lowercaseString]]) {
                    ;
                }
                else {
                    [newArray addObject:oldDict];
                }
            }
        }
    }
    
    if (index==0)
    {
        [[RegValueSaver getInstance] saveSystemInfoValue:newArray forKey:StockSearchHistoryKey encryptString:NO];
    }
    else {
        [[RegValueSaver getInstance] saveSystemInfoValue:newArray forKey:NewsSearchHistoryKey encryptString:NO];
    }
    
    [newArray release];
}



#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _groupViewType = GroupViewType_Search;
    // only show the status bar’s cancel button while in edit mode
    searchBar.showsCancelButton = YES;
    curViewIndex = 1;
    [self adjustContentView];
    NSString* text = searchBar.text;
    if ([text length]==0) {
        [self performSelector:@selector(showHistorySearchList) withObject:nil afterDelay:0.001];
    }
    else {
        UITextField* field = nil;
        for (UITextField* oneView in self.curSearchBar.subviews) {
            if ([oneView isKindOfClass:[UITextField class]]) {
                field = oneView;
                break;
            }
        }
        [self performSelector:@selector(addStockFieldChangedWithTextTield:) withObject:field afterDelay:0.03];
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //[tableData removeAllObjects];// remove all data that belongs to previous search
    if([searchText isEqualToString:@""] || searchText == nil){
        //[resultTable reloadData];
        
        return;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // if a valid search was entered but the user wanted to cancel, bring back the main list content
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    curViewIndex = 0;
    [self adjustContentView];
    [self hideSuggestView];
}

// called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self closeSearchKeyBoard];
    
    [[ProjectLogUploader getInstance] writeDataString:@"Speed_Dial_search"];
    NSString* searchText = searchBar.text;
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([searchText length]>0) {
        if ([self.selectID count]>1) {
            [self.selectID replaceObjectAtIndex:1 withObject:searchText];
        }
        else {
            [self.selectID addObject:searchText];
        }
        curViewIndex = 1;
        [self adjustContentView];
        [self startRefreshTable:NO firstReload:YES scrollTop:YES];
    }
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:@"内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    self.suggestView.superview.hidden = YES;
}

- (void)closeSearchKeyBoard
{
    [curSearchBar resignFirstResponder];
    NSArray* subViews = [curSearchBar subviews];
    for (UIButton* cancelBtn in subViews) {
        if ([cancelBtn isKindOfClass:[UIButton class]]) {
            cancelBtn.enabled = YES;
            break;
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
        if (length>60*60) {
            rtval = YES;
        }
    }
    else
        rtval = YES;
    return rtval;
}

#pragma mark -
#pragma mark addsuggest
-(void)addStockFieldChanged:(NSNotification*)notify
{
    UITextField* object = notify.object;
    if (self.addStockField==object) {
        [self addStockFieldChangedWithTextTield:object];
    }
}
-(void)addStockFieldChangedWithTextTield:(UITextField*)field
{
    UITextField* object = field;
    if (curIndex==0) {
        if (object==self.addStockField) {
            NSString* text = object.text;
            if (text&&![text isEqualToString:@""]) {
                [self initSuggestView];
                self.suggestView.superview.hidden = NO;
                [self.suggestView setData:nil];
                [[StockFuncPuller getInstance] startStockSuggestWithSender:self name:text type:0 subtype:nil count:10 page:0 args:nil dataList:nil seperateRequst:YES userInfo:nil];
            }
            else {
                self.suggestView.superview.hidden = YES;
            }
        }
    }
    else {
        self.suggestView.superview.hidden = YES;
    }
    [self showHistorySearchList];
}

-(void)initSuggestView
{
    CGRect addStockRect = self.addStockField.frame;
    addStockRect = [self.view convertRect:addStockRect fromView:self.addStockField.superview];
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
    [self closeSearchKeyBoard];
    backView.hidden = YES;
}

-(void)hideSuggestView
{
    [self closeSearchKeyBoard];
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
    if (_groupViewType == GroupViewType_Search) {
        _groupViewType = GroupViewType_Search;
        NSString* symbol = [dict valueForKey:StockFunc_Suggest_full_symbol];
        if (symbol) {
            if ([symbol rangeOfString:@" "].location!=NSNotFound) {
                symbol = [dict valueForKey:StockFunc_Suggest_full_symbol];
            }
        }
        else {
            symbol = [dict valueForKey:StockFunc_Suggest_nasdac];
        }
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        self.addStockField.text = symbol;
        [nc addObserver:self
               selector:@selector(addStockFieldChanged:)
                   name:UITextFieldTextDidChangeNotification
                 object:nil];
        [self searchBarSearchButtonClicked:curSearchBar];
    }else if(_groupViewType == GroupViewType_AddMyStock){
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
    }else{
        
    }
    
}

#pragma mark -
#pragma mark refreshTable
-(void)startRefreshTable:(BOOL)bForce firstReload:(BOOL)bReload scrollTop:(BOOL)bScrollTop
{
    [self startRefreshTable:bForce neverhttp:NO firstReload:bReload scrollTop:bScrollTop];
}

-(void)startRefreshTable:(BOOL)bForce neverhttp:(BOOL)neverhttp firstReload:(BOOL)bReload scrollTop:(BOOL)bScrollTop
{
    BOOL needRefresh = NO;
    if (bForce) {
        needRefresh = YES;
    }
    else
    {
        needRefresh = [self.dataTableView checkRefreshByDate:30*30];
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
        if (bScrollTop) {
            [self.dataTableView scrollTop:NO];
        }
        [self.dataTableView setPageMode:PageCellType_Normal];
        [self.dataTableView reloadData];
    }
    
    NSString* mode = [self.selectID objectAtIndex:0];
    NSString* searchStr = [self.selectID objectAtIndex:1];
    if (needRefresh&&!neverhttp) {
        [self.dataTableView startLoadingUI];
        if (![searchStr isEqualToString:@""]) {
            if ([mode intValue]==0) {
                [self addHistorySearchList:searchStr index:curIndex];
                [[StockFuncPuller getInstance] startStockLookupWithSender:self name:searchStr forLeast:NO args:self.selectID dataList:self.dataList seperateRequst:NO userInfo:nil];
            }
            else {
            }
        }
        else {
            [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:YES];
        }
    }
    else
    {
        if (![searchStr isEqualToString:@""]) {
            [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
        }
        else {
            [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:YES];
        }
    }
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
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                curPage = [pageNumber intValue];
                if ([pageNumber intValue]<=1) {
                    [self.dataTableView scrollTop:NO];
                }
                [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
            }
        }
        else if([stageNumber intValue]==Stage_Request_AddStockSuggest)
        {
            self.suggestArray = [userInfo valueForKey:RequsetExtra];
            if (curIndex==0) {
                [self addSuggestView];
            }
        }
        else if([stageNumber intValue]==Stage_Request_ObtainMyGroupList)
        {
            
            _groupViewType = GroupViewType_AddMyStock;
            
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
        if ([stageNumber intValue]==Stage_Request_StockLookup) {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                [self postFailedTip];
                [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
            }
        }
        else if([stageNumber intValue]==Stage_Request_AddMyGroup)
        {
            NSDictionary* extraDict = [userInfo valueForKey:RequsetExtra];
            NSString* oldMsg = [extraDict valueForKey:@"msg"];
            NSString* msg = [NSString stringWithFormat:@"添加股票失败,%@",oldMsg];
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
        else if([stageNumber intValue]==Stage_Request_AddStockSuggest)
        {
            if (curIndex==0) {
                self.suggestArray = nil;
                [suggestView setData:nil];
                suggestView.loadState = GroupViewState_Error;
            }
        }
    }
}

-(void)postFailedTip
{
    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"搜索出错了" time:1.0 ignoreAddition:NO pView:self.dataTableView];
}

#pragma mark -
#pragma mark DataListTableView
-(UITableViewCell*)dataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    NSArray* oldSelectID = view.selectID;
    NSString* mode = [oldSelectID objectAtIndex:0];
    if ([mode intValue]==0) {
        return [self stockCellWithDataListView:view cellForIndexPath:path object:object];
    }
    else {
    }
}

-(UITableViewCell*)stockCellWithDataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    NSString *StockCellIdentifier = [NSString stringWithFormat:@"StockCellIdentifier"];
    UITableViewCell *cell = (UITableViewCell*)[view.tableView dequeueReusableCellWithIdentifier:StockCellIdentifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StockCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 150, 40)];
        nameLabel.tag = 111111;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:18.0];
        nameLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:nameLabel];
        [nameLabel release];
        
        UILabel* symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 120, 40)];
        symbolLabel.tag = 111112;
        symbolLabel.textColor = [UIColor blackColor];
        symbolLabel.font = [UIFont systemFontOfSize:18.0];
        symbolLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:symbolLabel];
        [symbolLabel release];
    }
    
    UILabel* nameLabel = (UILabel*)[cell.contentView viewWithTag:111111];
    nameLabel.text = [[object valueForKey:StockFunc_RemindStockInfo_name] isEqualToString:@""]?[object valueForKey:StockFunc_RemindStockInfo_symbol]:[object valueForKey:StockFunc_RemindStockInfo_name];
    
    UILabel* symbolLabel = (UILabel*)[cell.contentView viewWithTag:111112];
    symbolLabel.text = [object valueForKey:StockFunc_RemindStockInfo_symbol];
    
    UIButton *addMyStock = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [addMyStock setImage:[UIImage imageWithName:@"jiahao.png"] forState:UIControlStateNormal];
    addMyStock.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 8, 8);
    //        [addMyStock setValue:object forKey:@"news_object"];
    [addMyStock addTarget:self action:@selector(handleAddPressed:) forControlEvents:UIControlEventTouchUpInside];
    addMyStock.frame = CGRectMake(280, 0, 40, 40);
    addMyStock.tag = path.row;
    
    //addMyStock.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:addMyStock];
    //        [addMyStock release];
    
    
    return cell;
}

-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    NSArray* oldSelectID = view.selectID;
    NSString* mode = [oldSelectID objectAtIndex:0];
    if ([mode intValue]==0) {
        return 40.0;
    }
    else {
        return 46.0;
    }
}

-(void)dataListView:(DataListTableView*)view didSelectedAtIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    [view.tableView deselectRowAtIndexPath:path animated:YES];
    NSArray* oldSelectID = view.selectID;
    NSString* mode = [oldSelectID objectAtIndex:0];
    if ([mode intValue]==0) {
        NSString* name = [object valueForKey:StockFunc_RemindStockInfo_name];
        NSString* type = [object valueForKey:StockFunc_RemindStockInfo_type];
        NSString* symbol = [object valueForKey:StockFunc_RemindStockInfo_symbol];
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        
        SingleStockViewController* singleViewController = [[SingleStockViewController alloc] init];
        singleViewController.stockSymbol = symbol;
        singleViewController.stockType = type;
        singleViewController.stockName = name;
        singleViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:singleViewController animated:YES];
        [singleViewController release];
    }
    else {
    }
    
}

-(void)dataListViewDidMoreClicked:(DataListTableView*)view
{
    NSArray* oldSelectID = view.selectID;
    NSString* mode = [oldSelectID objectAtIndex:0];
    NSString* searchStr = [oldSelectID objectAtIndex:1];
    if ([mode intValue]==0) {
        [[StockFuncPuller getInstance] startStockLookupWithSender:self name:searchStr forLeast:NO args:self.selectID dataList:self.dataList seperateRequst:NO userInfo:nil];
    }
    else {
        
    }
}
-(void)dataListViewDidRefreshTriggered:(DataListTableView*)view
{
    [self startRefreshTable:YES firstReload:YES scrollTop:YES];
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
    [self closeSearchKeyBoard];
}

#pragma mark -
#pragma mark ItemPageViewDelegate
-(PageItemCell*)pageView:(ItemPageView*)view cellWithIndex:(NSInteger)index
{
    PageItemCell* cell = [[[PageItemCell alloc] init] autorelease];
    NewsObject* oneObject = [self.configDataList oneObjectWithIndex:index IDList:nil];
    UIImage* btnImage = [UIImage imageNamed:[oneObject valueForKey:Stockitem_avatar]];
    NSString* title = [oneObject valueForKey:Stockitem_name];
    cell.title = title;
    [cell setImage:btnImage forState:UIControlStateNormal];
    return cell;
}

- (NSInteger)numberOfCellsInPageView:(ItemPageView *)view
{
    return [self.configDataList contentsCountWithIDList:nil];
}

-(void)pageView:(ItemPageView*)view cellClickedWithCell:(PageItemCell*)cell byBtn:(BOOL)byBtn
{
    NSInteger index = cell.curIndex;
    NSString* name = cell.title;
    
    if (byBtn) {
        [self addProjectLog:index];
    }
    
    NewsObject* oneObject = [self.configDataList oneObjectWithIndex:index IDList:nil];
    NSString* needLoginString = [oneObject valueForKey:Stockitem_needlogin];
    BOOL needLogin = NO;
    BOOL hasLogin = [[WeiboLoginManager getInstance] hasLogined];
    if (needLoginString&&[needLoginString intValue]>0) {
        if (!hasLogin) {
            needLogin = YES;
        }
    }
    
    if (needLogin) {
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        LoginViewController* userLoginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        userLoginController.delegate = self;
        userLoginController.loginMode = LoginMode_Stock;
        userLoginController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userLoginController animated:YES];
        [userLoginController release];
    }
    else {
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        NSString* specialClass = [oneObject valueForKey:Stockitem_specilclass];
        if (specialClass&&[specialClass intValue]>0) {
            StockBarViewController* stockBarController = [[StockBarViewController alloc] init];
            stockBarController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:stockBarController animated:YES];
            [stockBarController release];
        }
        else {
            StockListViewController2* stockController = [[StockListViewController2 alloc] initWithItem:oneObject];
            stockController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:stockController animated:NO];
            [stockController release];
        }
    }
}

-(void)addProjectLog:(NSInteger)index
{
    if (index==0) {
        [[ProjectLogUploader getInstance] writeDataString:@"My_finance_stock"];
    }
    else if(index==1)
    {
        [[ProjectLogUploader getInstance] writeDataString:@"Astock"];
    }
    else if(index==2)
    {
        [[ProjectLogUploader getInstance] writeDataString:@"Shares"];
    }
    else if(index==3)
    {
        [[ProjectLogUploader getInstance] writeDataString:@"USstock"];
    }
    else if(index==4)
    {
        [[ProjectLogUploader getInstance] writeDataString:@"Hkstock"];
    }
    else if(index==5)
    {
        [[ProjectLogUploader getInstance] writeDataString:@"stock_index"];
    }
    else if(index==6)
    {
        [[ProjectLogUploader getInstance] writeDataString:@"fund_quotation"];
    }
    else if(index==7)
    {
        [[ProjectLogUploader getInstance] writeDataString:@"foreign_exchange_quotation"];
    }
    else if(index==8)
    {
        [[ProjectLogUploader getInstance] writeDataString:@"Global_commodity"];
    }
}

-(void)handleAddPressed:(UIButton*)addMyStockBtn
{
    _groupViewType = GroupViewType_AddMyStock;
    NewsObject *oneObject = [dataList oneObjectWithIndex:addMyStockBtn.tag IDList:self.selectID];
    //    NSDictionary* listConfigDict = oneObject.newsData; //自选股的配置信息
    //
    
    NSString* name = [oneObject valueForKey:StockFunc_RemindStockInfo_name];
    NSString* type = [oneObject valueForKey:StockFunc_RemindStockInfo_type];
    self.stockSymbol = [oneObject valueForKey:StockFunc_RemindStockInfo_symbol];
    //
    //    if ([self.stockType isEqualToString:@"fund"]) {
    //        self.stockSymbol = [self.stockSymbol stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    //    }
    
    self.subType = [oneObject valueForKey:StockFunc_SingleStockInfo_fundtype];
    self.stockType = type;
    
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    if (hasLogined) {
        BOOL hasMyGroupView = mygroupView?YES:NO;
        [self initMyGroupView:addMyStockBtn];
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
                if ([oneType isEqualToString:type]) {
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
        LoginViewController* userLoginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        userLoginController.delegate = self;
        userLoginController.loginMode = LoginMode_Stock;
        [self.navigationController pushViewController:userLoginController animated:YES];
        [userLoginController release];
    }
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


/**
 * 初始化并增加我的自选groupview
 * 2012-09-20 sang
 */
-(void)initMyGroupView:(UIButton*)sender
{
    CGRect addStockRect = sender.frame;
    addStockRect = [self.view convertRect:addStockRect fromView:sender.superview];
    CGRect suggestRect = addStockRect;
    suggestRect.origin.y = addStockRect.origin.y + addStockRect.size.height+3;
    suggestRect.size.width = 120;
    suggestRect.origin.x = 320 - 10 - 120;
    suggestRect.size.height = 100;
    
    if ( suggestRect.origin.y>300) {
        suggestRect.origin.y = suggestRect.origin.y-150;
    }
    
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

/**
 * 隐藏我的自选groupview
 * 2012-09-20 sang
 */
-(void)groupViewBackClicked:(UIButton*)sender
{
    self.mygroupView.superview.hidden = YES;
}


#pragma mark - textFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _groupViewType = GroupViewType_Search;
    OPCustomKeyboard *keyboard = [[OPCustomKeyboard alloc] initWithTextField:self.addStockField andIDelegate:self];
    keyboard.view.frame = CGRectMake(0, 240, 320, 221);
    textField.inputView = keyboard.view;
}


-(void)doSearch{
    [self searchBarSearchButtonClicked:curSearchBar];
}

@end
