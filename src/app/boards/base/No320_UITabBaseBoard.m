//
//  No320_UITabBaseBoard.m
//  sinafinance
//
//  Created by sang on 5/9/13.
//
//

#import "No320_UITabBaseBoard.h"





@interface No320_UITabBaseBoard ()

/**
 * 设置统一的navigationbar背景
 */
- (void) use_common_bee_ui_navigationbar_background_image;

@end

@implementation No320_UITabBaseBoard

DEF_SINGLETON(No320_UITabBaseBoard)


- (void)load
{
	[super load];
     //do
    
    [self use_common_bee_ui_navigationbar_background_image];
    
  
    
}

- (void)unload
{
    //do
    
    
	//
	[super unload];
}


#pragma mark - Private

/**
 * 设置统一的navigationbar背景
 */
- (void) use_common_bee_ui_navigationbar_background_image
{
    [BeeUINavigationBar setBackgroundImage:__BASE_BOARD_IMAGE(@"nav_bg.png")];
}


#pragma mark - Signals

// BeeUIBoard signal goes here
- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
	         
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
		// 界面删除
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
		// 界面重新布局
//        self.view.frame = __TAB_CONTROLLER_VIEW_FRAME;
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


// Lesson2View1 signal goes here
- (void)handleUISignal_Lesson2View1:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
}

// Lesson2View2 signal goes here
- (void)handleUISignal_Lesson2View2:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:Lesson2View2.TEST] )
	{
		[BeeUIAlertView showMessage:@"Signal received" cancelTitle:@"OK"];
	}
}

#pragma mark - Public

- (void)addTopTabView
{
    _topTabView = [[Bee_UITopTab alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    [self.view addSubview:_topTabView];
    
    _topTabView.source = [self get_top_tab_data_source];
    [_topTabView reload];
    
    [self log:@"addTopTabView"];
}


#pragma mark - Template methods 

/**
 * 如果调用addTopTabView方法，需要子类重载此方法
 */
- (NSMutableArray *)get_top_tab_data_source
{
    NSAssert(NO, @"get_top_tab_data_source方法没有重写");
    return [NSMutableArray array];//纯粹为减少warning而写
}


-(void)log:(NSString *)str{
    CC(@"%@文件: %@",self.class,str);
}

 

@end


 
