/*
 *  CGPathReader.h
 *
 *  Created by Marcus Rohrmoser on 13.11.10.
 *  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
 *
 */

#include <CoreGraphics/CGPath.h>
#include <CoreFoundation/CFError.h>

/** Parse the svg path and return a retained CGPathRef.
 * Currently just a C-wrapper around PathParser::parseChar:length:trafo:error:
 * but might become plain C some day.
 * @param path the svg <path d="..."> data
 * @param error pointer to a CFError/NSError object
 * @return a retained CGPathRef
 */
CGPathRef CGPathCreateFromSVG(const char *path, CFErrorRef *error);