//
//  TestBoard.m
//  sinafinance
//
//  Created by sang alfred on 5/8/13.
//
//

#import "TestBoard.h"

@interface TestBoard ()

@end

@implementation TestBoard

DEF_SINGLETON(TestBoard)


// Other signal goes here
- (void)handleUISignal:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
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

// BeeUIBoard signal goes here
- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
		// 界面创建
//        [self hideNavigationBarAnimated:NO];
		[self setTitleString:@"t 1"];
		[self showNavigationBarAnimated:NO];
        
        CGRect innerFrame;
		innerFrame.size.width = self.viewSize.width - 20.0f;
		innerFrame.size.height = 44.0f;
		innerFrame.origin.x = 10.0f;
		innerFrame.origin.y = self.viewSize.height - innerFrame.size.height - 10.0f-100;
		
		_innerView = [[Lesson2View1 alloc] initWithFrame:innerFrame];
		_innerView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:_innerView];
        
        self.view.backgroundColor = [UIColor orangeColor];
        
       
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
         [self.view setFrame: CGRectMake(0, 0, 320, 200)];
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


@end
