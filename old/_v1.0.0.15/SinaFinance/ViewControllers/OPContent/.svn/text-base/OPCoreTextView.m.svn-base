//
//  OPCoreTextView.m
//  OPCoreText
//
//  Created by Sun Guanglei on 12-9-12.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "OPCoreTextView.h"
#import "UIImageView+AFNetworking.h"

@implementation OPCoreTextView
@synthesize contentString = _contentString;
@synthesize images;
@synthesize imageDelegate;
@synthesize nightMode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.scrollsToTop = NO;
    }
    return self;
}

-(void)setNightMode:(BOOL)anightMode
{
    nightMode = anightMode;
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawRect");
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable(); //1
    CGPathAddRect(path, NULL, self.bounds );
    
//    NSAttributedString* attString = [[[NSAttributedString alloc]
//                                      initWithString:@"Hello core text world!\nTest \n\nTest"] autorelease]; //2
    
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_contentString); //3
    CTFrameRef frame =
    CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [_contentString length]), path, NULL);
    
    CTFrameDraw(frame, context); //4
    
//    [self drawImages:frame context:context];
    
    CFRelease(frame); //5
    CFRelease(path);
    CFRelease(framesetter);
    
//    for (NSDictionary* imageData in self.images) {
//        UIImage* img = [imageData objectForKey:@"name"];
////        CGRect imgBounds = CGRectFromString([imageData objectForKey:@":1]);
////        CGContextDrawImage(context, imgBounds, img.CGImage);
//    }
}
                                             
- (void)drawImages:(CTFrameRef)aFrame context:(CGContextRef)context
{
    //drawing images
    NSArray *lines = (NSArray *)CTFrameGetLines(aFrame); //1
    
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(aFrame, CFRangeMake(0, 0), origins); //2
    
    int imgIndex = 0; //3
    NSDictionary* nextImage = [self.images objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    
    //find images for the current column
    CFRange frameRange = CTFrameGetVisibleStringRange(aFrame); //4
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[self.images count]) return; //quit if no images for this column
        nextImage = [self.images objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) { //5
        CTLineRef line = (CTLineRef)lineObj;
        
        for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) { //6
            CTRunRef run = (CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) { //7
	            CGRect runBounds = CGRectZero;
	            CGFloat ascent = 0.0;//height above the baseline
	            CGFloat descent = 0.0;//height below the baseline
	            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
	            runBounds.size.height = ascent + descent;
                
	            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
                NSLog(@"runBounds: %@", NSStringFromCGRect(runBounds));
	            runBounds.origin.x = origins[lineIndex].x + xOffset - runBounds.size.width / 2;
	            runBounds.origin.y = origins[lineIndex].y;
	            runBounds.origin.y -= descent;
                
                UIImage *img = [UIImage imageNamed: [nextImage objectForKey:@"fileName"] ];
                CGPathRef pathRef = CTFrameGetPath(aFrame); //10
                CGRect colRect = CGPathGetBoundingBox(pathRef);
                
                CGRect imgBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
//                [col.images addObject: //11
//                 [NSArray arrayWithObjects:img, NSStringFromCGRect(imgBounds) , nil]
//                 ];
                imgBounds = CGRectMake(imgBounds.origin.x, imgBounds.origin.y, 238, 280);
                CGContextDrawImage(context, imgBounds, img.CGImage);
//                UIImageView *imgview = [[[UIImageView alloc] initWithFrame:imgBounds] autorelease];
//                [imgview setImageWithURL:[NSURL URLWithString:[nextImage objectForKey:@"filename"]]];
//                imgview.backgroundColor = [UIColor blueColor];
//                [self addSubview:imgview];
                NSLog(@"imgrect: %@", NSStringFromCGRect(imgBounds));
                //load the next image //12
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = [self.images objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                }
                
            }
        }
        lineIndex++;
    }
}

