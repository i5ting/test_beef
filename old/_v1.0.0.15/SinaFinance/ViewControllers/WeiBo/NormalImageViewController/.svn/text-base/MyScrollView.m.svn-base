//
//  MyScrollView.m
//  PhotoBrowserEx
//
//  Created by on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyScrollView.h"

@interface MyScrollView ()
-(void)mylayout;

@end

@implementation MyScrollView

@synthesize image,imageView,customDelegate;

#pragma mark -
#pragma mark === Intilization ===
#pragma mark -
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
		self.delegate = self;
		self.minimumZoomScale = 0.5;
		self.maximumZoomScale = 7.0;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		
		imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:imageView];
        
        // 单击的 Recognizer    
        UITapGestureRecognizer* singleRecognizer;    
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];   
        singleRecognizer.numberOfTapsRequired = 1; 
        // 单击    
        [self addGestureRecognizer:singleRecognizer];        
        // 双击的 Recognizer    
        UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom)];    
        doubleRecognizer.numberOfTapsRequired = 2; 
        // 双击    
        [self addGestureRecognizer:doubleRecognizer];       
        // 关键在这一行，如果双击确定偵測失败才會触发单击    
        [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];   
        [singleRecognizer release];    
        [doubleRecognizer release];
    }
    return self;
}

- (void)setImage:(UIImage *)img
{
	imageView.image = img;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self mylayout];
}

-(void)mylayout
{
    CGRect mainRect = self.bounds;
    self.imageView.frame = mainRect;
}

#pragma mark -
#pragma mark === UIScrollView Delegate ===
#pragma mark -
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{	
	return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	//NSLog(@"%s", _cmd);
	
	CGFloat zs = scrollView.zoomScale;
	zs = MAX(zs, 1.0);
	zs = MIN(zs, 7.0);	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];		
	scrollView.zoomScale = zs;	
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark === UITouch Delegate ===
#pragma mark -
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"%s", _cmd);
	[super touchesBegan:touches withEvent:event];
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) 
	{
		//NSLog(@"double click");
		
		CGFloat zs = self.zoomScale;
		zs = (zs == 1.0) ? 2.0 : 1.0;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];			
		self.zoomScale = zs;	
		[UIView commitAnimations];
	}
    else if ([touch tapCount] == 1) 
	{
		//NSLog(@"double click");
        
        if ([customDelegate respondsToSelector:@selector(viewClicked:)]) {
            [customDelegate viewClicked:self];
        }
	}
}
 */

-(void)handleSingleTapFrom
{
    if ([customDelegate respondsToSelector:@selector(viewClicked:)]) {
        [customDelegate viewClicked:self];
    }
}

-(void)handleDoubleTapFrom
{
    CGFloat zs = self.zoomScale;
    CGFloat min = 1.0;
    CGFloat max = self.maximumZoomScale;
    if (max>zs) {
        zs = zs*2.0;
        if (zs>max) {
            zs = min;
        }
    }
    else
    {
        zs = min;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];			
    self.zoomScale = zs;	
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark === dealloc ===
#pragma mark -
- (void)dealloc
{
	[image release];
	[imageView release];
	
    [super dealloc];
}


@end
