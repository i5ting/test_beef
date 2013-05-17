//
//  AddStockViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddStockRemindViewController : UIViewController <UITextFieldDelegate>
{
    UILabel* stockNameL;
    UILabel* stockInfo1L;
    UILabel* stockInfo2L;
    UILabel* stockInfo3L;
    UIActivityIndicatorView* indicator;
    UIView* titleView;
    UITextField* stockSetting1L;
    UITextField* stockSetting2L;
    UITextField* stockSetting3L;
    UITextField* stockSetting4L;
    UISwitch* stockFrequencyModeS;
    UIButton* comfirmBtn;
    UIButton* cancelBtn;
    UIView* backView;
    NSDictionary* stockSymbolInfo;
}

@property(nonatomic,retain)IBOutlet UILabel* stockNameL;
@property(nonatomic,retain)IBOutlet UILabel* stockInfo1L;
@property(nonatomic,retain)IBOutlet UILabel* stockInfo2L;
@property(nonatomic,retain)IBOutlet UILabel* stockInfo3L;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView* indicator;
@property(nonatomic,retain)IBOutlet UIView* titleView;
@property(nonatomic,retain)IBOutlet UITextField* stockSetting1L;
@property(nonatomic,retain)IBOutlet UITextField* stockSetting2L;
@property(nonatomic,retain)IBOutlet UITextField* stockSetting3L;
@property(nonatomic,retain)IBOutlet UITextField* stockSetting4L;
@property(nonatomic,retain)IBOutlet UISwitch* stockFrequencyModeS;
@property(nonatomic,retain)IBOutlet UIButton* comfirmBtn;
@property(nonatomic,retain)IBOutlet UIButton* cancelBtn;
@property(nonatomic,retain)IBOutlet UIView* backView;
@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)NSString* preSettting1;
@property(nonatomic,retain)NSString* preSettting2;
@property(nonatomic,retain)NSString* preSettting3;
@property(nonatomic,retain)NSString* preSettting4;
@property(nonatomic,assign)NSInteger mode;
@property(nonatomic,retain)id data;

-(IBAction)comfirmClicked:(id)sender;
-(IBAction)cancelClicked:(id)sender;
-(IBAction)backgroundClicked:(id)sender;
-(IBAction)backviewClicked:(id)sender;

@property(nonatomic,retain)NSDictionary* stockSymbolInfo;

@end



@protocol AddStockRemindDelegate <NSObject>

-(void)addStockRemindComfirm:(AddStockRemindViewController*)remindController;
-(void)addStockRemindCancel:(AddStockRemindViewController*)remindController;

@end
