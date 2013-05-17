//
//  OPTable.m
//  TestGrid
//
//  Created by  on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "OPTable.h"

#define MARGIN_SPACE  5.0
#define FONT_SIZE    12.0

@implementation OPTable

@synthesize gridItems;
@synthesize lineSize;
@synthesize columnWidth1;
@synthesize columnWidth2;
@synthesize fontSize;
@synthesize itemFont;
@synthesize drawWithBorder;

- (id)initWithFrame:(CGRect)frame column:(NSInteger)column
{
    self = [super initWithFrame:frame];
    if (self) {
        lineSize = 2.0;
        self.column = column;
        
        //Default widths.
        self.columnWidths = [NSMutableArray arrayWithCapacity:column];
        CGFloat width = self.frame.size.width / column;
        NSNumber *widthVal = [NSNumber numberWithFloat:width];
        for (int i = 0; i < column; i++) {
            [_columnWidths addObject:widthVal];
        }

        rowHeights = [[NSMutableArray arrayWithCapacity:20] retain];
        fontSize = FONT_SIZE;
		drawWithBorder = YES;
        
        self.font = [UIFont systemFontOfSize:fontSize];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineSize);
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();  
    
    CGFloat components[] = {0.0, 0.0, 0.0, 1.0};  
    CGColorRef color = CGColorCreate(colorspace, components);  
    
    CGContextSetStrokeColorWithColor(context, color);
    
    [self drawGridSeperateLine:rect context:context];
    
	if (drawWithBorder) {
		[self drawBorder:rect context:context];
	}
    
    CGColorRelease(color);
}

- (void)drawBorder:(CGRect)rect context:(CGContextRef)context {
    CGContextSetLineWidth(context, lineSize);
    CGContextAddRect(context, CGRectMake(rect.origin.x + lineSize, rect.origin.y + lineSize, rect.size.width - 2 * lineSize, rect.size.height - 2 * lineSize));
    
    CGContextStrokePath(context);
}

- (CGFloat)maxRowHeight:(NSArray *)rowItems {
    __block CGFloat maxHeight = 0;
    
    [rowItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj != [NSNull null]) {
            CGFloat columnWidth = [[_columnWidths objectAtIndex:idx] floatValue];
            CGSize targetSize = CGSizeMake(columnWidth - 2 * (MARGIN_SPACE + lineSize), 1000);
            if ([obj hasPrefix:@"^"]) {
                targetSize = CGSizeMake(self.frame.size.width  - 2 * (MARGIN_SPACE + lineSize), 1000);
            }
            CGSize rectSize = [obj sizeWithFont:self.font constrainedToSize:targetSize lineBreakMode:UILineBreakModeWordWrap];
            if (rectSize.height > maxHeight) {
                maxHeight = ceilf(rectSize.height); // 圆整
            }
        }
    }];
    
    return maxHeight;
}

- (void)calcRowHeights {    
    CGFloat height = 0;
    NSInteger numberOfRows = [gridItems count] / _column;
    
    for (int i = 0; i < numberOfRows; i++) {
        NSRange itemRange = NSMakeRange(i * _column, _column);
        NSArray *rowItems = [gridItems subarrayWithRange:itemRange];
        CGFloat rowMaxHeight = [self maxRowHeight:rowItems] + 2 * MARGIN_SPACE;
        [rowHeights addObject:[NSNumber numberWithFloat:rowMaxHeight]];
        height += rowMaxHeight;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)drawGridSeperateLine:(CGRect)rect context:(CGContextRef)context {
    CGFloat curHeight = 0;
    
    int n = [rowHeights count];
    
    for (int i = 0; i < n; i++) { 
        NSRange itemRange = NSMakeRange(i * _column, _column);
        NSArray *rowItems = [gridItems subarrayWithRange:itemRange];
        CGFloat rowHeight = [[rowHeights objectAtIndex:i] floatValue];
        __block CGFloat x = 0;
        
        [rowItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CGFloat width = [[_columnWidths objectAtIndex:idx] floatValue];
            CGFloat y = curHeight + MARGIN_SPACE;
            
            if (obj != [NSNull null]) {
                CGRect rect = CGRectMake(x + MARGIN_SPACE + lineSize, y, width - 2 * (MARGIN_SPACE + lineSize), rowHeight);
                NSString *itemStr = (NSString *)obj;
                if ([obj hasPrefix:@"^"]) {
                    itemStr = [itemStr substringFromIndex:1];
                    rect = CGRectMake(x + MARGIN_SPACE + lineSize, y, self.frame.size.width - 2 * (MARGIN_SPACE + lineSize), rowHeight);
                }
                [itemStr drawInRect:rect
                       withFont:self.font
                  lineBreakMode:UILineBreakModeCharacterWrap
                      alignment:UITextAlignmentLeft];
            }
            
            // 逐行画分割线
            if (idx > 0) {
                // 画之前的分割线
                if (obj != [NSNull null]) {
                    CGContextMoveToPoint(context, x, curHeight + lineSize / 2.0);
                    CGContextAddLineToPoint(context, x, curHeight + rowHeight + lineSize / 2.0);
                }
            }

            x += width;
        }];
        
        curHeight += rowHeight;
        if (i < n - 1) {
            CGContextMoveToPoint(context, 0 + lineSize, curHeight);
            CGContextAddLineToPoint(context, rect.size.width - lineSize, curHeight);
        }
    }
    
//    __block CGFloat x = 0;
//    [_columnWidths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if (idx == _columnWidths.count - 2) {
//            *stop = YES;
//        }
//        CGFloat columnWidth = [obj floatValue];
//        x += columnWidth;
//        CGContextMoveToPoint(context, x, lineSize);
//        CGContextAddLineToPoint(context, x, curHeight - lineSize);
//    }];
    
	CGContextStrokePath(context);
    [self setNeedsDisplay];
}

- (void)dealloc {
    [gridItems release];
    [rowHeights release];
    [itemFont release];
    [super dealloc];
}

- (void)setItems:(NSArray *)itemArray {
    [gridItems release];
    gridItems = [itemArray retain];
    
    [self calcRowHeights];
}

@end
