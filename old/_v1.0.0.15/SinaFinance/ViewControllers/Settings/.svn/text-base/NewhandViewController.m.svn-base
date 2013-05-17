//
//  NewhandViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewhandViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "NewHandScroll.h"

@interface NewhandViewController ()

@end

@implementation NewhandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    MyCustomToolbar *topToolBar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(60, 0, 200, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"新手指南";
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
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
    
    NewHandScroll* scroll = [[NewHandScroll alloc] initWithFrame:CGRectMake(0, 0, 320, UI_MAX_HEIGHT - 20)];
    scroll.scaleModeFit = NO;
    scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:scroll];
    [self.view sendSubviewToBack:scroll];
    [scroll release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)handleBackPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
