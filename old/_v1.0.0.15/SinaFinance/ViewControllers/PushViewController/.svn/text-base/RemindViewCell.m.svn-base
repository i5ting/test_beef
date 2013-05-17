//
//  RemindViewCell.m
//  SinaNews
//
//  Created by shieh exbice on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RemindViewCell.h"
#import "UIImageView+WebCache.h"

#define kRemindCell_title 191219
#define kRemindCell_image 191220
#define kRemindCell_timelabel 191221
#define kRemindCell_closeBtn 191222
#define kRemindCell_closeBackBtn 191223

#define kRemind_TitleFontSize 13.0

@interface RemindViewCell ()

-(void)initUI;
-(void)myLayoutSubviews;

@end


@implementation RemindViewCell
{
 
}
@synthesize nameString,data,createDate,delegate,hideRemove;
@synthesize is_has_readed;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        hasInit = NO;
    }
    return self;
}

-(void)dealloc
{
    [nameString release];
    [data release];
    [createDate release];
    
    [super dealloc];
}

-(void)initUI
{
    self.userInteractionEnabled = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:213/255.0 alpha:1.0];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.tag = kRemindCell_title;
    titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:60/255.0 blue:118/255.0 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:kRemind_TitleFontSize];
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
    [titleLabel release];
    
    UIImage* avatar = [UIImage imageNamed:@"pic_wiget_highly.png"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:avatar];
    imageView.frame = CGRectMake(0, 0, 10, 10);
    imageView.tag = kRemindCell_image;
    if (!is_has_readed) {
        imageView.image = [UIImage imageNamed:@"pic_wiget_highly"];
    }else{
        imageView.image = [UIImage imageNamed:@"dot"];
    }
    
    [self.contentView addSubview:imageView];
    
    [imageView release];
    
    UILabel* timeLabel = [[UILabel alloc] init];
    timeLabel.frame = CGRectMake(0, 0, 200, 10);
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    timeLabel.font = [UIFont systemFontOfSize:kRemind_TitleFontSize];
    timeLabel.tag = kRemindCell_timelabel;
    [self.contentView addSubview:timeLabel];
    [timeLabel release];
    
    UIButton* closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"btn_wiget_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeClicked:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.tag = kRemindCell_closeBtn;
    closeBtn.frame = CGRectMake(0, 0, 14, 14);
    [self.contentView addSubview:closeBtn];
    [closeBtn release];
    
    UIButton* closeBackBtn = [[UIButton alloc] init];
    [closeBackBtn addTarget:self action:@selector(closeClicked:) forControlEvents:UIControlEventTouchUpInside];
    closeBackBtn.tag = kRemindCell_closeBackBtn;
    closeBackBtn.frame = CGRectMake(0, 0, 30, 30);
    [self.contentView addSubview:closeBackBtn];
    [closeBackBtn release];
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
    UILabel* titleLabel = (UILabel*)[self.contentView viewWithTag:kRemindCell_title];
    titleLabel.text = nameString;
    
    UILabel* dateLabel = (UILabel*)[self.contentView viewWithTag:kRemindCell_timelabel];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = @"yyyy-MM-dd HH:mm";
    dateLabel.text = [formater stringFromDate:createDate];
    [formater release];
    
    UIButton* closeBtn = (UIButton*)[self.contentView viewWithTag:kRemindCell_closeBtn];
    closeBtn.hidden = hideRemove;
    
    UIButton* closeBackBtn = (UIButton*)[self.contentView viewWithTag:kRemindCell_closeBackBtn];
    closeBackBtn.hidden = hideRemove;
     
}

-(void)myLayoutSubviews
{
    CGRect mainRect = self.bounds;
    int borderMargin = 0;
    mainRect = CGRectMake(mainRect.origin.x + borderMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin, mainRect.size.height - 2*borderMargin);
    
    UIImageView* imageView = (UIImageView*)[self.contentView viewWithTag:kRemindCell_image];
    CGRect imageRect = imageView.frame;
    imageRect = CGRectMake(15, 10, imageRect.size.width, imageRect.size.height);
    imageView.frame = imageRect;
    
    UILabel* timeLabel = (UILabel*)[self.contentView viewWithTag:kRemindCell_timelabel];
    CGRect timeRect = timeLabel.frame;
    timeRect.origin.x = imageRect.origin.x + imageRect.size.width + 5; 
    timeRect.origin.y = imageRect.origin.y;
    timeLabel.frame = timeRect;
    
    UIButton* closeBtn = (UIButton*)[self.contentView viewWithTag:kRemindCell_closeBtn];
    CGRect closeRect = closeBtn.frame;
    closeRect.origin.y = imageRect.origin.y;
    closeRect.origin.x = 320 - 14 - 5;
    closeBtn.frame = closeRect;
    
    UIButton* closeBackBtn = (UIButton*)[self.contentView viewWithTag:kRemindCell_closeBackBtn];
    CGRect closeBackRect = closeBackBtn.frame;
    closeBackRect.origin.y = 0;
    closeBackRect.origin.x = 320 - closeBackRect.size.width;
    closeBackRect.size.height = mainRect.size.height;
    closeBackBtn.frame = closeBackRect;
    
    CGRect containRect = mainRect;
    containRect.origin.x = 30;
    containRect.origin.y = 10 + 11 + 3;
    containRect.size.width = containRect.size.width - containRect.origin.x - 20;
    
    UILabel* titleLabel = (UILabel*)[self.contentView viewWithTag:kRemindCell_title];
    CGRect titleRect = containRect;
    titleLabel.frame = titleRect;
    [titleLabel sizeToFit];
    titleRect.size = titleLabel.frame.size;
    titleLabel.frame = titleRect;
    
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
    int borderMargin = 0;
    mainRect = CGRectMake(mainRect.origin.x + borderMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin, mainRect.size.height - 2*borderMargin);
    
    CGRect containRect = mainRect;
    containRect.origin.x = 30;
    containRect.origin.y = 10 + 11 + 3;
    containRect.size.width = containRect.size.width - containRect.origin.x - 20;
    
    CGRect titleRect = containRect;
    
    titleRect.size = [nameString sizeWithFont:[UIFont systemFontOfSize:kRemind_TitleFontSize] constrainedToSize:titleRect.size];
    
    CGSize totalSize = CGSizeZero;
    totalSize.width = 320;
    totalSize.height = titleRect.origin.y + titleRect.size.height + 10;
    return totalSize;
}

-(void)closeClicked:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(cell:closeClicked:)]) {
        [delegate cell:self closeClicked:data];
    }
}

 
@end
