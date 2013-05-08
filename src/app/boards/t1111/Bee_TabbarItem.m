//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//	Powered by BeeFramework
//
//
//  no320_bee_tab_board.h
//  git;
//
//  Created by sang on 5/8/13.
//    Copyright (c) 2013 alfred sang. All rights reserved.
//

#import "Bee_TabbarItem.h"
 

@implementation Bee_TabbarItem

DEF_SIGNAL(TABBAR_ITEM_CLICK)



#define CUSTOM_TABBAR_ORIGIN_INSETS UIEdgeInsetsMake(1.0,3.0,3.0,3.0)

@synthesize viewframe,bundleName,configArray;


@synthesize indicator0;
@synthesize indicator1;
@synthesize indicator2;
@synthesize indicator3;
@synthesize updateLabel0;
@synthesize updateLabel1;
@synthesize updateLabel2;
@synthesize updateLabel3;

@synthesize delegate;


@synthesize highlightView;



- (id)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}


-(void)showTab
{
    __count = [self.configArray count];
    UIEdgeInsets originInsets = CUSTOM_TABBAR_ORIGIN_INSETS;
    
    if (__count==0) {
        return;
    }
    
    highlightView = [[UIImageView alloc] init];
    //callback
    //    highlightView.frame = CGRectMake(0, 0, 320/__count, 44);
    if ([delegate respondsToSelector:@selector(set_init_heigh_light_view_frame)]) {
        highlightView.frame = [delegate set_init_heigh_light_view_frame];
    }
    
    [highlightView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",bundleName,@"tab_light.png"]]];
    
    [self addSubview:highlightView];
    
    int i = 1;
    for (NSDictionary *d in self.configArray) {
        NSString *defaultImg = [NSString stringWithFormat:@"%@/%@",self.bundleName,(NSString *)[d objectForKey:@"default"]];
        NSString *selectedImg = [NSString stringWithFormat:@"%@/%@",self.bundleName,(NSString *)[d objectForKey:@"selected"]];
        BeeUIButton  *_newsBtn = [BeeUIButton buttonWithType:UIButtonTypeCustom];
        _newsBtn.tag = 10357+i;
        //callback
        //        _newsBtn.frame = CGRectMake(_width*(i - 1)-4, 0, _width+6, 46);
        if ([delegate respondsToSelector:@selector(set_init_image_button_view_frame_with_index:)]) {
            _newsBtn.frame = [delegate set_init_image_button_view_frame_with_index:i];
        }
        
        _newsBtn.stateNormal.image = [UIImage imageNamed:defaultImg];
        _newsBtn.stateSelected.image = [UIImage imageNamed:selectedImg];
        [_newsBtn setOpaque:NO];
        _newsBtn.contentEdgeInsets = originInsets;
        i++;
        [_newsBtn addSignal:Bee_TabbarItem.TABBAR_ITEM_CLICK forControlEvents:UIControlEventTouchUpInside object:[NSNumber numberWithInt:i]];
        
        [self addSubview:_newsBtn];
        
        if (delegate && [delegate respondsToSelector:@selector(draw_with_dict:in_container:)]) {
            [delegate draw_with_dict:d in_container:self];
        }
    }
}

- (void)selectTabAtCompletion:(int)index{
    for (int i = 0; i < __count; i++) {
        UIButton *_cur_btn = (UIButton *)[self viewWithTag:10358+i];
        if (_cur_btn == nil) {
            return;
        }
        
        if (i == index) {
            _cur_btn.selected = YES;
        }else{
            _cur_btn.selected = NO;
        }
    }
}

- (void)selectTabAtIndex:(int)index
{
    for (int i; i < __count; i++) {
        UIButton *_cur_btn = (UIButton *)[self viewWithTag:10358+i];
        if (_cur_btn == nil) {
            return;
        }
        
        if (i != index) {
            _cur_btn.selected = NO;
        }else{
            
        }
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:0.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        if ([delegate respondsToSelector:@selector(set_after_animate_light_view_frame_with_prev_frame:and_index:)]) {
            self.highlightView.frame = [delegate set_after_animate_light_view_frame_with_prev_frame:self.highlightView.frame and_index:index];
        }
        
    }completion: ^(BOOL finished){
        [self selectTabAtCompletion:index];
    }];
    
    [UIView commitAnimations];
}

- (void)tapOnBtn:(UIButton *)sender {
    int i = sender.tag - 10358;
    if (delegate && [delegate respondsToSelector:@selector(customTabbar:didSelectTab:)]) {
        NSLog(@"【 tapOnNewsBtn 】 current tag :=%d",i);
        [delegate customTabbar:self didSelectTab:i];
    }
    self.indicator0.hidden = YES;
    self.updateLabel0.hidden = YES;
    
    if (delegate && [delegate respondsToSelector:@selector(tap_on_btn_call_back:)]) {
        [delegate tap_on_btn_call_back:i];
    }
}

- (void)dealloc {
    [highlightView release];
    [indicator0 release];
    [indicator1 release];
    [indicator2 release];
    [indicator3 release];
    [updateLabel0 release];
    [updateLabel1 release];
    [updateLabel2 release];
    [updateLabel3 release];
    [super dealloc];
}

#pragma mark - delay



@end