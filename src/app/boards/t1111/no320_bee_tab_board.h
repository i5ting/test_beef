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

#import "Bee.h"
#import "Bee_TabbarItem.h"


@interface no320_bee_tab_board : BeeUIBoard
{
    BeeUIStackGroup *	_mainStackGroup;
    BeeUITabBar *		_tabBar;
    NSMutableArray *	_boards;

    UIView *            _contentView;
    Bee_TabbarItem *    _customView;     /*custom Tab View*/
    UIImageView *       bgView;
    BOOL                _isHide;

    NSDictionary *      __configDict;
    NSString *          __bundleName;

    NSMutableArray *    __controllerArray;
}
 
@property (assign, nonatomic)int selectedIndex;

@property (retain, nonatomic)Bee_TabbarItem *customView;
@property (assign, nonatomic)BOOL isHidden;
@property (assign, nonatomic)BOOL logTrace;

@property (retain, nonatomic)NSMutableArray *__controllerArray;

-(id)initWithJSON:(NSString *)json_file_name;
-(id)initWithBundleName:(NSString *)bundle_file_name;

+ (no320_bee_tab_board*)sharedTabBarController;
- (void)selectTab:(int)tabID;
+(BOOL)isHidden;
//获取当前的ViewController
- (UIViewController *)getShowingViewController;

+ (void)hide:(BOOL)bHide animated:(BOOL)bAnimated;

-(void)set_custom_tab_view_delegate:(id)d;


#pragma mark - before

AS_SINGLETON( no320_bee_tab_board )

- (void)toggleBoard:(NSUInteger)index;

@end
