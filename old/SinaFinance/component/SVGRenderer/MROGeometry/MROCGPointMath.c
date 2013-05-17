/*
 *  MROCGPointMath.c
 *
 *  Created by Marcus Rohrmoser on 21.09.10.
 *  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
 *
 */

#include "MROCGPointMath.h"
#include <math.h>


CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
	return CGPointMake(a.x + b.x, a.y + b.y);
}


CGPoint CGPointSub(const CGPoint a, const CGPoint b)
{
	return CGPointMake(a.x - b.x, a.y - b.y);
}


CGPoint CGPointMul(const CGPoint a, const CGFloat f)
{
	return CGPointMake(f * a.x, f * a.y);
}


CGFloat CGPointDotPr(const CGPoint a, const CGPoint b)
{
	return a.x * b.x + a.y * b.y;
}


#if !defined(SQR)
#define SQR(x) ( (x) * (x) )
#else
#error "SQR already defined."
#endif


CGFloat CGPointAbsSqr(const CGPoint a)
{
	return CGPointDotPr(a, a);
}


CGFloat CGPointAbs(const CGPoint a)
{
	return sqrt( CGPointAbsSqr(a) );
}


#if !defined(ABS)
#define ABS(A)  ({ __typeof__(A) __a = (A); __a < 0 ? -__a : __a; } \
		 )
#else
#error "ABS already defined."
#endif


int CGPointDistanceSmallerThan(const CGPoint a, const CGPoint b, const CGFloat radius)
{
	const CGFloat dx = ABS(a.x - b.x);
	if ( dx > radius )
		return 0 == 1;
	const CGFloat dy = ABS(a.y - b.y);
	if ( dy > radius )
		return 0 == 1;
	return SQR(dx) + SQR(dy) < SQR(radius);
}