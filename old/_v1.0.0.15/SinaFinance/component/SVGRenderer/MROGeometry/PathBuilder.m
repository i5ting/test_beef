//
//  PathBuilder.m
//
//  Created by Marcus Rohrmoser on 11.03.10.
//  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
//

#import "PathBuilder.h"

#ifdef NSLogD
#undef NSLogD
#endif

// No Logging
#define NSLogD(x, ...)                             /* NSLog(x,##__VA_ARGS__) */

@implementation PathBuilder

-(id)initWithTrafo:(CGAffineTransform *)trafo_
{
	if ( (self = [super init]) ) {
		trafo = trafo_;
		gp = CGPathCreateMutable();
		//		last control point for the smooth curveTo and quadTo
		ox = oy = 0.0;
		//		last point
		px = py = 0.0;
	}
	return self;
}


-(void)dealloc
{
	CGPathRelease(gp);
	[super dealloc];
}


-(void)closePath
{
	CGPathCloseSubpath(gp);
}


-(void)cubicToAbsolute:(BOOL)abs x1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 x3:(CGFloat)x3 y3:(CGFloat)y3
{
	NSLogD(@"[PathBuilder cubicToAbsolute:%d (%f,%f) (%f,%f) (%f,%f)]", abs, x1, y1, x2, y2, x3, y3);
	if ( !abs ) {
		x1 += px;
		y1 += py;
		x2 += px;
		y2 += py;
		x3 += px;
		y3 += py;
	}
	CGPathAddCurveToPoint(gp, trafo, x1, y1, x2, y2, x3, y3);
	ox = px;
	oy = py;
	px = x3;
	py = y3;
}


-(void)lineToAbsolute:(BOOL)abs x:(CGFloat)x y:(CGFloat)y
{
	NSLogD(@"[PathBuilder lineToAbsolute:%d]", abs);
	if ( !abs ) {
		x += px;
		y += py;
	}
	CGPathAddLineToPoint(gp, trafo, x, y);
	ox = px;
	oy = py;
	px = x;
	py = y;
}


-(void)hlineToAbsolute:(BOOL)abs x:(CGFloat)x
{
	NSLogD(@"[PathBuilder hlineToAbsolute:%d]", abs);
	[self lineToAbsolute:abs x:x y:(abs ? py:0)];
}


-(void)moveToAbsolute:(BOOL)abs x:(CGFloat)x y:(CGFloat)y
{
	NSLogD(@"[PathBuilder moveToAbsolute:%d (%f,%f)]", abs, x, y);
	if ( !abs ) {
		x += px;
		y += py;
	}
	CGPathMoveToPoint(gp, trafo, x, y);
	ox = px;
	oy = py;
	px = x;
	py = y;
}


-(void)quadToAbsolute:(BOOL)abs x1:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2
{
	NSLogD(@"[PathBuilder quadToAbsolute:%d]", abs);
	if ( !abs ) {
		x1 += px;
		y1 += py;
		x2 += px;
		y2 += py;
	}
	CGPathAddQuadCurveToPoint(gp, trafo, x1, y1, x2, y2);
	ox = px;
	oy = py;
	px = x2;
	py = y2;
}


-(void)smoothCubicToAbsolute:(BOOL)abs x2:(CGFloat)x2 y2:(CGFloat)y2 x3:(CGFloat)x3 y3:(CGFloat)y3
{
	NSLogD(@"[PathBuilder smoothCubicToAbsolute:%d]", abs);
	CGFloat x1;
	CGFloat y1;
	if ( abs ) {
		x1 = 2 * px - ox;
		y1 = 2 * py - oy;
	} else {
		//		@todo verify!
		x1 = px - ox;
		y1 = py - oy;
	}
	[self cubicToAbsolute:abs x1:x1 y1:y1 x2:x2 y2:y2 x3:x3 y3:y3];
}


-(void)smoothQuadToAbsolute:(BOOL)abs x2:(CGFloat)x2 y2:(CGFloat)y2
{
	NSLogD(@"[PathBuilder smoothQuadToAbsolute:%d]", abs);
	CGFloat x1;
	CGFloat y1;
	if ( abs ) {
		x1 = 2 * px - ox;
		y1 = 2 * py - oy;
	} else {
		//		@todo verify!
		x1 = px - ox;
		y1 = py - oy;
	}
	[self quadToAbsolute:abs x1:x1 y1:y1 x2:x2 y2:y2];
}


/// returns an unretained reference!
-(CGPathRef)toPath
{
	return gp;
}


-(void)vlineToAbsolute:(BOOL)abs y:(CGFloat)y
{
	NSLogD(@"[PathBuilder vlineToAbsolute:%d]", abs);
	[self lineToAbsolute:abs x:(abs ? px:0) y:y];
}


@end