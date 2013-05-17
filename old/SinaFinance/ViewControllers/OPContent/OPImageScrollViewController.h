//
//  OPImageScrollViewController.h
//  NewsHD
//
//  Created by sgl on 12-9-18.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPImageScrollViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, assign) BOOL pagingEnabled;
@property (nonatomic, strong) NSMutableArray *imgViews;
@property (nonatomic, assign) NSInteger curPage;

- (void)showImages:(NSArray *)imgUrls;
@end
