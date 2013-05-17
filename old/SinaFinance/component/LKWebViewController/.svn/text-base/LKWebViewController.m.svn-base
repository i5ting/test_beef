//
//  LKWebViewController.m
//  SK
//
//  Created by luke on 10-12-8.
//  Copyright 2010 pica.com. All rights reserved.
//

#import "LKWebViewController.h"
#import "LKLoadingCenter.h"
#import "LKTipCenter.h"
#import "MyCustomToolbar.h"

@interface LKWebViewController ()
- (void)checkIfCanGobackOrForward;

@end



@implementation LKWebViewController

@synthesize webView, toolBar,preButton, priButton, refreshButton, actionButton;
@synthesize url;
@synthesize titleString;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL *)aUrl {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.url = aUrl;
        self.titleString = @"";
    }
    return self;
}

- (void)dealloc {
    self.preButton = nil;
    self.priButton = nil;
    self.refreshButton = nil;
    self.actionButton = nil;
    self.toolBar = nil;
    [titleString release];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [webView stopLoading];
    self.webView = nil;
    
	[url release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	isViewAppeared = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[LKLoadingCenter defaultCenter] disposeLoadingView];
	isViewAppeared = NO;
}

-(IBAction) cancel:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [[LKLoadingCenter defaultCenter] disposeLoadingView];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	isViewAppeared = NO;
	isNeedChangeSkin = YES;
    [self addToolbar];
	if (url) {
		NSURLRequest *req = [NSURLRequest requestWithURL:url];
		self.webView.delegate = self;
		[self.webView loadRequest:req];
		[[LKLoadingCenter defaultCenter] postLoadingWithTitle:@"处理中 ..." message:nil ignoreTouch:NO];
	}
    /*
    UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:@"关闭" 
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(cancel:)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0/255 green:48.0/255 blue:112.0/255 alpha:1.0];
    self.navigationItem.leftBarButtonItem = button;
    [button release];
     */
//    self.navigationItem.title = @"网页";
//    self.title = @"网页";
    self.navigationItem.title = @"";
    self.title = @"";
}

- (void)addToolbar
{
    MyCustomToolbar *topToolbar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    topToolbar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolbar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(98, 0, 125, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Arial" size:20];
    titleLabel.text = titleString;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolbar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 5, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [backBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:backBtn];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.preButton = nil;
    self.priButton = nil;
    self.refreshButton = nil;
    self.actionButton = nil;
    self.toolBar = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [webView stopLoading];
    self.webView = nil;
}

#pragma mark -
#pragma mark FUNCTIONs

- (IBAction)goPrepage {
	

	[webView goBack];
}

- (IBAction)goPripage {
	

	[webView goForward];
}

- (IBAction)refreshPage {
	

	[webView reload];
}

- (IBAction)actionButtonPressed {
	
    
}

#pragma mark UIWebView delegate handle


- (void)checkIfCanGobackOrForward {
	
	if (webView.canGoBack) {
		preButton.enabled = YES;
	} else {
		preButton.enabled = NO;
	}
	
	if (webView.canGoForward) {
		priButton.enabled = YES;
	} else {
		priButton.enabled = NO;
	}
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	

	//[self checkIfCanGobackOrForward];
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView {
	

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[[LKLoadingCenter defaultCenter] disposeLoadingView];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
	

	NSString *errinfo = [error localizedDescription];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[[LKLoadingCenter defaultCenter] disposeLoadingView];
	
	if ([error code] == -999) {
		return;
	}
	[[LKTipCenter defaultCenter] postTipWithMessage:errinfo time:3];
}

@end
