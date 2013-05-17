//
//  NewHandScroll.m
//  SinaNews
//
//  Created by shieh exbice on 12-1-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewHandScroll.h"
@interface NewHandScroll()
@property(nonatomic,retain)NSValue* sourceRectValue;
@property(nonatomic,retain)NSValue* destRectValue;
@end

@implementation NewHandScroll
@synthesize sourceRectValue,destRectValue;
@synthesize scaleModeFit;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.scrollEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        NSString* executablePath = [[NSBundle mainBundle] bundlePath];
        
        NSString* newhandPath = [executablePath stringByAppendingPathComponent:@"newhand1.png"];
        UIImage* newhandImage = [[UIImage alloc] initWithContentsOfFile:newhandPath];
        CGRect imageRect = frame;
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:imageRect];
        imageView.tag =1000000;
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = newhandImage;
        [self addSubview:imageView];
        [newhandImage release];
        [imageView release];
        
        newhandPath = [executablePath stringByAppendingPathComponent:@"newhand2.png"];
        newhandImage = [[UIImage alloc] initWithContentsOfFile:newhandPath];
//        imageRect.origin.x = imageRect.origin.x+frame.size.width;
        imageView = [[UIImageView alloc] initWithFrame:imageRect];
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = newhandImage;
        imageView.tag =1000001;
        [self addSubview:imageView];
        [newhandImage release];
        [imageView release];
        
        newhandPath = [executablePath stringByAppendingPathComponent:@"newhand3.png"];
        newhandImage = [[UIImage alloc] initWithContentsOfFile:newhandPath];
//        imageRect.origin.x = imageRect.origin.x+frame.size.width;
        imageView = [[UIImageView alloc] initWithFrame:imageRect];
        imageView.image = newhandImage;
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag =1000002;
        [self addSubview:imageView];
        [newhandImage release];
        [imageView release];
        
        newhandPath = [executablePath stringByAppendingPathComponent:@"newhand4.png"];
        newhandImage = [[UIImage alloc] initWithContentsOfFile:newhandPath];
//        imageRect.origin.x = imageRect.origin.x+frame.size.width;
        imageView = [[UIImageView alloc] initWithFrame:imageRect];
        imageView.image = newhandImage;
        imageView.tag =1000003;
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        [newhandImage release];
        [imageView release];
        [self setContentSize:CGSizeMake(imageRect.origin.x+imageRect.size.width, imageRect.size.height)];
    }
    return self;
}

-(void)dealloc
{
    [sourceRectValue release];
    [destRectValue release];
    [super dealloc];
}

-(void)setScaleModeFit:(BOOL)bscaleModeFit
{
    scaleModeFit = bscaleModeFit;
    int i = 0;
    UIImageView* imageView = (UIImageView*)[self viewWithTag:1000000+i];
    while (imageView) {
        if (bscaleModeFit) {
            imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        else {
            imageView.contentMode = UIViewContentModeScaleToFill;
        }
        i++;
        imageView = (UIImageView*)[self viewWithTag:1000000+i];
    }
}

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
            [self realFrameChanged];
        }
    }
    self.sourceRectValue = nil;
    self.destRectValue = nil;
}

-(void)realFrameChanged
{
    CGRect frame = [self.destRectValue CGRectValue];
    CGRect sourceRect = [self.sourceRectValue CGRectValue];
    int addCount = 0;
    for (int i=0; i<999999; i++) {
        UIImageView* imageView = (UIImageView*)[self viewWithTag:1000000+i];
        if (imageView) {
            imageView.frame = CGRectMake(addCount*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
            addCount++;
            [self addSubview:imageView];
        }
        else {
            break;
        }
    }
    [self setContentSize:CGSizeMake(addCount*self.bounds.size.width, self.bounds.size.height)];
}

@end
