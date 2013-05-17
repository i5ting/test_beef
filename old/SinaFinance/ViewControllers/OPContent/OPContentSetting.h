//
//  OPContentSetting.h
//  SinaNews
//
//  Created by fabo on 12-10-17.
//
//

#import <Foundation/Foundation.h>

@interface OPContentSetting : NSObject
{
    CGFloat titleSpaceBetweenTop;
    CGFloat titleSpaceBetweenEdge;
    NSString* titleFontName;
	CGFloat titleFontSize;
    
    CGFloat contentSpaceBetweenEdge;
}

@property (nonatomic, assign) CGFloat titleSpaceBetweenTop;
@property (nonatomic, assign) CGFloat titleSpaceBetweenEdge;
@property (nonatomic, retain) NSString* titleFontName;
@property (nonatomic, assign) CGFloat titleFontSize;

@property (nonatomic, assign) CGFloat contentSpaceBetweenEdge;

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
@end
