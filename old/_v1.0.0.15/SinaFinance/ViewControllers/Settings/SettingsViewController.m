//
//  SettingsViewController.m
//  SinaFinance
//
//  Created by Du Dan on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "LKWebViewController.h"
#import "IntervalSelectionViewController.h"
#import "RegValueSaver.h"
#import "SaveData.h"
#import "WeiboLoginManager.h"
#import "NewsFavoriteViewController.h"
#import "UpdateModule.h"
#import "gDefines.h"
#import "MyTabBarController.h"
#import "AppDelegate.h"
#import "NewhandViewController.h"
#import "NewsContentViewController2.h"

#define ViewTag_Of_Cell_SwitchView_Label 1001
#define ViewTag_Of_Cell_SwitchView_Switch 1002


@implementation SettingsViewController
@synthesize pushSwitch;

static NSString *about_items[] = {@"版本",@"许可协议",@"隐私策略",@"发送反馈",@"检查更新"};


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
        self.title = @"设置";
        self.tabBarItem.image = [UIImage imageNamed:@"settings_icon.png"];
        [self initNotification];
    }
    return self;
}

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self 
		   selector:@selector(PushStartupFailed:) 
			   name:PushStartupFailedNotification 
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
           selector:@selector(PushValueChanged:) 
               name:PushValueChangedNotification
             object:nil];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [settingsTable release];
    [pushSwitch release];
    [super dealloc];
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
    self.navigationController.navigationBarHidden = YES;
    
    MyCustomToolbar *topToolBar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    
    UIImageView *logo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sina_logo.png"]] autorelease];
    logo.frame = CGRectMake(15, 8, 38, 27);
    logo.contentMode = UIViewContentModeScaleToFill;
    [topToolBar addSubview:logo];
    
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(60, 0, 200, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"设置";
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolBar addSubview:titleLabel];

    settingsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, UI_MAX_HEIGHT-110.0f) style:UITableViewStyleGrouped];
    settingsTable.delegate = self;
    settingsTable.dataSource = self;
    [self.view addSubview:settingsTable];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
    [tabBarController setTabBarHiden:NO];
    [settingsTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)LoginSuccessed:(NSNotification*)notify
{
    [settingsTable reloadData];
//    [[StockListViewController2 sharedInstance] initView];
}

-(void)LogoutSuccessed:(NSNotification*)notify
{
    [settingsTable reloadData];
}

