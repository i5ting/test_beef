//
//  ForeignCalculatorView.h
//  SinaFinance
//
//  Created by shieh exbice on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForeignCalculatorView : UIView<UITextFieldDelegate>

@property(nonatomic,retain)IBOutlet UIView* totalView;
@property(nonatomic,retain)IBOutlet UITextField* input1;
@property(nonatomic,retain)IBOutlet UITextField* input2;
@property(nonatomic,retain)IBOutlet UIImageView* inputback1;
@property(nonatomic,retain)IBOutlet UIImageView* inputback2;
@property(nonatomic,retain)IBOutlet UIImageView* coinComboBack1;
@property(nonatomic,retain)IBOutlet UIImageView* coinComboBack2;
@property(nonatomic,retain)IBOutlet UILabel* coinCombo1;
@property(nonatomic,retain)IBOutlet UILabel* coinCombo2;
@property(nonatomic,retain)IBOutlet UIButton* coinComboBtn1;
@property(nonatomic,retain)IBOutlet UIButton* coinComboBtn2;
@property(nonatomic,retain)IBOutlet UIButton* resultBtn;
@property(nonatomic,retain)IBOutlet UILabel* tipLabel;
@property(nonatomic,assign)BOOL justNetwork;
@property(nonatomic,assign)BOOL hideWhenFinish;
@property(nonatomic,assign)id delegate;

-(IBAction)backClicked:(id)sender;

-(IBAction)resultClicked:(id)sender;
-(IBAction)coinCombo1Clicked:(id)sender;
-(IBAction)coinCombo2Clicked:(id)sender;
-(void)finish;
-(BOOL)isFirstResponder;

@end

@protocol ForeignCalculatorView_Delegate <NSObject>

-(void)calculatorBackClicked:(ForeignCalculatorView*)view;
-(void)calculatorBecomeFirstResponse:(ForeignCalculatorView*)view;

@end
