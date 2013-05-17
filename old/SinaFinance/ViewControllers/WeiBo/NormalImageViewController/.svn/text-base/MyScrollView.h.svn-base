//
//  MyScrollView.h
//  PhotoBrowserEx
//
//  Created by  on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyScrollView;

@protocol MyScrollViewDelegate <NSObject>

-(void)viewClicked:(MyScrollView*)view;

@end

@interface MyScrollView : UIScrollView <UIScrollViewDelegate>
{
	UIImage *image;
	UIImageView *imageView;
    id<MyScrollViewDelegate> customDelegate;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) id<MyScrollViewDelegate> customDelegate;

@end
