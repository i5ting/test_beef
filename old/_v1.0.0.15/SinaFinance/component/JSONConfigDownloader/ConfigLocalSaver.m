//
//  ConfigLocalSaver.m
//  SinaFinance
//
//  Created by shieh exbice on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ConfigLocalSaver.h"
#import "JSONKit.h"
#import "MyTool.h"

@implementation ConfigLocalSaver

-(void)mergeAndSaveFromBundle
{
    NSString* path = [[NSBundle mainBundle] bundlePath];
    NSArray* dictArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    NSMutableDictionary* totalDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSString* oneFile in dictArray) {
        NSString* filePath = [path stringByAppendingPathComponent:oneFile];
        if ([[filePath lowercaseString] hasSuffix:@".json"]) {
            NSError* error;
            NSString* contentString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
            if (!contentString) {
                contentString = [NSString stringWithContentsOfFile:filePath encoding:NSUnicodeStringEncoding error:&error];
            }
            if (contentString) {
                contentString = [contentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if ([contentString hasPrefix:@"/*"]) {
                    NSRange annotationRange = [contentString rangeOfString:@"*/"];
                    if (annotationRange.location!=NSNotFound) {
                        contentString = [contentString substringFromIndex:annotationRange.location+annotationRange.length];
                    }
                }
            }
            
            id contentArray = [contentString objectFromJSONString];
            if (contentArray) {
                [totalDict setValue:contentArray forKey:oneFile];
            }
        }
    }
    NSString* totalString = [totalDict JSONString];
    [MyTool writeToDocument:totalString folder:nil fileName:@"ConfigLocalSaver.json"];
    [totalDict release];
}

-(BOOL)spliteAndSaveWithString:(NSString*)string
{
    BOOL rtval = NO;
    NSArray* documentPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [documentPathArray objectAtIndex:0];
    NSString* configStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([configStr hasPrefix:@"/*"]) {
        NSRange annotationRange = [configStr rangeOfString:@"*/"];
        if (annotationRange.location!=NSNotFound) {
            configStr = [configStr substringFromIndex:annotationRange.location+annotationRange.length];
        }
    }
    
    NSDictionary* configDict = [configStr objectFromJSONString];
    if (configDict&&[configDict isKindOfClass:[NSDictionary class]])
    {
        BOOL hasError = NO;
        NSArray* allKeys = [configDict allKeys];
        for (NSString* oneFileName in allKeys) {
            id oneConfigData = [configDict valueForKey:oneFileName];
            NSString* saveFilePath = [documentPath stringByAppendingPathComponent:oneFileName];
            NSString* dataString = [oneConfigData JSONString];
            BOOL ret = [dataString writeToFile:saveFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            if (!ret) {
                hasError = YES;
            }
        }
        if (!hasError) {
            rtval = YES;
        }
    }
    return rtval;
}

@end
