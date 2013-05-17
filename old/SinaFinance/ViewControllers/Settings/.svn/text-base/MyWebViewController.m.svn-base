//
//  MyWebViewController.m
//  SinaFinance
//
//  Created by Du Dan on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyWebViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"

@implementation MyWebViewController

- (id)initWithURL:(NSString*)urlString title:(NSString*)title
{
    self = [super init];
    if (self) {
        myURL = [[NSURL alloc] initWithString:urlString];
        myTitle = [[NSString alloc] initWithFormat:@"%@", title];
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
    [myURL release];
    [myWebView release];
    [myTitle release];
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)initToolbar
{
    MyCustomToolbar *topToolbar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    [self.view addSubview:topToolbar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(60, 0, 200, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = myTitle;
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolbar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:backBtn];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:3/255.0 green:30/255.0 blue:54/255.0 alpha:1.0];
    
    [self initToolbar];
    
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, UI_MAX_HEIGHT -110)];
    myWebView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myWebView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL];
    [myWebView loadRequest:request];
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

@end
