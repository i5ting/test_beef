//
//  StockListCell.m
//  SinaFinance
//
//  Created by shieh exbice on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StockListCell.h"
#import "ShareData.h"

@interface StockListCell()
@property(nonatomic,retain)UIView* lineView;
@property(nonatomic,retain)UIImageView* realTimeView;

@end

@implementation StockListCell
{
    UIImageView* realTimeView;
    UIView* lineView;
    BOOL hasInit;
    BOOL hasEditSymbol;
    BOOL hasDeleteSymbol;
}
@synthesize columnWidths,lineView;
@synthesize hasSeperatorLine,bRealtime;
@synthesize realTimeView;
@synthesize leftMargin;
@synthesize bDelaytime;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        leftMargin = 5;
        [self initUI];
    }
    return self;
}

- (id)initWithCellType:(NSInteger)type reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        cellType = type;
        // Initialization code
        [self initUI];
    }
    return self;
}

-(void)dealloc
{
    [columnWidths release];
    [lineView release];
    [realTimeView release];
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
    tempView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:tempView];
    self.lineView = tempView;
    self.lineView.hidden = YES;
    [tempView release];
    
    UIImageView* tempView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
    UIImage* tempImage = [UIImage imageNamed:@"stock_list_realtime.png"];
    tempView2.image = tempImage;
    [self.contentView addSubview:tempView2];
    self.realTimeView = tempView2;
    self.realTimeView.hidden = YES;
    [tempView2 release];
}

-(void)setHasSeperatorLine:(BOOL)ahasSeperatorLine
{
    hasSeperatorLine = ahasSeperatorLine;
    self.lineView.hidden = !ahasSeperatorLine;
}

-(void)setBRealtime:(BOOL)realtime
{
    bRealtime = realtime;
    self.realTimeView.hidden = !realtime;
}

-(void)setBDelaytime:(BOOL)realtime
{
    UIImage* tempImage = [UIImage imageNamed:@"stock_list_delay.png"];
    
    bDelaytime = realtime;
    self.realTimeView.frame = CGRectMake(0, 0, 30, 15);
    self.realTimeView.hidden = !realtime;
    
    NSString *open_umeng_flag =  [MobClick getConfigParams:@"is_display_stock_list_delay_img"];
    if ([open_umeng_flag isEqualToString:@"y"]) {
        [self.realTimeView setImage:tempImage];
    }else{
        UIImage* tempImage1 = [UIImage imageNamed:@""];
        [self.realTimeView setImage:tempImage1];
    }

    
    
}


-(void)addLabel
{
    for (int i=0;i<[columnWidths count];i++) {
        NSNumber* oneWidthNumber = [columnWidths objectAtIndex:i];
        UILabel* oneLabel = (UILabel*)[self.contentView viewWithTag:1000+i];
        if (!oneLabel) {
            oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [oneWidthNumber intValue], 30)];
            oneLabel.backgroundColor = [UIColor clearColor];
            oneLabel.lineBreakMode = UILineBreakModeTailTruncation;
            if (i==0) {
                oneLabel.textAlignment = UITextAlignmentLeft;
            }
            else {
                if (cellType==StockListCell_SingleName) {
                    oneLabel.textAlignment = UITextAlignmentCenter;
                }
                else {
                    oneLabel.textAlignment = UITextAlignmentLeft;
                }
            }
            oneLabel.textColor = [UIColor whiteColor];
            oneLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
            oneLabel.tag = 1000+i;
            [self.contentView addSubview:oneLabel];
            [oneLabel release];
        }
        else {
            oneLabel.hidden = NO;
            oneLabel.frame = CGRectMake(0, 0, [oneWidthNumber intValue], 30);
        }
    }
}

-(void)hidenLabels
{
    for (int i=0;i<[columnWidths count];i++) {
        UILabel* oneLabel = (UILabel*)[self.contentView viewWithTag:1000+i];
        if (oneLabel) {
            oneLabel.hidden = YES;
        }
    }
}

-(void)reloadData
{
    if (!hasInit) {
        hasInit = YES;
        [self initUI];
    }
    [self myLayoutSubviews];
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
    if (columnWidths) {
        int reduceWidth = 0;
        int lastPos = 0;
        for (int i=0; i<[columnWidths count]; i++) {
            UILabel* firstLabel = [self labelWithIndex:i];
            NSNumber* widthNumber = [columnWidths objectAtIndex:i];
            CGRect labelRect = firstLabel.frame;
            if (i==0) {
                if (hasEditSymbol) {
                    reduceWidth = 50;
                }
                if (hasDeleteSymbol) {
                    reduceWidth = 50;
                }
                labelRect.size.width = [widthNumber intValue] - reduceWidth;
                lastPos = labelRect.origin.x + labelRect.size.width;
            }
            else {
                labelRect.origin.x = lastPos;
                lastPos = labelRect.origin.x + labelRect.size.width;
            }
            firstLabel.frame = labelRect;
        }
    }
}

-(void)myLayoutSubviews
{
    CGRect mainRect = self.bounds;
    int borderMargin = 0;
    mainRect = CGRectMake(mainRect.origin.x + borderMargin+leftMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin -2*leftMargin, mainRect.size.height - 2*borderMargin);
    int index = 0;
    UILabel* oneLabel = (UILabel*)[self.contentView viewWithTag:1000+index];
    CGRect firstFrame = oneLabel.frame;
    [oneLabel sizeToFit];
    CGRect firstFitFrame = oneLabel.frame;
    firstFitFrame.size.height = firstFrame.size.height;
    oneLabel.frame = firstFrame;
    CGRect realTimeRect = self.realTimeView.frame;
    realTimeRect.origin.y = firstFitFrame.origin.y + firstFitFrame.size.height/2 - realTimeRect.size.height/2;
    realTimeRect.origin.x = firstFitFrame.origin.x+ firstFitFrame.size.width + 5;
    self.realTimeView.frame = realTimeRect;
    
    NSInteger lastpos = mainRect.origin.x;
    while (oneLabel) {
        oneLabel.frame = CGRectMake(lastpos, 0, oneLabel.frame.size.width, mainRect.size.height);
        lastpos = oneLabel.frame.size.width + oneLabel.frame.origin.x;
        index++;
        oneLabel = (UILabel*)[self.contentView viewWithTag:1000 + index];
    }
    self.lineView.frame = CGRectMake(0, self.bounds.size.height-2, self.bounds.size.width, 1);
    
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            [self bringSubviewToFront:v];
        }
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
    return CGSizeMake(320, 40);
}

-(void)setColumnWidths:(NSArray*)widths
{
    if (columnWidths) {
        [self hidenLabels];
    }
    NSArray* oldWidths = columnWidths;
    NSMutableArray* newarray = [[NSMutableArray alloc] initWithArray:widths];
    columnWidths = newarray;
    [oldWidths release];
    [self addLabel];
    [self myLayoutSubviews];
}
-(UILabel*)labelWithIndex:(NSInteger)index
{
    if (index<[columnWidths count]) {
        return (UILabel*)[self.contentView viewWithTag:1000+index];
    }
    else {
        return nil;
    }
}

-(NSArray*)allLabels
{
    NSMutableArray* rtval = nil;
    NSInteger index = 0;
    UILabel* oneLabel = (UILabel*)[self.contentView viewWithTag:1000+index];
    while (oneLabel&&index<[columnWidths count]) {
        index++;
        if (!rtval) {
            rtval = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        }
        [rtval addObject:oneLabel];
        oneLabel = (UILabel*)[self.contentView viewWithTag:1000+index];
    }
    return rtval;
}


@end
