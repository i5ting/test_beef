//
//  NewsFavoriteTableViewCell.m
//  SinaNews
//
//  Created by  on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsFavoriteTableViewCell.h"

#define kCommentCell_title 191219

#define kComment_TitleFontSize 18.0

@interface NewsFavoriteTableViewCell ()

-(void)initUI;
-(void)myLayoutSubviews;

@end


@implementation NewsFavoriteTableViewCell
{
    BOOL hasEditSymbol;
    BOOL hasDeleteSymbol;
}
@synthesize nameString,data;

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
    
    [super dealloc];
}

-(void)initUI
{
    self.userInteractionEnabled = YES;
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.tag = kCommentCell_title;
    titleLabel.font = [UIFont systemFontOfSize:kComment_TitleFontSize];
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
    [titleLabel release];
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
    titleLabel.text = nameString;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    if ((state&UITableViewCellStateShowingEditControlMask)>0) {
        hasEditSymbol = YES;
    }
    else {
        hasEditSymbol = NO;
    }
    if ((state&UITableViewCellStateShowingDeleteConfirmationMask)>0) {
        hasDeleteSymbol = YES;
    }
    else {
        hasDeleteSymbol = NO;
    }
    [self myLayoutSubviews];
}

-(void)myLayoutSubviews
{
    CGRect mainRect = self.bounds;
    if (hasEditSymbol) {
        mainRect.size.width -= 32;
    }
    if (hasDeleteSymbol) {
        mainRect.size.width -= 50;
    }
    int borderMargin = 4;
    int leftrightMargin = 10;
    mainRect = CGRectMake(mainRect.origin.x + borderMargin+leftrightMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin-2*leftrightMargin, mainRect.size.height - 2*borderMargin);
    
    UILabel* titleLabel = (UILabel*)[self.contentView viewWithTag:kCommentCell_title];
    CGRect titleRect = mainRect;
    titleLabel.frame = titleRect;
    [titleLabel sizeToFit];
    titleRect.size = titleLabel.frame.size;
    titleRect.origin.y = mainRect.origin.y + mainRect.size.height/2 - titleRect.size.height/2;
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
    int borderMargin = 4;
    int leftrightMargin = 10;
    mainRect = CGRectMake(mainRect.origin.x + borderMargin+leftrightMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin - 2*leftrightMargin, mainRect.size.height - 2*borderMargin);
    
    CGRect titleRect = mainRect;
    
    titleRect.size = [nameString sizeWithFont:[UIFont systemFontOfSize:kComment_TitleFontSize] constrainedToSize:titleRect.size];

    CGSize totalSize = CGSizeZero;
    totalSize.width = 320;
    totalSize.height = titleRect.origin.y + titleRect.size.height + borderMargin;
    totalSize.height = totalSize.height>44?totalSize.height:44;
    return totalSize;
}


@end
