//
//  Bee_UITopTab.h
//  sinafinance
//
//  Created by sang on 5/9/13.
//
//

#import <UIKit/UIKit.h>


#pragma mark - config

//#define TOP_TAB_ITEM_CHANGE_ANIMATED 1
#define TOP_TAB_ITEM_CHANGE_ANIMATED 0



@interface Bee_UITopTabItem : NSObject

@end
 
@interface Bee_UITopTab : UIView <UIScrollViewDelegate>
{
    UIScrollView  *     _container;
    
    CGFloat                 _itemWidth;
}


AS_SIGNAL(TOP_TAB_ITEM_CHANGE)

/**
 * 背景
 */
@property(nonatomic,retain) UIImageView  *     bgView;


/**
 * 选中背景
 */
@property(nonatomic,retain) UIImageView  *     selectedView;


/**
 * 数据源
 */
@property(nonatomic,retain) NSMutableArray *    source;


- (void)reload;

@end
