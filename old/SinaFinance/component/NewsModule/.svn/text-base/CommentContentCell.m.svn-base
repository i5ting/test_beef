//
//  CommentContentCell.m
//  SinaNews
//
//  Created by shieh exbice on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommentContentCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MyTool.h"
#import "NewsObject.h"
#import "NewsFuncPuller.h"

#define CommentContentCell_MaxNumOfBorder 5
#define CommentContentCell_BorderSpacer 2

#define CommentContentCell_DefaultNumOfLevel 4
#define CommentContentCell_DefaultTopNumOfLevel 2
#define CommentContentCell_DefaultBottomNumOfLevel 2

#define CommentContentCell_Margin 6
#define CommentContentCell_TitleFontSize 12.0
#define CommentContentCell_ContentFontSize 16.0
#define CommentContentCell_ExpandFontSize 18.0

#define CommentContentCell_ExpandHeight 40.0

@class BorderView;

@protocol BorderView_Delegate <NSObject>

-(void)BorderViewClicked:(BorderView*)sender;

@end

@interface BorderView : UIView
{
    UILabel* titleLabel;
    UILabel* contentLabel;
    UILabel* numOfLevel;
    UIView* expandView;
    BOOL hasInit;
    
    NSString* titleName;
    NSString* contentString;
    NSString* tipString;
    NSInteger topExtraMargin;
    BOOL bLastView;
    BOOL bHidenView;
    id<BorderView_Delegate> delegate;
    
    NSInteger retTopMarginForContainView;
}
@property(nonatomic,retain)UIView* expandView;
@property(nonatomic,retain)UILabel* titleLabel;
@property(nonatomic,retain)UILabel* contentLabel;
@property(nonatomic,retain)UILabel* numOfLevel;
@property(nonatomic,retain)NSString* titleName;
@property(nonatomic,retain)NSString* contentString;
@property(nonatomic,retain)NSString* tipString;
@property(nonatomic,assign)NSInteger topExtraMargin;
@property(nonatomic,assign)BOOL bLastView;
@property(nonatomic,assign)BOOL bHidenView;
@property(nonatomic,assign)NSInteger retTopMarginForContainView;
@property(nonatomic,assign)id<BorderView_Delegate> delegate;

-(void)initUI;
-(void)reloadData;
-(void)reloadTimeString;
@end
    
@implementation BorderView
@synthesize titleName,contentString,tipString;
@synthesize titleLabel,expandView,contentLabel,numOfLevel,topExtraMargin,bLastView,bHidenView;
@synthesize retTopMarginForContainView;
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        hasInit = NO;
        topExtraMargin = 0;
        bLastView = NO;
        bHidenView = NO;
    }
    return self;
}

-(void)dealloc
{
    [titleName release];
    [contentString release];
    [tipString release];
    [titleLabel release];
    [contentLabel release];
    [numOfLevel release];
    [expandView release];
    
    [super dealloc];
}

-(void)initUI
{
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:CommentContentCell_TitleFontSize];
    label.textColor = [UIColor colorWithRed:22/255.0 green:86/255.0 blue:181/255.0 alpha:1.0];
    [self addSubview:label];
    self.titleLabel = label;
    [label release];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:CommentContentCell_TitleFontSize];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    [self addSubview:label];
    self.numOfLevel = label;
    [label release];
    
    label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:CommentContentCell_ContentFontSize];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    [self addSubview:label];
    self.contentLabel = label;
    [label release];
    
}

