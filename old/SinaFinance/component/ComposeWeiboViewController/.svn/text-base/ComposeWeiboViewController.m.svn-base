//
//  ComposeWeiboViewController.m
//  SinaNews
//
//  Created by shieh exbice on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ComposeWeiboViewController.h"
#import "LKLoadingCenter.h"
#import "LoginViewController.h"
#import "BCTabBarController.h"
#import "WeiboFuncPuller.h"
#import "PageControllerView.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "LKWebViewController.h"
#import "LKTipCenter.h"
#import "AppDelegate.h"

#define ComposeWeibo_sendBtn  111223

@interface ComposeWeiboViewController ()

-(void)addNavigationBtn;
-(void)initUI;
-(void)initNotification;
-(void)initData;
- (void)textViewDidChange:(UITextView *)textView;
@end

@implementation ComposeWeiboViewController

@synthesize inputView,tipLabel;
@synthesize type;
@synthesize isSnap;
@synthesize preString;
@synthesize backView;
@synthesize emotionView;
@synthesize mid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        type = ComposeType_publish;
        curCountLeft = 140;
    }
    return self;
}

-(void)dealloc
{
    [inputView release];
    [tipLabel release];
    [backView release];
    [preString release];
    [emotionView release];
    [mid release];
    
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
    self.view.backgroundColor = [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:237.0/255];
    
    [self addNavigationBtn];
    topToolbar.title = self.title;
    if (type==ComposeType_publish) {
        self.title = @"发表新微博";
        bNowordValid = NO;
    }
    else if (type==ComposeType_repost)
    {
        self.title = @"转发微博";
        bNowordValid = YES;
    }
    else if (type==ComposeType_comment)
    {
        self.title = @"评论微博";
        bNowordValid = NO;
    }
    else if (type==ComposeType_repostNews)
    {
        self.title = @"转发到微博";
        bNowordValid = NO;
    }
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

-(void)initUI
{
	self.inputView.backgroundColor = [UIColor clearColor];
    self.emotionView.delegate = self;
    [self.inputView becomeFirstResponder];
    UIButton* sendBtn = (UIButton*)[topToolbar viewWithTag:ComposeWeibo_sendBtn];
	if (bNowordValid) {
        sendBtn.enabled = YES;
    }
    else
    {
        sendBtn.enabled = NO;
    }
    self.tipLabel.text = @"140";
}

-(void)initData
{
    if (!self.preString) {
        self.inputView.text = @"";
    }
    else {
        self.inputView.text = self.preString;
    }
    [self textViewDidChange:self.inputView];
}

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(notifyKeyboardDidShow:)
			   name:UIKeyboardWillShowNotification
			 object:nil];
    
    [nc addObserver:self selector:@selector(notifyKeyboardWillHide:)
			   name:UIKeyboardWillHideNotification
			 object:nil];
    [nc addObserver:self selector:@selector(CommonWeiboSucceed:)
			   name:CommonWeiboSucceedNotification
			 object:nil];
    
    [nc addObserver:self selector:@selector(CommonWeiboFailed:)
			   name:CommonWeiboFailedNotification
			 object:nil];
    
}

-(void)addNavigationBtn
{
    topToolbar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    [self.view addSubview:topToolbar];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(closeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:backBtn];
    //微博 发送 
    UIImageView *sendImgView = [[UIImageView alloc] initWithFrame:CGRectMake(259, 5, 44+6, 34)];
    sendImgView.image = [UIImage imageNamed:@"weibo_send_btn.png"];
    [topToolbar addSubview:sendImgView];
    
    UIButton* tempBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn1.frame = CGRectMake(259, 0, 54, 40);//(285, 4, 44, 22);
//    [tempBtn1 setBackgroundImage:[UIImage imageNamed:@"weibo_send_btn.png"] forState:UIControlStateNormal];
    [tempBtn1 addTarget:self action:@selector(sendClicked:) forControlEvents:UIControlEventTouchUpInside];
    tempBtn1.tag = ComposeWeibo_sendBtn;
    //[self.navigationBar addSubview:tempBtn1];
    [topToolbar addSubview:tempBtn1];
    
}

