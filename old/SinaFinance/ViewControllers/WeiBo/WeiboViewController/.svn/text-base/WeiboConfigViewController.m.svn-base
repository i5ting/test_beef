//
//  WeiboConfigViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WeiboConfigViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "DataListTableView.h"
#import "CommentDataList.h"
#import "BCMultiTabBar.h"
#import "WeiboFuncPuller.h"
#import "LKTipCenter.h"
#import "DataButton.h"
#import "LKWebViewController.h"

#define UserObjectRemving @"UserObjectRemving"
#define WeiboAlert_AddUser 133333
#define WeiboAlert_OpenWeibo 133334

#define WeiboConfigAddStage 188893
#define WeiboConfigListStage 188894
#define WeiboConfigVerifyStage 188895

@interface WeiboConfigViewController ()
@property(nonatomic,retain)BCMultiTabBar* curMultiTabBar;
@property(nonatomic,retain)DataListTableView* dataTableView;
@property(nonatomic,retain)CommentDataList* dataList;
@property(nonatomic,retain)NSArray* selectID;
@property(nonatomic,retain)NSMutableArray* groupID;
@property(nonatomic,retain)NSMutableArray* groupValueArray;
@property(nonatomic,retain)NSMutableArray* removingObjects;
@property(nonatomic,retain)UIButton* addUserBtn;
@property(nonatomic,retain)UIActivityIndicatorView* addIndicator;
@property(nonatomic,retain)NSMutableArray* addingUserIDs;


- (void)addToolbar;
-(void)initNotification;
-(void)initUI;
-(void)postFailedTip;
-(void)startRefreshTable:(BOOL)bForce;
-(void)startRefreshTableNoForce;
-(void)startRefreshTableWithForce;
-(NSArray*)defaultWeiboGroupNameArray;
-(void)removeFromRemovingArrayWithArray:(NSArray*)args;
@end

@implementation WeiboConfigViewController
@synthesize curMultiTabBar;
@synthesize dataTableView,dataList,selectID;
@synthesize groupList,groupID;
@synthesize groupValueArray;
@synthesize removingObjects;
@synthesize addUserBtn,addIndicator,addingUserIDs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataList = [[CommentDataList alloc] init];
        dataList.dataTableName = @"UserList";
        countPerPage = 20;
        removingObjects = [[NSMutableArray alloc] initWithCapacity:0];
        addingUserIDs = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

-(void)dealloc
{
    [curMultiTabBar release];
    [dataTableView release];
    [dataList release];
    [selectID release];
    [groupList release];
    [groupID release];
    [groupValueArray release];
    [removingObjects release];
    [addUserBtn release];
    [addIndicator release];
    [addingUserIDs release];
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
    [self initNotification];
    [self initUI];
    [self addToolbar];
    
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

-(void)initNotification
{
    if (!bInitedNotify) {
        bInitedNotify = YES;
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self 
               selector:@selector(CommonWeiboSucceed:) 
                   name:CommonWeiboSucceedNotification 
                 object:nil];
        [nc addObserver:self 
               selector:@selector(CommonWeiboFailed:) 
                   name:CommonWeiboFailedNotification
                 object:nil];
    }
}


