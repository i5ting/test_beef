//
//  WDKlineAnimation.m
//  TestXML
//
//  Created by Sun Guanglei on 12-3-15.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "WDKlineAnimation.h"

#define LINE_COLOR [UIColor colorWithRed:0x45/255.0 green:0xa9/255.0 blue:0xea/255.0 alpha:1.0].CGColor
#define LINE_WIDTH 0.5
#define MAFONT_SIZE 10
#define LABEL_HEIGHT 10
#define OFFSET_X 10

// #define SCALE [[UIScreen] mainscreen].scale
#define SCALE 2.0

@implementation WDKlineAnimation

@synthesize lineRect;
@synthesize descData;
@synthesize klineData;
@synthesize dataOrigin;
@synthesize delegate;
@synthesize dataLabelFont;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        maStart = 0;
        
        topDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(OFFSET_X, 0, frame.size.width - OFFSET_X, LABEL_HEIGHT)];
        
        dataLabelFont = nil;
        topDataLabel.backgroundColor = [UIColor clearColor];
        topDataLabel.textColor = [UIColor whiteColor];
        topDataLabel.font = [UIFont systemFontOfSize:9.0];
        topDataLabel.adjustsFontSizeToFitWidth = YES;
        // topDataLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:topDataLabel];
        
        MA5Label = [self addMALabelWithColor:[UIColor colorWithRed:0xa5/255.0 green:0xbc/255.0 blue:0x20/255.0 alpha:1.0] align:UITextAlignmentLeft];
        MA10Label = [self addMALabelWithColor:[UIColor colorWithRed:0xb5/255.0 green:0.0 blue:0x58/255.0 alpha:1.0] align:UITextAlignmentCenter];
        MA30Label = [self addMALabelWithColor:[UIColor whiteColor] align:UITextAlignmentRight];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, LINE_WIDTH);
    CGContextSetStrokeColorWithColor(context, LINE_COLOR);
    // CGContextSetFillColor(context, CGColorGetComponents([UIColor whiteColor].CGColor));
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    if (bDraw) {
        if (CGPointEqualToPoint(vLineStartPt, CGPointZero)!=YES&&CGPointEqualToPoint(vLineEndPt, CGPointZero)!=YES&&CGPointEqualToPoint(hLineStartPt, CGPointZero)!=YES&&CGPointEqualToPoint(hLineEndPt, CGPointZero)!=YES) {
            CGContextMoveToPoint(context, vLineStartPt.x, vLineStartPt.y);
            CGContextAddLineToPoint(context, vLineEndPt.x, vLineEndPt.y);
            
            CGContextMoveToPoint(context, hLineStartPt.x, hLineStartPt.y);
            CGContextAddLineToPoint(context, hLineEndPt.x, hLineEndPt.y);
        }

    }

    CGContextStrokePath(context);
    
    if (bDraw) {
        if (CGPointEqualToPoint(vLineStartPt, CGPointZero)!=YES&&CGPointEqualToPoint(vLineEndPt, CGPointZero)!=YES&&CGPointEqualToPoint(hLineStartPt, CGPointZero)!=YES&&CGPointEqualToPoint(hLineEndPt, CGPointZero)!=YES) {
            // CGPoint *arcPt = CGPointMake(hLineEndPt.x, vLineEndPt.y);
            CGContextAddArc(context, vLineEndPt.x, hLineEndPt.y, 2.0, 0.0, 1.0, 1);
            CGContextFillPath(context);
        }
        
    }
}

- (NSMutableArray *)combineArraysWithFormat:(NSString *)mergeFormat
                                   array1:(NSArray *)arr1
                                   array2:(NSArray *)arr2
{
    if (arr1 == nil || arr2 == nil
        || [arr1 count] != [arr2 count])
    {
        return nil;
    }
    
    NSMutableArray *retArr = [NSMutableArray arrayWithCapacity:[arr1 count]];
    
    for (int i = 0; i < [arr1 count]; i++) {
        [retArr addObject:[NSString stringWithFormat:mergeFormat, [arr1 objectAtIndex:i], [arr2 objectAtIndex:i]]];
    }
    
    return retArr;
}

- (NSString *)combineStringInArray:(NSString *)seperate strArray:(NSArray *)arr
{
    if (arr == nil) {
        return nil;
    }
    
    NSString *str = [[[NSString alloc] init] autorelease];
    for (int i = 0; i < [arr count] - 1; i++) {
        str = [str stringByAppendingFormat:@"%@%@", [arr objectAtIndex:i], seperate];
    }
    
    str = [str stringByAppendingFormat:@"%@", [arr lastObject]];
    
    return str;
}

