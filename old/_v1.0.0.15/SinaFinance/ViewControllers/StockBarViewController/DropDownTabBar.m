//
//  DropDownTabBar.m
//  SinaFinance
//
//  Created by shieh exbice on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DropDownTabBar.h"
#import <QuartzCore/QuartzCore.h>



@implementation DropDownTab
@synthesize hasArrow;
@synthesize data;

- (id)init
{
    if((self = [super init])){
        hasArrow = YES;
        arrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow.png"]] autorelease];
        arrow.frame = CGRectMake(0, 0, 7, 4);
        arrow.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:arrow];
        arrow.hidden = YES;
    }
    return self;
}

-(void)dealloc
{
    [data release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected
{
    if (hasArrow) {
        arrow.hidden = !selected;
    }
    else
    {
        arrow.hidden = YES;
    }
    [super setSelected:selected];
}

-(void)setHasArrow:(BOOL)ahasArrow
{
    hasArrow = ahasArrow;
    if (hasArrow&&self.selected) {
        arrow.hidden = NO;
    }
    else
    {
        arrow.hidden = YES;
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect arrowRect =arrow.frame;
    arrowRect.origin.x = frame.size.width - arrowRect.size.width - 5;
    arrowRect.origin.y = frame.size.height/2 - arrowRect.size.height/2;
    arrow.frame = arrowRect;
}

@end

@interface DropDownTabBar ()
@property(nonatomic,retain)NSMutableArray* buttons;
-(void)handleChangeGroup:(DropDownTab*)sender;
@end

@implementation DropDownTabBar
{
    NSMutableArray* buttons;
}
@synthesize curIndex;
@synthesize buttons;
@synthesize padding,spacer;
@synthesize hasDropDown;
@synthesize delegate;
@synthesize defautBtnWidth;
@synthesize hasLoaded;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        curIndex = 0;
        self.backgroundColor = [UIColor clearColor];
        padding = 20;
        spacer = 6;
        defautBtnWidth = 50;
    }
    return self;
}

-(void)dealloc
{
    [buttons release];
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

-(void)setFrame:(CGRect)frame
{
    CGRect sourceRect = self.frame;
    [super setFrame:frame];
    
    if (!CGRectEqualToRect(frame, CGRectZero)&&!CGRectEqualToRect(frame, sourceRect))
    {
        [self reloadFromFrameChanged];
    }
}

-(void)reloadFromFrameChanged
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.01];
}

-(void)reloadData
{
    [self reloadDataWithIndex:[NSNumber numberWithInt:curIndex]];
}

-(void)reloadDataWithIndex:(NSNumber*)indexNumber
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
    CGRect bounds = self.bounds;
    if (!buttons) {
        buttons = [[NSMutableArray alloc] init];
    }
    else
    {
        for (DropDownTab* oneBtn in buttons) {
            [oneBtn removeFromSuperview];
        }
        [buttons removeAllObjects];
    }
    
    NSArray* tabArray = nil;
    if ([delegate respondsToSelector:@selector(tabsWithTabBar:)]) {
        tabArray = [delegate tabsWithTabBar:self];
    }
    
    
    if (tabArray&&[tabArray count]) {
        int count = [tabArray count];
        NSInteger totoalSpacer = count<=1?0:((count-1)*spacer);
        NSInteger btnWidth = (bounds.size.width - 2*padding - totoalSpacer) / count;
        NSInteger btnY = 0;
        NSInteger btnHeight = bounds.size.height;
        if (curIndex>count-1) {
            curIndex = count-1;
        }
        for(int i = 0; i < count; i++){
            DropDownTab *button = [tabArray objectAtIndex:i];
            if (hasDropDown) {
                button.hasArrow = YES;
            }
            else
            {
                button.hasArrow = NO;
            }
            button.frame = CGRectMake(padding + btnWidth * i + spacer*i, btnY, btnWidth, btnHeight);
            button.tag = 1000 + i;
            [button addTarget:self action:@selector(handleChangeGroup:) forControlEvents:UIControlEventTouchUpInside];
            //        [self.view addSubview:button];
            [self addSubview:button];
            
            if(i == curIndex){
                button.selected = YES;
            }
            
            [buttons addObject:button];
        }
    }
    if (indexNumber) {
        self.curIndex = [indexNumber intValue];
    }
    else {
        self.curIndex = 0;
    }
    hasLoaded = YES;
}

-(void)setSelected:(NSInteger)index
{
    self.curIndex = index;
}

-(NSString*)titleForIndex:(NSInteger)index
{
    NSString* rtval = nil;
    DropDownTab * oneTab = nil;
    if (index<[buttons count]) {
        oneTab = [buttons objectAtIndex:index];
    }
    rtval = [oneTab titleForState:UIControlStateNormal];
    return rtval;
}

-(void)didSelectBtn
{
    if ([self.buttons count]>0) {
        if (curIndex>=[self.buttons count]) {
            curIndex = [self.buttons count] - 1;
        }
        [self handleChangeGroup:[self.buttons objectAtIndex:curIndex] byBtn:NO];
    }
}

-(void)setHasDropDown:(BOOL)ahasDropDown
{
    hasDropDown = ahasDropDown;
    for (DropDownTab* oneBtn in buttons) {
        oneBtn.hasArrow = ahasDropDown;
    }
}

-(void)setCurIndex:(NSInteger)acurIndex
{
    curIndex = acurIndex;
    if (self.buttons) {
        if ([self.buttons count]>0) {
            if (curIndex>=[self.buttons count]) {
                curIndex = [self.buttons count] - 1;
            }
            [self handleChangeGroup:[self.buttons objectAtIndex:curIndex] byBtn:NO];
        }
    }
}

-(void)handleChangeGroup:(DropDownTab*)sender
{
    [self handleChangeGroup:sender byBtn:YES];
}

-(void)handleChangeGroup:(DropDownTab*)sender byBtn:(BOOL)byBtn
{
    DropDownTab *selectedBtn = (DropDownTab*)sender;
    NSInteger index = selectedBtn.tag - 1000;
    
    for(UIButton *button in buttons){
        if(button.tag == selectedBtn.tag){
            button.selected = YES;
        }
        else{
            button.selected = NO;
        }
    }
    
    if ([delegate respondsToSelector:@selector(tabBar:clickedWithIndex:byBtn:)]) {
        [delegate tabBar:self clickedWithIndex:index byBtn:byBtn];
    }
}

@end
