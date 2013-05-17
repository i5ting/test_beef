#import "BCTabBar.h"
#import "BCNavigationController.h"
@class BCTabBarView;

@interface BCTabBarController : UITabBarController <BCTabBarDelegate>
{
    BCTabBar *bctabBar;
    BOOL showFullZone;
    float mtabBarHeight; 
    NSArray *bcviewControllers;
    UIViewController *bcselectedViewController;
}
@property (nonatomic, assign) float tabBarHeight; 
@property (nonatomic, retain) NSArray *bcviewControllers;
@property (nonatomic, retain) BCTabBar *bctabBar;
@property (nonatomic, retain) UIViewController *bcselectedViewController;
@property (nonatomic, retain) BCTabBarView *tabBarView;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, readonly) BOOL visible;
@property (nonatomic, assign) BOOL showFullZone;
@property (nonatomic, assign) id delegate;

-(UIViewController*)rotatebcselectedViewController;
- (void)setViewControllers:(NSArray *)array selectedController:(UIViewController*)controller;
- (void)setViewControllers:(NSArray *)array;
- (void)setSelectedViewController:(UIViewController *)controller;
-(void)setTabBarHiden:(BOOL)hiden;

@end

@protocol BCTabBarController_Delegate <NSObject>

-(void)controller:(BCTabBarController*)controller index:(NSInteger)index clickedByBtn:(BOOL)byBtn;

@end
