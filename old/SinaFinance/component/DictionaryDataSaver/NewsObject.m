//
//  NewsObject.m
//  SinaNews
//
//  Created by shieh exbice on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NewsObject.h"
#import "CommentDataList.h"
#import "JSONKit.h"
#import "MyTool.h"

NSString* NewsObject_Seperate = @"|>";

NSString* NewsObject_Images = @"images";
NSString* NewsObject_TypeKey = @"TypeKey{}";

@implementation ImageURLData

@synthesize imageURL=_imageURL,imageSize=_imageSize,imageTitle=_imageTitle,image=_image;

-(id)init
{
    self = [super init];
    _imageSize = CGSizeZero;
    
    return self;
}

-(void)dealloc
{
    [_image release];
    [_imageTitle release];
    [_imageURL release];
    
    [super dealloc];
}

@end

@interface NewsObject ()

@property(retain)NSMutableDictionary* userInfo;

@end

@implementation NewsObject

@synthesize newsData = mNewsData;
@synthesize newsType = mNewsType;
@synthesize userInfo=mUserInfo;
@synthesize dataString;
@synthesize data;
@synthesize parentList;
@synthesize IDListInParentList;
@synthesize rowInParentList;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        mNewsType = 0;
    }
    
    return self;
}

-(void)dealloc
{
    [mNewsData release];
    [mUserInfo release];
    [IDListInParentList release];
    
    [super dealloc];
}

+(NewsObject*)objectWithJsonDict:(NSDictionary*)aJson
{
    NewsObject* rtval = nil;
    if (aJson&&[aJson isKindOfClass:[NSDictionary class]]) {
        rtval = [[[NewsObject alloc] init] autorelease];
        rtval.newsData = aJson;
    }
    return rtval;
}

+(NewsObject*)objectWithJsonString:(NSString*)aJson
{
    NewsObject* rtval = nil;
    NSDictionary* dict = [aJson objectFromJSONString];
    if (dict&&[dict isKindOfClass:[NSDictionary class]]) {
        rtval = [[[NewsObject alloc] init] autorelease];
        rtval.newsData = dict;
    }
    return rtval;
}

-(id)initWithCoder: (NSCoder *) decoder
{
    if (self=[super init]) {
        mNewsData = [[decoder decodeObjectForKey:@"data"] retain];
        mNewsType = [decoder decodeIntForKey:@"type"];
        mUserInfo = [[decoder decodeObjectForKey:@"userinfo"] retain];
    }
    return self;
}

-(void)encodeWithCoder: (NSCoder*)encoder
{
    if (self.newsData) {
        [encoder encodeObject:self.newsData forKey:@"data"];
    }
	[encoder encodeInt:self.newsType forKey:@"type"];
    if (self.userInfo) {
        [encoder encodeObject:self.userInfo forKey:@"userinfo"];
    }
}

-(id)initWithNewsOBject:(NewsObject*)object
{
    self = [super init];
    if (self) {
        self.newsData = object.newsData;
    }
    return self;
}

-(id)initWithJsonDictionary:(NSDictionary*)aJson
{
    self = [super init];
    if (self) {
        if (aJson&&[aJson isKindOfClass:[NSDictionary class]]) {
            mNewsData = aJson;
            [mNewsData retain];
        }
    }
    return self;
}

-(id)initWithNewsData:(NSData*)aData
{
    self = [super init];
    if (self) {
        if (aData&&[aData isKindOfClass:[NSData class]]) {
            NSString* tempString = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
            NSDictionary* dict = [tempString objectFromJSONString];
            if (dict&&[dict isKindOfClass:[NSDictionary class]]) {
                mNewsData = dict;
                [mNewsData retain];
            }
            [tempString release];
        }
    }
    return self;
}

-(id)initWithJsonString:(NSString*)aJson
{
    self = [super init];
    if(self){
        NSDictionary* dict = [aJson objectFromJSONString];
        if(dict&&[dict isKindOfClass:[NSDictionary class]]){
            mNewsData = dict;
            [mNewsData retain];
        }
    }
    return self;
}

-(NSString*)dataString
{
    NSString* rtval = nil;
    rtval = [mNewsData JSONString];
    return rtval;
}

