//
//  OPScrollTestView.m
//  SinaFinance
//
//  Created by sang on 12/10/12.
//
//

#import "OPScrollTestView.h"
 
@implementation OPScrollTestView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self){
        
        TopNews *topnews1 = [[TopNews alloc] initWithTid:@""
                                                    category:@""
                                                        type:@""
                                                    category:@""
                                                       order:@""
                                                       ptime:@""
                                                       mtime:@""
                                                         url:@""
                                                     comment:@""
                                                       title:@"title单身"
                                                     content:@"sdf"
                                                   hdcontent:@"sdfsfd"
                                                       image:@"http://i1.sinaimg.cn/cj/pc/2012-10-22/32/U2082P31T32D97069F651DT20121022083152.jpg"] ;


        TopNews *topnews2 = [[TopNews alloc] initWithTid:@""
                                               category:@""
                                                   type:@""
                                               category:@""
                                                  order:@""
                                                  ptime:@""
                                                  mtime:@""
                                                    url:@""
                                                comment:@""
                                                  title:@"title试试"
                                                content:@"sdf"
                                              hdcontent:@"sdfsfd"
                                                  image:@"http://hiphotos.baidu.com/mxdsu919/mpic/item/f5fabfb596153b538ad4b2ff.jpg"] ;

        TopNews *topnews3 = [[TopNews alloc] initWithTid:@""
                                                category:@""
                                                    type:@""
                                                category:@""
                                                   order:@""
                                                   ptime:@""
                                                   mtime:@""
                                                     url:@""
                                                 comment:@""
                                                   title:@"试试第三方速度快"
                                                 content:@"sdf"
                                               hdcontent:@"sdfsfd"
                                                   image:@"http://hiphotos.baidu.com/mxdsu919/mpic/item/f5fabfb596153b538ad4b2ff.jpg"] ;



        NSArray *topnewsArray =[NSArray arrayWithObjects:topnews1,topnews2,topnews3, nil];
        
        _s = [[OPScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, NEWS_OPSCROLL_VIEW_HIGHT) andSource:topnewsArray];
        
        
        [self addSubview:_s];
        
        //        [self performSelector:@selector(ss) withObject:nil afterDelay:2];
        //        [self performSelector:@selector(ss) withObject:nil afterDelay:2];
        //        [self performSelector:@selector(sss) withObject:nil afterDelay:8];
        //        [self performSelector:@selector(ss) withObject:nil afterDelay:15];
        //        [self performSelector:@selector(sss) withObject:nil afterDelay:16];
        
    }
    return self;
}

-(void)reloadWith:(NSArray *)topnewsArray{
    [_s reloadWith:topnewsArray ];
}



-(void)ss{
    return;
    TopNews *topnews2 = [[TopNews alloc] initWithTid:@""
                                            category:@""
                                                type:@""
                                            category:@""
                                               order:@""
                                               ptime:@""
                                               mtime:@""
                                                 url:@""
                                             comment:@""
                                               title:@"title试试"
                                             content:@"sdf"
                                           hdcontent:@"sdfsfd"
                                               image:@"http://hiphotos.baidu.com/mxdsu919/mpic/item/f5fabfb596153b538ad4b2ff.jpg"] ;
    
    TopNews *topnews3 = [[TopNews alloc] initWithTid:@""
                                            category:@""
                                                type:@""
                                            category:@""
                                               order:@""
                                               ptime:@""
                                               mtime:@""
                                                 url:@""
                                             comment:@""
                                               title:@"试试第三方速度快"
                                             content:@"sdf"
                                           hdcontent:@"sdfsfd"
                                               image:@"http://hiphotos.baidu.com/mxdsu919/mpic/item/f5fabfb596153b538ad4b2ff.jpg"] ;
    
    
    
    NSArray *topnewsArray =[NSArray arrayWithObjects:topnews2, nil];
    [self reloadWith:topnewsArray];
}


-(void)sss{
    TopNews *topnews1 = [[TopNews alloc] initWithTid:@""
                                            category:@""
                                                type:@""
                                            category:@""
                                               order:@""
                                               ptime:@""
                                               mtime:@""
                                                 url:@""
                                             comment:@""
                                               title:@"title单身"
                                             content:@"sdf"
                                           hdcontent:@"sdfsfd"
                                               image:@"http://i1.sinaimg.cn/cj/pc/2012-10-22/32/U2082P31T32D97069F651DT20121022083152.jpg"] ;
    
    
    TopNews *topnews2 = [[TopNews alloc] initWithTid:@""
                                            category:@""
                                                type:@""
                                            category:@""
                                               order:@""
                                               ptime:@""
                                               mtime:@""
                                                 url:@""
                                             comment:@""
                                               title:@"title试试"
                                             content:@"sdf"
                                           hdcontent:@"sdfsfd"
                                               image:@"http://hiphotos.baidu.com/mxdsu919/mpic/item/f5fabfb596153b538ad4b2ff.jpg"] ;
    
    TopNews *topnews3 = [[TopNews alloc] initWithTid:@""
                                            category:@""
                                                type:@""
                                            category:@""
                                               order:@""
                                               ptime:@""
                                               mtime:@""
                                                 url:@""
                                             comment:@""
                                               title:@"试试第三方速度快"
                                             content:@"sdf"
                                           hdcontent:@"sdfsfd"
                                               image:@"http://hiphotos.baidu.com/mxdsu919/mpic/item/f5fabfb596153b538ad4b2ff.jpg"] ;
    
    
    
    NSArray *topnewsArray =[NSArray arrayWithObjects:topnews1,topnews2,topnews3, nil];
    [self reloadWith:topnewsArray];
}



@end
