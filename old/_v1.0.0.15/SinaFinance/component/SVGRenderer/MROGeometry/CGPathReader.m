//
//  CGPathReader.c
//
//  Created by Marcus Rohrmoser on 11.03.10.
//  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
//

#import "CGPathReader.h"
#import "PathParser.h"

// http://blog.mro.name/2010/06/xcode-missing-deprecated-warnings/
#define alloc(c)        ( (c *)[c alloc] )

CGPathRef CGPathCreateFromSVG(const char *path, CFErrorRef *errPtr)
{
	if ( path == NULL )
		return NULL;
	const size_t len = strlen(path);
	// #FIXME check overflow
	PathParser *p = [alloc (PathParser)init];
	CGPathRef ret = [p parseChar:path length:len trafo:NULL error:(NSError **)errPtr];
	[p release];
	return ret;
}