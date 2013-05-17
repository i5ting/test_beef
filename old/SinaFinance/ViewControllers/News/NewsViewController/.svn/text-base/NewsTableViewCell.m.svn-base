//
//  NewsTableViewCell.m
//  SinaFinance
//
//  Created by Du Dan on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "ShareData.h"

@implementation NewsTableViewCell

@synthesize background, titleLabel, dateLabel, sourceLabel, readIcon, line;
@synthesize leftrightMargin;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.frame = CGRectMake(0, 0, 308, 40);
        
        background = [[UIImageView alloc] init];
        background.frame = CGRectMake(0, 0, 320, 44);
        [self addSubview:background];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 290, 25)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:16];
        [self addSubview:titleLabel];
        
//        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 25, 140, 20)];
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 290, 25)];
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont fontWithName:APP_FONT_NAME size:12];
        [self addSubview:dateLabel];
        
        sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 140, 20)];
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
    [dateLabel release];
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
    CGRect dateRect = dateLabel.frame;
    dateRect.origin.x = 10 + leftrightMargin;
    dateLabel.frame = dateRect;
}

@end
