//
//  ShareData.h
//  SinaNBA
//
//  Created by Du Dan on 9/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    kMyStock = 0,
    kGlobalStock,
    kGlobalProduct,
    kForeignExchange,
    kSHZhangDie,
    kHotUSAStock,
    kHKStockRanking,
    kSearch,
}StockMarketType;

#define constant_ipad_uuid	@"14a3cb0d-6eaa-dc0b-e2d5-2c5a-d8c2da9a"

#define APP_FONT_NAME @"Arial"//@"Helvetica"
#define BOLD_FONT_NAME @"Arial Bold"

#define MD5_STRING @"45*&=<09>?"

#define MYSTOCK_USERNAME_KEY @"MyStockUserName"
#define MYSTOCK_PASSWORD_KEY @"MyStockPassword"
#define MYSTOCK_CNGROUP_KEY @"MyStockCNGroup"
#define MYSTOCK_USGROUP_KEY @"MyStockUSGroup"
#define MYSTOCK_HKGROUP_KEY @"MyStockHKGroup"
#define MYSTOCK_FUNDGROUP_KEY @"MyStockFundGroup"
#define SETTINGS_COLOR_KEY @"SettingsColor"
#define SETTINGS_INTERVAL_KEY @"SettingsInterval"
#define SETTINGS_WEIBOEMAIL_KEY @"SettingsWeiboEmail"

@class Reachability;

@interface ShareData : NSObject {
    NSString *myStockTicket;
    NSString *myStockUserName;
    NSString *myStockPassword;
    BOOL isUserChanged;
    
    NSString *weiboEmail;
    
    NSMutableArray *myStockAGroup;
    NSMutableArray *myStockUSGroup;
    NSMutableArray *myStockHKGroup;
    NSMutableArray *myFundGroup;
    
    NSMutableArray *newsListArray;
    NSInteger newsFontSize;
    
    NSInteger refreshInterval;
    BOOL isColorSetted;
    
    BOOL isNetworkAvailable;
    Reachability* internetReach;
    
    BOOL isStockItemView;
    
    BOOL viewIsLoading;
    BOOL kLineHided;
}

@property (nonatomic, retain) NSString *myStockTicket;
@property (nonatomic, retain) NSString *myStockUserName;
@property (nonatomic, retain) NSString *myStockPassword;
@property (nonatomic, assign) BOOL isUserChanged;

@property (nonatomic, retain) NSString *weiboEmail;

@property (nonatomic, retain) NSMutableArray *myStockAGroup;
@property (nonatomic, retain) NSMutableArray *myStockUSGroup;
@property (nonatomic, retain) NSMutableArray *myStockHKGroup;
@property (nonatomic, retain) NSMutableArray *myFundGroup;

@property (nonatomic, retain) NSMutableArray *newsListArray;
@property (nonatomic, assign) NSInteger newsFontSize;

@property (nonatomic, assign) NSInteger refreshInterval;
@property (nonatomic, assign) BOOL isColorSetted;

@property (nonatomic, assign) BOOL isNetworkAvailable;

@property (nonatomic, assign) BOOL isStockItemView;

@property (nonatomic, assign) BOOL viewIsLoading;
@property (nonatomic, assign) BOOL kLineHided;

+ (ShareData*)sharedManager;
- (BOOL)checkNetworkAvailable;
- (void)networkStopNotifier;
- (UIColor*)textColorWithValue:(double)value marketType:(StockMarketType)marketType;

@end
