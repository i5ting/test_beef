//
//  CommentContentList.h
//  SinaNews
//
//  Created by shieh exbice on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsObject;

@interface CommentContentList : NSObject
{
    NSMutableArray* mContentObjects;
    NSMutableArray* mOrderList;
    NSMutableDictionary* mRelationList;
    NewsObject* mNews;
    NSLock* mLock;
}

-(void)addFromAnotherCommentContentList:(CommentContentList*)list;
-(void)refreshFromAnotherCommentContentList:(CommentContentList*)list;
-(void)refreshContentObjectsWithOrderList:(NSArray*)orderList relationList:(NSDictionary*)relationList news:(NewsObject*)news;
-(void)addContentObjectsWithOrderList:(NSArray*)orderList relationList:(NSDictionary*)relationList news:(NewsObject*)news;
-(NSInteger)countOfOrderList;
-(NSArray*)contentObjectsWithIndex:(NSInteger)index;

@end