- (void)addToolbar
{
    MyCustomToolbar *topToolbar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    topToolbar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolbar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(98, 0, 125, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    titleLabel.text = @"自定义微博";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolbar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 5, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:backBtn];
    
    UIButton* tempBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(245, 7, 60, 30)];
    [tempBtn1 setTitle:@"添加用户" forState:UIControlStateNormal];
    UIImage* btnImage = [UIImage imageNamed:@"toolbar_btn_bg.png"];
    [tempBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    tempBtn1.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [tempBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tempBtn1 addTarget:self action:@selector(addClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:tempBtn1];
    self.addUserBtn = tempBtn1;
    [tempBtn1 release];
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    CGRect indicatorRect = indicator.frame;
    indicatorRect.origin.x = 265;
    indicatorRect.origin.y = 44/2 - indicatorRect.size.height/2;
    indicator.frame = indicatorRect;
    [topToolbar addSubview:indicator];
    self.addIndicator = indicator;
    [indicator release];
}

-(void)initUI
{
    CGRect multiRect = CGRectZero;
    float multiBarHeight = 40.0;
    CGRect mainRect = self.view.bounds;
    multiRect = CGRectMake(0, 44, mainRect.size.width, multiBarHeight);
    if (!initedUI) {
        initedUI = YES;
        if (!curMultiTabBar) {
            NSArray* multiBarHeightArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:multiBarHeight], nil];
            BCMultiTabBar* newMultiTabBar = [[BCMultiTabBar alloc] initWithFrame:multiRect heights:multiBarHeightArray];
            newMultiTabBar.delegate = self;
            newMultiTabBar.selectedMovement = MovementStyle_Free;
            for (int i=0; i<[newMultiTabBar.tabBarArray count]; i++) {
                BCTabBar* oneTabBar = [newMultiTabBar.tabBarArray objectAtIndex:i];
                if (i==0) {
                    oneTabBar.selectedAlignment = AlignmentStyle_Center;
                    oneTabBar.showedMaxItem = 7;
                    oneTabBar.arrowImage = [UIImage imageNamed:@"weibo_tab_btn_selected.png"];
                    UIImage* columnBack = [UIImage imageNamed:@"weibo_tab_back.png"];
                    columnBack = [columnBack stretchableImageWithLeftCapWidth:1.0 topCapHeight:15.0];
                    oneTabBar.backgroundImage = columnBack;
                    oneTabBar.maxTabWidth = 40;
                    oneTabBar.arrowCoverScroll = NO;
                    oneTabBar.ArrowBackScrollAnimate = NO;
                    oneTabBar.leftArrowImage = [UIImage imageNamed:@"weibo_tab_left.png"];
                    oneTabBar.rightArrowImage = [UIImage imageNamed:@"weibo_tab_right.png"];
                    oneTabBar.leftRightArrowWidth = 7;
                }
            }
            self.curMultiTabBar = newMultiTabBar;
            [newMultiTabBar release];
        }
        else
        {
            multiRect = self.curMultiTabBar.frame;
        }
        [self.view addSubview:self.curMultiTabBar];
        
        if (!dataTableView) {
            int curY = multiRect.origin.y + multiRect.size.height;
            int maxHeight = self.view.bounds.size.height - curY;
            DataListTableView* dataView = [[DataListTableView alloc] initWithFrame:CGRectMake(0, curY, 320, maxHeight)];
            dataView.defaultSucBackString = @"";
            dataView.backgroundColor = [UIColor whiteColor];
            dataView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            dataView.delegate = self;
            dataView.tableView.backgroundColor = [UIColor clearColor];
            self.dataTableView = dataView;
            [dataView release];
        }
        [self.view addSubview:self.dataTableView];
    }
    else
    {
        [self.view addSubview:self.curMultiTabBar];
        int curY = multiRect.origin.y + multiRect.size.height;
        int maxHeight = self.view.bounds.size.height - curY;
        self.dataTableView.frame = CGRectMake(0, curY, 320, maxHeight);
        [self.view addSubview:self.dataTableView];
    }
    
}

-(void)cancel:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addClicked:(UIButton*)sender
{
    UIAlertView* anAlert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"请输入需要关注的帐号:", nil)
                                                      message: @"\n" 
                                                     delegate: self
                                            cancelButtonTitle: NSLocalizedString(@"否",nil)
                                            otherButtonTitles: NSLocalizedString(@"是",nil), nil];
    anAlert.tag = WeiboAlert_AddUser;
    UITextField* aPageField = [[UITextField alloc] initWithFrame:CGRectMake(20,45, 230, 25)];
    aPageField.tag = 111;
    aPageField.borderStyle = UITextBorderStyleRoundedRect;
    aPageField.autocorrectionType = UITextAutocorrectionTypeNo;
    aPageField.textAlignment = UITextAlignmentCenter;
    aPageField.clearButtonMode = UITextFieldViewModeWhileEditing;
    aPageField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [anAlert addSubview:aPageField];
    [aPageField becomeFirstResponder];
    [aPageField release];
    [anAlert show];
    [anAlert release];
}

