//
//  SearchViewController.m
//  SinaFinance
//
//  Created by Du Dan on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "StockViewDefines.h"
#import "SearchViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "DropDownTabBar.h"
#import "DataListTableView.h"
#import "CommentDataList.h"
#import "StockFuncPuller.h"
#import "NewsFuncPuller.h"
#import "LKTipCenter.h"
#import "NewsTableViewCell.h"
#import "NewsListFuncPuller.h"
#import "NewsContentViewController2.h"
#import "SingleStockViewController.h"
#import "ItemPageView.h"
#import "MyStockGroupView.h"
#import "MyTabBarController.h"
#import "AppDelegate.h"
#import "RegValueSaver.h"
#import "StockViewDefines.h"
#import "LoginViewController.h"
#import "ConfigFileManager.h"
#import "OPCustomKeyboard.h"

#define NewsHasReadKey @"NewsHasReadKey"

NSString* StockSearchHistoryKey = @"StockSearchHistoryKey";
NSString* NewsSearchHistoryKey = @"NewsSearchHistoryKey";

@interface SearchViewController ()
@property(nonatomic,retain)UIView* tabBarBack;
@property(nonatomic,retain)DropDownTabBar* tabBarView;
@property(nonatomic,retain)DataListTableView* dataTableView;
@property(nonatomic,retain)NSMutableArray* selectID;
@property(nonatomic,retain)CommentDataList* dataList,*configDataList;
@property(nonatomic,retain)UISearchBar* curSearchBar;
@property(nonatomic,retain)UIView* hotView;
@property(nonatomic,retain)NSArray* searchHotObjectArray;
@property(nonatomic,retain)ItemPageView* itemPageView;
@property(nonatomic,retain)UIView* errorHotView;
@property(nonatomic,retain)UITextField* addStockField;
@property(nonatomic,retain)NSArray* suggestArray;
@property(nonatomic,retain)MyStockGroupView *suggestView;
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
@end