-(void)initExpandView
{
    UIButton* parentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, CommentContentCell_ExpandHeight)];
    [parentView addTarget:self action:@selector(thisClicked:) forControlEvents:UIControlEventTouchUpInside];
    UILabel* tipLabel = [[UILabel alloc] init];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    tipLabel.font = [UIFont systemFontOfSize:CommentContentCell_ExpandFontSize];
    tipLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    tipLabel.text = @"点击展开隐藏楼层";
    [tipLabel sizeToFit];
    CGRect tipRect = parentView.bounds;
    tipRect.size =tipLabel.frame.size;
    tipRect.origin.x = (parentView.bounds.size.width/2 - tipRect.size.width/2);
    tipRect.origin.y = (parentView.bounds.size.height/2 - tipRect.size.height/2);
    tipLabel.frame = tipRect;
    tipLabel.tag = 11111222;
    [parentView addSubview:tipLabel];
    [tipLabel release];
    
    self.expandView = parentView;
    [self addSubview:parentView];
    [parentView release];
}

-(void)thisClicked:(UIButton*)sender
{
    UILabel* tipLabel = (UILabel*)[self.expandView viewWithTag:11111222];
    tipLabel.text = @"楼层扩展中";
    CGRect parentRect = tipLabel.superview.frame;
    [tipLabel sizeToFit];
    CGRect tipRect = parentRect;
    tipRect.size = tipLabel.frame.size;
    tipRect.origin.x = (parentRect.size.width/2 - tipRect.size.width/2);
    tipRect.origin.y = (parentRect.size.height/2 - tipRect.size.height/2);
    tipLabel.frame = tipRect;
    
    if ([delegate respondsToSelector:@selector(BorderViewClicked:)]) {
        [delegate BorderViewClicked:self];
    }
}

-(void)reloadData
{
    if (!hasInit) {
        hasInit = YES;
        [self initUI];
    }
    
    if (bHidenView) {
        if (!expandView) {
            [self initExpandView];
        }
    }
    
    if (bLastView) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 0;    
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;    
        self.layer.borderColor= [[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0] CGColor]; 
    }
    if (!bHidenView) {
        titleLabel.text = titleName;
        contentLabel.text = contentString;
        numOfLevel.text = tipString;
        expandView.hidden = YES;
    }
    else
    {
        titleLabel.text = nil;
        contentLabel.text = nil;
        numOfLevel.text = nil;
        expandView.hidden = NO;
    }
    
}

-(void)reloadTimeString
{
    numOfLevel.text = tipString;
    [self myLayoutSubviews];
}

-(void)myLayoutSubviews
{
    CGRect mainRect = self.bounds;
    if (!bHidenView) {
        int borderMargin = CommentContentCell_Margin;
        if (!bLastView) {
            mainRect = CGRectMake(mainRect.origin.x + borderMargin, mainRect.origin.y + borderMargin + topExtraMargin, mainRect.size.width - 2*borderMargin, mainRect.size.height - 2*borderMargin - topExtraMargin);
        }
        else
        {
            mainRect = CGRectMake(mainRect.origin.x + borderMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin, mainRect.size.height - 2*borderMargin);
        }
        
        [self.numOfLevel sizeToFit];
        CGRect numRect = mainRect;
        numRect.size = self.numOfLevel.frame.size;
        numRect.origin.x = mainRect.origin.x + mainRect.size.width - self.numOfLevel.frame.size.width;
        self.numOfLevel.frame = numRect;
        
        CGRect titleRect = mainRect;
        titleRect.size.width = mainRect.size.width - numRect.size.width;
        titleRect.size.height = numRect.size.height;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.frame = titleRect;
        
        int curY = numRect.origin.y + numRect.size.height + borderMargin;
        self.retTopMarginForContainView = curY;
        if (bLastView) {
            mainRect.size.height = mainRect.size.height - (curY + topExtraMargin - mainRect.origin.y);
            mainRect.origin.y = curY + topExtraMargin;
        }
        else
        {
            mainRect.size.height = mainRect.size.height - (curY - mainRect.origin.y);
            mainRect.origin.y = curY;
        }
        
        CGRect contentRect = mainRect;
        self.contentLabel.frame = contentRect;
    }
    else
    {
        CGRect expandRect = CGRectMake(0, mainRect.origin.y + topExtraMargin, mainRect.size.width, CommentContentCell_ExpandHeight); 
        self.expandView.frame = expandRect;
    }
    ;
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
    CGRect mainRect = CGRectMake(0, 0, size.width, 10000);
    if (!bHidenView)
    {
        int borderMargin = CommentContentCell_Margin;
        if (!bLastView) {
            mainRect = CGRectMake(mainRect.origin.x + borderMargin, mainRect.origin.y + borderMargin + topExtraMargin, mainRect.size.width - 2*borderMargin, mainRect.size.height - 2*borderMargin - topExtraMargin);
        }
        else
        {
            mainRect = CGRectMake(mainRect.origin.x + borderMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin, mainRect.size.height - 2*borderMargin);
        }
        
        [self.numOfLevel sizeToFit];
        CGRect numRect = mainRect;
        numRect.size = self.numOfLevel.frame.size;
        numRect.origin.x = mainRect.origin.x + mainRect.size.width - self.numOfLevel.frame.size.width;
        
        int curY = numRect.origin.y + numRect.size.height + borderMargin;
        
        if (bLastView) {
            mainRect.size.height = mainRect.size.height - (curY + topExtraMargin - mainRect.origin.y);
            mainRect.origin.y = curY + topExtraMargin;
        }
        else
        {
            mainRect.size.height = mainRect.size.height - (curY - mainRect.origin.y);
            mainRect.origin.y = curY;
        }
        
        CGRect contentRect = mainRect;
        self.contentLabel.frame = contentRect;
        [self.contentLabel sizeToFit];
        contentRect.size.height = self.contentLabel.frame.size.height;
        
        
        totalSize.width = size.width;
        totalSize.height = contentRect.origin.y + contentRect.size.height + borderMargin;
    }
    else
    {
        
        totalSize.width = size.width;
        totalSize.height = topExtraMargin + CommentContentCell_ExpandHeight;
    }
    return totalSize;
}

