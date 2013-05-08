//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//	Powered by BeeFramework
//
//
//  no320_bee_tab_board.h
//  git;
//
//  Created by sang on 5/8/13.
//    Copyright (c) 2013 alfred sang. All rights reserved.
//

#import "no320_bee_tab_board.h"

@implementation no320_bee_tab_board
@synthesize __controllerArray;

@synthesize customView = _customView;
@synthesize isHidden = _isHide;
@synthesize logTrace ;
@synthesize selectedIndex;


DEF_SINGLETON( no320_bee_tab_board )

#pragma mark -

- (void)load
{
    [super load];

     _boards = [[NSMutableArray alloc] init];
 
     
    
    
    NSLog(@"1");
    
}

- (void)unload
{
	[_boards removeAllObjects];
	[_boards release];

    [super unload];
}

#pragma mark Signal

// Bee_TabbarItem signal goes here
- (void)handleUISignal_Bee_TabbarItem:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:Bee_TabbarItem.TABBAR_ITEM_CLICK] )
	{
        int index = [(NSNumber *)signal.object intValue];
        [_tabBar setSelectedIndex:index-2];
        [_customView selectTabAtIndex:index-2];
	}
}

- (void)handleUISignal_BeeUIBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        //初始化背景
        [self bg_image_setting];
        //设置tab图片
        [self tab_image_setting];
        
        [BeeUITipsCenter setDefaultContainerView:self.view];
        [BeeUITipsCenter setDefaultBubble:[UIImage imageNamed:@"alertBox.png"]];

        self.view.backgroundColor = [UIColor whiteColor];

        _mainStackGroup = [[BeeUIStackGroup alloc] init];
        [self.view addSubview:_mainStackGroup.view];

        _tabBar = [[BeeUITabBar alloc] init];
        [_tabBar addTitle:@"First"];
        [_tabBar addTitle:@"Second"];
        [_tabBar addTitle:@"Second"];
        [_tabBar addTitle:@"Second"];
        [self.view addSubview:_tabBar];

        [_tabBar setSelectedIndex:0];

        if (_boards == nil) {
            return;
        }
 
        [self hideTabBar];
        [self addCustomElements];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE( _mainStackGroup );
        SAFE_RELEASE( _tabBar );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
        _tabBar.frame = CGRectMake( 0, self.viewBound.size.height - 49, self.viewBound.size.width, 49 );
        _mainStackGroup.view.frame = CGRectMake( 0, 0, self.viewBound.size.width, self.viewBound.size.height - _tabBar.frame.size.height );
	}
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.ORIENTATION_CHANGED] )
    {
    }
    else if ( [signal is:BeeUIBoard.ANIMATION_BEGIN] )
    {
    }
    else if ( [signal is:BeeUIBoard.ANIMATION_FINISH] )
    {
    }
    else if ( [signal is:BeeUIBoard.MODALVIEW_WILL_SHOW] )
    {
    }
    else if ( [signal is:BeeUIBoard.MODALVIEW_DID_SHOWN] )
    {
    }
    else if ( [signal is:BeeUIBoard.MODALVIEW_WILL_HIDE] )
    {
    }
    else if ( [signal is:BeeUIBoard.MODALVIEW_DID_HIDDEN] )
    {
    }
    else if ( [signal is:BeeUIBoard.POPOVER_WILL_PRESENT] )
    {
    }
    else if ( [signal is:BeeUIBoard.POPOVER_DID_PRESENT] )
    {
    }
    else if ( [signal is:BeeUIBoard.POPOVER_WILL_DISMISS] )
    {
    }
    else if ( [signal is:BeeUIBoard.POPOVER_DID_DISMISSED] )
    {
    }
}

- (void)handleUISignal_BeeUITabBar:(BeeUISignal *)signal
{
    if ( [signal is:BeeUITabBar.HIGHLIGHT_CHANGED] )
    {
        [self toggleBoard:_tabBar.selectedIndex];
    }
}

#pragma mark Message

- (void)handleMessage:(BeeMessage *)msg
{
    [super handleMessage:msg];
}

#pragma mark Notification

- (void)handleNotification:(NSNotification *)notification
{
    [super handleNotification:notification];
}

#pragma mark -

- (void)toggleBoard:(NSUInteger)index
{
	NSString * className = [_boards safeObjectAtIndex:index];
	if ( nil == className )
		return;
    
    selectedIndex = index;

    BeeUIStack * stack = [_mainStackGroup reflect:className];
    if ( nil == stack )
    {
        CGRect stackFrame;
        stackFrame.origin = CGPointZero;
        stackFrame.size = _mainStackGroup.view.frame.size;

        stack = [BeeUIStack stack:className firstBoardClass:NSClassFromString(className)];
        stack.view.frame = stackFrame;
        [_mainStackGroup append:stack];
    }
    else
    {
        [_mainStackGroup present:stack];
    }
}

#pragma mark - tab ui

