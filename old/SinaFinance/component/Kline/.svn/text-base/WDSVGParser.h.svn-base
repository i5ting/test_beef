//
//  WDSVGParser.h
//  KlineView
//
//  Created by Sun Guanglei on 12-3-15.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"

@interface WDSVGParser : NSObject
{
    CGPoint origin;
    CGRect  dataRect;
    CGRect  fillRect;
    CGSize size;
    TFHpple *svgDoc;
    UIImage *svgImg;
    NSMutableArray *dataDesc;
    NSMutableArray *klineData;
}

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGRect  dataRect;
@property (nonatomic, assign) CGRect  fillRect;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, retain) UIImage *svgImg;
@property (nonatomic, retain) NSMutableArray *dataDesc;
@property (nonatomic, retain) NSMutableArray *klineData;
@property (nonatomic, assign) BOOL bVaild;

- (id)initWithSVG:(NSString *)svgPath;
- (id)initWithData:(NSData *)svgData;
- (void)doParse:(NSData *)svgData;

@end