@end

@interface CommentContentCell() 
@property(nonatomic,retain)NSMutableArray* levelViews;

-(void)addBorderViewToArray:(NSMutableArray*)dest atIndex:(NSInteger)index;
@end

@implementation CommentContentCell

@synthesize commentLevels=mCommentLevels,data,expandLevel=mExpandLevel;
@synthesize levelViews;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        hasInit = NO;
        mExpandLevel = NO;
    }
    return self;
}

-(void)dealloc
{
    [mCommentLevels release];
    [data release];
    [levelViews release];
    
    [super dealloc];
}

-(void)initUI
{
    self.userInteractionEnabled = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    UIImage* backImage = [[UIImage imageNamed:@"wf_wiget_back.png"] stretchableImageWithLeftCapWidth:1.0 topCapHeight:40.0];
    UIImageView* backView = [[UIImageView alloc] initWithImage:backImage];
    self.backgroundView = backView;
    [backView release];
}

-(void)reloadDataWithUI
{
    if (!self.levelViews) {
        NSMutableArray* viewArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.levelViews = viewArray;
        [viewArray release];
    }
    else
    {
        for (int i=0; i<[self.levelViews count]; i++) {
            UIView* aView = [self.levelViews objectAtIndex:i];
            [aView removeFromSuperview];
        }
        [self.levelViews removeAllObjects];
    }
    
    int commentLevelsCount = [self.commentLevels count];
    if (self.commentLevels&&commentLevelsCount>0) {
        if ((!self.expandLevel)&&commentLevelsCount>CommentContentCell_DefaultNumOfLevel) {
            BOOL hasAddedHiden = NO;
            for (int i=0; i<commentLevelsCount; i++) {
                if (i<CommentContentCell_DefaultTopNumOfLevel) {
                    [self addBorderViewToArray:self.levelViews atIndex:i];
                }
                else if(i<commentLevelsCount-CommentContentCell_DefaultBottomNumOfLevel)
                {
                    if (!hasAddedHiden) {
                        hasAddedHiden = YES;
                        BorderView* borderView = [[BorderView alloc] init];
                        borderView.delegate = self;
                        borderView.bHidenView = YES;
                        [borderView reloadData];
                        [self.contentView addSubview:borderView];
                        [self.contentView sendSubviewToBack:borderView];
                        [self.levelViews addObject:borderView];
                        [borderView release];
                    }
                }
                else
                {
                    [self addBorderViewToArray:self.levelViews atIndex:i];
                }
            }
        }
        else
        {
            for (int i=0; i<commentLevelsCount; i++) {
                [self addBorderViewToArray:self.levelViews atIndex:i];
            }
        }
    }
}