+(BOOL)isHidden
{
    return [no320_bee_tab_board sharedInstance].isHidden;
}

+ (no320_bee_tab_board*)sharedTabBarController{
	return [no320_bee_tab_board sharedInstance];
}
+ (void)hide:(BOOL)bHide animated:(BOOL)bAnimated{
    [[no320_bee_tab_board sharedInstance] hide:bHide withAnimation:bAnimated];
    [no320_bee_tab_board sharedInstance].isHidden = bHide;
}

#pragma mark - CustomTabBarDelegate
- (void)customTabbar:(Bee_TabbarItem*)customTabbar didSelectTab:(int)tabIndex{
    //    [customTabbar selectTabAtIndex:tabIndex];
    //    self.selectedIndex = tabIndex;
    [self selectTab:tabIndex];
    
    /**
     * 当切换tab的时候，让CXPopoverView消失，选中按钮取消高亮，所有内容在whenClear方法里实现
     */
    if ([self getShowingViewController] && [[self getShowingViewController] respondsToSelector:@selector(whenTabChanged)]) {
        [(UIViewController *)[self getShowingViewController] whenTabChanged];
    }
}

#pragma mark - private methods
- (void)hideTabBar{
	if ([[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
		_contentView = [self.view.subviews objectAtIndex:1];
	}
	else {
		_contentView = [self.view.subviews objectAtIndex:0];
	}
	_contentView.frame = CGRectMake(0, 0, 320, UI_MAX_HEIGHT);
	for(UIView *view in self.view.subviews){
		if([view isKindOfClass:[UITabBar class]]){
			view.alpha = 0;
			break;
		}
	}
}

//先注释掉，以后实现
- (UIViewController *)getShowingViewController
{
//    UINavigationController *currentNavController =  (UINavigationController *)self.selectedViewController;
//    return currentNavController.visibleViewController;
}

- (void)addCustomElements{
    if (__controllerArray == nil) {
        return;
    }
    //    _customView = [[Bee_TabbarItem1 alloc] initWithFrame:CGRectMake(0, 0, 320, 44) andBundleName:__bundleName andConfigArray:__controllerArray];
    
    _customView = [[Bee_TabbarItem alloc] init];
    _customView.delegate = self;
    
    
    [_customView setViewframe:[self set_init_tab_view_frame]];
    
    [_customView setViewframe:CGRectMake(0, 0, 320, 44)];
    [_customView setConfigArray:__controllerArray];
    [_customView setBundleName:__bundleName];
    
    [_customView showTab];
    [_customView selectTabAtIndex:0];
    _customView.delegate = self;
    _customView.frame = CGRectMake(0, UI_MAX_HEIGHT - TAB_CONTROLLER_TAB_HEIGHT-21, 320, TAB_CONTROLLER_TAB_HEIGHT);
    [self.view addSubview:_customView];
//    [self selectTab:0];
}

-(void)hide:(BOOL)hidden withAnimation:(BOOL)isAnimation{
	CGFloat durTime = 0;
	if (isAnimation) {
		durTime = 0.5f;
	}
    
	if (hidden) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:durTime];
        bgView.frame = CGRectMake(0, UI_MAX_HEIGHT, 320, 59);;
        _customView.frame = CGRectMake(_customView.frame.origin.x, UI_MAX_HEIGHT, _customView.frame.size.width, _customView.frame.origin.y);
		[UIView commitAnimations];
	}else {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:durTime];
        bgView.frame = CGRectMake(0, UI_MAX_HEIGHT - TAB_CONTROLLER_TAB_HEIGHT, 320, 59);;
        _customView.frame = CGRectMake(_customView.frame.origin.x, UI_MAX_HEIGHT - TAB_CONTROLLER_TAB_HEIGHT , _customView.frame.size.width, _customView.frame.origin.y);
		[UIView commitAnimations];
	}
}

#pragma mark - public methods
- (void)selectTab:(int)tabID{
    NSLog(@"tabID=%d",tabID);
    
    
    return;
    if (self.selectedIndex == tabID) {
		UINavigationController *navController = (UINavigationController *)[self selectedViewController];
		[navController popToRootViewControllerAnimated:YES];
	} else {
		self.selectedIndex = tabID;
        [_customView selectTabAtIndex:tabID];
	}
    //    if ([[[TabBarController sharedTabBarController] getShowingViewController] isKindOfClass:[TopicNewsViewController class]]) {
    //        [(TopicNewsViewController *)[[TabBarController sharedTabBarController] getShowingViewController] resetTableCellColor];
    //    }
    
}


#pragma mark - lifecycle methods
- (id)init{
    self =[super init];
//    _tabBarInstance = self;
	if (self) {
       
    }
	return self;
}

