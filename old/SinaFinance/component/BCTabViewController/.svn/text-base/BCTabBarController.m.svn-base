#import "BCTabBarController.h"
#import "BCTabBar.h"
#import "BCTab.h"
#import "BCTabBarView.h"
#import <UIKit/UITabBar.h>
#import <QuartzCore/QuartzCore.h>
#import "MyTool.h"

@interface BCTabBarController ()

- (void)loadTabs;

@property (nonatomic, retain) UIImageView *selectedTab;
@property (nonatomic, readwrite) BOOL visible;

@end


@implementation BCTabBarController
@synthesize tabBarHeight=mtabBarHeight;
@synthesize bcviewControllers, bctabBar, selectedTab, bcselectedViewController, tabBarView, visible,selectedIndex,showFullZone;
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        if (!bctabBar) {
            bctabBar = [[BCTabBar alloc] initWithFrame:CGRectZero];
        }
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"app_current_tab_index"];
    }
    
    return self;
}

- (void)loadView {
    CGRect appRect = [[UIScreen mainScreen] bounds];
    if ([self isKindOfClass:[UITabBarController class]])
    {
        [super loadView];
    }
    else {
        BCTabBarView* tempView = [[BCTabBarView alloc] initWithFrame:appRect];
        tempView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.tabBarView = tempView;
        self.view = self.tabBarView;
        [tempView release];
    }
}


- (void)tabBar:(BCTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index byBtn:(BOOL)byBtn
{
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"app_current_tab_index"];
	UIViewController *vc = [self.bcviewControllers objectAtIndex:index];
	if (self.bcselectedViewController == vc) {
		if ([self.bcselectedViewController isKindOfClass:[UINavigationController class]]) {
			[(UINavigationController *)self.bcselectedViewController popToRootViewControllerAnimated:YES];
		}
	} else {
		self.selectedIndex = index;
	}
    if ([delegate respondsToSelector:@selector(controller:index:clickedByBtn:)]) {
        [delegate controller:self index:index clickedByBtn:byBtn];
    }
	
}

-(void)dealloc
{
    [bcviewControllers release];
    [bctabBar release];
    [bcselectedViewController release];
    [tabBarView release];
    
    [super dealloc];
}

-(UIViewController*)bcselectedViewController
{
    return bcselectedViewController;
}

