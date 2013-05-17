//
//  WDKlineView.m
//  KlineView
//
//  Created by Sun Guanglei on 12-3-13.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "WDKlineView.h"
#import <QuartzCore/QuartzCore.h>

#define MARGIN_SIZE CGSizeMake(5, 10)
#define SCALE 2.0

@implementation MyWebView

-(void)dealloc
{
    [super dealloc];
}
@end

@implementation WDKlineView
@synthesize aniview;
@synthesize svgData;
@synthesize svgParser;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        bSVGLoaded = NO;
        svgview = nil;
        fillImgView = nil;
        
        self.backgroundColor = [UIColor clearColor];
        
        CGRect viewRect = CGRectMake(MARGIN_SIZE.width, MARGIN_SIZE.height,
                                     svgParser.size.width /SCALE, svgParser.size.height / SCALE);
        
        svgview = [[MyWebView alloc] initWithFrame:viewRect];
        NSArray* subViews = [svgview subviews];
        for (UIScrollView* oneSub in subViews) {
            if ([oneSub isKindOfClass:[UIScrollView class]]) { 
                oneSub.scrollsToTop = NO;
            }
        }
        svgview.alpha = 0.0;
        svgview.opaque = NO;
        svgview.backgroundColor = [UIColor clearColor];
        
        svgview.delegate = self;
        NSString *htmlstr = [NSString stringWithFormat:@"<html><head><title>The Meaning of Life</title><meta name=\"viewport\" content=\"width=%.0f height=%.0f initial-scale=1\"/></head><body style=\"margin:0;background-color: transparent;\" ></body></html>",
                             svgParser.size.width / SCALE,
                             svgParser.size.height / SCALE,
                             @"",
                             svgParser.size.width / SCALE,
                             svgParser.size.height / SCALE];
        
        [svgview loadHTMLString:htmlstr baseURL:nil];
        
        loadFillImgView = [[UIImageView alloc] initWithFrame:viewRect];
        loadFillImgView.alpha = 0.0;
        
        aniview = [[WDKlineAnimation alloc] initWithFrame:CGRectMake(0, 0, 
                                                    frame.size.width, frame.size.height)];
        aniview.backgroundColor = [UIColor clearColor];
        
        aniview.lineRect = CGRectMake(svgParser.dataRect.origin.x + MARGIN_SIZE.width * SCALE,
                                      svgParser.dataRect.origin.y + MARGIN_SIZE.height * SCALE,
                                      svgParser.dataRect.size.width, 
                                      svgParser.dataRect.size.height);
        
        aniview.dataOrigin = svgParser.origin;
        aniview.klineData = svgParser.klineData;
        aniview.descData = svgParser.dataDesc;
        aniview.hidden = YES;
        
        // add subviews
        [self addSubview:svgview];
        [self addSubview:loadFillImgView];
        [self addSubview:aniview];
        [self bringSubviewToFront:aniview];
    }
    return self;
}

/*
 * filePath: SVG所在的路径
 * bDraw: 是否填充SVG曲线阴影
 *        由于SVG中存在多个polyline标签，已约定填充第一个
 *        polyline所标识的曲线；另外，目前在svg中没有标识
 *        是否需要填充，因此由调用者传递参数
 */
- (id)initWithSVG:(NSString *)filePath drawShadow:(BOOL)bDraw
{
    NSData  *newData = [filePath dataUsingEncoding:NSUTF8StringEncoding];
    WDSVGParser* newParser = [[WDSVGParser alloc] initWithData:newData];
    
    if (!newParser.bVaild) {
        NSLog(@"Kline:svg is invaild!");
    }
    
    [svgParser release];
    svgParser = [newParser retain];
    bDrawShadow = bDraw;
    
    self = [self initWithFrame:CGRectMake(0, 0, newParser.size.width / 2 + MARGIN_SIZE.width * 2, newParser.size.height / 2 + MARGIN_SIZE.height * 2)];
    
    if (self) {
        if (bDrawShadow) {
            loadFillImgView.image = svgParser.svgImg;
        }
        self.svgData = filePath;
        aniview.hidden = YES;
        [self showSVG];
    }
    [newParser release];
    return self;
}

/*
 * filePath: SVG所在的路径
 * bDraw: 是否填充SVG曲线阴影
 *        由于SVG中存在多个polyline标签，已约定填充第一个
 *        polyline所标识的曲线；另外，目前在svg中没有标识
 *        是否需要填充，因此由调用者传递参数
 */
