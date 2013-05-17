//
//  PicNewsContentView.h
//  SinaNews
//
//  Created by shieh exbice on 11-11-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PicNewsContentView;

@protocol PicNewsContentViewDelegate <NSObject>

-(void)view:(PicNewsContentView*)view clickedWithIndex:(NSInteger)index; 
-(void)view:(PicNewsContentView*)view changedIndex: (NSInteger)index;
@end

@interface PicNewsContentView : UIView<UIScrollViewDelegate>
{
    UIScrollView *scrView;
    NSArray* picURLArray;
	
	NSInteger lastPage;
    
    id<PicNewsContentViewDelegate> delegate;
}

@property(nonatomic,retain)UIScrollView *scrView;
@property(nonatomic,retain)NSArray* picURLArray;
@property(nonatomic,assign)id<PicNewsContentViewDelegate> delegate;
@property(nonatomic,assign)NSInteger lastPage;

-(void)setPage:(NSInteger)index animate:(BOOL)bAnimate;
-(void)setNextPageWithAnimate:(BOOL)bAnimate;

@end
