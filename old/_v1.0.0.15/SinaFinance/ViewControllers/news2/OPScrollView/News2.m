//
//  News2.m
//  SinaFinance
//
//  Created by sang on 10/25/12.
//
//

#import "News2.h"
@class TopNews;
@implementation News2 

@end


@implementation TopNews

@synthesize tid;
@synthesize category;
@synthesize type;
@synthesize order;
@synthesize ptime;
@synthesize mtime;
@synthesize url;
@synthesize comment;
@synthesize title;
@synthesize content;
@synthesize hdcontent;
@synthesize image;

-(id)initWithTid:(NSString *)tid
        category:(NSString *)pcategory
            type:(NSString *)type
        category:(NSString *)category
           order:(NSString *)order
           ptime:(NSString *)ptime
           mtime:(NSString *)mtime
             url:(NSString *)url
         comment:(NSString *)comment
           title:(NSString *)title
         content:(NSString *)content
       hdcontent:(NSString *)hdcontent
           image:(NSString *)image
{
    
    if (self = [super init]) {
        self.tid=tid;
        self.category =pcategory;
        self.order = order;
        self.ptime = ptime;
        self.mtime = mtime;
        self.url = url;
        self.comment = comment;
        self.title = title;
        self.content = content;
        self.hdcontent = hdcontent;
        self.image = image;
        
    }

    return self;
}

-(id)initWithDict:(NSDictionary *)dict
{
    
    if (self = [super init]) {
        self.tid=[dict objectForKey:@"id"];
        self.category =[dict objectForKey:@"category"];
        self.order = [dict objectForKey:@"category"];
        self.ptime = [dict objectForKey:@"ptime"];
        self.mtime = [dict objectForKey:@"mtime"];
        self.url = [dict objectForKey:@"url"];
        self.comment = [dict objectForKey:@"comment"];
        self.title = [dict objectForKey:@"title"];
        self.content = [dict objectForKey:@"content"];
        self.hdcontent = [dict objectForKey:@"hdcontent"];
        self.image = [dict objectForKey:@"image"];
        
    }
    
    return self;
}



@end
