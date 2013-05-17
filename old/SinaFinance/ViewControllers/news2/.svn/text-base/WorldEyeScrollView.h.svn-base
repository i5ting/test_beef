//
//  WorldEyeScrollView.h
//  SinaFinance
//
//  Created by sang on 11/12/12.
//
//

#import <UIKit/UIKit.h>
 
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
#import "News2.h"

@protocol WorldEyeOPScrollViewDelegate <NSObject>
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


@class WorldEyeOPScrollTitleView;
@class WorldEyeOPScrollStatusView;
@interface WorldEyeScrollView : UIView<UIScrollViewDelegate>{
    UIScrollView *scrollView;
    int _index;
    WorldEyeOPScrollTitleView *_scrollTitleView;
    WorldEyeOPScrollStatusView *_statusView;
    UIButton *_prevbtn;
    UIButton *_nextbtn;
}

@property(nonatomic,retain,readwrite) NSArray *topnewsArray;
@property(nonatomic,retain,readwrite) id<WorldEyeOPScrollViewDelegate> delegate;

//初始化
- (id)initWithFrame:(CGRect)frame andSource:(NSArray *)source;

//重载
-(void)reloadWith:(NSArray *)topnewsArray;
@end



//--------------------------------------------------private imp-------------------------------------------------//
@class WorldEyeOPScrollStatusView;
@interface WorldEyeOPScrollTitleView : UIView{
    int _index;
}

@property(nonatomic,retain,readwrite) NSArray *topnewsArray;

@property(nonatomic,retain,readwrite) UIImageView *bgImageView;
@property(nonatomic,retain,readwrite) UILabel *titleLable;
@property(nonatomic,retain,readwrite) WorldEyeOPScrollStatusView *statusView;

-(id)initWithFrame:(CGRect)frame andSourceArray:(NSArray *)source andIndex:(int)index;
-(void)setStatusWithIndex:(int)index;

-(void)ReloadWith:(NSArray *)topnewsArray;
@end


@interface WorldEyeOPScrollStatusView : UIView{
    CGRect _frame;
    int _prevIndex;
    
}

-(void)reloadWith:(int)c;

-(id)initWithCount:(int)c andFrame:(CGRect)frame;

-(void)setSelected:(int)index;


@end