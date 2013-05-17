/*
 *  CGPathWriter.c
 *
 *  Created by Marcus Rohrmoser on 15.10.10.
 *  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
 *
 */

#include "CGPathWriter.h"
#include "stdlib.h"
#include "assert.h"
#include "limits.h"
#include "stdarg.h"
#include "stdio.h"

#if !defined(MAX)
#define MAX(A, B)        ({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? __b : __a; } \
			  )
#endif

#ifndef MRLogD
#define MRLogD(x, ...)
#endif

/// internal, temporary helper struct
struct CGPathWriter_t {
	char *buffer;
	size_t allocated;
	size_t used;
	size_t increment;
};
/// internal, temporary helper struct
typedef struct CGPathWriter_t CGPathWriter_t;

/// internal, re-allocating snprintf helper
void CGPathWriter_snprintf(CGPathWriter_t *const t, char *fmt, ...)
{
	assert(t != NULL);
	for (;; ) {
		if ( t->buffer == NULL )
			return;
		assert(t->used >= 0);
		assert(t->allocated >= t->used);
		const size_t max = t->allocated - t->used;

		// http://stackoverflow.com/questions/498705/create-a-my-printf-that-sends-data-to-both-a-sprintf-and-the-normal-printf
		va_list ap;
		va_start(ap, fmt);
		const int len = vsnprintf(t->buffer + t->used, max, fmt, ap);
		va_end(ap);
		assert(len >= 0);

		if ( len >= max ) {
			assert(t->increment >= 0);
			const size_t inc = MAX(len - max + 1, t->increment);
			assert(t->allocated < INT_MAX - inc);
			// fprintf(stderr, "CGPathToCString::re-allocating %zu\n", inc);
			t->buffer = reallocf(t->buffer, t->allocated += inc);
			assert(t->allocated > t->used);
			t->buffer[t->used] = '\0';
			assert(t->buffer[t->used] == '\0');
		} else {
			t->used += len;
			return;
		}
	}
}


/// internal Helper
void CGPathWriter_path_walker(void *info, const CGPathElement *elm)
{
	assert(info != NULL);
	CGPathWriter_t *const t = (CGPathWriter_t *)info;
	if ( t->buffer == NULL )
		return;
	switch ( elm->type ) {
	case kCGPathElementMoveToPoint:
		CGPathWriter_snprintf(t, "M%f,%f", elm->points[0].x, elm->points[0].y);
		break;
	case kCGPathElementAddLineToPoint:
		CGPathWriter_snprintf(t, "L%f,%f", elm->points[0].x, elm->points[0].y);
		break;
	case kCGPathElementAddQuadCurveToPoint:
		CGPathWriter_snprintf(t, "Q%f,%f,%f,%f", elm->points[0].x, elm->points[0].y, elm->points[1].x, elm->points[1].y);
		break;
	case kCGPathElementAddCurveToPoint:
		CGPathWriter_snprintf(t, "C%f,%f,%f,%f,%f,%f", elm->points[0].x, elm->points[0].y, elm->points[1].x, elm->points[1].y, elm->points[2].x, elm->points[2].y);
		break;
	case kCGPathElementCloseSubpath:
		CGPathWriter_snprintf(t, "Z");
		break;
	default:
		fprintf(stderr, "Switch-case-fallthrough\n");
		assert(0);
		break;
	}
}


char *CGPathToCString(const CGPathRef p, const size_t capacity, const size_t increment)
{
	if ( p == NULL )
		return NULL;
	CGPathWriter_t t;
	t.allocated = MAX(0, capacity);
	t.increment = MAX(0, increment);
	t.buffer = malloc(t.allocated);
	if ( t.buffer != NULL )
		t.buffer[0] = '\0';
	t.used = 0;

	CGPathApply(p, &t, CGPathWriter_path_walker);

	return t.buffer;
}