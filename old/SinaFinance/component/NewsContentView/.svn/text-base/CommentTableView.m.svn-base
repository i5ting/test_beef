//
//  CommentTableView.m
//  SinaNews
//
//  Created by shieh exbice on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentTableView.h"
#import "ArticleContentView.h"
#import "MyTool.h"

#define kCommentCell_title 191219
#define kCommentCell_content 191229
#define kCommentCell_date 191239
#define kCommentCell_dateImageView 191249

#define kCommentCell_TitleFontSize 12.0
#define kCommentCell_ContentFontSize 14.0
#define kCommentCell_DateFontSize 12.0

@interface CommentTableCell ()

-(void)initUI;
-(void)myLayoutSubviews;

@end

@implementation CommentTableCell
@synthesize titleString,contentString,createDate,data;
@synthesize leftrightmargin;

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
    titleLabel.font = [UIFont systemFontOfSize:kCommentCell_TitleFontSize];
    titleLabel.textColor = [UIColor colorWithRed:22/255.0 green:86/255.0 blue:181/255.0 alpha:1.0];
    [self.contentView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel* dateLabel = [[UILabel alloc] init];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.tag = kCommentCell_date;
    dateLabel.font = [UIFont systemFontOfSize:kCommentCell_DateFontSize];
    dateLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [self.contentView addSubview:dateLabel];
    [dateLabel release];
    
    UIImageView* dateImageView = [[UIImageView alloc] init];
    //dateImageView.image = [UIImage imageNamed:@"pic_clock.png"];
    dateImageView.tag = kCommentCell_dateImageView;
    //    dateImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:dateImageView];
    [dateImageView release];
    
    UILabel* contentLabel = [[UILabel alloc] init];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.tag = kCommentCell_content;
//    contentLabel.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:kCommentCell_ContentFontSize];
    contentLabel.font = [UIFont systemFontOfSize:kCommentCell_ContentFontSize];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    [contentLabel release];
    
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
    
    UILabel* contentLabel = (UILabel*)[self.contentView viewWithTag:kCommentCell_content];
    contentLabel.text = self.contentString;
    
    UILabel* dateLabel = (UILabel*)[self.contentView viewWithTag:kCommentCell_date];
    NSString* createString = [MyTool humanizeDateFormatFromDate:self.createDate];
    createString = [createString stringByAppendingString:@" 发表"];
    dateLabel.text = createString;
    
}

-(void)myLayoutSubviews
{
    CGRect mainRect = self.bounds;
    int borderMargin = 6;
    int leftMargin = leftrightmargin;
    mainRect = CGRectMake(mainRect.origin.x +leftMargin, mainRect.origin.y + borderMargin, mainRect.size.width -2*leftMargin, mainRect.size.height - 2*borderMargin);
    
    UILabel* dateLabel = (UILabel*)[self.contentView viewWithTag:kCommentCell_date];
    CGRect dateRect = mainRect;
    dateLabel.frame = dateRect;
    [dateLabel sizeToFit];
    dateRect.size = dateLabel.frame.size;
    dateRect.origin.x = mainRect.origin.x + mainRect.size.width - dateRect.size.width;
    dateLabel.frame = dateRect;
    
    
    
    UILabel* titleLabel = (UILabel*)[self.contentView viewWithTag:kCommentCell_title];
    [titleLabel sizeToFit];
    CGRect titleRect = mainRect;
    titleRect.size = CGSizeMake(mainRect.size.width - dateRect.size.width, titleLabel.frame.size.height);
    titleLabel.frame = titleRect;
    
    UILabel* contentLabel = (UILabel*)[self.contentView viewWithTag:kCommentCell_content];
    CGRect contentRect = mainRect;
    contentRect.origin.y = titleRect.origin.y + titleRect.size.height + borderMargin;
    contentLabel.frame = contentRect;
    [contentLabel sizeToFit];
    contentRect.size = contentLabel.frame.size;
    
    dateRect.origin.y =  titleLabel.frame.origin.y + titleLabel.frame.size.height/2 - dateLabel.frame.size.height/2;
    dateLabel.frame = dateRect;
    
    UIImageView* dateImageView = (UIImageView*)[self.contentView viewWithTag:kCommentCell_dateImageView];
    dateImageView.frame = CGRectMake(dateRect.origin.x - 3 - 15, dateRect.origin.y + (dateRect.size.height/2 - 10/2), 10, 10);
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
    CGRect mainRect = CGRectMake(0, 0, 320, 2000);
    int borderMargin = 6;
    int leftMargin = leftrightmargin;
    mainRect = CGRectMake(mainRect.origin.x +leftMargin, mainRect.origin.y + borderMargin, mainRect.size.width -2*leftMargin, mainRect.size.height - 2*borderMargin);
    
    CGSize titleSize = [self.titleString sizeWithFont:[UIFont systemFontOfSize:kCommentCell_TitleFontSize]];
    CGRect titleRect = mainRect;
    titleRect.size = titleSize;
    
    CGRect contentRect = mainRect;
    contentRect.origin.y = titleRect.origin.y + titleRect.size.height + borderMargin;
    contentRect.size = [self.contentString sizeWithFont:[UIFont systemFontOfSize:kCommentCell_ContentFontSize] constrainedToSize:mainRect.size];
    
    CGSize totalSize = CGSizeZero;
    totalSize.width = 320;
    totalSize.height = contentRect.origin.y + contentRect.size.height + borderMargin;
    
    return totalSize;
}

