//
//  OPScrollView.m
//  SinaFinance
//
//  Created by sang on 10/25/12.
//
// 依赖SDWebImage

#import "WorldEyeScrollView.h"
#import "UIImage+.h"
#import "UIImageView+WebCache.h"

 



//a和b之间距离
#define a_b_distance 15
//a的半径
#define a_width_div_2 5
#define title_lable_hight 20

@implementation WorldEyeScrollView
@synthesize delegate;
@synthesize topnewsArray;

- (id)initWithFrame:(CGRect)frame andSource:(NSArray *)source
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.topnewsArray = [source retain];
        
        NSMutableArray *reQueryArr = [NSMutableArray array];
        for (TopNews *top in source) {
            if (![top.url hasPrefix:@"http://slide."]) {
                [reQueryArr addObject:top];
            }
        }
        
        self.topnewsArray = reQueryArr;
        
        
        [self initUI:frame];
        [self addGesture];
    }
    return self;
}

#pragma mark - public

-(void)reloadWith:(NSArray *)source{
    
    NSMutableArray *reQueryArr = [NSMutableArray array];
    
    for (TopNews *top in source) {
        if (![top.url hasPrefix:@"http://slide."]) {
            [reQueryArr addObject:top];
        }
    }
    
    self.topnewsArray = reQueryArr;
    
    scrollView.contentSize = CGSizeMake((320-66)*[self.topnewsArray count] , 125);
    
    for (UIView *s in scrollView.subviews) {
        if ([s isMemberOfClass:[UIImageView class]]) {
            [s removeFromSuperview];
        }
    }
    
    for (int i=0; i<[self.topnewsArray count]; i++) {
        TopNews *topnews =[self.topnewsArray objectAtIndex:i];
        int a = i>0?320*i-33*i:33;
        //UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, 320, 135)];
        
        UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake((320-66)*i, 0, 320-66 , 125)];

        //if (onePhoto.widthValue>onePhoto.heightValue) {
           // imageView.contentMode = UIViewContentModeScaleAspectFill;
//        }else{
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
//        }
//        
        NSLog(@"a.image url = %@",topnews.image);
        [imageView setImageWithURL:[NSURL URLWithString:topnews.image]];
        
        imageView.userInteractionEnabled = YES;
        
        [scrollView addSubview:imageView];
        [imageView release];
    }
    
    
    [_scrollTitleView ReloadWith:self.topnewsArray];
}


#pragma mark - private
-(void)initUI:(CGRect)frame{
    
    UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, NEWS_OPSCROLL_VIEW_HIGHT)];
    [imageView setImage:[UIImage imageNamed:@"worldeye.bundle/worldeye_scroll_bg.png"]];
    [self addSubview:imageView];
    [imageView release];
    
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(33, 7.5f, 320-66, 125)];
    scrollView.scrollsToTop = NO;
    scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    scrollView.backgroundColor =[UIColor whiteColor];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    
    
    scrollView.contentSize = CGSizeMake( (320-66)*[self.topnewsArray count] , 125);
    [self addSubview:scrollView];
   
    
    _prevbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _prevbtn.frame = CGRectMake(0, 0, 46, 138);
//    _prevbtn.frame = CGRectMake(11, 53, 35, 50);
//    _prevbtn.backgroundColor = [UIColor orangeColor];
    [_prevbtn setImage:[UIImage imageNamed:@"worldeye.bundle/left_btn_bg.png"] forState:UIControlStateNormal];
    [self addSubview:_prevbtn];
    
    
    _nextbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _nextbtn.frame = CGRectMake(274, 0, 46, 138);
    //_nextbtn.backgroundColor = [UIColor orangeColor];
    
    [_nextbtn setImage:[UIImage imageNamed:@"worldeye.bundle/right_btn_bg.png"] forState:UIControlStateNormal];
    [self addSubview:_nextbtn];

    
    [_nextbtn addTarget:self action:@selector(onRightclick:) forControlEvents:UIControlEventTouchUpInside];
    [_prevbtn addTarget:self action:@selector(onLeftclick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self reloadWith:self.topnewsArray];
    
    _scrollTitleView = [[WorldEyeOPScrollTitleView alloc] initWithFrame:CGRectMake(33, 7.5f+125-title_lable_hight, 320-66, title_lable_hight) andSourceArray:self.topnewsArray andIndex:0];
    [self addSubview:_scrollTitleView];
    
    _statusView = [[WorldEyeOPScrollStatusView alloc] initWithCount:[self.topnewsArray count] andFrame:CGRectMake(0, 145, 320, 10)];
    
    [_statusView setBackgroundColor:[UIColor orangeColor]];
    [self addSubview:_statusView];
    
    _scrollTitleView.statusView = _statusView;
}


