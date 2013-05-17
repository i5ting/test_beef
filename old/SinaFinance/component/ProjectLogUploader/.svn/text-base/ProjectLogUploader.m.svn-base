//
//  ProjectLogUploader.m
//  SinaFinance
//
//  Created by shieh exbice on 12-5-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProjectLogUploader.h"
#import "MyTool.h"
#import "RegValueSaver.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "JSONKit.h"
#import "ASIDataCompressor.h"

#define ProjectLogUploaderFolder @"uploaderlog"
#define ProjectLogWritingFile @"uploaderlogfile"
#define ProjectLogLastUploadDateKey @"ProjectLogLastUploadDateKey"
#define ProjectLogMaxFileSize 99*1024
#define ProjectLogRefreshTimeInterval 10.0
#define ProjectLogFailedRefreshTimeInterval 4.0*60
#define ProjectLogMaxLocalTimeInterval 60.0*60*24

@interface ProjectLogUploader ()
@property(nonatomic,retain)NSDate* lastDate;
@property(nonatomic,retain)NSFileHandle* mainHandle;
@property(nonatomic,retain)NSString* curWritingFile;
@property(nonatomic,retain)NSString* curSid;
@property(nonatomic,retain)ASIHTTPRequest* curRequst;
@property(nonatomic,retain)ASINetworkQueue* uploadQueue;
@property(nonatomic,retain)NSNumber* needUploader;
@end

@implementation ProjectLogUploader
{
    NSDate* lastDate;
    NSTimeInterval pastedTimeInterval;
    NSFileHandle* mainHandle;
    NSString* curWritingFile;
    NSString* curSid;
    BOOL curExited;
    ASIHTTPRequest* curRequst;
    NSString* appKey;
    ASINetworkQueue* uploadQueue;
    NSNumber* needUploader;
    BOOL requsting;
    BOOL bFirstStart;
    BOOL lastUploadSuc;
}
@synthesize lastDate;
@synthesize mainHandle;
@synthesize curWritingFile;
@synthesize curSid;
@synthesize curRequst;
@synthesize appKey;
@synthesize uploadQueue;
@synthesize needUploader;

+ (id)getInstance
{
    static ProjectLogUploader* s_messageManager = nil;
	if (s_messageManager == nil)
	{
		//没有创建则创建
		s_messageManager = [[ProjectLogUploader alloc] init];
        
	}
	return s_messageManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        lastUploadSuc = YES;
        [self refreshSID];
    }
    return self;
}

-(void)dealloc
{
    [lastDate release];
    [mainHandle closeFile];
    [mainHandle release];
    [curWritingFile release];
    [curSid release];
    [curRequst release];
    [appKey release];
    [uploadQueue release];
    [needUploader release];
    
    [super dealloc];
}

-(void)startup
{
    curExited = NO;
    bFirstStart = YES;
    [self startRefreshDataTimer];
}

-(void)stop
{
    if (self.curRequst) {
        [curRequst clearDelegatesAndCancel];
        self.curRequst = nil;
    }
    [self.uploadQueue cancelAllOperations];
    curExited = YES;
}

-(void)refreshSID
{
    self.curSid = [MyTool getSid];
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
        if (lastUploadSuc) {
            if(ProjectLogRefreshTimeInterval<=pastedTimeInterval&&ProjectLogRefreshTimeInterval>0.0&&!requsting) {
                pastedTimeInterval = 0.0;
                [self uploadFile];
            }
        }
        else {
            if(ProjectLogFailedRefreshTimeInterval<=pastedTimeInterval&&ProjectLogFailedRefreshTimeInterval>0.0&&!requsting) {
                pastedTimeInterval = 0.0;
                [self uploadFile];
            }
        }
    }
    if (bFirstStart) {
        bFirstStart = NO;
        [self uploadFile];
    }
}

-(void)uploadFile
{
    if (!needUploader) {
        NSString* oneFile = [self getOneUploaderFile];
        if (oneFile&&[oneFile length]>0) {
            self.needUploader = [NSNumber numberWithBool:YES];
        }
    }
    
    if (needUploader&&[needUploader boolValue]==YES) {
        [self startHttpRequest];
    }
}