-(void)backBtnClicked:(UIButton *)sender
{
    [[LKLoadingCenter defaultCenter] disposeLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)closeClicked:(UIButton*)sender
{
    [[LKLoadingCenter defaultCenter] disposeLoadingView];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendClicked:(UIButton*)sender
{
    BOOL hasLogined = [[WeiboLoginManager getInstance] hasLogined];
    if (hasLogined) {
        NSString* composeStr = self.inputView.text;
        NSString* userId = [[WeiboLoginManager getInstance] loginedID];
        
        NSData *imgData  =  (NSData *)[[NSUserDefaults standardUserDefaults] objectForKey:@"weibo_pic"];
        
        if (isSnap) {
            [[WeiboFuncPuller getInstance] startUserInfoWeiboWithSender2:self uid:userId username:nil info:composeStr image:imgData];
        }else{
            [[WeiboFuncPuller getInstance] startUserInfoWeiboWithSender:self uid:userId username:nil info:composeStr];
        }
        
//        [self.inputView resignFirstResponder];
//        self.emotionView.hidden = YES;
//            [SVProgressHUD showWithStatus:@"正在发送，请稍等..."];
//        [SVProgressHUD showInView:<#(UIView *)#> status:<#(NSString *)#> networkIndicator:<#(BOOL)#> posY:<#(CGFloat)#>];
        [SVProgressHUD showInView:self.view status:@"正在发送，请稍等..." networkIndicator:YES posY:100.0];
        //
    }
    else
    {
        LoginViewController* loginController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        
        [self.navigationController pushViewController:loginController animated:YES];
        [loginController release];
    }
}

-(UIImage*)getTableImage:(UIView*)realView
{
    [realView sizeToFit];
    CGSize captureSize = realView.bounds.size;
	UIGraphicsBeginImageContextWithOptions(captureSize, NO, [[UIScreen mainScreen] scale]);
    [realView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

-(void)PublishWeiboSuccessed:(NSNotification*)notify
{
    [[LKLoadingCenter defaultCenter] disposeLoadingView];
    [self closeClicked:nil];
}

-(void)emotionClicked:(id)sender
{

    if ([inputView isFirstResponder]) {
        [inputView resignFirstResponder];
        self.emotionView.hidden = NO;
    }
    else
    {
        [inputView becomeFirstResponder];
    }
}
-(void)topicClicked:(id)sender
{
    inputView.text = [inputView.text stringByAppendingString:@"#"];
    [self textViewDidChange:inputView];
}
-(void)mentionedClicked:(id)sender
{
    inputView.text = [inputView.text stringByAppendingString:@"@"];
    [self textViewDidChange:inputView];
}

-(void)view:(PageControllerView*)controlView emotionString:(NSString*)emotion
{
    inputView.text = [inputView.text stringByAppendingString:emotion];
    [self textViewDidChange:inputView];
}

#pragma mark -
#pragma mark networkCallback
-(void)CommonWeiboSucceed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    if ([senderNumber intValue]==(int)self) {
        if ([stageNumber intValue]==Stage_RequestV2_Publish) {
            [self performSelector:@selector(backBtnClicked:) withObject:nil afterDelay:1.2];
        }
        else if([stageNumber intValue]==Stage_Request_V2UserInfoWeibo)
        {
            NSString* composeStr = [userInfo valueForKey:RequsetInfo];
            if (type==ComposeType_publish)
            {
                [[WeiboFuncPuller getInstance] startPublishV2:composeStr];
            }
            else if(type==ComposeType_repost)
            {
                [[WeiboFuncPuller getInstance] startRepostV2WeiboWithID:mid content:composeStr];
            }
            else if(type==ComposeType_repostNews)
            {
                [[WeiboFuncPuller getInstance] startPublishV2:composeStr];
            }
            else
            {
                [[WeiboFuncPuller getInstance] startCommentV2WeiboWithID:mid content:composeStr];
            }
        }
    }
    
}

-(void)CommonWeiboFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
    if ([senderNumber intValue]==(int)self) {
        if ([stageNumber intValue]==Stage_RequestV2_Publish) {
//            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"网络错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
//            [alert show];
             [self.inputView becomeFirstResponder];
        }
        else if([stageNumber intValue]==Stage_Request_V2UserInfoWeibo)
        {
            NSString* topString = self.title;
            topString = [topString stringByAppendingString:@"失败了"];
//            [[LKTipCenter defaultCenter] postTopTipWithMessage:topString time:2.0 color:nil];
            [self.inputView becomeFirstResponder];
            NSNumber* errorCode = [userInfo valueForKey:RequsetError];
            if ([errorCode intValue]==RequestError_User_Not_Exists) {
                [self startOpenMindedWeibo];
            }
            else {
//                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"发送失败了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
//                [alert show];
                 [self.inputView becomeFirstResponder];
            }
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(alertView.tag==111878)
    {
        if (buttonIndex==1) {
            [self realOpenMindedWeibo];
        }
    }
}

-(void)startOpenMindedWeibo
{
    UIAlertView* anAlert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"您的帐号未开通微博功能,是否现在开通?", nil)
                                                      message: @"\n"
                                                     delegate: self
                                            cancelButtonTitle: NSLocalizedString(@"否",nil)
                                            otherButtonTitles: NSLocalizedString(@"是",nil), nil];
    anAlert.tag = 111878;
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

#pragma mark --
#pragma mark textView

- (void)textViewDidChange:(UITextView *)textView
{
    NSString* text = textView.text;
    int left = 140-[text length];
    curCountLeft = left;
    tipLabel.text = [NSString stringWithFormat:@"%d",left];
    if (curCountLeft<0) {
        tipLabel.textColor = [UIColor redColor];
    }
    else
    {
        tipLabel.textColor = [UIColor blackColor];
    }
    UIButton* sendBtn = (UIButton*)[topToolbar viewWithTag:ComposeWeibo_sendBtn];
    if (left>=140||left<0) {
        if (!bNowordValid) {
            sendBtn.enabled = NO;
        }
        else
        {
            sendBtn.enabled = YES;
        }
    }
    else
    {
        sendBtn.enabled = YES;
    }
}

#pragma mark -
#pragma mark keyboard

-(void)notifyKeyboardDidShow:(NSNotification*)note
{
    if (![inputView isFirstResponder]) {
        return;
    }
    
    NSDictionary* userInfo = [note userInfo];
    NSValue* frameEndValue = [userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect frameEnd = [frameEndValue CGRectValue];
    NSNumber* animationDurationNumber = [userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
    double animationDuration = [animationDurationNumber doubleValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.backView.frame = CGRectMake(0, 44, 320, frameEnd.origin.y-44 - 20);
    CGRect emotionRect = emotionView.frame;
    emotionRect.origin.y = self.view.frame.size.height;
    emotionView.frame = emotionRect;
    [UIView commitAnimations];
    
}

-(void)notifyKeyboardWillHide:(NSNotification*)note
{
    if (![inputView isFirstResponder]) {
        return;
    }
    
    NSDictionary* userInfo = [note userInfo];
    NSNumber* animationDurationNumber = [userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
    double animationDuration = [animationDurationNumber doubleValue];
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    CGRect emotionRect = emotionView.frame;
    emotionRect.origin.y = self.view.frame.size.height - emotionRect.size.height;
    emotionView.frame = emotionRect;
    CGRect inputBKGRect = backView.frame;
    inputBKGRect.size.height = emotionView.frame.origin.y - 44;
    backView.frame = inputBKGRect;
    [UIView commitAnimations];
    
}

@end
