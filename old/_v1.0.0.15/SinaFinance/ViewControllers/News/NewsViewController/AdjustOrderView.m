//
//  AdjustOrderView.m
//  SinaFinance
//
//  Created by shieh exbice on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdjustOrderView.h"
#import "CommentDataList.h"

@interface AdjustOrderView()
@property(nonatomic,retain)UITableView* table;
@property(nonatomic,retain)NSMutableArray* ableDataArray;
@property(nonatomic,retain)NSMutableArray* disableDataArray;
@end

@implementation AdjustOrderView
{
    UITableView* mTable;
    BOOL bModified;
}
@synthesize table=mTable;
@synthesize ableDataArray,disableDataArray;
@synthesize delegate,data;
@synthesize immediateWorked;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        immediateWorked = YES;
        [self initUI];
    }
    return self;
}

-(void)dealloc
{
    [mTable release];
    [ableDataArray release];
    [disableDataArray release];
    [data release];
    
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
    UITableView* aTable = [[UITableView alloc] initWithFrame:[self bounds] style:UITableViewStylePlain];
    aTable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:aTable];
    aTable.scrollsToTop = NO;
    aTable.editing = YES;
    aTable.delegate = self;
    aTable.dataSource = self;
    self.table =aTable;
    [aTable release];
}


-(void)setDataArray:(NSArray*)aDataArray
{
    if (!ableDataArray) {
        ableDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else
    {
        [ableDataArray removeAllObjects];
    }
    if (!disableDataArray) {
        disableDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    else
    {
        [disableDataArray removeAllObjects];
    }
    for (AdjustOrderData* onedata in aDataArray) {
        if (onedata.type==AdjustOrderType_abled) {
            [ableDataArray addObject:onedata];
        }
        else
        {
            [disableDataArray addObject:onedata];
        }
    }
    self.table.editing = YES;
    [self.table reloadData];
}

-(void)setFinished:(BOOL)bFinished
{
    self.table.editing = NO;
    [self userOperated];
}

#pragma mark -
#pragma mark table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return 44;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage* headerImage = [UIImage imageNamed:@"news_list_custom_header.png"];
    headerImage = [headerImage stretchableImageWithLeftCapWidth:100.0 topCapHeight:10.0];
    UIImageView* headerView = [[[UIImageView alloc] initWithImage:headerImage] autorelease];
    UILabel* newLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 24)];
    newLabel.backgroundColor = [UIColor clearColor];
    newLabel.textColor = [UIColor colorWithRed:56/255.0 green:90/255.0 blue:143/255.0 alpha:1.0];
    if (section==0) {
        newLabel.text = @"已选栏目";
    }
    else {
        newLabel.text = @"可选栏目";
    }
    [headerView addSubview:newLabel];
    [newLabel release];
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"已选栏目";
    }
    else
    {
        return @"可选栏目";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [ableDataArray count];
    }
    else
    {
        return [disableDataArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int sectionNum = indexPath.section;
    NSMutableArray* dataArray = nil;
    if (sectionNum==0) {
        dataArray = ableDataArray;
    }
    else
    {
        dataArray = disableDataArray;
    }
    int rowNum = indexPath.row;
	AdjustOrderData* oneData = nil;
	if ([dataArray count]>rowNum) {
		oneData = [dataArray objectAtIndex:rowNum];
	}
    
    NSString* showString = oneData.value;
    UITableViewCell* cell = nil;
    NSString* userIdentifier = @"textIdentifier";
    cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = showString;
    cell.textLabel.textColor = [UIColor colorWithRed:34/255.0 green:71/255.0 blue:149/255.0 alpha:1.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    UIImage* lineImage = [UIImage imageNamed:@"news_list_cell_back.png"];
    lineImage = [lineImage stretchableImageWithLeftCapWidth:100.0 topCapHeight:18.0];
    UIImageView* line = [[UIImageView alloc] initWithImage:lineImage];
    line.frame = cell.bounds;
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [cell addSubview:line];
    [cell sendSubviewToBack:line];
    [line release];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	NSIndexPath* rtval = nil;
    int sectionNum = sourceIndexPath.section;
    NSMutableArray* dataArray = nil;
    if (sectionNum==0) {
        dataArray = ableDataArray;
    }
    else
    {
        dataArray = disableDataArray;
    }
    int rowNum = sourceIndexPath.row;
    AdjustOrderData* oneData = [dataArray objectAtIndex:rowNum];
    BOOL moveAble = oneData.movable;
    if (!moveAble) {
        if( sourceIndexPath.section != proposedDestinationIndexPath.section )   
        {         
            rtval = sourceIndexPath;     
        }     
        else    
        {         
            rtval = proposedDestinationIndexPath;    
        } 
    }
    else
    {
        rtval = proposedDestinationIndexPath;
		if (rtval.section==0) {
            if ([disableDataArray count]==0) {
                int rowCount = [self tableView:tableView numberOfRowsInSection:0];
                if (rtval.row==rowCount-1) {
                    rtval = [NSIndexPath indexPathForRow:0 inSection:1];
                }
            }
			
		}
		else if(rtval.section==1)
		{
            if ([ableDataArray count]==0) {
                if (rtval.row==0) {
                    int firstRowCount = [self tableView:tableView numberOfRowsInSection:0];
                    if (firstRowCount>0) {
                        firstRowCount = firstRowCount-1;
                    }
                    rtval = [NSIndexPath indexPathForRow:firstRowCount inSection:0];
                }
            }
			
			
		}
    }
	
	
	return rtval;
	
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{ 
    int sourceNum = sourceIndexPath.row;
    int destNum = destinationIndexPath.row;
    NSMutableArray* sourceArray = sourceIndexPath.section==0?ableDataArray:disableDataArray;
    NSMutableArray* destArray = destinationIndexPath.section==0?ableDataArray:disableDataArray;
    if (destArray==sourceArray) {
        if (sourceIndexPath.row!=destinationIndexPath.row) {
            id moveData = [sourceArray objectAtIndex:sourceIndexPath.row];
            [moveData retain];
            [sourceArray removeObject:moveData];
            if ([sourceArray count]>destinationIndexPath.row) {
                [sourceArray insertObject:moveData atIndex:destinationIndexPath.row];
            }
            else
            {
                [sourceArray addObject:moveData];
            }
            [moveData release];
            bModified = YES;
        }
    }
    else
    {
        AdjustOrderData* moveData = (AdjustOrderData*)[sourceArray objectAtIndex:sourceIndexPath.row];
        if (destinationIndexPath.section==0) {
            moveData.type = AdjustOrderType_abled;
        }
        else
        {
            moveData.type = AdjustOrderType_disabled;
        }
        if ([destArray count]>destinationIndexPath.row) {
            [destArray insertObject:moveData atIndex:destinationIndexPath.row];
        }
        else
        {
            [destArray addObject:moveData];
        }
        [sourceArray removeObject:moveData];
        bModified = YES;
    }
    if (immediateWorked) {
        [self performSelector:@selector(userOperated) withObject:nil afterDelay:0.001];
    }
}

-(void)userOperated
{
    if (bModified) {
        if ([delegate respondsToSelector:@selector(view:adjustFinished:)]) {
            NSMutableArray* retArray = [[NSMutableArray alloc] initWithCapacity:0];
            [retArray addObjectsFromArray:ableDataArray];
            [retArray addObjectsFromArray:disableDataArray];
            [delegate view:self adjustFinished:retArray];
            [retArray release];
        }
    }
}

@end