- (void)loadSVG:(NSString *)filePath drawShadow:(BOOL)bDraw
{
    bDrawShadow = bDraw;
    
    bSVGLoaded = NO;
    NSData  *newData = [filePath dataUsingEncoding:NSUTF8StringEncoding];;
    self.svgData = filePath;
    
    [svgParser release];
    svgParser = [[WDSVGParser alloc] initWithData:newData];
    
    if (!svgParser.bVaild) {
        NSLog(@"Kline:svg is invaild!");
    }
    
    svgFillImg = svgParser.svgImg;
    
    //
    CGRect viewRect = CGRectMake(MARGIN_SIZE.width, MARGIN_SIZE.height,
                                 svgParser.size.width /SCALE, svgParser.size.height / SCALE);
    
    svgview.frame = viewRect;
    if (loadFillImgView) {
        [loadFillImgView removeFromSuperview];
        [loadFillImgView release];
        loadFillImgView = nil;
    }
    loadFillImgView = [[UIImageView alloc] initWithFrame:viewRect];
    [self insertSubview:loadFillImgView belowSubview:aniview];
    [self bringSubviewToFront:aniview];
    loadFillImgView.alpha = 0.0;
    if (bDrawShadow) {
        loadFillImgView.image = svgFillImg;
    }
    
    // resize
    self.frame = CGRectMake(0, 0, svgParser.size.width / 2 + MARGIN_SIZE.width * 2, svgParser.size.height / 2 + MARGIN_SIZE.height * 2);
    
    [aniview resize:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    aniview.lineRect = CGRectMake(svgParser.dataRect.origin.x + MARGIN_SIZE.width * SCALE,
                                  svgParser.dataRect.origin.y + MARGIN_SIZE.height * SCALE,
                                  svgParser.dataRect.size.width, 
                                  svgParser.dataRect.size.height);
    
    aniview.dataOrigin = svgParser.origin;
    aniview.klineData = svgParser.klineData;
    aniview.descData = svgParser.dataDesc;
    
    [self showSVG];
}

-(void)clear
{
    if (fillImgView) {
        fillImgView.image = nil;
    }
    if (loadFillImgView) {
        loadFillImgView.image = nil;
    }
    if (svgview) {
        [svgview stopLoading];
        svgview.alpha = 0.0;
    }
    if (aniview) {
        aniview.hidden = YES;
    }
    UIImageView* oldImageView = (UIImageView*)[self viewWithTag:333323];
    oldImageView.image = nil;
}

- (void)showSVG
{
    if (svgData&&[svgData length]>0) {
        NSData  *newData = [svgData dataUsingEncoding:NSUTF8StringEncoding];
        [svgview stopLoading];
        aniview.hidden = YES;
        [svgview loadData:newData MIMEType:@"image/svg+xml" textEncodingName:nil baseURL:nil];
    }
    else {
        [svgview stopLoading];
        aniview.hidden = YES;
        [svgview loadData:nil MIMEType:@"image/svg+xml" textEncodingName:nil baseURL:nil];
    }
    
//	svgview.scalesPageToFit = YES;
}

- (void)dealloc
{
    [svgParser release];
    [aniview release];
    [svgData release];
    [svgview stopLoading];
    svgview.delegate = nil;
    [svgview release];
    [fillImgView release];
    [super dealloc]; 
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

#pragma mark -
#pragma mark UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSArray* subViews = [webView subviews];
    for (UIScrollView* oneSub in subViews) {
        if ([oneSub isKindOfClass:[UIScrollView class]]) { 
            oneSub.scrollsToTop = NO;
        }
    }
#ifdef DEBUG
    NSLog(@"test webViewDidFinishLoad");
#endif
    [self webViewDidRealFinishLoad:webView];
}

- (void)webViewDidRealFinishLoad:(UIWebView *)webView
{
    webView.alpha = 1.0;
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    UIImage* tempImage = [self getTableImage:webView];
    UIImageView* oldImageView = (UIImageView*)[self viewWithTag:333323];
    if (!oldImageView) {
        oldImageView = [[UIImageView alloc] initWithImage:tempImage];
        oldImageView.tag = 333323;
        [self insertSubview:oldImageView aboveSubview:svgview];
        [oldImageView release];
    }
    else {
        oldImageView.image = tempImage;
    }
    
    CGRect viewRect = CGRectMake(MARGIN_SIZE.width, MARGIN_SIZE.height,
                                 svgParser.size.width /SCALE, svgParser.size.height / SCALE);
    oldImageView.frame = viewRect;
    
    bSVGLoaded = YES;
    svgview.alpha = 0.0;
    loadFillImgView.alpha = 1.0;
    
    fillImgView.alpha = 0.0;
    aniview.hidden = NO;
    
    if (fillImgView != nil) {
        [fillImgView removeFromSuperview];
        [fillImgView release];
    }
    
    fillImgView = loadFillImgView;
    
    loadFillImgView = nil;
    
    [aniview showData:CGPointMake(0, 0) lastPrice:YES];
    [pool release];
}

-(void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (hidden) {
        [svgview stopLoading];
    }
}

-(void)stopLoading
{
    [svgview stopLoading];
}

@end
