//
//  NormalImageViewController.m
//  SinaNews
//
//  Created by shieh exbice on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NormalImageViewController.h"
#import "PicNewsContentView.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "LoadingErrorView.h"

@interface NormalImageViewController()

@property(nonatomic,retain)PicNewsContentView* picContentView;
@property(nonatomic,retain)NSTimer* playTimer;
@property(nonatomic,retain)UIButton* playBtn;

-(void)layoutTipView;
-(void)initPicNewsContentView;
-(void)tipViewClicked:(UIButton*)sender;
-(void)expandTipView:(BOOL)expand;
-(void)setPlayStart:(BOOL)bStart;
-(void)playImagesClicked:(UIButton*)sender;
-(void)playImagesTimer:(NSTimer*)sender;
@end

@implementation NormalImageViewController
@synthesize imageObjectList,loading,picContentView;
@synthesize playing,playTimer,playBtn;

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
    [imageObjectList release];
    [picContentView release];
    [playTimer release];
    [playBtn release];
    
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
    
    MyCustomToolbar *topToolbar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    [self.view addSubview:topToolbar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(98, 0, 125, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    titleLabel.text = @"查看图片";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolbar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [topToolbar addSubview:backBtn];
    
    if(![ShareData sharedManager].isNetworkAvailable){
        LoadingErrorView *errorView = [[[LoadingErrorView alloc] initWithFrame:CGRectMake(0, 44, 320, 460-44)] autorelease];
        [self.view addSubview:errorView];
        return;
    }
    
    if (!bInited) {
        bInited = YES;
        
        self.containFillBounds = YES;
        self.title = @"查看图片";
                
        [self initPicNewsContentView];
        
        if ([imageObjectList count]>1) {
            UIButton* aPlayBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            aPlayBtn.frame = CGRectMake(260, 0, 50, mNavigationBarHeight);
            aPlayBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            aPlayBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            [aPlayBtn addTarget:self action:@selector(playImagesClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.navigationBar addSubview:aPlayBtn];
            self.playBtn = aPlayBtn;
            [self setPlayStart:NO];
        }
    }
}

-(void)initPicNewsContentView
{
    if (!self.picContentView) {
//        PicNewsContentView* view = [[PicNewsContentView alloc] initWithFrame:self.containView.bounds];
        CGRect frame = self.containView.bounds;
        frame.origin.y = frame.origin.y + 24;
        frame.size.height = frame.size.height - 55;
        PicNewsContentView* view = [[PicNewsContentView alloc] initWithFrame:frame];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
//        view.delegate = self;
        self.containView.backgroundColor = [UIColor blackColor];
        [self.containView addSubview:view];
        self.picContentView = view;
        [view release];
    }
    
    NSMutableArray* picArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString* imageUrl in imageObjectList) {
        [picArray addObject:imageUrl];
    }
    self.picContentView.picURLArray = picArray;
    [picArray release];
}

-(void)view:(PicNewsContentView*)view clickedWithIndex:(NSInteger)index
{
    if (!bFullShowed) {
        self.navigationBarHiden = YES;
    }
    else
    {
        self.navigationBarHiden = NO;
    }
    bFullShowed = !bFullShowed;
}

-(void)view:(PicNewsContentView*)view changedIndex:(NSInteger)index
{    
    if (index>=[imageObjectList count]-1) {
        [self setPlayStart:NO];
    }
}

-(void)playImagesClicked:(UIButton*)sender
{
    [self setPlayStart:!playing];
}

-(void)setPlayStart:(BOOL)bStart
{
    playing = bStart;
    if (bStart) {
        [self.playTimer invalidate];
        self.playTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(playImagesTimer:) userInfo:nil repeats:YES]; 
        [[NSRunLoop mainRunLoop] addTimer:self.playTimer forMode:NSRunLoopCommonModes];
        
        [self.playBtn setTitle:@"停止" forState:UIControlStateNormal];
    }
    else
    {
        [self.playBtn setTitle:@"播放" forState:UIControlStateNormal];
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

-(void)playImagesTimer:(NSTimer*)sender
{
    [picContentView setNextPageWithAnimate:YES];
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

-(void)backBtnClicked:(UIButton*)sender
{
    [self.playTimer invalidate];
    self.playTimer = nil;
    [super backBtnClicked:sender];
}

@end
