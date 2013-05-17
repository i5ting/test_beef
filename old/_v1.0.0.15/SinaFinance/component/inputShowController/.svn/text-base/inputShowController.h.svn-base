//
//  inputShowController.h
//  SinaNews
//
//  Created by shieh exbice on 11-12-11.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class inputShowController;

@protocol inputShowController_Delegate <NSObject>

-(void)controller:(inputShowController*)controller text:(NSString*)content;

@end

@interface inputShowController : UIViewController
{
    BOOL isShownNow;
    IBOutlet UIView* inputBKGView;
    IBOutlet UIImageView* inputBKGImageView;
    IBOutlet UITextView* inputTextView;
    IBOutlet UIButton* publishBtn;
    UIView* parentView;
    NSInteger inputViewHeight;
    NSInteger inputViewMaxHeight;
    BOOL bInited;
}
@property(nonatomic,assign,readonly)BOOL isStarted;
@property(nonatomic,assign)UIView* parentView;
@property(nonatomic,assign)id<inputShowController_Delegate> delegate;

-(IBAction)publishClicked:(id)sender;

-(void)startInput;
-(void)stopInput;


@end
