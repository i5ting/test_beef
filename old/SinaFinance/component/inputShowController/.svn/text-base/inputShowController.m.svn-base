//
//  inputShowController.m
//  SinaNews
//
//  Created by shieh exbice on 11-12-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "inputShowController.h"

@interface inputShowController()
@property(nonatomic,retain)UIView* inputBKGView;
@property(nonatomic,retain)UIView* inputBKGImageView;
@property(nonatomic,retain)UITextView* inputTextView;
@property(nonatomic,retain)UIButton* publishBtn;

@property(nonatomic,retain)NSString* lastString;

-(void)initNotify;
-(void)initUI;
-(void)notifyKeyboardWillShow:(NSNotification*)note;
-(void)notifyKeyboardWillHide:(NSNotification*)note;
-(void)startPublish:(NSString*)content;
-(void)resetTextView;
@end

@implementation inputShowController
@synthesize isStarted,lastString;
@synthesize parentView;
@synthesize inputBKGView,inputBKGImageView,inputTextView,publishBtn;
@synthesize delegate;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (!nibNameOrNil) {
            [[NSBundle mainBundle] loadNibNamed:@"inputShowController" owner:self options:nil];
        }
        [self initNotify];
        [self initUI];
        isShownNow = YES;
        inputViewMaxHeight = 65;
        inputTextView.delegate = self;
        inputTextView.scrollsToTop = NO;
        UIImage* bkgImage = inputBKGImageView.image;
        CGSize bkgImageSize = bkgImage.size;
        inputBKGImageView.image = [bkgImage stretchableImageWithLeftCapWidth:bkgImageSize.width/2 - 4 topCapHeight:bkgImageSize.height/2 - 4];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    UIView* thisView = [[UIView alloc] init];
    thisView.frame = CGRectMake(0, 0, 1, 1);
    self.view = thisView;
    [thisView release];
}

-(void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
    [inputTextView resignFirstResponder];
    [inputBKGView removeFromSuperview];
    
    [inputBKGView release];
    [inputBKGImageView release];
    [inputTextView release];
    [publishBtn release];
    
    [lastString release];

    [super dealloc];
}

-(void)setParentView:(UIView *)aParent
{
    parentView = aParent;
    UIView* thisView = self.view;
    [aParent addSubview:thisView];
    [aParent sendSubviewToBack:thisView];
}

-(void)initNotify
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(notifyKeyboardWillShow:)
			   name:UIKeyboardWillShowNotification 
			 object:nil];
	
	[nc addObserver:self selector:@selector(notifyKeyboardWillHide:) 
			   name:UIKeyboardWillHideNotification
			 object:nil];
}

-(void)initUI
{
    CGRect BKGRect = inputBKGView.frame;
    inputViewHeight = inputTextView.frame.size.height;
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    BKGRect = CGRectMake(0, mainBounds.size.height, mainBounds.size.width, BKGRect.size.height);
    inputBKGView.frame = BKGRect;
    [[UIApplication sharedApplication].keyWindow addSubview:inputBKGView];

}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    isShownNow = NO;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    if (!bInited) {
        bInited = YES;
        isShownNow = YES;
    }
}

-(void)publishClicked:(id)sender
{
    NSString* content = inputTextView.text;
    inputTextView.text = nil;
    self.lastString = nil;
    [self resetTextView];
    [inputTextView resignFirstResponder];
    
    
    if (content&&![content isEqualToString:@""]) {
        [self performSelector:@selector(startPublish:) withObject:content afterDelay:0.025];
    }
}

-(void)startPublish:(NSString*)content
{
    if ([delegate respondsToSelector:@selector(controller:text:)]) {
        [delegate controller:self text:content];
    }
}

#pragma mark -
#pragma mark keyboard methods

-(BOOL)isStarted
{
    return [inputTextView isFirstResponder];
}

-(void)startInput
{
    [inputTextView becomeFirstResponder];
}

-(void)stopInput
{
    self.lastString = inputTextView.text;
    [inputTextView resignFirstResponder];
    
}

#pragma mark -
#pragma mark keyboard

