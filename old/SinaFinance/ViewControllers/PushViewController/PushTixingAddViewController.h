//
//  PushViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-4-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PushTixingAddViewControllerDelegate <NSObject>

-(void)disappearPushTixingAddView;

-(void)showPushTixingAddView;

@end

@interface PushTixingAddViewController : UIViewController

@property(nonatomic,assign)BOOL pushReceved;
@property(nonatomic,retain)NSString* pushSymbol;
@property(nonatomic,assign)BOOL needTab;
@property(nonatomic,retain)NSString* singleSymbol;
@property(nonatomic,assign)id<PushTixingAddViewControllerDelegate> delegate;
-(void)exit;

@end

