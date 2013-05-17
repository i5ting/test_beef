//
//  ArticleTitleLabel.m
//  SinaFinance
//
//  Created by fabo on 12-10-18.
//
//

#import "ArticleTitleLabel.h"

@implementation ArticleTitleLabel
@synthesize firstLine;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    [firstLine release];
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.textColor set];
    if (firstLine&&firstLine.length>0) {
        NSString* secondLine = [self.text stringByReplacingOccurrencesOfString:firstLine withString:@""];
        [firstLine drawAtPoint:rect.origin withFont:self.font];
        if (secondLine&&[secondLine length]>0) {
            CGSize oldSize = CGSizeMake(rect.size.width, self.font.pointSize);
            rect.origin.y = rect.origin.y + oldSize.height;
            rect.size.height = rect.size.height - oldSize.height;
            [secondLine drawInRect:rect withFont:self.font lineBreakMode:self.lineBreakMode alignment:self.textAlignment];
        }
    }
    else
    {
        [self.text drawAtPoint:rect.origin withFont:self.font];
    }
}


@end


@implementation ClickURLBtn
@synthesize data;

-(void)dealloc
{
    [data release];
    [super dealloc];
}

@end
