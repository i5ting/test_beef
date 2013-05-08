//
//  No320TabBoard.h
//  sinafinance
//
//  Created by sang alfred on 5/8/13.
//
//

#import "Bee_UIBoard.h"

#import "CustomerTab.h"
#import "Bee_TabbarItem.h"

#import "Bee_UITabBarBoard.h"


#import "Lesson2Board.h"

@interface No320TabBoard : BeeUITabBarBoard
{
    BeeUIStackGroup *	_mainStackGroup;
//    BeeUITabBar *		_mytabBar;
    NSMutableArray *	_boards;
    
    
    UIView *_contentView;
    Bee_TabbarItem *_customView;
    UIImageView *bgView;
    BOOL _isHide;
    
    NSDictionary *__configDict;
    NSString *__bundleName;
    
    NSMutableArray *__controllerArray;
    
    Lesson2View1 *	_innerView;
}

AS_SINGLETON( No320TabBoard )


- (void)toggleBoard:(NSUInteger)index;



@property (retain, nonatomic)Bee_TabbarItem *customView;
@property (assign, nonatomic)BOOL isHidden;
@property (assign, nonatomic)BOOL logTrace;

@property (retain, nonatomic)NSMutableArray *__controllerArray;

-(id)initWithJSON:(NSString *)json_file_name;
-(id)initWithBundleName:(NSString *)bundle_file_name;

+ (No320TabBoard*)sharedTabBarController;
- (void)selectTab:(int)tabID;
+(BOOL)isHidden;
//获取当前的ViewController
- (UIViewController *)getShowingViewController;

+ (void)hide:(BOOL)bHide animated:(BOOL)bAnimated;

-(void)set_custom_tab_view_delegate:(id)d;



@end
