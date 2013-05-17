//
//  NSCoder_MROCGPath.m
//
//  Created by Marcus Rohrmoser on 26.10.10.
//  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
//

#import "NSCoder_MROCGPath.h"
#import "CGPathWriter.h"
#import "PathParser.h"

// http://blog.mro.name/2010/06/xcode-missing-deprecated-warnings/
#define alloc(c)        ( (c *)[c alloc] )

@implementation NSCoder (MROCGPath)


-(void)encodeCGPath:(CGPathRef)value forKey:(NSString *)key
{
	char *buf = CGPathToCString(value, 256, 256);
	if ( buf == NULL )
		return;
	//MRLogD(@"Encode CGPath Buffer[%d]: '%s'", strlen(buf) + 1, buf);
	NSAssert(buf[strlen(buf)] == '\0', @"");
	[self encodeObject:[NSString stringWithCString:buf encoding:NSASCIIStringEncoding] forKey:key];
	free(buf);
}


-(CGPathRef)decodeCGPathForKey:(NSString *)key
{
	NSString *buf = [self decodeObjectForKey:key];
	//MRLogD(@"Decode CGPath Buffer[%d]: '%s'", len, buf);
	PathParser *pp = [alloc (PathParser)init];
	NSError *err = nil;
	CGPathRef p = [pp parseString:buf trafo:NULL error:&err];
	//	MRLogD(@"Error: %@", err);
	NSAssert(p != NULL, @"");
	NSAssert(err == nil, @"");
	[pp release];
	return p;
}


@end