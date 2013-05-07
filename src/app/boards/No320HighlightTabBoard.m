//
//  No320HighlightTabBoard.m
//  sinafinance
//
//  Created by sang alfred on 5/8/13.
//
//

#import "No320HighlightTabBoard.h"

@interface No320HighlightTabBoard ()

@end

@implementation No320HighlightTabBoard


#pragma mark -
- (void)tap_on_btn_call_back:(int)index;
{
    [self log:[NSString stringWithFormat:@"tap_on_btn_call_back:%d",index]];
}

- (void)draw_with_dict:(NSDictionary *)d in_container:(UIView *)view
{
    [self log:@"draw_with_dict in_container"];
}


-(void)log:(NSString *)str{
    NSLog(@"%@:%@",@"No320HeighlightTabViewController",str);
}


#pragma mark - required
- (CGRect)set_init_heigh_light_view_frame
{
    int _count = [self.__controllerArray count];
    return CGRectMake(0, 0, 320/_count, 44);
}

- (CGRect)set_after_animate_light_view_frame_with_prev_frame:(CGRect)prev_frame and_index:(int)index
{
    CGRect f = prev_frame;
    f.origin.x = index * prev_frame.size.width-1;
    return f;
}

- (CGRect)set_init_image_button_view_frame_with_index:(int)i
{
    int _width = 320/[self.__controllerArray count];
    return CGRectMake(_width*(i - 1)-4, 0, _width+6, 46);
}



@end
