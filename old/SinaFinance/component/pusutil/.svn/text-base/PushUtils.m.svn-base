
//
//  PushUtils.m
//  SinaFinance
//
//  Created by sang on 10/23/12.
//
//

#import "PushUtils.h"


#define DEVICE_TOKEN @"push_device_token"

#ifdef DEBUG
#define APSLog(_log_, ...) NSLog([NSString stringWithFormat:@"APS PUSH INFO:%@",_log_], ## __VA_ARGS__)
#else
#define APSLog(_log_, ...)
#endif


@implementation PushUtils



+ (void)push_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *pushDic = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (pushDic) {
        NSDictionary *apsDic = [pushDic objectForKey:@"aps"];
        NSString *articleId = [apsDic objectForKey:@"acme1"];
        if (articleId && ![@""isEqualToString:articleId]) {
//            DATA_ENV.pushArticleId = articleId;
        }
    } 
    APSLog(pushDic);
   [[NSNotificationCenter defaultCenter] postNotificationName:@"offlineReceiPushArrivedNotification" object:nil userInfo:pushDic];
}


+ (void)push_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceiPushArrivedNotification" object:nil userInfo:userInfo];
//    [[self class] saveApsInfo:userInfo];
}



// Retrieve the device token
+ (void)push_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    NSString *deviceToken = [[[[devToken description]
                               stringByReplacingOccurrencesOfString:@"<"withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString: @" " withString: @""];
//    [[RegValueSaver getInstance] saveSystemInfoValue:deviceToken forKey:PushDeviceTokenKey encryptString:YES];
//    [self realStartPushRequst:YES withToken:deviceToken];
//    NSLog(@"test shit:%@",[MyTool encryptPwd:deviceToken]);
//#ifdef DEBUG
//    NSLog(@"test shit2:%@",deviceToken);
//#endif
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:DEVICE_TOKEN];
    
    BOOL hasStartPush = YES;
}


+ (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    //    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UD_PUSH_NOTIFICATION];
    NSLog(@"Error in registration. Error: %@", err);
}

/**
 *
 * @param = isOn  {YES=打开，NO=关闭}
 * @param = types 可以不写，如果没有，默认types=(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)
 *
 */
+(void)resetPush:(BOOL)isOn withRemoteNotificationTypes:(UIRemoteNotificationType)types{
     
    if (isOn) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types?types:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    }
    else
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

-(void)pushArrived{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewsPushArrivedNotification" object:nil userInfo:[self getApsInfo]];
}

/*
 
 userInfo ={
    aps = {
        alert = "\U5751\U7239100110";
        badge = 1000;
        sound = default;
    };
    hash = zlQgn8h;
 }
 
 */

#define PUSH_FOLDER_NAME @"remote"
#define PUSH_FOLDER_FILE_NAME @"push"

-(void)saveApsInfo:(NSDictionary *)remoteNotif{
    NSMutableDictionary* newRemoteNotif = [[NSMutableDictionary alloc] initWithDictionary:remoteNotif];
    NSString* intervalString = [remoteNotif valueForKey:@"time"];
    if (intervalString) {
        intervalString = [[NSNumber numberWithInt:[intervalString intValue] + 100] stringValue];
        [newRemoteNotif setValue:intervalString forKey:@"time"];
    }
    
    [self writeToDocument:newRemoteNotif folder:PUSH_FOLDER_NAME fileName:PUSH_FOLDER_FILE_NAME];
    [newRemoteNotif release];
}

- (NSString*)writeToDocument:(id)data folder:(NSString*)folderName fileName:(NSString*)filename
{
	NSArray* documentPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentPath = [documentPathArray objectAtIndex:0];
    if (folderName) {
        documentPath = [documentPath stringByAppendingPathComponent:folderName];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:NULL];
	}
    NSString* filepathName = [documentPath stringByAppendingPathComponent:filename];
    APSLog(filepathName);
    if ([data respondsToSelector:@selector(writeToFile:atomically:)]) {
        BOOL ret = [data writeToFile:filepathName atomically:YES];
        if (ret) {
            return filepathName;
        }
    }
	return nil;
}

/* 返回aps后，删除文件*/
- (NSDictionary*)getApsInfo
{
    NSArray* documentPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentPath = [documentPathArray objectAtIndex:0];
    if (PUSH_FOLDER_NAME) {
        documentPath = [documentPath stringByAppendingPathComponent:PUSH_FOLDER_NAME];
    }
    NSString* filepathName = [documentPath stringByAppendingPathComponent:PUSH_FOLDER_FILE_NAME];
    NSDictionary* rtval = [NSDictionary dictionaryWithContentsOfFile:filepathName];
    
    BOOL boolValue=[[NSFileManager defaultManager] removeItemAtPath:filepathName error:nil];
    if (boolValue)
    {
        APSLog(@"remove push file ok");
    }
    
    return rtval;    
}



@end
