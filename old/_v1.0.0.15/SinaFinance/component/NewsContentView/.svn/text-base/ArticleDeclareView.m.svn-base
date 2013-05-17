//
//  ArticleDeclareView.m
//  SinaNews
//
//  Created by fabo on 12-10-18.
//
//

#import "ArticleDeclareView.h"

@implementation DeclareView
@synthesize declareString;
@synthesize stringBounds;
@synthesize font;
@synthesize fontColor;
@synthesize margin;
@synthesize textAlignment;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage* image = [UIImage imageNamed:@"contentdeclarebakc.png"];
        image = [image stretchableImageWithLeftCapWidth:250.0 topCapHeight:20.0];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        imageView.tag = 111122;
        [self addSubview:imageView];
        [imageView release];
        UILabel* tempLabel = [[UILabel alloc] initWithFrame:self.bounds];
        tempLabel.numberOfLines = 0;
        tempLabel.textAlignment = UITextAlignmentCenter;
        tempLabel.backgroundColor = [UIColor clearColor];
        tempLabel.tag = 1122288;
        [self addSubview:tempLabel];
        [tempLabel release];
    }
    return self;
}

-(void)dealloc
{
    [declareString release];
    [font release];
    [fontColor release];
    [super dealloc];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
}

-(void)setFont:(UIFont *)afont
{
    if (font!=afont) {
        UIFont* oldFont = font;
        font = [afont retain];
        [oldFont release];
    }
    [self reloadData];
}

-(void)setString:(NSString*)string stringRect:(CGRect)bound margin:(NSInteger)amargin font:(UIFont*)afont fontColor:(UIColor*)acolor textAlignment:(UITextAlignment)alignment
{
    self.textAlignment = alignment;
    self.declareString = string;
    self.stringBounds = bound;
    self.margin = amargin;
    self.fontColor = acolor;
    self.font = afont;
    [self reloadData];
}

-(void)reloadData
{
    UILabel* tempLabel = (UILabel*)[self viewWithTag:1122288];
    tempLabel.text = self.declareString;
    tempLabel.textColor = self.fontColor;
    tempLabel.frame = self.stringBounds;
    tempLabel.font = self.font;
    tempLabel.textAlignment = self.textAlignment;
    CGRect bound = self.stringBounds;
    UIImageView* imageView = (UIImageView*)[self viewWithTag:111122];
    if (bound.size.height>=60) {
        UIImage* image = [UIImage imageNamed:@"contentdeclarebakc_big.png"];
        image = [image stretchableImageWithLeftCapWidth:280.0 topCapHeight:55.0];
        imageView.image = image;
    }
    else {
        UIImage* image = [UIImage imageNamed:@"contentdeclarebakc.png"];
        image = [image stretchableImageWithLeftCapWidth:280.0 topCapHeight:25.0];
        imageView.image = image;
    }
    imageView.frame = CGRectMake(margin, 0, self.bounds.size.width-2*margin, self.bounds.size.height);
}

@end