@implementation SearchViewController
{
    UIView* tabBarBack;
    DropDownTabBar* tabBarView;
    DataListTableView* dataTableView;
    NSMutableArray* selectID;
    CommentDataList* dataList,*configDataList;
    UISearchBar* curSearchBar;
    UIView* hotView;
    NSInteger bInited;
    NSInteger curIndex;
    NSInteger curViewIndex;
    NSInteger curPage;
    NSInteger countPerPage;
    NSArray* searchHotObjectArray;
    ItemPageView* itemPageView;
    UIView* errorHotView;
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
@synthesize tabBarView;
@synthesize tabBarBack;
@synthesize dataTableView;
@synthesize selectID,dataList,configDataList;
@synthesize curSearchBar;
@synthesize hotView;
@synthesize searchHotObjectArray;
@synthesize itemPageView;
@synthesize errorHotView;
@synthesize addStockField;
@synthesize suggestArray;
@synthesize suggestView;
@synthesize mygroupView;
@synthesize listConfigDict;
@synthesize mygroupArray;
@synthesize subType,stockType,stockSymbol;
@synthesize keyboard;
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



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"搜索";
        self.tabBarItem.image = [UIImage imageNamed:@"tbsearch_icon.png"];
        selectID = [[NSMutableArray alloc] initWithCapacity:0];
        dataList = [[CommentDataList alloc] init];
        countPerPage = 20;
        _groupViewType = GroupViewType_Search;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [tabBarBack release];
    [tabBarView release];
    [dataTableView release];
    [selectID release];
    [dataList release];
    [curSearchBar release];
    [hotView release];
    [searchHotObjectArray release];
    [itemPageView release];
    [addStockField release];
    [suggestArray release];
    [suggestView release];
    [errorHotView release];
    
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
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化配置数据，增加我的自选时使用
    [self initConfigData];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createToolbar];
    [self initUI];
    [self initData];
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

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate{
    //     if([ShareData sharedManager].isStockItemView && [ShareData sharedManager].viewIsLoading == NO){
    //         return YES;
    //     }else{
    return NO;
    //     }
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (void)createToolbar
{
    MyCustomToolbar *topToolBar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(110, 0, 100, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    titleLabel.text = @"搜索";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolBar addSubview:titleLabel];
    
    UIImageView *logo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sina_logo.png"]] autorelease];
    logo.frame = CGRectMake(15, 8, 38, 27);
    logo.contentMode = UIViewContentModeScaleToFill;
    [topToolBar addSubview:logo];
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
           selector:@selector(CommonNewsSucceed:) 
               name:CommonNewsSucceedNotification 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(CommonNewsFailed:) 
               name:CommonNewsFailedNotification
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(addStockFieldChanged:) 
               name:UITextFieldTextDidChangeNotification
             object:nil];
//    [nc addObserver:self
//           selector:@selector(keyboardDidShow:)
//               name:UIKeyboardDidShowNotification
//             object:nil];
    [nc addObserver:self selector:@selector(custom_key_board_change:) name:CUSTOM_KEY_BOARD_EVENT_CHANGE_NOTI object:nil];
    
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
        curSearchBar.placeholder = @"请输入搜索内容";
        [self.view addSubview:curSearchBar];
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
    
    curY += 44;
    if (!tabBarBack) {
        tabBarBack = [[UIView alloc] initWithFrame:CGRectMake(0, curY, 320, 34)];
        NSInteger tabBarheight = 30;
        if (!tabBarView) {
            tabBarView = [[DropDownTabBar alloc] initWithFrame:CGRectMake(0, 4, 320, tabBarheight)];
            tabBarView.delegate = self;
            tabBarView.hasDropDown = NO;
            tabBarView.spacer = 0;
            tabBarView.padding = 23.0;
        }
        else
        {
            tabBarView.frame = CGRectMake(0, 4, 320, tabBarheight);
        }
        [self.tabBarBack addSubview:tabBarView];
    }
    else {
        tabBarBack.frame = CGRectMake(0, curY, 320, 34);
    }
    [self.view addSubview:tabBarBack];
    
    curY += 34;
    int maxHeight = self.view.bounds.size.height - curY;
    if (!self.dataTableView) {
        DataListTableView* dataView = [[DataListTableView alloc] initWithFrame:CGRectMake(0, curY, 320, maxHeight)];
        dataView.defaultSucBackString = @"";
        dataView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        dataView.delegate = self;
        dataView.backLabel.textColor = [UIColor blackColor];
        dataView.tableView.backgroundColor = [UIColor whiteColor];
        dataView.selectID = selectID;
        dataView.dataList = dataList;
        dataView.hasHeaderMode = NO;
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
        hotView.backgroundColor = [UIColor clearColor];
        hotView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        hotView.userInteractionEnabled = YES;
        
        UIView* tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
//        tempView.backgroundColor = [UIColor colorWithRed:233/255.0 green:242/255.0 blue:250/255.0 alpha:1.0];
        tempView.backgroundColor = [UIColor whiteColor];
        [self.hotView addSubview:tempView];
        [tempView release];
        
        UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 290, 30)];
        tipLabel.text = @"热点股票";
        tipLabel.textColor = [UIColor colorWithRed:104/255.0 green:146/255.0 blue:211/255.0 alpha:1.0];
        tipLabel.backgroundColor = [UIColor clearColor];
        [self.hotView addSubview:tipLabel];
        [tipLabel release];
        
        itemPageView = [[ItemPageView alloc] init];
        itemPageView.delegate = self;
        itemPageView.countPerPage = 30;
        itemPageView.sizePerItem = CGSizeMake(100, 25);
        itemPageView.sameSapcer = NO;
        itemPageView.hasPageControll = YES;
        itemPageView.paddingSize = CGSizeMake(5, 5);
        itemPageView.backImageView.backgroundColor = [UIColor clearColor];
        CGRect itemRect = hotView.bounds;
        itemPageView.frame = CGRectMake(0, 35, 320, hotView.bounds.size.height - 35);
        itemPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [hotView addSubview:itemPageView];
        
    }
    else {
        hotView.frame = CGRectMake(0, curY, 320, maxHeight);
    }
    [self.view addSubview:self.hotView];
    
    [self adjustContentView];
    
    keyboard = [[OPCustomKeyboard alloc] initWithTextField:self.addStockField andIDelegate:self];
    keyboard.view.frame = CGRectMake(0, 0, 320, 221+40);
    keyboard.view.tag = 100;
}

