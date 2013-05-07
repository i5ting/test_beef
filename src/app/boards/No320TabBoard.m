//
//  No320TabBoard.m
//  sinafinance
//
//  Created by sang alfred on 5/8/13.
//
//

#import "No320TabBoard.h"
//
//@implementation Lesson2View2
//
//DEF_SIGNAL( TEST )
//
//- (id)initWithFrame:(CGRect)frame
//{
//	self = [super initWithFrame:frame];
//	if ( self )
//	{
//		_innerView = [[BeeUIButton alloc] initWithFrame:CGRectToBound(frame)];
//		_innerView.backgroundColor = [UIColor blackColor];
//		_innerView.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
//		_innerView.stateNormal.title = @"Click";
//		_innerView.stateNormal.titleColor = [UIColor whiteColor];
//		[_innerView addSignal:Lesson2View2.TEST forControlEvents:UIControlEventTouchUpInside];
//		[self addSubview:_innerView];
//	}
//	return self;
//}
//
//- (void)dealloc
//{
//	SAFE_RELEASE_SUBVIEW( _innerView );
//	[super dealloc];
//}
//
//@end

@interface No320TabBoard ()

@end

@implementation No320TabBoard

@synthesize customView = _customView;
@synthesize isHidden = _isHide;
@synthesize logTrace ;

DEF_SINGLETON( No320TabBoard )

#pragma mark -

- (void)load
{
    [super load];
    
    _boards = [[NSMutableArray alloc] init];
    [_boards addObject:@"TestBoard"];
    [_boards addObject:@"TestBoard"];
    
    
   
    
}

- (void)unload
{
	[_boards removeAllObjects];
	[_boards release];
    
    [super unload];
}

#pragma mark Signal

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

- (void)handleUISignal_BeeUITabBarBoard:(BeeUISignal *)signal
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUITabBarBoard.CREATE_VIEWS] )
	{
        [BeeUITipsCenter setDefaultContainerView:self.view];
        [BeeUITipsCenter setDefaultBubble:[UIImage imageNamed:@"alertBox.png"]];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
//        _mainStackGroup = [[BeeUIStackGroup alloc] init];
//        [self.view addSubview:_mainStackGroup.view];
//
//        [self hideTabBar];
//        [self addCustomElements];
//        
        
//        [self setTitleString:@"Lesson 2"];
//		[self showNavigationBarAnimated:NO];
        
//		_textView.contentInset = UIEdgeInsetsMake( 0, 0, 44.0f + 20.0f, 0.0f );
		
		CGRect innerFrame;
		innerFrame.size.width = self.viewSize.width - 20.0f;
		innerFrame.size.height = 44.0f;
		innerFrame.origin.x = 10.0f;
		innerFrame.origin.y = self.viewSize.height - innerFrame.size.height - 10.0f;
		
		_innerView = [[Lesson2View1 alloc] initWithFrame:innerFrame];
		_innerView.backgroundColor = [UIColor clearColor];
		[self.view addSubview:_innerView];
        
//        
//        [self hideTabBar];
//        [self addCustomElements];
        
//        _mytabBar = [[BeeUITabBar alloc] init];
//        [_mytabBar addTitle:@"First"];
//        [_mytabBar addTitle:@"Second"];
//        [self.view addSubview:_mytabBar];
//        
//
////        [_tabBar set]
////        [self setTitleString:@"Lesson 1"];
////        [self showNavigationBarAnimated:NO];
//
//        [_mytabBar setSelectedIndex:0];
	}
	else if ( [signal is:BeeUITabBarBoard.DELETE_VIEWS] )
	{
        SAFE_RELEASE( _mainStackGroup );
//        SAFE_RELEASE( _tabBar );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
//        _mytabBar.frame = CGRectMake( 0, self.viewBound.size.height - 49, self.viewBound.size.width, 49 );
//        _mainStackGroup.view.frame = CGRectMake( 0, 0, self.viewBound.size.width, self.viewBound.size.height - _mytabBar.frame.size.height );
	}
    else if ( [signal is:BeeUITabBarBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.WILL_APPEAR] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.DID_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.ORIENTATION_CHANGED] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.ANIMATION_BEGIN] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.ANIMATION_FINISH] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.MODALVIEW_WILL_SHOW] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.MODALVIEW_DID_SHOWN] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.MODALVIEW_WILL_HIDE] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.MODALVIEW_DID_HIDDEN] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.POPOVER_WILL_PRESENT] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.POPOVER_DID_PRESENT] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.POPOVER_WILL_DISMISS] )
    {
    }
    else if ( [signal is:BeeUITabBarBoard.POPOVER_DID_DISMISSED] )
    {
    }
}

