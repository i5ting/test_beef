//
//  WDSVGParser.m
//  KlineView
//
//  Created by Sun Guanglei on 12-3-15.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "WDSVGParser.h"

@implementation WDSVGParser
@synthesize origin;
@synthesize dataRect;
@synthesize fillRect;
@synthesize size;
@synthesize svgImg;
@synthesize dataDesc;
@synthesize klineData;
@synthesize bVaild;

- (id)initWithSVG:(NSString *)svgPath
{
    self = [super init];
    if (self) {
        //
        NSData  *data = [NSData dataWithContentsOfFile:svgPath];
        [self doParse:data];
    }
    return self;
}

- (id)initWithData:(NSData *)svgData
{
    self = [super init];
    if (self) {
        //
        [self doParse:svgData];
    }
    return self;
}

- (CGSize)svgSize
{
    NSArray *elements = [svgDoc searchWithXPathQuery:@"//svg"];
    
    if (elements == nil || [elements count] < 1) {
        NSLog(@"Err: cant get svg size!");
        bVaild = NO;
        return CGSizeZero;
    }
    
    bVaild = YES;
    
    TFHppleElement *element = [elements objectAtIndex:0];
    NSInteger width = [[element objectForKey:@"width"] intValue];
    NSInteger height = [[element objectForKey:@"height"] intValue];
    return CGSizeMake(width, height);
}

// 获取坐标原点
- (CGPoint)svgOrigin
{
    NSInteger x = 0;
    NSInteger y = 0;
    
    NSArray *elements = [svgDoc searchWithXPathQuery:@"//circle[@class='start']"];
    
    if (elements == nil || [elements count] < 1) {
        NSLog(@"Err: no origin point info!");
        return CGPointZero;
    }
    
    TFHppleElement *element = [elements objectAtIndex:0];
    
    x = [[element objectForKey:@"cx"] intValue];
    y = [[element objectForKey:@"cy"] intValue];
    
    return CGPointMake(x, y);
}

// 获取坐标区域大小
- (void)svgRect
{
    NSInteger x = 0;
    NSInteger y = 0;
    
    NSArray *elements = [svgDoc searchWithXPathQuery:@"//circle[@class='end']"];
    
    if (elements == nil || [elements count] < 1) {
        NSLog(@"Err: no end point info!");
        return;
    }
    
    TFHppleElement *element = [elements objectAtIndex:0];
    
    x = [[element objectForKey:@"cx"] intValue];
    y = [[element objectForKey:@"cy"] intValue];
    
    NSArray *volElements = [svgDoc searchWithXPathQuery:@"//circle[@class='vol_start']"];
    CGPoint startPT = origin;
    
    if (volElements && [volElements count] == 1) {
        TFHppleElement *volElement = [volElements objectAtIndex:0];
        
        NSInteger x = 0;
        NSInteger y = 0;
        x = [[volElement objectForKey:@"cx"] intValue];
        y = [[volElement objectForKey:@"cy"] intValue];
        
        startPT = CGPointMake(x, y);
    }

    fillRect = CGRectMake(origin.x, y, x - origin.x, origin.y - y);
    dataRect = CGRectMake(startPT.x, y, x - startPT.x, startPT.y - y);
}

- (NSArray *)getFillPath
{
    NSArray * elements  = [svgDoc searchWithXPathQuery:@"//polyline[@class='main_line']"];
    
    if (elements == nil || [elements count] < 1) {
        NSLog(@"Err: no fill data!");
        return nil;
    }
    
    TFHppleElement * element = [elements objectAtIndex:0];
    
    NSString *points = [element objectForKey:@"points"];
    NSArray *pts = [points componentsSeparatedByString:@","];
    
    NSMutableArray *ptarr = [NSMutableArray arrayWithCapacity:200];
    
    for (NSString *pt in pts) {
        // NSLog(@"pt = (%@)", pt);
        NSArray *xy = [pt componentsSeparatedByString:@" "];
        if ([xy count] != 2) {
            continue;
        }
        
        NSInteger x = [[xy objectAtIndex:0] intValue];
        NSInteger y = [[xy objectAtIndex:1] intValue];
        NSValue *point = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [ptarr addObject:point];
    }
    
    return ptarr;
}

