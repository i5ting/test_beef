//
//  NewsCategoryView.m
//  SinaFinance
//
//  Created by Du Dan on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsCategoryView.h"
#import "ShareData.h"

#define CATEGORY_ITEM_MAX_NUMBER 20
#define CATEGORY_BUTTON_START_TAG 1000

@implementation NewsCategoryView

static NSString *itemsName[] = {@"要闻",@"深度",@"排行",@"滚动",@"股票",@"港股",@"美股",@"基金",@"产经",@"评论",@"理财",@"消费",@"期货",@"外汇",@"银行",@"保险",@"IT业界",@"互联网",@"通信",@"搜索"};
static NSString *iconsName[] = {@"focus_icon.png",@"depth_icon.png",@"ranking_icon.png",@"scroll_icon.png",@"newsstock_icon.png",@"hkstock_icon.png",@"usstock_icon.png",@"fund_icon.png",@"chanjing_icon.png",@"comment_icon.png",@"finance_icon.png",@"consumtion_icon.png",@"futures_icon.png",@"exchange_icon.png",@"bank_icon.png",@"insurance_icon.png",@"IT_icon.png",@"network_icon.png",@"communication_icon.png",@"search_icon.png"};

@synthesize delegate;


- (void)loadSubViews
{
    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(20, 10, 276, UI_MAX_HEIGHT -110)] autorelease];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 70;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:18/255.0 green:85/255.0 blue:117/255.0 alpha:1.0];
        UIImageView *topMask = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask.png"]] autorelease];
        topMask.frame = CGRectMake(0, 0, 320, 172);
        [self addSubview:topMask];
        
        UIImageView *bottomMask = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_bottom.png"]] autorelease];
        bottomMask.frame = CGRectMake(0, 325, 320, 105);
        [self addSubview:bottomMask];
        [self sendSubviewToBack:bottomMask];
        
        [self loadSubViews];
    }
    return self;
}

- (void)dealloc
{
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
    return CATEGORY_ITEM_MAX_NUMBER / 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        for(int i = 0; i < 4; i++){
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.frame = CGRectMake((55+18) * i, 0, 55, 70);
            //[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.tag = CATEGORY_BUTTON_START_TAG + i + indexPath.row * 4;
            [button addTarget:self action:@selector(handleItemDidSelect:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            
            UIImageView *icon = [[[UIImageView alloc] init] autorelease];
            icon.frame = CGRectMake(10, 0, 34, 37);
            icon.tag = 2000;
            [button addSubview:icon];
            
            UILabel *label = [[[UILabel alloc] init] autorelease];
            label.backgroundColor = [UIColor clearColor];
            label.frame = CGRectMake(0, 35, 55, 30);
            label.textAlignment = UITextAlignmentCenter;
            label.textColor = [UIColor colorWithRed:193/255.0 green:188/255.0 blue:189/255.0 alpha:1.0];
            label.font = [UIFont fontWithName:APP_FONT_NAME size:12];
            label.tag = 2001;
            [button addSubview:label];
        }
    }
    
    for(int i = 0; i < 4; i++){
        NSInteger index = i + indexPath.row * 4;
        UIButton *button = (UIButton*)[cell.contentView viewWithTag:CATEGORY_BUTTON_START_TAG + index];
        UIImageView *icon = (UIImageView*)[button viewWithTag:2000];
        icon.image = [UIImage imageNamed:iconsName[index]];
        
        UILabel *label = (UILabel*)[button viewWithTag:2001];
        label.text = itemsName[index];
        //[button setTitle:itemsName[index] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)handleItemDidSelect:(id)sender
{
    UIButton *selectedBtn = (UIButton*)sender;
    NSInteger index = selectedBtn.tag - CATEGORY_BUTTON_START_TAG;
    NSLog(@"selected index: %d", index);
    NSDictionary  *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index], @"NewsCategoryItemIndex",
                           itemsName[index],@"NewsCategoryItemTitle",
                           nil];
    [delegate newsCategoryView:self didSelectCategoryAtItem:dict];
}

@end
