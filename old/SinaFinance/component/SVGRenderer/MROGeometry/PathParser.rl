//
//  PathParser.m
//
//  Created by Marcus Rohrmoser on 11.03.10.
//  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
//

#import "PathParser.h"
#import "PathBuilder.h"

//#ifdef MRLogD
//#undef MRLogD
//#endif
//
//// No Logging
//#define MRLogD(x,...)                             /* NSLog(x,##__VA_ARGS__) */

// http://blog.mro.name/2010/06/xcode-missing-deprecated-warnings/
#define alloc(c)        ( (c *)[c alloc] )


/** <a href="http://research.cs.queensu.ca/~thurston/ragel/">Ragel</a> parser 
 * for <a href="http://www.w3.org/TR/SVG11/paths.html#PathDataBNF">paths</a> 
 * This file is auto-generated
 * <p>
 * DO NOT EDIT MANUALLY!!!
 * </p>
 * See also https://lib2geom.svn.sourceforge.net/svnroot/lib2geom/lib2geom/trunk/src/2geom/svg-path-parser.rl
 */
@implementation PathParser

%%{

	machine path;

	#######################################################
	## Define the actions
	#######################################################

	action start_number {
		start = p;
	}

	action push_number {
		char *endmark = (char*)p;
		const char c = *endmark;
		*endmark = '\0';
		argv[argc++] = strtod(start, NULL);
		*endmark = c;
		start = NULL;
	}

	action push_true {
		if(YES)
			[NSException raise:@"ragel action push_true isn't implemented yet." format:@""];
	}

	action push_false {
		if(YES)
			[NSException raise:@"ragel action push_false isn't implemented yet." format:@""];
	}

	action mode_abs {
		absolute = YES;
	}

	action mode_rel {
		absolute = NO;
	}
    
	action moveto {
		[pb moveToAbsolute:absolute x:argv[0] y:argv[1]];
		argc = 0;
	}    

	action lineto {
		[pb lineToAbsolute:absolute x:argv[0] y:argv[1]];
		argc = 0;
	}

	action horizontal_lineto {
		[pb hlineToAbsolute:absolute x:argv[0]];
		argc = 0;
	}

	action vertical_lineto {
		[pb vlineToAbsolute:absolute y:argv[0]];
		argc = 0;
	}

	action curveto {
		[pb cubicToAbsolute:absolute x1:argv[0] y1:argv[1] x2:argv[2] y2:argv[3] x3:argv[4] y3:argv[5] ];
		argc = 0;
	}

	action smooth_curveto {
		[pb smoothCubicToAbsolute:absolute x2:argv[0] y2:argv[1] x3:argv[2] y3:argv[3] ];
		argc = 0;
	}

	action quadratic_bezier_curveto {
		[pb quadToAbsolute:absolute x1:argv[0] y1:argv[1] x2:argv[2] y2:argv[3] ];
		argc = 0;
	}

	action smooth_quadratic_bezier_curveto {
		[pb smoothQuadToAbsolute:absolute x2:argv[0] y2:argv[1] ];
		argc = 0;
	}

	action elliptical_arc {
		if(YES)
			[NSException raise:@"ragel action elliptical_arc isn't implemented yet." format:@""];
		argc = 0;
	}
        
	action closepath {
		[pb closePath];		
	}

	#######################################################
	## Define the grammar
	#######################################################

		wsp = (' ' | 9 | 10 | 13);
        sign = ('+' | '-');
        digit_sequence = digit+;
        exponent = ('e' | 'E') sign? digit_sequence;
        fractional_constant =
            digit_sequence? '.' digit_sequence
            | digit_sequence '.';
        floating_point_constant =
            fractional_constant exponent?
            | digit_sequence exponent;
        integer_constant = digit_sequence;
        comma = ',';
        comma_wsp = (wsp+ comma? wsp*) | (comma wsp*);

        flag = ('0' %push_false | '1' %push_true);
        
        number =
            ( sign? integer_constant
            | sign? floating_point_constant )
            >start_number %push_number;

        nonnegative_number =
            ( integer_constant
            | floating_point_constant)
            >start_number %push_number;

        coordinate = number $(number,1) %(number,0);
        coordinate_pair = (coordinate $(coordinate_pair_a,1) %(coordinate_pair_a,0) comma_wsp? coordinate $(coordinate_pair_b,1) %(coordinate_pair_b,0)) $(coordinate_pair,1) %(coordinate_pair,0);
        elliptical_arc_argument =
            (nonnegative_number $(elliptical_arg_a,1) %(elliptical_arg_a,0) comma_wsp?
             nonnegative_number $(elliptical_arg_b,1) %(elliptical_arg_b,0) comma_wsp?
             number comma_wsp
             flag comma_wsp flag comma_wsp
             coordinate_pair)
            %elliptical_arc;
        elliptical_arc_argument_sequence =
            elliptical_arc_argument $1 %0
            (comma_wsp? elliptical_arc_argument $1 %0)*;
        elliptical_arc =
            ('A' %mode_abs| 'a' %mode_rel) wsp*
            elliptical_arc_argument_sequence;
        
        smooth_quadratic_bezier_curveto_argument =
            coordinate_pair %smooth_quadratic_bezier_curveto;
        smooth_quadratic_bezier_curveto_argument_sequence =
            smooth_quadratic_bezier_curveto_argument $1 %0
            (comma_wsp?
             smooth_quadratic_bezier_curveto_argument $1 %0)*;
        smooth_quadratic_bezier_curveto =
            ('T' %mode_abs| 't' %mode_rel) wsp*
             smooth_quadratic_bezier_curveto_argument_sequence;

        quadratic_bezier_curveto_argument =
            (coordinate_pair $1 %0 comma_wsp? coordinate_pair)
            %quadratic_bezier_curveto;
        quadratic_bezier_curveto_argument_sequence =
            quadratic_bezier_curveto_argument $1 %0
            (comma_wsp? quadratic_bezier_curveto_argument $1 %0)*;
        quadratic_bezier_curveto =
            ('Q' %mode_abs| 'q' %mode_rel) wsp* 
            quadratic_bezier_curveto_argument_sequence;

        smooth_curveto_argument =
            (coordinate_pair $1 %0 comma_wsp? coordinate_pair)
            %smooth_curveto;
        smooth_curveto_argument_sequence =
            smooth_curveto_argument $1 %0
            (comma_wsp? smooth_curveto_argument $1 %0)*;
        smooth_curveto =
            ('S' %mode_abs| 's' %mode_rel)
            wsp* smooth_curveto_argument_sequence;

        curveto_argument =
            (coordinate_pair $1 %0 comma_wsp?
             coordinate_pair $1 %0 comma_wsp?
             coordinate_pair) 
            %curveto;
        curveto_argument_sequence =
            curveto_argument $1 %0
            (comma_wsp? curveto_argument $1 %0)*;
        curveto =
            ('C' %mode_abs| 'c' %mode_rel)
            wsp* curveto_argument_sequence;

        vertical_lineto_argument = coordinate %vertical_lineto;
        vertical_lineto_argument_sequence =
            vertical_lineto_argument $(vertical_lineto_argument_a,1) %(vertical_lineto_argument_a,0)
            (comma_wsp? vertical_lineto_argument $(vertical_lineto_argument_b,1) %(vertical_lineto_argument_b,0))*;
        vertical_lineto =
            ('V' %mode_abs| 'v' %mode_rel)
            wsp* vertical_lineto_argument_sequence;

        horizontal_lineto_argument = coordinate %horizontal_lineto;
        horizontal_lineto_argument_sequence =
            horizontal_lineto_argument $(horizontal_lineto_argument_a,1) %(horizontal_lineto_argument_a,0)
            (comma_wsp? horizontal_lineto_argument $(horizontal_lineto_argument_b,1) %(horizontal_lineto_argument_b,0))*;
        horizontal_lineto =
            ('H' %mode_abs| 'h' %mode_rel)
            wsp* horizontal_lineto_argument_sequence;

        lineto_argument = coordinate_pair %lineto;
        lineto_argument_sequence =
            lineto_argument $1 %0
            (comma_wsp? lineto_argument $1 %0)*;
        lineto =
            ('L' %mode_abs| 'l' %mode_rel) wsp*
            lineto_argument_sequence;

        closepath = ('Z' | 'z') %closepath;

        moveto_argument = coordinate_pair %moveto;
        moveto_argument_sequence =
            moveto_argument $1 %0
            (comma_wsp? lineto_argument $1 %0)*;
        moveto =
            ('M' %mode_abs | 'm' %mode_rel)
            wsp* moveto_argument_sequence;

        drawto_command =
            closepath | lineto |
            horizontal_lineto | vertical_lineto |
            curveto | smooth_curveto |
            quadratic_bezier_curveto |
            smooth_quadratic_bezier_curveto |
            elliptical_arc;

        drawto_commands = drawto_command (wsp* drawto_command)*;
        moveto_drawto_command_group = moveto wsp* drawto_commands?;
        moveto_drawto_command_groups =
            moveto_drawto_command_group
            (wsp* moveto_drawto_command_group)*;

        svg_path = wsp* moveto_drawto_command_groups? wsp*;

        main := svg_path;
}%%

