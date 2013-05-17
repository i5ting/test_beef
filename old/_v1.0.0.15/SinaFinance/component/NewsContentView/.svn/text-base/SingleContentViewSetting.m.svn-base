//
//  SingleContentViewSetting.m
//  TypesetTest
//
//  Created by huangdx on 9/15/10.
//  Copyright 2010 hdx. All rights reserved.
//

#import "SingleContentViewSetting.h"
#import "MUser.h"

@implementation SingleContentViewSetting

@synthesize myType;
@synthesize textSpaceBetweenPhoto;
@synthesize viewSize;
@synthesize titleSpaceBetweenTop;
@synthesize titleSpaceBetweenEdge;
@synthesize titleFontName;
@synthesize titleFontSize;

@synthesize contentSpaceBetweenTitle;

@synthesize contentSpaceBetweenEdge;
@synthesize columnSum;
@synthesize columnSpaceBetweenColumn;

@synthesize authorFontName;
@synthesize authorFontSize;

@synthesize textSpaceBetweenAuthor;

@synthesize textFontName;
@synthesize textFontSize;

@synthesize sourceSpaceBetweenText;
@synthesize sourceFontName;
@synthesize sourceFontSize;

@synthesize relativeTitleSize,relativeTextSize,commentTextSize,commentTitleSize;

@synthesize textFontColor,titleFontColor,sourceFontColor,imageFontColor;

+(void)setTitleFontSize:(float)newtitleFontSize 
		   textFontSize:(float)newtextFontSize  
		 SourceFontSize:(float)newsourceFontSize 
{
	[[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:newtextFontSize] forKey:@"textFontSize"];
	[[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:newtitleFontSize] forKey:@"titleFontSize"];
	[[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:newsourceFontSize] forKey:@"sourceFontSize"];
}

+(void)setRelativeTitleSize:(float)relativeTitleSize
		   relativeTextSize:(float)relativeTextSize
		 commentTextSize:(float)commentTextSize
            commentTitleSize:(float)commentTitleSize
{
	[[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:relativeTitleSize] forKey:@"relativeTitleSize"];
	[[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:relativeTextSize] forKey:@"relativeTextSize"];
	[[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:commentTextSize] forKey:@"commentTextSize"];
    [[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:commentTitleSize] forKey:@"commentTitleSize"];
}

+(void)initialize
{
    if (![[MUser sharedUser] appAttr:@"textFontSize"]) {
		[[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:16.0] forKey:@"textFontSize"];
	}
	
	if (![[MUser sharedUser] appAttr:@"titleFontSize"]) {
		[[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:18.0] forKey:@"titleFontSize"];
	}
	
	if (![[MUser sharedUser] appAttr:@"sourceFontSize"]) {
		[[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:12.0] forKey:@"sourceFontSize"];
	}
    
    if (![[MUser sharedUser] appAttr:@"relativeTitleSize"]) {
		[[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:20.0] forKey:@"relativeTitleSize"];
	}
    if (![[MUser sharedUser] appAttr:@"relativeTextSize"]) {
		[[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:17.0] forKey:@"relativeTextSize"];
	}
    if (![[MUser sharedUser] appAttr:@"commentTextSize"]) {
		[[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:14.0] forKey:@"commentTextSize"];
	}
    if (![[MUser sharedUser] appAttr:@"commentTitleSize"]) {
		[[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:12.0] forKey:@"commentTitleSize"];
	}
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.myType = FromTopToBottom;
		self.viewSize = CGSizeMake(320, 414);
		self.titleSpaceBetweenTop = 10;
		self.titleSpaceBetweenEdge = 10;
		self.titleFontName = @"Helvetica";
//        self.titleFontName = @"FZLTHJW--GB1-0";
		self.titleFontSize = [[[MUser sharedUser] appAttr:@"titleFontSize"] floatValue]	;
		self.contentSpaceBetweenTitle = 10;
		self.contentSpaceBetweenEdge = 5;
		self.columnSum = 1;
		self.columnSpaceBetweenColumn = 10;
		self.authorFontName = @"Helvetica";
        self.authorFontName = @"Arial";
		self.authorFontSize = 18;
		self.textSpaceBetweenAuthor = 10;
		self.textFontName = @"Helvetica";
        self.textFontName = @"Arial";
		self.textFontSize = [[[MUser sharedUser] appAttr:@"textFontSize"] floatValue];
		self.sourceSpaceBetweenText = 10;
		self.sourceFontName = @"Helvetica";
        self.sourceFontName = @"Arial";
		self.sourceFontSize = [[[MUser sharedUser] appAttr:@"sourceFontSize"] floatValue];
		self.textSpaceBetweenPhoto = 10;
        self.sourceFontColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.titleFontColor =  [UIColor colorWithRed:16/255.0 green:78/255.0 blue:179/255.0 alpha:1.0];
        self.textFontColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.imageFontColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1.0];
        self.relativeTitleSize = [[[MUser sharedUser] appAttr:@"relativeTitleSize"] floatValue];
        self.relativeTextSize = [[[MUser sharedUser] appAttr:@"relativeTextSize"] floatValue];
        self.commentTitleSize = [[[MUser sharedUser] appAttr:@"commentTitleSize"] floatValue];
        self.commentTextSize = [[[MUser sharedUser] appAttr:@"commentTextSize"] floatValue];
	}
	return self;
}

