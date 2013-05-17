//
//  PageTableViewCell.m
//  SinaNews
//
//  Created by shieh exbice on 11-12-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PageTableViewCell.h"

#define PageTableViewCell_titleFontSize 18.0
#define PageTableViewCell_TipLabel 1212122
#define PageTableViewCell_Activitor 1212123
#define PageTableViewCell_Button 1212124

@interface PageTableViewCell()
@property(nonatomic,assign)BOOL btnEnabled;
@property(nonatomic,retain)NSMutableDictionary* tipColorDict;
@property(nonatomic,retain)NSMutableDictionary* tipStringDict;

-(void)initUI;
-(void)myLayoutSubviews;
-(void)setBtnEnabled:(BOOL)bBtnEnabled;
-(void)thisClicked:(UIButton*)sender;

@end

@implementation PageTableViewCell

@synthesize delegate,btnEnabled,tipString,type,tipColor;
@synthesize tipColorDict,tipStringDict;
@synthesize clickable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        hasInit = NO;
        btnEnabled = YES;
        clickable = YES;
        [self reloadData];
    }
    return self;
}

-(void)initUI
{
    self.userInteractionEnabled = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    
    
    UILabel* tipLabel = [[UILabel alloc] init];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    tipLabel.font = [UIFont systemFontOfSize:PageTableViewCell_titleFontSize];
    tipLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    tipLabel.frame = CGRectMake(320/2 - 100/2, 0, 100, 30);
    tipLabel.tag = PageTableViewCell_TipLabel;
    [self.contentView addSubview:tipLabel];
    [tipLabel release];
    
    UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.hidesWhenStopped = YES;
    activity.tag = PageTableViewCell_Activitor;
    [self.contentView addSubview:activity];
    [activity release];
    
    UIButton* parentView = [[UIButton alloc] init];
    [parentView addTarget:self action:@selector(thisClicked:) forControlEvents:UIControlEventTouchUpInside];
    parentView.frame = CGRectMake(0, 0, 320, 30);
    parentView.tag = PageTableViewCell_Button;
    [self.contentView addSubview:parentView];
    
    [parentView release];
}

-(void)dealloc
{
    [tipString release];
    [tipColor release];
    [tipColorDict release];
    [tipStringDict release];
    [super dealloc];
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

-(void)setTipString:(NSString *)oneTipString forType:(NSInteger)oneType
{
    if (!tipStringDict) {
        tipStringDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    NSString* keyString = [[NSNumber numberWithInt:oneType] stringValue];
    [tipStringDict setValue:oneTipString forKey:keyString];
}

-(void)setTipColor:(UIColor *)oneTipColor forType:(NSInteger)oneType
{
    if (!tipColorDict) {
        tipColorDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    NSString* keyString = [[NSNumber numberWithInt:oneType] stringValue];
    [tipColorDict setValue:oneTipColor forKey:keyString];
}

-(void)reloadData
{
    if (!hasInit) {
        hasInit = YES;
        [self initUI];
    }
    UILabel* tipLabel = (UILabel*)[self.contentView viewWithTag:PageTableViewCell_TipLabel];
    UIActivityIndicatorView* activity = (UIActivityIndicatorView*)[self.contentView viewWithTag:PageTableViewCell_Activitor];
    NSString* defaultTipString = nil;
    UIColor* defaultTipColor = nil;
    if (type==PageCellType_Normal) {
        self.btnEnabled = YES;
        if ([activity isAnimating]) {
            [activity stopAnimating];
        }
        defaultTipString = @"点击查看下一页";
        defaultTipColor = [UIColor blackColor];        
    }
    else if(type==PageCellType_Loading)
    {
        self.btnEnabled = NO;
        if (![activity isAnimating]) {
            [activity startAnimating];
        }
        defaultTipString = @"加载中...";
        defaultTipColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    }
    else
    {
        self.btnEnabled = NO;
        if ([activity isAnimating]) {
            [activity stopAnimating];
        }
        defaultTipString = @"已至末页";
        defaultTipColor = [UIColor blackColor];
    }
    if (self.tipString) {
        tipLabel.text = self.tipString;
    }
    else
    {
        tipLabel.text = defaultTipString;
    }
    if (self.tipColor) {
        tipLabel.textColor = self.tipColor;
    }
    else
    {
        tipLabel.textColor = defaultTipColor;
    }
    if (self.tipStringDict) {
        NSString* oneKey = [[NSNumber numberWithInt:type] stringValue];
        NSString* curTip = [self.tipStringDict valueForKey:oneKey];
        if (curTip) {
            tipLabel.text = curTip;
        }
    }
    if (self.tipColorDict) {
        NSString* oneKey = [[NSNumber numberWithInt:type] stringValue];
        UIColor* curTip = [self.tipColorDict valueForKey:oneKey];
        if (curTip) {
            tipLabel.textColor = curTip;
        }
    }
    if (type==PageCellType_Normal&&clickable==NO) {
        UIColor* disableColor = nil;
        if (self.tipColor) {
            disableColor = self.tipColor;
        }
        else
        {
            disableColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
        }
        NSString* tempKey = [[NSNumber numberWithInt:PageCellType_Loading] stringValue];
        UIColor* disableTip = [self.tipColorDict valueForKey:tempKey];
        if (disableTip) {
            disableColor = disableTip;
        }
        tipLabel.textColor = disableColor;
    }
    [self myLayoutSubviews];
}

-(void)myLayoutSubviews
{
    CGRect mainRect = self.bounds;
    UIView* tipLabel = (UIView*)[self.contentView viewWithTag:PageTableViewCell_TipLabel];
    UIView* activity = (UIView*)[self.contentView viewWithTag:PageTableViewCell_Activitor];
    UIView* btnView = (UIView*)[self.contentView viewWithTag:PageTableViewCell_Button];
    
    CGRect btnRect = mainRect;
    btnView.frame = btnRect;
    
    CGRect tipRect = mainRect;
    [tipLabel sizeToFit];
    tipRect.size = tipLabel.frame.size;
    
    CGRect workingRect = CGRectZero;
    if (activity.hidden) {
        workingRect.size = tipRect.size;
    }
    else
    {
        CGRect activityRect = activity.frame;
        workingRect.size = CGSizeMake(tipRect.size.width+ 5 + activityRect.size.width, MAX(tipRect.size.height, activityRect.size.height));
    }
    workingRect.origin.x = mainRect.size.width/2 - workingRect.size.width/2;
    workingRect.origin.y = mainRect.size.height/2 - workingRect.size.height/2;
    
    if (activity.hidden) {
        tipLabel.frame = workingRect;
    }
    else
    {
        CGRect activityRect = activity.frame;
        activityRect.origin.y = workingRect.origin.y + workingRect.size.height/2 - activityRect.size.height/2;
        activityRect.origin.x = workingRect.origin.x;
        activity.frame = activityRect;
        
        tipRect.origin.y = workingRect.origin.y + workingRect.size.height/2 - tipRect.size.height/2;
        tipRect.origin.x = activityRect.origin.x + activityRect.size.width + 5;
        tipLabel.frame = tipRect;
        
    }
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
    //CGRect mainRect = CGRectMake(0, 0, 320, 2000);
    CGSize totalSize = CGSizeZero;
    totalSize.width = 320;
    totalSize.height = 44;
    
    return totalSize;
}

-(void)thisClicked:(UIButton*)sender
{
    if (btnEnabled&&clickable) {
        [self setBtnEnabled:!btnEnabled];
        if (delegate&&[delegate respondsToSelector:@selector(cell:didclicked:)]) {
            [delegate cell:self didclicked:sender];
        }
    }
}

@end
