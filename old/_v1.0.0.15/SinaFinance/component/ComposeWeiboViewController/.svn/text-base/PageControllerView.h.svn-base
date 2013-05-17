//
//  PageControllerView.h
//  SinaNews
//
//  Created by shieh exbice on 12-1-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageControllerView;

@protocol PageControllerView_Delegate <NSObject>

-(void)view:(PageControllerView*)controlView emotionString:(NSString*)emotion;

@end

@interface PageControllerView : UIView
{
    UIScrollView* scrollView;
    UIPageControl* pageControl;
    UIImageView* backImageView;
    NSArray* emotionArray;
    NSInteger countEmotinPerPage;
    CGSize sizePerPage;
    CGSize emotionSize;
    NSInteger countPage;
    BOOL pageControlUsed;
}
@property(nonatomic,retain)NSArray* emotionArray;
@property(nonatomic,assign)id<PageControllerView_Delegate> delegate;

-(void)reloadData;

@end
