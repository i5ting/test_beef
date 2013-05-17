//
//  JSONConfigDownloader.m
//  SinaFinance
//
//  Created by shieh exbice on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JSONConfigDownloader.h"
#import "ConfigLocalSaver.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "MyTool.h"
#import "RegValueSaver.h"

#define ConfigDownloadInterval 12*60*60
#define ConfigDownloadErrorInterval 30*60
#define ConfigServerCatalogURL @"http://m.sina.com.cn/iframe/config/catalog.json"
#define ConfigServerTestCatalogURL @"http://m.sina.com.cn/iframe/config/catalog_test.json"
#define ConfigLoadedServerIndexKey @"ConfigLoadedServerIndexKey"
#define ConfigLoadedCurVersionKey @"ConfigLoadedCurVersionKey"

@interface JSONConfigDownloader ()
@property(nonatomic,retain)NSDate* lastDate;
@property(nonatomic,retain)ASIHTTPRequest* curCatalogRequest;
@property(assign)BOOL requsting;
@property(assign)BOOL lastUploadSuc;

@end

@implementation JSONConfigDownloader
{
    NSDate* lastDate;
    BOOL curExited;
    NSTimeInterval pastedTimeInterval;
    ASIHTTPRequest* curCatalogRequest;
    BOOL lastUploadSuc;
    BOOL requsting;
    BOOL bFirstStart;
}
@synthesize lastDate;
@synthesize curCatalogRequest;
@synthesize testMode;
@synthesize requsting,lastUploadSuc;

+ (id)getInstance
{
    static JSONConfigDownloader* s_instance = nil;
	if (s_instance == nil)
	{
		//没有创建则创建
		s_instance = [[JSONConfigDownloader alloc] init];
	}
	return s_instance;
}

-(id)init
{
    self = [super init];
    if (self) {
        lastUploadSuc = YES;
        
#ifdef DEBUG
        [self performSelector:@selector(saveLocalConfig) withObject:nil afterDelay:1.0];
#endif
    }
    return self;
}

-(void)dealloc
{
    [lastDate release];
    [curCatalogRequest release];
    [super dealloc];
}

-(void)saveLocalConfig
{
    ConfigLocalSaver* saver = [[ConfigLocalSaver alloc] init];
    [saver mergeAndSaveFromBundle];
    [saver release];
}

-(void)startup
{
    curExited = NO;
    bFirstStart = YES;
    [self startRefreshDataTimer];
}

-(void)stop
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshDataTimer) object:nil];
}

-(id)mutableJsonOjbectWithJSONConfigFile:(NSString*)fileName
{
    NSString* commentStr = [self jsonStringWithJSONConfigFile:fileName];
    return [commentStr mutableObjectFromJSONString];
}

-(id)jsonOjbectWithJSONConfigFile:(NSString*)fileName
{
    NSString* commentStr = [self jsonStringWithJSONConfigFile:fileName];
    return [commentStr objectFromJSONString];
}

-(NSString*)jsonStringWithJSONConfigFile:(NSString*)fileName
{
    NSArray* documentPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentPath = [documentPathArray objectAtIndex:0];
    NSString* commentPath = [documentPath stringByAppendingPathComponent:fileName];
    NSString* loadedAppVersion = [[RegValueSaver getInstance] readSystemInfoForKey:ConfigLoadedCurVersionKey];
    NSDictionary* sysInfo = [[NSBundle mainBundle] infoDictionary];
    NSString* appver = [sysInfo objectForKey:(NSString*)kCFBundleVersionKey];
    BOOL canuseDocument = NO;
    if (loadedAppVersion&&[loadedAppVersion isEqualToString:appver]) {
        canuseDocument = YES;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:commentPath]||!canuseDocument) {
		NSString* path = [[NSBundle mainBundle] bundlePath];
        commentPath = [path stringByAppendingPathComponent:fileName];
	}
    
    NSError* error;
    NSString* commentStr = [NSString stringWithContentsOfFile:commentPath encoding:NSUTF8StringEncoding error:&error];
    if (!commentStr) {
        commentStr = [NSString stringWithContentsOfFile:commentPath encoding:NSUnicodeStringEncoding error:&error];
    }
    commentStr = [commentStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([commentStr hasPrefix:@"/*"]) {
        NSRange annotationRange = [commentStr rangeOfString:@"*/"];
        if (annotationRange.location!=NSNotFound) {
            commentStr = [commentStr substringFromIndex:annotationRange.location+annotationRange.length];
        }
    }
    return commentStr;
}