-(UIViewController*)rotatebcselectedViewController
{
    if ([bcselectedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nav = (UINavigationController*)bcselectedViewController;
        if ([nav.viewControllers count]==0) {
            return self.moreNavigationController;
        }
    }
    return bcselectedViewController;
}

-(void)setBcselectedViewController:(UIViewController *)abcselectedViewController
{
    [self setSelectedViewController:abcselectedViewController];
}

- (void)setSelectedViewController:(UIViewController *)vc {
    [super setSelectedViewController:vc];
	UIViewController *oldVC = bcselectedViewController;
	if (bcselectedViewController != vc) {
		bcselectedViewController = [vc retain];
        if (self.bcviewControllers && visible) {
			[oldVC viewWillDisappear:NO];
			[bcselectedViewController viewWillAppear:NO];
		}
		self.tabBarView.contentView = vc.view;
        if (self.bcviewControllers && visible) {
			[oldVC viewDidDisappear:NO];
			[bcselectedViewController viewDidAppear:NO];
		}
        
        [oldVC release];
        
        if (self.bctabBar&&[self.bctabBar.tabs count]>0&&self.selectedIndex!=NSNotFound) {
            NSInteger index = self.selectedIndex;
            NSArray* oldTabs = self.bctabBar.tabs;
            
            [self.bctabBar setSelectedTab:[oldTabs objectAtIndex:index] animated:NO];
        }
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    if (self.bcviewControllers)
        [self.bcselectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    if (self.bcviewControllers)
        [self.bcselectedViewController viewDidAppear:animated];
    
	visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
    if (self.bcviewControllers)
        [self.bcselectedViewController viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
    if (![self respondsToSelector:@selector(addChildViewController:)])
        [self.bcselectedViewController viewDidDisappear:animated];
	visible = NO;
}



- (NSUInteger)selectedIndex {
    if (self.bcviewControllers&&self.bcselectedViewController) {
        return [self.bcviewControllers indexOfObject:self.bcselectedViewController];
    }
    else {
        return 0;
    }
}

- (void)setSelectedIndex:(NSUInteger)aSelectedIndex {
	if (self.bcviewControllers.count > aSelectedIndex)
    {
		UIViewController* selCotroller = [self.bcviewControllers objectAtIndex:aSelectedIndex];
        self.bcselectedViewController = selCotroller;
        if ([self isKindOfClass:[UITabBarController class]])
        {
            [super setSelectedIndex:aSelectedIndex];
        }
    }
}

- (void)loadTabs {
	NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:self.bcviewControllers.count];
	for (UIViewController *vc in self.bcviewControllers) {
        if ([vc isKindOfClass:[BCNavigationController class]]) {
            BCNavigationController* nav = (BCNavigationController*)vc;
            BCTab* oneTab = [[BCTab alloc] init];
            oneTab.nameLabel.text = nav.tabBarTitle;
            if (nav.tabBarTitleColor) {
                oneTab.nameLabel.textColor = nav.tabBarTitleColor;
            }
            if (nav.tabBarTitleHighlyColor) {
                oneTab.nameLabel.highlightedTextColor = nav.tabBarTitleHighlyColor;
            }
            oneTab.mainImageView.image = nav.tabBarImage;
            oneTab.mainImageView.highlightedImage = nav.tabBarHighlyImage;
            
            [tabs addObject:oneTab];
            [oneTab release];
        }
	}
	self.bctabBar.tabs = tabs;
    if ([tabs count]>0&&self.selectedIndex!=NSNotFound) {
        NSInteger index = self.selectedIndex;
        NSArray* oldTabs = self.bctabBar.tabs;
        
        [self.bctabBar setSelectedTab:[oldTabs objectAtIndex:index] animated:NO];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(tabBar)]) {
        [(UITabBar*)[self tabBar] setHidden:YES];
        [(UITabBar*)[self tabBar] setUserInteractionEnabled:NO];
    }
    if (!bctabBar) {
        bctabBar = [[BCTabBar alloc] initWithFrame:CGRectZero];
    }
	CGFloat tabBarHeight = 50; // tabbar + arrow
    if (mtabBarHeight>0) {
        tabBarHeight = mtabBarHeight;
    }
    else {
        mtabBarHeight = tabBarHeight;
    }
	self.bctabBar.delegate = self;
    if ([self isKindOfClass:[UITabBarController class]]) {
        if (CGRectEqualToRect(self.bctabBar.frame, CGRectZero)) {
            self.bctabBar.frame = CGRectMake(0, self.view.bounds.size.height - tabBarHeight, self.view.bounds.size.width, tabBarHeight);
        }
        self.bctabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.bctabBar];
        [self.view bringSubviewToFront:self.bctabBar];
    }
    else {
        if (CGRectEqualToRect(self.bctabBar.frame, CGRectZero)) {
            self.bctabBar.frame = CGRectMake(0, self.view.bounds.size.height - tabBarHeight, self.view.bounds.size.width, tabBarHeight);
        }
        self.bctabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    }
	
	self.tabBarView.backgroundColor = [UIColor clearColor];
	self.tabBarView.tabBar = self.bctabBar;
    self.tabBarView.showFullZone = self.showFullZone;
    
    UIViewController *tmp = bcselectedViewController;
	[self loadTabs];
	bcselectedViewController = nil;
    if (tmp) {
        [self setSelectedViewController:tmp];
    }

}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.bctabBar = nil;
	self.selectedTab = nil;
}