-(NSString*)valueForKey:(NSString*)newsKey
{
    NSString* rtval = nil;
    if (newsKey) {
        NSArray* keysArray = [newsKey componentsSeparatedByString:NewsObject_Seperate];
        id parentDict = mNewsData;
       
        for (int i=0; i<[keysArray count]; i++) {
            NSString* key = [keysArray objectAtIndex:i];
            id ret = nil;
            if ([parentDict isKindOfClass:[NSDictionary class]]) {
                NSDictionary* dict = (NSDictionary*)parentDict;
                ret = [dict objectForKey:key];
            }
            else if ([parentDict isKindOfClass:[NSArray class]]) {
                NSArray* array = (NSArray*)parentDict;
                int keyInt = [key intValue];
                if ([array count]>keyInt) {
                    ret = [array objectAtIndex:keyInt];
                }
            }
            
            if ([ret isKindOfClass:[NSString class]]) {
                rtval = (NSString*)ret;
                break;
            }
            else
            {
                parentDict = ret;
            }
            if (i==[keysArray count]-1) {
                rtval = ret;
            }
        }
        
    }
    if ([rtval isKindOfClass:[NSNumber class]]) {
        rtval = [(NSNumber*)rtval stringValue];
    }
    if ([rtval isKindOfClass:[NSNull class]]) {
        rtval = @"";
    }
    return rtval;
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([self.newsData isKindOfClass:[NSMutableDictionary class]]) {
        NSMutableDictionary* customData = (NSMutableDictionary*)self.newsData;
        [customData setValue:value forKey:key];
    }
    else {
        NSMutableDictionary* newDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [newDict addEntriesFromDictionary:self.newsData];
        self.newsData = newDict;
        [newDict setValue:value forKey:key];
        [newDict release];
    }
}

-(NSMutableDictionary*)mutableNewsData
{
    if ([self.newsData isKindOfClass:[NSMutableDictionary class]]) {
        return (NSMutableDictionary*)self.newsData;
    }
    else {
        NSMutableDictionary* newDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [newDict addEntriesFromDictionary:self.newsData];
        self.newsData = newDict;
        [newDict release];
        
        return newDict;
    }
}

-(NSArray*)imageURLDataList
{
    NSMutableArray* rtval = [NSMutableArray arrayWithCapacity:0];
    NSArray* images = [mNewsData objectForKey:NewsObject_Images];
    if (images) {
        for (NSDictionary* imageDict in images) {
            ImageURLData* urlData = [[ImageURLData alloc] init];
            urlData.imageURL = [imageDict objectForKey:@"url"];
            urlData.imageTitle = [imageDict objectForKey:@"title"];
            NSNumber* width = (NSNumber*)[imageDict objectForKey:@"width"];
            NSNumber* height = (NSNumber*)[imageDict objectForKey:@"height"];
            if (width&&height) {
                if ([MyTool isRetina]) {
                    urlData.imageSize = CGSizeMake([width intValue]/2, [height intValue]/2);
                }
                else
                {
                    urlData.imageSize = CGSizeMake([width intValue], [height intValue]);
                }
            }
            else {
                urlData.imageSize = CGSizeZero;
            }
            [rtval addObject:urlData];
            [urlData release];
        }
    }
    
    if ([rtval count]>0) {
        return rtval;
    }
    else
    {
        return nil;
    }
}

-(void)setUserInfoValue:(id)value forKey:(NSString *)key
{
    if (!mUserInfo) {
        mUserInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    if (value) {
        [self.userInfo setValue:value forKey:key];
    }
    else
    {
        [self.userInfo removeObjectForKey:key];
    }
}

-(id)userInfoValueForKey:(NSString*)newsKey
{
    return [self.userInfo valueForKey:newsKey];
}

-(NSData*)data
{
    NSData* rtval = nil;
    NSString* dataStr = [mNewsData JSONString];
    rtval = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    return rtval;
    
}
-(NSDictionary*)dataDict
{
    return self.newsData;
}

-(NSArray*)allKeys
{
    return [self.newsData allKeys];
}

-(void)refreshToDataBase
{
    [self.parentList refreshDataBaseWithOneCommnetContent:self dataIDList:self.IDListInParentList row:self.rowInParentList];
}

@end
