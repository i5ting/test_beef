//
//  OPTextParser.m
//  OPCoreText
//
//  Created by Sun Guanglei on 12-9-13.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "OPTextParser.h"

/* Callbacks */
static void deallocCallback( void* ref ){
    [(id)ref release];
}
static CGFloat ascentCallback( void *ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"width"] floatValue];
}

@implementation OPTextParser
@synthesize font, color, strokeColor, strokeWidth;
@synthesize parsedImages;
@synthesize videos;
@synthesize attributedContent;
@synthesize articleImages;
@synthesize maxWidth;

-(id)init
{
    self = [super init];
    if (self) {
        self.font = @"FZLTHJW--GB1-0";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.parsedImages = [NSMutableArray array];
        attributedContent = [[NSMutableAttributedString alloc] initWithString:@""];
        self.fontSize = 18.0;
        self.lineSpace = self.fontSize * 0.8;
        self.paragraphSpace = 1.0;
        self.titleSpace = 8.0;
        self.tableWidth = 310.0;
        self.maxWidth = 310.0;
    }
    return self;
}

-(void)dealloc
{
    self.font = nil;
    self.color = nil;
    self.strokeColor = nil;
    self.parsedImages = nil;
    [attributedContent release];
    [articleImages release];
    [videos release];
    [_talbes release];
    
    [super dealloc];
}

- (void)doParse:(NSString *)aString
{
    __block NSUInteger tokenStart = 0;
    __block NSUInteger tokenEnd = 0;
    __block OPTextParser *parser = self;
    __block OPTokenType tokenType = OPTokenNone;
    __block NSUInteger paragraphStart = 0;
    __block BOOL tokenContent = NO;
    __block NSUInteger totoalTokenSize = 0;
    __block BOOL addParagraph = NO;
    
    NSMutableString *current = [NSMutableString stringWithCapacity:20];
    
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font,
                                             _fontSize, NULL);
    
    CFIndex theNumberOfSettings = 2;
    
    CTTextAlignment theAlignment = kCTTextAlignmentLeft;
    CGFloat lineSpacing = 8.0;
    CTParagraphStyleSetting theSettings[3] = {{ kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &theAlignment },
        {kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing},{kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &_paragraphSpace}
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
    //apply the current text style //2
    NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (id)self.color.CGColor, kCTForegroundColorAttributeName,
                           (id)fontRef, kCTFontAttributeName,
                           (id)self.strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                           (id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                           (id)theParagraphRef, (id)kCTParagraphStyleAttributeName,
                           nil];
    
    NSRange range;
    range.location = 0;
    range.length = aString.length;
    
    [aString enumerateSubstringsInRange:range options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        // 处理标记开始“{{”
        if ([substring isEqualToString:@"{"]
            || [substring isEqualToString:@"|"]) {
            [current appendString:substring];
            if ([current isEqualToString:@"{{"]
                || [current isEqualToString:@"{|"]) {
                tokenStart = substringRange.location - 1;
                [current setString:@""];
                tokenContent = YES;
                // 如果标记前无换行符则增加一个
                if (tokenStart > 0) {
                    NSRange preStrRange;
                    preStrRange.location = tokenStart - 1;
                    preStrRange.length = 1;
                    NSString *preStr = [aString substringWithRange:preStrRange];
                    if (preStr != nil
                        && ![preStr isEqualToString:@"\n"]) {
                        [parser.attributedContent appendAttributedString:[[[NSAttributedString alloc] initWithString:@"\n" attributes:attrs] autorelease]];
                        if (paragraphStart < tokenStart - 1) {
                            NSRange attrStrRange;
                            attrStrRange.location = paragraphStart;
                            attrStrRange.length = tokenStart - paragraphStart;
                            
                            NSString *paragraphStr = [NSString stringWithFormat:@"%@\n", [aString substringWithRange:attrStrRange]];
                            [parser.attributedContent appendAttributedString:[[[NSAttributedString alloc] initWithString:paragraphStr attributes:attrs] autorelease]];
                        }
                    }
                }
            }
            else {
                [current setString:substring];
            }
        }
        
        // 处理标记结束“}}”
        if ([substring isEqualToString:@"}"]) {
            [current appendString:substring];
            if ([current isEqualToString:@"}}"]
                || [current isEqualToString:@"|}"]) {
                tokenEnd = substringRange.location;
                [current setString:@""];
                tokenContent = NO;
                // token end
                NSRange tokenRange;
                tokenRange.location = tokenStart;
                tokenRange.length = tokenEnd - tokenStart + 1;
                // TODO: 这里可以根据已生成的NSAttributedString字符串去判断location
                tokenType = [parser parseToken:[aString substringWithRange:tokenRange] location:tokenStart - totoalTokenSize];
                totoalTokenSize += tokenRange.length - 1; //因为替换了token，所以，token在原始字符串中的位置和在生成的字符串中的位置不一致，需要处理一下
                
                // 如果标记结束无换行符则增加一个
                if (tokenEnd < aString.length) {
                    NSRange nextStrRange;
                    nextStrRange.location = tokenEnd + 1;
                    nextStrRange.length = 1;
                    NSString *nextStr = [aString substringWithRange:nextStrRange];
                    if (nextStr != nil
                        && ![nextStr isEqualToString:@"\n"]) {
                        [parser.attributedContent appendAttributedString:[[[NSAttributedString alloc] initWithString:@"\n" attributes:attrs] autorelease]];
                        paragraphStart = tokenEnd + 1;
                        addParagraph = YES;
                    }
                }
            }
            else {
                [current setString:substring];
            }
        }
        
        // 判断是否为token行
        if (tokenContent == NO &&
            [substring isEqualToString:@"\n"]) {
            if (tokenEnd == 0) {
                if (tokenType == OPTokenImage) {
                    // 该行是图片标题，文字需要居中
                    CTTextAlignment theAlignment = kCTCenterTextAlignment;
                    CFIndex theNumberOfSettings = 2;
                    CTParagraphStyleSetting theSettings[2] = {{ kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &theAlignment },
                        {kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &_titleSpace}
                    };
                    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
                    
                    
                    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:attrs];
                    [attributes setObject:(id)theParagraphRef forKey:(id)kCTParagraphStyleAttributeName];
                    
                    NSRange attrStrRange;
                    attrStrRange.location = paragraphStart - 1;
                    attrStrRange.length = substringRange.location + 2 - paragraphStart;
                    
                    NSString *imgTitle = [aString substringWithRange:attrStrRange];
                    [parser.attributedContent appendAttributedString:[[[NSAttributedString alloc] initWithString:imgTitle attributes:attributes] autorelease]];
                    
                    tokenType = OPTokenNone;
                }
                else {// 创建段落NSAttributedString
                    NSRange attrStrRange;
                    attrStrRange.location = paragraphStart;
                    attrStrRange.length = substringRange.location + 1 - paragraphStart;
                    
                    [parser.attributedContent appendAttributedString:[[[NSAttributedString alloc] initWithString:[aString substringWithRange:attrStrRange] attributes:attrs] autorelease]];
                }
            }
            else {
                // 该行是标记行，跳过
                tokenStart = 0;
                tokenEnd = 0;
                if (addParagraph) {
                    NSRange attrStrRange;
                    attrStrRange.location = paragraphStart;
                    attrStrRange.length = substringRange.location + 1 - paragraphStart;
                    
                    [parser.attributedContent appendAttributedString:[[[NSAttributedString alloc] initWithString:[aString substringWithRange:attrStrRange] attributes:attrs] autorelease]];
                    addParagraph = NO;
                }
            }
            // 新的段落开始
            paragraphStart = substringRange.location + 1;
        }
        else {
            // 处理最后没有换行符的情况
            if (aString.length == substringRange.location + substringRange.length) {
                    NSRange attrStrRange;
                    attrStrRange.location = paragraphStart;
                    attrStrRange.length = substringRange.location + 1 - paragraphStart;
                    
                    [parser.attributedContent appendAttributedString:[[[NSAttributedString alloc] initWithString:[aString substringWithRange:attrStrRange] attributes:attrs] autorelease]];
            }
        }
    }];
}

