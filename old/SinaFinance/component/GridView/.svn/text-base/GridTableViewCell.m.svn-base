//
//  GridTableViewCell.m
//  GridView
//
//  Created by Du Dan on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GridTableViewCell.h"
#import "GridViewController.h"

#define cell1Width 80
#define cell2Width 80

#define cellWidth 80


@implementation GridTableViewCell

@synthesize lineColor;
@synthesize topCell;
@synthesize rowsNumber, colsNumber;
@synthesize widthArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier
               rows:(NSInteger)rows
            columns:(NSInteger)columns
             parent:(GridViewController*)parent
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        rowsNumber = rows;
        colsNumber = columns;
        widthArray = [[NSArray alloc] initWithArray:parent.maxLengthArray];
        
        NSInteger width = 0;
        for (int i = 0; i < columns; i++) {
            UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(width+1.2, 1.5, [[widthArray objectAtIndex:i] intValue]-1.0, cellHeight-2.5)];
            cellLabel.backgroundColor = [UIColor clearColor];
            cellLabel.textAlignment = UITextAlignmentCenter;
            cellLabel.tag = i + CELL_LABEL_BEGIN_TAG;
            [self addSubview:cellLabel];
            [cellLabel release];
            
            width += [[widthArray objectAtIndex:i] intValue];
        }
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    
    CGContextSetLineWidth(context, 1.0);
        
    //Draw the line between columns
    NSInteger tableWidth = 0;
    for (int i = 0; i <= colsNumber; i++) {
        NSInteger width = 0;
        for (int j = 0; j < i; j++) {
            width += [[widthArray objectAtIndex:j] intValue];
        }
        CGContextMoveToPoint(context,width+0.5,0);
        CGContextAddLineToPoint(context, width+0.5, rect.size.height);
        tableWidth = width;
    }
        
    //Draw the line on the bottom of the cell
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, tableWidth, rect.size.height-0.5);
    
    //Draw the line on the top of the table
    if(topCell){
        CGContextMoveToPoint(context, 0, 0);
        //CGContextAddLineToPoint(context, rect.size.width, 0);
        CGContextAddLineToPoint(context, tableWidth, 0);
    }
    
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [widthArray release];
    [super dealloc];
}

- (void)setTopCell:(BOOL)newTopCell
{
    topCell = newTopCell;
    [self setNeedsDisplay];
}

@end
