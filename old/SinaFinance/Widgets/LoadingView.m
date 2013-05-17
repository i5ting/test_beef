//
//  .m
//  SinaNBA
//
//  Created by Du Dan on 10/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()
@property(nonatomic,retain)NSValue* sourceRectValue;
@property(nonatomic,retain)NSValue* destRectValue;
@property(nonatomic,retain)UIActivityIndicatorView* indicator;
@end

@implementation LoadingView
{
    NSValue* sourceRectValue;
    NSValue* destRectValue;
    UIActivityIndicatorView* indicator;
}
@synthesize indicator;
@synthesize sourceRectValue,destRectValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
        UIActivityIndicatorView *loading = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((frame.size.width - 40)/2, (frame.size.height - 40)/2, 40, 40)] autorelease];
        self.indicator = loading;
        [self addSubview:loading];
        [loading startAnimating];
    }
    return self;
}

- (void)dealloc
{
    [indicator release];
    [sourceRectValue release];
    [destRectValue release];
    [super dealloc];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)setFrame:(CGRect)frame
{
    CGRect sourceRect = self.frame;
    [super setFrame:frame];
    
    NSValue* sourceValue = [NSValue valueWithCGRect:sourceRect];
    NSValue* destValue = [NSValue valueWithCGRect:frame];
    if (!sourceRectValue) {
        self.sourceRectValue = sourceValue;
    }
    self.destRectValue = destValue;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(frameChanged) object:nil];
    [self performSelector:@selector(frameChanged) withObject:nil afterDelay:0.001];
}

-(void)frameChanged
{
    if (self.destRectValue&&self.sourceRectValue) {
        CGRect frame = [self.destRectValue CGRectValue];
        CGRect sourceRect = [self.sourceRectValue CGRectValue];
        if (!CGRectEqualToRect(frame, CGRectZero)&&!CGRectEqualToRect(frame, sourceRect))
        {
            CGRect textRect = indicator.frame;
            textRect.origin.x = frame.size.width/2 - textRect.size.width/2;
            textRect.origin.y = frame.size.height/2 - textRect.size.height/2;
            indicator.frame = textRect;
        }
    }
    self.sourceRectValue = nil;
    self.destRectValue = nil;
}

@end 

@implementation LoadingView2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:8/255.0 blue:25/255.0 alpha:1.0];
        UIImage* loadingBackImage = [UIImage imageNamed:@"loadingback.png"];
        loadingBackImage = [loadingBackImage stretchableImageWithLeftCapWidth:50.0 topCapHeight:50.0];
        UIImageView* backView = [[UIImageView alloc] initWithImage:loadingBackImage];
        CGSize imageSize = CGSizeMake(loadingBackImage.size.width/2, loadingBackImage.size.height/2);
        NSInteger curX = self.bounds.size.width/2 - imageSize.width/2;
        NSInteger curY = self.bounds.size.height/2 - imageSize.height/2 - 20;
        backView.frame = CGRectMake(curX, curY, imageSize.width, imageSize.height);
        backView.frame = self.bounds;
        backView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:backView];
        [backView release];
    }
    return self;
}

@end