- (OPTokenType)parseToken:(NSString *)token  location:(NSUInteger)location
{
    if (token.length < 10) {
        //add the image for drawing
        NSRange indexRange;
        indexRange.location = 2;
        indexRange.length = token.length - 4;
        NSInteger index = [[token substringWithRange:indexRange] integerValue] - 1;
        if (index >= articleImages.count) {
            return OPTokenNone;
        }
        NSDictionary *imgdict = [self.articleImages objectAtIndex:index];
        NSInteger width = [[imgdict objectForKey:@"width"] intValue];
        NSInteger height = [[imgdict objectForKey:@"height"] intValue];
        NSString *url = [imgdict objectForKey:@"url"];
        if (width>maxWidth) {
            height = maxWidth*(height*1.0/width);
            width = maxWidth;
        }
        
        NSUInteger imgLocation = [self.attributedContent length];
        [self.parsedImages addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithInt:width], @"width",
          [NSNumber numberWithInt:height], @"height",
          url, @"url",
          [NSNumber numberWithInt:imgLocation], @"location",
          nil]
         ];
        
        //render empty space for drawing the image in the text //1
        CTRunDelegateCallbacks callbacks;
        callbacks.version = kCTRunDelegateVersion1;
        callbacks.getAscent = ascentCallback;
        callbacks.getDescent = descentCallback;
        callbacks.getWidth = widthCallback;
        callbacks.dealloc = deallocCallback;
        
        NSDictionary* imgAttr = [[NSDictionary dictionaryWithObjectsAndKeys: //2
                                  [NSNumber numberWithInt:width], @"width",
                                  [NSNumber numberWithInt:height], @"height",
                                  nil] retain];
        
        //
        CTTextAlignment theAlignment = kCTCenterTextAlignment;
        CFIndex theNumberOfSettings = 1;
        CTParagraphStyleSetting theSettings[1] = {{ kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &theAlignment }};
        CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
        
        
        CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, imgAttr); //3

        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:(id)theParagraphRef, (id)kCTParagraphStyleAttributeName,
                                    (id)delegate, (NSString*)kCTRunDelegateAttributeName, nil];
        //add a space to the text so that it can call the delegate
        [self.attributedContent appendAttributedString:[[[NSAttributedString alloc] initWithString:@" " attributes:attributes] autorelease]];
        return OPTokenImage;
    }
    else if ([token hasPrefix:@"{|TABLE"]) {
        UIView *tableView = [self createTable:token];
        NSUInteger imgLocation = [self.attributedContent length];
        [self.parsedImages addObject:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithInt:tableView.frame.size.width], @"width",
          [NSNumber numberWithInt:tableView.frame.size.height], @"height",
          tableView, @"view",
          [NSNumber numberWithInt:imgLocation], @"location",
          nil]
         ];
        
        //render empty space for drawing the image in the text //1
        CTRunDelegateCallbacks callbacks;
        callbacks.version = kCTRunDelegateVersion1;
        callbacks.getAscent = ascentCallback;
        callbacks.getDescent = descentCallback;
        callbacks.getWidth = widthCallback;
        callbacks.dealloc = deallocCallback;
        
        NSDictionary* imgAttr = [[NSDictionary dictionaryWithObjectsAndKeys: //2
                                  [NSNumber numberWithInt:tableView.frame.size.width], @"width",
                                  [NSNumber numberWithInt:tableView.frame.size.height], @"height",
                                  nil] retain];
        
        //
        CTTextAlignment theAlignment = kCTCenterTextAlignment;
        CFIndex theNumberOfSettings = 1;
        CTParagraphStyleSetting theSettings[1] = {{ kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &theAlignment }};
        CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, theNumberOfSettings);
        
        
        CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, imgAttr); //3
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:(id)theParagraphRef, (id)kCTParagraphStyleAttributeName,
                                    (id)delegate, (NSString*)kCTRunDelegateAttributeName, nil];
        //add a space to the text so that it can call the delegate
        [self.attributedContent appendAttributedString:[[[NSAttributedString alloc] initWithString:@" " attributes:attributes] autorelease]];
        return OPTokenTable;
    }
    return OPTokenNone;
}

