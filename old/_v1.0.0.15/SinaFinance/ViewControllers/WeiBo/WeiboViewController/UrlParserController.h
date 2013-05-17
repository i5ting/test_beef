//
//  UrlParserView.h
//  SinaNews
//
//  Created by shieh exbice on 12-1-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UrlParserController;

@protocol UrlParser_Delegate <NSObject>

-(void)UrlParserHiden:(UrlParserController*)controller;
-(void)UrlParser:(UrlParserController*)controller urlString:(NSString*)urlString;
@end

@interface UrlParserController : UIViewController
{
    UITableView* mTable;
    NSString* parseString;
    NSArray* parsedRangeArray;
}

@property(nonatomic,retain)UITableView* table;
@property(nonatomic,assign)id<UrlParser_Delegate> delegate;
@property(nonatomic,retain)NSString* parseString;
@property(nonatomic,retain)NSArray* parsedRangeArray;

-(void)setURLString:(NSString*)urlString;
-(BOOL)show;

+(NSArray*)componetBySearchNetworkString:(NSString*)str;

@end
