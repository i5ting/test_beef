//
//  CommentContentList.m
//  SinaNews
//
//  Created by shieh exbice on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommentContentList.h"
#import "NewsObject.h"
#import "NewsFuncPuller.h"

@interface CommentContentList() 

@property(retain)NSMutableArray* contentObjects;
@property(retain)NSMutableArray* orderList;
@property(retain)NSMutableDictionary* relationList;
@property(retain)NewsObject* news;

@property(retain)NSLock* lock;


-(void)initAllObjects;

@end

@implementation CommentContentList

@synthesize contentObjects=mContentObjects,relationList=mRelationList,orderList=mOrderList,news=mNews;
@synthesize lock=mLock;

-(id)init
{
    self = [super init];
    if (self) {
        mLock = [[NSLock alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [mContentObjects release];
    [mOrderList release];
    [mRelationList release];
    [mLock release];
    [mNews release];
    
    [super dealloc];
}

-(void)initAllObjects
{
    if (!self.contentObjects) {
        self.contentObjects = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (!self.orderList) {
        self.orderList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (!self.relationList) {
        self.relationList = [[NSMutableDictionary alloc] initWithCapacity:0];
    }

}

-(void)refreshFromAnotherCommentContentList:(CommentContentList*)list
{
    [self initAllObjects];
    [self.lock lock];
    [self.orderList removeAllObjects];
    [self.relationList removeAllObjects];
    self.news = nil;
    [self.lock unlock];
    [self addFromAnotherCommentContentList:list];
}

-(void)addFromAnotherCommentContentList:(CommentContentList*)list
{
    [self initAllObjects];
    [self.lock lock];
    [self.orderList addObjectsFromArray:list.orderList];
    [self.relationList addEntriesFromDictionary:list.relationList];
    self.news = list.news;
    [self.lock unlock];
}

-(void)refreshContentObjectsWithOrderList:(NSArray*)orderList relationList:(NSDictionary*)relationList news:(NewsObject*)news
{
    [self initAllObjects];
    [self.lock lock];
    [self.orderList removeAllObjects];
    [self.relationList removeAllObjects];
    self.news = nil;
    [self.lock unlock];
    [self addContentObjectsWithOrderList:orderList relationList:relationList news:news];
}

-(void)addContentObjectsWithOrderList:(NSArray*)orderList relationList:(NSDictionary*)relationList news:(NewsObject*)news
{
    [self initAllObjects];
    [self.lock lock];
    [self.orderList addObjectsFromArray:orderList];
    [self.relationList addEntriesFromDictionary:relationList];
    self.news = news;
    [self.lock unlock];
}

-(NSInteger)countOfOrderList
{
    [self.lock lock];
    int orderListCount = [self.orderList count];
    [self.lock unlock];
    return orderListCount;
}

-(NSArray*)contentObjectsWithIndex:(NSInteger)index
{
    NSMutableArray* rtval = [NSMutableArray arrayWithCapacity:0];
    [self.lock lock];
    if (index<[self.orderList count]) {
        NewsObject* commentObject = [self.orderList objectAtIndex:index];
        NSString* mid = [commentObject valueForKey:CommentContentObject_mid];
        NSMutableArray* relationArray = [self.relationList objectForKey:mid];
        [rtval addObjectsFromArray:relationArray];
        [rtval addObject:commentObject];
    }
    [self.lock unlock];
    
    return rtval;
}

@end