-(void)changeDataWhenRotate
{
	UIInterfaceOrientation currentOrientation = [[MUser sharedUser] getOrientation];
	switch (currentOrientation) {
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			self.myType = FromTopToBottom;
			self.viewSize = CGSizeMake(320, 414);
			self.titleSpaceBetweenTop = 10;
			self.titleSpaceBetweenEdge = 10;


			self.contentSpaceBetweenTitle = 10;
			self.contentSpaceBetweenEdge = 5;
			self.columnSum = 1;
			self.columnSpaceBetweenColumn = 10;


			self.textSpaceBetweenAuthor = 10;


			self.sourceSpaceBetweenText = 10;


			self.textSpaceBetweenPhoto = 10;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
		case UIInterfaceOrientationPortrait:
		default:
			self.myType = FromTopToBottom;
			self.viewSize = CGSizeMake(320, 414);
			self.titleSpaceBetweenTop = 10;
			self.titleSpaceBetweenEdge = 10;


			self.contentSpaceBetweenTitle = 10;
			self.contentSpaceBetweenEdge = 5;
			self.columnSum = 1;
			self.columnSpaceBetweenColumn = 10;

			self.textSpaceBetweenAuthor = 10;

			self.sourceSpaceBetweenText = 10;

			self.textSpaceBetweenPhoto = 10;
			break;
	}
}

-(void)convertFontSizeBigger
{
//    self.textFontSize = [[[MUser sharedUser] appAttr:@"textFontSize"] floatValue];
//    self.textFontSize = (self.textFontSize+ 2);
//    [[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:self.textFontSize] forKey:@"textFontSize"];
}

-(void)convertFontSizeSmaller
{
//    self.textFontSize = [[[MUser sharedUser] appAttr:@"textFontSize"] floatValue];
//    if (self.textFontSize>8) {
//        self.textFontSize = (self.textFontSize- 2);
//    }
//    [[MUser sharedUser] setAppAttr:[NSNumber numberWithFloat:self.textFontSize] forKey:@"textFontSize"];
}

- (void) dealloc
{
	self.textFontName = nil;
	self.sourceFontName = nil;
	self.titleFontName = nil;
	self.authorFontName = nil;
    self.textFontColor = nil;
    self.titleFontColor = nil;
    self.sourceFontColor = nil;
    self.imageFontColor = nil;
	[super dealloc];
}



@end
