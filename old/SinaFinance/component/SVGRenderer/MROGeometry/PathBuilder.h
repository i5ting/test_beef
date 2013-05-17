//
//  PathBuilder.h
//
//  Created by Marcus Rohrmoser on 11.03.10.
//  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
//

#import <CoreGraphics/CGPath.h>
#import <CoreGraphics/CGAffineTransform.h>

/** Internal Helper for PathParser. As the PathParser sources stem from a ragel PathParser.rl file
 * that means a break in the toolchain and therefore I try to keep it's complexity as low as possible.
 */
@interface PathBuilder : NSObject
{
	CGAffineTransform *trafo;
	CGMutablePathRef gp;
	//	last control point for the smooth curveTo and quadTo
	CGFloat ox;
	CGFloat oy;
	//	last point
	CGFloat px;
	CGFloat py;
}


-(id)initWithTrafo:(CGAffineTransform *)trafo;

/**
 * http://www.w3.org/TR/SVG11/paths.html#PathDataClosePathCommand
 */
-(void)closePath;

/**
 * http://www.w3.org/TR/SVG11/paths.html#PathDataCubicBezierCommands
 */
-(void)cubicToAbsolute:(BOOL)abs x1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 x3:(CGFloat)x3 y3:(CGFloat)y3;

/**
 * http://www.w3.org/TR/SVG11/paths.html#PathDataLinetoCommands
 */
-(void)lineToAbsolute:(BOOL)abs x:(CGFloat)x y:(CGFloat)y;

/**
 * http://www.w3.org/TR/SVG11/paths.html#PathDataLinetoCommands
 */
-(void)hlineToAbsolute:(BOOL)abs x:(CGFloat)x;

/**
 * http://www.w3.org/TR/SVG11/paths.html#PathDataMovetoCommands
 */
-(void)moveToAbsolute:(BOOL)abs x:(CGFloat)x y:(CGFloat)y;

/**
 * http://www.w3.org/TR/SVG11/paths.html#PathDataQuadraticBezierCommands
 */
-(void)quadToAbsolute:(BOOL)abs x1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2;

/**
 * http://www.w3.org/TR/SVG11/paths.html#PathDataCubicBezierCommands
 */
-(void)smoothCubicToAbsolute:(BOOL)abs x2:(CGFloat)x2 y2:(CGFloat)y2 x3:(CGFloat)x3 y3:(CGFloat)y3;

/**
 * http://www.w3.org/TR/SVG11/paths.html#PathDataQuadraticBezierCommands
 */
-(void)smoothQuadToAbsolute:(BOOL)abs x2:(CGFloat)x2 y2:(CGFloat)y2;

-(CGPathRef)toPath;

/**
 * http://www.w3.org/TR/SVG11/paths.html#PathDataLinetoCommands
 */
-(void)vlineToAbsolute:(BOOL)abs y:(CGFloat)y;

@end