-(void)startRefreshDataTimer
{
    self.lastDate = [NSDate date];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshDataTimer) object:nil];
    [self performSelector:@selector(refreshDataTimer) withObject:nil afterDelay:1.0];
}

-(void)refreshDataTimer
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshDataTimer) object:nil];
    if (!curExited) {
        [self performSelector:@selector(refreshDataTimer) withObject:nil afterDelay:1.0];
        NSTimeInterval timelen = [[NSDate date] timeIntervalSinceDate:self.lastDate];
        if (timelen>1.0) {
            pastedTimeInterval += timelen;
        }
        else {
            pastedTimeInterval += 1.0;
        }
        self.lastDate = [NSDate date];
        if (self.lastUploadSuc) {
            if(ConfigDownloadInterval<=pastedTimeInterval&&ConfigDownloadInterval>0.0&&!self.requsting) {
                pastedTimeInterval = 0.0;
                [self startDownloadCatalogInfo];
            }
        }
        else {
            if(ConfigDownloadErrorInterval<=pastedTimeInterval&&ConfigDownloadErrorInterval>0.0&&!self.requsting) {
                pastedTimeInterval = 0.0;
                [self startDownloadCatalogInfo];
            }
        }
    }
    if (bFirstStart) {
        bFirstStart = NO;
        [self startDownloadCatalogInfo];
    }
}

-(void)startDownloadCatalogInfo
{
    self.requsting = YES;
    NSURL* url = [NSURL URLWithString:ConfigServerCatalogURL];
    if (testMode) {
        url = [NSURL URLWithString:ConfigServerTestCatalogURL];
    }
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL :url];
    if (self.curCatalogRequest) {
        [self.curCatalogRequest clearDelegatesAndCancel];
        self.curCatalogRequest = nil;
    }
    self.curCatalogRequest = request;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(updateFailed:)];
    [request setDidFinishSelector:@selector(updatefinished:)];
    [request startAsynchronous];
    [request release];
}

-(void)updateFailed:(ASIHTTPRequest*)request
{
    self.lastUploadSuc = NO;
    self.requsting = NO;
}

-(void)updatefinished:(ASIHTTPRequest*)request
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:enc];
    NSString* commentStr = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([commentStr hasPrefix:@"/*"]) {
        NSRange annotationRange = [commentStr rangeOfString:@"*/"];
        if (annotationRange.location!=NSNotFound) {
            commentStr = [commentStr substringFromIndex:annotationRange.location+annotationRange.length];
        }
    }
    
    NSDictionary* catalogDict = [commentStr objectFromJSONString];
    if (catalogDict&&[catalogDict isKindOfClass:[NSDictionary class]]) {
        NSDictionary* sysInfo = [[NSBundle mainBundle] infoDictionary];
        NSString* bundleName = [sysInfo valueForKey:(NSString*)kCFBundleNameKey];
        NSArray* allKeys = [catalogDict allKeys];
        NSString* foundKey = nil;
        for (NSString* oneKey in allKeys) {
            if ([[oneKey lowercaseString] isEqualToString:[bundleName lowercaseString]]) {
                foundKey = oneKey;
                break;
            }
        }
        id catalogInfo = [catalogDict valueForKey:foundKey];
        if([catalogInfo isKindOfClass:[NSString class]])
        {
            NSString* catalogURLString = (NSString*)catalogInfo;
            [self startDownloadSubCatalogInfoWithURLString:catalogURLString];
        }
        else if([catalogInfo isKindOfClass:[NSArray class]])
        {
            NSArray* catalogArray = (NSArray*)catalogInfo;
            BOOL ret = [self dealRealCataLogArray:catalogArray];
            if (!ret) {
                self.lastUploadSuc = YES;
                self.requsting = NO;
            }
        }
        else {
            self.lastUploadSuc = YES;
            self.requsting = NO;
        }
    }
    else {
        self.lastUploadSuc = YES;
        self.requsting = NO;
    }
    
    [resultString release];
}

