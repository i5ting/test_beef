//
//  SingleContentViewSetting.h
//  TypesetTest
//
//  Created by huangdx on 9/15/10.
//  Copyright 2010 hdx. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
	FromTopToBottom,
	FromLeftToRight
};


@interface SingleContentViewSetting : NSObject {
	
	
	CGSize viewSize;
	
	int myType;
	CGFloat titleSpaceBetweenTop;
	CGFloat titleSpaceBetweenEdge;
	NSString* titleFontName;
	CGFloat titleFontSize;
	
	CGFloat contentSpaceBetweenTitle;
	
	CGFloat contentSpaceBetweenEdge;
	unsigned int columnSum;
	CGFloat columnSpaceBetweenColumn;
	
	NSString* authorFontName;
	CGFloat authorFontSize;
	
	CGFloat textSpaceBetweenAuthor;
	
	NSString* textFontName;
	CGFloat textFontSize;
	CGFloat textSpaceBetweenPhoto;
	
	CGFloat sourceSpaceBetweenText;
	NSString* sourceFontName;
	CGFloat sourceFontSize;
    UIColor* textFontColor;
    UIColor* titleFontColor;
    UIColor* sourceFontColor;
}
@property (nonatomic, assign) int myType;
@property (nonatomic, assign) CGFloat textSpaceBetweenPhoto;
@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat titleSpaceBetweenTop;
@property (nonatomic, assign) CGFloat titleSpaceBetweenEdge;
@property (nonatomic, retain) NSString* titleFontName;
@property (nonatomic, assign) CGFloat titleFontSize;
@property (nonatomic, assign) CGFloat contentSpaceBetweenTitle;
@property (nonatomic, assign) CGFloat contentSpaceBetweenEdge;
@property (nonatomic, assign) unsigned int columnSum;
@property (nonatomic, assign) CGFloat columnSpaceBetweenColumn;
@property (nonatomic, retain) NSString* authorFontName;
@property (nonatomic, assign) CGFloat authorFontSize;
@property (nonatomic, assign) CGFloat textSpaceBetweenAuthor;
@property (nonatomic, retain) NSString* textFontName;
@property (nonatomic, assign) CGFloat textFontSize;
@property (nonatomic, assign) CGFloat sourceSpaceBetweenText;
@property (nonatomic, retain) NSString* sourceFontName;
@property (nonatomic, assign) CGFloat sourceFontSize;
@property (nonatomic, retain) UIColor* textFontColor;
@property (nonatomic, retain) UIColor* titleFontColor;
@property (nonatomic, retain) UIColor* sourceFontColor;
@property (nonatomic, retain) UIColor* imageFontColor;

@property (nonatomic, assign) CGFloat relativeTitleSize;
@property (nonatomic, assign) CGFloat relativeTextSize;
@property (nonatomic, assign) CGFloat commentTitleSize;
@property (nonatomic, assign) CGFloat commentTextSize;

+(void)setTitleFontSize:(float)newtitleFontSize 
		   textFontSize:(float)newtextFontSize  
		 SourceFontSize:(float)newsourceFontSize ;
+(void)setRelativeTitleSize:(float)relativeTitleSize
		   relativeTextSize:(float)relativeTextSize
            commentTextSize:(float)commentTextSize
           commentTitleSize:(float)commentTitleSize;
-(void)changeDataWhenRotate;

-(void)convertFontSizeBigger;
-(void)convertFontSizeSmaller;
@end