- (UILabel *)addMALabelWithColor:(UIColor *)textColor align:(UITextAlignment)textAlign
{
    UILabel *retLabel = [[UILabel alloc] init];
    
    retLabel.backgroundColor = [UIColor clearColor];
    retLabel.textColor = textColor;
    retLabel.textAlignment = textAlign;
    retLabel.font = [UIFont systemFontOfSize:MAFONT_SIZE];
    
    [self addSubview:retLabel];
    
    return retLabel;
}

- (void)updateLabels:(NSArray *)dataArray
{
    NSRange topdataRange;
    topdataRange.location = 3;
    topdataRange.length = maStart - topdataRange.location;
    
    NSRange maRange;
    maRange.location = maStart;
    maRange.length = [descData count] - maStart;
    
    NSMutableArray *formatedArr = [self combineArraysWithFormat:@"%@:%@"
                                                         array1:descData array2:dataArray];
    
    NSString *topData = [self combineStringInArray:@"  "
                                          strArray:[formatedArr subarrayWithRange:topdataRange]];
    
    // 时间标签不显示
    NSString *dataTime = [dataArray objectAtIndex:2];
    dataTime = [dataTime stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    if (dataTime == nil) {
        dataTime = @" ";
    }
    
    if (topData == nil) {
        topData = @" ";
    }
    
    if ([delegate respondsToSelector:@selector(klineAnimationTouchedWithDateString:KeyData:valueData:)]) {
        topDataLabel.text = @"";
        NSArray* keyData = nil;
        NSArray* valueData = nil;
        if (descData&&dataArray&&[descData count]==[dataArray count]) {
            keyData = [descData subarrayWithRange:topdataRange];
            valueData = [dataArray subarrayWithRange:topdataRange];
        }
        [delegate klineAnimationTouchedWithDateString:dataTime KeyData:keyData valueData:valueData];
    }
    else {
        if ([delegate respondsToSelector:@selector(stringForklineAnimationTouchedWithDateString:KeyData:valueData:)]) {
            NSArray* keyData = nil;
            NSArray* valueData = nil;
            if (descData&&dataArray&&[descData count]==[dataArray count]) {
                keyData = [descData subarrayWithRange:topdataRange];
                valueData = [dataArray subarrayWithRange:topdataRange];
            }
            topDataLabel.text = [delegate stringForklineAnimationTouchedWithDateString:dataTime KeyData:keyData valueData:valueData];
        }
        else {
            topDataLabel.text = [NSString stringWithFormat:@"%@  %@", dataTime, topData];
        }
    }
    
    // 判断描述里是否有MA标签，有的话则设置Label值
    if (maStart > 0 && maStart + 2 < [descData count]) {
        if ([dataArray objectAtIndex:maStart] != nil) {
            MA5Label.text = [NSString stringWithFormat:@"MA5:%@", [dataArray objectAtIndex:maStart]];
        }
        if ([dataArray objectAtIndex:maStart + 1] != nil) {
            MA10Label.text = [NSString stringWithFormat:@"MA10:%@", [dataArray objectAtIndex:maStart + 1]];
        }
        if ([dataArray objectAtIndex:maStart + 2] != nil) {
            MA30Label.text = [NSString stringWithFormat:@"MA30:%@", [dataArray objectAtIndex:maStart + 2]];
        }
    }
    
    [topDataLabel setNeedsDisplay];
}

- (void)showData:(CGPoint)touchPt lastPrice:(BOOL)bShow
{
    NSInteger offset = (int)(touchPt.x * SCALE - lineRect.origin.x + dataOrigin.x);
    id pre_data = nil;
    
    BOOL bOut = YES;
    
    if (!bShow) {
        for (id data in klineData) {
            if (offset < [[data objectAtIndex:0] intValue]) {
                if (pre_data != nil) {
                    
                    [self updateLabels:pre_data];
                    
                    CGFloat x = ([[pre_data objectAtIndex:0] intValue] - dataOrigin.x) / SCALE
                    + logicLineRect.origin.x;
                    
                    vLineStartPt = CGPointMake(x, logicLineRect.origin.y);
                    vLineEndPt = CGPointMake(x, (logicLineRect.origin.y + logicLineRect.size.height));
                    
                    hLineStartPt = CGPointMake(logicLineRect.origin.x,
                                               [[pre_data objectAtIndex:1] intValue] / SCALE + LABEL_HEIGHT);
                    hLineEndPt = CGPointMake(logicLineRect.origin.x + logicLineRect.size.width,
                                             [[pre_data objectAtIndex:1] intValue] / SCALE + LABEL_HEIGHT);
                    
                    bOut = NO;
                    break;
                }
            }
            pre_data = data;
        }
    }
    
    if (bOut) {
        pre_data = [klineData lastObject];
        [self updateLabels:pre_data];
        if (klineData&&[klineData count]>0) {
            CGFloat x = ([[pre_data objectAtIndex:0] floatValue] - dataOrigin.x) / SCALE + logicLineRect.origin.x;
            
            vLineStartPt = CGPointMake(x, logicLineRect.origin.y);
            vLineEndPt = CGPointMake(x, (logicLineRect.origin.y + logicLineRect.size.height));
            
            hLineStartPt = CGPointMake(logicLineRect.origin.x,
                                       [[pre_data objectAtIndex:1] intValue] / SCALE + LABEL_HEIGHT);
            hLineEndPt = CGPointMake(logicLineRect.origin.x + logicLineRect.size.width,
                                     [[pre_data objectAtIndex:1] intValue] / SCALE + LABEL_HEIGHT);
        }
        else {
            vLineStartPt = CGPointZero;
            vLineEndPt = CGPointZero;
            hLineStartPt = CGPointZero;
            hLineEndPt = CGPointZero;
        }
    }
}

- (void)calcLinePoints:(CGPoint)touchPt
{
    if (touchPt.x >= logicLineRect.origin.x
        && touchPt.x <= (logicLineRect.origin.x + logicLineRect.size.width)) {
        [self showData:touchPt lastPrice:NO];
    }
}

- (void)dealloc
{
    [topDataLabel release];
    [klineData release];
    
    [MA5Label release];
    [MA10Label release];
    [MA30Label release];
    
    [super dealloc];
}

- (void)setLineRect:(CGRect)theRect
{
    lineRect = theRect;
    logicLineRect = CGRectMake(lineRect.origin.x / SCALE, lineRect.origin.y / SCALE, 
                               lineRect.size.width / SCALE, lineRect.size.height / SCALE);
    
    // layout ma labels
    CGFloat width = logicLineRect.size.width / 3.0;
    MA5Label.frame  = CGRectMake(logicLineRect.origin.x + 0 * width,
                                 logicLineRect.origin.y, width, LABEL_HEIGHT);
    MA10Label.frame = CGRectMake(logicLineRect.origin.x + 1 * width,
                                 logicLineRect.origin.y, width, LABEL_HEIGHT);
    MA30Label.frame = CGRectMake(logicLineRect.origin.x + 2 * width,
                                 logicLineRect.origin.y, width, LABEL_HEIGHT);
}

- (void)setDescData:(NSArray *)dataArray
{
    [descData release];
    descData = [dataArray retain];
    
    // reset maStart value 
    maStart = 0;
    
    for (NSString *desc in descData) {
        if ([[desc lowercaseString] hasPrefix:@"ma"]) {
            maStart = [descData indexOfObject:desc];
            break;
        }
    }
    
    if (maStart == 0) {
        maStart = [descData count];
        MA5Label.text = nil;
        MA10Label.text = nil;
        MA30Label.text = nil;
    }
}

- (void)resize:(CGRect)theRect
{
    self.frame = theRect;
    topDataLabel.frame = CGRectMake(OFFSET_X, 0, self.frame.size.width - OFFSET_X, LABEL_HEIGHT);
}

- (void)setDataLabelFont:(UIFont *)aFont
{
    [dataLabelFont release];
    dataLabelFont = [aFont retain];
    topDataLabel.font = aFont;
    [topDataLabel setNeedsDisplay];
}

#pragma mark - Touch Handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([delegate respondsToSelector:@selector(klineAnimationTouchBegin:)]) {
        [delegate klineAnimationTouchBegin:self];
    }
    
    bDraw = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPt = [touch locationInView:self];
    
    [self calcLinePoints:touchPt];
    
    [self setNeedsDisplay];
}

-  (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPt = [touch locationInView:self];
    
    [self calcLinePoints:touchPt];
    
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([delegate respondsToSelector:@selector(klineAnimationTouchEnd:)]) {
        [delegate klineAnimationTouchEnd:self];
    }
    bDraw = NO;
    [self showData:CGPointMake(0, 0) lastPrice:YES];
    [self setNeedsDisplay];
}

-  (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([delegate respondsToSelector:@selector(klineAnimationTouchEnd:)]) {
        [delegate klineAnimationTouchEnd:self];
    }
    bDraw = NO;
    [self showData:CGPointMake(0, 0) lastPrice:YES];
    [self setNeedsDisplay];
}

@end
