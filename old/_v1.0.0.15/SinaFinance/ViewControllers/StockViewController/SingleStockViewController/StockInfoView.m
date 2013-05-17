//
//  StockInfoView.m
//  SinaFinance
//
//  Created by shieh exbice on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StockInfoView.h"
#import "StockListCell.h"

@implementation StockInfoOneColumnData
@synthesize justName,name,fontColor,preName;

-(void)dealloc
{
    [name release];
    [preName release];
    [fontColor release];
    [super dealloc];
}

@end

@implementation StockInfoCellData
@synthesize columnData;

-(id)init
{
    self = [super init];
    if (self) {
        columnData = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

-(void)dealloc
{
    [columnData release];
    [super dealloc];
}

@end

@interface StockInfoView ()
@property(nonatomic,retain)UITableView* curtableView;
-(void)initUI;

@end

@implementation StockInfoView
{
    UITableView* curtableView;
}
@synthesize curtableView;
@synthesize dataArray,widthArray;
@synthesize viewType;
@synthesize leftMargin;
@synthesize titleFont;
@synthesize fontSizeArray;
@synthesize widthArrayForRows;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

-(void)dealloc
{
    [curtableView release];
    [dataArray release];
    [widthArray release];
    [titleFont release];
    [fontSizeArray release];
    [widthArrayForRows release];
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)initUI
{
    if (!curtableView) {
        curtableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        curtableView.backgroundColor = [UIColor clearColor];
        curtableView.allowsSelection = NO;
        curtableView.delegate = self;
        curtableView.dataSource = self;
        curtableView.rowHeight  = 20;
        curtableView.scrollEnabled = NO;
        curtableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        curtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:curtableView];
    }
}

-(void)setViewType:(NSInteger)aviewType
{
    viewType = aviewType;
    if (viewType==ViewType_Info) {
        curtableView.rowHeight  = 20;
    }
    else if(viewType==ViewType_titleItem0)
    {
        curtableView.rowHeight  = 20;
    }
    else if(viewType==ViewType_titleItem1)
    {
        curtableView.rowHeight  = 25;
    }
}

#pragma mark
#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowNum = indexPath.row;
    static NSString *CellIdentifier = @"StockItemCell";
    
    StockListCell *cell = (StockListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[[StockListCell alloc] initWithCellType:StockListCell_MultiName reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.leftMargin = leftMargin;
    
    NSArray* curWidthArray = widthArray;
    if (widthArrayForRows) {
        NSNumber* rowNumber = [NSNumber numberWithInt:rowNum];
        NSString* rowString = [rowNumber stringValue];
        NSArray* specilRowWidths = [widthArrayForRows valueForKey:rowString];
        if (specilRowWidths) {
            curWidthArray = specilRowWidths;
        }
    }
    if (curWidthArray) {
        StockInfoCellData* oneCellData = [dataArray objectAtIndex:rowNum];
        int columnCount = [oneCellData.columnData count];
        if (columnCount<[curWidthArray count]) {
            NSMutableArray* newWidths = [NSMutableArray arrayWithCapacity:columnCount];
            int lastWidth = 0;
            for (int i=0; i<[curWidthArray count]; i++) 
            {
                if (i<columnCount-1) {
                    [newWidths addObject:[curWidthArray objectAtIndex:i]];
                }
                else {
                    lastWidth += [(NSNumber*)[curWidthArray objectAtIndex:i] intValue];
                }
            }
            [newWidths addObject:[NSNumber numberWithInt:lastWidth]];
            cell.columnWidths = newWidths;
        }
        else {
            cell.columnWidths = curWidthArray;
        }
        
        for (int i=0;i<[oneCellData.columnData count];i++) {
            StockInfoOneColumnData* oneColumn = [oneCellData.columnData objectAtIndex:i];
            UILabel* oneLabel = [cell labelWithIndex:i];
            if (viewType==ViewType_Info) {
                oneLabel.font = [UIFont systemFontOfSize:12.0];
            }
            else if(viewType==ViewType_titleItem0)
            {
                oneLabel.font = [UIFont systemFontOfSize:12.0];
            }
            else if(viewType==ViewType_titleItem1)
            {
                oneLabel.font = [UIFont systemFontOfSize:14.0];
            }
            if (titleFont) {
                oneLabel.font = titleFont;
            }
            if (fontSizeArray&&i<[fontSizeArray count]) {
                NSNumber* fontSizeNumber = [fontSizeArray objectAtIndex:i];
                if (titleFont) {
                    oneLabel.font = [titleFont fontWithSize:[fontSizeNumber floatValue]];
                }
                else {
                    oneLabel.font = [UIFont systemFontOfSize:[fontSizeNumber floatValue]];
                }
            }
            oneLabel.textColor = [UIColor whiteColor];
            if(oneColumn.fontColor)
            {
                oneLabel.textColor = oneColumn.fontColor;
            }
            if (oneColumn.preName) {
                oneLabel.text = [NSString stringWithFormat:@"%@%@",oneColumn.preName,oneColumn.name];
            }
            else {
                oneLabel.text = oneColumn.name;
            }
        }
        
        if (viewType==ViewType_Info) {
            if(indexPath.row % 2){
                cell.contentView.backgroundColor = [UIColor colorWithRed:3.0/255 green:21.0/255 blue:59.0/255 alpha:1.0];
            }
            else{
                cell.contentView.backgroundColor = [UIColor colorWithRed:16.0/255 green:42.0/255 blue:89.0/255 alpha:1.0];
            }
        }
        else if(viewType==ViewType_titleItem0)
        {
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        else if(viewType==ViewType_titleItem1)
        {
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
    }
    
    return cell;
}

-(void)reloadData
{
    NSInteger height = [dataArray count]*curtableView.rowHeight;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    [self.curtableView reloadData];
}

@end