-(void)addBorderViewToArray:(NSMutableArray*)dest atIndex:(NSInteger)index
{
    BorderView* borderView = [[BorderView alloc] init];
    NewsObject* commentObject = [self.commentLevels objectAtIndex:index];
    NSString* content = [commentObject valueForKey:CommentContentObject_content];
    borderView.contentString = content;
    
    NSString* ipStr = [commentObject valueForKey:CommentContentObject_ip];
    NSString* nickStr = [commentObject valueForKey:CommentContentObject_nick];
    if (index==[self.commentLevels count]-1) {
        NSString* titleStr = [NSString stringWithFormat:@"%@[%@]:",nickStr,[self hideIPWithSourceIP:ipStr]];
        borderView.titleName = titleStr;
        NSString* timeStr = [commentObject valueForKey:CommentContentObject_time];
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate* newFormatDate  = [formater dateFromString:timeStr];
        [formater release];
        NSString* createDateStr = [MyTool humanizeDateFormatFromDate:newFormatDate];
        borderView.tipString = [NSString stringWithFormat:@"%@ 发表",createDateStr];
        borderView.bLastView = YES;
    }
    else
    {
        NSString* titleStr = [NSString stringWithFormat:@"%@[%@]的原帖:",nickStr,[self hideIPWithSourceIP:ipStr]];
        borderView.titleName = titleStr;
        borderView.tipString = [NSString stringWithFormat:@"%d",index+1];
        borderView.bLastView = NO;
    }
    [borderView reloadData];
    [self.contentView addSubview:borderView];
    [self.contentView sendSubviewToBack:borderView];
    [dest addObject:borderView];
    [borderView release];
}

-(NSString*)hideIPWithSourceIP:(NSString*)ipstr
{
    NSString* rtval = ipstr;
    if (ipstr) {
        NSArray* componet = [ipstr componentsSeparatedByString:@"."];
        if ([componet count]==4) {
            rtval = [NSString stringWithFormat:@"%@.%@.*.*",[componet objectAtIndex:0],[componet objectAtIndex:1]];
        }
    }
    return rtval;
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
    [self reloadDataWithUI];
}

-(void)reloadTimeString
{
    if (self.levelViews) {
        for (int i=[self.levelViews count]-1; i>=0; i--) {
            BorderView* borderView = [self.levelViews objectAtIndex:i];
            NewsObject* commentObject = [self.commentLevels objectAtIndex:i];
            if (borderView.bLastView) {
                NSString* timeStr = [commentObject valueForKey:CommentContentObject_time];
                NSDateFormatter* formater = [[NSDateFormatter alloc] init];
                formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate* newFormatDate  = [formater dateFromString:timeStr];
                [formater release];
                NSString* createDateStr = [MyTool humanizeDateFormatFromDate:newFormatDate];
                borderView.tipString = [NSString stringWithFormat:@"%@ 发表",createDateStr];
                [borderView reloadTimeString];
                break;
            }
        }
    }
}

-(void)BorderViewClicked:(BorderView*)sender
{
    if ([delegate respondsToSelector:@selector(expandClickedWithCell:)]) {
        [delegate expandClickedWithCell:self];
    }
}

