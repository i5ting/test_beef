//
//  NewsListView.m
//  SinaFinance
//
//  Created by Du Dan on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsListView.h"
#import "NewsXmlParser.h"
#import "NewsTableViewCell.h"
#import "StockTableViewCell.h"
#import "ShareData.h"

#define TABLECELL_WIDGET_START_TAG 1000

@implementation NewsListView

@synthesize delegate;
@synthesize isStockColumn;

- (void)reloadViewWithData:(NSArray*)data
{
    if(newsArray){
        [newsArray release];
        newsArray = nil;
        newsArray = [[NSMutableArray alloc] initWithArray:data];
    }
    else{
        newsArray = [[NSMutableArray alloc] initWithArray:data];
    }
    [newsTable reloadData];
}

- (id)initWithData:(NSArray*)data frame:(CGRect)frame type:(NewsContentType)type
{
    self = [super init];
    if (self) {
        newsArray = [[NSMutableArray alloc] initWithArray:data];
        contentType = type;
        
        newsTable = [[UITableView alloc] initWithFrame:frame];
        newsTable.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:34.0/255 green:57.0/255 blue:79.0/255 alpha:1.0];
        newsTable.delegate = self;
        newsTable.dataSource = self;
        newsTable.rowHeight = 46;
        newsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:newsTable];
    }
    return self;
}

- (void)dealloc
{
    [newsArray release];
    [newsTable release];
    [delegate release];
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

#pragma mark
#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"newsArray.count: %d", newsArray.count);
    if(contentType == kNewsContentNormal && isStockColumn == NO){
        return newsArray.count + 1;
    }
    return newsArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NewsCellIdentifier = @"NewsCell";
    static NSString *StockCellIdentifier = @"StockCell";
    NSInteger row = indexPath.row;
    
    NSArray *array = [NSArray arrayWithArray:newsArray];
    NSDictionary *newsDict = nil;
    NSString *type = nil;
    BOOL isRead;
    if(row < array.count){
        newsDict = (NSDictionary*)[array objectAtIndex:row];
        type = [newsDict objectForKey:@"SearchType"];
        isRead = [[newsDict objectForKey:@"NewsIsReadFlag"] boolValue];
    }
    
    if(type){
        StockTableViewCell *cell = (StockTableViewCell*)[tableView dequeueReusableCellWithIdentifier:StockCellIdentifier];
        if(cell == nil){
            cell = [[[StockTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StockCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.stockName.text = [newsDict objectForKey: STOCK_SEARCH_CNAME_KEY];
        cell.stockID.text = [newsDict objectForKey: STOCK_SEARCH_SYMBOL_KEY];
        
        return cell;
    }
    else{
        if(row == newsArray.count && newsArray.count > 0 && isStockColumn == NO){
//            NSLog(@"news count: %d", newsArray.count);
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"aCell"];
            if(cell == nil){
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aCell"] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
            cell.textLabel.text = @"更多...";
            return cell;
        }
        else if(newsDict)
        {
//            NSLog(@"news count: %d", newsArray.count);
            NewsTableViewCell *cell = (NewsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
            if(cell == nil){
                cell = [[[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if(!isRead){
                cell.readIcon.hidden = NO;
                cell.titleLabel.textColor = [UIColor whiteColor];
                cell.dateLabel.textColor = [UIColor colorWithRed:154.0/255 green:154.0/255 blue:154.0/255 alpha:1.0];
//                cell.sourceLabel.textColor = [UIColor colorWithRed:154.0/255 green:154.0/255 blue:154.0/255 alpha:1.0];
            }
            else{
                cell.readIcon.hidden = YES;
                cell.titleLabel.textColor = [UIColor colorWithRed:135.0/255 green:135.0/255 blue:135.0/255 alpha:1.0];
                cell.dateLabel.textColor = [UIColor colorWithRed:120.0/255 green:120.0/255 blue:120.0/255 alpha:1.0];
//                cell.sourceLabel.textColor = [UIColor colorWithRed:120.0/255 green:120.0/255 blue:120.0/255 alpha:1.0];
            }
            NSString *title = [newsDict objectForKey:NEWSLIST_TITLE_KEY];
            if(title){
                cell.titleLabel.text = title;//[newsDict objectForKey:NEWSLIST_TITLE_KEY];
                cell.dateLabel.text = [newsDict objectForKey:NEWSLIST_DATE_KEY];
//                cell.sourceLabel.text = [newsDict objectForKey:NEWSLIST_SOURCE_KEY];
            }
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = nil;
    NSInteger row = indexPath.row;
    if(row < newsArray.count){
        dict = [NSMutableDictionary dictionaryWithDictionary:[newsArray objectAtIndex:row]];
    }
    if(dict){
        NSString *type = [dict objectForKey:@"SearchType"];
        if(type){//It is stock
            NSString *country = [dict objectForKey:STOCK_SEARCH_COUNTRY_KEY];
//            NSLog(@"stock country: %@", country);
            if([country isEqualToString:@"stock"]){
                [dict setValue:country forKey:@"MarketType"];
                [delegate newsList:self didSelectStockAtDict:dict];
            }
            else if([country isEqualToString:@"hk"]){
                [dict setValue:[NSNumber numberWithInt:kHKStockRanking] forKey:@"MarketType"];
                [delegate newsList:self didSelectStockAtDict:dict];
            }
            else if([country isEqualToString:@"us"]){
                [dict setValue:[NSNumber numberWithInt:kHotUSAStock] forKey:@"MarketType"];
                [delegate newsList:self didSelectStockAtDict:dict];
            }
            else if([country isEqualToString:@"fund"]){
                [delegate newsList:self didSelectFundAtDict:dict];
            }
        }
        else{//It is news
            [dict setValue:[NSNumber numberWithInt:contentType] forKey:@"NewsContentType"];
            [dict setValue:[NSNumber numberWithBool:YES] forKey:@"NewsIsReadFlag"];
            if(row < newsArray.count){
                [newsArray replaceObjectAtIndex:row withObject:dict];
            }
            [newsTable reloadData];
            
            [delegate newsList:self didSelectNewsAtIndex:row news:dict];
        }
    }
    else if(row == newsArray.count && isStockColumn == NO){
        [delegate didSelectMoreItem];
    }
}

- (NSArray*)getNewsArray
{
    return newsArray;
}

@end
