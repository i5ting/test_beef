//
//  BarStockTableCell.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BarStockReplyCell.h"

@interface BarStockReplyCell ()
@property(nonatomic,retain)UIView* lineView;
@property(nonatomic,retain)UILabel* userTipLabel;
@property(nonatomic,retain)UIWebView* contentWebView;
@end

@implementation BarStockReplyCell
{
    BOOL hasInit;
}
@synthesize lineView;
@synthesize levelLabel,userLabel,userTipLabel,dateLabel,contentLabel;
@synthesize contentWebView;

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
    [lineView release];
    [levelLabel release];
    [userLabel release];
    [userTipLabel release];
    [dateLabel release];
    [contentLabel release];
    [contentWebView release];
    
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)initUI
{
    hasInit = YES;
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
    label.frame = CGRectMake(5, 5, 40, 20);
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:label];
    self.levelLabel = label;
    [label release];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(50, 5, 30, 20);
    label.text = @"作者:";
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor colorWithRed:118/255.0 green:139/255.0 blue:156/255.0 alpha:1.0];
    [self.contentView addSubview:label];
    self.userTipLabel = label;
    [label release];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(80, 5, 120, 20);
    label.textColor = [UIColor colorWithRed:118/255.0 green:139/255.0 blue:156/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:label];
    self.userLabel = label;
    [label release];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(200, 5, 115, 20);
    label.textColor = [UIColor colorWithRed:118/255.0 green:139/255.0 blue:156/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:label];
    self.dateLabel = label;
    [label release];
    
    UIWebView* contentWeb = [[UIWebView alloc] init];
    contentWeb.backgroundColor = [UIColor clearColor];
    contentWeb.frame = CGRectMake(5, 25, 310, 30);
    contentWeb.opaque = NO;
    //[self.contentView addSubview:contentWeb];
    self.contentWebView = contentWeb;
    [contentWeb release];
    
    label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12.0];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [self.contentView addSubview:label];
    self.contentLabel = label;
    [label release];
}

-(void)reloadData
{
    if (!hasInit) {
        [self initUI];
    }
    NSString* contentText = self.contentLabel.text;
    NSString *htmlstr = [NSString stringWithFormat:@"<body style=\"margin:0;color:rgb(255,255,255);background-color: transparent; font-size:12;\" >%@</body>",contentText];
    [self.contentWebView loadHTMLString:htmlstr baseURL:nil];
    [self myLayoutSubviews];
}

-(void)myLayoutSubviews
{
    CGRect mainRect = self.bounds;
    int borderMargin = 5;
    int leftMargin = 0;
    mainRect = CGRectMake(mainRect.origin.x + borderMargin+leftMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin -2*leftMargin, mainRect.size.height - 2*borderMargin);
    NSInteger lineOneHeight = 20;
    CGRect contentRect = CGRectMake(borderMargin+leftMargin, lineOneHeight+borderMargin, mainRect.size.width, mainRect.size.height - lineOneHeight);
    self.contentLabel.frame = contentRect;
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
    CGRect mainRect = CGRectMake(0, 0, 320, 20000);
    int borderMargin = 5;
    int leftMargin = 0;
    mainRect = CGRectMake(mainRect.origin.x + borderMargin+leftMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin -2*leftMargin, mainRect.size.height - 2*borderMargin);
    NSInteger lineOneHeight = 20;
    CGRect contentRect = CGRectMake(borderMargin+leftMargin, lineOneHeight+borderMargin, mainRect.size.width, mainRect.size.height - lineOneHeight);
    NSString* contentText = self.contentLabel.text;
    self.contentLabel.frame = contentRect;
    [self.contentLabel sizeToFit];
    contentRect = self.contentLabel.frame;
    
    return CGSizeMake(320, contentRect.origin.y+contentRect.size.height+borderMargin);
}

@end
