//
//  UdScrollView.m
//  SinaFinance
//
//  Created by sang on 11/2/12.
//
//

#import "UdScrollView.h"

@implementation UdScrollView
@synthesize udscrolldelage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(!self.dragging)
        
    {
        
        [[self nextResponder] touchesBegan:touches withEvent:event];
        
    }
    
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    _prevPoint = [touch  locationInView:self];
 
    NSLog(@"MyScrollView touch Began");
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event

{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch  locationInView:self];
    NSLog(@"%f",point.y - _prevPoint.y );
 
//    if (s.origin.y >0 && s.origin.y<40) {
    
        [self.udscrolldelage onUDScrollViewMoving:point.y - _prevPoint.y];
//    }
}




- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    if(!self.dragging)
        
    {
        
        [[self nextResponder] touchesEnded:touches withEvent:event];
        
    }
    
    [super touchesEnded:touches withEvent:event];
    
}


@end