- (UIView *)createTable:(NSString *)tableToken
{
    
    NSString *tableString = [[tableToken stringByReplacingOccurrencesOfString:@"\n" withString:@""]
                             stringByReplacingOccurrencesOfString:@"|}" withString:@""];
    
    NSMutableArray *tableArray = [[[NSMutableArray alloc] init] autorelease];
    NSArray *rowArray = [tableString componentsSeparatedByString:@"|-"];
    if ([rowArray count] <= 2) {
        return nil;
    }
    
    int column = 0;
    
    for (int row = 1; row < [rowArray count]; row++)
	{
		NSString *rowString = [rowArray objectAtIndex:row];
        if (rowString.length <= 0) {
            continue;
        }
        
        NSArray *colArray = [rowString componentsSeparatedByString:@"||"];
        if (column < colArray.count) {
            column = colArray.count;
        }
        
        [tableArray addObject:colArray];
    }
	
    NSMutableArray *tableItems = [NSMutableArray arrayWithCapacity:tableArray.count * column];
    [tableArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj count] < column) {
            // Add NSNull
            if ([obj count] == 1) {
                // 添加独行标记         
                [tableItems addObject:[NSString stringWithFormat:@"^%@", [obj objectAtIndex:0]]];
            }
            else {
                [tableItems addObjectsFromArray:obj];
            }
            
            for (int i = [obj count]; i < column; i++) {
                [tableItems addObject:[NSNull null]];
            }
        }
        else {
            [tableItems addObjectsFromArray:obj];
        }
    }];
    
    OPTable *tableView = [[[OPTable alloc] initWithFrame:CGRectMake(0, 0, _tableWidth, 1000) column:column] autorelease];
    tableView.gridItems = tableItems;
    return tableView;
}

- (CGFloat)textHeight:(CGFloat)fixedWidth
{
    CGFloat total_height = 0;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedContent);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, fixedWidth, 50000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    if ([linesArray count] == 0) {
        return 24.0;
    }
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    CGFloat line_y = origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    CTLineRef line = (CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    total_height = 50000 - line_y + descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    CFRelease(textFrame);
    return ceilf(total_height);
}

@end
