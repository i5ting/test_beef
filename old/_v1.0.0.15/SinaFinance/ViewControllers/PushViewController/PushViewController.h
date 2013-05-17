//
//  PushViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsObject.h"

typedef enum{
    pushType_tixing=0,
    pushType_xinwen=1
}pushType;

@interface PushViewController : UIViewController

+ (PushViewController *)sharedAppDelegate;

@property(nonatomic,assign)BOOL pushReceved;
@property(nonatomic,retain)NSString* pushSymbol;
@property(nonatomic,assign)BOOL needTab;
@property(nonatomic,retain)NSString* singleSymbol;
-(void)exit;

@property(nonatomic,assign) pushType pushType;

-(void)update_news_table_with_index:(int)index news_object:(NewsObject *)oneObject;
-(void)update_news_table_with_index:(int)index new_value:(NSString *)newValue;

-(void)reload_push_news_talbe_view;
@end
