//
//  OPImageView.m
//  NewsHD
//
//  Created by sgl on 12-9-18.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "OPImageView.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+ImageScale.h"
#import "AFNetworking.h"

@interface OPImageView()
- (void)setupButton;
@end

@implementation OPImageView
@synthesize button;
@synthesize cutfit;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupButton];
    }
    return self;
}

- (void)dealloc
{
    if (!_imageLoaded) {
        [self cancleLoad];
    }
    
    [button release];
    
    [super dealloc];
}

- (void)setupButton
{
    self.imageLoaded = NO;
    self.cutfit = NO;
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = self.bounds;
    [self addSubview:self.button];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupButton];
}

- (void)loadImage:(NSURL *)imgURL useDefaultImage:(BOOL)use
{
    if (use) {
        // TODO: 设置默认图片
        [self loadImage:imgURL holderImage:[UIImage imageNamed:@"oparticle_photo_back.png"]];
    }
    else {
        [self loadImage:imgURL holderImage:nil];
    }
}

- (void)loadImage:(NSURL *)imgURL holderImage:(UIImage *)img
{
    __block OPImageView *imgview = self;
    
    NSURLRequest *req = [NSURLRequest requestWithURL:imgURL];
    [self setImageWithURLRequest:req placeholderImage:img success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        //
        if (imgview.cutfit) {
            [imgview fitImage:image];
        }
        imgview.imageLoaded = YES;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        //
        imgview.imageLoaded = YES;
    }];
}

- (void)cancleLoad
{
    [self cancelImageRequestOperation];
    self.imageLoaded = YES;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    self.userInteractionEnabled = YES;
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}

// 从中间截图
- (void)fitImage:(UIImage *)image
{
    CGSize imgSize = image.size;
    CGFloat targetWidth = self.frame.size.width;
    CGFloat targetHeight = self.frame.size.height;
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    if ((image.size.width / image.size.height) >= (targetWidth / targetHeight)) {
        height = imgSize.height;
        width = targetWidth * height / targetHeight;
        x = ABS((imgSize.width - width)) / 2.0;
    }
    else {
        width = imgSize.width;
        height = targetHeight * width / targetWidth;
        y = ABS((imgSize.height - height)) / 2.0;
    }
    
    self.image = [image subImage:CGRectMake(x, y, width, height)];
}

@end
