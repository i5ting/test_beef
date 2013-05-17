/*
 *  MROCGPointMath.h
 *
 *  Created by Marcus Rohrmoser on 21.09.10.
 *  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
 *
 */

#include <CoreGraphics/CGGeometry.h>

/// Similar to http://developer.apple.com/library/ios/documentation/Accelerate/Reference/vDSPRef/Reference/reference.html#//apple_ref/c/func/vDSP_vsadd
CGPoint CGPointAdd(const CGPoint a, const CGPoint b);

CGPoint CGPointSub(const CGPoint a, const CGPoint b);

/// Similar to http://developer.apple.com/library/ios/documentation/Accelerate/Reference/vDSPRef/Reference/reference.html#//apple_ref/c/func/vDSP_vsmul
CGPoint CGPointMul(const CGPoint a, const CGFloat f);

/// Similar to http://developer.apple.com/library/ios/documentation/Accelerate/Reference/vDSPRef/Reference/reference.html#//apple_ref/c/func/vDSP_dotpr
CGFloat CGPointDotPr(const CGPoint a, const CGPoint b);

CGFloat CGPointAbsSqr(const CGPoint a);

/// Similar to http://developer.apple.com/library/ios/documentation/Accelerate/Reference/vDSPRef/Reference/reference.html#//apple_ref/c/func/vDSP_vabs
CGFloat CGPointAbs(const CGPoint a);

int CGPointDistanceSmallerThan(const CGPoint a, const CGPoint b, const CGFloat radius);