-(void)notifyKeyboardWillShow:(NSNotification*)note
{
    if (![inputTextView isFirstResponder]) {
        return;
    }
    NSDictionary* userInfo = [note userInfo];
    NSValue* frameBeginValue = [userInfo objectForKey:@"UIKeyboardFrameBeginUserInfoKey"];
    CGRect frameBeginRect = [frameBeginValue CGRectValue];
    NSValue* frameEndValue = [userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect frameEndRect = [frameEndValue CGRectValue];
    NSNumber* animationDurationNumber = [userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
    double animationDuration = [animationDurationNumber doubleValue];
    NSNumber* FrameChangedValue = [userInfo objectForKey:@"UIKeyboardFrameChangedByUserInteraction"];
    BOOL frameChanged = [FrameChangedValue boolValue];
    
    CGRect inputBKGRect = inputBKGView.frame;
    inputBKGRect.origin.y = frameBeginRect.origin.y - inputBKGRect.size.height;
    inputBKGView.frame = inputBKGRect;
    
	[UIView beginAnimations:@"222" context:NULL];
	[UIView setAnimationDuration:animationDuration]; 
    inputBKGRect.origin.y = frameEndRect.origin.y - inputBKGRect.size.height;
    inputBKGView.frame = inputBKGRect;
	[UIView commitAnimations]; 
}

-(void)notifyKeyboardWillHide:(NSNotification*)note
{
    if (![inputTextView isFirstResponder]) {
        return;
    }
    NSDictionary* userInfo = [note userInfo];
    NSValue* frameBeginValue = [userInfo objectForKey:@"UIKeyboardFrameBeginUserInfoKey"];
    CGRect frameBeginRect = [frameBeginValue CGRectValue];
    NSValue* frameEndValue = [userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect frameEndRect = [frameEndValue CGRectValue];
    NSNumber* animationDurationNumber = [userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
    double animationDuration = [animationDurationNumber doubleValue];
    NSNumber* FrameChangedValue = [userInfo objectForKey:@"UIKeyboardFrameChangedByUserInteraction"];
    BOOL frameChanged = [FrameChangedValue boolValue];
	
	CGRect inputBKGRect = inputBKGView.frame;
    inputBKGRect.origin.y = frameBeginRect.origin.y - inputBKGRect.size.height;
    inputBKGView.frame = inputBKGRect;
    
	[UIView beginAnimations:@"222" context:NULL];
	[UIView setAnimationDuration:animationDuration]; 
    inputBKGRect.origin.y = frameEndRect.origin.y;
    inputBKGView.frame = inputBKGRect;
	[UIView commitAnimations]; 
}

#pragma mark -
#pragma mark textview

- (void)textViewDidChange:(UITextView *)textView
{
	[self resetTextView];
	
}

-(void)resetTextView
{
	//size of content, so we can set the frame of self
	NSInteger newSizeH = inputTextView.contentSize.height;
    newSizeH = newSizeH>inputViewMaxHeight ? inputViewMaxHeight : newSizeH;
	//newSizeH = newSizeH%2==1 ? newSizeH+1 : newSizeH;
	if(newSizeH < inputViewHeight || (inputTextView.text == nil || [inputTextView.text isEqualToString:@""]) )
	{
		newSizeH = inputViewHeight;//not smalles than minHeight
	}
	int chatTextViewHeight = inputTextView.frame.size.height;
	if (chatTextViewHeight != newSizeH)
	{
		if (newSizeH <= inputViewMaxHeight)
		{
			// internalTextView
			CGRect internalTextViewFrame = inputTextView.frame;
			NSInteger oldTextViewHeight = internalTextViewFrame.size.height;
			internalTextViewFrame.size.height = internalTextViewFrame.size.height - (internalTextViewFrame.size.height - newSizeH);
			inputTextView.frame = internalTextViewFrame;
			
			// subView
			CGRect bottomView_frame = inputBKGView.frame;
			bottomView_frame.origin.y = bottomView_frame.origin.y + (oldTextViewHeight - newSizeH);
			bottomView_frame.size.height = bottomView_frame.size.height - (oldTextViewHeight - newSizeH);
			inputBKGView.frame = bottomView_frame;
			
			// reset image
			CGRect backgroundViewFrame = inputBKGImageView.frame;
			backgroundViewFrame.size.height = backgroundViewFrame.size.height - (oldTextViewHeight - newSizeH);
			inputBKGImageView.frame = backgroundViewFrame;
			
		}
		
        // if our new height is greater than the maxHeight
        // sets not set the height or move things
        // around and enable scrolling
		if (newSizeH >= inputViewMaxHeight)
		{
			if(!inputTextView.scrollEnabled)
			{
				inputTextView.scrollEnabled = YES;
				[inputTextView flashScrollIndicators];
			}
		} 
		else 
		{
			inputTextView.scrollEnabled = NO;
		}
		
	}
}

@end