-(void)realAddUser:(NSString*)username
{
    if (username&&![username isEqualToString:@""]) {
        [self.addIndicator startAnimating];
        self.addUserBtn.hidden = YES;
        NSMutableDictionary* addDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [addDict setValue:username forKey:@"name"];
        [addDict setValue:[self.groupID objectAtIndex:0] forKey:@"groupindex"];
        [addingUserIDs addObject:addDict];
        [addDict release];
        
        NSString* userID = [[WeiboLoginManager getInstance] loginedID];
        [[WeiboFuncPuller getInstance] startUserInfoWeiboWithSender:(id)WeiboConfigVerifyStage uid:userID username:nil info:username];
    }
    else
    {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"用户名不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {  
    if (alertView.tag==WeiboAlert_AddUser) {
        if (buttonIndex==1) {
            UITextField* aPageField = (UITextField*)[alertView viewWithTag:111];
            NSString* curString = aPageField.text;
            [self realAddUser:curString];
        }
    }
    else if(alertView.tag==WeiboAlert_OpenWeibo)
    {
        if (buttonIndex==1) {
            [self realOpenMindedWeibo];
        }
    }
}  

#pragma mark -
#pragma mark function
-(NSArray*)defaultWeiboGroupNameArray
{
    NSMutableArray* rtval = nil;
    NSArray* subNames = [self.groupList subCommentNamelistAtRowColumns:nil];
    int subCount = [subNames count];
    for (int i=0; i<subCount; i++) {
        NSArray* codeArray = [self.groupList curCommentAPICodeAtRowColumns:[NSArray arrayWithObject:[NSNumber numberWithInt:i]]];
        if (!rtval) {
            rtval = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        }
        [rtval addObject:[codeArray objectAtIndex:4]];
    }
    return rtval;
}

#pragma mark -
#pragma mark multiTabBar
-(NSArray*)multiTabBar:(BCMultiTabBar*)multiTabBar tabsForIndex:(NSIndexPath *)index
{
    NSMutableArray* rtval = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];

    NSArray* tempArray = [self.groupList subCommentNamelistAtRowColumns:nil];
    if (index.row==0) {
        if (tempArray) {
            int tempCount = [tempArray count];
            for(int i=0;i<tempCount;i++) {
                BCTab* oneTab = [[BCTab alloc] init];
                
                if (i<[tempArray count]) {
                    NSString* name = [tempArray objectAtIndex:i];
                    oneTab.nameLabel.text = name;
                }
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
    BCTabBar* tabBar = [curMultiTabBar.tabBarArray objectAtIndex:0];
    NSNumber* barIndexNum =  [NSNumber numberWithInt:[tabBar selectedColumn]];
    NSMutableArray* selectedIndexList = [[NSMutableArray alloc] initWithObjects:barIndexNum, nil];
    if (![CommentDataList checkNumberArrayEqualWithFirstArray:selectedIndexList secondArray:self.groupID])
    {
        self.groupID = selectedIndexList;
        [selectedIndexList release];
        NSTimer* timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(startRefreshTableWithForce) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(void)checkGroupList
{
    if (groupValueArray&&[groupValueArray count]>0) {
        [self startRefreshTableWithForce];
    }
    else
    {
        [[WeiboFuncPuller getInstance] startV2ObtainGroupListWithSender:(id)WeiboConfigListStage args:nil];
    }
}

-(void)startRefreshTableNoForce
{
    [self startRefreshTable:NO];
}

-(void)startRefreshTableWithForce
{
    [self startRefreshTable:YES];
}

-(void)refreshSelectedID
{
    self.selectID = nil;
    NSString* groupIDStr = nil;
    if (self.groupID&&[self.groupID count]>0) {
        NSNumber* selectedNumber = [self.groupID objectAtIndex:0];
        if (self.groupValueArray) 
        {
            if ([self.groupValueArray count]>[selectedNumber intValue]) {
                groupIDStr = [self.groupValueArray objectAtIndex:[selectedNumber intValue]];
                if (![groupIDStr isEqualToString:@""]) {
                    NSMutableArray* groupUserSelectID = [[NSMutableArray alloc] initWithObjects:groupIDStr, nil];
                    self.selectID = groupUserSelectID;
                    [groupUserSelectID release];
                }
            }
        }
    }
}

-(void)startRefreshTable:(BOOL)needGroup
{
    BOOL refreshGroup = NO;
    if (!groupValueArray&&needGroup) {
        refreshGroup = YES;
    }
    if (!refreshGroup) {
        [self refreshSelectedID];
        self.dataTableView.dataList = self.dataList;
        self.dataTableView.selectID = self.selectID;
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
        
        [self.dataTableView startLoadingUI];
        if (self.selectID) {        
            [[WeiboFuncPuller getInstance] startGroupMembersWeiboWithSender:(id)WeiboConfigListStage userID:[self.selectID objectAtIndex:0] count:countPerPage page:1 cursor:nil args:self.selectID dataList:self.dataList];
        }
        else
        {
            [self performSelector:@selector(doneLoading) withObject:nil afterDelay:0.001];
        }
    }
    else
    {
        [self checkGroupList];
    }
}

-(void)doneLoading
{
    if (!self.selectID) {
        [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
    }
}

-(void)startOpenMindedWeibo
{
    UIAlertView* anAlert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"您的帐号未开通微博功能,是否现在开通?", nil)
                                                      message: @"\n" 
                                                     delegate: self
                                            cancelButtonTitle: NSLocalizedString(@"否",nil)
                                            otherButtonTitles: NSLocalizedString(@"是",nil), nil];
    anAlert.tag = WeiboAlert_OpenWeibo;
    [anAlert show];
    [anAlert release];
}

-(void)realOpenMindedWeibo
{
    NSURL* url = [NSURL URLWithString:@"http://weibo.com/signup/full_info.php?nonick=1&lang=zh-cn"];
    LKWebViewController *webVC = [[LKWebViewController alloc] initWithNibName:@"LKWebViewController" bundle:nil url:url];
    webVC.titleString = @"开通微博";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    [webVC release];
}

#pragma mark -
#pragma mark networkCallback
-(void)CommonWeiboSucceed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    if ([senderNumber intValue]==WeiboConfigListStage) {
        if ([stageNumber intValue]==Stage_RequestV2_ObtainGroupListWeibo) {
            NSArray* array = [userInfo valueForKey:RequsetArray];
            NSMutableArray* tempArray = [[NSMutableArray alloc] initWithCapacity:0];
            NSArray* nameArray = [self defaultWeiboGroupNameArray];
            for (int i=0; i<[nameArray count]; i++) {
                NSString* oneName = [nameArray objectAtIndex:i];
                BOOL hasFound = NO;
                for (NewsObject* oneObject in array) {
                    NSString* groupidstr = [oneObject valueForKey:WeiboGroup_idstr];
                    NSString* groupname = [oneObject valueForKey:WeiboGroup_name];
                    if ([groupname isEqualToString:oneName]) {
                        [tempArray addObject:groupidstr];
                        hasFound = YES;
                        break;
                    }
                }
                if (!hasFound) {
                    [tempArray addObject:@""];
                }
            }
            self.groupValueArray = tempArray;
            [tempArray release];
            [self startRefreshTable:NO];
        }
        else if([stageNumber intValue]==Stage_Request_V2GroupMembersWeibo)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
                NSArray* array = [userInfo valueForKey:RequsetArray];
                curPage = [pageNumber intValue];
                if ([pageNumber intValue]<=1) 
                {
                    [self.dataTableView scrollTop:NO];
                }
                if ([array count]<countPerPage) {
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:YES];
                }
                else
                {
                    [self.dataTableView doneLoadingWithReloadTable:YES pageEnd:NO];
                }
            }
        }
        else if([stageNumber intValue]==Stage_Request_V2RemoveGroupMemberWeibo)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            [self removeFromRemovingArrayWithArray:args];
            
            [self startRefreshTable:NO];
        }
    }
    else if([senderNumber intValue]==WeiboConfigVerifyStage)
    {
        if([stageNumber intValue]==Stage_Request_V2UserInfoWeibo)
        {
            NSString* username = [userInfo valueForKey:RequsetInfo];
            [[WeiboFuncPuller getInstance] startUserInfoWeiboWithSender:(id)WeiboConfigAddStage uid:nil username:username info:nil];
        }
    }
    else if([senderNumber intValue]==WeiboConfigAddStage)
    {
        if([stageNumber intValue]==Stage_Request_V2UserInfoWeibo)
        {
            NSArray* objectArray = [userInfo objectForKey:RequsetArray];
            if ([objectArray count]>0) {
                NSString* userID = [[objectArray lastObject] valueForKey:WeiboUserObject_idstr];
                NSString* name = [[objectArray lastObject] valueForKey:WeiboUserObject_screen_name];
                NSMutableDictionary* addDict = [addingUserIDs lastObject];
                NSString* oldName = [addDict valueForKey:@"name"];
                [addDict setValue:userID forKey:@"uid"];
                [[WeiboFuncPuller getInstance] startV2ObtainGroupListWithSender:(id)WeiboConfigAddStage args:nil];
            }
        }
        else if ([stageNumber intValue]==Stage_RequestV2_ObtainGroupListWeibo) {
            NSString* curGroupStr = nil;
            NSArray* array = [userInfo valueForKey:RequsetArray];
            NSMutableArray* tempArray = [[NSMutableArray alloc] initWithCapacity:0];
            NSArray* nameArray = [self defaultWeiboGroupNameArray];
            NSMutableDictionary* addDict = [addingUserIDs lastObject];
            NSNumber* groupNumber = [addDict valueForKey:@"groupindex"];
            NSString* uid = [addDict valueForKey:@"uid"];
            for (int i=0; i<[nameArray count]; i++) {
                NSString* oneName = [nameArray objectAtIndex:i];
                BOOL hasFound = NO;
                for (NewsObject* oneObject in array) {
                    NSString* groupidstr = [oneObject valueForKey:WeiboGroup_idstr];
                    NSString* groupname = [oneObject valueForKey:WeiboGroup_name];
                    if ([groupname isEqualToString:oneName]) {
                        [tempArray addObject:groupidstr];
                        hasFound = YES;
                        break;
                    }
                }
                if (!hasFound) {
                    [tempArray addObject:@""];
                }
                if ([groupNumber intValue]==i) {
                    curGroupStr = [tempArray lastObject];
                    [addDict setValue:curGroupStr forKey:@"group"];
                }
            }
            BOOL needReloadList = YES;
            NSNumber* selectedNumber = [self.groupID objectAtIndex:0];
            if ([tempArray count]>[selectedNumber intValue]&&groupValueArray&&[self.groupValueArray count]>[selectedNumber intValue]) {
                NSString* oldGroupValue = [self.groupValueArray objectAtIndex:[selectedNumber intValue]];
                NSString* newGroupValue = [tempArray objectAtIndex:[selectedNumber intValue]];
                if ([newGroupValue isEqualToString:oldGroupValue]) {
                    needReloadList = NO;
                }
            }
            if (curGroupStr&&![curGroupStr isEqualToString:@""]) {
                self.groupValueArray = tempArray;
            }
            [tempArray release];
//            if (needReloadList) 
            if (NO)
            {
                [self startRefreshTable:NO];
            }
            if (curGroupStr&&![curGroupStr isEqualToString:@""]) {
                [[WeiboFuncPuller getInstance] startCreateFriendshipWeiboWithSender:(id)WeiboConfigAddStage uid:uid username:nil];
            }
            else
            {
                NSString* oneName = [nameArray objectAtIndex:[groupNumber intValue]];
                [[WeiboFuncPuller getInstance] startCreateGroupWeiboWithSender:(id)WeiboConfigAddStage groupName:oneName];
            }
        }
        else if([stageNumber intValue]==Stage_Request_V2CreateGroupWeibo)
        {
            [[WeiboFuncPuller getInstance] startV2ObtainGroupListWithSender:(id)WeiboConfigAddStage args:nil];
        }
        else if([stageNumber intValue]==Stage_Request_V2CreateFriendshipWeibo)
        {
            NSMutableDictionary* addDict = [addingUserIDs lastObject];
            NSString* group = [addDict valueForKey:@"group"];
            NSString* uid = [addDict valueForKey:@"uid"];
            [[WeiboFuncPuller getInstance] startAddGroupMemberWeiboWithSender:(id)WeiboConfigAddStage userid:uid groupid:group];
        }
        else if([stageNumber intValue]==Stage_Request_V2AddGroupMemberWeibo)
        {
            NSMutableDictionary* addDict = [addingUserIDs lastObject];
            NSNumber* groupNumber = [addDict valueForKey:@"groupindex"];
            if ([groupNumber intValue]==[(NSNumber*)[self.groupID objectAtIndex:0] intValue]) {
                [self startRefreshTable:NO];
            }
            [addingUserIDs removeLastObject];
            self.addUserBtn.hidden = NO;
            [self.addIndicator stopAnimating];
        }
    }
}

