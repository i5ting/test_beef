//
//  StockTableViewCell.h
//  SinaFinance
//
//  Created by Du Dan on 11/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockTableViewCell : UITableViewCell
{
    UILabel *stockName;
    UILabel *stockID;
}

@property (nonatomic, retain) UILabel *stockName;
@property (nonatomic, retain) UILabel *stockID;

@end