-(void)startDownloadSubCatalogInfoWithURLString:(NSString*)urlString
{
    self.requsting = YES;
    NSURL* url = [NSURL URLWithString:urlString];
    ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL :url];
    if (self.curCatalogRequest) {
        [self.curCatalogRequest clearDelegatesAndCancel];
        self.curCatalogRequest = nil;
    }
    self.curCatalogRequest = request;
    [request setDelegate:self];
    [request setDidFailSelector:@selector(updateFailed:)];
    [request setDidFinishSelector:@selector(updatefinished:)];
    [request startAsynchronous];
    [request release];
}

-(BOOL)verifyCatalogArray:(NSArray*)catalogArray
{
    BOOL rtval = YES;
    for (NSDictionary* oneCatalog in catalogArray) {
        if ([oneCatalog isKindOfClass:[NSDictionary class]]) {
            NSString* indexString = [oneCatalog valueForKey:@"index"];
            if (indexString&&!([indexString isKindOfClass:[NSString class]]||[indexString isKindOfClass:[NSNumber class]])) {
                rtval = NO;
                break;
            }
            NSString* urlString = [oneCatalog valueForKey:@"url"];
            if (urlString&&![urlString isKindOfClass:[NSString class]]) {
                rtval = NO;
                break;
            }
            NSArray* versionsString = [oneCatalog valueForKey:@"versions"];
            if (versionsString&&![versionsString isKindOfClass:[NSArray class]]) {
                rtval = NO;
                break;
            }
            NSString* isdefaultString = [oneCatalog valueForKey:@"isdefault"];
            if (isdefaultString&&!([isdefaultString isKindOfClass:[NSString class]]||[isdefaultString isKindOfClass:[NSNumber class]])) {
                rtval = NO;
                break;
            }
            NSString* invalidString = [oneCatalog valueForKey:@"invalidend-version"];
            if (invalidString&&![invalidString isKindOfClass:[NSString class]]) {
                rtval = NO;
                break;
            }
        }
        else {
            rtval = NO;
            break;
        }
    }
    return rtval;
}

-(BOOL)dealRealCataLogArray:(NSArray*)array
{
    BOOL rtval = NO;
    if (array&&[array count]>0) {
        rtval = [self verifyCatalogArray:array];
        if (rtval) {
            NSDictionary* sysInfo = [[NSBundle mainBundle] infoDictionary];
            NSString* appver = [sysInfo objectForKey:(NSString*)kCFBundleVersionKey];
            NSMutableArray* sortArray = [[NSMutableArray alloc] initWithArray:array];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES comparator:^(id obj1, id obj2) 
            {    
                if (obj1&&obj2) {
                    if ([obj1 intValue] > [obj2 intValue]) 
                    {         
                        return (NSComparisonResult)NSOrderedDescending;     
                    }     
                    if ([obj1 intValue] < [obj2 intValue]) 
                    {
                        return (NSComparisonResult)NSOrderedAscending;     
                    }
                } 
                return (NSComparisonResult)NSOrderedSame; 
            }];  
            [sortArray sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]; 
            NSDictionary* commonDict = nil;
            NSDictionary* versionAppointDict = nil;
            for (int i=[sortArray count]-1;i>=0;i--) {
                NSDictionary* dict = [sortArray objectAtIndex:i];
                NSArray* versionsArray = [dict valueForKey:@"versions"];
                NSString* invalidStartString = [dict valueForKey:@"invalidstart-version"];
                NSString* invalidEndString = [dict valueForKey:@"invalidend-version"];
                if (versionsArray&&[versionsArray count]>0) {
                    if ([versionsArray containsObject:appver]) {
                        versionAppointDict = dict;
                        break;
                    }
                }
                else {
                    BOOL canuse = YES;
                    if (invalidEndString&&[MyTool versionCompareWithVersion1:invalidEndString version2:appver]==NSOrderedDescending) {
                        canuse = NO;
                    }
                    
                    if (canuse) {
                        if (invalidStartString&&[MyTool versionCompareWithVersion1:invalidStartString version2:appver]==NSOrderedAscending) {
                            canuse = NO;
                        }
                    }
                    
                    if (canuse) {
                        if (!commonDict) {
                            commonDict = dict;
                        }
                    }
                }
            }
            
            NSDictionary* useDict = versionAppointDict?versionAppointDict:commonDict;
            if (useDict) {
                NSString* isdefaultString = [useDict valueForKey:@"isdefault"];
                NSString* indexString = [useDict valueForKey:@"index"];
                if (indexString) {
                    NSString* loadedIndexString = [[RegValueSaver getInstance] readSystemInfoForKey:ConfigLoadedServerIndexKey];
                    NSString* loadedAppVersion = [[RegValueSaver getInstance] readSystemInfoForKey:ConfigLoadedCurVersionKey];
                    if (!(loadedIndexString&&[loadedIndexString isEqualToString:indexString])||!(loadedAppVersion&&[loadedAppVersion isEqualToString:appver])) {
                        if (!(isdefaultString&&[isdefaultString intValue]>0)) {
                            NSString* urlString = [useDict valueForKey:@"url"];
                            [self requstRealConfigFileWithURLString:urlString indexInfo:indexString curVersion:appver];
                        }
                    }
                }
            }
            
            [sortArray release];
        }
    }
    return rtval;
}

