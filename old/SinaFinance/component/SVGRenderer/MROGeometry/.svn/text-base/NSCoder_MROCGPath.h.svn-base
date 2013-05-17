//
//  NSCoder_MROCGPath.h
//
//  Created by Marcus Rohrmoser on 26.10.10.
//  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
//


/** Persist a CGPath using the SVG path format as ASCII/C String
 * http://www.w3.org/TR/SVG11/paths.html#PathDataBNF .
 * @see CGPathToCString(CGPathRef p, size_t c, size_t i)
 * @see PathParser
 */
@interface NSCoder (MROCGPath)

-(void)encodeCGPath:(CGPathRef)value forKey:(NSString *)key;
-(CGPathRef)decodeCGPathForKey:(NSString *)key;

@end