//
//  ShareData.m
//  SinaNBA
//
//  Created by Du Dan on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareData.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "SaveData.h"
#import "ASIHTTPRequest.h"
#import "Reachability.h"
#import "Util.h"


@interface ShareData(private)

- (void)getTeamList;
- (BOOL)checkNetworkAvailable;

@end

@implementation ShareData

static ShareData *sharedInstance = nil;

//static bool userNotifiedOfReachability = NO;

@synthesize myStockTicket;
@synthesize myStockUserName, myStockPassword;
@synthesize myStockAGroup, myStockUSGroup, myStockHKGroup, myFundGroup;
@synthesize newsListArray;
@synthesize newsFontSize;
@synthesize refreshInterval;
@synthesize isNetworkAvailable;
@synthesize isUserChanged;
@synthesize isColorSetted;
@synthesize isStockItemView;
@synthesize viewIsLoading;
@synthesize weiboEmail;
@synthesize kLineHided;

+ (ShareData*)sharedManager
{
	if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

//- (void)release
//{
//    //do nothing
//}

- (id)autorelease
{
    return self;
}

- (id)init
{
    if((self = [super init])){
        myStockTicket = [[NSString alloc] init];
        
        NSString *username = (NSString*)[SaveData getDataForKey:MYSTOCK_USERNAME_KEY];
        NSString *password = (NSString*)[SaveData getDataForKey:MYSTOCK_PASSWORD_KEY];
        if(username && password){
            self.myStockUserName = [[NSString alloc] initWithString:username];
            self.myStockPassword = [[NSString alloc] initWithString:password];
        }
        else{
            self.myStockUserName = [[NSString alloc] init];
            self.myStockPassword = [[NSString alloc] init];
        }
        myStockAGroup = [[NSMutableArray alloc] initWithArray:(NSArray*)[SaveData getDataForKey:MYSTOCK_CNGROUP_KEY]];
        myStockHKGroup = [[NSMutableArray alloc] initWithArray:(NSArray*)[SaveData getDataForKey:MYSTOCK_HKGROUP_KEY]];
        myStockUSGroup = [[NSMutableArray alloc] initWithArray:(NSArray*)[SaveData getDataForKey:MYSTOCK_USGROUP_KEY]];
        myFundGroup = [[NSMutableArray alloc] initWithArray:(NSArray*)[SaveData getDataForKey:MYSTOCK_FUNDGROUP_KEY]];
        newsListArray = [[NSMutableArray alloc] init];
        newsFontSize = 14;
        isColorSetted = [(NSNumber*)[SaveData getDataForKey:SETTINGS_COLOR_KEY] boolValue];
        if([SaveData getDataForKey:SETTINGS_INTERVAL_KEY] == nil){
            refreshInterval = 15;
        }
        else{
            refreshInterval = [(NSNumber*)[SaveData getDataForKey:SETTINGS_INTERVAL_KEY] intValue];
        }
//        isNetworkAvailable = [self checkNetworkAvailable];
        isStockItemView = NO;
        viewIsLoading = NO;
        kLineHided = YES;
        weiboEmail = [[NSString alloc] initWithFormat:@"%@",[Util formatNullString:(NSString*)[SaveData getDataForKey:SETTINGS_WEIBOEMAIL_KEY]]];
    }
    return self;
}

- (void)dealloc
{
    sharedInstance = nil;
    [myStockTicket release];
    [myStockUserName release];
    [myStockPassword release];
    [myStockAGroup release];
    [myStockHKGroup release];
    [myStockUSGroup release];
    [myFundGroup release];
    [newsListArray release];
//    [internetReach stopNotifier];
    [internetReach release];
    [weiboEmail release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [super dealloc];
}

- (NSDate*)NSStringToNSDate:(NSString*)dateString isWithTime:(BOOL)isWithTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    if(isWithTime){
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    
    NSLog(@"dateFromString:%@", [dateFromString description]);
    return [dateFromString autorelease];
}


#pragma mark
#pragma mark CHECK NETWORK METHODS
- (BOOL)checkNetworkAvailable
{
    //if(internetReach == nil)
    {
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
//    [internetReach startNotifier];
//    [[NSNotificationCenter defaultCenter] addObserver: self 
//                                             selector: @selector(reachabilityChanged:) 
//                                                 name: kReachabilityChangedNotification 
//                                               object: nil];
    }
    [internetReach startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(reachabilityChanged:) 
                                                 name: kReachabilityChangedNotification 
                                               object: nil];
    NetworkStatus remoteHostStatus = [internetReach currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable){
        NSLog(@"NotReachable");
        return NO;
    }
    NSLog(@"Reachable");
    return YES;
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    NSLog(@"reachabilityChanged");
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            isNetworkAvailable = YES;
            break;
        }
        case ReachableViaWiFi:
        {
            isNetworkAvailable = YES;
            break;
        }
        case NotReachable:
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time. Some functionality will be limited until a connection is made." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            [alert show];
//            [alert release];
            isNetworkAvailable = NO;
            break;
        }
    }
}

//- (void)updateInterfaceWithReachability:(Reachability*)curReach
//{
//	//if(!userNotifiedOfReachability)
//	{	
//		NetworkStatus netStatus = [curReach currentReachabilityStatus];
//        //userNotifiedOfReachability = YES;
//        NSLog(@"netStatus: %d", netStatus);
//		switch (netStatus)
//		{
//			case NotReachable:
//			{
//				//statusString = @"Access Not Available";
//				[ShareData sharedManager].isNetworkAvailable = NO;  
//				break;
//			}
//				
//			case ReachableViaWWAN:
//			{
//				//statusString = @"Reachable WWAN";
//				[ShareData sharedManager].isNetworkAvailable = YES;  
//				break;
//			}
//			case ReachableViaWiFi:
//			{
//				//statusString= @"Reachable WiFi";
//				[ShareData sharedManager].isNetworkAvailable = YES; 
//				break;
//			}
//		}
//	}
//}


- (void)networkStopNotifier
{
    [internetReach stopNotifier];
    [internetReach release];
    internetReach = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (UIColor*)textColorWithValue:(double)value marketType:(StockMarketType)marketType
{
    if(isColorSetted){
        if(value > 0.0){
            return [UIColor redColor];
        }
        else if(value < 0.0){
            return [UIColor greenColor];
        }
        else{
            return [UIColor whiteColor];
        }
    }
    else{
        if(marketType == kSHZhangDie){
            if(value > 0.0){
                return [UIColor redColor];
            }
            else if(value < 0.0){
                return [UIColor greenColor];
            }
            else{
                return [UIColor whiteColor];
            }
        }
        else{
            if(value > 0.0){
                return [UIColor greenColor];
            }
            else if(value < 0.0){
                return [UIColor redColor];
            }
            else{
                return [UIColor whiteColor];
            }
        }
    }
}

@end
