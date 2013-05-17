//
//  TitleDropButton.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TitleDropButton.h"
#import <QuartzCore/QuartzCore.h>

@interface TitleDropButton () 
-(void)resizeSubs;
-(void)setTitleArrow:(BOOL)normal;
@end

@implementation TitleDropButton
@synthesize titleString;
@synthesize selected,hasImage;
@synthesize delegate;
@synthesize titleBtn,titleLabel;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect bounds = CGRectZero;
        bounds.size = frame.size;
        self.userInteractionEnabled = YES;
        spacerInt = 3;
        titleBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        titleBtn.frame = bounds;
        titleBtn.backgroundColor = [UIColor clearColor];
        [titleBtn addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleBtn];
        titleLabel = [[UILabel alloc] initWithFrame:bounds];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        CALayer *layer = [CALayer layer];
        layer.contentsGravity = kCAGravityResizeAspect;
        UIImage* layerImage = [UIImage imageNamed:@"news_title_arrow11.png"];
        
        if (hasImage) {
             layerImage = [UIImage imageNamed:@"news_title_arrow.png"];
        }else{
             layerImage = [UIImage imageNamed:@"nil"];
        }
//        UIImage* layerImage = [UIImage imageNamed:@"news_title_arrow.png"];
        if (layerImage) {
            arrowSize = layerImage.size;
            layer.frame = CGRectMake(bounds.size.width/2-arrowSize.width/2, bounds.size.height/2-arrowSize.height/2, arrowSize.width, arrowSize.height);
            layer.contents = (id)layerImage.CGImage;
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
            if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
                layer.contentsScale = [[UIScreen mainScreen] scale];
            }
#endif
            
            [[self layer] addSublayer:layer];
            _arrowImage=layer;
        }
        
    }
    return self;
}

-(void)dealloc
{
    [titleBtn release];
    [titleLabel release];
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resizeSubs];
}

-(void)setTitleString:(NSString *)aTitleString
{
    if (titleString!=aTitleString) {
        NSString* oldString = titleString;
        titleString = [aTitleString retain];
        [oldString release];
    }
    titleLabel.text = titleString;
    [self resizeSubs];
}

-(void)resizeSubs
{
    [titleLabel sizeToFit];
    CGRect bounds = self.bounds;
    CGRect titleRect = titleLabel.frame;
    int maxWidth = bounds.size.width - (spacerInt+arrowSize.width);
    if (titleRect.size.width>maxWidth) {
        titleRect.size.width = maxWidth;
    }
    int totalWidth = titleRect.size.width + spacerInt+arrowSize.width;
    titleRect.origin.x = bounds.size.width/2 - totalWidth/2;
    titleRect.origin.y = bounds.size.height/2 - titleRect.size.height/2;
    titleLabel.frame = titleRect;
    CGRect arrowRect = CGRectZero;
    arrowRect.size = arrowSize;
    arrowRect.origin.x = titleRect.origin.x + titleRect.size.width + spacerInt;
    arrowRect.origin.y = bounds.size.height/2 - arrowRect.size.height/2;
    _arrowImage.frame = arrowRect;
    titleBtn.frame = bounds;
}

-(void)titleClicked:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(titleDropBtnClicked:)]) {
        [delegate titleDropBtnClicked:self];
    }
}

-(void)setSelected:(BOOL)aSelected
{
    selected = aSelected;
    titleBtn.selected = aSelected;
    [self setTitleArrow:!aSelected];
}

-(void)setTitleArrow:(BOOL)normal
{
    if (normal) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        _arrowImage.transform = CATransform3DIdentity;
        [CATransaction commit];
    }
    else
    {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        _arrowImage.transform = CATransform3DMakeRotation((M_PI / 181.0) * 180.0f, 0.0f, 0.0f, 1.0f);
        [CATransaction commit];
    }
}



@end