- (void)handleUISignal_BeeUITabBar:(BeeUISignal *)signal
{
    if ( [signal is:BeeUITabBar.HIGHLIGHT_CHANGED] )
    {
//        [self toggleBoard:_mytabBar.selectedIndex];
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


#pragma mark - p




#pragma mark - private methods
@synthesize __controllerArray;

static No320TabBoard *_tabBarInstance;

+(BOOL)isHidden
{
    return _tabBarInstance.isHidden;
}

+ (No320TabBoard*)sharedTabBarController{
	return _tabBarInstance;
}
+ (void)hide:(BOOL)bHide animated:(BOOL)bAnimated{
    [_tabBarInstance hide:bHide withAnimation:bAnimated];
    _tabBarInstance.isHidden = bHide;
}

#pragma mark - CustomTabBarDelegate
- (void)customTabbar:(Bee_TabbarItemTmpl*)customTabbar didSelectTab:(int)tabIndex{
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

- (UIViewController *)getShowingViewController
{
    UINavigationController *currentNavController =  (UINavigationController *)self.selectedViewController;
    return currentNavController.visibleViewController;
}

- (void)addCustomElements{
    if (__controllerArray == nil) {
        return;
    }
    //    _customView = [[Bee_TabbarItem1 alloc] initWithFrame:CGRectMake(0, 0, 320, 44) andBundleName:__bundleName andConfigArray:__controllerArray];
    
    _customView = [[Bee_TabbarItemTmpl alloc] init];
    _customView.delegate = self;
    [_customView setViewframe:[self set_init_tab_view_frame]];
    [_customView setConfigArray:__controllerArray];
    [_customView setBundleName:__bundleName];
    
    [_customView showTab];
    [_customView selectTabAtIndex:0];
    _customView.delegate = self;
    _customView.frame = CGRectMake(0, UI_MAX_HEIGHT - TAB_CONTROLLER_TAB_HEIGHT, 320, TAB_CONTROLLER_TAB_HEIGHT);
    [self.view addSubview:_customView];
    [self selectTab:0];
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
    _tabBarInstance = self;
	if (self) {
		self.delegate = self;
        [self bg_image_setting];
        [self tab_image_setting];
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
    bgView.frame = CGRectMake(0, UI_MAX_HEIGHT - TAB_CONTROLLER_TAB_HEIGHT, 320, 59);;
    
    if ([[__configDict objectForKey:@"tab_bg"] isKindOfClass:[NSString class] ]) {
        NSLog(@"ss");
        bgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",__bundleName,(NSString *)[__configDict objectForKey:@"tab_bg"]]];
    }
    
    if ([[__configDict objectForKey:@"tab_bg"] isKindOfClass:[NSDictionary class] ]) {
        NSLog(@"ss");
        
        NSDictionary *_config = [__configDict objectForKey:@"tab_bg"];
        
        bgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",__bundleName,(NSString *)[_config objectForKey:@"name"]]];
        
        bgView.frame = [self getRect:[_config objectForKey:@"frame"]];
        
    }
    [self.view insertSubview:bgView belowSubview:_customView];
}


- (void)tab_image_setting
{
    NSMutableArray *_controllersArray = [NSMutableArray array];
    
    for (NSDictionary *d in  __controllerArray) {
        
        
        
        if ([[d objectForKey:@"controllerName"] hasSuffix:@"oard"]) {
            BeeUIBoard * board = [[(BeeUIBoard *)[BeeRuntime allocByClassName:[d objectForKey:@"controllerName"]] init] autorelease];
            if ( board )
            {
                UINavigationController *topicNavigationController = [[[UINavigationController alloc] initWithRootViewController:board] autorelease];
                topicNavigationController.navigationBar.hidden = YES;
                [_controllersArray addObject:topicNavigationController];
            }
            
            [_controllersArray addObject:board];
            
            
            
        }else{
            id _myViewController = [[NSClassFromString((NSString *)[d objectForKey:@"controllerName"]) alloc] init];
            UINavigationController *topicNavigationController = [[[UINavigationController alloc] initWithRootViewController:_myViewController] autorelease];
            topicNavigationController.navigationBar.hidden = YES;
            [_controllersArray addObject:topicNavigationController];
        }
        
        
        
        
    }
    
    __controllerArray = _controllersArray;
    [self setViewControllers:_controllersArray];
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
    NSLog(@"%@:%@",@"CustomTabBarViewController",str);
}

#pragma mark - public
-(void)set_custom_tab_view_delegate:(id)d{
    _customView.delegate = d;
}



#pragma mark - required
- (CGRect)set_init_heigh_light_view_frame
{
    //    int _count = [__controllerArray count];
    return CGRectMake(0, 0, 320, 44);
}


- (CGRect)set_after_animate_light_view_frame_with_prev_frame:(CGRect)prev_frame and_index:(int)index
{
    //    CGRect f = prev_frame;
    //    f.origin.x = index * prev_frame.size.width-1;
    //    return f;
}

- (CGRect)set_init_image_button_view_frame_with_index:(int)i
{
    //    int _width = 320/[__controllerArray count];
    //    return CGRectMake(_width*(i - 1)-4, 0, _width+6, 46);
}

- (CGRect)set_init_tab_view_frame
{
    //    int _count = [__controllerArray count];
    //    return CGRectMake(0, 0, 320/_count, 44);
}


@end