-(void)myLayoutSubviews
{
    CGRect mainRect = self.bounds;
    int levelViewsCount = [self.levelViews count];
    if (levelViewsCount>0) {
        BorderView* borderView = [self.levelViews lastObject];
        borderView.frame = mainRect;
        int topMargin = borderView.retTopMarginForContainView;
        int leftRightMargin = CommentContentCell_Margin;
        levelViewsCount = levelViewsCount - 1;
        if (levelViewsCount<=CommentContentCell_MaxNumOfBorder) {
            topMargin += (levelViewsCount-1)*CommentContentCell_BorderSpacer;
            leftRightMargin += (levelViewsCount-1)*CommentContentCell_BorderSpacer;
        }
        else
        {
            topMargin += (CommentContentCell_MaxNumOfBorder-1)*CommentContentCell_BorderSpacer;
            leftRightMargin += (CommentContentCell_MaxNumOfBorder-1)*CommentContentCell_BorderSpacer;
        }
        
        int extraHeight = 0;
        for (int i=0; i<levelViewsCount; i++) {
            BorderView* oldView = [self.levelViews objectAtIndex:i];
            oldView.topExtraMargin = extraHeight;
            CGRect viewRect = CGRectMake(mainRect.origin.x+leftRightMargin, mainRect.origin.y+topMargin, mainRect.size.width - 2*leftRightMargin, mainRect.size.height - topMargin);
            viewRect.size = [oldView sizeThatFits:viewRect.size];
            oldView.frame = viewRect;
            extraHeight = viewRect.size.height;
            if (i>=(levelViewsCount-CommentContentCell_MaxNumOfBorder)) {
                topMargin -= CommentContentCell_BorderSpacer;
                leftRightMargin -= CommentContentCell_BorderSpacer;
            }
            if (i==levelViewsCount-1) {
                borderView.topExtraMargin = extraHeight;
            }
        }
        borderView.frame = mainRect;
        
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
    int totalHeight = 0;
    CGRect mainRect = CGRectMake(0, 0, 320, 100000);
    int levelViewsCount = [self.levelViews count];
    if (levelViewsCount>0) {
        BorderView* borderView = [self.levelViews lastObject];
        borderView.frame = mainRect;
        int topMargin = borderView.retTopMarginForContainView;
        int leftRightMargin = CommentContentCell_Margin;
        levelViewsCount = levelViewsCount - 1;
        if (levelViewsCount<=CommentContentCell_MaxNumOfBorder) {
            topMargin += (levelViewsCount-1)*CommentContentCell_BorderSpacer;
            leftRightMargin += (levelViewsCount-1)*CommentContentCell_BorderSpacer;
        }
        else
        {
            topMargin += (CommentContentCell_MaxNumOfBorder-1)*CommentContentCell_BorderSpacer;
            leftRightMargin += (CommentContentCell_MaxNumOfBorder-1)*CommentContentCell_BorderSpacer;
        }
        
        int extraHeight = 0;
        for (int i=0; i<levelViewsCount; i++) {
            BorderView* oldView = [self.levelViews objectAtIndex:i];
            oldView.topExtraMargin = extraHeight;
            CGRect viewRect = CGRectMake(mainRect.origin.x+leftRightMargin, mainRect.origin.y+topMargin, mainRect.size.width - 2*leftRightMargin, mainRect.size.height - topMargin);
            viewRect.size = [oldView sizeThatFits:viewRect.size];
            oldView.frame = viewRect;
            extraHeight = viewRect.size.height;
            if (i>=(levelViewsCount-CommentContentCell_MaxNumOfBorder)) {
                topMargin -= CommentContentCell_BorderSpacer;
                leftRightMargin -= CommentContentCell_BorderSpacer;
            }
            if (i==levelViewsCount-1) {
                borderView.topExtraMargin = extraHeight;
            }
        }
        CGSize borderSize = [borderView sizeThatFits:mainRect.size];
        totalHeight = borderSize.height;
    }
    

    
    CGSize totalSize = CGSizeZero;
    totalSize.width = mainRect.size.width;
    totalSize.height = totalHeight;
    return totalSize;
}

@end