-(void)CommonWeiboFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    NSNumber* errorNumber = [userInfo objectForKey:RequsetError];
    if ([senderNumber intValue]==WeiboConfigListStage) {
        if ([stageNumber intValue]==Stage_RequestV2_ObtainGroupListWeibo)
        {
            if ([errorNumber intValue]==RequestError_Account_Not_Open)
            {
                [self startRefreshTable:NO];
            }
            else {
                [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                [self startRefreshTable:NO];
            }
        }
        else if([stageNumber intValue]==Stage_Request_V2GroupMembersWeibo)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if ([CommentDataList checkNumberArrayEqualWithFirstArray:args secondArray:self.selectID]) {
                [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
            }
        }
        else if([stageNumber intValue]==Stage_Request_V2RemoveGroupMemberWeibo)
        {
            NSIndexPath* reloadPath = nil;
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            if (self.selectID) {
                NSString* oldGroupID = [args objectAtIndex:0];
                NSString* oldUserID = [args objectAtIndex:1];
                NSString* curGroupID = [self.selectID objectAtIndex:0];
                NSArray* indexPaths = [self.dataTableView.tableView indexPathsForVisibleRows];
                if ([oldGroupID isEqualToString:curGroupID]) {
                    for (NSIndexPath* path in indexPaths) {
                        int rowInt = path.row;
                        NewsObject* oneObject = [self.dataList oneObjectWithIndex:rowInt IDList:self.selectID];
                        NSString* curUserID = [oneObject valueForKey:WeiboUserObject_idstr];
                        if (curUserID&&[curUserID isEqualToString:oldUserID]) {
                            reloadPath = path;
                            break;
                        }
                    }
                }
            }
            [self removeFromRemovingArrayWithArray:args];
            [self.dataTableView.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:reloadPath] withRowAnimation:UITableViewRowAnimationNone];
            [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"删除出错了!" time:1.0 ignoreAddition:NO pView:self.dataTableView];
        }
    }
    else if([senderNumber intValue]==WeiboConfigVerifyStage)
    {
        if([stageNumber intValue]==Stage_Request_V2UserInfoWeibo)
        {
            self.addUserBtn.hidden = NO;
            [self.addIndicator stopAnimating];
            NSNumber* errorCode = [userInfo valueForKey:RequsetError];
            if ([errorCode intValue]==RequestError_User_Not_Exists) {
                [self startOpenMindedWeibo];
            }
            else {
                [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"关注出错了!" time:1.0 ignoreAddition:NO pView:self.dataTableView];
            }
        }
    }
    else if([senderNumber intValue]==WeiboConfigAddStage)
    {
        [addingUserIDs removeLastObject];
        if (stageNumber) {
            if([stageNumber intValue]==Stage_Request_V2UserInfoWeibo)
            {
                self.addUserBtn.hidden = NO;
                [self.addIndicator stopAnimating];
                if (errorNumber&&[errorNumber intValue]==RequestError_User_Not_Exists) {
                    NSString* tips = @"该用户不存在!";
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" 
                                                                  message:tips
                                                                 delegate:nil
                                                        cancelButtonTitle:@"确定"  
                                                        otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
                else
                {
                    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"关注出错了!" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                }
            }
            else if([stageNumber intValue]==Stage_Request_V2CreateGroupWeibo)
            {
                self.addUserBtn.hidden = NO;
                [self.addIndicator stopAnimating];
                [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"关注出错了!" time:1.0 ignoreAddition:NO pView:self.dataTableView];
            }
            if([stageNumber intValue]==Stage_Request_V2CreateFriendshipWeibo)
            {
                self.addUserBtn.hidden = NO;
                [self.addIndicator stopAnimating];
                [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"关注出错了!" time:1.0 ignoreAddition:NO pView:self.dataTableView];
            }
            else if([stageNumber intValue]==Stage_Request_V2AddGroupMemberWeibo)
            {
                self.addUserBtn.hidden = NO;
                [self.addIndicator stopAnimating];
                [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"关注出错了!" time:1.0 ignoreAddition:NO pView:self.dataTableView];
            }
            else if([stageNumber intValue]==Stage_RequestV2_ObtainGroupListWeibo)
            {
                if ([errorNumber intValue]==RequestError_Account_Not_Open) {
                    self.addUserBtn.hidden = NO;
                    [self.addIndicator stopAnimating];
                    [self startOpenMindedWeibo];
                }
                else {
                    self.addUserBtn.hidden = NO;
                    [self.addIndicator stopAnimating];
                    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"关注出错了!" time:1.0 ignoreAddition:NO pView:self.dataTableView];
                }
            }
        }
    }
}

