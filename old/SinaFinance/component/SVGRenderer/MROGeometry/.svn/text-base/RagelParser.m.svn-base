//
//  RagelParser.m
//
//  Created by Marcus Rohrmoser on 11.03.10.
//  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
//

#import "RagelParser.h"

#ifdef MRLogD
#undef MRLogD
#endif

// No Logging
#define MRLogD(x, ...)                             /* NSLog(x,##__VA_ARGS__) */

@implementation RagelParser

-(NSError *)parseError:(const char *)data position:(const char *)p
{
	MRLogD(@"%s", data);
	NSDictionary *ui = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Couldn't parse transform '%s' - failed at %d", data, p - data], NSLocalizedDescriptionKey,
			    nil];
	return [NSError errorWithDomain:RAGEL_ERROR_DOMAIN code:RAGEL_ERROR_CODE userInfo:ui];
}


@end