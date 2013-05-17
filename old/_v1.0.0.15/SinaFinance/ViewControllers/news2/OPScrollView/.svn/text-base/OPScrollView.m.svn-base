//
//  OPScrollView.m
//  SinaFinance
//
//  Created by sang on 10/25/12.
//
// 依赖SDWebImage 

#import "OPScrollView.h"




//--------------------------------------------------private imp-------------------------------------------------//
@class OPScrollStatusView;
@interface OPScrollTitleView : UIView{
    int _index;
}

@property(nonatomic,retain,readwrite) NSArray *topnewsArray;

@property(nonatomic,retain,readwrite) UIImageView *bgImageView;
@property(nonatomic,retain,readwrite) UILabel *titleLable;
@property(nonatomic,retain,readwrite) OPScrollStatusView *statusView;

-(id)initWithFrame:(CGRect)frame andSourceArray:(NSArray *)source andIndex:(int)index;
-(void)setStatusWithIndex:(int)index;

-(void)ReloadWith:(NSArray *)topnewsArray;
@end


@interface OPScrollStatusView : UIView{
    CGRect _frame;
    int _prevIndex;
}

-(void)reloadWith:(int)c;

-(id)initWithCount:(int)c andFrame:(CGRect)frame;

-(void)setSelected:(int)index;

@end
//--------------------------------------------------private imp-------------------------------------------------//


@implementation OPScrollView
@synthesize delegate;
@synthesize topnewsArray;

- (id)initWithFrame:(CGRect)frame andSource:(NSArray *)source
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.topnewsArray = [source retain];
        
        [self initUI:frame];
        [self addGesture];
    }
    return self;
}

#pragma mark - public

-(void)reloadWith:(NSArray *)source{
    self.topnewsArray = source;
    scrollView.contentSize = CGSizeMake(320*[self.topnewsArray count] , NEWS_OPSCROLL_VIEW_HIGHT);
    for (UIView *s in scrollView.subviews) {
        if ([s isMemberOfClass:[UIImageView class]]) {
            [s removeFromSuperview];
        }
    }
    
    for (int i=0; i<[self.topnewsArray count]; i++) {
        TopNews *topnews =[self.topnewsArray objectAtIndex:i];
        UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, NEWS_OPSCROLL_VIEW_HIGHT)];
        //NSLog(@"a.image url = %@",topnews.image);
        [imageView setImageWithURL:[NSURL URLWithString:topnews.image] placeholderImage:[UIImage imageNamed:@"loading_small.png"]];
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
        [imageView release];
    }
    
    [_scrollTitleView ReloadWith:self.topnewsArray];
}

#pragma mark - private
-(void)initUI:(CGRect)frame{
    scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.scrollsToTop = NO;
    scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    scrollView.backgroundColor =[UIColor whiteColor];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    scrollView.contentSize = CGSizeMake(320*[self.topnewsArray count] , NEWS_OPSCROLL_VIEW_HIGHT);
    
    _scrollTitleView = [[OPScrollTitleView alloc] initWithFrame:CGRectMake(0, NEWS_OPSCROLL_VIEW_HIGHT-30, 320, 30) andSourceArray:self.topnewsArray andIndex:0];
    
    [self addSubview:scrollView];
    [self addSubview:_scrollTitleView];
    [self reloadWith:self.topnewsArray];
}

-(void)addGesture{
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self addGestureRecognizer:singleRecognizer];
    
    // 双击的 Recognizer
    UITapGestureRecognizer* doubleRecognizer;
    doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandle:)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [self addGestureRecognizer:doubleRecognizer];
    
    // 关键在这一行，如果双击确定偵測失败才會触发单击
    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
    [singleRecognizer release];
    [doubleRecognizer release];
}

#define singleTap_tag 1
#define doubleTap_tag 2

#pragma mark - delegate for UIPanGestureRecognizer
-(void)singleTapHandle:(UIGestureRecognizer *)recognizer{
    [self goto:singleTap_tag];
}

-(void)doubleTapHandle:(UIGestureRecognizer *)recognizer{
    [self goto:doubleTap_tag];
}

/**
 * 目前只是支持jpg和png格式，如果图片地址长度小于4，不处理
 * 其他格式不处理
 */
