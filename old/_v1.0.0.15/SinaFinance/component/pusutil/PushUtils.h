//
//  PushUtils.h
//  SinaFinance
//
//  Created by sang on 10/23/12.
//
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface PushUtils:NSObject


+ (void)push_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+ (void)push_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

+ (void)push_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken;

+ (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err;


+(void)resetPush:(BOOL)isOn withRemoteNotificationTypes:(UIRemoteNotificationType)types;


@end