-(void)postFailedTip
{
    [[LKTipCenter defaultCenter] postSmallCenterTipWithMessage:@"网络错误" time:1.0 ignoreAddition:NO pView:self.dataTableView];
}

-(void)removeFromRemovingArrayWithArray:(NSArray*)args
{
    NSString* oldGroupID = [args objectAtIndex:0];
    NSString* oldUserID = [args objectAtIndex:1];
    for (NewsObject* oneObject in removingObjects) {
        NSString* curGroupID = [oneObject userInfoValueForKey:WeiboGroup_idstr];
        NSString* curUserID = [oneObject valueForKey:WeiboUserObject_idstr];
        if ([curGroupID isEqualToString:oldGroupID]&&[oldUserID isEqualToString:curUserID]) {
            [removingObjects removeObject:oneObject];
            break;
        }
    }
}

#pragma mark -
#pragma mark DataListTableView
-(UITableViewCell*)dataListView:(DataListTableView*)view cellForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    int rowNum = path.row;
    NSString* name = [object valueForKey:WeiboUserObject_name];
    NSString* userIdentifier = @"textIdentifier";
    UITableViewCell* cell = (UITableViewCell*)[view.tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DataButton* btn = [[DataButton alloc] init];
        btn.frame = CGRectMake(280, 5, 34, 34);
        UIImage* removeImage = [UIImage imageNamed:@"weibo_remove.png"];
        [btn setImage:removeImage forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 12321;
        [cell.contentView addSubview:btn];
        [btn release];
        UILabel* textLabel = [[UILabel alloc] init];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.tag = 11331;
        textLabel.frame = CGRectMake(10, 7, 225, 30);
        [cell.contentView addSubview:textLabel];
        [textLabel release];
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.tag = 11334;
        CGRect indicatorRect = indicator.frame;
        indicatorRect.origin.x = 285;
        indicatorRect.origin.y = 44/2 - indicatorRect.size.height/2;
        indicator.frame = indicatorRect;
        [cell.contentView addSubview:indicator];
        [indicator release];
    }
    UILabel* textLabel = (UILabel*)[cell viewWithTag:11331];
    if ([name isKindOfClass:[NSNull class]]) {
        name = @"";
    }
    textLabel.text = name;
    DataButton* btn = (DataButton*)[cell.contentView viewWithTag:12321];
    btn.data = path;
    UIActivityIndicatorView* indicator = (UIActivityIndicatorView*)[cell.contentView viewWithTag:11334];
    BOOL contant = [removingObjects containsObject:object];
    if (contant) {
        btn.hidden = YES;
        [indicator startAnimating];
    }
    else
    {
        [indicator stopAnimating];
        btn.hidden = NO;
    }
    return cell;
}

