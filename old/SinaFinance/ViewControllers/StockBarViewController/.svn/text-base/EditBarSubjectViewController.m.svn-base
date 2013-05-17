//
//  EditBarSubjectViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EditBarSubjectViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "StockBarPuller.h"
#import <QuartzCore/QuartzCore.h>
#import "LKTipCenter.h"

@interface EditBarSubjectViewController ()
@property(nonatomic,retain)UIActivityIndicatorView* sendIndicator;
@property(nonatomic,retain)UIButton* sendBtn;
-(void)initNotification;
- (void)createToolbar;
@end

@implementation EditBarSubjectViewController
{
    UIActivityIndicatorView* sendIndicator;
    UIButton* sendBtn;
}
@synthesize stockName,stockNick,bid,tid,quotePid;
@synthesize sendIndicator,sendBtn;
@synthesize titleView,contentView;

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
    [stockNick release];
    [stockName release];
    [bid release];
    [tid release];
    [quotePid release];
    [sendIndicator release];
    [sendBtn release];
    [titleView release];
    [contentView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createToolbar];
    [self initNotification];
    
    contentTextView.layer.borderWidth = 1;    
    contentTextView.layer.borderColor= [[UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1.0] CGColor]; 
    
    if (tid) {
        self.titleView.hidden = YES;
        CGRect titleRect = self.titleView.frame;
        CGRect contentRect = self.contentView.frame;
        NSInteger bottom = contentRect.origin.y+contentRect.size.height;
        contentRect.origin.y = titleRect.origin.y;
        contentRect.size.height = bottom - contentRect.origin.y;
        self.contentView.frame = contentRect;
        [contentTextView becomeFirstResponder];
    }
    else {
        [titleTextView becomeFirstResponder];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)createToolbar
{
    MyCustomToolbar* topToolBar = [[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    [topToolBar release];
    
    if (self.tid) {
        topToolBar.title = @"回复原帖";
    }
    else {
        topToolBar.title = @"发布新帖";
    }
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:backBtn];
    
    UIButton *sendBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn1.frame = CGRectMake(265, 7, 40, 30);
    [sendBtn1 setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn1 setBackgroundImage:[UIImage imageNamed:@"toolbar_btn_bg.png"] forState:UIControlStateNormal];
    sendBtn1.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [sendBtn1 addTarget:self action:@selector(sendClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn = sendBtn1;
    [topToolBar addSubview:sendBtn1];
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    CGRect indicatorRect = indicator.frame;
    indicatorRect.origin.x = 275;
    indicatorRect.origin.y = 44/2 - indicatorRect.size.height/2;
    indicator.frame = indicatorRect;
    [topToolBar addSubview:indicator];
    self.sendIndicator = indicator;
    [indicator release];
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
}

#pragma mark -
#pragma mark BtnPressed
-(void)handleBackPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sendClicked:(UIButton*)sender
{
    NSString* titleString = titleTextView.text;
    NSString* contentString = contentTextView.text;
    if (self.titleView.hidden) {
        if (!(contentString&&[contentString length]>0)) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"正文不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
            [contentTextView becomeFirstResponder];
        }
        else {
            sendBtn.hidden = YES;
            [sendIndicator startAnimating];
            [[StockBarPuller getInstance] startSendStockSubjectWithSender:self stockName:stockName bid:bid tid:tid quotePid:quotePid title:titleString content:contentString args:nil userInfo:nil];
        }
    }
    else {
        if (!(contentString&&[contentString length]>0)||!(titleString&&[titleString length]>0)) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"正文及标题不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
            if (!(titleString&&[titleString length]>0)) {
                [titleTextView becomeFirstResponder];
            }
            else {
                [contentTextView becomeFirstResponder];
            }
            
        }
        else {
            sendBtn.hidden = YES;
            [sendIndicator startAnimating];
            [[StockBarPuller getInstance] startSendStockSubjectWithSender:self stockName:stockName bid:bid tid:tid quotePid:quotePid title:titleString content:contentString args:nil userInfo:nil];
        }
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
        if ([stageNumber intValue]==Stage_Request_SendStockSubject)
        {
            sendBtn.hidden = NO;
            [sendIndicator stopAnimating];
            [self handleBackPressed];
        }
    }
}

-(void)StockBarObjectFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_SendStockSubject)
        {
            sendBtn.hidden = NO;
            [sendIndicator stopAnimating];
            NSString* errorString = [userInfo valueForKey:RequsetErrorString];
            if (errorString) {
                errorString = [NSString stringWithFormat:@"发送失败了,%@",errorString];
            }
            else {
                errorString = @"发送失败";
            }
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
            
            if (self.titleView.hidden) {
                [contentTextView becomeFirstResponder];
            }
            else {
                if ([titleTextView.text length]>0) {
                    [contentTextView becomeFirstResponder];
                }
                else {
                    [titleTextView becomeFirstResponder];
                }
            }
        }
    }
}

@end
