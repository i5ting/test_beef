//
//  NewsListView.h
//  SinaFinance
//
//  Created by Du Dan on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsContentViewController2.h"

@protocol NewsListDelegate;

@interface NewsListView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *newsArray;
    UITableView *newsTable;
    id <NewsListDelegate> delegate;
    NewsContentType contentType;
    
    BOOL isStockColumn;
}

@property (nonatomic, retain) id <NewsListDelegate> delegate;

@property (nonatomic, assign) BOOL isStockColumn;

//nArray is used to store NSDictionary, each item contains title, date, source, url
- (id)initWithData:(NSArray*)data frame:(CGRect)frame type:(NewsContentType)type;
- (void)reloadViewWithData:(NSArray*)data;
- (NSArray*)getNewsArray;

@end

@protocol NewsListDelegate <NSObject>

@optional
- (void)newsList:(NewsListView*)newsList didSelectNewsAtIndex:(NSInteger)index news:(NSDictionary*)dict;
- (void)newsList:(NewsListView*)newsList didSelectStockAtDict:(NSDictionary*)dict;
- (void)newsList:(NewsListView*)newsList didSelectFundAtDict:(NSDictionary*)dict;
- (void)didSelectMoreItem;

@end