-(void)onLeftclick:(UIButton *)sender{
    
    if (_index>=0 && _index < [self.topnewsArray count]) {
        _index--;
        if (_index==-1) {
            _index = [self.topnewsArray count] -1;
        }
        [scrollView setContentOffset:CGPointMake((320-66)*_index, 0) animated:YES];
        [_scrollTitleView setStatusWithIndex:_index];
    }
    
    NSLog(@"_index=%d",_index);
    
}


-(void)onRightclick:(UIButton *)sender{
    
    if (_index>=0 && _index < [self.topnewsArray count]) {
        _index++;
        if (_index == ([self.topnewsArray count]) ) {
            _index = 0;
        }
        [scrollView setContentOffset:CGPointMake((320-66)*_index, 0) animated:YES];
        [_scrollTitleView setStatusWithIndex:_index];
    }
    
    NSLog(@"_index=%d",_index);
    
}

-(void)addGesture{
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHandle:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [scrollView addGestureRecognizer:singleRecognizer];
    
    // 双击的 Recognizer
    UITapGestureRecognizer* doubleRecognizer;
    doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandle:)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [scrollView addGestureRecognizer:doubleRecognizer];
    
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

-(void)goto:(int)c{
  
    if (_index>=0 && _index < [self.topnewsArray count]) {
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
}

- (void)dealloc
{
    [scrollView release];
    [super dealloc];
}

//滑动结束，即类型切换时更新内容
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _index = scrollView.contentOffset.x/(320-66);
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



@implementation WorldEyeOPScrollTitleView
@synthesize topnewsArray,bgImageView,titleLable,statusView;

-(void)ReloadWith:(NSArray *)topnewsArray{
    
    self.topnewsArray = [topnewsArray  retain];
    _index = 0;
    
    
    statusView.center = CGPointMake(160, 20);
    [statusView reloadWith:[topnewsArray count]];
    [self setStatusWithIndex:0];
}

//h=130
-(id)initWithFrame:(CGRect)frame andSourceArray:(NSArray *)source andIndex:(int)index{
    if (self = [super initWithFrame:frame]) {
        //        self.backgroundColor = [UIColor blueColor];
        
        
        self.topnewsArray = source;
        _index = index;
        
        
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320-66, title_lable_hight)];
        bgImageView.image = [UIImage imageNamed:@"worldeye.bundle/titleview_bg"];
        [bgImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bgImageView];
        
        
        titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 320-66, title_lable_hight)];
        titleLable.textColor = [UIColor whiteColor];
        titleLable.font = [UIFont systemFontOfSize:16];
        titleLable.textAlignment = UITextAlignmentCenter;
        [titleLable setBackgroundColor:[UIColor clearColor]];
        [self addSubview:titleLable];
        

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
    NSString *trimmedTitleString = [topnews.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.titleLable setText:trimmedTitleString];
}

@end



@implementation WorldEyeOPScrollStatusView

//add direction

-(void)reloadWith:(int)c{
    for (UIView *s in self.subviews) {
        [s removeFromSuperview];
    }

    int dd = c/2*a_b_distance -a_b_distance/2;
    int left = 0;
 
    for (int i=0;i<c;i++) { 
        UIImageView *a = [[UIImageView alloc] init];
        if (i == 0) {
            a.image = [UIImage imageNamed:@"worldeye.bundle/dot.png"];
        }else{
            a.image = [UIImage imageNamed:@"worldeye.bundle/dot_hight.png"];
        }
        
        if ( c%2==0) {
            left = 160-dd;
            NSLog(@"偶数left+i*30-5=%d",left+i*a_b_distance-a_width_div_2);
            a.frame = CGRectMake(left+i*a_b_distance-a_width_div_2, _frame.origin.y, 10, 10);
        }else{
            left = 160-dd - a_b_distance/2;
            NSLog(@"奇数left+i*30-5=%d",left+i*a_b_distance-a_width_div_2);
            a.frame = CGRectMake(left+i*a_b_distance-a_width_div_2, _frame.origin.y, 10, 10);
        }
        
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
    a.image=[UIImage imageNamed:@"worldeye.bundle/dot.png"];
    
    //取消之前的选中状态
    UIImageView *_prevImageView =(UIImageView *)[self viewWithTag:10000+_prevIndex];
    _prevImageView.image=[UIImage imageNamed:@"worldeye.bundle/dot_hight.png"];
    
    _prevIndex = index;
}


#ifdef WORLD_EYE_SCROLL_DEBUG

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif

#endif


@end