- (void)layoutSubviews
{
    NSLog(@"layoutSubviews");
    [super layoutSubviews];
    
    // layout
    if (self.images.count == 0) {
        return;
    }
    
    CGMutablePathRef path = CGPathCreateMutable(); //1
    CGPathAddRect(path, NULL, self.bounds );
    
    //    NSAttributedString* attString = [[[NSAttributedString alloc]
    //                                      initWithString:@"Hello core text world!\nTest \n\nTest"] autorelease]; //2
    
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_contentString); //3
    CTFrameRef frame =
    CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [_contentString length]), path, NULL);
    

    //drawing images
    NSArray *lines = (NSArray *)CTFrameGetLines(frame); //1
    
    CGPoint origins[[lines count]];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins); //2
    
    int imgIndex = 0; //3
    NSDictionary* nextImage = [self.images objectAtIndex:imgIndex];
    int imgLocation = [[nextImage objectForKey:@"location"] intValue];
    
    //find images for the current column
    CFRange frameRange = CTFrameGetVisibleStringRange(frame); //4
    while ( imgLocation < frameRange.location ) {
        imgIndex++;
        if (imgIndex>=[self.images count]) return; //quit if no images for this column
        nextImage = [self.images objectAtIndex:imgIndex];
        imgLocation = [[nextImage objectForKey:@"location"] intValue];
    }
    
    NSUInteger lineIndex = 0;
    for (id lineObj in lines) { //5
        CTLineRef line = (CTLineRef)lineObj;
        
        for (id runObj in (NSArray *)CTLineGetGlyphRuns(line)) { //6
            CTRunRef run = (CTRunRef)runObj;
            CFRange runRange = CTRunGetStringRange(run);
            
            if ( runRange.location <= imgLocation && runRange.location+runRange.length > imgLocation ) { //7
	            CGRect runBounds = CGRectZero;
	            CGFloat ascent = 0.0;//height above the baseline
	            CGFloat descent = 0.0;//height below the baseline
	            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); //8
	            runBounds.size.height = ascent + descent;
                
	            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL); //9
                NSLog(@"runBounds: %@", NSStringFromCGRect(runBounds));
	            runBounds.origin.x = origins[lineIndex].x + xOffset - runBounds.size.width / 2;
	            runBounds.origin.y = self.bounds.size.height - origins[lineIndex].y - runBounds.size.height;
	            runBounds.origin.y -= descent;
 
                NSString *imgurl = [nextImage objectForKey:@"url"];
                if (imgurl != nil)
                {
					UIView* tempView = nil;
                	if ([imageDelegate respondsToSelector:@selector(coreTextView:viewWithURLString:bounds:)]) {
                    tempView = [imageDelegate coreTextView:self viewWithURLString:imgurl bounds:runBounds];
                    CGRect tempRect = tempView.bounds;
                    tempRect.origin.y = runBounds.origin.y;
                    tempRect.origin.x = self.bounds.size.width/2 - tempRect.size.width/2;
                    tempView.frame = tempRect;
                	}
                	else
                	{
                    	UIImageView *imgview = [[[UIImageView alloc] initWithFrame:runBounds] autorelease];
                    	imgview.contentMode = UIViewContentModeScaleAspectFit;
                    
                    	[imgview setImageWithURL:[NSURL URLWithString:imgurl]];
                    	tempView = imgview;
                    }
                    [self addSubview:tempView];
                }
                else {
                    UIView *table = [nextImage objectForKey:@"view"];
                    table.backgroundColor = [UIColor clearColor];
                    table.frame = runBounds;
                    [self addSubview:table];
                }

//                NSLog(@"imgrect: %@", NSStringFromCGRect(runBounds));
                //load the next image //12
                imgIndex++;
                if (imgIndex < [self.images count]) {
                    nextImage = [self.images objectAtIndex: imgIndex];
                    imgLocation = [[nextImage objectForKey: @"location"] intValue];
                }
                
            }
        }
        lineIndex++;
    }
    
    CFRelease(frame); //5
    CFRelease(path);
    CFRelease(framesetter);
}

@end
