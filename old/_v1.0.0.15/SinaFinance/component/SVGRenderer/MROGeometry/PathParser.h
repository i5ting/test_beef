//
//  PathParser.h
//
//  Created by Marcus Rohrmoser on 11.03.10.
//  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
//

#import "RagelParser.h"
#import <CoreGraphics/CGPath.h>
#import <CoreGraphics/CGAffineTransform.h>

/** Parser for <a href="http://www.w3.org/TR/SVG11/paths.html#PathDataBNF">SVG path elements</a>.
 *
 * The implementation is generated via <a href="http://research.cs.queensu.ca/~thurston/ragel/">Ragel</a>
 * from ../ragel/PathParser.rl.
 *
 * <b>DO NOT EDIT PathParser.m MANUALLY!!!</b>
 *
 * See also https://lib2geom.svn.sourceforge.net/svnroot/lib2geom/lib2geom/trunk/src/2geom/svg-path-parser.rl
 */
@interface PathParser : RagelParser {}

#if 0
/** Do the actual parsing. Stateless and reentrant.
 * @param data content of a svg path element's 'd' attribute.
 * @param errPtr out parameter to report parsing problems.
 * @return a retained core graphics path.
 */
-(CGPathRef)parseString:(NSString *)data error:(NSError **)errPtr;
#endif

/** Do the actual parsing. Stateless and reentrant.
 * @param data content of a svg path element's 'd' attribute.
 * @param trafo may be NULL
 * @param errPtr out parameter to report parsing problems.
 * @return a retained core graphics path.
 */
-(CGPathRef)parseString:(NSString *)data trafo:(CGAffineTransform *)trafo error:(NSError **)errPtr;

#if 1
/** Do the actual parsing. Stateless and reentrant.
 * @param data content of a svg path element's 'd' attribute.
 * @param length number of max. baytes to read
 * @param errPtr out parameter to report parsing problems.
 * @return a retained core graphics path.
 */
-(CGPathRef)parseChar:(const char *)data length:(int)length trafo:(CGAffineTransform *)trafo error:(NSError **)errPtr;
#endif

@end