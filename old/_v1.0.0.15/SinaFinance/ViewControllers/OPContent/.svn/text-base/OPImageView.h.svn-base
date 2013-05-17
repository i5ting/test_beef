//
//  OPImageView.h
//  NewsHD
//
//  Created by sgl on 12-9-18.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPImageView : UIImageView

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) BOOL cutfit;
@property (nonatomic, assign) BOOL imageLoaded;

- (void)loadImage:(NSURL *)imgURL useDefaultImage:(BOOL)use;
- (void)loadImage:(NSURL *)imgURL holderImage:(UIImage *)img;
- (void)cancleLoad;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
