//
//  UITabItemBoardBase.m
//  sinafinance
//
//  Created by sang on 5/13/13.
//
//

#import "UITabItemViewBase.h"

@implementation UITabItemViewBase

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)init
{
    CGRect frame = __TAB_CONTROLLER_VIEW_FRAME;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delaysContentTouches = NO;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
//        self.alpha = 0.1;
        self.backgroundImage = __BASE_BOARD_IMAGE( @"main_board_bg" );
        [self setting];
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
- (void)setting
{

}

@end
