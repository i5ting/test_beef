//
//  OPContentSetting.m
//  SinaNews
//
//  Created by fabo on 12-10-17.
//
//

#import "OPContentSetting.h"

@implementation OPContentSetting
@synthesize contentSpaceBetweenEdge;
@synthesize titleSpaceBetweenTop;
@synthesize titleSpaceBetweenEdge;
@synthesize titleFontName;
@synthesize titleFontSize;
@synthesize textFontName;
@synthesize textFontSize;
@synthesize sourceSpaceBetweenText;
@synthesize sourceFontName;
@synthesize sourceFontSize;
@synthesize textFontColor;
@synthesize titleFontColor;
@synthesize sourceFontColor;
@synthesize imageFontColor;
@synthesize relativeTitleSize;
@synthesize relativeTextSize;
@synthesize commentTextSize;
@synthesize commentTitleSize;

- (id) init
{
	self = [super init];
	if (self != nil) {
        contentSpaceBetweenEdge = 5;
        titleSpaceBetweenTop = 10;
        titleSpaceBetweenEdge = 10;
        self.titleFontName = @"FZLTHJW--GB1-0";
        self.titleFontSize = 23.0;
        self.textFontName = @"Arial";
        self.textFontSize = 17.0;
        self.sourceFontName = @"Arial";
        self.sourceFontSize = 12.0;
        self.sourceSpaceBetweenText = 10;
        self.sourceFontColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
//        self.titleFontColor = [UIColor colorWithRed:16/255.0 green:78/255.0 blue:179/255.0 alpha:1.0];
        self.titleFontColor = [UIColor blackColor];
        self.textFontColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.imageFontColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1.0];
    }
    return self;
}

- (void) dealloc
{
	self.textFontName = nil;
	self.sourceFontName = nil;
	self.titleFontName = nil;
    self.textFontColor = nil;
    self.titleFontColor = nil;
    self.sourceFontColor = nil;
    self.imageFontColor = nil;
	[super dealloc];
}

@end
