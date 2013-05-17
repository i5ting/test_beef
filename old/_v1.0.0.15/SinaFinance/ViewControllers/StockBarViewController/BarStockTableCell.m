//
//  BarStockTableCell.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BarStockTableCell.h"

@interface BarStockTableCell ()
@property(nonatomic,retain)UILabel* clickTipLabel;
@property(nonatomic,retain)UILabel* replyTipLabel;
@property(nonatomic,retain)UIView* lineView;
@end

@implementation BarStockTableCell
{
    BOOL hasInit;
    UIView* lineView;
}
@synthesize titleLabel,clickNumLabel,clickTipLabel,replyTipLabel,replayNumLabel,mediaLabel,dateLabel;
@synthesize lineView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

-(void)dealloc
{
    [titleLabel release];
    [clickNumLabel release];
    [clickTipLabel release];
    [replayNumLabel release];
    [replyTipLabel release];
    [mediaLabel release];
    [dateLabel release];
    [lineView release];
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    
    UIView* tempView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, 320, 1)];
    tempView.backgroundColor = [UIColor colorWithRed:73/255.0 green:100/255.0 blue:125/255.0 alpha:1.0];
    [self.contentView addSubview:tempView];
    self.lineView = tempView;
    [tempView release];
    
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(5, 5, 310, 20);
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    [label release];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(5, 25, 40, 20);
    label.font = [UIFont systemFontOfSize:12.0];
    label.text = @"点击:";
    label.textColor = [UIColor colorWithRed:118/255.0 green:139/255.0 blue:156/255.0 alpha:1.0];
    [self.contentView addSubview:label];
    self.clickTipLabel = label;
    [label release];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(45, 25, 60, 20);
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor colorWithRed:118/255.0 green:139/255.0 blue:156/255.0 alpha:1.0];
    [self.contentView addSubview:label];
    self.clickNumLabel = label;
    [label release];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(105, 25, 40, 20);
    label.text = @"回复:";
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor colorWithRed:118/255.0 green:139/255.0 blue:156/255.0 alpha:1.0];
    [self.contentView addSubview:label];
    self.replyTipLabel = label;
    [label release];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(145, 25, 60, 20);
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor colorWithRed:118/255.0 green:139/255.0 blue:156/255.0 alpha:1.0];
    [self.contentView addSubview:label];
    self.replayNumLabel = label;
    [label release];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(135, 25, 140, 20);
    label.textAlignment = UITextAlignmentRight;
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor colorWithRed:118/255.0 green:139/255.0 blue:156/255.0 alpha:1.0];
    [self.contentView addSubview:label];
    self.mediaLabel = label;
    [label release];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(245, 25, 75, 20);
    label.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:label];
    label.textColor = [UIColor colorWithRed:118/255.0 green:139/255.0 blue:156/255.0 alpha:1.0];
    self.dateLabel = label;
    [label release];
    
}

-(void)reloadData
{
    if (!hasInit) {
        hasInit = YES;
        [self initUI];
    }
}

-(void)myLayoutSubviews
{
    CGRect mainRect = self.bounds;
    int borderMargin = 5;
    int leftMargin = 0;
    mainRect = CGRectMake(mainRect.origin.x + borderMargin+leftMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin -2*leftMargin, mainRect.size.height - 2*borderMargin);
    self.lineView.frame = CGRectMake(0, mainRect.origin.y + mainRect.size.height + borderMargin -1, 320, 1);
    
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
    return CGSizeMake(320, 44);
}

@end
