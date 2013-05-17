//
//  WeiboCommentCell.m
//  SinaNews
//
//  Created by shieh exbice on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "WeiboCommentCell.h"

#define kWeiboCommentCell_title 191219
#define kWeiboCommentCell_content 191229
#define kWeiboCommentCell_date 191239
#define kWeiboCommentCell_dateImageView 191249

#define kWeiboCommentCell_TitleFontSize 16.0
#define kWeiboCommentCell_ContentFontSize 14.0

@interface WeiboCommentCell ()

-(void)initUI;
-(void)myLayoutSubviews;

@end

@implementation WeiboCommentCell
@synthesize titleString,contentString,createDate,data;

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
    titleLabel.tag = kWeiboCommentCell_title;
    titleLabel.font = [UIFont systemFontOfSize:kWeiboCommentCell_TitleFontSize];
    titleLabel.textColor = [UIColor colorWithRed:145/255.0 green:99/255.0 blue:0/255.0 alpha:1.0];
    [self.contentView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel* dateLabel = [[UILabel alloc] init];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.tag = kWeiboCommentCell_date;
    dateLabel.font = [UIFont systemFontOfSize:kWeiboCommentCell_TitleFontSize];
    dateLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [self.contentView addSubview:dateLabel];
    [dateLabel release];
    
    UIImageView* dateImageView = [[UIImageView alloc] init];
    dateImageView.image = [UIImage imageNamed:@"pic_clock.png"];
    dateImageView.tag = kWeiboCommentCell_dateImageView;
    [self.contentView addSubview:dateImageView];
    [dateImageView release];
    
    UILabel* contentLabel = [[UILabel alloc] init];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.tag = kWeiboCommentCell_content;
    contentLabel.font = [UIFont systemFontOfSize:kWeiboCommentCell_ContentFontSize];
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
    
    UILabel* titleLabel = (UILabel*)[self.contentView viewWithTag:kWeiboCommentCell_title];
    titleLabel.text = self.titleString;
    
    UILabel* contentLabel = (UILabel*)[self.contentView viewWithTag:kWeiboCommentCell_content];
    contentLabel.text = self.contentString;
    
    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"MM-dd HH:mm:ss"];
    NSString* dateString = [dateFormater stringFromDate:self.createDate];
    UILabel* dateLabel = (UILabel*)[self.contentView viewWithTag:kWeiboCommentCell_date];
    dateLabel.text = dateString;
    
}

-(void)myLayoutSubviews
{
    CGRect mainRect = self.bounds;
    int borderMargin = 4;
    int leftMargin = 5;
    mainRect = CGRectMake(mainRect.origin.x + borderMargin+leftMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin -2*leftMargin, mainRect.size.height - 2*borderMargin);
    
    UILabel* dateLabel = (UILabel*)[self.contentView viewWithTag:kWeiboCommentCell_date];
    CGRect dateRect = mainRect;
    dateLabel.frame = dateRect;
    [dateLabel sizeToFit];
    dateRect.size = dateLabel.frame.size;
    dateRect.origin.x = mainRect.origin.x + mainRect.size.width - dateRect.size.width;
    dateLabel.frame = dateRect;
    
    UIImageView* dateImageView = (UIImageView*)[self.contentView viewWithTag:kWeiboCommentCell_dateImageView];
    dateImageView.frame = CGRectMake(dateRect.origin.x - 3 - 15, dateRect.origin.y + (dateRect.size.height/2 - 15/2), 15, 15);
    
    UILabel* titleLabel = (UILabel*)[self.contentView viewWithTag:kWeiboCommentCell_title];
    CGRect titleRect = mainRect;
    titleRect.size = CGSizeMake(mainRect.size.width - dateRect.size.width, dateRect.size.height);
    titleLabel.frame = titleRect;
    
    UILabel* contentLabel = (UILabel*)[self.contentView viewWithTag:kWeiboCommentCell_content];
    CGRect contentRect = mainRect;
    contentRect.origin.y = titleRect.origin.y + titleRect.size.height + borderMargin;
    contentLabel.frame = contentRect;
    [contentLabel sizeToFit];
    contentRect.size = contentLabel.frame.size;
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
    int borderMargin = 4;
    int leftMargin = 5;
    mainRect = CGRectMake(mainRect.origin.x + borderMargin+leftMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin -2*leftMargin, mainRect.size.height - 2*borderMargin);
    
    CGSize titleSize = [self.titleString sizeWithFont:[UIFont systemFontOfSize:kWeiboCommentCell_TitleFontSize]];
    CGRect titleRect = mainRect;
    titleRect.size = titleSize;
    
    CGRect contentRect = mainRect;
    contentRect.origin.y = titleRect.origin.y + titleRect.size.height + borderMargin;
    contentRect.size = [self.contentString sizeWithFont:[UIFont systemFontOfSize:kWeiboCommentCell_ContentFontSize] constrainedToSize:mainRect.size];
    
    CGSize totalSize = CGSizeZero;
    totalSize.width = 320;
    totalSize.height = contentRect.origin.y + contentRect.size.height + borderMargin;
    
    return totalSize;
}

@end
