//
//  LoadingErrorView.m
//  SinaNBA
//
//  Created by Du Dan on 10/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoadingErrorView.h"
#import "ShareData.h"
#import "gDefines.h"

@interface LoadingErrorView()
@property(nonatomic,retain)NSValue* sourceRectValue;
@property(nonatomic,retain)NSValue* destRectValue;
@property (nonatomic, retain) UILabel *textLabel;
@end

@implementation LoadingErrorView
{
    NSValue* sourceRectValue;
    NSValue* destRectValue;
}

@synthesize textLabel;
@synthesize sourceRectValue,destRectValue;
@synthesize customTipString;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.frame = frame;//CGRectMake(290, 190, 422, 213);
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        
//        UIImageView *bg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingerror_alert_bg.png"]] autorelease];
//        bg.frame = CGRectMake(0, 0, 422, 213);
//        [self addSubview:bg];
            
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        textLabel.backgroundColor = [UIColor clearColor];
//        NSLog(@"[ShareData sharedManager].isNetworkAvailable: %d",[ShareData sharedManager].isNetworkAvailable);
        if([ShareData sharedManager].isNetworkAvailable == NO){
            textLabel.text = @"没有连接网络，请检查网络连接后再试。";
        }
        else{
            textLabel.text = @"页面加载错误，请稍候再试。";
        }
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.font = [UIFont fontWithName:APP_FONT_NAME size:16];
        [self addSubview:textLabel];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self 
               selector:@selector(ReachabilityChanged:) 
                   name:ReachabilityChangedNotification 
                 object:nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [textLabel release];
    [customTipString release];
    [super dealloc];
}

-(void)ReachabilityChanged:(NSNotification*)notify
{
    [self refreshTipString];
}


-(void)setFrame:(CGRect)frame
{
    CGRect sourceRect = self.frame;
    [super setFrame:frame];
    
    NSValue* sourceValue = [NSValue valueWithCGRect:sourceRect];
    NSValue* destValue = [NSValue valueWithCGRect:frame];
    if (!sourceRectValue) {
        self.sourceRectValue = sourceValue;
    }
    self.destRectValue = destValue;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(frameChanged) object:nil];
    [self performSelector:@selector(frameChanged) withObject:nil afterDelay:0.001];
}

-(void)frameChanged
{
    if (self.destRectValue&&self.sourceRectValue) {
        CGRect frame = [self.destRectValue CGRectValue];
        CGRect sourceRect = [self.sourceRectValue CGRectValue];
        if (!CGRectEqualToRect(frame, CGRectZero)&&!CGRectEqualToRect(frame, sourceRect))
        {
            [self realFrameChanged:frame];
        }
    }
    self.sourceRectValue = nil;
    self.destRectValue = nil;
}

-(void)realFrameChanged:(CGRect)frame
{
    [textLabel sizeToFit];
    CGRect textRect = textLabel.frame;
    textRect.origin.x = frame.size.width/2 - textRect.size.width/2;
    textRect.origin.y = frame.size.height/2 - textRect.size.height/2;
    textLabel.frame = textRect;
}

-(void)setCustomTipString:(NSString *)acustomTipString
{
    if (customTipString!=acustomTipString) {
        NSString* oldString = customTipString;
        customTipString = [acustomTipString retain];
        [oldString release];
    }
    [self refreshTipString];
}

-(void)refreshTipString
{
    if (customTipString) {
        self.textLabel.text = customTipString;
    }
    else {
        if([ShareData sharedManager].isNetworkAvailable == NO){
            textLabel.text = @"没有连接网络，请检查网络连接后再试。";
        }
        else{
            textLabel.text = @"页面加载错误，请稍候再试。";
        }
    }
    [self reloadData];
}

-(void)reloadData
{
    [self realFrameChanged:self.bounds];
}

@end