-(void)PushValueChanged:(NSNotification*)notify
{
    BOOL bOn = self.pushSwitch.on;
    NSNumber* onNumber = [[RegValueSaver getInstance] readSystemInfoForKey:PushEnabledKey];
    BOOL newOn = [onNumber boolValue];
    if (newOn!=bOn) {
        [pushSwitch removeTarget:self action:@selector(pushValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.pushSwitch.on = newOn;
        [pushSwitch addTarget:self action:@selector(pushValueChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
}


-(UITableViewCell*)switchCellWithTable:(UITableView*)tableView
{
    UITableViewCell* cell = nil;
    NSString* Identifier_switchcell = @"switchcell";
    cell = [tableView dequeueReusableCellWithIdentifier:Identifier_switchcell];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier_switchcell] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView* pushView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        pushView.backgroundColor = [UIColor clearColor];
        pushView.frame = cell.contentView.frame;
        UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        tipLabel.tag = ViewTag_Of_Cell_SwitchView_Label;
        tipLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        //tipLabel.textColor = [UIColor colorWithRed:20/255.0 green:70/255.0 blue:140/255.0 alpha:1.0];
        tipLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [pushView addSubview:tipLabel];
        [tipLabel release];
        UISwitch* newSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(51, 0, 50, 20)];
        newSwitch.tag = ViewTag_Of_Cell_SwitchView_Switch;
        newSwitch.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [pushView addSubview:newSwitch];
        [newSwitch release];
        tipLabel.frame = CGRectMake(10, 0,pushView.frame.size.width - newSwitch.frame.size.width - 40,pushView.frame.size.height);
        tipLabel.backgroundColor = [UIColor clearColor];
        newSwitch.frame = CGRectMake(pushView.frame.size.width - newSwitch.frame.size.width - 30, (pushView.frame.size.height - newSwitch.frame.size.height)/2, newSwitch.frame.size.width,pushView.frame.size.height);
        [cell.contentView addSubview:pushView];
        [pushView release];
    }
    return cell;
}

#pragma mark
#pragma mark UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"帐号管理";
            break;
        case 1:
            return @"功能设置";
            break;
        case 2:
            return @"高级设置";
            break;
        case 3:
            return @"关于";
            break;
        default:
            break;
    }
    return @"";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        BOOL hasLogin = [[WeiboLoginManager getInstance] hasLogined];
        if(hasLogin)
        {
            return 2;
        }
        else
        {
            return 1;
        }
        
    }
    else if(section == 1){
        return 2;
    }
    else if(section == 2){
        return 3;
    }
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = nil;
    if (cell == nil) {
        if( (indexPath.section == 2 && indexPath.row == 0) || (indexPath.section == 1 && indexPath.row == 0) ||(indexPath.section == 3 && indexPath.row == 0)){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        else{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if(indexPath.section == 0){//Weibo account
        if ([[WeiboLoginManager getInstance] hasLogined]) {
            int rowNum = indexPath.row;
            if (rowNum==0) {
                NSString* userIdentifier = @"textIdentifier";
                cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:userIdentifier];
                if (!cell) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userIdentifier] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.textLabel.text = [NSString stringWithFormat:@"帐号:%@",[[WeiboLoginManager getInstance] loginedAccount]];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.textAlignment = UITextAlignmentLeft;
            }
            else
            {
                NSString* userIdentifier = @"centerIdentifier";
                cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:userIdentifier];
                if (!cell) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userIdentifier] autorelease];
                }
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                cell.textLabel.text = @"注销";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else
        {
            NSString* userIdentifier = @"loginIdentifier";
            cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:userIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userIdentifier] autorelease];
            }
            cell.textLabel.text = @"登录";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textAlignment = UITextAlignmentLeft;
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row==0)
        {
            NSString* userIdentifier = @"favoriteIdentifier";
            cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:userIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userIdentifier] autorelease];
                cell.textLabel.textAlignment = UITextAlignmentCenter;
            }
            cell.textLabel.text = @"收藏";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            cell = [self switchCellWithTable:tableView];
            UISwitch* aSwitch = (UISwitch*)[cell.contentView viewWithTag:ViewTag_Of_Cell_SwitchView_Switch];
            UILabel* aLabel = (UILabel*)[cell.contentView viewWithTag:ViewTag_Of_Cell_SwitchView_Label];
            aLabel.text = @"开启推送";
            if (aSwitch!=nil)
            {
                [aSwitch removeTarget:self action:@selector(pushValueChanged:) forControlEvents:UIControlEventValueChanged];
                [aSwitch addTarget:self action:@selector(pushValueChanged:) forControlEvents:UIControlEventValueChanged];
                self.pushSwitch = aSwitch;
                NSNumber* pushEabledNumber = [[RegValueSaver getInstance] readSystemInfoForKey:PushEnabledKey];
                [aSwitch setOn:[pushEabledNumber boolValue]];
            }
        }
    }
    else if(indexPath.section == 2){
        if(indexPath.row == 0){
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.text = @"刷新时间";
            NSString *interval = @"";
            if([ShareData sharedManager].refreshInterval > 0){
                interval = [NSString stringWithFormat:@"%d秒", [ShareData sharedManager].refreshInterval];
            }
            else{
                interval = @"停止自动刷新";
            }
            cell.detailTextLabel.text = interval;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row == 1){
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"全部红涨绿跌";
            UISwitch *colorSwitch = [[[UISwitch alloc] init] autorelease];
            colorSwitch.on = [ShareData sharedManager].isColorSetted;
            [colorSwitch addTarget:self action:@selector(handleColorChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = colorSwitch;
//            cell.detailTextLabel.text = @"";
        }
        else if(indexPath.row == 2){
            //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSString* userIdentifier = @"favoriteIdentifier";
            cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:userIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userIdentifier] autorelease];
                cell.textLabel.textAlignment = UITextAlignmentCenter;
            }
            cell.textLabel.text = @"新手指南";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else{
        cell.textLabel.text = about_items[indexPath.row];
        if(indexPath.row == 0){
            NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];

#ifdef DEBUG
            cell.detailTextLabel.text = version;
#else
            NSArray* versionArray = [version componentsSeparatedByString:@"."];
            NSMutableArray* newVersions = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i=0; i<4&&i<[versionArray count]; i++) {
                [newVersions addObject:[versionArray objectAtIndex:i]];
            }
            version = [newVersions componentsJoinedByString:@"."];
            cell.detailTextLabel.text = version;
#endif
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else if(indexPath.row == 4){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){ //Weibo account
        if ([[WeiboLoginManager getInstance] hasLogined]) 
        {
            int rowNum = indexPath.row;
            if (rowNum==1) {
                UIAlertView* anAlert = [[[UIAlertView alloc] initWithTitle: nil
                                                                   message: NSLocalizedString(@"是否注销当前登录帐号?", nil)
                                                                  delegate: self
                                                         cancelButtonTitle: NSLocalizedString(@"是",nil)
                                                         otherButtonTitles: NSLocalizedString(@"否",nil), nil] autorelease];
                [anAlert show];
            }
        }
        else
        {
            MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
            [tabBarController setTabBarHiden:YES];
            LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            loginController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginController animated:YES];
            [loginController release];
        }
    }
    else if(indexPath.section == 1){
        if(indexPath.row == 0){
            if ([[WeiboLoginManager getInstance] hasLogined]) 
            {
                MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
                [tabBarController setTabBarHiden:YES];
                NewsFavoriteViewController* FavoriteController = [[NewsFavoriteViewController alloc] init];
                FavoriteController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:FavoriteController animated:YES];
                [FavoriteController release];
            }
            else
            {
                MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
                [tabBarController setTabBarHiden:YES];
                LoginViewController* loginer = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                loginer.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginer animated:YES];
                [loginer release];
            }
        }
    }
    else if(indexPath.section == 2){
        if(indexPath.row == 0){
            MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
            [tabBarController setTabBarHiden:YES];
            IntervalSelectionViewController *intervalController = [[[IntervalSelectionViewController alloc] init] autorelease];
            intervalController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:intervalController animated:YES];
        }
        else if(indexPath.row == 2)
        {
            MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
            [tabBarController setTabBarHiden:YES];
            NewhandViewController* loginer = [[NewhandViewController alloc] init];
            loginer.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginer animated:YES];
            [loginer release];
        }
    }
    else if(indexPath.section == 3){
        switch (indexPath.row) {
            case 0:
                break;
            case 1://http://3g.sina.com.cn/3g/pro/index.php?sa=t254d1919v150
            {
                MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
                [tabBarController setTabBarHiden:YES];
                NSURL* url = [NSURL URLWithString:@"http://3g.sina.com.cn/3g/pro/index.php?sa=t254d1919v150"];
                LKWebViewController *webVC = [[LKWebViewController alloc] initWithNibName:@"LKWebViewController" bundle:nil url:url];
                webVC.titleString = @"许可协议";
                webVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webVC animated:YES];
                [webVC release];
            }
                break;
            case 2://http://pro.sina.cn/?sa=t254d1921v150
            {
                MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
                [tabBarController setTabBarHiden:YES];
                
                NSURL* url = [NSURL URLWithString:@"http://pro.sina.cn/?sa=t254d1921v150"];
                LKWebViewController *webVC = [[LKWebViewController alloc] initWithNibName:@"LKWebViewController" bundle:nil url:url];
                webVC.titleString = @"隐私政策";
                webVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webVC animated:YES];
                [webVC release];
            }
                break;
            case 3://http://3g.sina.com.cn/prog/wapsite/message/prog/userMesgList.php?titleId=368&pos=17&vt=4
            {
                MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
                [tabBarController setTabBarHiden:YES];
                //TODO:
                NSURL* url = [NSURL URLWithString:@"http://dp.sina.cn/dpool/messagev2/index.php?boardid=41"];//new start v.2.4.0.55
                //NSURL* url = [NSURL URLWithString:@"http://3g.sina.com.cn/prog/wapsite/message/prog/userMesgList.php?titleId=368&pos=17&vt=4"];
                LKWebViewController *webVC = [[LKWebViewController alloc] initWithNibName:@"LKWebViewController" bundle:nil url:url];
                webVC.titleString = @"发送反馈";
                webVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webVC animated:YES];
                [webVC release];
            }
                break;
            case 4:
            {
                [[UpdateModule getInstance] startCheckUpdate:YES];
            }
                break;
            default:
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self performSelector:@selector(logoutClicked)];
        
    }
}

-(void)logoutClicked
{
    [[WeiboLoginManager getInstance] startLogout];
    [SVProgressHUD showInView:self.view status:@"正在注销..."];
}

- (void)handleColorChanged:(id)sender
{
    UISwitch *colorSwitch = (UISwitch*)sender;
    [SaveData saveDataForKey:SETTINGS_COLOR_KEY data:[NSNumber numberWithBool:colorSwitch.on]];
    [ShareData sharedManager].isColorSetted = colorSwitch.on;
}

#pragma mark
#pragma mark push
-(void)pushValueChanged:(id)sender
{
	BOOL pushEnabled = [((UISwitch*)sender) isOn];
	NSNumber* pushEnabledNumber = [NSNumber numberWithBool:pushEnabled];
	[[RegValueSaver getInstance] saveSystemInfoValue:pushEnabledNumber forKey:PushEnabledKey encryptString:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:PushValueChangedNotification object:pushEnabledNumber];
}

- (void)PushStartupFailed: (NSNotification*)note
{
    NSNumber* onNumber = [[RegValueSaver getInstance] readSystemInfoForKey:PushEnabledKey];
	[self.pushSwitch setOn:[onNumber boolValue] animated:YES];
}

@end
