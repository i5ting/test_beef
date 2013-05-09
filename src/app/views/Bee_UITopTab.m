//
//  Bee_UITopTab.m
//  sinafinance
//
//  Created by sang on 5/9/13.
//
//

#import "Bee_UITopTab.h"

@implementation Bee_UITopTab

@synthesize source;
 
//DEF_SIGNAL( TEST )

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
        
        self.backgroundImage = __BASE_BOARD_IMAGE(@"top_tab_bg");
        
        source = [NSMutableArray array];
        [source addObject:@"ssssss "];
        [source addObject:@"dddddd "];
        
        _container = [[BeeUIScrollView alloc] initWithFrame:CGRectMake(20, 3, 280, 30)];
//        _container.backgroundImage = __BASE_BOARD_IMAGE(@"top_tab_bg");
        _container.delegate = self;
        _container.dataSource = self;
        [_container setHorizontal:YES];
//        [_container setVertical:YES];
        _container.bounces = YES;

        
		[self addSubview:_container];
        
        
        [_container reloadData];
	}
	return self;
}


- (void)dealloc
{
	SAFE_RELEASE_SUBVIEW( _container );
	[super dealloc];
}


#pragma mark - BeeUIScrollViewDataSource

- (NSInteger)numberOfLinesInScrollView:(BeeUIScrollView *)scrollView
{
    return 1;
}
- (NSInteger)numberOfViewsInScrollView:(BeeUIScrollView *)scrollView
{
    return [source count];
}

- (UIView *)scrollView:(BeeUIScrollView *)scrollView viewForIndex:(NSInteger)index scale:(CGFloat)scale
{
    BeeUIButton *l = [[BeeUIButton alloc] initWithFrame:CGRectMake( 0, 0, 50, 25)];
//    l.text = 
    l.stateNormal.title = [source objectAtIndex:index];
    
    l.stateNormal.backgroundImage = __BASE_BOARD_IMAGE(@"top_tab_selected");
    return l;
}

- (CGSize)scrollView:(BeeUIScrollView *)scrollView sizeForIndex:(NSInteger)index
{
    return CGSizeMake(50, 30);
}


@end
