//
//  RootViewController.m
//  GridView
//
//  Created by Du Dan on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GridViewController.h"
#import "GridTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define CELL_BLANK_SPACE 30

@implementation GridViewController

@synthesize dataArray;
@synthesize maxLengthArray;
@synthesize maxColCount;

- (CGFloat)widthOfString:(NSString *)string 
                withFont:(UIFont*)font {
    CGSize stringSize = [string sizeWithFont:font];
    return stringSize.width;
}

- (NSInteger)getMaxLengthWithArray:(NSArray*)array{
    NSInteger maxLength = 0;
    
    for (int i = 0; i < [array count]; i++) {
        NSString *temp = [array objectAtIndex:i];
        NSInteger tempLen = [self widthOfString:temp withFont:[UIFont fontWithName:FONT_TYPE size:FONT_SIZE]];
        if(tempLen > maxLength){
            maxLength = tempLen;
        }
    }
    return (maxLength + CELL_BLANK_SPACE);
}

- (CGSize)getTableViewSize{
    NSInteger width = 0;
    for (int i = 0; i < [maxLengthArray count]; i++) {
        width += [[maxLengthArray objectAtIndex:i] intValue];
    }
    NSInteger height = (cellHeight) * [dataArray count];
    
    return CGSizeMake(width, height);
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (id)initWithGridData:(NSArray*)array
{
    if((self = [super init])){
        dataArray = [[NSArray alloc] initWithArray:array];
        maxLengthArray = [[NSMutableArray alloc] init];
        
        int aMaxColCount = 0;
        for (int row = 0; row < [dataArray count]; row++) {
            NSArray* oneRow = [dataArray objectAtIndex:row];
            int oneRowCount = [oneRow count];
            aMaxColCount = oneRowCount>aMaxColCount?oneRowCount:aMaxColCount;
        }
        self.maxColCount = aMaxColCount;
        NSMutableArray *colArray = [[NSMutableArray alloc] init];
        for (int col = 0; col < maxColCount; col++) {
            [colArray removeAllObjects];
            for (int row = 0; row < [dataArray count]; row++) {
                NSArray* oneRow = [dataArray objectAtIndex:row];
                NSString* oneRowCol = nil;
                if ([oneRow count]>col) {
                    oneRowCol = [oneRow objectAtIndex:col];
                }
                else
                {
                    oneRowCol = @"";
                }
                [colArray addObject:oneRowCol];
            }
            NSInteger maxLen = [self getMaxLengthWithArray:colArray];
            [maxLengthArray addObject:[NSNumber numberWithInt:maxLen]];
        }
        [colArray release];
    }
    return self;
}

- (void)dealloc
{
    [dataArray release];
    [maxLengthArray release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.userInteractionEnabled = NO;
    CGSize viewSize = [self getTableViewSize];
    self.tableView.frame = CGRectMake(0, 0 ,viewSize.width, viewSize.height);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(UIImage*)getTableImage
{	
    CGSize captureSize = self.tableView.bounds.size;
	UIGraphicsBeginImageContextWithOptions(captureSize, NO, [[UIScreen mainScreen] scale]);
    [self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    int rowCount = indexPath.row;
    NSInteger rows = [dataArray count];
    NSInteger cols = self.maxColCount;
    CellIdentifier = [CellIdentifier stringByAppendingFormat:@"%d",cols];
    GridTableViewCell *cell = (GridTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[GridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier rows:rows columns:cols parent:self] autorelease];
        cell.lineColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger tag = CELL_LABEL_BEGIN_TAG;
    NSArray* oneRowData = [dataArray objectAtIndex:indexPath.row];
    for (int i = 0; i < cols; i++) {
        UILabel *label = (UILabel*)[cell viewWithTag:tag + i];
        if ([oneRowData count]>i) {
            label.text = [oneRowData objectAtIndex:i];
        }
        else
        {
            label.text = nil;
        }
        label.font = [UIFont fontWithName:FONT_TYPE size:FONT_SIZE];
    }
        
    if(indexPath.row == 0){
        cell.topCell = YES;
        
        UIFont *font = [UIFont fontWithName:FONT_TYPE size:FONT_SIZE];
        for (int i = 0; i < cols; i++) {
            UILabel *label = (UILabel*)[cell viewWithTag:tag + i];
            label.font = font;
            label.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0];
        }
    }
    else{
        cell.topCell = NO;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