-(void)addLoadingFailedView
{
    CGRect errorHotViewRect = self.itemPageView.frame;
    if (!errorHotView) {
        errorHotView = [[UIView alloc] initWithFrame:errorHotViewRect];
        errorHotView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        errorHotView.backgroundColor = [UIColor clearColor];
        [self.hotView addSubview:errorHotView];
        UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.text = @"热点股票加载失败,请检查网络后重试!";
        [tipLabel sizeToFit];
        [errorHotView addSubview:tipLabel];
        
        UIButton* retryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        retryBtn.tag = 13330;
        [retryBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        UIImage* btnImage = [UIImage imageNamed:@"toolbar_btn_bg.png"];
        [retryBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        retryBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
        [retryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [retryBtn addTarget:self action:@selector(reloadUIClicked:) forControlEvents:UIControlEventTouchUpInside];
        [errorHotView addSubview:retryBtn];
        
        UIActivityIndicatorView* retryIndicatior = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        retryIndicatior.tag = 13331;
        [errorHotView addSubview:retryIndicatior];
        
        CGRect tipRect = tipLabel.frame;
        tipRect.origin.x = errorHotViewRect.origin.x + errorHotViewRect.size.width/2 - tipRect.size.width/2;
        tipRect.origin.y = 70;
        tipLabel.frame = tipRect;
        
        CGRect retryRect = retryBtn.frame;
        retryRect.origin.x = errorHotViewRect.origin.x + errorHotViewRect.size.width/2 - retryRect.size.width/2;
        retryRect.origin.y = tipRect.origin.y + tipRect.size.height + 15;
        retryBtn.frame = retryRect;
        
        CGRect indicataorRect = retryIndicatior.frame;
        indicataorRect.origin.x = errorHotViewRect.origin.x + errorHotViewRect.size.width/2 - indicataorRect.size.width/2;
        indicataorRect.origin.y = tipRect.origin.y + tipRect.size.height + 10;
        retryIndicatior.frame = indicataorRect;
        
        [retryBtn release];
        
        [tipLabel release];
        [retryIndicatior release];
    }
    else
    {
        errorHotView.hidden = NO;
    }
    self.itemPageView.hidden = YES;
}

-(void)restoreErrorView
{
    [self addLoadingFailedView];
    UIActivityIndicatorView* retryIndicator = (UIActivityIndicatorView*)[self.errorHotView viewWithTag:13331];
    [retryIndicator stopAnimating];
    UIButton* retryBtn = (UIButton*)[self.errorHotView viewWithTag:13330];
    retryBtn.hidden = NO;
}

-(void)reloadUIClicked:(UIButton*)sender
{
    sender.hidden = YES;
    UIActivityIndicatorView* retryIndicator = (UIActivityIndicatorView*)[self.errorHotView viewWithTag:13331];
    [retryIndicator startAnimating];
    [self initData];
}

-(void)initData
{
    [[StockFuncPuller getInstance] startSearchHotStockWithSender:self args:nil dataList:nil seperateRequst:NO userInfo:nil];
}

-(void)adjustContentView
{
    if (curViewIndex==0) {
        self.hotView.hidden = NO;
        self.dataTableView.hidden = YES;
        self.tabBarBack.backgroundColor = [UIColor colorWithRed:233/255.0 green:242/255.0 blue:250/255.0 alpha:1.0];
        self.tabBarBack.backgroundColor = [UIColor whiteColor];
        curSearchBar.showsCancelButton = NO;
        [self.selectID removeAllObjects];
        NSString* curIndexString = [[NSNumber numberWithInt:curIndex] stringValue];
        [self.selectID addObject:curIndexString];
        [self.selectID addObject:@""];
        [self startRefreshTable:NO neverhttp:YES firstReload:YES scrollTop:YES];
    }
    else {
        self.tabBarBack.backgroundColor = [UIColor whiteColor];
        self.hotView.hidden = YES;
        self.dataTableView.hidden = NO;
        curSearchBar.showsCancelButton = YES;
    }
}

-(void)showHistorySearchList
{
    NSString* textString = self.curSearchBar.text;
    if ([textString length]==0) {
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
    _groupViewType = GroupViewType_Search;
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
        BOOL bEnd = [self.dataList pageEndInfoWithIDList:self.selectID];
        if (bEnd) {
            [self.dataTableView setPageMode:PageCellType_Ending];
        }
        else {
            [self.dataTableView setPageMode:PageCellType_Normal];
        }
        [self.dataTableView reloadData];
    }
    
    NSString* mode = [self.selectID objectAtIndex:0];
    NSString* searchStr = [self.selectID objectAtIndex:1];
    if (needRefresh&&!neverhttp) {
        [self.dataTableView startLoadingUI];
        if (![searchStr isEqualToString:@""]) {
            [self addHistorySearchList:searchStr index:curIndex];
            if ([mode intValue]==0) {
                [[StockFuncPuller getInstance] startStockLookupWithSender:self name:searchStr forLeast:NO args:self.selectID dataList:self.dataList seperateRequst:NO userInfo:nil];
            }
            else {
                [[NewsFuncPuller getInstance] startSearchFinanceNewsWithSender:self searchString:searchStr lastps:nil lastpf:nil count:countPerPage page:1 args:self.selectID dataList:self.dataList userInfo:nil];
            }
        }
        else {
            [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:YES];
        }
    }
    else
    {
        if (![searchStr isEqualToString:@""]) {
            BOOL bEnd = [self.dataList pageEndInfoWithIDList:self.selectID];
            [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:bEnd];
            
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
        else if ([stageNumber intValue]==Stage_Request_SearchHotStock) {
            _groupViewType = GroupViewType_Search;
            
            NSArray* array = [userInfo valueForKey:RequsetArray];
            self.errorHotView.hidden = YES;
            self.itemPageView.hidden = NO;
            self.searchHotObjectArray = array;
            [self.itemPageView reloadData];
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
                NSArray* array = [userInfo valueForKey:RequsetArray];
                [self postFailedTip];
                if ([array count]!=countPerPage) {
                    [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:YES];
                }
                else {
                    [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
                }
                
            }
        }
        else if ([stageNumber intValue]==Stage_Request_SearchHotStock) {
            [self restoreErrorView];
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

-(void)CommonNewsSucceed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_SearchNews) {
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                NSArray* array = [userInfo valueForKey:RequsetArray];
                curPage = [pageNumber intValue];
                if ([pageNumber intValue]<=1) {
                    [self.dataTableView scrollTop:NO];
                }
                if ([array count]!=countPerPage) {
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:YES];
                }
                else {
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
                }
            }
        }
        
    }
}

-(void)CommonNewsFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_SearchNews) {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                [self postFailedTip];
                [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
            }
        }
    }
}

