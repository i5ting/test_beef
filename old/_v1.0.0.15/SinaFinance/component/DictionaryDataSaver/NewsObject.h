//
//  NewsObject.h
//  SinaNews
//
//  Created by shieh exbice on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageURLData : NSObject {
@private
    NSString* _imageURL;
    CGSize _imageSize;
    NSString* _imageTitle;
    UIImage* _image;
}

@property(retain)NSString* imageURL;
@property(assign)CGSize imageSize;
@property(retain)NSString* imageTitle;
@property(retain)UIImage* image;
@end

@class CommentDataList;

@interface NewsObject : NSObject
{
@private
    NSDictionary* mNewsData;
    NSInteger mNewsType;
    NSMutableDictionary* mUserInfo;
}
@property(retain)NSDictionary* newsData;
@property(assign)NSInteger newsType;
@property(assign,readonly)NSString* dataString;
@property(assign,readonly)NSData* data;
@property(assign)CommentDataList* parentList;
@property(retain)NSArray* IDListInParentList;
@property(assign)NSInteger rowInParentList;

+(NewsObject*)objectWithJsonDict:(NSDictionary*)aJson;
+(NewsObject*)objectWithJsonString:(NSString*)aJson;
-(id)initWithNewsOBject:(NewsObject*)object;
-(id)initWithJsonDictionary:(NSDictionary*)aJson;
-(id)initWithJsonString:(NSString*)aJson;
-(id)initWithNewsData:(NSData*)aData;

-(NSDictionary*)dataDict;
-(NSArray*)allKeys;
-(NSString*)valueForKey:(NSString*)newsKey;
-(void)setValue:(id)value forKey:(NSString *)key;
-(void)setUserInfoValue:(id)value forKey:(NSString *)key;
-(id)userInfoValueForKey:(NSString*)newsKey;
-(NSArray*)imageURLDataList;
-(void)refreshToDataBase;
-(NSMutableDictionary*)mutableNewsData;
@end
