//
//  UdScrollView.h
//  SinaFinance
//
//  Created by sang on 11/2/12.
//
//

#import <UIKit/UIKit.h>

@protocol UdScrollViewDelegate <NSObject>

-(void)onUDScrollViewMoving:(CGFloat)f;

@end

@interface UdScrollView : UIScrollView
{
    CGPoint _prevPoint;
}

@property(assign,nonatomic,readwrite) id udscrolldelage;
@end