-(void)postFailedTip
{
    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"搜索出错了" time:1.0 ignoreAddition:NO pView:self.dataTableView];
}

#pragma mark -
#pragma mark DropDownTabBarDelegate
-(NSArray*)tabsWithTabBar:(DropDownTabBar*)tabBar
{
    NSArray* titleArray = [NSArray arrayWithObjects:@"搜股票",@"搜新闻", nil];
    NSMutableArray* rtval = nil;
    for (int i=0; i<[titleArray count]; i++) {
        if (!rtval) {
            rtval = [NSMutableArray arrayWithCapacity:0];
        }
        DropDownTab* onetab = [[DropDownTab alloc] init];
        UIImage *image = nil;
        UIImage *selectedImage = nil;
        if (i==0) {
            image = [UIImage imageNamed:@"search_btn_left.png"];
            selectedImage = [UIImage imageNamed:@"search_btn_left_selected.png"];
            [onetab setBackgroundImage:image forState:UIControlStateNormal];
            [onetab setBackgroundImage:selectedImage forState:UIControlStateSelected];
        }
        
        if (i==1) {
            image = [UIImage imageNamed:@"search_btn_right.png"];
            selectedImage = [UIImage imageNamed:@"search_btn_right_selected.png"];
            [onetab setBackgroundImage:image forState:UIControlStateNormal];
            [onetab setBackgroundImage:selectedImage forState:UIControlStateSelected];
        }
        
        [onetab setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [onetab setTitleColor:[UIColor colorWithRed:50/255.0 green:110/255.0 blue:186/255.0 alpha:1.0] forState:UIControlStateNormal];
        [onetab setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [onetab setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [rtval addObject:onetab];
        [onetab release];
    }
    return rtval;
}

-(void)tabBar:(DropDownTabBar*)tabBar clickedWithIndex:(NSInteger)index byBtn:(BOOL)byBtn
{
    if (index==0) {
        self.dataTableView.hasPageMode = NO;
    }
    else {
        self.dataTableView.hasPageMode = YES;
    }
    [self closeSearchKeyBoard];
    NSString* titleString = [tabBar titleForIndex:index];
    NSString* indexString = [[NSNumber numberWithInt:index] stringValue];
    curIndex = index;
    if (curViewIndex==0) {
        [self.selectID removeAllObjects];
    }
    
    if ([self.selectID count]>0) {
        [self.selectID replaceObjectAtIndex:0 withObject:indexString];
    }
    else {
        [self.selectID addObject:indexString];
    }
    
    if ([self.selectID count]>=2) {
        curViewIndex = 1;
        [self adjustContentView];
        [self startRefreshTable:NO firstReload:YES scrollTop:YES];
    }
    else {
        curViewIndex = 0;
        [self adjustContentView];
    }
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
        return [self newsCellWithDataListView:view cellForIndexPath:path object:object];
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
    
    
    UILabel* nameLabel = (UILabel*)[cell.contentView viewWithTag:111111];
    nameLabel.text = [[object valueForKey:StockFunc_RemindStockInfo_name] isEqualToString:@""]?[object valueForKey:StockFunc_RemindStockInfo_symbol]:[object valueForKey:StockFunc_RemindStockInfo_name];
    
    UILabel* symbolLabel = (UILabel*)[cell.contentView viewWithTag:111112];
    symbolLabel.text = [object valueForKey:StockFunc_RemindStockInfo_symbol];
    
    return cell;
}

-(UITableViewCell*)newsCellWithDataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    NSString *NewsCellIdentifier = [NSString stringWithFormat:@"NewsCellIdentifier"];
    NewsTableViewCell *cell = (NewsTableViewCell*)[view.tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
    if(cell == nil){
        cell = [[[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSNumber* hasRead = [object userInfoValueForKey:NewsHasReadKey];
    
    if(!hasRead||![hasRead boolValue]){
        cell.readIcon.hidden = NO;
    }
    else{
        cell.readIcon.hidden = YES;
    }
    if(!hasRead||![hasRead boolValue]) {
        cell.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:88/255.0 blue:162/255.0 alpha:1.0];
        cell.dateLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        cell.sourceLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    }
    else {
        cell.titleLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        cell.dateLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
        cell.sourceLabel.textColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1.0];
    }

    NSString *title = [object valueForKey:SearchNews_short_title];
    if (!title||[title length]==0) {
        title = [object valueForKey:SearchNews_title];
    }
    if(title){
        cell.titleLabel.text = title;
    }
    else {
        cell.titleLabel.text = @"";
    }
    NSString *dateString = [object valueForKey:SearchNews_datetime];
    cell.dateLabel.text = dateString;
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
        NSNumber* hasRead = [object userInfoValueForKey:NewsHasReadKey];
        if (!hasRead) {
            [object setUserInfoValue:[NSNumber numberWithBool:YES] forKey:NewsHasReadKey];
            [object refreshToDataBase];
            [view.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
        }
        [view.tableView deselectRowAtIndexPath:path animated:YES];
        
        NSString* urlstring = [object valueForKey:SearchNews_url];
        MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
        [tabBarController setTabBarHiden:YES];
        NewsContentViewController2* contentController = [[NewsContentViewController2 alloc] initWithNewsURL2:urlstring];
        contentController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contentController animated:YES];
        [contentController release];
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
        NSObject* oneObject = [view.dataList lastObjectWithIDList:oldSelectID];
        NSString* ps = [oneObject valueForKey:@"ps"];
        NSString* pf = [oneObject valueForKey:@"pf"];
        [[NewsFuncPuller getInstance] startSearchFinanceNewsWithSender:self searchString:searchStr lastps:ps lastpf:pf count:countPerPage page:curPage+1 args:self.selectID dataList:self.dataList userInfo:nil];
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
    [rtval setTipColor:[UIColor blackColor] forType:PageCellType_Normal];
    [rtval setTipColor:[UIColor blackColor] forType:PageCellType_Ending];
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
    NewsObject* oneObject = [self.searchHotObjectArray objectAtIndex:index];
    NSString* title = [oneObject valueForKey:SearchHotStock_name];
    cell.title = title;
    cell.data = oneObject;
    cell.backgroundColor = [UIColor clearColor];
    [cell setTitle:title forState:UIControlStateNormal];
    [cell setTitleColor:[UIColor colorWithRed:40/255.0 green:82/255.0 blue:149/255.0 alpha:1.0] forState:UIControlStateNormal];
    return cell;
}

- (NSInteger)numberOfCellsInPageView:(ItemPageView *)view
{
    return [self.searchHotObjectArray count];
}

-(void)pageView:(ItemPageView*)view cellClickedWithCell:(PageItemCell*)cell byBtn:(BOOL)byBtn
{
    NewsObject* oneObject = cell.data;
    NSString* name = [oneObject valueForKey:SearchHotStock_name];
    NSString* type = [oneObject valueForKey:SearchHotStock_type];
    NSString* symbol = [oneObject valueForKey:SearchHotStock_symbol];
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


#pragma mark -
//-(void)handleAddPressed:(UIButton *)addMyStockBtn
//{
//    
////    NewsObject *oneObject = (NewsObject *)[addMyStockBtn valueForKey:@"news_object"];
////    NSLog(@"%@",oneObject.newsData);
//    NewsObject *oneObject = [dataList oneObjectWithIndex:addMyStockBtn.tag IDList:self.selectID];
//    NSDictionary* listConfigDict = oneObject.newsData; //自选股的配置信息
//    
////    NSArray* requstTypes = (NSArray*)[listConfigDict valueForKey:Stockitem_request_type];
////    NSInteger curRequstIndex = 0;
////    for (int i=0; i<[requstTypes count]; i++) {
////        NSString* oneType = [requstTypes objectAtIndex:i];
////        if ([oneType isEqualToString:self.stockType]) {
////            curRequstIndex = i;
////            break;
////        }
////    }
////    NSArray* groupRequstTypes = (NSArray*)[listConfigDict valueForKey:Stockitem_grouprequst_type];
////    NSString* service = nil;
////    if (curRequstIndex<[groupRequstTypes count]) {
////        service = [groupRequstTypes objectAtIndex:curRequstIndex];
////    }
////    NSDictionary* commandDict = (NSDictionary*)[listConfigDict valueForKey:Stockitem_layout_request_command];
////    NSString* command = [commandDict valueForKey:Stockitem_layout_request_command_add];
////    
////    NSString* pid = [dict valueForKey:StockFunc_GroupInfo_pid];
////    [[StockFuncPuller getInstance] startMyGroupAddStockWithSender:self service:service stock:[NSArray arrayWithObject:self.stockSymbol] command:command groupPID:pid args:nil dataList:nil userInfo:nil];
//// 
//}

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


//#pragma mark - textFieldDelegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    _groupViewType = GroupViewType_Search;
////    OPCustomKeyboard *keyboard = [[OPCustomKeyboard alloc] initWithTextField:self.addStockField andIDelegate:self];
////    keyboard.view.frame = CGRectMake(0, 240, 320, 221);
////    textField.inputView = keyboard.view;
//}
//

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    //    textField.inputView.hidden= YES;
    //    [textField becomeFirstResponder];
    _groupViewType = GroupViewType_Search;
    //    OPCustomKeyboard *keyboard = [[OPCustomKeyboard alloc] initWithTextField:self.addStockField andIDelegate:self];
    //    keyboard.view.frame = CGRectMake(0, 240, 320, 221);
    //    textField.inputAccessoryView = keyboard.view;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardDidShowNotification
     object:nil];
    
    
    UIView *foundKeyboard = [self getSystemKeyboard];
    if (foundKeyboard) {
        
        
        if (keyboard.view ) {
            [keyboard.view removeFromSuperview];
        }
        foundKeyboard.hidden = NO;
        
    }
}



-(void)doSearch:(NSString *)str{
//    [self searchBarSearchButtonClicked:curSearchBar];
    [self closeSearchKeyBoard];
    NSString* searchText = str;
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


#pragma mark -
-(void)keyboardDidShow:(NSNotification *)noti{
    [self hackSystemKeyboard];
}

- (void)hackSystemKeyboard
{
    UIView *foundKeyboard = [self getSystemKeyboard];
    if (foundKeyboard) {
        //如果有原先存在的hack button，删之
        //[self clearKeyboardHack];
        //hackButton 为123button
        //新建hackButton，根据orentation定义不同的frame
        //        UIButton *hackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        hackButton.backgroundColor = [UIColor clearColor];
        //        hackButton.tag = 19100;
        //        if (YES) {
        //            hackButton.frame = CGRectMake(3, 124, 90, 38);
        //            UIImage *btnBG = [UIImage imageNamed:@"hackButtonLandscape.png"];
        //            [hackButton setBackgroundImage:btnBG forState:UIControlStateNormal];
        //        }else {
        //            hackButton.frame = CGRectMake(2, 173, 77, 43);
        //            UIImage *btnBG = [UIImage imageNamed:@"hackButton.png"];
        //            [hackButton setBackgroundImage:btnBG forState:UIControlStateNormal];
        //        }
        //        [hackButton setShowsTouchWhenHighlighted:YES];
        //        [hackButton addTarget:self action:@selector(switchToNumberPad:) forControlEvents:UIControlEventTouchUpInside];
        //        [foundKeyboard addSubview:hackButton];
        
        if (![foundKeyboard viewWithTag:100]) {
            CGRect f = keyboard.view.frame;
            f.origin.y= 0;
            keyboard.view.frame = f;
            if (foundKeyboard.frame.size.height == 216) {
                CGRect f = keyboard.view.frame;
                f.origin.y=-20;
                keyboard.view.frame = f;
            }
            [foundKeyboard addSubview:keyboard.view];
        }
        foundKeyboard.hidden = NO;

        
        
    }
}


- (UIView *)getSystemKeyboard
{
    UIView *foundKeyboard = nil;
    
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows])
    {
        if (![[testWindow class] isEqual:[UIWindow class]])
        {
            keyboardWindow = testWindow;
            break;
        }
    }
    if (!keyboardWindow)
        return nil;
    
    for (UIView *possibleKeyboard in [keyboardWindow subviews])
    {
        //iOS3
        if ([[possibleKeyboard description] hasPrefix:@"<UIKeyboard"])
        {
            foundKeyboard = possibleKeyboard;
            break;
        }
        else
        {
            // iOS 4 sticks the UIKeyboard inside a UIPeripheralHostView.
            if ([[possibleKeyboard description] hasPrefix:@"<UIPeripheralHostView"])
            {
                int pCount = [[possibleKeyboard subviews] count] - 1;
                NSLog(@"键盘[possibleKeyboard subviews] count =  %d",pCount);
                if (pCount>=0) {
                    possibleKeyboard = [[possibleKeyboard subviews] objectAtIndex:pCount];
                }
            }
            
            if ([[possibleKeyboard description] hasPrefix:@"<UIKeyboard"])
            {
                foundKeyboard = possibleKeyboard;
                break;
            }
        }
    }
    return foundKeyboard;
}

-(void)custom_key_board_change:(NSNotification *)no{
    //ios6+ 自定义键盘不会出发change事件
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        [self addStockFieldChanged:no];
    }
}

@end
