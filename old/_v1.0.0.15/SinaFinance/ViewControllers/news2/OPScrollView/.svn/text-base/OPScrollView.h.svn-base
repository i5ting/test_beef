//
//  OPScrollView.h
//  SinaFinance
//
//  Created by sang on 10/25/12.
//
// 依赖 SDWebImage 
// 类层级说明： OPScrollView > OPScrollTitleView > OPScrollStatusView
// 用法参见OPScrollTestView

#import <UIKit/UIKit.h>
#import "UIImage+.h"
#import "UIImageView+WebCache.h"
#import "News2.h"


@protocol OPScrollViewDelegate <NSObject>
@optional
/**
 * 可选
 * 如果有点击事件，可以根据tapcount来区分实现
 *
 * @param curIndex 当前索引
 * @param topNews  当前TopNews对象
 * @param tapCount 点击次数（1次或2次）
 *
 */
-(void)clickWithIndex:(int)curIndex topNews:(TopNews *)topnews  tapCount:(int)tapcount;
@end


@class OPScrollTitleView;

@interface OPScrollView : UIView<UIScrollViewDelegate>{
    UIScrollView *scrollView;
    int _index;
    OPScrollTitleView *_scrollTitleView;
}
@property(nonatomic,retain,readwrite) NSArray *topnewsArray;
@property(nonatomic,retain,readwrite) id<OPScrollViewDelegate> delegate;


//初始化
- (id)initWithFrame:(CGRect)frame andSource:(NSArray *)source;

//重载
-(void)reloadWith:(NSArray *)topnewsArray;
@end