-(NSString*)getOneUploaderFile
{
    NSArray* documentPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [documentPathArray objectAtIndex:0];
    NSString* cachePath = [documentPath stringByAppendingPathComponent:ProjectLogUploaderFolder];
    NSArray* dictArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachePath error:NULL];
    NSString* oneFileComponet = nil;
    for (int i=0; i<[dictArray count]; i++) {
        oneFileComponet = [dictArray objectAtIndex:i];
        if ([oneFileComponet hasSuffix:@".log"]) {
            break;
        }
        else {
            oneFileComponet = nil;
        }
    }
    if (oneFileComponet) {
        return [cachePath stringByAppendingPathComponent:oneFileComponet];
    }
    else {
        return nil;
    }
}

-(void)startHttpRequest
{
    requsting = YES;
    NSString* urlString = @"http://platform.sina.com.cn/general/upload_mobile_log";
    urlString = [MyTool urlString:urlString replaceStringKey:@"app_key" withValueString:appKey];
    urlString = [MyTool urlString:urlString replaceStringKey:@"gzip" withValueString:@"1"];
    NSURL* url = [NSURL URLWithString:urlString];
    if (self.curRequst) {
        [self.curRequst clearDelegatesAndCancel];
        self.curRequst = nil;
    }
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.requestMethod = @"POST";
    //request.shouldCompressRequestBody = YES;
    NSString* uplaodFile = [self getOneUploaderFile];
    NSString* fileName = [uplaodFile lastPathComponent];
    fileName = [MyTool MD5DigestFromString:fileName];
    NSString* fileContent = [NSString stringWithContentsOfFile:uplaodFile encoding:NSUTF8StringEncoding error:NULL];
    [request setPostValue:fileName forKey:@"file_name"];
//    NSString* fileNameString = [NSString stringWithFormat:@"%@=%@",@"file_name",fileName];
//    fileNameString = [fileNameString stringByAppendingString:@"&log="];
//    NSMutableData* sendData = [[NSMutableData alloc] initWithCapacity:0];
//    [sendData appendData:[fileNameString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData* sourceData = [fileContent dataUsingEncoding:NSUTF8StringEncoding];
    NSData *compressedBody = [ASIDataCompressor compressData:sourceData error:NULL];
//    [sendData appendData:compressedBody];
    [request setPostValue:compressedBody forKey:@"log"];
    NSMutableDictionary* info = [[NSMutableDictionary alloc] initWithCapacity:0];
    [info setValue:uplaodFile forKey:@"filepath"];
    request.userInfo = info;
    request.delegate = self;
    self.curRequst = request;
    [request release];
    [info release];
    [self.curRequst startAsynchronous];
}

-(void)clearRequestQueue
{
    [uploadQueue cancelAllOperations];
    self.uploadQueue = nil;
}

-(void)initalDownloadQueue
{
    if (!uploadQueue) {
        uploadQueue = [[ASINetworkQueue alloc] init];
        [uploadQueue setShouldCancelAllRequestsOnFailure:NO];
        [uploadQueue setDelegate:self];
    }
}

-(void)addRequestToDowloadQueue:(ASIHTTPRequest*)request
{
    [self initalDownloadQueue];
    [self.uploadQueue addOperation:request];
    [self.uploadQueue go];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    lastUploadSuc = YES;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:enc];
    if (!resultString) {
        resultString = [request.responseString retain];
    }
    NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
    NSDictionary* jsonDict = [newString objectFromJSONString];
    if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
        NSDictionary* resultDict = [jsonDict objectForKey:@"result"];
        NSDictionary* statusDict = [resultDict objectForKey:@"status"];
        NSString* codeValue = [statusDict objectForKey:@"code"];
        if ([codeValue isKindOfClass:[NSNumber class]]) {
            codeValue = [NSString stringWithFormat:@"%@",codeValue];
        }
        if ([codeValue isEqualToString:@"0"]) {
            NSDictionary* userInfo = request.userInfo;
            NSString* filePath = [userInfo valueForKey:@"filepath"];
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:NULL];
            NSString* existFile = [self getOneUploaderFile];
            if (existFile&&[existFile length]>0) {
                [self startHttpRequest];
            }
            else {
                self.needUploader = [NSNumber numberWithBool:NO];
                requsting = NO;
            }
        }
        else
        {
            [self requestFailed:request];
        }
    }
    else {
        [self requestFailed:request];
    }
}

-(void)requestFailed:(ASIHTTPRequest*)request
{
    lastUploadSuc = NO;
    requsting = NO;
}