- (NSArray *)getAvgLine
{
    NSArray * elements  = [svgDoc searchWithXPathQuery:@"//polyline[@class='avg_line']"];
    
    if (elements == nil || [elements count] < 1) {
        NSLog(@"Err: no fill data!");
        return nil;
    }
    
    TFHppleElement * element = [elements objectAtIndex:0];
    
    NSString *points = [element objectForKey:@"points"];
    NSArray *pts = [points componentsSeparatedByString:@","];
    
    NSMutableArray *ptarr = [NSMutableArray arrayWithCapacity:200];
    
    for (NSString *pt in pts) {
        // NSLog(@"pt = (%@)", pt);
        NSArray *xy = [pt componentsSeparatedByString:@" "];
        if ([xy count] != 2) {
            continue;
        }
        
        NSInteger x = [[xy objectAtIndex:0] intValue];
        NSInteger y = [[xy objectAtIndex:1] intValue];
        NSValue *point = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [ptarr addObject:point];
    }
    
    return ptarr;
}

// <line xmlns="http://www.w3.org/2000/svg" x1="70" y1="106" x2="590" y2="106" style="stroke-dasharray: 8; stroke-width: 1; stroke: #9fa713;"/>

- (NSArray *)getLastPriceLine
{
    NSArray * elements  = [svgDoc searchWithXPathQuery:@"//line[@class='base_line']"];
    
    if (elements == nil || [elements count] < 1) {
        NSLog(@"Err: no fill data!");
        return nil;
    }
    
    TFHppleElement * element = [elements objectAtIndex:0];
    
    NSInteger x1 = 0;
    NSInteger y1 = 0;
    NSInteger x2 = 0;
    NSInteger y2 = 0;
    
    NSString *x1str = [element objectForKey:@"x1"];
    if (x1str) {
        x1 = [x1str intValue];
    }
    
    NSString *x2str = [element objectForKey:@"x2"];
    if (x2str) {
        x2 = [x2str intValue];
    }
    
    NSString *y1str = [element objectForKey:@"y1"];
    if (y1str) {
        y1 = [y1str intValue];
    }
    
    NSString *y2str = [element objectForKey:@"y2"];
    if (y2str) {
        y2 = [y2str intValue];
    }
    
    NSValue *start = [NSValue valueWithCGPoint:CGPointMake(x1, y1)];
    NSValue *end = [NSValue valueWithCGPoint:CGPointMake(x2, y2)];
    
    NSArray *ptarr = [NSArray arrayWithObjects:start, end, nil];
    
    return ptarr;
}

- (BOOL)fillImage:(CGContextRef)context
{
    NSArray *ptArray = [self getFillPath];
    
    if (ptArray == nil || [ptArray count] == 0) {
        return NO;
    }
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.0);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();  
    
    CGFloat components[] = {1.0, 1.0, 1.0, 1.0};  
    CGColorRef color = CGColorCreate(colorspace, components);  
    
    CGContextSetStrokeColorWithColor(context, color);
    
    @try {
        NSValue *val = [ptArray objectAtIndex:0];
        CGPoint pt = [val CGPointValue];
        CGPoint fstPt = pt;
        CGPoint lstPt = [[ptArray objectAtIndex:[ptArray count] - 1] CGPointValue];
        CGContextMoveToPoint(context, pt.x, pt.y);
        for (int i = 1; i < [ptArray count]; i++) {
            NSValue *val = [ptArray objectAtIndex:i];
            CGPoint pt = [val CGPointValue];
            CGContextAddLineToPoint(context, pt.x, pt.y);
        }
        
        CGContextAddLineToPoint(context, lstPt.x, origin.y);
        CGContextAddLineToPoint(context, fstPt.x, origin.y);
        CGContextClosePath(context);
        
        CGContextClip(context);
    }
    @catch (NSException *exception) {
        NSLog(@"%@, %@", exception.name, exception.reason);
    }
    @finally {
        
    }
    
    // draw the gradient
    CGFloat locs[3] = {0.0, 0.0, 1.0};
    
    // 1d71bd
    CGFloat colors[12] = {
        0x1d / 255.0,  0x71 / 255.0,  0xbd / 255.0, 1.0, // start
        0x1d / 255.0,  0x71 / 255.0,  0xbd / 255.0, 1.0, //
        0x1d / 255.0,  0x71 / 255.0,  0xbd / 255.0, 0.1 // end 
    };
    
    CGColorSpaceRef sp = CGColorSpaceCreateDeviceRGB();
    CGGradientRef grad = CGGradientCreateWithColorComponents(sp, colors, locs, 3);
    CGContextDrawLinearGradient(context, grad, CGPointMake(0, 0), CGPointMake(0, origin.y), 0);
    CGColorSpaceRelease(sp);
    CGGradientRelease(grad);
    
    CGContextRestoreGState(context);
    
    // 均价线
    NSArray *avgData = [self getAvgLine];
