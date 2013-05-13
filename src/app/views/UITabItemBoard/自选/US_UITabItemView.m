//
//  HS.m
//  sinafinance
//
//  Created by sang on 5/13/13.
//
//
 
#import "US_UITabItemView.h"

@implementation USUITabItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
       
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
 */- (void)setting
{
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *l = [UILabel new];
    l.frame = CGRectMake(10, 10, 300, 40);
    l.text = @"ddd";
    [self addSubview:l];
    
    self.contentSize = CGSizeMake(320, 400*3);
}


@end