-(void)setTabBarHeight:(float)atabBarHeight
{
    mtabBarHeight = atabBarHeight;
    if ([self isKindOfClass:[UITabBarController class]]) {
        self.bctabBar.frame = CGRectMake(0, self.view.bounds.size.height - atabBarHeight, self.view.bounds.size.width, atabBarHeight);
        self.bctabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.bctabBar];
        [self.view bringSubviewToFront:self.bctabBar];
    }
    else {
        self.bctabBar.frame = CGRectMake(0, self.view.bounds.size.height - atabBarHeight, self.view.bounds.size.width, atabBarHeight);
        self.bctabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    }
}

-(void)setTabBarHiden:(BOOL)hiden
{
    UIImage* realBarImage = nil;
    if ([self isKindOfClass:[UITabBarController class]])
    {
        if (hiden) {
            realBarImage = [self getTableImage:self.bctabBar];
        }
    }
    self.bctabBar.hidden = hiden;
    self.bctabBar.userInteractionEnabled = !hiden;
    if (!hiden) {
        
        if ([self isKindOfClass:[UITabBarController class]])
        {
            [self.view bringSubviewToFront:self.bctabBar];
            [(UITabBar*)[self tabBar] setHidden:YES];
            [(UITabBar*)[self tabBar] setUserInteractionEnabled:NO];
        }
    }
    else {
        if ([self isKindOfClass:[UITabBarController class]])
        {
            [[self tabBar] setHidden:NO];
            [[self tabBar] setUserInteractionEnabled:NO];
            UIImageView* coverView = (UIImageView*)[[self tabBar] viewWithTag:33343];
            if (coverView) {
                
            }
            else {
                coverView = [[UIImageView alloc] initWithFrame:[[self tabBar] bounds]];
                coverView.tag = 33343;
                coverView.userInteractionEnabled = YES;
                [[self tabBar] addSubview:coverView];
                [coverView release];
            }
            coverView.image = realBarImage;
            [[self tabBar] bringSubviewToFront:coverView];
            [[[self tabBar] superview] sendSubviewToBack:[self tabBar]];
        }
    }
}

-(UITabBar*)tabBar
{
    if ([self isKindOfClass:[UITabBarController class]])
    {
        return [super tabBar];
    }
    else {
        return nil;
    }
}

-(UIImage*)getTableImage:(UIView*)realView
{	
    [realView sizeToFit];
    CGSize captureSize = realView.bounds.size;
	UIGraphicsBeginImageContextWithOptions(captureSize, NO, [[UIScreen mainScreen] scale]);
    [realView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (void)setViewControllers:(NSArray *)array {
    if ([self isKindOfClass:[UITabBarController class]]) {
        [super setViewControllers:array];
    }
	if (array != bcviewControllers) {
        NSArray* oldviewControllers = bcviewControllers;
		bcviewControllers = [array retain];
        [oldviewControllers release];
		
		if (bcviewControllers != nil) {
			[self loadTabs];
		}
	}
	
	self.selectedIndex = 0;
}

- (void)setViewControllers:(NSArray *)array selectedController:(UIViewController*)controller
{
    [self setViewControllers:array];
    if (array != bcviewControllers) {
        NSArray* oldviewControllers = bcviewControllers;
		bcviewControllers = [array retain];
        [oldviewControllers release];
		
		if (bcviewControllers != nil) {
			[self loadTabs];
		}
	}
    if (controller) {
        NSInteger index = [array indexOfObject:controller];
        if (index>=0) {
            self.selectedIndex = index;
        }
        else
        {
            self.selectedIndex = 0;
        }
    }
    else
    {
        self.selectedIndex = 0;
    }
}

-(void)setShowFullZone:(BOOL)bShowFullZone
{
    showFullZone = bShowFullZone;
    tabBarView.showFullZone = showFullZone;
}

//
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    //return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
	return [[self rotatebcselectedViewController] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return  [[self rotatebcselectedViewController] supportedInterfaceOrientations];
//    return [self.selectedViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    return YES;
}
//

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    UIViewController* controller = [self rotatebcselectedViewController];
	[controller willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[[self rotatebcselectedViewController] willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[[self rotatebcselectedViewController] willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	[[self rotatebcselectedViewController] willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[[self rotatebcselectedViewController] didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end
