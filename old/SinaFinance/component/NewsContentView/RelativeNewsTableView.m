//
//  CommentTableView.m
//  SinaNews
//
//  Created by shieh exbice on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RelativeNewsTableView.h"
#import "ArticleContentView.h"
#import "MyTool.h"

#define kCommentCell_title 191219
#define kCommentCell_content 191229
#define kCommentCell_date 191239
#define kCommentCell_dateImageView 191249

#define kCommentCell_TitleFontSize 12.0
#define kCommentCell_ContentFontSize 17.0
#define kCommentCell_DateFontSize 12.0

@interface RelativeNewsCell ()

-(void)initUI;
-(void)myLayoutSubviews;

@end

@implementation RelativeNewsCell
@synthesize titleString,contentString,createDate,data;
@synthesize leftrightmargin;
@synthesize textSize;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    [titleString release];
    [contentString release];
    [createDate release];
    [data release];
    
    [super dealloc];
}

-(void)initUI
{
    self.userInteractionEnabled = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.backgroundColor = [UIColor clearColor];
    
    /*
     UIImage* backImage = [[UIImage imageNamed:@"wf_wiget_back.png"] stretchableImageWithLeftCapWidth:1.0 topCapHeight:40.0];
     UIImageView* backView = [[UIImageView alloc] initWithImage:backImage];
     self.backgroundView = backView;
     [backView release];
     */
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.tag = kCommentCell_title;
    if (textSize>0.0) {
        titleLabel.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:textSize];
        titleLabel.font = [UIFont systemFontOfSize:textSize];
    }
    else
    {
//        titleLabel.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:kCommentCell_ContentFontSize];
        titleLabel.font = [UIFont systemFontOfSize:kCommentCell_ContentFontSize];
    }
    titleLabel.textColor = [UIColor colorWithRed:16/255.0 green:78/255.0 blue:179/255.0 alpha:1.0];
    [self.contentView addSubview:titleLabel];
    [titleLabel release];
    
    UIImageView* dateImageView = [[UIImageView alloc] init];
    UIImage* arrowImage = [UIImage imageNamed:@"statusdetail_header_arrow.png"];
    dateImageView.image = arrowImage;
    //dateImageView.image = [UIImage imageNamed:@"pic_clock.png"];
    dateImageView.tag = kCommentCell_dateImageView;
    //    dateImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:dateImageView];
    [dateImageView release];
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)reloadData
{
    if (!hasInit) {
        hasInit = YES;
        [self initUI];
    }
    
    UILabel* titleLabel = (UILabel*)[self.contentView viewWithTag:kCommentCell_title];
    titleLabel.text = self.titleString;
    
    UILabel* dateLabel = (UILabel*)[self.contentView viewWithTag:kCommentCell_date];
    NSString* createString = [MyTool humanizeDateFormatFromDate:self.createDate];
    createString = [createString stringByAppendingString:@" 发表"];
    dateLabel.text = createString;
    
}

-(void)myLayoutSubviews
{
    CGRect mainRect = self.bounds;
    int borderMargin = 11;
    int leftMargin = leftrightmargin;
    mainRect = CGRectMake(mainRect.origin.x +leftMargin, mainRect.origin.y + borderMargin, mainRect.size.width -2*leftMargin, mainRect.size.height - 2*borderMargin);
    
    UILabel* titleLabel = (UILabel*)[self.contentView viewWithTag:kCommentCell_title];
    [titleLabel sizeToFit];
    CGRect titleRect = mainRect;
    titleRect.size = CGSizeMake(mainRect.size.width - 16, titleLabel.frame.size.height);
    titleLabel.frame = titleRect;
    
    UIImageView* dateImageView = (UIImageView*)[self.contentView viewWithTag:kCommentCell_dateImageView];
    dateImageView.frame = CGRectMake(mainRect.origin.x+mainRect.size.width-14,  mainRect.origin.y+2, 14, 14);
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!CGRectEqualToRect(frame, CGRectZero)) {
        [self myLayoutSubviews];
    }
}