-(void)goto:(int)c{
    TopNews *topnews =[self.topnewsArray objectAtIndex:_index];
    
    NSRange range = [topnews.image rangeOfString:@".jpg"];
    NSRange range2 = [topnews.image rangeOfString:@".jpeg"];
    NSRange range1 = [topnews.image rangeOfString:@".png"];
    if([topnews.image length]<=4){
        return;
    }

    if (range.location != NSNotFound || range1.location != NSNotFound || range2.location != NSNotFound ){//不包含
        if ([self.delegate respondsToSelector:@selector(clickWithIndex: topNews: tapCount:)]) {
            [self.delegate  clickWithIndex:_index topNews:topnews  tapCount:c];
        }else{
            NSString *s = [NSString stringWithFormat:@"curent_index = %d  and tap=%d",_index,c];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"测试信息" message:s delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
         return;
    }
}

- (void)dealloc
{
    [scrollView release];
    [super dealloc];
}

//滑动结束，即类型切换时更新内容
- (void)scrollViewDidEndDecelerating:(UIScrollView *)mscrollView {
    _index = scrollView.contentOffset.x/320;
    if (_index>=0 && _index < [self.topnewsArray count]) {
        [_scrollTitleView setStatusWithIndex:_index];
    }
    
    //健壮性代码，如果没有缓存，此处会再次缓存的。    
//    UIImageView *curImageView = (UIImageView *)[scrollView.subviews objectAtIndex:_index];
//    TopNews *topnews =[self.topnewsArray objectAtIndex:_index];
//    [curImageView setImageWithURL:[NSURL URLWithString:topnews.image] placeholderImage:[UIImage imageNamed:@"loading_small.png"]];
//    
    NSLog(@"_index=%d",_index);
}

@end


@implementation OPScrollTitleView
@synthesize topnewsArray,bgImageView,titleLable,statusView;

-(void)ReloadWith:(NSArray *)topnewsArray{
    self.topnewsArray = [self.topnewsArray  retain];
    _index = 0;
    
    [statusView reloadWith:[self.topnewsArray count]];
    [self setStatusWithIndex:0];
}
 
//h=130
-(id)initWithFrame:(CGRect)frame andSourceArray:(NSArray *)source andIndex:(int)index{
    if (self = [super initWithFrame:frame]) { 
        self.topnewsArray = source;
        _index = index;
        
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        bgImageView.image = [UIImage imageNamed:@"titleview_bg"];
        [bgImageView setBackgroundColor:[UIColor clearColor]];
        
        titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 30)];
        titleLable.textColor = [UIColor whiteColor];
        [titleLable setBackgroundColor:[UIColor clearColor]];
        
        statusView = [[OPScrollStatusView alloc] initWithCount:[self.topnewsArray count] andFrame:CGRectMake(100, 10, 80, 10)];
        [statusView setBackgroundColor:[UIColor orangeColor]];
        
        [self addSubview:bgImageView];
        [self addSubview:titleLable];
        [self addSubview:statusView];
        
        [self setStatusWithIndex:index];
    }
    return self;
}

-(void)setStatusWithIndex:(int)index{
    //更新标题
    [self updateTitle:index];
    //更新状态
    [statusView setSelected:index];
}

#pragma mark - private
-(void)updateTitle:(int)index{
    TopNews *topnews =[self.topnewsArray objectAtIndex:index];
    [self.titleLable setText:topnews.title];
}

@end


@implementation OPScrollStatusView

-(void)reloadWith:(int)c{
    for (UIView *s in self.subviews) {
        [s removeFromSuperview];
    }
    
    for (int i=0;i<c;i++) {
        UIImageView *a = [[UIImageView alloc] init];
        if (i == 0) {
            a.image = [UIImage imageNamed:@"dot.png"];
        }else{
            a.image = [UIImage imageNamed:@"dot_hight.png"];
        }
        
        a.frame = CGRectMake(310 -(c-i)*15, _frame.origin.y, 10, 10);
        a.tag = 10000+i;
        [self addSubview:a];
        [a release];
    }
    
    [self setSelected:0];
    
    [self setBackgroundColor:[UIColor orangeColor]];
    _prevIndex = 0;
}

-(id)initWithCount:(int)c andFrame:(CGRect)frame{
    
    if (self = [super init]) {
        _frame = frame;
        [self reloadWith:c];
    }
    return self;
}

-(void)setSelected:(int)index{
    
    if (index==_prevIndex) {
        return;
    }
    //设置选中
    UIImageView *a =(UIImageView *)[self viewWithTag:10000+index];
    a.image=[UIImage imageNamed:@"dot.png"];
    
    //取消之前的选中状态
    UIImageView *_prevImageView =(UIImageView *)[self viewWithTag:10000+_prevIndex];
    _prevImageView.image=[UIImage imageNamed:@"dot_hight.png"];
    
    _prevIndex = index;
}

@end