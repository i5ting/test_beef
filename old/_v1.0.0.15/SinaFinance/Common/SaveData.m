//
//  SaveData.m
//  CubeGame
//
//  Created by BeiZ  on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SaveData.h"


@implementation SaveData

+ (NSString*)getFilePath:(NSString*)keyValue
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:keyValue];
}

+ (void)saveDataForKey:(NSString*)keyValue data:(NSObject*)savedData
{
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[archiver encodeObject:savedData forKey:keyValue];
	[archiver finishEncoding];
	
	[data writeToFile:[self getFilePath:keyValue] atomically:YES];
	[archiver release];
	[data release];
}

+ (NSObject*)getDataForKey:(NSString*)keyValue
{
	NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self getFilePath:keyValue]];
	if(data == nil)
		return nil;
	
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	
	NSObject *record = [unarchiver decodeObjectForKey:keyValue];
	
	[data release];
	[unarchiver release];	
	
	return record;
}

@end
