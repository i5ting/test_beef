//
//  LoginViewController.m
//  SinaNews
//
//  Created by shieh exbice on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "LKLoadingCenter.h"
#import "LKTipCenter.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "SaveData.h"
#import "LKWebViewController.h"

@interface LoginViewController ()
-(void)initUI;
-(void)addNavigationBtn;
-(void)initNotification;
-(void)closeClicked:(UIButton*)sender;
@end

@implementation LoginViewController
@synthesize table,usernameCell,passwordCell,usernameField,passwordField;
@synthesize delegate,failedSelector,succeedSelector,returnSelector;
@synthesize loginMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [table release];
    [usernameCell release];
    [passwordCell release];
    [usernameField release];
    [passwordField release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:3/255.0 green:30/255.0 blue:54/255.0 alpha:1.0];
    
    [self.usernameField becomeFirstResponder];
    
    passwordField.secureTextEntry = YES;
    
    MyCustomToolbar *topToolBar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    [self.view addSubview:topToolBar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(98, 0, 125, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    titleLabel.text = @"帐号登录";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:backBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(51, 180, 110, 28);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_left_normal.png"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_left_highly.png"] forState:UIControlStateHighlighted];
    loginBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [loginBtn setTitleColor:[UIColor colorWithRed:129/255.0 green:121/255.0 blue:121/255.0 alpha:1.0] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(161, 180, 108, 28);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_right_normal.png"] forState:UIControlStateNormal];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"loginbtn_right_highly.png"] forState:UIControlStateHighlighted];
    registerBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [registerBtn setTitleColor:[UIColor colorWithRed:129/255.0 green:121/255.0 blue:121/255.0 alpha:1.0] forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [registerBtn addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
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

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self 
           selector:@selector(LoginSuccessed:) 
               name:LoginSuccessedNotification 
             object:nil];
    [nc addObserver:self 
           selector:@selector(LoginFailed:) 
               name:LoginFailedNotification 
             object:nil];
}

-(void)LoginSuccessed:(NSNotification*)notify
{
    NSNumber* stageNumber = [notify object];
    if (succeedSelector!=nil) {
        [delegate performSelector:succeedSelector];
    }
    [self backBtnClicked:nil];
    if ([delegate respondsToSelector:@selector(weiboUserLoginFinished)]) {
        [delegate weiboUserLoginFinished];
    }
}

-(void)LoginFailed:(NSNotification*)notify
{
    NSNumber* stageNumber = [notify object];
    NSDictionary* userInfo = [notify userInfo];
    NSNumber* errorCode = [userInfo valueForKey:RequsetError];
    NSString* tips = nil;
    if (errorCode&&[errorCode intValue]==ErrorCode_UserNamePassword) {
        tips = @"用户名或密码不正确";
    }
    else {
        tips = @"网络错误";
    }
    [[LKLoadingCenter defaultCenter] disposeLoadingView];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" 
                                                  message:tips
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"  
                                        otherButtonTitles:nil];
    [alert show];
    [alert release];
    if ([delegate respondsToSelector:@selector(weiboUserLoginFailed)]) {
        [delegate weiboUserLoginFailed];
    }
}

-(void)loginClicked:(UIButton*)sender
{
    NSString* userName = usernameField.text;
    NSString* password = passwordField.text;
    if (userName&&![userName isEqualToString:@""]&&password&&![password isEqualToString:@""]) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:0];
        if (loginMode==LoginMode_Weibo) {
            [dict setObject:userName forKey:Key_Login_Username];
            [dict setObject:password forKey:Key_Login_Password];
            [[WeiboLoginManager getInstance] startLogin:dict];
        }
        else {
            [dict setObject:userName forKey:Key_Login_Username];
            [dict setObject:password forKey:Key_Login_Password];
            [[WeiboLoginManager getInstance] startLogin:dict];
        }
//        [[LKLoadingCenter defaultCenter] postLoadingWithTitle:nil message:@"登录中..." ignoreTouch:YES];
        
        [SVProgressHUD showInView:self.navigationController.view status:@"登录中..."];
    }
}

-(void)registerClicked:(UIButton *)sender
{
    NSURL* url = [NSURL URLWithString:@"http://weibo.com/signup/signup.php?ps=u3&lang=zh-cn"];
    LKWebViewController *webVC = [[LKWebViewController alloc] initWithNibName:@"LKWebViewController" bundle:nil url:url];
    webVC.titleString = @"注册";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    [webVC release];
}

-(void)backBtnClicked:(UIButton *)sender
{
    
    
    MyTabBarController* tabBarController = [(AppDelegate*)[[UIApplication sharedApplication] delegate] tabBarController];
//    [tabBarController cu]

//    int a = tabBarController.;
//    tabBarController
//    NSLog(@"tabid=%d",[[AppDelegate sharedAppDelegate] getTabId]);
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];


    
    [[LKLoadingCenter defaultCenter] disposeLoadingView];
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    
//    if ([[AppDelegate sharedAppDelegate] getTabId] == 1 && !hasLogined) {
//        [[AppDelegate sharedAppDelegate] gotoTabWithIndex:0];
        [self.navigationController popToRootViewControllerAnimated:YES];
//        return;
//    }
    
}

-(void)closeClicked:(UIButton*)sender
{
    if (returnSelector!=nil) {
        [delegate performSelector:returnSelector];
    }
    [self backBtnClicked:nil];
}

#pragma mark -
#pragma mark table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowNum = indexPath.row;
    if (rowNum==0) 
    {
        return usernameCell;
    }
    else
    {
        return passwordCell;
    }
}

- (void)handleBackPressed
{
    [self closeClicked:nil];
}

@end
