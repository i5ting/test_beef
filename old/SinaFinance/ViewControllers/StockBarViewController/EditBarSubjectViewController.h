//
//  EditBarSubjectViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditBarSubjectViewController : UIViewController
{
    IBOutlet UITextField* titleTextView;
    IBOutlet UITextView* contentTextView;
    
    NSString* stockName;
    NSString* stockNick;
    NSString* bid;
    NSString* tid;
    NSString* quotePid;
    UIView* titleView;
    UIView* contentView;
}

@property(nonatomic,retain)NSString* stockName;
@property(nonatomic,retain)NSString* stockNick;
@property(nonatomic,retain)NSString* bid;
@property(nonatomic,retain)NSString* tid;
@property(nonatomic,retain)NSString* quotePid;
@property(nonatomic,retain)IBOutlet UIView* titleView;
@property(nonatomic,retain)IBOutlet UIView* contentView;

@end
