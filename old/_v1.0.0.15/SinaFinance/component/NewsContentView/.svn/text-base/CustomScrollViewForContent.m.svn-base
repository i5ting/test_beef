//
//  CustomScrollViewForContent.m
//  SinaNewsHD
//
//  Created by du zhe on 10-10-31.
//  Copyright 2010 sina. All rights reserved.
//

#import "CustomScrollViewForContent.h"
#import "NewsContentVariable.h"

@implementation CustomScrollViewForContent
@synthesize images,scrollView,label;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
	    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"contentSTBBG.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15]];
		bgImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
		[self addSubview:bgImageView];
		[bgImageView release];
		
		CGRect scrollFrame = frame;
		scrollFrame.origin.x = GAPBETWEENSCROLLVIEW;
		scrollFrame.origin.y = GAPBETWEENSCROLLVIEW;
		scrollFrame.size.width = frame.size.width - 2 * GAPBETWEENSCROLLVIEW;
		scrollFrame.size.height = frame.size.height - SCROLLVIEWLABLEHEIGHT - 3 * GAPBETWEENSCROLLVIEW;
		scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
		scrollView.backgroundColor = [UIColor clearColor];
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
		[self addSubview:scrollView];
		[scrollView release];
	
		self.backgroundColor = [UIColor clearColor];
        // Initialization code
    }
    return self;
}

- (void)addLabelView
{
	CGRect labelFrame = scrollView.frame;
	labelFrame.origin.y = scrollView.frame.origin.y + scrollView.frame.size.height + GAPBETWEENSCROLLVIEW;
	labelFrame.size.height = SCROLLVIEWLABLEHEIGHT;
	label = [[UILabel alloc] initWithFrame:labelFrame];
	label.textAlignment =UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
	label.text = @"左右滑动还有更多图片";
	label.font = [UIFont systemFontOfSize:14];
	[self addSubview:label];
	[label release];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[images release];
    [super dealloc];
	
}


@end
