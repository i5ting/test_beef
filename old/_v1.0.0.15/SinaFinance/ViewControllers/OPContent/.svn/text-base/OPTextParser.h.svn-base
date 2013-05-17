//
//  OPTextParser.h
//  OPCoreText
//
//  Created by Sun Guanglei on 12-9-13.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "OPTable.h"

@class OPArticleObject;

typedef enum {
    OPTokenNone = 0,
    OPTokenImage,
    OPTokenTable
}OPTokenType;

@interface OPTextParser : NSObject {
    NSString *font;
    UIColor *color;
    UIColor *strokeColor;
    float strokeWidth;
    
    NSMutableArray* parsedImages;
}

@property (strong, nonatomic) NSString *font;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *strokeColor;
@property (assign, readwrite) float strokeWidth;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat paragraphSpace;
@property (nonatomic, assign) CGFloat titleSpace;

@property (strong, nonatomic) NSMutableArray *parsedImages;
@property (strong, nonatomic) NSMutableArray *videos;
@property (strong, nonatomic) NSMutableArray *articleImages;
@property (strong, nonatomic) NSMutableAttributedString *attributedContent;

@property (strong, nonatomic) NSMutableArray *talbes;
@property (assign, nonatomic) CGFloat tableWidth;

- (void)doParse:(NSString *)aString;
- (OPTokenType)parseToken:(NSString *)token location:(NSUInteger)location;

- (CGFloat)textHeight:(CGFloat)fixedWidth;

@end
