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
        
//        if ( [self sendingMessage:ZXBoard_Message.REMOTE] )
//		{
//			[self cancelMessage:ZXBoard_Message.REMOTE];
//		}
//		else
//		{
//			[[self sendMessage:ZXBoard_Message.REMOTE timeoutSeconds:10.0f] input:
//			 @"url", @"http://top.baidu.com/news/pagination?pageno=1", nil];
//		}

        
        self.navigationController.navigationItem.leftBarButtonItem.title = @"ddd";
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        /**
         *  设置frame只能控制按钮的大小
         */
        btn.frame= CGRectMake(0, 0, 40, 44);
        [btn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btn_right = [[UIBarButtonItem alloc] initWithCustomView:btn];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        /**
         *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
         *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
         */
        negativeSpacer.width = -5;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, btn_right, nil];
        [btn_right release];
        
        
        UIButton *ssoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [ssoButton setTitle:@"请求微博认证（SSO授权）" forState:UIControlStateNormal];
        [ssoButton addTarget:self action:@selector(ssoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        ssoButton.frame = CGRectMake(20, 250, 280, 50);
        [self.view addSubview:ssoButton];

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

#pragma mark - Messages
- (void)handleMessage:(BeeMessage *)msg
{
	[super handleMessage:msg];
}

- (void)handleMessage_ZXBoard_Message:(BeeMessage *)msg
{
	[super handleMessage:msg];
    
	if ( [msg is:ZXBoard_Message.LOCAL] )
	{
		if ( msg.sending )
		{
//			_button1.stateNormal.title = @"Cancel";
		}
		else
		{
//			_button1.stateNormal.title = @"Local message";
		}
		
		if ( msg.succeed )
		{
			[BeeUIAlertView showMessage:[msg.output description] cancelTitle:@"OK"];
		}
	}
	else if ( [msg is:ZXBoard_Message.REMOTE] )
	{
		if ( msg.sending )
		{
//			_button2.stateNormal.title = @"Cancel";
		}
		else
		{
//			_button2.stateNormal.title = @"Remote message";
		}
		
		if ( msg.sending )
		{
			// TODO: 当发送
			
			self.title = @"Communicating...";
		}
		else if ( msg.failed )
		{
			// TODO: 当失败
			
			self.title = @"Failed";
		}
		else if ( msg.succeed )
		{
			// TODO: 当成功
			CC(msg.responseJSON);
			self.title = @"Succeed";
            
            //reload table view
			
			[BeeUIAlertView showMessage:[msg.output description] cancelTitle:@"OK"];
		}
        
		else if ( msg.cancelled )
		{
			// TODO: 当取消
			
			self.title = @"Cancelled";
		}
	}
}

#pragma mark - Override 
- (NSMutableArray *)get_top_tab_data_source
{
    return [NSMutableArray arrayWithObjects:@"沪深",@"港股",@"美股", nil];
}


- (void)ssoButtonPressed
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"email,direct_messages_write";
    request.userInfo = @{@"SSO_From": @"ZXBoard",
    @"Other_Info_1": [NSNumber numberWithInt:123],
    @"Other_Info_2": @[@"obj1", @"obj2"],
    @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}


@end
