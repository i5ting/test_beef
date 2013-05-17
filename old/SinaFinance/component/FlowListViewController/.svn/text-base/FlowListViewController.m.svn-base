//
//  FlowListViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FlowListViewController.h"

@interface FlowListTableViewCell : UITableViewCell
{
    NSString* nameString;
    id data;
    BOOL hasInit;
    BOOL cellSelected;
    BOOL cellHighlighted;
}

@property(nonatomic,retain)NSString* nameString;
@property(nonatomic,retain)id data;

@end

@implementation FlowListTableViewCell
@synthesize nameString,data;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
        UIImageView* backView = [[UIImageView alloc] init];
        self.backgroundView = backView;
        [backView release];
    }
    return self;
}

-(void)dealloc
{
    [nameString release];
    [data release];
    
    [super dealloc];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    cellHighlighted = highlighted;
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        UIImageView* backView = (UIImageView*)self.backgroundView;
        UIImage* highlyImage = [UIImage imageNamed:@"group_picker_cell_background_highlighted.png"];
        highlyImage = [highlyImage stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
        [backView setImage:highlyImage];
        if(!cellSelected)
        {
            self.textLabel.textColor = [UIColor colorWithRed:50/255.0 green:110/255.0 blue:186/255.0 alpha:1.0];
        }
        else
        {
            self.textLabel.textColor = [UIColor colorWithRed:50/255.0 green:110/255.0 blue:186/255.0 alpha:1.0];
        }
    }
    else
    {
        if (!cellSelected) {
            UIImageView* backView = (UIImageView*)self.backgroundView;
            backView.image = nil;
            self.textLabel.textColor = [UIColor colorWithRed:43/255.0 green:82/255.0 blue:143/255.0 alpha:1.0];
        }
        else
        {
            UIImageView* backView = (UIImageView*)self.backgroundView;
            UIImage* highlyImage = [UIImage imageNamed:@"group_picker_cell_background_selected.png"];
            highlyImage = [highlyImage stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
            [backView setImage:highlyImage]; 
            self.textLabel.textColor = [UIColor whiteColor];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    cellSelected = selected;
    [super setSelected:selected animated:animated];
    if (selected&&!cellHighlighted) {
        UIImageView* backView = (UIImageView*)self.backgroundView;
        UIImage* highlyImage = [UIImage imageNamed:@"group_picker_cell_background_selected.png"];
        highlyImage = [highlyImage stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
        [backView setImage:highlyImage]; 
        self.textLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        if (!cellHighlighted) {
            UIImageView* backView = (UIImageView*)self.backgroundView;
            backView.image = nil;
            self.textLabel.textColor = [UIColor whiteColor];
        }
        else
        {
            UIImageView* backView = (UIImageView*)self.backgroundView;
            UIImage* highlyImage = [UIImage imageNamed:@"group_picker_cell_background_highlighted.png"];
            highlyImage = [highlyImage stretchableImageWithLeftCapWidth:15.0 topCapHeight:15.0];
            [backView setImage:highlyImage]; 
            self.textLabel.textColor = [UIColor colorWithRed:50/255.0 green:110/255.0 blue:186/255.0 alpha:1.0];
        }
    }
    // Configure the view for the selected state
}
@end

@interface FlowListViewController ()
@property(nonatomic,retain)UIView* searchModeBackView;

-(void)dismissAfterAnimite;

@end

@implementation FlowListViewController
@synthesize delegate,listNames,separateList;
@synthesize searchModeBackView;
@synthesize selectedIndex;

-(id)initWithSelectedIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        selectedIndex = index;
    }
    return self;
}

-(void)dealloc
{
    [listNames release];
    [separateList release];
    [searchModeBackView release];
    [super dealloc];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)show:(CGPoint)point boxSize:(CGSize)boxSize
{
    seletedInvalid = NO;
    hotPoint = point;
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if (!self.searchModeBackView) {
        UIButton* backView = [[UIButton alloc] initWithFrame:bounds];
        backView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [backView addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.searchModeBackView = backView;
        [backView release];
        UIImageView* modeImageView = [[UIImageView alloc] init];
        modeImageView.userInteractionEnabled = YES;
        modeImageView.clipsToBounds = YES;
        modeImageView.tag = 111333;
        UIImage* modeImage = [UIImage imageNamed:@"group_picker_background.png"];
        modeImage = [modeImage stretchableImageWithLeftCapWidth:50.0 topCapHeight:20.0];
        modeImageView.image = modeImage;
        int curX = hotPoint.x - boxSize.width/2;
        CGRect visibleBackRect = CGRectMake(curX, hotPoint.y, boxSize.width, boxSize.height);
        modeImageView.frame = visibleBackRect;
        [backView addSubview:modeImageView];
        [modeImageView release];
        int tableMargin = 8;
        CGRect tableRect = visibleBackRect;
        tableRect.origin.x = tableMargin;
        tableRect.origin.y = tableMargin;
        tableRect.size.width = tableRect.size.width - 2* tableMargin;
        tableRect.size.height = tableRect.size.height - 2* tableMargin;
        UITableView* tempTable = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
        tempTable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        tempTable.scrollsToTop = NO;
        tempTable.delegate = self;
        tempTable.dataSource = self;
        tempTable.tag = 111901;
        tempTable.backgroundColor = [UIColor clearColor];
        tempTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [modeImageView addSubview:tempTable];
        [tempTable release];
        [self.view addSubview:self.searchModeBackView];
    }
    UITableView* tempTable =  (UITableView*)[self.searchModeBackView viewWithTag:111901];
    [tempTable reloadData];
    if (selectedIndex<[listNames count]) {
        NSIndexPath* selectedPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        [tempTable selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    UIImageView* modeImageView = (UIImageView*)[self.searchModeBackView viewWithTag:111333];
    int maxHeight = 56;
    if ([listNames count]>=2) {
        maxHeight = 30*[listNames count] + 10;
    }
    maxHeight = maxHeight>boxSize.height?boxSize.height:maxHeight;
    maxHeight +=10;
    int curX = hotPoint.x - boxSize.width/2;
    CGRect modeImageRect = modeImageView.frame;
    modeImageRect.origin.x = curX;
    modeImageRect.origin.y = hotPoint.y;
    modeImageRect.size.height = maxHeight;
    modeImageView.frame = modeImageRect;
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.view];
    
    self.view.alpha = 0.0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.alpha = 1.0;
    [UIView commitAnimations];
    
}

-(void)backClicked:(UIButton*)sender
{
    [self dismiss:YES byBtn:NO];
}

-(void)dismiss:(BOOL)animate byBtn:(BOOL)byBtn
{
    if ([delegate respondsToSelector:@selector(controllerHidenWithController:)]) {
        [delegate controllerHidenWithController:self];
    }
    if (seletedInvalid) {
        if ([delegate respondsToSelector:@selector(controller:didSelectIndex:byBtn:)]) {
            [delegate controller:self didSelectIndex:selectedIndex byBtn:byBtn];
        }
    }
    if (animate) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(dismissAfterAnimite)];
        self.view.alpha = 0.0;
        [UIView commitAnimations];
    }
    else
    {
        [self dismissAfterAnimite];
    }
}

-(void)dismissAfterAnimite
{
    [self.view removeFromSuperview];
}

#pragma mark -
#pragma mark table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    FlowListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[FlowListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        UIImage* seperatorImage = [UIImage imageNamed:@"group_picker_cell_separator.png"];
        seperatorImage = [seperatorImage stretchableImageWithLeftCapWidth:50.0 topCapHeight:0.0];
        UIImageView* seperator = [[UIImageView alloc] initWithImage:seperatorImage];
        seperator.tag = 188865;
        seperator.frame = CGRectMake(0, 29, tableView.bounds.size.width, 2);
        [cell.contentView addSubview:seperator];
        [seperator release];
    }
    
    NSString* text = [listNames objectAtIndex:indexPath.row];
    cell.textLabel.text = text;
    UIImageView* seperator = (UIImageView*)[cell.contentView viewWithTag:188865];
    if ([listNames count]==indexPath.row+1) {
        seperator.hidden = YES;
    }
    else {
        seperator.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  
{
    seletedInvalid = YES;
    selectedIndex = indexPath.row;
    [self dismiss:YES byBtn:YES];
}


@end
