//
//  CustomImageView.m
//  SinaNewsHD
//
//  Created by du zhe on 10-10-29.
//  Copyright 2010 sina. All rights reserved.
//

#import "CustomImageView.h"
#import "NewsContentVariable.h"
#import "hExtension.h"
#import "UIImageView+WebCache.h"


@implementation CustomImageView
@synthesize isNeedBorder,border,delegate;
@synthesize imageURL,contentImage;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTaped:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(imageLoaded:) name:WebCacheImageSuccessedNotification object:nil];
    }
    return self;
}

-(void)selfTaped:(UITapGestureRecognizer *)tapGesture
{
    if ([delegate respondsToSelector:@selector(CustomImageViewClicked:)]) {
        [delegate CustomImageViewClicked:self];
    }
}

- (void)setSubstituteImageWithFrame:(CGRect)imageFrame
{

	[self removeAllSubViews];
	
	UIImage *borderImage = [[UIImage imageNamed:@"ContentImageBorder.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	self.image = borderImage;
	self.frame = imageFrame;
	self.backgroundColor = [UIColor clearColor];
	CGRect contentRect = imageFrame;
	contentRect.size.width = imageFrame.size.width - 2 * border;
	contentRect.size.height = imageFrame.size.height - 2 * border;
	contentRect.origin.x = border;
	contentRect.origin.y = border;
	
	UIView *contentView = [[UIView alloc] initWithFrame:contentRect];
	contentView.backgroundColor = [UIColor grayColor];
	[self addSubview:contentView];
	[contentView release];
	
	UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:placeholder_photo]];
	CGFloat iconWidth = iconView.image.size.width;
	CGFloat iconHeight = iconView.image.size.height;
	
	iconWidth = iconWidth > contentRect.size.width ? contentRect.size.width : iconWidth;
	iconHeight = iconHeight > contentRect.size.height ? contentRect.size.height : iconHeight;
	
	iconView.frame = CGRectMake((contentRect.size.width - iconWidth) / 2, (contentRect.size.height - iconHeight) / 2, iconWidth, iconHeight);
	iconView.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:iconView];
	[iconView release];
}

- (void)setContentImageWithFrame:(CGRect)imageFrame
{
    UIImage *borderImage = [[UIImage imageNamed:@"ContentImageBorder.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	self.image = borderImage;
	self.frame = imageFrame;
	self.backgroundColor = [UIColor clearColor];
	
	CGRect contentRect = imageFrame;
	contentRect.size.width = imageFrame.size.width - 2 * border;
	contentRect.size.height = imageFrame.size.height - 2 * border;
	contentRect.origin.x = border;
	contentRect.origin.y = border;
    
    UIImageView *imageView = (UIImageView*)[self viewWithTag:111487];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.frame =contentRect;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 111487;
        [self addSubview:imageView];
        [imageView release];
    }
    imageView.frame = contentRect;
}

- (void)setContentImageWithFrame:(CGRect)imageFrame imageURL:(NSString *)contentImageURL placeImage:(UIImage*)placeImage
{
    [self removeAllSubViews];
	
	UIImage *borderImage = [[UIImage imageNamed:@"ContentImageBorder.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	self.image = borderImage;
	self.frame = imageFrame;
	self.backgroundColor = [UIColor clearColor];
	
	CGRect contentRect = imageFrame;
	contentRect.size.width = imageFrame.size.width - 2 * border;
	contentRect.size.height = imageFrame.size.height - 2 * border;
	contentRect.origin.x = border;
	contentRect.origin.y = border;
	
	UIImageView *imageView = [[UIImageView alloc] init];
	imageView.frame =contentRect;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tag = 111487;
	[self addSubview:imageView];
	[imageView release];
    NSURL* url = [NSURL URLWithString:contentImageURL];
    [imageView setImageWithURL:url placeholderImage:placeImage];
    self.imageURL = contentImageURL;
    self.contentImage = nil;
}

- (void)setContentImageWithFrame:(CGRect)imageFrame image:(UIImage *)aContentImage
{
	[self removeAllSubViews];
	
	UIImage *borderImage = [[UIImage imageNamed:@"ContentImageBorder.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	self.image = borderImage;
	self.frame = imageFrame;
	self.backgroundColor = [UIColor clearColor];
	
	CGRect contentRect = imageFrame;
	contentRect.size.width = imageFrame.size.width - 2 * border;
	contentRect.size.height = imageFrame.size.height - 2 * border;
	contentRect.origin.x = border;
	contentRect.origin.y = border;
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:aContentImage];
	imageView.frame =contentRect;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
	[self addSubview:imageView];
	[imageView release];
    self.contentImage = aContentImage;
    self.imageURL = nil;
}


- (void) sendImageRequest:(NSString *)url
{
	;
}

-(void)imageLoaded:(NSNotification*)notify
{
    UIImageView* imageView = [notify object];
    UIImageView* oldImageView = (UIImageView*)[self viewWithTag:111487];
    if (imageView==oldImageView) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(afterImageLoaded:) object:nil];
        [self performSelector:@selector(afterImageLoaded:) withObject:imageView afterDelay:0.001];
    }
}

-(void)afterImageLoaded:(UIImageView*)imageView
{
    NSURL* oldURL = [imageView imageURL];
    if (oldURL&&[[oldURL absoluteString] isEqualToString:self.imageURL]) {
        if ([delegate respondsToSelector:@selector(CustomImageViewFinishLoading:size:)]) {
            [delegate CustomImageViewFinishLoading:self size:imageView.image.size];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [contentImage release];
    [imageURL release];
    [super dealloc];
	
}


@end
