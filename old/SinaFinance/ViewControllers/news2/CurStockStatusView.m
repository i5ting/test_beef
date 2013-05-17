//
//  CurStockStatusView.m
//  SinaFinance
//
//  Created by sang on 10/28/12.
//
//
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CAAnimation.h>
#import "CurStockStatusView.h"
@interface CurStockStatusView(private)
 
-(void)setInfo:(NSDictionary *)s andCode:(NSString *)symbolcode;
@end


@implementation CurStockStatusView

@synthesize l1,l2,l3,l4;

#define APP_FONT_NAME @"Arial"//@"Helvetica"


#define APP_FONT_SIZE 13

#define CUR_STOCK_STATUS_LABEL_HIGHT 0
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        bg.image = [UIImage imageNamed:@"stockstatus_bg.png"];
        [self addSubview:bg];
        [bg release];
        
        l1 = [[UILabel alloc] initWithFrame:CGRectMake(30, CUR_STOCK_STATUS_LABEL_HIGHT, 40, 20)];
        l2 = [[UILabel alloc] initWithFrame:CGRectMake(89, CUR_STOCK_STATUS_LABEL_HIGHT, 60, 20)];
        l3 = [[UILabel alloc] initWithFrame:CGRectMake(170, CUR_STOCK_STATUS_LABEL_HIGHT, 60, 20)];
        l4 = [[UILabel alloc] initWithFrame:CGRectMake(240, CUR_STOCK_STATUS_LABEL_HIGHT, 60, 20)];
        
        l1.font = [UIFont fontWithName:APP_FONT_NAME size:APP_FONT_SIZE];
        l2.font = [UIFont fontWithName:APP_FONT_NAME size:APP_FONT_SIZE];
        l3.font = [UIFont fontWithName:APP_FONT_NAME size:APP_FONT_SIZE];
        l4.font = [UIFont fontWithName:APP_FONT_NAME size:APP_FONT_SIZE];
            
        l1.backgroundColor = [UIColor clearColor];
        l2.backgroundColor = [UIColor clearColor];
        l3.backgroundColor = [UIColor clearColor];
        l4.backgroundColor = [UIColor clearColor];
        
        [self addSubview:l1];
        [self addSubview:l2];
        [self addSubview:l3];
        [self addSubview:l4];
         
         
        l1.textColor = [UIColor blueColor];
        
//        [_timer invalidate];
//        _timer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(playWithTimer:) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//        
        
        _curIndex = 0;
        
        
    }
    return self;
}

#pragma mark - private methods

- (void)doPrivateCATransition{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
     animation.type = @"cube";//—
    [self.layer addAnimation:animation forKey:@"animation"];
}

//白天       上证，深成，恒生
-(void)getDayInfo:(NSArray *)re{
    int index = _curIndex%3;
    
    for (NSDictionary *s in re ) {
        switch (index) {
            case 1:
                [self setInfo:s andCode:@"sz399001"];
                break;
            case 2:
                [self setInfo:s andCode:@"HSI"];
                break;
            case 0:
                [self setInfo:s andCode:@"sh000001"];
                break;
            default:
                break;
        }
    }
}

//晚上    道指.dji，纳指.ixic，标普.inx
-(void)getNightInfo:(NSArray *)re{
    int index = _curIndex%3;
    
    for (NSDictionary *s in re ) {
        switch (index) {
            case 1:
                [self setInfo:s andCode:@".dji"];
                break;
            case 2:
                [self setInfo:s andCode:@".ixic"];
                break;
            case 0:
               [self setInfo:s andCode:@".inx"];
                break;
            default:
                break;
        }
    }
}

/**
 * 设置具体显示内容
 * 
 */
-(void)setInfo:(NSDictionary *)s andCode:(NSString *)symbolcode{
    NSString *retpriceString = [NSString stringWithFormat:@"%.02f",[[s objectForKey:@"price"] floatValue]];
    NSString *retdiffString = [NSString stringWithFormat:@"%.02f",[[s objectForKey:@"diff"] floatValue]];
    NSString *str = [NSString stringWithFormat:@"%@",[s objectForKey:@"symbol"]];

    if ([str isEqualToString:symbolcode]) {
        l1.text = [s objectForKey:@"cn_name"];
        l2.text = retpriceString;
        l3.text = retdiffString;
        l4.text = [s objectForKey:@"chg"];
        
        if ([[s objectForKey:@"diff"] floatValue]<0) {
            //减号
            l2.textColor = COLOR_WITH_RGB(0,153,68);
            l3.textColor = COLOR_WITH_RGB(0,153,68);
            l4.textColor = COLOR_WITH_RGB(0,153,68);
        }else{
            //加号
            l3.text = [NSString stringWithFormat:@"+%@",retdiffString];
            l4.text = [NSString stringWithFormat:@"+%@",[s objectForKey:@"chg"]];
            
            l2.textColor = COLOR_WITH_RGB(194,8,8);
            l3.textColor = COLOR_WITH_RGB(194,8,8);
            l4.textColor = COLOR_WITH_RGB(194,8,8);
        }
    }
}

#pragma mark - public methods 

-(void)updateInfo:(NSArray *)re{
    [self doPrivateCATransition];
    _curIndex ++;
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *_now=[NSDate date];
    NSCalendar *_calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *_comps = [_calendar components:unitFlags fromDate:_now];
    int hour = [_comps hour];
    
    //如果是晚上，显示道指和纳指
    if (hour >=21 || hour <7) {
        [self getNightInfo:re];
    }else{
        //如果是白天，显示沪指和深成
        [self getDayInfo:re];
    }
    
    self.hidden = NO;
    
    [_calendar release];
}

@end
