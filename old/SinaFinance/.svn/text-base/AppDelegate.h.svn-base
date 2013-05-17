//
//  AppDelegate.h
//  SinaFinance
//
//  Created by Du Dan on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushUtils.h"
#import "PushNewsViewController.h"

@class Reachability;
@class MyTabBarController;
@class CommentDataList;
#import "HQViewController.h"
#import "ConfigFileManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    Reachability* internetReach;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MyTabBarController *tabBarController;
@property(retain)NSDictionary* pushDict;
@property(retain)CommentDataList* remindIDList;
@property(retain)CommentDataList* tixingIDList;
 
-(void)adjustTabBarFrame;


+ (AppDelegate*)sharedAppDelegate;

-(void)initPushTab;
-(void)initTabToPushController;

-(void)reInitTab;
-(int)getTabId;
-(void)gotoTabWithIndex:(int)i;
-(void)resetHQviewController;

-(void)update_push_tixing_count_num;
-(void)update_push_xinwen_count_num;



#pragma mark - about news readed dict
-(void)add_news_to_already_read_array:(NSString *)news_url;
-(BOOL)is_news_has_readed:(NSString *)news_url;

@end
