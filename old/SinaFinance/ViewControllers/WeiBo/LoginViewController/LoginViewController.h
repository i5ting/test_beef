//
//  LoginViewController.h
//  SinaNews
//
//  Created by shieh exbice on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BCViewController.h"
#import "WeiboLoginManager.h"

enum LoginMode
{
    LoginMode_Weibo,
    LoginMode_Stock
};

@protocol WeiboUserLoginDelegate;

@interface LoginViewController : UIViewController
{
    IBOutlet UITableView* table;
    IBOutlet UITableViewCell* usernameCell;
    IBOutlet UITableViewCell* passwordCell;
    IBOutlet UITextField* usernameField;
    IBOutlet UITextField* passwordField;
    NSInteger loginMode;
    BOOL bInited;
    
    id<WeiboUserLoginDelegate> delegate;
    SEL failedSelector;
    SEL succeedSelector;
    SEL returnSelector;
}

@property (assign) SEL failedSelector;
@property (assign) SEL succeedSelector;
@property (assign) SEL returnSelector;

@property(nonatomic,retain)UITableView* table;
@property(nonatomic,retain)UITableViewCell* usernameCell;
@property(nonatomic,retain)UITableViewCell* passwordCell;
@property(nonatomic,retain)UITextField* usernameField;
@property(nonatomic,retain)UITextField* passwordField;
@property(nonatomic,assign)NSInteger loginMode;

@property (nonatomic, retain) id<WeiboUserLoginDelegate> delegate;


@end

@protocol WeiboUserLoginDelegate <NSObject>

@optional
- (void)weiboUserLoginFinished;
- (void)weiboUserLoginFailed;

@end