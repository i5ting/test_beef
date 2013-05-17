//
//  IndexTableViewCell.m
//  SinaFinance
//
//  Created by sang on 10/28/12.
//
//
#import "ShareData.h"

#import "IndexTableViewCell.h"

@implementation IndexTableViewCell
@synthesize background, titleLabel, detailLabel, sourceLabel, readIcon, line;
@synthesize leftrightMargin;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //        self.frame = CGRectMake(0, 0, 308, 40);
        
        background = [[UIImageView alloc] init];
        background.frame = CGRectMake(0, 0, 320, 44);
//        background.image = [UIImage imageNamed:@"cell_bg"];
        [self addSubview:background];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 300, 25)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:16];
        [self addSubview:titleLabel];
        
        //        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 25, 140, 20)];
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 23, 300, 66 - 25)];
        detailLabel.textColor = [UIColor whiteColor];
        detailLabel.numberOfLines = 2;
        detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
        [self addSubview:detailLabel];
        
        sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 23, 140, 20)];
        sourceLabel.textColor = [UIColor whiteColor];
        sourceLabel.backgroundColor = [UIColor clearColor];
        sourceLabel.font = [UIFont fontWithName:APP_FONT_NAME size:12];
        [self addSubview:sourceLabel];
        
        readIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"news_list_cell_arrow.png"]];
        readIcon.frame = CGRectMake(5, 10, 6, 8);
        [self addSubview:readIcon];
        readIcon.hidden = YES;
        
        UIImage* lineImage = [UIImage imageNamed:@"news_list_cell_back.png"];
        lineImage = [lineImage stretchableImageWithLeftCapWidth:100.0 topCapHeight:18.0];
        line = [[UIImageView alloc] initWithImage:lineImage];
        line.frame = self.bounds;
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:line];
        [self sendSubviewToBack:line];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    [background release];
    [titleLabel release];
    [detailLabel release];
    [sourceLabel release];
    [readIcon release];
    [line release];
    [super dealloc];
}

-(void)setLeftrightMargin:(NSInteger)aLeftrightMargin
{
    leftrightMargin = aLeftrightMargin;
    CGRect readIconRect = readIcon.frame;
    readIconRect.origin.x = leftrightMargin;
    readIcon.frame = readIconRect;
    CGRect titleRect = titleLabel.frame;
    titleRect.origin.x = 10 + leftrightMargin;
    titleRect.size.width = 300 - leftrightMargin*2;
    titleLabel.frame =titleRect;
    CGRect dateRect = detailLabel.frame;
    dateRect.origin.x = 10 + leftrightMargin;
    detailLabel.frame = dateRect;
}

@end