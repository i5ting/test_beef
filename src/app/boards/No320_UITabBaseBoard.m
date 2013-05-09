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

#pragma mark - Public

- (void)addTopTabView
{
    _topTabView = [[Bee_UITopTab alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    [self.view addSubview:_topTabView];
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

@end
