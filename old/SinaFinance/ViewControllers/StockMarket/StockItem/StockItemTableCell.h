//
//  StockItemTableCell.h
//  SinaFinance
//
//  Created by Du Dan on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockItemTableCell : UITableViewCell
{
    UILabel *title1;
    UILabel *number1;
    UILabel *title2;
    UILabel *number2;
}

@property (nonatomic, retain) UILabel *title1;
@property (nonatomic, retain) UILabel *number1;
@property (nonatomic, retain) UILabel *title2;
@property (nonatomic, retain) UILabel *number2;

@end
