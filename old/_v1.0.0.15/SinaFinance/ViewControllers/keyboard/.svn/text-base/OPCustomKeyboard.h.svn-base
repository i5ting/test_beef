//
//  OPCustomKeyboard.h
//  SinaFinance
//
//  Created by sang alfred on 9/20/12.
//
//

#import <UIKit/UIKit.h>

#define CUSTOM_KEY_BOARD_EVENT_CHANGE_NOTI @"KEY_BOARD_EVENT_CHANGE_NOTI"

typedef enum KeyBoardMap
{
    //数字键盘
	kb_1 = 1,
    kb_2 = 2,
    kb_3 = 3,
    kb_4 = 4,
    kb_5 = 5,
    kb_6 = 6,
    kb_7 = 7,
    kb_8 = 8,
    kb_9 = 9,
    kb_0 = 0,
    
    kb_600 = 600,
    kb_601 = 601,
    kb_000 = 599,
    kb_002 = 602,
    kb_00 = 603,
    
    kb_del = 100,
    kb_hide = 101,
    kb_clear = 102,
    
    kb_abc = 103,
    kb_123 = 104,
    kb_search = 105,
    
    //字母键盘
    
    kb_us_shift = 106,
    kb_us_del = 107,
    
    
	kb_a = 65,
    kb_b = 66,
    kb_c = 67,
    kb_d = 68,
    kb_e = 69,
    kb_f = 70,
    kb_g = 71,
    kb_h = 72,
    kb_i = 73,
    kb_j = 74,
    kb_k = 75,
    kb_l = 76,
    kb_m = 77,
    kb_n = 78,
    kb_o = 79,
    kb_p = 80,
    kb_q = 81,
    kb_r = 82,
    kb_s = 83,
    kb_t = 84,
    kb_u = 85,
    kb_v = 86,
    kb_w = 87,
    kb_x = 88,
    kb_y = 89,
    kb_z = 90,
    
    kb_system = 10
//    kb_A = 91,
//    kb_B = 92,
//    kb_C = 93,
//    kb_D = 94,
//    kb_E = 95,
//    kb_F = 96,
//    kb_G = 97,
//    kb_H = 98,
//    kb_I = 99,
//    kb_J = 101,
//    kb_K = 102,
//    kb_L = 103,
//    kb_M = 104,
//    kb_N = 105,
//    kb_O = 106,
//    kb_P = 107,
//    kb_Q = 108,
//    kb_R = 109,
//    kb_S = 110,
//    kb_T = 111,
//    kb_U = 112,
//    kb_V = 113,
//    kb_W = 114,
//    kb_X = 115,
//    kb_Y = 116,
//    kb_Z = 117,
    
    
}KeyBoardMap;

@protocol OPCustomKeyboardDelegate <NSObject>
@required
//-(void)doSearch;
-(void)doSearch:(NSString *)str;

@end

@interface OPCustomKeyboard : UIViewController{
    id _delegate;
    BOOL _isUsKeyboardFlag;
    BOOL _isShiftPressedFlag;
    UIView *_us_keyboard_view;
}
@property(nonatomic,assign,readonly) id _delegate;
@property(nonatomic,assign,readonly) id _textfiledelegate;

@property(nonatomic,retain,readonly) IBOutlet UIButton *delBtn;
-(id)initWithTextField:(UITextField *)textField andIDelegate:(id)myDelegate;

-(IBAction)keyPressed:(UIButton *)keyBtn;


@end