-(CGSize)sizeThatFits:(CGSize)size
{
    CGSize totalSize = CGSizeZero;
    totalSize.width = 320;
    totalSize.height = 40;
    
    return totalSize;
}

@end

@interface RelativeNewsTableView ()

@property(nonatomic,retain)UITableView* cTableView;

@end

@implementation RelativeNewsTableView
{
    BOOL hasInit;
}
@synthesize dataArray;
@synthesize cTableView;
@synthesize leftrightMargin;
@synthesize titleSize;
@synthesize textSize;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    [dataArray release];
    [cTableView release];
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
    CGRect bounds = self.bounds;
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, 30)];
    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(5, 28, bounds.size.width-10, 2)];
    backView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    backView.backgroundColor = [UIColor blackColor];
    [titleView addSubview:backView];
    [backView release];
    UILabel* tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, titleView.frame.size.height)];
    titleView.backgroundColor = [UIColor clearColor];
    tempLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tempLabel.backgroundColor = [UIColor clearColor];
    if (titleSize>0.0) {
//        tempLabel.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:titleSize];
        tempLabel.font = [UIFont systemFontOfSize:titleSize];
    }
    else
    {
//        tempLabel.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:20.0];
        tempLabel.font = [UIFont systemFontOfSize:20.0];
    }
    tempLabel.text = @"相关新闻";
    tempLabel.textColor = [UIColor blackColor];
    tempLabel.tag = 19832;
    [titleView addSubview:tempLabel];
    
    [self addSubview:titleView];
    
    [tempLabel release];
    [titleView release];
    
    NSInteger orignY = titleView.frame.origin.y+titleView.frame.size.height;
    UITableView* tempTable = [[UITableView alloc] initWithFrame:CGRectMake(0,orignY, bounds.size.width, bounds.size.height - orignY - 5)];
    tempTable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tempTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    tempTable.dataSource = self;
    tempTable.delegate = self;
    tempTable.scrollsToTop = NO;
    tempTable.tag = 1111128;
    [self addSubview:tempTable];
    [tempTable release];
}

-(void)setLeftrightMargin:(NSInteger)aleftrightMargin
{
    leftrightMargin = aleftrightMargin;
    UIView* labelView = [self viewWithTag:19832];
    CGRect labelRect = labelView.frame;
    labelRect.origin.x = leftrightMargin;
    labelView.frame = labelRect;
    
    UITableView* onetable = (UITableView*)[self viewWithTag:1111128];
    [onetable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RelativeNewsCell* cell = nil;
    NSString* userIdentifier = @"textIdentifier";
    cell = (RelativeNewsCell*)[tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!cell) {
        cell = [[[RelativeNewsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textSize = self.textSize;
    NSInteger rowInt = indexPath.row;
    SVRelativeModel* oneModel = [dataArray objectAtIndex:rowInt];
    cell.titleString = oneModel.titleString;
    cell.contentString = oneModel.urlString;
    cell.createDate = oneModel.createDate;
    cell.leftrightmargin = self.leftrightMargin;
    [cell reloadData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowInt = indexPath.row;
    SVRelativeModel* oneModel = [dataArray objectAtIndex:rowInt];
    NSString* urlString = oneModel.urlString;
    if ([delegate respondsToSelector:@selector(RelativeNewsTableView:relativeURLClicked:)]) {
        [delegate RelativeNewsTableView:self relativeURLClicked:urlString];
    }
}

-(NSInteger)fitHeight
{
    NSInteger count = [self tableView:nil numberOfRowsInSection:0];
    NSInteger heightCount = 30;
    for (int i=0; i<count; i++) {
        heightCount += 35;
    }
    heightCount += 5;
    return heightCount;
}

-(void)reloadData
{
    if (!hasInit) {
        hasInit = YES;
        [self initUI];
    }
    [cTableView reloadData];
}

@end
