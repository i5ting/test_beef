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
@synthesize selectedView;


DEF_SIGNAL( TOP_TAB_ITEM_CHANGE )

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
        
        self.backgroundImage = __BASE_BOARD_IMAGE(@"top_tab_bg");
        
        self.selectedView = [[UIImageView alloc] init];
        self.selectedView.image = __BASE_BOARD_IMAGE(@"top_tab_selected");
        
        
        source = [NSMutableArray array];
        [source addObject:@"哈哈"];
        [source addObject:@"嘻嘻"];
        [source addObject:@"时间"];
        [source addObject:@"哈哈"];
        [source addObject:@"说的"];
        [source addObject:@"没有"];
//        [source addObject:@"哈哈"];
//        [source addObject:@"嘻嘻"];
//        [source addObject:@"时间"];
//        [source addObject:@"哈哈"];
//        [source addObject:@"说的"];
//        [source addObject:@"没有"];
//        [source addObject:@"哈哈"];
//        [source addObject:@"嘻嘻"];
//        [source addObject:@"时间"];
//        [source addObject:@"哈哈"];
//        [source addObject:@"说的"];
//        [source addObject:@"没有"];
        
        _container = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 3, 280, 30)];

        _container.contentSize = CGSizeMake([source count]*90, 30);
        
        _container.delegate = self;

//        [_container setHorizontal:YES];
//        [_container setVertical:YES];
        _container.bounces = YES;
//        _container.pagingEnabled = YES;
        _container.delaysContentTouches = YES;
		[self addSubview:_container];
        
        _container.showsHorizontalScrollIndicator = NO;
        
        
        if ([source count]>=4) {
            _itemWidth = 50;
        }else{
            _itemWidth = 280/[source count];
        }
        
        self.selectedView.frame = CGRectMake(0 * (_itemWidth +20)-6, 2, 61, 26);
        [_container addSubview:self.selectedView];
        
        
        for (int i =0 ; i<[source count]; i++) {
            
            BeeUIButton *l = [[BeeUIButton alloc] initWithFrame:CGRectMake(i * (_itemWidth +20), 0, 50, 30)];
            l.opaque = YES;
//            l.textColor = [UIColor whiteColor];
            l.title = [source objectAtIndex:i];
            l.titleFont = [UIFont systemFontOfSize:14];
            l.titleColor = [UIColor orangeColor];
            l.backgroundColor = [UIColor clearColor];
            
//            l.stateSelected.image = __BASE_BOARD_IMAGE(@"top_tab_selected");
            l.opaque = YES;
            l.tag = i;

            [l addTarget:self action:@selector(top_tab_item_click:) forControlEvents:UIControlEventTouchUpInside];
//            l.text = [source objectAtIndex:i];
            [_container addSubview:l];
        }
        
        
        
//        [_container reloadData];
	}
	return self;
}


- (void)dealloc
{
	SAFE_RELEASE_SUBVIEW( _container );
	[super dealloc];
}

#pragma mark - event 

- (void)top_tab_item_click:(BeeUIButton *)sender
{
    
    int i = sender.tag;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2];
//    self.selectedView.frame = CGRectMake(i* (_itemWidth +20), 0, 80, 30);
    
    CGRect f = self.selectedView.frame;
    f.origin.x = i* (_itemWidth +20) - 6;
    self.selectedView.frame = f;
    [UIView commitAnimations];
    
    [self sendUISignal:Bee_UITopTab.TOP_TAB_ITEM_CHANGE withObject:nil];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
//    CGFloat boundY = -(_baseInsets.top + _headerLoader.bounds.size.height);
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat left = scrollView.frame.origin.x;
    
    
    CC(@"%d",offset);
    
    // 65  - 0
    CGFloat f = offset - left;
    
    if (offset > 40 || offset < -40) {
        int i = f/70;
        
        [UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
        
        
        [_container setContentOffset:CGPointMake(i * 80, 0)];
        
		[UIView commitAnimations];
    }
    
    
    if (decelerate) {
         
    }
 
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
 
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
 
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
 
}




@end
