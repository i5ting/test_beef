//
//  MyCustomToolbar.m
//  SinaNBA
//
//  Created by Du Dan on 10/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyCustomToolbar.h"
#import "TitleView.h"

@interface MyCustomToolbar()
@property(nonatomic,retain)UIView* titleView;
@end

@implementation MyCustomToolbar
@synthesize titleView,title;

- (id)initWithImage:(NSString*)imgName
{
    if((self = [super init])){
        customImage = [[NSString alloc] initWithString:imgName];
        UIImage *image = nil;
        if(customImage){
            image = [UIImage imageNamed: customImage];
        }
        else{
            image = [UIImage imageNamed: @"toolbar_bg.png"];
        }
        UIImageView* tempImageView = [[UIImageView alloc] initWithImage:image];
        tempImageView.tag = 111485;
        [self addSubview:tempImageView];
        [tempImageView release];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    UIImageView* tempImageView = (UIImageView*)[self viewWithTag:111485];
    if (!tempImageView) {
        UIImage *image = nil;
        if(customImage){
            image = [UIImage imageNamed: customImage];
        }
        else{
            image = [UIImage imageNamed: @"toolbar_bg.png"];
        }
        tempImageView = [[UIImageView alloc] initWithImage:image];
        tempImageView.tag = 111485;
        [self addSubview:tempImageView];
        [tempImageView release];
        [self sendSubviewToBack:tempImageView];
    }
    if (tempImageView.image) {
        if (!self.autoresizesSubviews) {
            CGSize imageSize = tempImageView.image.size;
            tempImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        }
        else
        {
            CGSize imageSize = self.bounds.size;
            tempImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        }
    }
    
}

- (void)layoutSubviews
{
    NSArray* subViews = self.subviews;
    for (UIView* oneView in subViews) {
        if ([oneView isKindOfClass:[TitleView class]]) {
            TitleView* oneTitleView = (TitleView*)oneView;
            [oneTitleView sizeToFit];
            CGRect titleFrame = oneTitleView.frame;
            titleFrame.origin.x = self.bounds.size.width/2 - titleFrame.size.width/2;
            titleFrame.origin.y = self.bounds.size.height/2 - titleFrame.size.height/2;
            oneTitleView.frame = titleFrame;
        }
    }
}

-(void)initTitleView
{
    if (!titleView) {
        TitleView* newTitleView = [[TitleView alloc] init];
        newTitleView.titleFont = [UIFont fontWithName:@"Arial" size:20];
        self.titleView = newTitleView;
        UIColor* showColor = [UIColor whiteColor];
        if (showColor) {
            newTitleView.titleColor = showColor;
        }
        [self addSubview:newTitleView];
        [newTitleView release];
    }
}

-(void)setTitle:(NSString *)aTitle
{
    [self initTitleView];
    if ([titleView isKindOfClass:[TitleView class]]) {
        ((TitleView*)titleView).title = aTitle;
    }
}

-(NSString*)title
{
    return [(TitleView*)titleView title];
}

- (void)dealloc
{
    [customImage release];
    [titleView release];
    [super dealloc];
}

@end

