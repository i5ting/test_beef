//
//  UserLoginViewController.m
//  SinaFinance
//
//  Created by Du Dan on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UserLoginViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Util.h"
#import "MyStockDataParser.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "NSDictionary_JSONExtensions.h"
#import "SaveData.h"


#define MYSTOCK_LOGIN_URL @"https://login.sina.com.cn/sso/login.php"//@"https://login.sina.com.cn/sso/login.php?entry=uc&username=%@&password=%@&returntype=TEXT2"//



@implementation UserLoginViewController

@synthesize delegate;

- (void)postLoginRequest
{
//    NSString *pswString = [Util convertToSHA1:passwordField.text];
//    NSString *urlString = [NSString stringWithFormat:MYSTOCK_LOGIN_URL];//,usernameField.text, passwordField.text];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:MYSTOCK_LOGIN_URL]] autorelease];
    [request setPostValue:@"finance_client" forKey:@"entry"];
    [request setPostValue:usernameField.text forKey:@"username"];
    [request setPostValue:passwordField.text forKey:@"password"];
    [request setPostValue:@"finance" forKey:@"service"];
    [request setPostValue:@"TEXT" forKey:@"returntype"];
    request.requestMethod = @"POST";
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    request.stringEncoding = enc;
    request.delegate = self;
    [request startAsynchronous];
}

- (void)requestMyStockWithURL:(NSString*)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    [request startAsynchronous];
    
    NSLog(@"url: %@", [url absoluteString]);
    
    //NSLog(@"md5: %@", [Util md5:MD5_STRING]);
}

#pragma mark
#pragma mark ASIHTTPRequest Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = request.responseString;
    NSData *responseData = request.responseData;
    NSError *error = nil;
    NSDictionary *resultJSON = [NSDictionary dictionaryWithJSONData:request.responseData error:nil];
    
    NSString *reason = [NSString stringWithFormat:@"%@", [Util decodeUTF8String:[resultJSON objectForKey:@"reason"]]];
    NSLog(@"reason: %@", reason);
    
    NSDictionary *json = [NSDictionary dictionaryWithJSONData:responseData error:&error];
    NSString *ticket = [json objectForKey:@"ticket"];
    if(error == nil && ticket){
        [ShareData sharedManager].myStockTicket = ticket;//json objectForKey:@"ticket"];
        [ShareData sharedManager].myStockUserName = usernameField.text;
        [ShareData sharedManager].myStockPassword = passwordField.text;
        [SaveData saveDataForKey:MYSTOCK_USERNAME_KEY data:[ShareData sharedManager].myStockUserName];
        [SaveData saveDataForKey:MYSTOCK_PASSWORD_KEY data:[ShareData sharedManager].myStockPassword];
        [delegate myStockUserLoginFinished];
    }
    else{
        //[delegate myStockUserLoginFailed];
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"用户或密码不对，请确认后重试。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"responseString: %@",[Util decodeUTF8String:request.responseString]);
    //[delegate myStockUserLoginFailed];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"登录操作失败。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
    [alert show];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    MyCustomToolbar *topToolBar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(60, 0, 200, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"新浪帐号登录";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 5, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:backBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(245, 7, 60, 30);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"toolbar_btn_bg.png"] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [loginBtn addTarget:self action:@selector(handleLoginPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:loginBtn];
    
    UITableView *loginTable = [[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, UI_MAX_HEIGHT -110) style:UITableViewStyleGrouped] autorelease];
    loginTable.delegate = self;
    loginTable.dataSource = self;
    loginTable.allowsSelection = NO;
    [self.view addSubview:loginTable];
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

- (void)handleBackPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleLoginPressed
{
    if(usernameField.text.length > 0 && passwordField.text.length > 0){
        [self postLoginRequest];
    }
    else{
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"用户名和密码不能为空。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alert show];
    }
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

#pragma mark
#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        NSString *text = @"";
        if(indexPath.row == 0){
            text = @"用户名：";
        }
        else{
            text = @"密码：";
        }
        UILabel *label = [[[UILabel alloc] init] autorelease];
        label.text = text;
        label.frame = CGRectMake(15, 0, 80, 43);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentRight;
        [cell.contentView addSubview:label];
        
        UITextField *textField = [[[UITextField alloc] initWithFrame:CGRectMake(90, 13, 540, 30)] autorelease];
        [cell.contentView addSubview:textField];
        textField.delegate = self;
        if(indexPath.row == 0){
            usernameField = textField;
        }
        else{
            textField.secureTextEntry = YES;
            passwordField = textField;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    return YES;
}


@end