-(id)initWithBundleName:(NSString *)bundle_file_name{
    if (self = [super init]) {
        
        
        NSString *json_file_name;
        if ([bundle_file_name hasSuffix:@"bundle"]) {
            json_file_name = [NSString stringWithFormat:@"%@/tab.config.json",bundle_file_name];
            __bundleName = bundle_file_name;
        }else{
            json_file_name = [NSString stringWithFormat:@"%@.bundle/tab.config.json",bundle_file_name];
            __bundleName = [NSString stringWithFormat:@"%@.bundle",bundle_file_name];;
        }
        
        self = [self initWithJSON:json_file_name];
    }
    return self;
}

-(id)initWithJSON:(NSString *)json_file_name{
    if (self = [super init]) {
        [self getConfigInfo:json_file_name];
        self = [self init];
    }
    return self;
}




- (void)getConfigInfo:(NSString *)json_file_name{
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString* emotionFile = [bundlePath stringByAppendingPathComponent:json_file_name];
    NSError* error;
    NSString* commentStr = [NSString stringWithContentsOfFile:emotionFile encoding:NSUTF8StringEncoding error:&error];
    if (!commentStr) {
        commentStr = [NSString stringWithContentsOfFile:emotionFile encoding:NSUnicodeStringEncoding error:&error];
    }
    NSDictionary *cemotionArray = [commentStr objectFromJSONString];
    
    __configDict = cemotionArray;
    __controllerArray = [cemotionArray objectForKey:@"btns"];
}

#pragma mark - tab

- (void)bg_image_setting
{
    bgView = [UIImageView new];
    bgView.frame = CGRectMake(0, UI_MAX_HEIGHT - TAB_CONTROLLER_TAB_HEIGHT-21, 320, 59);;
    
    if ([[__configDict objectForKey:@"tab_bg"] isKindOfClass:[NSString class] ]) {
        NSLog(@"ss");
        bgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",__bundleName,(NSString *)[__configDict objectForKey:@"tab_bg"]]];
    }
    
    if ([[__configDict objectForKey:@"tab_bg"] isKindOfClass:[NSDictionary class] ]) {
        NSLog(@"ss");
        
        NSDictionary *_config = [__configDict objectForKey:@"tab_bg"];
        
        bgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",__bundleName,(NSString *)[_config objectForKey:@"name"]]];
        
//        bgView.frame = [self getRect:[_config objectForKey:@"frame"]];
        
    }
    [self.view insertSubview:bgView belowSubview:_customView];
    [self.view addSubview:bgView];
}

- (void)tab_image_setting
{
    NSMutableArray *_controllersArray = [NSMutableArray array];
    
    for (NSDictionary *d in  __controllerArray) {
        
        if ([[d objectForKey:@"controllerName"] hasSuffix:@"oard"]) {
            [_boards addObject:[d objectForKey:@"controllerName"]];
            [_controllersArray addObject:d];
        }else{
            id _myViewController = [[NSClassFromString((NSString *)[d objectForKey:@"controllerName"]) alloc] init];
            UINavigationController *topicNavigationController = [[[UINavigationController alloc] initWithRootViewController:_myViewController] autorelease];
            topicNavigationController.navigationBar.hidden = YES;
            [_controllersArray addObject:topicNavigationController];
        }
    
    }
    
    __controllerArray = _controllersArray;

}

#pragma mark - utils

-(CGRect)getRect:(NSDictionary *)d
{
    float l = [self getFloatValue:d key:@"l" defaultValue:0.0];
    float t = [self getFloatValue:d key:@"t" defaultValue:0.0];
    float w = [self getFloatValue:d key:@"w" defaultValue:0.0];
    float h = [self getFloatValue:d key:@"h" defaultValue:0.0];
    //    480-436 = 44
    return CGRectMake(0, UI_MAX_HEIGHT - 44, 320, 59);;
    return CGRectMake(l, t, w, h);
}

-(float)getFloatValue:(NSDictionary *)d key:(NSString *)key defaultValue:(float)defaultValue
{
    return [[d objectForKey:key] floatValue] > 0 ? [[d objectForKey:key] floatValue] : defaultValue;
}

#pragma mark - private
- (void)tap_on_btn_call_back:(int)index;
{
    [self log:[NSString stringWithFormat:@"tap_on_btn_call_back:%d",index]];
}

- (void)draw_with_dict:(NSDictionary *)d in_container:(UIView *)view
{
    [self log:@"draw_with_dict in_container"];
}


-(void)log:(NSString *)str{
    NSLog(@"%@:%@",@"no320_bee_tab_board",str);
}

#pragma mark - public
-(void)set_custom_tab_view_delegate:(id)d{
    _customView.delegate = d;
}


#pragma mark - required
- (CGRect)set_init_heigh_light_view_frame
{
    return CGRectMake(0, 0, 320, 44);
}


- (CGRect)set_after_animate_light_view_frame_with_prev_frame:(CGRect)prev_frame and_index:(int)index
{
    
}

- (CGRect)set_init_image_button_view_frame_with_index:(int)i
{
    
}

- (CGRect)set_init_tab_view_frame
{

}

@end
