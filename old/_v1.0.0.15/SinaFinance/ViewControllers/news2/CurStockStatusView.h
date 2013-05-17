//
//  CurStockStatusView.h
//  SinaFinance
//
//  Created by sang on 10/28/12.
//
//

#import <UIKit/UIKit.h>
#import "Util.h"

@interface CurStockStatusView : UIView{
//    NSTimer *_timer;
    int _curIndex;
}

/**
 * 名称cn_name
 */
@property(nonatomic,retain,readwrite) UILabel *l1;
/**
 * 价格price
 */
@property(nonatomic,retain,readwrite) UILabel *l2;
/**
 * diff
 */
@property(nonatomic,retain,readwrite) UILabel *l3;
/**
 * chg
 */
@property(nonatomic,retain,readwrite) UILabel *l4;

/**
 * 构造方法
 */
- (id)initWithFrame:(CGRect)frame;

/**
 * 更新信息
 */
-(void)updateInfo:(NSArray *)re;

@end
