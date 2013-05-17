//
//  StockTableViewCell.m
//  SinaFinance
//
//  Created by Du Dan on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StockTableViewCell.h"

@implementation StockTableViewCell

@synthesize stockName, stockID;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, 320, 44);
        
//        background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"news_cell_bg.png"]] autorelease];
//        background.frame = CGRectMake(0, 0, 308, 44);
//        [self addSubview:background];
        
        UIImageView *line = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"news_line.png"]] autorelease];
        line.frame = CGRectMake(0, 43, 320, 1);
        [self addSubview:line];
        
        stockName = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 139, 44)];
        stockName.backgroundColor = [UIColor clearColor];
        stockName.textColor = [UIColor whiteColor];
        [self addSubview:stockName];
        stockID = [[UILabel alloc] initWithFrame:CGRectMake(139, 0, 139, 44)];
        stockID.backgroundColor = [UIColor clearColor];
        stockID.textColor = [UIColor whiteColor];
        stockID.textAlignment = UITextAlignmentRight;
        [self addSubview:stockID];
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
    [stockName release];
    [stockID release];
    [super dealloc];
}

@end
