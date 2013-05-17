//
//  OPTable.h
//  TestGrid
//
//  Created by  on 11-11-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPTable : UIView {
    NSArray *gridItems;
    CGFloat lineSize;
    CGFloat columnWidth1;
    CGFloat columnWidth2;
    CGFloat fontSize;
    UIFont  *itemFont;
    NSMutableArray *rowHeights;
	BOOL	drawWithBorder;
}

@property (nonatomic, retain, setter = setItems:) NSArray *gridItems;
@property (nonatomic, retain) NSMutableArray *columnWidths;
@property (nonatomic, assign) CGFloat lineSize;
@property (nonatomic, assign) CGFloat columnWidth1;
@property (nonatomic, assign) CGFloat columnWidth2;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, retain) UIFont  *itemFont;
@property (nonatomic, assign) BOOL	  drawWithBorder;
@property (nonatomic, assign) NSInteger column;

- (id)initWithFrame:(CGRect)frame column:(NSInteger)column;
- (void)drawBorder:(CGRect)rect context:(CGContextRef)context;
- (void)calcRowHeights;
- (void)drawGridSeperateLine:(CGRect)rect context:(CGContextRef)context;
- (void)setItems:(NSArray *)itemArray;

@end
