//
//  BugAppDelegate.m
//  WhatsBug
//

#import "AppDelegate.h"
#import "CatelogBoard.h"
#import "DribbbleController.h"

#import "Bee.h"
#import "Bee_Debug.h"
// #import "Bee_UnitTest.h"
#import "ProvideMessageForWeiboViewController.h"
#import "SendMessageToWeiboViewController.h"

#pragma mark -

#define DEV 0


#import "TestBoard.h" 
#import "Bee_CustomTabBoard.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
	// [BeeUnitTest runTests];
    
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
	
    
//    CustomTabBarViewController *tabbarController = [[No320HeighlightTabViewController alloc] initWithBundleName:@"finiance_tab"];
    //    CustomTabBarViewController *tabbarController = [[CustomTabBarViewController alloc] initWithBundleName:@"xiangqu"];
    self.window.frame = CGRectMake(0, 0, 320, UI_MAX_HEIGHT);
//    self.window.rootViewController = tabbarController;
//    [tabbarController release];
    
    
//    self.window.rootViewController = [BeeUIStackGroup stackGroupWithFirstStack:[BeeUIStack stackWithFirstBoard:[TestBoard board]]];
    
//    self.window.rootViewController = [[No320HighlightTabBoard alloc] initWithBundleName:@"finiance_tab"];
    
    self.window.rootViewController = [[BeeCustomTabBoard alloc] initWithBundleName:@"finiance_tab"];
    
    if (DEV != 0) {
        self.window.rootViewController = [BeeUIStackGroup stackGroupWithFirstStack:[BeeUIStack stackWithFirstBoard:[CatelogBoard board]]];
    }
    
    [self.window makeKeyAndVisible];
	
	[BeeDebugger show];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [ WeiboSDK handleOpenURL:url delegate:self ];
}

#pragma mark - WeiboSDKDelegate 

/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
   BeeUIBoard * board = (BeeUIBoard *)[[BeeUIBoard allBoards] objectAtIndex:0];
    
    
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        ProvideMessageForWeiboViewController *controller = [[[ProvideMessageForWeiboViewController alloc] init] autorelease];
//        [self.viewController presentModalViewController:controller animated:YES];
        
        [board.stack presentViewController:controller animated:YES completion:^{
           
        }];
    }
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 [WBBaseResponse userInfo] 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = @"发送结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",
                             response.statusCode, response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSString *title = @"认证结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",
                             response.statusCode, [(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }

}



@end
