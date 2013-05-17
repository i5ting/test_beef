//
//  TrafoParser.h
//
//  Created by Marcus Rohrmoser on 11.03.10.
//  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
//

#import "RagelParser.h"

/** Parser for <a href="http://www.w3.org/TR/SVG11/coords.html#TransformAttribute">SVG transform attributes</a>.
 *
 * The implementation is generated via <a href="http://research.cs.queensu.ca/~thurston/ragel/">Ragel</a>
 * from ../ragel/TrafoParser.rl.
 *
 * <b>DO NOT EDIT TrafoParser.m MANUALLY!!!</b>
 *
 * See also https://lib2geom.svn.sourceforge.net/svnroot/lib2geom/lib2geom/trunk/src/2geom/svg-path-parser.rl
 */
@interface TrafoParser : RagelParser {}

/** Do the actual parsing. Stateless and reentrant.
 * @param data content of a svg transform attribute.
 * @param errPtr out parameter to report parsing problems.
 * @return a core graphics transformation.
 */
-(CGAffineTransform)parseString:(NSString *)data error:(NSError **)errPtr;

#if 0
-(CGAffineTransform)parseChar:(const char *)data length:(int)length error:(NSError **)errPtr;
#endif

@end