@end

@interface CommentTableView ()

@property(nonatomic,retain)UITableView* cTableView;

@end

@implementation CommentTableView
@synthesize dataArray;
@synthesize cTableView;
@synthesize leftrightMargin;
@synthesize delegate;

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
    tempLabel.text = @"评论";
//    tempLabel.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:20.0];
    tempLabel.font = [UIFont systemFontOfSize:20.0];
    tempLabel.textColor = [UIColor blackColor];
    tempLabel.tag = 19832;
    [titleView addSubview:tempLabel];
    
    [self addSubview:titleView];
    
    [tempLabel release];
    [titleView release];
    
    NSInteger orignBtnY = bounds.size.height - 27;
    NSInteger sizeBtn = 22;
    NSInteger orignY = titleView.frame.origin.y+titleView.frame.size.height;
    UITableView* tempTable = [[UITableView alloc] initWithFrame:CGRectMake(0,orignY, bounds.size.width, bounds.size.height - orignY - 35)];
    tempTable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tempTable.dataSource = self;
    tempTable.delegate = self;
    tempTable.scrollsToTop = NO;
    tempTable.tag = 1111128;
    [self addSubview:tempTable];
    [tempTable release];
    
    UIButton* allContentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* btnImage = [UIImage imageNamed:@"btn_allcomment.png"];
    CGRect btnRect = CGRectMake(bounds.size.width/2 - 40, orignBtnY, 80, sizeBtn);
    allContentBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [allContentBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [allContentBtn setTitle:@"查看所有评论" forState:UIControlStateNormal];
    [allContentBtn setTitleColor:[UIColor colorWithRed:27.0/255.0 green:27.0/255.0 blue:27.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    allContentBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [allContentBtn addTarget:self action:@selector(allContentClicked:) forControlEvents:UIControlEventTouchUpInside];
    allContentBtn.frame = btnRect;
    [self addSubview:allContentBtn];
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
    CommentTableCell* cell = nil;
    NSString* userIdentifier = @"textIdentifier";
    cell = (CommentTableCell*)[tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!cell) {
        cell = [[[CommentTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger rowInt = indexPath.row;
    SVCommentModel* oneModel = [dataArray objectAtIndex:rowInt];
    cell.titleString = oneModel.authorString;
    cell.contentString = oneModel.contentString;
    cell.createDate = oneModel.createDate;
    cell.leftrightmargin = self.leftrightMargin;
    NSInteger height = [cell sizeThatFits:CGSizeZero].height;
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableCell* cell = nil;
    NSString* userIdentifier = @"textIdentifier";
    cell = (CommentTableCell*)[tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!cell) {
        cell = [[[CommentTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger rowInt = indexPath.row;
    SVCommentModel* oneModel = [dataArray objectAtIndex:rowInt];
    cell.titleString = oneModel.authorString;
    cell.contentString = oneModel.contentString;
    cell.createDate = oneModel.createDate;
    cell.leftrightmargin = self.leftrightMargin;
    [cell reloadData];
    return cell;
}

-(NSInteger)fitHeight
{
    NSInteger count = [self tableView:nil numberOfRowsInSection:0];
    NSInteger heightCount = 30;
    for (int i=0; i<count; i++) {
        heightCount += [self tableView:nil heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    heightCount += 35;
    return heightCount;
}

-(void)reloadData
{
    [cTableView reloadData];
}

-(void)allContentClicked:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(commentTableView:allContentClicked:)]) {
        [delegate commentTableView:self allContentClicked:sender];
    }
}

@end
