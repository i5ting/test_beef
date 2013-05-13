//
//  ZXBoard.m
//  sinafinance
//
//  Created by sang on 5/9/13.
//
//

#import "ZXBoard.h"




@interface ZXBoard ()

@end

@implementation ZXBoard


#pragma mark - Signals

// BeeUIBoard signal goes here
- (void)handleUISignal_Bee_UITopTab:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
    if ( [signal is:Bee_UITopTab.TOP_TAB_ITEM_CHANGE] )
	{
        int i = [(NSNumber *)[signal object] intValue];
        [self log:[NSString stringWithFormat:@"Bee_UITopTab click item : %d",i]];
        
        if (i == ZXBoard_ITEM_VIEW_HS) {
            if (!_hs_tab_item_view) {
                _hs_tab_item_view = [HSUITabItemView new];
                [self.view addSubview:_hs_tab_item_view];
            } 
            [self.view bringSubviewToFront:_hs_tab_item_view];
        }
        
        if (i == ZXBoard_ITEM_VIEW_HK) {
            if (!_hk_tab_item_view) {
                _hk_tab_item_view = [HKUITabItemView new];
                [self.view addSubview:_hk_tab_item_view];
            }
            [self.view bringSubviewToFront:_hk_tab_item_view];
        }
        
        if (i == ZXBoard_ITEM_VIEW_US) {
            if (!_us_tab_item_view) {
                _us_tab_item_view = [USUITabItemView new];
                [self.view addSubview:_us_tab_item_view];
            }
            [self.view bringSubviewToFront:_us_tab_item_view];
        }
    }
}

// BeeUIBoard signal goes here
- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		// 界面创建
        self.view.backgroundImage = __BASE_BOARD_IMAGE( @"main_board_bg" );
        //        [self hideNavigationBarAnimated:NO];
		[self setTitleString:@"我的自选"];
		[self showNavigationBarAnimated:NO];
        
        CGRect innerFrame;
		innerFrame.size.width = self.viewSize.width - 20.0f;
		innerFrame.size.height = 44.0f;
		innerFrame.origin.x = 10.0f;
		innerFrame.origin.y =100;
		
        
        CC(@"%d", self.viewSize.height);
                CC(@"%d", self.view);
                CC(@"%d", self.viewSize.width);

		_innerView = [[Lesson2View1 alloc] initWithFrame:innerFrame];
		_innerView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:_innerView];
        
         
		innerFrame.size.width = self.viewSize.width - 20.0f;
		innerFrame.size.height = 44.0f;
		innerFrame.origin.x = 10.0f;
		innerFrame.origin.y = 200;
		
		_innerView = [[Lesson2View1 alloc] initWithFrame:innerFrame];
		_innerView.backgroundColor = [UIColor clearColor];
        		[self.view addSubview:_innerView];
         
		innerFrame.size.width = self.viewSize.width - 20.0f;
		innerFrame.size.height = 44.0f;
		innerFrame.origin.x = 10.0f;
		innerFrame.origin.y = 300;
		
		_innerView = [[Lesson2View1 alloc] initWithFrame:innerFrame];
		_innerView.backgroundColor = [UIColor clearColor];
        		[self.view addSubview:_innerView];
    
        
        innerFrame.size.width = self.viewSize.width - 20.0f;
		innerFrame.size.height = 44.0f;
		innerFrame.origin.x = 10.0f;
		innerFrame.origin.y = 500;
		
		_innerView = [[Lesson2View1 alloc] initWithFrame:innerFrame];
		_innerView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_innerView];
        
        
        [self addTopTabView];
        
  
        

	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		// 界面删除
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		// 界面重新布局
	}
	else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
	{
		// 数据加载
	}
	else if ( [signal is:BeeUIBoard.FREE_DATAS] )
	{
		// 数据释放
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
		// 将要显示
	}
	else if ( [signal is:BeeUIBoard.DID_APPEAR] )
	{
		// 已经显示
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
		// 将要隐藏
	}
	else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
	{
		// 已经隐藏
	}
}



#pragma mark - Override 
- (NSMutableArray *)get_top_tab_data_source
{
    return [NSMutableArray arrayWithObjects:@"沪深",@"港股",@"美股", nil];
}

@end
