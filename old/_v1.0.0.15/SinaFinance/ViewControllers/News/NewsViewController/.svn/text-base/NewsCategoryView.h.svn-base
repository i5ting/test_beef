//
//  NewsCategoryView.h
//  SinaFinance
//
//  Created by Du Dan on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsCategoryDelegate;

@interface NewsCategoryView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    id <NewsCategoryDelegate> delegate;
}

@property (nonatomic, retain) id <NewsCategoryDelegate> delegate;

@end


@protocol NewsCategoryDelegate <NSObject>

- (void)newsCategoryView:(NewsCategoryView*)categoryView didSelectCategoryAtItem:(NSDictionary*)itemDict;

@end
