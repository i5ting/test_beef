//
//  OPImageScrollViewController.m
//  NewsHD
//
//  Created by sgl on 12-9-18.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "OPImageScrollViewController.h"
#import "OPImageView.h"

@interface OPImageScrollViewController ()
- (void)fitImagesForOrientation;
@end

@implementation OPImageScrollViewController
@synthesize imageURLs = _imageURLs;
@synthesize contentScrollView = _contentScrollView;
@synthesize pagingEnabled = _pagingEnabled;
@synthesize imgViews = _imgViews;
@synthesize curPage = _curPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _pagingEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_imageURLs release];
    [_contentScrollView release];
    
    [super dealloc];
}

- (void)viewDidUnload {
    [self setContentScrollView:nil];
    [super viewDidUnload];
}

- (void)showImages:(NSArray *)imgUrls
{
    self.imageURLs = imgUrls;
    self.imgViews = [NSMutableArray arrayWithCapacity:_imageURLs.count];
    
    CGFloat xoffset = 0;
    CGFloat yoffset = 0;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    for (id imageURL in _imageURLs) {
        OPImageView *imgView = [[OPImageView alloc] initWithFrame:CGRectMake(xoffset, yoffset, width, height)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [imgView addTarget:self action:@selector(imgClicked:) forControlEvents:UIControlEventTouchUpInside];
        [imgView loadImage:[NSURL URLWithString:imageURL] useDefaultImage:YES];
        [_contentScrollView addSubview:imgView];
        [_imgViews addObject:imgView];
        xoffset += width;
        [imgView release];
    }
    
    _contentScrollView.contentSize = CGSizeMake(xoffset, height);
    _contentScrollView.pagingEnabled = _pagingEnabled;
}

- (IBAction)imgClicked:(id)sender
{
    NSLog(@"img clicked");
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self fitImagesForOrientation];
}

- (void)fitImagesForOrientation
{
    // Get current page.
    CGFloat xoffset = 0;
    CGFloat yoffset = 0;
    CGFloat width = _contentScrollView.frame.size.width;
    CGFloat height = _contentScrollView.frame.size.height;
    _contentScrollView.pagingEnabled = NO;
    
    for (OPImageView *imgview in _imgViews) {
        imgview.frame = CGRectMake(xoffset, yoffset, width, height);
        xoffset += width;
    }
    _contentScrollView.contentSize = CGSizeMake(_imgViews.count * width, height);
    
    CGRect targetRect = CGRectMake(_curPage * width, yoffset, width, height);
    [_contentScrollView scrollRectToVisible:targetRect animated:NO];
    _contentScrollView.pagingEnabled = YES;
}

#pragma mark -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _curPage = (NSInteger)(scrollView.contentOffset.x / scrollView.frame.size.width);
}

@end
