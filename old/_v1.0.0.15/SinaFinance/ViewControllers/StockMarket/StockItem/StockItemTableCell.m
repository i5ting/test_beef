//
//  StockItemTableCell.m
//  SinaFinance
//
//  Created by Du Dan on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StockItemTableCell.h"
#import "ShareData.h"

@implementation StockItemTableCell

@synthesize title1, number1, title2, number2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {        
        title1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 75, 20)];
        title1.backgroundColor = [UIColor clearColor];
        title1.textColor = [UIColor whiteColor];
        title1.textAlignment = UITextAlignmentLeft;
        title1.font = [UIFont fontWithName:APP_FONT_NAME size:14];
        [self addSubview:title1];
        
        number1 = [[UILabel alloc] initWithFrame:CGRectMake(85, 0, 75, 20)];
        number1.backgroundColor = [UIColor clearColor];
        number1.textColor = [UIColor whiteColor];
        number1.textAlignment = UITextAlignmentLeft;
        number1.font = [UIFont fontWithName:APP_FONT_NAME size:14];
        [self addSubview:number1];
        
        title2 = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 75, 20)];
        title2.backgroundColor = [UIColor clearColor];
        title2.textColor = [UIColor whiteColor];
        title2.textAlignment = UITextAlignmentLeft;
        title2.font = [UIFont fontWithName:APP_FONT_NAME size:14];
        [self addSubview:title2];
        
        number2 = [[UILabel alloc] initWithFrame:CGRectMake(235, 0, 75, 20)];
        number2.backgroundColor = [UIColor clearColor];
        number2.textAlignment = UITextAlignmentLeft;
        number2.textColor = [UIColor whiteColor];
        number2.font = [UIFont fontWithName:APP_FONT_NAME size:14];
        [self addSubview:number2];
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
    [title1 release];
    [number1 release];
    [title2 release];
    [number2 release];
    [super dealloc];
}

@end