%% write data;
	
-(CGPathRef)parseChar:(const char*)data length:(int)length trafo:(CGAffineTransform*)trafo error:(NSError**)errPtr
{
	//DEBUG_TIMER_START();
	// MRLogD(@"");
	PathBuilder *pb = [[alloc(PathBuilder) initWithTrafo:trafo] autorelease];
	if(data == NULL)
		return CGPathRetain([pb toPath]);
//	high-level buffers
	const char *start = NULL;
	CGFloat argv[] = {0,1,2,3,4,5,6,7};
	int argc = 0;
	BOOL absolute = YES;
	
//	ragel variables (low level)
	const char *p = data;
	const char *pe = data + length; // pointer "end"
	const char *eof = pe;
	int cs = 0;
//	int top;

///////////////////////////////////////////////////////////
//	init ragel
	%% write init;
///////////////////////////////////////////////////////////
//	exec ragel
	%% write exec;

	if ( errPtr != nil && cs < path_first_final )
		*errPtr = [self parseError:data position:p];

   // DEBUG_TIMER_LOG();
	return CGPathRetain([pb toPath]);
}

-(CGPathRef)parseString:(NSString*)data trafo:(CGAffineTransform*)trafo error:(NSError**)errPtr
{
    const char *c = [data UTF8String];
    const int len = strlen(c);
    return [self parseChar:c length:len trafo:trafo error:errPtr];
}

-(CGPathRef)parseString:(NSString*)data error:(NSError**)errPtr
{
    return [self parseString:data trafo:NULL error:errPtr];
}

@end