-(CGFloat)dataListView:(DataListTableView*)view heightForIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    return 44;
}

-(void)dataListView:(DataListTableView*)view didSelectedAtIndexPath:(NSIndexPath*)path object:(NewsObject*)object
{
    //    [view.tableView deselectRowAtIndexPath:path animated:YES];
    
}

-(void)dataListViewDidMoreClicked:(DataListTableView*)view
{
    if (self.selectID) {
        [[WeiboFuncPuller getInstance] startGroupMembersWeiboWithSender:(id)WeiboConfigListStage userID:[self.selectID objectAtIndex:0] count:countPerPage page:curPage+1 cursor:nil args:self.selectID dataList:self.dataList];
    }
    else
    {
        [self.dataTableView doneLoadingWithReloadTable:NO pageEnd:NO];
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

-(void)cancelBtnClicked:(DataButton*)sender
{
    NSIndexPath* indexPath = [sender data];
    NewsObject* newsObject = [self.dataList oneObjectWithIndex:indexPath.row IDList:self.selectID];
    
    NSString* userid = [newsObject valueForKey:WeiboUserObject_idstr];
    if (userid&&![userid isEqualToString:@""]) {
        if (![removingObjects containsObject:newsObject]) {
            [removingObjects addObject:newsObject];
        }
        [newsObject setUserInfoValue:[self.selectID objectAtIndex:0] forKey:WeiboGroup_idstr];
        [self.dataTableView.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [[WeiboFuncPuller getInstance] startRemoveGroupMemberWeiboWithSender:(id)WeiboConfigListStage userid:userid groupid:[self.selectID objectAtIndex:0]];
    }
    
}

@end