-(void)requstRealConfigFileWithURLString:(NSString*)urlString indexInfo:(NSString*)index curVersion:(NSString*)curVersion
{
    self.requsting = YES;
    NSURL* url = [NSURL URLWithString:urlString];
    ASIHTTPRequest* request = [[[ASIHTTPRequest alloc] initWithURL :url] autorelease];
    NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (index) {
        [userInfo setValue:index forKey:@"index"];
    }
    [userInfo setValue:curVersion forKey:@"curversion"];
    request.userInfo = userInfo;
    [userInfo release];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(configRequstFailed:)];
    [request setDidFinishSelector:@selector(configRequstFinished:)];
    [request startAsynchronous];
}

-(void)configRequstFailed:(ASIHTTPRequest*)request
{
    self.lastUploadSuc = NO;
    self.requsting = NO;
}

-(void)configRequstFinished:(ASIHTTPRequest*)request
{
    NSDictionary* userInfo = request.userInfo;
    NSString* indexString = [userInfo valueForKey:@"index"];
    NSString* curversion = [userInfo valueForKey:@"curversion"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:enc];
    ConfigLocalSaver* saver = [[ConfigLocalSaver alloc] init];
    NSString* configStr = [resultString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([configStr hasPrefix:@"/*"]) {
        NSRange annotationRange = [configStr rangeOfString:@"*/"];
        if (annotationRange.location!=NSNotFound) {
            configStr = [configStr substringFromIndex:annotationRange.location+annotationRange.length];
        }
    }
    NSDictionary* configDict = [configStr objectFromJSONString];
    if (configDict&&[configDict isKindOfClass:[NSDictionary class]])
    {
        BOOL result = [saver spliteAndSaveWithString:resultString];
        [saver release];
        
        if (result) {
            [[RegValueSaver getInstance] saveSystemInfoValue:indexString forKey:ConfigLoadedServerIndexKey encryptString:NO];
            [[RegValueSaver getInstance] saveSystemInfoValue:curversion forKey:ConfigLoadedCurVersionKey encryptString:NO];
            NSMutableDictionary* notifyDict = [NSMutableDictionary dictionaryWithCapacity:3];
            [notifyDict setObject:JSONConfigChangedNotification forKey:@"postNotificationName"];
            [notifyDict setObject:NSStringFromClass([self class]) forKey:@"object"];
            
            [self performSelectorOnMainThread:@selector(mainThreadRunningNotification:) withObject:notifyDict waitUntilDone:NO];
            self.lastUploadSuc = YES;
            self.requsting = NO;
        }
        else {
            self.lastUploadSuc = NO;
            self.requsting = NO;
        }
    }
    else {
        self.lastUploadSuc = YES;
        self.requsting = NO;
    }
    [resultString release];
}

-(void)mainThreadRunningNotification:(NSDictionary*)argInfo
{
    NSString* notifyName = [argInfo objectForKey:@"postNotificationName"];
    id object = [argInfo objectForKey:@"object"];
    NSDictionary* userInfo = [argInfo objectForKey:@"userInfo"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notifyName object:object userInfo:userInfo];
}

@end