//    if (avgData == nil || [avgData count] == 0) {
//        return NO;
//    }
    
    if (avgData && [avgData count] > 1) {
        UIColor *color = [UIColor colorWithRed:(0xc2 / 255.0) green:(0x94 / 255.0) blue:(0x67 / 255.0) alpha:1.0];
        
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        
        NSValue *val = [avgData objectAtIndex:0];
        CGPoint startPt = [val CGPointValue];
        CGContextMoveToPoint(context, startPt.x, startPt.y);
        for (int i = 1; i < [avgData count]; i++) {
            NSValue *val = [avgData objectAtIndex:i];
            CGPoint pt = [val CGPointValue];
            CGContextAddLineToPoint(context, pt.x, pt.y);
        }
        
        CGContextStrokePath(context);
    }
    
    // 收盘价
    NSArray *lastPriceData = [self getLastPriceLine];
    if (lastPriceData && [lastPriceData count] == 2) {
        UIColor *color = [UIColor colorWithRed:(0x9f / 255.0) green:(0xa7 / 255.0) blue:(0x13 / 255.0) alpha:1.0];
        
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        
        CGFloat dashArray[] = {8,8};
        CGContextSetLineDash(context, 0, dashArray, 2);
        
        CGPoint  pt1 = [[lastPriceData objectAtIndex:0] CGPointValue];
        CGPoint  pt2 = [[lastPriceData objectAtIndex:1] CGPointValue];
        CGContextMoveToPoint(context, pt1.x, pt1.y);
        CGContextAddLineToPoint(context, pt2.x, pt2.y);
        
        CGContextStrokePath(context);
    }

    
    
    CGColorRelease(color);
    
    return YES;
}

- (UIImage *)imageFromSVG
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([self fillImage:context]) {
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
    
    return nil;
}

- (void)svgKlineData
{
    NSArray * elements  = [svgDoc searchWithXPathQuery:@"//desc[@class='last_info']"];
    
    if (elements == nil || [elements count] < 1) {
        NSLog(@"Err: no kline data!");
        klineData = nil;
        dataDesc = nil;
        return;
    }
    
    TFHppleElement * element = [elements objectAtIndex:0];
    
    NSString *points = [element content];
    NSArray *pts = [points componentsSeparatedByString:@","];
    
    self.klineData = [NSMutableArray arrayWithCapacity:200];
    
    self.dataDesc = nil;
    for (NSString *pt in pts) {
        if (dataDesc == nil) {
            self.dataDesc = [NSMutableArray arrayWithCapacity:1];
            [dataDesc addObjectsFromArray:[pt componentsSeparatedByString:@" "]];
        }
        else {
            [klineData addObject:[pt componentsSeparatedByString:@" "]];
        }
    }
}

- (void)doParse:(NSData *)svgData
{
    svgDoc = [[TFHpple alloc] initWithHTMLData:svgData];
    size = [self svgSize];
    origin = [self svgOrigin];
    [self svgRect];
    [self svgKlineData];
    self.svgImg = [self imageFromSVG];
}

- (void)dealloc
{
    [svgDoc release];
    [svgImg release];
    [dataDesc release];
    [klineData release];
    [super dealloc];
}

@end
