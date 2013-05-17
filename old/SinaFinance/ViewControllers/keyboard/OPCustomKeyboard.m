//
//  OPCustomKeyboard.m
//  SinaFinance
//
//  Created by sang alfred on 9/20/12.
//
//

#import "OPCustomKeyboard.h"

@implementation OPCustomKeyboard
@synthesize _delegate;
@synthesize _textfiledelegate;
@synthesize delBtn;

-(id)initWithTextField:(UITextField *)textField andIDelegate:(id)myDelegate{
    if (self = [super init]) {
        _delegate = myDelegate;
        _textfiledelegate = textField;
        _isUsKeyboardFlag = NO;
        _isShiftPressedFlag = NO;
        UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(HandleLongPress:)];
        
        gr.minimumPressDuration = 0.8;
        
        [delBtn addGestureRecognizer:gr];
        
//        [gr release];
        
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)HandleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [(UITextField *)_textfiledelegate  setText:@""];
        NSLog(@"长按事件");
    }
}
#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _us_keyboard_view = [[[NSBundle mainBundle] loadNibNamed:@"OPCustomKeyboard" owner:self options:nil] objectAtIndex:1];
    
    _us_keyboard_view.frame = self.view.frame;
    _us_keyboard_view.hidden = YES;
    [self.view addSubview:_us_keyboard_view];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)keyPressed:(UIButton *)keyBtn{
    NSString *oldStr = [(UITextField *)_textfiledelegate text];
    
//    if ([oldStr length]>10) {
//        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"消息提示" message:@"股票代码请不要超过10个字符" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease];
//        [alert show];
//    }
    
    NSString *nextstr = [NSString stringWithFormat:@"%@%d",oldStr,keyBtn.tag];
   
    if (_isUsKeyboardFlag) {
        //字母键盘
        CGRect f = keyBtn.frame;
        
       
        
        switch (keyBtn.tag) {
            case kb_system:
                [self.view removeFromSuperview];
                break;
            case kb_us_del:
                //            NSString *s = [oldStr substringWithRange:NSMakeRange(0,[oldStr count]-1)];
                [(UITextField *)_textfiledelegate  setText:[oldStr length]>0?[oldStr substringWithRange:NSMakeRange(0,[oldStr length]-1)]:@""];
                break;
            case kb_123:
                _isUsKeyboardFlag = NO;
                _us_keyboard_view.hidden = YES;
                
            default:
                break;
        }
     
        
        if (_isShiftPressedFlag) {
            
            //大写
            switch (keyBtn.tag) {
                case kb_us_shift:
                    _isShiftPressedFlag = NO;
                    keyBtn.selected = NO;
                    break;
                case kb_a:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"A"]];
                    break;
                case kb_b:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"B"]];
                    break;
                case kb_c:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"C"]];
                    break;
                case kb_d:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"D"]];
                    break;
                case kb_e:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"E"]];
                    break;
                case kb_f:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"F"]];
                    break;
                case kb_g:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"G"]];
                    break;
                case kb_h:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"H"]];
                    break;
                case kb_i:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"I"]];
                    break;
                case kb_j:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"J"]];
                    break;
                case kb_k:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"K"]];
                    break;
                case kb_l:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"L"]];
                    break;
                case kb_m:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"M"]];
                    break;
                case kb_n:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"N"]];
                    break;
                case kb_clear:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"O"]];
                    break;
                case kb_p:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"P"]];
                    break;
                case kb_q:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"Q"]];
                    break;
                case kb_r:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"R"]];
                    break;
                case kb_s:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"S"]];
                    break;
                case kb_t:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"T"]];
                    break;
                case kb_u:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"U"]];
                    break;
                case kb_v:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"V"]];
                    break;
                case kb_w:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"W"]];
                    break;
                case kb_x:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"X"]];
                    break;
                case kb_y:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"Y"]];
                    break;
                case kb_z:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"Z"]];
                    break;
                case kb_search:
                    [(UITextField *)_textfiledelegate  resignFirstResponder];
                    if ([_delegate respondsToSelector:@selector(doSearch:)]) {
                        if ([oldStr length]>=1) {
                            [_delegate doSearch:[(UITextField *)_textfiledelegate text]];
                        }else{
                            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"消息提示" message:@"未输入股票代码，请确认！" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease];
                            [alert show];
                        }
                    }
                    break;
                default:
                    break;
            }
        }else{
            //小写字母
            switch (keyBtn.tag) {
                case kb_us_shift:
                    _isShiftPressedFlag = YES;
                    keyBtn.selected = YES;
                    break;
                case kb_a:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"a"]];
                    break;
                case kb_b:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"b"]];
                    break;
                case kb_c:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"c"]];
                    break;
                case kb_d:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"d"]];
                    break;
                case kb_e:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"e"]];
                    break;
                case kb_f:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"f"]];
                    break;
                case kb_g:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"g"]];
                    break;
                case kb_h:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"h"]];
                    break;
                case kb_i:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"i"]];
                    break;
                case kb_j:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"j"]];
                    break;
                case kb_k:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"k"]];
                    break;
                case kb_l:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"l"]];
                    break;
                case kb_m:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"m"]];
                    break;
                case kb_n:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"n"]];
                    break;
                case kb_o:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"o"]];
                    break;
                case kb_p:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"p"]];
                    break;
                case kb_q:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"q"]];
                    break;
                case kb_r:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"r"]];
                    break;
                case kb_s:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"s"]];
                    break;
                case kb_t:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"t"]];
                    break;
                case kb_u:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"u"]];
                    break;
                case kb_v:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"v"]];
                    break;
                case kb_w:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"w"]];
                    break;
                case kb_x:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"x"]];
                    break;
                case kb_y:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"y"]];
                    break;
                case kb_z:
                    [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"z"]];
                    break;
                case kb_search:
                    [(UITextField *)_textfiledelegate  resignFirstResponder];
                    if ([_delegate respondsToSelector:@selector(doSearch:)]) {
                        if ([oldStr length]>=1) {
                            [_delegate doSearch:[(UITextField *)_textfiledelegate text]];
                        }else{
                            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"消息提示" message:@"未输入股票代码，请确认！" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease];
                            [alert show];
                        }
                    }
                    break;
                default:
                    break;
            }
        }
        
        
    }else{
        switch (keyBtn.tag) {
            case kb_0:
                
            case kb_1:
                ;
            case kb_2:
                ;
            case kb_3:
                ;
            case kb_4:
                ;
            case kb_5:
                ;
            case kb_6:
                ;
            case kb_7:
                ;
            case kb_8:
                ;
            case kb_9:
                [(UITextField *)_textfiledelegate  setText:nextstr];
                break;
            case kb_del:
                //            NSString *s = [oldStr substringWithRange:NSMakeRange(0,[oldStr count]-1)];
                [(UITextField *)_textfiledelegate  setText:[oldStr length]>0?[oldStr substringWithRange:NSMakeRange(0,[oldStr length]-1)]:@""];
                break;
            case kb_clear:
                [(UITextField *)_textfiledelegate  setText:@""];
                break;
                
            case kb_hide:
                [(UITextField *)_textfiledelegate resignFirstResponder];
                break;
            case kb_600:
                [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"600"]];
                break;
                
                
            case kb_601:
                [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"601"]];
                break;
                
                
            case kb_000:
                [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"000"]];
                break;
                
                
            case kb_00:
                [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"00"]];
                break;
                
                
            case kb_002:
                [(UITextField *)_textfiledelegate  setText:[NSString stringWithFormat:@"%@%@",oldStr,@"002"]];
                break;
                
            case kb_search:
                [(UITextField *)_textfiledelegate  resignFirstResponder];
                if ([_delegate respondsToSelector:@selector(doSearch:)]) {
                    if ([oldStr length]>=1) {
                        [_delegate doSearch:[(UITextField *)_textfiledelegate text]];
                    }else{
                        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"消息提示" message:@"未输入股票代码，请确认！" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] autorelease];
                        [alert show];
                    }
                }
                break;
            case kb_abc:
                _isUsKeyboardFlag = YES;
                _us_keyboard_view.hidden = NO;
                //                [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
                break;
            case kb_system:
                [self.view removeFromSuperview];
//                [(UITextField *)_textfiledelegate setHidden:YES];
//                 [(UITextField *)_textfiledelegate  becomeFirstResponder];
//                ((UITextField *)_textfiledelegate).keyboardType = UIKeyboardTypeDefault;
                break;
                
                
            default:
                break;
        }
        
      
        
    }
    NSString *curStr = [(UITextField *)_textfiledelegate text];
    
    if ([oldStr length]!=[curStr length]) {
        [self postNoti];
    }
    
}


-(void)postNoti{
    //ios6+ 自定义键盘不会出发change事件
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CUSTOM_KEY_BOARD_EVENT_CHANGE_NOTI object:(UITextField *)_textfiledelegate];
    }
}
@end
