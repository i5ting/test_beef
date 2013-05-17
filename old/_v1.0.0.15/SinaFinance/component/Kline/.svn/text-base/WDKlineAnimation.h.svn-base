//
//  WDKlineAnimation.h
//  TestXML
//
//  Created by Sun Guanglei on 12-3-15.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
// #import "WDDataLabel.h"

@protocol WDKlineAnimationDelegate;

@interface WDKlineAnimation : UIView
{
    CGPoint dataOrigin;
    CGPoint hLineStartPt;
    CGPoint hLineEndPt;
    CGPoint vLineStartPt;
    CGPoint vLineEndPt;
    
    CGRect lineRect;
    CGRect logicLineRect;
    
    BOOL bDraw;
    
    UILabel *topDataLabel;
    // MA标签 由于每个标签的颜色不一样，分别创建比较好
    UILabel *MA5Label;
    UILabel *MA10Label;
    UILabel *MA30Label;
    
    NSUInteger maStart;
    
    NSArray *descData;
    NSArray *klineData;
}

@property (nonatomic, assign) CGPoint dataOrigin;
@property (nonatomic, assign, setter = setLineRect:) CGRect lineRect;
@property (nonatomic, retain, setter = setDescData:) NSArray *descData;
@property (nonatomic, retain) NSArray *klineData;
@property (nonatomic, assign) id<WDKlineAnimationDelegate, NSObject>delegate;
@property (nonatomic, retain, setter = setDataLabelFont:) UIFont *dataLabelFont;

- (void)setLineRect:(CGRect)theRect;
- (void)setDescData:(NSArray *)dataArray;
- (void)resize:(CGRect)theRect;
- (void)showData:(CGPoint)touchPt lastPrice:(BOOL)bShow;
- (void)setDataLabelFont:(UIFont *)aFont;

@end

@protocol WDKlineAnimationDelegate <NSObject>

@optional 

- (void)klineAnimationTouchBegin:(WDKlineAnimation *)klineAnimation;
- (void)klineAnimationTouchEnd:(WDKlineAnimation *)klineAnimation;
- (void)klineAnimationTouchedWithDateString:(NSString*)dateString KeyData:(NSArray*)keyData valueData:(NSArray*)valueData;
- (NSString*)stringForklineAnimationTouchedWithDateString:(NSString*)dateString KeyData:(NSArray*)keyData valueData:(NSArray*)valueData;

@end
