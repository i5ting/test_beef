//
//  UserLoginViewController.h
//  SinaFinance
//
//  Created by Du Dan on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyStockUserLoginDelegate;

@interface UserLoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UITextField *usernameField;
    UITextField *passwordField;
    id <MyStockUserLoginDelegate> delegate;
}

@property (nonatomic, assign) id <MyStockUserLoginDelegate> delegate;

@end

@protocol MyStockUserLoginDelegate <NSObject>

- (void)myStockUserLoginFinished;
- (void)myStockUserLoginFailed;

@end
