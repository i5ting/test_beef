//
//  WDKlineView.h
//  KlineView
//
//  Created by Sun Guanglei on 12-3-13.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDKlineAnimation.h"
#import "WDSVGParser.h"

@interface MyWebView : UIWebView

@end

@interface WDKlineView : UIView <UIWebViewDelegate>
{
    MyWebView   *svgview;
    UIImage     *svgFillImg;
    UIImageView *fillImgView;
    UIImageView *loadFillImgView;
    
    WDSVGParser *svgParser;
    WDKlineAnimation *aniview;
    
    BOOL bSVGLoaded;
    BOOL bDrawShadow;
}

@property (nonatomic, retain) WDKlineAnimation *aniview;
@property (nonatomic, retain) NSString *svgData;
@property (nonatomic, readonly) WDSVGParser *svgParser;

- (id)initWithSVG:(NSString *)filePath drawShadow:(BOOL)bDraw;
- (void)loadSVG:(NSString *)filePath drawShadow:(BOOL)bDraw;
- (void)showSVG;
-(void)clear;
-(void)stopLoading;
@end
