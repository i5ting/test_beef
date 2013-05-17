//
//  BarStockReplyCell.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarStockReplyCell : UITableViewCell
{
    UILabel* levelLabel;
    UILabel* userLabel;
    UILabel* dateLabel;
    UILabel* contentLabel;
    UIWebView* contentWebView;
}

@property(nonatomic,retain)UILabel* levelLabel;
@property(nonatomic,retain)UILabel* userLabel;
@property(nonatomic,retain)UILabel* dateLabel;
@property(nonatomic,retain)UILabel* contentLabel;
-(void)reloadData;

@end