-(BOOL)writeDataString:(NSString*)dataString
{
    if (dataString) {
        dataString = [dataString stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        [self adjustFileHandleForWrite];
        NSDate* date = [NSDate date];
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString* dateString = [formater stringFromDate:date];
        [formater release];
        NSString* sysname = [[UIDevice currentDevice] systemName];
        sysname = [sysname stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString* sysver = [[UIDevice currentDevice] systemVersion];
        NSDictionary* sysInfo = [[NSBundle mainBundle] infoDictionary];
        NSString* appver = [sysInfo objectForKey:(NSString*)kCFBundleVersionKey];
        NSString* appname = [sysInfo objectForKey:(NSString*)kCFBundleNameKey];
        NSString* sid = self.curSid;
        NSString* uuid = [MyTool getDeviceUniqueMD5];
        NSString* writingString = [NSString stringWithFormat:@"[%@] funid:%@ sid:%@ uuid:%@ sysname:%@ sysver:%@ appver:%@ appname:%@\n",dateString,dataString,sid,uuid,sysname,sysver,appver,appname];
        [self.mainHandle writeData:[writingString dataUsingEncoding:NSUTF8StringEncoding]];
        [self.mainHandle synchronizeFile];
        [self adjustFileForUploader];
        //增加友盟实时统计,如果open_umeng_flag = y才发送
        [MobClick startWithAppkey:UMENG_KEY reportPolicy:REALTIME channelId:nil];
        NSString *open_umeng_flag =  [MobClick getConfigParams:@"open_umeng_flag"];
        if ([open_umeng_flag isEqualToString:@"y"]) {
            [MobClick event:dataString];
        }
    
    }
    return YES;
}

-(void)adjustFileHandleForWrite
{
    if (!mainHandle) {
        NSArray* documentPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentPath = [documentPathArray objectAtIndex:0];
        NSString* writingFile = [documentPath stringByAppendingPathComponent:ProjectLogWritingFile];
        if (![[NSFileManager defaultManager] fileExistsAtPath:writingFile]) {
            [[NSFileManager defaultManager] createFileAtPath:writingFile contents:nil attributes:nil];
        }
        self.mainHandle = [NSFileHandle fileHandleForUpdatingAtPath:writingFile];  
        self.curWritingFile = writingFile;
    }
    [self.mainHandle seekToEndOfFile];
}

-(BOOL)verifyFileNeedMove
{
    NSDictionary* dic = [[NSFileManager defaultManager] fileAttributesAtPath:curWritingFile traverseLink:YES];
    NSNumber* fileSizeNumber = [dic valueForKey:NSFileSize];
    if ([fileSizeNumber intValue]>ProjectLogMaxFileSize)
    {
        return YES;
    }
    else {
        NSNumber* oldIntervalNumber = [[RegValueSaver getInstance] readSystemInfoForKey:ProjectLogLastUploadDateKey];
        if (!oldIntervalNumber) {
            NSTimeInterval oldInterval = [[NSDate date] timeIntervalSince1970];
            oldIntervalNumber = [NSNumber numberWithDouble:oldInterval];
            [[RegValueSaver getInstance] saveSystemInfoValue:oldIntervalNumber forKey:ProjectLogLastUploadDateKey encryptString:NO];
        }
        NSTimeInterval oldInterval = [oldIntervalNumber doubleValue];
        NSTimeInterval newInterval = [[NSDate date] timeIntervalSince1970];
        if (abs(newInterval-oldInterval)>ProjectLogMaxLocalTimeInterval) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

-(void)adjustFileForUploader
{
    if ([self verifyFileNeedMove]) {
        NSArray* documentPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentPath = [documentPathArray objectAtIndex:0];
        NSString* cachePath = [documentPath stringByAppendingPathComponent:ProjectLogUploaderFolder];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        NSString* logFileName = [NSString stringWithFormat:@"%@.log",[MyTool stringWithUUID]];
        NSString* newFileString = [cachePath stringByAppendingPathComponent:logFileName];
        while ([[NSFileManager defaultManager] fileExistsAtPath:newFileString]) {
            logFileName = [NSString stringWithFormat:@"%@.log",[MyTool stringWithUUID]];
            newFileString = [cachePath stringByAppendingPathComponent:logFileName];
        }
        [self.mainHandle closeFile];
        self.mainHandle = nil;
        [[NSFileManager defaultManager] moveItemAtPath:self.curWritingFile toPath:newFileString error:NULL];
        NSTimeInterval newInterval = [[NSDate date] timeIntervalSince1970];
        [[RegValueSaver getInstance] saveSystemInfoValue:[NSNumber numberWithFloat:newInterval] forKey:ProjectLogLastUploadDateKey encryptString:NO];
        [self adjustFileHandleForWrite];
        self.needUploader = [NSNumber numberWithBool:YES];
    }
}


@end
